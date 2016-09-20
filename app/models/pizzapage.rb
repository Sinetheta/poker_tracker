class Pizzapage < ActiveRecord::Base

  has_many :categories

  validates :webpage_path, :menu_path, :item_path, :checkout_path, presence: true

  def url_from_attributes(base_url, path, **attributes)
    url = base_url + path + "?"
    attributes.each do |attribute, value|
      url << "&" unless url[-1] == "?"
      url << attribute.to_s + "=" + value.to_s
    end
    url
  end

end
