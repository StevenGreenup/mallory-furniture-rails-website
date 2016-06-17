class ProductsController < ApplicationController
require 'csv'

  class Product
  attr_accessor :item, :price, :description, :img_file, :condition, :dimension_w, :dimension_l, :dimension_h, :quantity, :category, :price_correction

    def initialize(item, price, description, condition, img_file, dimension_w, dimension_l, dimension_h, quantity, category)
      @item = item
      @price = price
      @description = description
      @condition = condition
      @img_file = img_file
      @dimension_w = dimension_w
      @dimension_l = dimension_l
      @dimension_h = dimension_h
      @quantity = quantity
      @category = category
    end

    def price

      if @condition == "good"
        "#{((@price)*0.9)} Clearanced Price! 10% off!"
      elsif @condition == "average"
        "#{((@price)*0.8)} Clearanced Price! 20% off!"
      else
        @price
      end
    end
  end


  def list
    @products = fetch_data
  end

  def detail
    @products = fetch_data
    @product = @products.find {|p| p.item.parameterize == params[:id]}
    render_404 if @product.nil?

  end



  def fetch_data
    products_list = []
    CSV.foreach("#{Rails.root}/mf_inventory.csv", headers: true) do |row|
      the_hash = row.to_hash
      quantity = the_hash['quantity'].to_i
      dimension_w = the_hash['dimension_w']
      dimension_l = the_hash['dimension_l']
      dimension_h = the_hash['dimension_h']
      item    = the_hash['item']
      price     = the_hash['price'].to_f
      description    = the_hash['description']
      condition    = the_hash['condition']
      img_file = the_hash['img_file']
      category = the_hash['category']
      product  = Product.new(item, price, description, condition, img_file, dimension_w, dimension_l, dimension_h, quantity, category)
      products_list << product
    end
    #filters out the products that have less than 1 item
    return products_list.select do |a|
      a.quantity > 0
    end

  end


  def fetch_by_category(category)
    fetch_data.select do |product|
      product.category == category
    end
  end

  def tables
     @products = fetch_by_category "tables"
  end

  def seating
  @products = fetch_by_category "seating"
  end

  def bedroom
  @products = fetch_by_category "bedroom"
    end

  def storage
  @products = fetch_by_category "storage"
    end

  def desks
  @products = fetch_by_category "desks"
    end

  def miscellaneous
  @products = fetch_by_category "miscellaneous"
end
end
