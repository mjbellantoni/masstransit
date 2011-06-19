class Numeric

  SCALE = 8.0
  GOSU_HEIGHT = 800.0
  GOSU_WIDTH  = 1280.0

  def self.world_to_gosu(x, y, scale = SCALE)
    [
      (x / scale) + (GOSU_WIDTH / 2), 
      ((-y / scale) + (GOSU_HEIGHT / 2))
    ]
  end

  def self.geokit_angle_to_math_angle(theta)
    (360 - theta + 90) % 360
  end

  def self.geokit_angle_to_math_angle2(theta)
    geokit_angle_to_math_angle
  end

end