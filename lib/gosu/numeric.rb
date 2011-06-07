class Numeric

  SCALE = 10.0

  def self.world_to_gosu(x, y)
    [x / SCALE, ((SCALE * 800.0) - y) / SCALE]
  end
  
end