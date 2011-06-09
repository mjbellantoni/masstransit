require "chingu"
require "texplay"

class OffTheRailsException < RuntimeError
end


# The Track class tells a trolley where to go.
class Track  < Chingu::BasicGameObject

  # Handles the connections between Tracks.
  class Terminal

    attr_accessor :x, :y, :track

    def initialize(track, x, y, direction)
      super
      @track = track
      @x, @y = x, y
      @direction = direction
      @link = nil
    end

    # Place a trolley onto the system.
    def carry(trolley)
      @track.carry(trolley, @direction)
      trolley.locate_at(@track, @x, @y)
    end

    # Pick up the trolley from another track.
    def pickup(trolley, duty_cycle = 1.0)
      @track.carry(trolley, @direction)
      @track.update
    end

    # Hand off the trolley to another track.
    def handoff(trolley, duty_cycle = 1.0)
      @track.drop
      @link.pickup(trolley, duty_cycle)
    end

    # Extend this terminal with another track.
    def extend_to(x, y)
      Track.create(@x, @y, x, y).tap do |extension|
        Terminal.link(self, extension.t_a)
      end
    end

    # Link to terminal of another track.
    def link_to(t)
      @link = t
    end

    def extended?
      not @link.nil?
    end

    def self.link(t_x, t_y)
      t_x.link_to(t_y)
      t_y.link_to(t_x)
    end

  end

  trait :sprite # Do I need this?
  attr_accessor :trolley

  A_TO_B = 0
  B_TO_A = 1

  def initialize(a_x, a_y, b_x, b_y)
    super()
    @terminal_a = Terminal.new(self, a_x, a_y, A_TO_B)
    @terminal_b = Terminal.new(self, b_x, b_y, B_TO_A)
    @trolley = nil
    @trolley_direction = nil
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

  def carry(trolley, direction)
    @trolley = trolley
    @trolley_direction = direction
  end

  def drop
    @trolley = nil
    @trolley_direction = nil
  end

  def moving_a_to_b?
    @trolley_direction == A_TO_B
  end
  private :moving_a_to_b?

  def moving_b_to_a?
    @trolley_direction == B_TO_A
  end
  private :moving_b_to_a?

  # TODO Assumes the trolley is stopped or moving forward.
  def update
    unless trolley.nil?
      x0, y0, x1, y1, t0, t1 = orient_direction

      theta = Math.atan2(y1 - y0, x1 - x0)
      vx = trolley.v * Math.cos(theta)
      vy = trolley.v * Math.sin(theta)

      d = Gosu::distance(trolley.x, trolley.y, x1, y1)
      # puts "O: from: (#{x0}, #{y0}) to: (#{x1}, #{y1}) t: (#{trolley.x}, #{trolley.y}) d: #{d}"
      unless d < trolley.v
        trolley.locate_at(self, trolley.x + vx, trolley.y + vy)
      else
        if t1.extended?
          t1.handoff(@trolley, d / trolley.v)
        else
          raise OffTheRailsException, "The trolley ran off the end of the track!"
        end
      end
    end
  end

  # The trolley is heading from (x0, y0) to (x1, y1)
  def orient_direction
    case
    when moving_a_to_b?
      [t_a.x, t_a.y, t_b.x, t_b.y, t_a, t_b]
    when moving_b_to_a?
      [t_b.x, t_b.y, t_a.x, t_a.y, t_b, t_a]
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