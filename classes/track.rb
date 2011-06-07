require "chingu"
require "texplay"

class OffTheRailsException < RuntimeError
end


class Track  < Chingu::BasicGameObject

  class Terminal

    attr_accessor :trolley, :x, :y

    def initialize(x, y)
      super
      @x, @y = x, y
      @trolley = nil
    end

    def carry(trolley)
      @trolley = trolley
      trolley.locate_at(@x, @y)
    end

    def connected?
      false
    end

  end

  trait :sprite

  def initialize(a_x, a_y, b_x, b_y)
    @terminal_a = Terminal.new(a_x, a_y)
    @terminal_b = Terminal.new(b_x, b_y)
  end

  def t_a
    @terminal_a
  end

  def t_b
    @terminal_b
  end
  
  def length
    Gosu::distance(t_a.x, t_a.y, t_b.x, t_b.y)
  end

  def trolley
    t_a.trolley || t_b.trolley
  end

  def moving_a_to_b?
    not t_a.trolley.nil?
  end
  private :moving_a_to_b?

  def moving_b_to_a?
    not t_b.trolley.nil?
  end
  private :moving_b_to_a?

  # TODO Assumes the trolley is stopped or moving forward.
  def update
    unless trolley.nil?
      x0, y0, x1, y1 = orient_direction

      theta = Math.atan2(y1 - y0, x1 - x0)
      vx = trolley.v * Math.cos(theta)
      vy = trolley.v * Math.sin(theta)

      d = Gosu::distance(trolley.x, trolley.y, x1, y1)

      unless d < trolley.v
        trolley.locate_at(trolley.x + vx, trolley.y + vy)
      else
        raise OffTheRailsException, "The trolley ran off the end of the track!"
      end
    end
  end

  # The trolley is heading from (x0, y0) to (x1, y1)
  def orient_direction
    case
    when moving_a_to_b?
      [t_a.x, t_a.y, t_b.x, t_b.y]
    when moving_b_to_a?
      [t_b.x, t_b.y, t_a.x, t_a.y]
    else
      raise RuntimeError, "Unable to orient direction."
    end
  end

  def draw
    g_ax, g_ay = Numeric.world_to_gosu(t_a.x, t_a.y)
    g_bx, g_by = Numeric.world_to_gosu(t_b.x, t_b.y)
    $window.draw_line(g_ax, g_ay, Gosu::Color::GRAY, g_bx, g_by, Gosu::Color::GRAY)
  end

end