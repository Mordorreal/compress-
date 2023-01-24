require 'rails_helper'

RSpec.describe CompressJob, type: :job do
  # need to use factories here but to save time I use this
  let(:user) { User.create!(email: Faker::Internet.unique.email) }
  let(:image_downdload_url) { Faker::Internet.url }
  let(:image) { Image.create!(user_id: user.id) }
  let(:params) { { image_id: image.id, image_url: Faker::Internet.url } }

  before do
    mail_job =
      instance_double(
        ActionMailer::Parameterized::MessageDelivery,
        deliver_later: nil,
      )
    mailer =
      instance_double(
        DownloadMailer,
        new_download_email: mail_job,
        new_error_email: mail_job,
      )

    allow(MiniMagick::Image).to receive(:open).and_return(Tempfile.new)
    allow(UploadFileToS3Service).to receive(:call).and_return(
      image_downdload_url,
    )
    # need to disable this cop because we need to mock library incide of private method
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(described_class).to receive(
      :compress_image,
    ).and_return(Tempfile.new)
    # rubocop:enable RSpec/AnyInstance
    allow(DownloadMailer).to receive(:with).and_return(mailer)
  end

  it { is_expected.to be_retryable 0 }
  it { is_expected.to be_expired_in 10.minutes }

  it 'pass MiniMagick::Image image to download' do
    described_class.perform_async(params.stringify_keys)

    expect(MiniMagick::Image).to have_received(:open).with(params[:image_url])
  end

  it 'update image status to compressed if image valid' do
    described_class.perform_async(params.stringify_keys)

    expect(image.reload.status).to eq('compressed')
  end

  it 'update image status to faile if image not valid' do
    allow(MiniMagick::Image).to receive(:open).and_raise(MiniMagick::Invalid)

    described_class.perform_async(params.stringify_keys)

    expect(image.reload.status).to eq('failed')
  end

  it 'sends email to user with download url' do
    described_class.perform_async(params.stringify_keys)

    expect(DownloadMailer).to have_received(:with).with(
      download_url: image_downdload_url,
      user_email: user.email,
    )
  end
end
