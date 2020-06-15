require 'io'
require 'timeframe'

module Tt
  class Timesheet
    def initialize(date:, timeframes:)
      @date = date
      @timeframes = timeframes
    end

    def self.load(date)
      Marshal.load(
        IO::Interface.read(
          resolve_path date
        )
      )
    rescue
      Timesheet.new(date: date, timeframes: [])
    end

    def save
      IO::Interface.write self.class.resolve_path(date), Marshal.dump(self)
    end

    def append(timeframe)
      raise 'Is not a timeframe' unless timeframe.is_a? Tt::Timeframe
      raise 'Overlapping timeframes detected' if timeframes.find { |x| x.start_time <= timeframe.start_time &&  x.end_time > timeframe.start_time }
      
      timeframes << timeframe
    end

    def duration
      sum = timeframes.sum { |x| x.duration.to_i }
      Duration.new(i: sum)
    end

    # def merged_timeframes(timeframes: self.timeframes)
    #   Timeframe.merged(timeframes)
    # end

    # def expanded_timeframes(timeframes: self.timeframes)
    #   Timeframe.expanded(timeframes)
    # end

    def self.resolve_path date
      raise 'Is not a valid Date object.' unless date.respond_to? :iso8601
      ".nogit/#{date.iso8601}.bin"
    end

    # private
    
    attr_accessor :date, :timeframes
  end
end
