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
      AgingItem.build(item).depreciate
    end
  end
end

class AgingItem
  attr_reader :item

  def self.build(item)
    if item.name == "Backstage passes to a TAFKAL80ETC concert"
      BackstagePass.new(item)
    elsif item.name == "Aged Brie" 
      AgedBrie.new(item)
    elsif item.name == "Sulfuras, Hand of Ragnaros"
      Sulfuras.new(item)
    else
      AgingItem.new(item)
    end
  end
  
  def initialize(item)
    @item = item
  end

  def depreciate
    age
    return if worthless?
    item.sell_in < 0 ? decrease_quality(2) : decrease_quality(1)
  end

  private

  def worthless?
    item.quality == 0  
  end

  def age
    item.sell_in -= 1
  end

  def decrease_quality(amount)
    item.quality -= amount
  end

  def increase_quality(amount = 1)
    item.quality += amount
  end
end

class BackstagePass < AgingItem 
  def depreciate
    age
    if item.sell_in < 0
      void_worth 
    elsif item.sell_in < 6
      increase_quality(3)
    elsif item.sell_in < 10
      increase_quality(2)
    else 
      increase_quality(1)
    end
  end

  private

  def void_worth
    item.quality = 0
  end
end

class AgedBrie < AgingItem
  def depreciate
    age
    increase_quality unless perfected?
  end

  private

  def perfected?
    item.quality >= 50
  end
end

class Sulfuras < AgingItem
  def depreciate
    # No op
  end
end
