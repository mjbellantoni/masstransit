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


    # @window = window

    # @body = CP::Body.new(10, 200) # Args are mass and moment of inertia.
    # # @body.p = CP::Vec2.new(x, y) # Position
    # @body.v = CP::Vec2.new(1.0, 0) # Velocity
    # @body.a = (3*Math::PI/2.0) # Angular momentum.
    # 
    # # Anti-clockwise, like Chipmunk wants.
    # @shape_verts = [
    #                 CP::Vec2.new(-5, 5),
    #                 CP::Vec2.new(5, 5),
    #                 CP::Vec2.new(5, -5),
    #                 CP::Vec2.new(-5, -5),
    #                ]
    # @shape = CP::Shape::Poly.new(@body, @shape_verts, CP::Vec2.new(0,0)) # FIXME: really?
    # @shape.e = 0.0 # See if this isn't the default.
    # @shape.u = 0 # Friction

    # @window.space.add_body(@body)
    # @window.space.add_shape(@shape)

  end

  def locate_at(x, y)
    @x, @y = x, y
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

  def draw
    # s_x = @body.p.x / 4.0
    # s_y = ((4.0 * 800.0) - @body.p.y) / 4.0
    # @window.draw_quad2(s_x, s_y, 5, Gosu::Color::GREEN, 1)
  end

end