class Time

  def self.convert_seconds_time(seconds)
    hours = seconds / 3600.floor
    minutes = ((seconds / 60) % 60).floor
    "%02d:%02d"%[hours,minutes]
  end

end


