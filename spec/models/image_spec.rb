require 'rails_helper'

RSpec.describe Image do
  it 'is valid with valid attributes' do
    user = User.create!(email: Faker::Internet.unique.email)

    expect(
      described_class.new(
        status: described_class.statuses.values.sample,
        download_url: Faker::Internet.url,
        user:,
      ),
    ).to be_valid
  end
end
