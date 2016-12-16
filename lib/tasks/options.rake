namespace :pizza do
  desc "Generate pizza options YAML"
  task generate_options_yaml: :environment do
    products = Product.all()
    products.each do |product|
      product.generate_options
      File.open("orders/#{product.name}.yaml", "w") do |file|
        file.write({product.name => product.options}.to_yaml)
      end
    end
  end
  desc "Generate pizza options in database"
  task generate_options: :environment do
    Product.all.each {|product| product.generate_options}
  end
end
