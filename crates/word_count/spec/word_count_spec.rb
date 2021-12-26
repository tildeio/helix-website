require "spec_helper"

describe "WordCount" do
  it "can count words" do
    path = File.expand_path("../../../../public/shakespeare-plays.csv", __FILE__)
    expect(WordCount.search(path, "thee")).to eq(3034)
    expect(WordCount.ruby_search(path, "thee")).to eq(3034)
  end

  it "can count words next to quotes" do
    path = File.expand_path("fixtures/thee-by-quotes.csv", File.dirname(__FILE__))
    expect(WordCount.search(path, "thee")).to eq(2)
    expect(WordCount.ruby_search(path, "thee")).to eq(2)
  end
end
