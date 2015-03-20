require 'aws-sdk'
require 'Date'
ec2 = AWS::EC2::Client.new

dryrun = false
description = ["mongo*"]
environment = ["production"]
start_time = Time.strptime("2014-12-14 00:00:00 -0000", '%Y-%m-%d')
role = ["*"]
 resp = ec2.describe_snapshots(
   owner_ids: ["OWNERID"],
   filters: [
    {
       name: "description",
       values: description
     },
     {
       name: "tag-key",
       values: ["Environment"]
     },
     {
       name: "tag-value",
       values: environment
     },
     {
      name: "tag-key",
      values: ["Role"]
     },
     {
      name: "tag-value",
      values: role
     }
   ]
 )

all = resp[:snapshot_set]


times = all.select do |x|
  x[:start_time] < start_time && x[:start_time].mday != 1
end


if times.empty?
  puts "there are no snapshots for the start_time threshold specified"
end


delete = times.map{|x| x[:snapshot_id]}


 delete.each do |d| 
  puts "deleting #{d}"
  ec2.delete_snapshot(
     dry_run: dryrun,
     snapshot_id: d, )
end
