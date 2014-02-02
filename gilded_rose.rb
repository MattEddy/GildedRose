require './item.rb'

class GildedRose

  attr_reader :items

  @items = []

  def initialize
    @items = []
    @items << Item.new("+5 Dexterity Vest", 10, 20)
    @items << Item.new("Aged Brie", 2, 0)
    @items << Item.new("Elixir of the Mongoose", 5, 7)
    @items << Item.new("Sulfuras, Hand of Ragnaros", 0, 80)
    @items << Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)
    @items << Item.new("Conjured Mana Cake", 3, 6)
  end

  def update_quality  
    items.each do |item|
      item.sell_in -= 1 

      if item.name == "Backstage passes to a TAFKAL80ETC concert"
        if item.sell_in < 0 
          item.quality = 0
        elsif item.sell_in < 6
          item.quality += 3
        elsif item.sell_in < 10
            item.quality += 2
        else 
            item.quality += 1
        end


      elsif item.name == "Aged Brie" 
        item.quality += 1 unless item.quality >= 50
      elsif item.name == "Sulfuras, Hand of Ragnaros"
        item.sell_in += 1
      else
        if item.sell_in < 0 
          item.quality -= 2 unless item.quality == 0  
        else 
          item.quality -= 1 unless item.quality == 0  
        end
      end
    end
  end
end

class Depreciator
  attr_accessor :item
  
  def intialize item
    @item = item
  end

end