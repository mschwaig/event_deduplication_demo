require_relative 'EventMerger'

em = EventMerger.new(1, 0.25, 2) do |time|
    puts "event at " + time.to_s
end

5.times do
  em.tick()
end
em.receive(2)
em.tick()
em.tick()
em.receive(4)
em.tick()
em.receive(5)
8.times do
  em.tick()
end

puts "remaining reports " + em.instance_variable_get(:@received_reports).to_s
puts "time " + em.instance_variable_get(:@t).to_s
