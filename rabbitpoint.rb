$:.unshift(File.join(File.dirname(__FILE__), "lib"))
require "rabbit_point"

begin
  ppt = ARGV.shift || raise
  minutes = (ARGV.shift || raise).to_i
rescue
  puts "Usage: ruby #$0 <ppt> <minutes>"
  exit 1
end

freq = minutes < 10 ? 2 : 10

RabbitPoint.run(ppt, minutes: minutes, frequency_sec: freq, margin_sec: freq * 6)
