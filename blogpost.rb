
def receive(report)
  @received_reports << report
end

def normal_PDF(mu, sigma, x)
    # this could be replaced by a lookup table if x was discrete
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

def tick()
 @t = @t + 1
 @prev_y = @curr_y
 @curr_y = @next_y
 @next_y =  sum_of_normal_PDFs(mu_list, 1, t-@delay)
 if prev_y < curr_y && curr_y > nxt_y then
   output_consolidated_event(t-1-@delay)
 end
end

mu_list = [2, 4, 5]

File.open("example1_inputs.txt", 'w') do |file_c|
  for mu in mu_list
    x = mu
    y = 0
    file_c.printf "%f %f\n", x, y
  end
end

prev_y = 0
curr_y = 0
nxt_y = 0
stepsize = 0.01

File.open("example1_pdf.txt", 'w') do |file_pdf|
  File.open("example1_outputs.txt", 'w') do |file_cons|
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
