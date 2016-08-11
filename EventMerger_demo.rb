require_relative 'EventMerger'

em = EventMerger.new(mean_time_error: 1,
                     min_merge_peak: 0.25,
                     time_inc: 0.1,
                     network_delay: 2) do |time|
    puts "event at " + time.to_s
end

50.times do
  em.tick()
end
em.receive(2)
20.times do
  em.tick()
end
em.receive(4)
10.times do
  em.tick()
end
em.receive(5)
80.times do
  em.tick()
end

puts "remaining reports " + em.instance_variable_get(:@received_reports).to_s
puts "time " + em.instance_variable_get(:@t).to_s
