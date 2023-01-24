require 'rails_helper'

RSpec.describe '/images' do
  let(:user) { User.create!(email: Faker::Internet.unique.email) }
  let(:valid_attributes) { { user_id: user.id } }
  let(:invalid_attributes) { {} }
  let(:image) do
    Image.create!(
      status: :compressed,
      download_url: Faker::Internet.url,
      **valid_attributes,
    )
  end
  let(:file) { instance_double(File) }

  describe 'GET /index' do
    it 'renders a successful response' do
      get images_url, as: :json

      expect(response).to be_successful
    end
  end

  describe 'GET /download' do
    it 'renders a successful response' do
      get download_image_url(image.id), as: :json

      expect(response).to be_successful
    end
  end

  describe 'POST /compress' do
    before do
      allow(UploadFileToS3Service).to receive(:call).and_return(
        'https://example.com/image.jpg',
      )
      allow(CompressJob).to receive(:perform_async).and_return(true)
    end

    it 'renders a successful response' do
      headers = { 'Content-Type' => 'multipart/form-data' }
      params = { image: { user_id: user.id, file: } }

      post(compress_images_url, params:, headers:)

      expect(response).to be_successful
    end
  end
end
