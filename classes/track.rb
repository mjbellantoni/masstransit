require "chingu"
require "observer"
require_relative "../classes/terminal"


class OffTheRailsException < RuntimeError
end


# The Track class tells a trolley where to go.
class Track  < Chingu::BasicGameObject

  # Handles the connections between Tracks.
  class TrackTerminal < Terminal

    include Observable

    attr_accessor :x, :y

    def initialize(track, x, y, orientation)
      super(track, orientation)
      @x, @y = x, y
    end

    def track
      @trunk
    end

    # Place a trolley onto the system.
    def carry(trolley)
      track.carry(trolley, @orientation)
      notify(:enter, trolley)
      trolley.locate_at(track, @x, @y)
    end

    # Pick up the trolley from another track.
    def pickup(trolley, duty_cycle = 1.0)
      track.carry(trolley, @orientation)
      notify(:enter, trolley)
      trolley.locate_at(track, @x, @y)
      track.update(duty_cycle)
    end

    # Hand off the trolley to another track.
    def handoff(trolley, duty_cycle = 1.0)
     # puts "HANDOFF #{duty_cycle}"
      # $logger.debug("HANDOFF #{duty_cycle}")
      # trolley.locate_at(track, @x, @y)
      track.drop
      notify(:exit, trolley)
      @link.pickup(trolley, duty_cycle)
    end

    # Extend this terminal with another track.
    def extend_to(x, y)
      Track.create(:a_x => @x, :a_y => @y, :b_x => x, :b_y => y).tap do |extension|
        Terminal.link(self, extension.t_a)
      end
    end

    def notify(action, trolley)
      changed
      notify_observers(action, trolley)
    end
    private :notify

  end

  trait :sprite
  attr_accessor :trolley

  A_TO_B = 0
  B_TO_A = 1

  def initialize(options)
    super(options)
    @terminal_a = TrackTerminal.new(self, options[:a_x], options[:a_y], A_TO_B)
    @terminal_b = TrackTerminal.new(self, options[:b_x], options[:b_y], B_TO_A)
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
  def update(duty_cycle = 1.0)
    # puts "UPDATE #{duty_cycle}"
    unless trolley.nil?
      x0, y0, x1, y1, t0, t1 = orient_direction

      theta = Math.atan2(y1 - y0, x1 - x0)
      vx = trolley.v * duty_cycle * Math.cos(theta)
      vy = trolley.v * duty_cycle * Math.sin(theta)

      d = Gosu::distance(trolley.x, trolley.y, x1, y1)
      # $logger.debug("#{d}, #{trolley.v}, #{Math.hypot(vx, vy)}")
      unless d < trolley.v * duty_cycle
        trolley.locate_at(self, trolley.x + vx, trolley.y + vy)
      else
        if t1.linked?
          t1.handoff(trolley, 1.0 - (d / trolley.v))
        else
          raise OffTheRailsException, "The trolley ran off the end of the track!"
        end
      end
    end
  end

  # The trolley is heading from (x0, y0) to (x1, y1)
  def orient_direction
    # TODO Use instance variables directly.
    case
    when moving_a_to_b?
      [t_a.x, t_a.y, t_b.x, t_b.y, t_a, t_b]
    when moving_b_to_a?
      [t_b.x, t_b.y, t_a.x, t_a.y, t_b, t_a]
    else
      raise RuntimeError, "Unable to orient direction."
    end
  end

  def dump
    x0, y0, x1, y1, t0, t1 = orient_direction
    "(#{x0}, #{y0}) -> (#{x1}, #{y1})"
  end

  def draw
    g_ax, g_ay = Numeric.world_to_gosu(t_a.x, t_a.y)
    g_bx, g_by = Numeric.world_to_gosu(t_b.x, t_b.y)
    $window.draw_line(g_ax, g_ay, Gosu::Color::GRAY, g_bx, g_by, Gosu::Color::GRAY)
  end

end