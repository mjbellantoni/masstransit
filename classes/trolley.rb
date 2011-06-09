require "chingu"

#
# Examples:
#   image = 'rocket.png'
#   image = Gosu::Image.new($window, 'rocket.png')
#     
#    image = lambda do
#      # TexPlay is library for Gosu image generation
#      TexPlay.create_image($window,10,10).paint { circle(5,5,5, :color => :red) }
#    end
#
class Trolley < Chingu::BasicGameObject

  trait :sprite
  attr_reader :v

  def initialize
    super()
    stop
   @track = nil

  end

  def locate_at(track, x, y)
    # puts "I'm at (#{x}, #{y})"
    @track, @x, @y = track, x, y
  end

  def forward
    @v = 4.470 # 4.470 m/s ~ 10 mph
  end

  def stop
    @v = 0.0
  end

  def running?
    @v != 0.0
  end

  def stopped?
    @v == 0.0
  end

  def update
    @track.update
  end

  def draw
    g_x, g_y = Numeric.world_to_gosu(@x, @y)
    $window.draw_quad2(g_x, g_y, 3, Gosu::Color::GREEN, 1)
  end

end