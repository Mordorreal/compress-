require 'securerandom'
require 'rack/mime'

class UploadFileToS3Service
  class << self
    def call(file, filename: nil)
      filename_with_extension = filename || generate_filename(file)
      obj = aws_object(filename_with_extension)
      obj.upload_file(file.path, acl: 'public-read')

      obj.public_url
    rescue Aws::Errors::ServiceError => e
      Rails.logger.error(
        "Couldn't upload file #{filename} to #{AWSS3::BUCKET_NAME}.",
      )
      Rails.logger.error("\t#{e.code}: #{e.message}")
      raise
    end

    private

    def generate_filename(file)
      "#{SecureRandom.uuid}#{Rack::Mime::MIME_TYPES.invert[file.content_type]}"
    end

    def aws_object(filename)
      AWSS3::S3_RESOURCE.bucket(AWSS3::BUCKET_NAME).object(filename)
    end
  end
end
