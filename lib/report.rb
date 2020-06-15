require 'timesheet'
require 'timeframe'

module Tt
  class Report
    def initialize(timesheet:)
      @timesheet = timesheet
    end

    def build(merge:, expand_to:)
      timeframes = timesheet.timeframes

      if expand_to
        hours, minutes = expand_to.scan Util::TIME_REGEX
        expand_to_duration = Duration.new(
          hours: Integer(hours, 10),
          minutes: Integer(minutes, 10)
        )

        timeframes = Timeframe.expanded(timeframes: timesheet.timeframes, expand_to: expand_to_duration) 
      end

      timeframes = timeframes.sort_by(&:start_time)

      build_table(timeframes)
    end

    def build_table(timeframes)
      table = Tabulo::Table.new(timeframes, border: :modern) do |t|
        t.add_column('Index') { |_, row_index| row_index }
        t.add_column('Expandable', &:expandable)
        t.add_column('Topic') { |x| "#{x.topic}" }
        t.add_column('Start Time') {|x| x.start_time.strftime '%H:%M' }
        t.add_column('End Time') {|x| x.end_time.strftime '%H:%M' }
        t.add_column('Duration', &:duration)
      end

      table.pack
    end
  
    attr_accessor :timesheet
  end
end
