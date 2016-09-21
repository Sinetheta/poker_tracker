namespace :pizza do
  desc "Generate pizza options YAML"
  task generate_pizza_options: :environment do
    products = Product.all()
    products.each do |product|
      product.generate_options
      File.open("orders/#{product.name}.yaml", "w") do |file|
        file.write({product.name => product.options}.to_yaml)
      end
    end
  end
end
