require "spec_helper"

describe "LinePoint" do
  it "can measure the distance between two lines" do
    p1 = Point.new(1, 2)
    p2 = Point.new(4, 6)
    line = p1.join(p2)
    expect(line.distance).to eq(5)
  end
end
