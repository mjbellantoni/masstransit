# Blocks controls movement of a Trolley through the system.
class Block

  module Signal
    RED = 1
    GREEN = 2
  end

  # Handles the connections between Tracks.
  class BlockTerminal

    # attr_accessor :x, :y, :track

    def initialize(block, orientation)
      super
      @block = block
      @orientation = orientation
    end

    # Place a trolley onto the system.
    # def carry(trolley)
    #   @track.carry(trolley, @direction)
    #   trolley.locate_at(@track, @x, @y)
    # end

    # Pick up the trolley from another track.
    # def pickup(trolley, duty_cycle = 1.0)
    #   @track.carry(trolley, @direction)
    #   @track.update
    # end

    # Hand off the trolley to another track.
    # def handoff(trolley, duty_cycle = 1.0)
    #   @track.drop
    #   @link.pickup(trolley, duty_cycle)
    # end

    # Extend this terminal with another track.
    # def extend_to(x, y)
    #   Track.create(:a_x => @x, :a_y => @y, :b_x => x, :b_y => y).tap do |extension|
    #     Terminal.link(self, extension.t_a)
    #   end
    # end

    # Link to terminal of another track.
    # def link_to(t)
    #   @link = t
    # end

    # def extended?
    #   not @link.nil?
    # end

    # def self.link(t_x, t_y)
    #   t_x.link_to(t_y)
    #   t_y.link_to(t_x)
    # end

  end

  A_TO_B = 0
  B_TO_A = 1

  def initialize(options = {})
    @orientation = options[:orientation]
    @occupied = false
    @terminal_a = BlockTerminal.new(self, A_TO_B)
    @terminal_b = BlockTerminal.new(self, B_TO_A)
  end

  def t_a
    @terminal_a
  end

  def t_b
    @terminal_b
  end

  def s_a
    Signal::RED
  end

  def s_b
    Signal::RED
  end

end