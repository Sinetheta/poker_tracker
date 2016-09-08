require 'rails_helper'

describe Player do
  it "has a valid factory" do
    expect(create(:player)).to be_valid
  end
end
