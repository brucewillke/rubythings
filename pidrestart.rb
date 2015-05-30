#!/usr/bin/ruby
process = ARGV
pid = %x(pgrep -f #{process})
time = Time.new

if pid.empty?
%x(sudo start #{process})
else
puts "As of #{time} #{process} already running"
end

