require 'image_processing/mini_magick'
require 'mini_magick'

MiniMagick.cli = :graphicsmagick

class CompressJob
  include Sidekiq::Job
  sidekiq_options retry: 0
  sidekiq_options expires_in: 10.minutes

  def perform(args)
    image = Image.find_by(id: args['image_id'])
    file = MiniMagick::Image.open(args['image_url'])

    processed = compress_image(file)
    url = upload_image(processed)
    image.update(status: :compressed, download_url: url)
    send_compressed_email(image)
  rescue MiniMagick::Invalid
    send_error_email(image)
    image.update(status: :failed)
  end

  private

  def compress_image(file)
    ImageProcessing::MiniMagick
      .source(file)
      .resize_to_limit(400, 400)
      .strip
      .call
  end

  def upload_image(image)
    ::UploadFileToS3Service.call(image, filename: File.basename(image.path))
  end

  def send_compressed_email(image)
    DownloadMailer
      .with(download_url: image.download_url, user_email: image.user.email)
      .new_download_email
      .deliver_later
  end

  def send_error_email(image)
    DownloadMailer
      .with(user_email: image.user.email)
      .new_error_email
      .deliver_later
  end
end
