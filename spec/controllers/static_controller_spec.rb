require 'rails_helper'

RSpec.describe StaticController, type: :controller do

  describe "GET #pizza" do
    it "returns http success" do
      get :pizza
      expect(response).to have_http_status(:success)
    end
  end

end
