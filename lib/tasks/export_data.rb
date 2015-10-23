module Tasks
  class ExportData
    def initialize(file, stdout)
      @file = file
      @stdout = stdout
    end

    def export_all
      total = Reservation.count

      Reservation.find_each.with_index(1) do |reservation, index|
        file.puts(reservation.to_json)

        print_progress(index, total)
      end

      stdout.puts
    end

  private

    attr_reader :file, :stdout

    def print_progress(completed, total)
      percent_complete = ((completed.to_f / total) * 100).round
      return if percent_complete == @percent_complete
      @percent_complete = percent_complete
      percent_remaining = 100 - percent_complete

      stdout.print "\r"
      stdout.flush
      stdout.print "Progress [#{"=" * percent_complete}>#{"." * percent_remaining}] (#{percent_complete}%)"
      stdout.flush
    end
  end
end
