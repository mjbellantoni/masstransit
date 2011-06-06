# Add this directory to the load path.
$:.unshift File.dirname(__FILE__)

require 'gosu'
require 'chingu'
require 'lib/gosu/window'
require 'classes/station'
require 'classes/trolley'


module ZOrder
  Background, Stars, Player, UI = *0..3
end


# http://namakajiri.net/code/falling_squares.rb
# https://bitbucket.org/philomory/ruby-gosu-moonbuggy/src/d916dfb1c36b/moonbuggy.rb

$stations_data = [
    ["Kenmore",	0],
    ["Copley",	1491.861888],
    ["Arlington",	2076.05376],
    ["Boylston",	2599.09056],
    ["Park Street",	3086.721792],
    ["Government Center",	3487.448448]
  ]



class Star
  attr_reader :x, :y

  def initialize(animation)
    @animation = animation
    @color = Gosu::Color.new(0xff000000)
    @color.red = rand(255 - 40) + 40
    @color.green = rand(255 - 40) + 40
    @color.blue = rand(255 - 40) + 40
    @x = rand * 1280
    @y = rand * 800 
  end

  def draw  
    img = @animation[Gosu::milliseconds / 100 % @animation.size];
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::Stars, 1, 1, @color, :additive)
  end
end


class Player
  def initialize(window)
    @image = Gosu::Image.new(window, "media/trolley.png", false)
    @x = @y = @vel_x = @vel_y = @angle = 0.0
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 1280
    @y %= 800

    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def collect_stars(stars)
    stars.reject! do |star|
      Gosu::distance(@x, @y, star.x, star.y) < 35
    end
  end

end


class GameWindow < Chingu::Window

  attr_reader :space

  def initialize
     super(1280, 800, true)
     self.caption = "Gosu Tutorial Game"

     @space = CP::Space.new

     #Create stations
     @stations = $stations_data.map do |station_data|
       Station.new(self, station_data[0], station_data[1] + 200, 1600.0)
     end
     
     @trolley = Trolley.new(self, @stations[0].x, @stations[0].y)

     @player = Player.new(self)
     @player.warp(320, 240)

     @font = Gosu::Font.new(self, Gosu::default_font_name, 30)
     @time = Time.now
   end

   def draw
     @trolley.draw
     @stations.each { |station| station.draw }
     @font.draw("Day 1 #{@time.strftime('%H:%M:%S')}", 0, 0, 0)
   end

  def update
    # This is getting called 1/sec in game time.
    @time += 1

    # Chipmunk
    # @substeps = 3
    # # @dt is the amount of time between each substep.
    # @dt = (1.0/60.0) / @substeps
    @space.step(1.0) # 1.0 second each time through.

    # Called 60 fps
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn_right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.accelerate
    end

  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show