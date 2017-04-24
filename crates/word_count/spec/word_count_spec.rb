require "spec_helper"

describe "WordCount" do
  it "can count words" do
    path = File.expand_path("../../../../public/shakespeare-plays.csv", __FILE__)
    expect(WordCount.search(path, "thee")).to eq(3034)
    expect(WordCount.ruby_search(path, "thee")).to eq(3034)
  end
end
