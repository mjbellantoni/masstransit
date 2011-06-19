require "geokit"


class StationLoader

  def initialize(filename)
    @filename = filename
    @center_point = Geokit::LatLng.new(-71.06218103280605, 42.35633768951247) # Park Street
  end

  def load
    data_points = {}

    # Load data points.
    File.open(@filename) do |file|
      while (line = file.gets) do
        name, lat, lng, el = line.split(",")
        data_points[name] = Geokit::LatLng.new(lat, lng)
      end
    end

    # Figure out where they are in game-world coordinates.
    data_points.map do |name, location|
      distance = @center_point.distance_to(location, :units => :kms) * 1000 # meters
      x, y = unless @center_point == location
        heading  = (@center_point.heading_to(location) / 180.0 * Math::PI) if @center_point != location
        [distance * Math.cos(heading), distance * Math.sin(heading)]
      else
        [0, 0]
      end
      Station.create(:name => name, :x => x, :y => y)
    end

  end

end