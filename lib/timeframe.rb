require 'util'

module Tt
  class Timeframe
    def initialize(start_time:, end_time:, topic:, expandable:)
      @start_time = start_time
      @end_time = end_time
      @topic = topic
      @expandable = expandable
    end

    def duration
      Duration.from start_time: start_time, end_time: end_time
    end

    def self.expanded(timeframes:, expand_to:)
      # target_duration = expand_to
      expandable_timeframes = timeframes.select {|x| x.expandable }

      if expandable_timeframes.empty?
        raise 'No expandable timeframes.'
      end

      non_expandable_timeframes = timeframes - expandable_timeframes

      current_total = Duration.new i: expandable_timeframes.sum { |x| x.duration.to_i }

      # binding.pry
      expanded_timeframes = expandable_timeframes.map do |x|
        target_ratio = Float(x.duration.to_i) / Float(current_total.to_i)
        target_duration = Duration.new(i: Integer(expand_to.to_i * target_ratio))
        # binding.pry
        x.dup.tap do |target_timeframe|
          target_timeframe.end_time = target_timeframe.start_time + target_duration.to_i * 60
        end
        # target_timeframe
      end

      non_expandable_timeframes + expanded_timeframes
    end

    def self.merged(timeframes)
      grouped_timeframes = timeframes.sort_by(&:start_time).group_by(&:topic)

      grouped_timeframes.map do |topic, timeframes|
        first_timeframe = timeframes.first
        start_time = first_timeframe.start_time
        duration = Duration.new i: timeframes.sum { |x| x.duration.to_i }
        end_time = start_time + (duration.to_i * 60)

        timeframe = Timeframe.new start_time: start_time, end_time: end_time, topic: topic
      end
    end

    attr_accessor :start_time, :end_time, :topic, :expandable
  end
end
