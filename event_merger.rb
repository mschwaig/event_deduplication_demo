require_relative "statistics_utils"

class EventMerger

  def initialize(args, &send_merged)
    @prev_y = @curr_y = @next_y = 0.0
    @t = 0.0
    @time_inc =  args[:time_inc] || 1.0
    @received_reports = []
    @mean_time_error = args[:mean_time_error]
    @min_merge_peak =args[:min_merge_peak] || 0.0
    @delay = args[:max_network_delay] + 3 * @mean_time_error
    @send_merged = send_merged
  end

  def receive(report)
    unless report < @t - @delay then
      @received_reports << report
    end
  end

  def tick()
    # advance window
    @prev_y = @curr_y
    @curr_y = @next_y
    @next_y =  StatisticsUtils.sum_of_normal_PDFs @received_reports,
                                                  @mean_time_error,
                                                  @t + @time_inc - @delay
    # output events
    if @prev_y < @curr_y && @curr_y > @next_y && @curr_y > @min_merge_peak then
      @send_merged.call(@t - @delay)
    end
    # remove old reports from list
    @received_reports.reject! do |rep_time|
      rep_time < @t - @delay - 3 * @mean_time_error
    end

    # advance time
    @t = @t + @time_inc
  end

end
