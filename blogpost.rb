

module StatisticUtils
  def normal_PDF(mu, sigma, x)
      # this could be replaced by a lookup table if the inputs were discrete
      y = (1 / (sigma * ((2 * Math::PI) ** 0.5))) *
            (Math::E ** (-((x - mu) ** 2)) / (2 * (sigma ** 2)))
  end

  def sum_of_normal_PDFs(mu_list, sigma, x)

    sum = 0.0;
    for mu in mu_list
      sum += normal_PDF(mu, sigma, x)
    end

    sum
  end
end

class EventMerger

  def initialize(mean_time_error, min_merge_peak, network_delay)
    @prev_y = 0
    @curr_y = 0
    @next_y = 0
    @t = 0
    @received_reports = []
    @mean_time_error = mean_time_error
    @min_merge_peak = min_merge_peak
    @delay = network_delay + 3 * mean_time_error
  end

  def receive(report)
    @received_reports << report
  end

  def tick()
    # advance window
    @prev_y = @curr_y
    @curr_y = @next_y
    @next_y =  sum_of_normal_PDFs (@received_reports,
                                   @mean_time_error,
                                   @t - @delay)
    # output events
    if @prev_y < @curr_y && @curr_y > @next_y && @curr_y > @min_merge_peak then
      output_merged_event(@t - @delay)
    end
    # remove old reports from list
    report.reject!{ |rep_time| rep_time < @t - @delay - 6 * @mean_time_error }

    # advance time
    @t = @t + 1
  end
end

mu_list = [2, 4, 5]

File.open("example1_inputs.dat", 'w') do |file_inputs|
  for mu in mu_list
    x = mu
    y = 0
    file_inputs.printf "%f %f\n", x, y
  end
end


stepsize = 0.01

File.open("example1_pdf.dat", 'w') do |file_pdf|
  File.open("example1_outputs.dat", 'w') do |file_cons|
    (0..8).step(stepsize) do |x|
      prev_y = curr_y
      curr_y = nxt_y
      nxt_y =  sum_of_normal_PDFs(mu_list, 1, x)
      file_pdf.printf "%f %f\n", x, nxt_y
      if prev_y < curr_y && curr_y > nxt_y then
        file_cons.printf "%f %f\n", x-stepsize, curr_y
      end
    end
  end
end

5.times do
  tick()
end
receive(2)
tick()
tick()
receive(3)
tick()
tick()
receive(4)
tick()
tick()
