class PizzaDataGenerator

  require 'url_helpers.rb'

  def initialize(page)
    @page = page
    @categories = {:classic => 124566, :premium => 124586,
                   :salads => 124591, :mini_meals => 124581,
                   :donairs => 124571, :sides => 124596, :drinks => 124576}
  end

  def create_categories
    @categories.each do |name, mnuid_it|
      Category.find_or_create_by(name: name) do |category|
        category.mnuid_it = mnuid_it
        category.pizzapage_id = @page.id
      end
    end
    @categories = Category.all
    @categories.each do |category|
      category_page = get_vcr_page("category_#{category.mnuid_it}", category.url)
      category_page.links_with(:class => "menudetails_item_name_link").select { |link| !link.text.empty?  }.each do |product|
        Product.find_or_create_by(name: product.text) do |p|
          p.iid_it = product.href[/\d{7}/]
          p.category_id = category.id
        end
      end
    end
  end

end
