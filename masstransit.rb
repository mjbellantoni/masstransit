# Add this directory to the load path.
$:.unshift File.dirname(__FILE__)

require 'gosu'
require 'chingu'
require 'lib/gosu/window'
require 'lib/gosu/numeric'
require 'classes/station'
require 'classes/station_loader'
require 'classes/trolley'
require 'classes/track'
require 'classes/states/test_state'
require 'pathname'


class GameWindow < Chingu::Window

  attr_reader :space

  def initialize
    super(1280, 800, true)
    self.caption = "Mass Transit -- Subway Fun!"
  end

  def setup
    switch_game_state(TestState)
  end

end


window = GameWindow.new
window.show