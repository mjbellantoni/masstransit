require "chingu"
require "classes/block"
require "classes/game_time"
require "classes/track"

class TestState < Chingu::GameState

  def initialize
    super
  end

  def setup

    # ==========
    # = Tracks =
    # ==========
    @track1 = Track.create(:a_x => 1200, :a_y => -200, :b_x => 500, :b_y => 100)
    @track2 = @track1.t_b.extend_to(800, 1000)
    @track3 = @track2.t_b.extend_to(-1500, -1500)
    @track4 = @track3.t_b.extend_to(1200, -200)
    Track::TrackTerminal.link(@track4.t_b, @track1.t_a)

    @tracks = [@track1, @track2, @track3, @track4]

    # ==========
    # = Blocks =
    # ==========
    @blocks = @tracks.map do |track|
      Block.create(:track_t_a => track.t_a, :track_t_b => track.t_b, :orientation => Block::A_TO_B)
    end
    @block1, @block2, @block3, @block4 = @blocks

    Block::BlockTerminal.link(@block1.t_b, @block2.t_a)
    Block::BlockTerminal.link(@block2.t_b, @block3.t_a)
    Block::BlockTerminal.link(@block3.t_b, @block4.t_a)
    Block::BlockTerminal.link(@block4.t_b, @block1.t_a)

    # Create a trolley, put it on the track and make it go.
    @trolley1 = Trolley.create
    @track2.t_a.carry(@trolley1)
    @trolley1.forward

    @trolley2 = Trolley.create
    @track4.t_a.carry(@trolley2)
    @trolley2.forward

    # station_loader = StationLoader.new(Pathname.new(__FILE__).dirname + ".." + ".." + "data" + "stations" + "central_subway_and_lechmere.dat")
    # @stations = station_loader.load

    @font = Gosu::Font.new($window, Gosu::default_font_name, 30)
    @time = GameTime.new
  end
  
  def draw
    super
    @font.draw(@time, 0, 0, 0)
  end

  def update

    # @drivers.all.each do |driver|
    #   driver.update
    # end

    super
    # This is getting called 1/sec in game time.
    # @time += 1
    @time.step
  end

end