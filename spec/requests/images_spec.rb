require 'rails_helper'

RSpec.describe '/images' do
  let(:valid_attributes) do
    { user_id: User.create!(email: Faker::Internet.unique.email).id }
  end

  let(:invalid_attributes) { {} }

  describe 'GET /index' do
    it 'renders a successful response' do
      Image.create! valid_attributes

      get images_url, as: :json

      expect(response).to be_successful
    end
  end
end
