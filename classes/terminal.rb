class Terminal

  attr_accessor :link

  def initialize(trunk, orientation)
    @trunk = trunk
    @orientation = orientation
    @link = nil
  end

  def link_to(t)
    @link = t
  end

  def linked?
    not @link.nil?
  end

  def self.link(t_x, t_y)
    t_x.link_to(t_y)
    t_y.link_to(t_x)
  end
  
end