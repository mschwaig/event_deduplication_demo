require_relative 'statistics_utils'

mu_list = [2, 4, 5]

File.open("example1_inputs.dat", 'w') do |file_inputs|
  for mu in mu_list
    x = mu
    y = 0
    file_inputs.printf "%f %f\n", x, y
  end
end

prev_y = curr_y = next_y = 0
stepsize = 0.01

File.open("example1_pdf.dat", 'w') do |file_pdf|
  File.open("example1_outputs.dat", 'w') do |file_cons|
    (0..8).step(stepsize) do |x|
      prev_y = curr_y
      curr_y = next_y
      next_y =  StatisticsUtils.sum_of_normal_PDFs(mu_list, 1, x)
      file_pdf.printf "%f %f\n", x, next_y
      if prev_y < curr_y && curr_y > next_y then
        file_cons.printf "%f %f\n", x-stepsize, curr_y
      end
    end
  end
end
