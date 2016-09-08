require 'rails_helper'

describe Game do
  it "has a valid factory" do
    expect(create(:game)).to be_valid
  end
end
