class TestState < Chingu::GameState

  def setup
    # Create a track.
    @track1 = Track.create(:a_x => 0, :a_y => 0, :b_x => 500, :b_y => 100)
    @track2 = @track1.t_b.extend_to(800, 1000)
    @track3 = @track2.t_b.extend_to(0, 0)
    Track::Terminal.link(@track3.t_b, @track1.t_a)
    # Create a trolley and put it on the track.
    @trolley = Trolley.create
    @track1.t_a.carry(@trolley)

    # Run the trolley.
    @trolley.forward

    # station_loader = StationLoader.new(Pathname.new(__FILE__).dirname + ".." + ".." + "data" + "stations" + "central_subway_and_lechmere.dat")
    # @stations = station_loader.load

    @font = Gosu::Font.new($window, Gosu::default_font_name, 30)
    @time = Time.now
  end
  
  def finalize
  end

  def draw
    super
    @font.draw("Day 1 #{@time.strftime('%H:%M:%S')}", 0, 0, 0)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      $window.close
    end
  end

  def update

    @drivers.all.each do |driver|
      driver.update
    end

    super
    # This is getting called 1/sec in game time.
    @time += 1
  end

end