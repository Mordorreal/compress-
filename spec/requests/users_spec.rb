require 'rails_helper'

RSpec.describe '/users' do
  let(:valid_attributes) { { email: 'test@test.com' } }

  let(:invalid_attributes) { { email: '' } }

  describe 'GET /index' do
    it 'renders a successful response' do
      User.create! valid_attributes

      get users_url, as: :json

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      user = User.create! valid_attributes

      get user_url(user), as: :json

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect {
          post users_url, params: { user: valid_attributes }, as: :json
        }.to change(User, :count).by(1)
      end

      it 'returns the created user' do
        post users_url, params: { user: valid_attributes }, as: :json

        user = User.find_by(email: valid_attributes[:email])

        expect(response.body).to include(
          { user: { id: user.id, email: user.email } }.to_json,
        )
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect {
          post users_url, params: { user: invalid_attributes }, as: :json
        }.not_to change(User, :count)
      end

      it 'renders a response with 422 status if validation failed' do
        post users_url, params: { user: invalid_attributes }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders an error response with message if email already taken' do
        User.create! valid_attributes

        post users_url, params: { user: valid_attributes }, as: :json

        expect(response.body).to include(
          { error_message: 'Email has already been taken' }.to_json,
        )
      end
    end
  end
end
