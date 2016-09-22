class PizzaDataGenerator

  require 'url_helpers.rb'

  def initialize(page)
    @page = page
    @categories = {:classic => 124566, :premium => 124586,
                  :salads => 124591, :mini_meals => 124581,
                  :donairs => 124571, :sides => 124596, :drinks => 124576}
    create_categories_and_products if page.categories.empty?
  end

  def create_categories_and_products
    @categories.each do |name, mnuid_it|
      Category.create(name: name) do |category|
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

  def options_for_product(product)
    product_page = get_vcr_page("product_#{product.iid_it}", product.url)
    form = product_page.form('crtitmfrm')
    options = {radios: {}, checkboxes: {}, text_fields: []}
    form.checkboxes.each do |checkbox|
      options[:checkboxes][checkbox.name] = [] unless options[:checkboxes][checkbox.name]
      options[:checkboxes][checkbox.name] << checkbox.text
    end
    form.fields.select {|f| f.type != "hidden"}.each do |field|
      options[:text_fields] << field.name
    end
    form.radiobuttons.each do |radio|
      options[:radios][radio.name] = [] unless options[:radios][radio.name]
      options[:radios][radio.name] << radio.text
    end
    options
  end

end
