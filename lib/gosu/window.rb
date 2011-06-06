module Gosu
  
  class Window

    def draw_quad2(x, y, r, color, z = 0)
      draw_quad(x - r, y + r, color, x + r, y + r, color, x + r, y - r, color, x - r, y - r, color, z)
    end

  end

end