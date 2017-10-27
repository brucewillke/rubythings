#!/usr/bin/env ruby
require 'aws-sdk'


starting = ARGV[1] #eg 2017-10-25T00:00:00
ending = ARGV[2] #eg 2017-10-26T00:00:00
load_balancer_name = ARGV[0]
name_space = 'AWS/ELB'
metric_name = 'RequestCount'
period = ARGV[3] #in seconds


cw = Aws::CloudWatch::Client.new(
  region: "us-east-1"
)

resp = cw.get_metric_statistics({
  namespace: name_space,
  metric_name: metric_name,
  dimensions: [
    {

      name: 'LoadBalancerName',
      value: load_balancer_name
    }
  ],
  start_time: starting,
  end_time: ending,
  period: period,
  statistics: ["Sum"]
})


sum = resp.datapoints.map {|s| s.sum}

def average(arg)
  arg.inject{ |sum, el| sum + el }.to_f / arg.size
end

rc_average = average(sum)

puts "The average RequestCount for #{load_balancer_name} is #{rc_average}"
