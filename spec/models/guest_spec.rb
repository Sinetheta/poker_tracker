require 'rails_helper'

describe Guest do
  it "has a valid factory" do
    expect(create(:guest)).to be_valid
  end
  it "is invalid without a name" do
		expect(build(:guest, :name => nil)).not_to be_valid
	end
	it "does not allow duplicate names" do
		create(:guest, :name => "Bob")
		expect(build(:guest, :name => "Bob")).not_to be_valid
	end
end
