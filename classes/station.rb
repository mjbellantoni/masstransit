require "chingu"
require "pathname"


class Station < Chingu::BasicGameObject

  trait :sprite
  attr_reader :x, :y

  def initialize(options)

    super(options)
    @name = options[:name]

    @x = options[:x]
    @y = options[:y]
    @color = Gosu::Color::RED

    @font = Gosu::Font.new($window, Gosu::default_font_name, 10)
  end

  def draw
    g_x, g_y = Numeric.world_to_gosu(@x, @y)
    $window.draw_quad2(g_x, g_y, 4, Gosu::Color::RED, 0)
    @font.draw_rel(@name, g_x, g_y, 0, 0.5, -1.0)
  end

end