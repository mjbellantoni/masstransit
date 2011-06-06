# Get the root of the project into the load path.
$:.unshift File.dirname(File.dirname(__FILE__))

require 'fabrication'


def setup_chingu
  # Dangerous, but trying to the right thing causes memory leaks!?
  $window ||= Chingu::Window.new
end
