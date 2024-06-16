require 'rails_helper'

RSpec.describe User, type: :model do
  it 'creates a new user with valid attributes' do
    user = FactoryBot.create(:user)
    expect(user).to be_valid
  end

  it 'requires an email' do
    user = FactoryBot.build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it 'requires a unique email' do
    FactoryBot.create(:user, email: 'test@example.com')
    user = FactoryBot.build(:user, email: 'test@example.com')
    expect(user).not_to be_valid
  end
end
