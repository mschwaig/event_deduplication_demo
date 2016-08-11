require_relative "StatisticsUtils"

class EventMerger

  def initialize(mean_time_error, min_merge_peak, network_delay, &send_merged)
    @prev_y = @curr_y = @next_y = 0
    @t = 0
    @received_reports = []
    @mean_time_error = mean_time_error
    @min_merge_peak = min_merge_peak
    @delay = network_delay + 3 * @mean_time_error
    @send_merged = send_merged;
  end

  def receive(report)
    unless report < @t - 3 * @mean_time_error then
      @received_reports << report
    end
  end

  def tick()
    # advance window
    @prev_y = @curr_y
    @curr_y = @next_y
    @next_y =  StatisticsUtils.sum_of_normal_PDFs @received_reports,
                                                  @mean_time_error,
                                                  @t + 1 - @delay
    # output events
    if @prev_y < @curr_y && @curr_y > @next_y && @curr_y > @min_merge_peak then
      @send_merged.call(@t - @delay)
    end
    # remove old reports from list
    @received_reports.reject! do |rep_time|
      rep_time < @t - @delay - 3 * @mean_time_error
    end

    # advance time
    @t = @t + 1
  end
  
end
