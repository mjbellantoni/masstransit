class Station

  attr_reader :x, :y

  def initialize(window, name, x, y)
    @window = window
    @name = name

    # ===========
    # = Classic =
    # ===========
    @x = x
    @y = y
    @color = Gosu::Color::RED


    # ============
    # = Chipmunk =
    # ============
    @body = CP::Body.new(10, 200) # Args are mass and moment of inertia.
    @body.p = CP::Vec2.new(x, y) # Position
    @body.v = CP::Vec2.new(0, 0) # Velocity
    @body.a = (3*Math::PI/2.0) # Angular momentum.
    
    # Anti-clockwise, like Chipmunk wants.
    @shape_verts = [
                    CP::Vec2.new(-10, 10),
                    CP::Vec2.new(10, 10),
                    CP::Vec2.new(10, -10),
                    CP::Vec2.new(-10, -10),
                   ]
    @shape = CP::Shape::Poly.new(@body, @shape_verts, CP::Vec2.new(0,0))
    @shape.e = 0.0 # See if this isn't the default.
    @shape.u = 0 # Friction

    # @window.space.add_body(@body)
    @window.space.add_shape(@shape)

    @font = Gosu::Font.new(@window, Gosu::default_font_name, 10)
  end

  def draw
    # s_x = @x / 4.0
    # s_y = ((4.0 * 800.0) - @y) / 4.0
    # 
    # @window.draw_quad2(s_x, s_y, 10, @color)
    s_x = @body.p.x / 4.0
    s_y = ((4.0 * 800.0) - @body.p.y) / 4.0
    @window.draw_quad2(s_x, s_y, 10, Gosu::Color::RED, 0)


    @font.draw_rel(@name, s_x, s_y, 0, 0.5, -1.0)
  end

end