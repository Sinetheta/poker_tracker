require 'rails_helper'

describe Game do
  it "has a valid factory" do
    expect(create(:game)).to be_valid
  end
  it "has a name" do
    expect(create(:game).name).not_to be_nil
  end
  it "has some players" do
    expect(create(:game).players.length).to be >= 2
  end
end
