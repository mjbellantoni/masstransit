require "chingu"
require_relative "../classes/terminal"

# Blocks controls movement of a Trolley through the system.
class Block < Chingu::BasicGameObject

  module Signal
    RED = 1
    YELLOW = 2
    GREEN = 3
  end

  # Handles the connections between Blocks.
  class BlockTerminal < Terminal

    def initialize(block, orientation)
      super(block, orientation)
    end

    def block
      @trunk
    end

  end

  trait :sprite

  A_TO_B = 0
  B_TO_A = 1

  attr_writer :orientation

  def initialize(options = {})
    super(options)

    @orientation = options[:orientation]
    @occupied = false

    @terminal_a = BlockTerminal.new(self, A_TO_B)
    @terminal_b = BlockTerminal.new(self, B_TO_A)

    @track_terminal_a = options[:track_t_a]
    @track_terminal_b = options[:track_t_b]

    @track_terminal_a.add_observer(self, :update_occupied_status)
    @track_terminal_b.add_observer(self, :update_occupied_status)
    
    # TODO Put in a check for minimum size of block.
  end

  def t_a
    @terminal_a
  end

  def t_b
    @terminal_b
  end

  def s_a
    calculate_signal(A_TO_B)
  end

  def s_b
    calculate_signal(B_TO_A)
  end

  def occupied?
    @occupied
  end

  def calculate_signal(for_orientation)
    t_start, t_end = orient_direction
    if @orientation == for_orientation
       if @occupied
         Signal::RED
        else
          if t_end.linked?
            next_block.occupied? ? Signal::YELLOW : Signal::GREEN
          else
            Signal::GREEN
          end
        end
    else  
      Signal::RED
    end
  end
  private :calculate_signal

  def orient_direction
    case @orientation
    when A_TO_B
      [@terminal_a, @terminal_b]
    when B_TO_A
      [@terminal_b, @terminal_a]
    else
      raise RuntimeError, "Unable to orient direction."
    end
  end
  private :orient_direction

  def next_block
    orient_direction[1].link.block
  end
  private :next_block

  def update_occupied_status(direction, trolley)
    @occupied = 
      case direction
      when :enter
        true
      when :exit
        false
      else
        raise "Something went wrong!"
      end
  end

  def draw
    g_ax, g_ay = Numeric.world_to_gosu(@track_terminal_a.x, @track_terminal_a.y)
    g_bx, g_by = Numeric.world_to_gosu(@track_terminal_b.x, @track_terminal_b.y)

    $window.draw_quad2(g_ax, g_ay, 4, signal2color(s_a), 0)
    # $window.draw_quad2(g_bx, g_by, 4, signal2color(s_b), 0)

    # $window.draw_line(g_ax, g_ay, Gosu::Color::GRAY, g_bx, g_by, Gosu::Color::GRAY)
  end

  def signal2color(signal)
    case signal
    when Signal::RED
      Gosu::Color::RED
    when Signal::YELLOW
      Gosu::Color::YELLOW
    when Signal::GREEN
      Gosu::Color::GREEN
    else
      raise "Something went wrong!"
    end
  end

end