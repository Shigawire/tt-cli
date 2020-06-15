module Tt
  class Duration
    def initialize(hours: nil, minutes: nil, i: nil)
      raise 'hours and minutes or i must be supplied.' unless (hours && minutes) || i
      @hours = hours
      @minutes = minutes
      @i = i

      if @i
        @minutes = Integer(@i % 60)
        @hours = Integer((@i - @minutes) / 60)
      else
        @i = @hours * 60 + @minutes
      end
    end

    def self.from(start_time:, end_time:)
      # duration_min = Integer(
      #   (end_time - start_time) / 60
      # ) rescue 0
      # minutes = Integer(duration_min % 60)
      # hours = Integer(
      #   (duration_min - minutes) / 60
      # )

      i = Integer(
        (end_time - start_time) / 60
      )

      Duration.new(i: i)
    end

    def to_s
      "#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}h"
    end

    def to_i
      @i
    end

    private
    attr_accessor :hours, :minutes, :i
  end
end
