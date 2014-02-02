require File.expand_path("../gilded_rose", __FILE__)
require "rspec"

describe GildedRose do

  subject { GildedRose.new }

  def build_item(name, sell_in, quality)
    Item.new(name, sell_in, quality).tap do |item|
      subject.stub(items: [item])
    end
  end

  describe "#update_quality" do
    let!(:item) { build_item("Thing", 5, 5) }

    before { subject.update_quality }

    it "ages an item by 1" do
      expect(item.sell_in).to equal 4
    end

    it "reduces the quality of an item by 1" do
      expect(item.quality).to equal 4
    end

    context "an item with 0 quality" do
      let!(:item) { build_item("Thing", 5, 0) }

      it "does not reduce quality below 0" do
        expect(item.quality).to equal 0
      end
    end

    context 'when sell_in has dropped below zero' do
      let!(:item) { build_item("Thing", 0, 5) }

      it "decreases the item's quality twice as fast" do
        expect(item.quality).to equal 3
      end
    end

    context "Aged Brie" do
      let!(:item) { build_item("Aged Brie", 5, 5) }

      it "ages" do
        expect(item.sell_in).to equal(4)
      end

      it "increases quality by 1 as it ages" do
        expect(item.quality).to equal(6)
      end

      context "when the quality is 50" do
        let!(:item) { build_item("Aged Brie", 5, 50) }

        it "does not increase the quality beyond 50" do
          expect(item.quality).to equal(50)
        end
      end
    end

    context "Sulfuras" do
      let!(:item) { build_item("Sulfuras, Hand of Ragnaros", 5, 5) }

      it "never ages" do
        expect(item.sell_in).to eq 5
      end

      it "never changes in quality" do
        expect(item.quality).to eq 5
      end
    end

    context "Backstage Passes" do
      context "when the sell_in drops below 0" do
        let!(:item) { build_item("Backstage passes to a TAFKAL80ETC concert", 0, 5) }

        it "drops the item's quality to 0" do
          expect(item.quality).to equal 0
        end
      end

      context "when the sell_in is 5 days or fewer" do
        let!(:item) { build_item("Backstage passes to a TAFKAL80ETC concert", 5, 5) }

        it "increases the item's quality by 3" do
          expect(item.quality).to equal 8
        end
      end

      context "when the sell_in is 10 days or fewer" do
        let!(:item) { build_item("Backstage passes to a TAFKAL80ETC concert", 10, 5) }

        it "increases the item's quality by 2" do
          expect(item.quality).to equal 7
        end
      end

      context "when the sell_in is greater than 10 days" do
        let!(:item) { build_item("Backstage passes to a TAFKAL80ETC concert", 11, 5) }

        it "increases the item's quality by 1" do
          expect(item.quality).to equal 6
        end
      end
    end
  end
end