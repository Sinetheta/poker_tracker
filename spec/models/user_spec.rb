require 'spec_helper'

describe User do
  it "has a valid factory" do
    expect(create(:user)).to be_valid
  end
  it "is invalid without a name" do
    expect(build(:user, :name => nil)).not_to be_valid
  end
  it "does not allow duplicate names" do
    create(:user, :name => "Bob")
    expect(build(:user, :name => "Bob")).not_to be_valid
  end
end
