class PizzaDataGenerator

  def initialize(page)
    @page = page
    @categories = {:classic => 124566, :premium => 124586,
                   :salads => 124591, :mini_meals => 124581,
                   :donairs => 124571, :sides => 124596, :drinks => 124576}
  end

  def make_categories
    @categories.each do |name, mnuid_it|
      Category.find_or_create_by(name: name) do |category|
        category.mnuid_it = mnuid_it
        category.pizzapage_id = @page.id
      end
    end
    @categories = Category.all
  end

  def make_products

  end

end
