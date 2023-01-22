require 'rails_helper'

RSpec.describe User do
  it 'is valid with valid attributes' do
    expect(described_class.new(email: 'test@test.com')).to be_valid
  end

  it 'is not valid without an email' do
    expect(described_class.new).not_to be_valid
  end

  it 'is not valid with an invalid email' do
    expect(described_class.new(email: 'test')).not_to be_valid
  end

  it 'is not valid with a duplicate email' do
    described_class.create(email: 'test@test.com')

    expect(described_class.create(email: 'test@test.com')).not_to be_valid
  end
end
