# Add this directory to the load path.
$:.unshift File.dirname(__FILE__)

require 'gosu'
require 'chingu'
require 'lib/gosu/window'
require 'lib/gosu/numeric'
# require 'classes/station'
require 'classes/trolley'
require 'classes/track'


$stations_data = [
    ["Kenmore",	0],
    ["Copley",	1491.861888],
    ["Arlington",	2076.05376],
    ["Boylston",	2599.09056],
    ["Park Street",	3086.721792],
    ["Government Center",	3487.448448]
  ]

$window = nil

class GameWindow < Chingu::Window

  attr_reader :space

  def initialize
     super(1280, 800, true)
     self.caption = "Mass Transit -- Subway Fun!"

     # Create a track.
     @track1 = Track.create(200, 1600, 1500, 2100)
     @track2 = @track1.t_b.extend_to(1800, 3100)

     # Create a trolley and put it on the track.
     @trolley = Trolley.create
     @track1.t_a.carry(@trolley)

     # Run the trolley.
     @trolley.forward

     @font = Gosu::Font.new(self, Gosu::default_font_name, 30)
     @time = Time.now
     
     $window = self
   end

   def draw
     # Draw tracks
     Track.all.each do |track|
       track.draw
     end

     # Draw trolley
     @trolley.draw

     # Draw timer.
     @font.draw("Day 1 #{@time.strftime('%H:%M:%S')}", 0, 0, 0)
   end

  def update
    # This is getting called 1/sec in game time.
    @time += 1
  
    @trolley.update
  
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