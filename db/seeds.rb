require "factory_girl"

include FactoryGirl::Syntax::Methods

50.times { create(:game) }
