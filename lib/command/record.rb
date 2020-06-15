module Tt
  module Command
    class Record < Dry::CLI::Command
      desc 'Records a time frame with a given parameter.'

      # option :tracker, values: %w[azure jira]
      # option :ticket, type: :string

      option :date, type: :string, default: ''#, required: false
      option :expandable, type: :boolean, required: false, default: true, desc: 'If this time frame can be expanded to fill an entire work day'

      argument :topic, required: true, desc: 'What are you working on?'
      argument :start_time, required: true, desc: 'Start time of the time frame. Format: %HH%MM, e.g. 1030'
      argument :end_time, required: true, desc: 'End time of the time frame. Format: %HH%MM, e.g. 1100'

      def call(topic:, start_time:, end_time:, date:, expandable:, **)
        record_date = Date.parse date rescue Date.today
        start_time = Time.new record_date.year, record_date.month, record_date.day, *(start_time.scan Util::TIME_REGEX)
        end_time = Time.new record_date.year, record_date.month, record_date.day, *(end_time.scan Util::TIME_REGEX)

        timeframe = Timeframe.new start_time: start_time, end_time: end_time, topic: topic, expandable: expandable

        timesheet = Timesheet.load record_date
        timesheet.append(timeframe)
        timesheet.save
        
        duration_string = timeframe.duration.to_s.colorize Tt::Colors::TRACKED_TIME
        topic_string = topic.colorize Tt::Colors::TICKET_ISSUE

        puts "[#{topic_string}] Logged #{duration_string} on #{record_date}"
        # puts timesheet.build_report
      end
    end
  end
end
