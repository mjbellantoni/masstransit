require "spec_helper"
require "lib/gosu/numeric"


describe "Numeric.world_to_gosu" do

  it "(0, 0) -> (640, 400)" do
    x, y = Numeric.world_to_gosu(0, 0, 3)
    x.should be_within(0.001).of(640)
    y.should be_within(0.001).of(400)
  end

  it "(3, 0) -> (641, 400)" do
    x, y = Numeric.world_to_gosu(3, 0, 3)
    x.should be_within(0.001).of(641)
    y.should be_within(0.001).of(400)
  end
 
  it "(-3, 0) -> (639, 400)" do
    x, y = Numeric.world_to_gosu(-3, 0, 3)
    x.should be_within(0.001).of(639)
    y.should be_within(0.001).of(400)
  end

  it "(0, 3) -> (640, 399)" do
    x, y = Numeric.world_to_gosu(0, 3, 3)
    x.should be_within(0.001).of(640)
    y.should be_within(0.001).of(399)
  end

  it "(0, -3) -> (640, 401)" do
    x, y = Numeric.world_to_gosu(0, -3, 3)
    x.should be_within(0.001).of(640)
    y.should be_within(0.001).of(401)
  end

end


describe "Numeric.geokit_angle_to_math_angle" do

  it "0 -> 90" do
    Numeric.geokit_angle_to_math_angle(0).should be_within(0.001).of(90)
  end

  it "45 -> 45" do
    Numeric.geokit_angle_to_math_angle(45).should be_within(0.001).of(45)
  end

  it "90 -> 0" do
    Numeric.geokit_angle_to_math_angle(90).should be_within(0.001).of(0)
  end

  it "180 -> 270" do
    Numeric.geokit_angle_to_math_angle(180).should be_within(0.001).of(270)
  end
  
  it "270 -> 180" do
    Numeric.geokit_angle_to_math_angle(270).should be_within(0.001).of(180)
  end



  it "-45 -> 135" do
    Numeric.geokit_angle_to_math_angle(-45).should be_within(0.001).of(135)
  end

  it "-90 -> 180" do
    Numeric.geokit_angle_to_math_angle(-90).should be_within(0.001).of(180)
  end

  it "-180 -> 270" do
    Numeric.geokit_angle_to_math_angle(-180).should be_within(0.001).of(270)
  end

  it "-270 -> 0" do
    Numeric.geokit_angle_to_math_angle(-270).should be_within(0.001).of(0)
  end

end