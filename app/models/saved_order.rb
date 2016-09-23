class SavedOrder < ActiveRecord::Base

  belongs_to :user

  serialize :order, Array

end
