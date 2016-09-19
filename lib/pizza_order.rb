#!/usr/bin/env ruby

require 'mechanize'
require 'pry'

class Pizza

  attr_reader :website
  attr_reader :classic
  attr_reader :premium

  def initialize
    @website = ""
    @classic = url_from_attributes(@website, :mnuid_it => 124566)
    @premium = url_from_attributes(@website, :mnuid_it => 124586)
    @salads = url_from_attributes(@website, :mnuid_it => 124591)
    @mini_meals = url_from_attributes(@website, :mnuid_it => 124581)
    @donairs = url_from_attributes(@website, :mnuid_it => 124571)
    @sides = url_from_attributes(@website, :mnuid_it => 124596)
    @drinks = url_from_attributes(@website, :mnuid_it => 124576)
    @mech = Mechanize.new
  end

  def url_from_attributes(base_url, **attributes)
    url = base_url + "?"
    attributes.each do |attribute, value|
      url << "&" unless url[-1] == "?"
      url << attribute.to_s + "=" + value.to_s
    end
    url
  end

  def list_pizzas
    pizzas = []
    @mech.get(@classic) do |page|
      pizzas += page.links_with(:class => "menudetails_item_name_link").select { |link| !link.text.empty? }
    end
    @mech.get(@premium) do |page|
      pizzas += page.links_with(:class => "menudetails_item_name_link").select { |link| !link.text.empty? }
    end
    pizzas
  end

end
