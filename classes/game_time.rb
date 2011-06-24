class GameTime

  def initialize
    @start = @current = Time.new(0)
  end
  
  def step
    @current += 1
  end

  def to_s
    "Day #{@current.yday} #{@current.strftime('%H:%M:%S')}" # %j
  end

end