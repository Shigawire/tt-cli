require 'date'

module Tt
  module Command
    class Report < Dry::CLI::Command
      option :date, type: :string, default: ''

      option :merge, type: :boolean, default: false, desc: "Merge timeframes with same topics"
      option :expand_to, type: :string, optional: true, desc: "Expand to %HH%MM hours of working time"

      def call(date:, merge:, expand_to: nil)
        date = Date.parse(date) rescue Date.today

        timesheet = Timesheet.load date

        report = ::Tt::Report.new(timesheet: timesheet)

        puts report.build(merge: merge, expand_to: expand_to)
        # timesheet.build_report merge: merge, expand_to: expand_to
      end
    end
  end
end
