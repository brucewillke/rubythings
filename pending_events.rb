require 'aws-sdk-v1'
require 'slack-notifier'
ec2 = AWS::EC2.new

resp = ec2.client.describe_instance_status(
filters: [
    {
       name: "event.code",
       values: ["instance-reboot","system-reboot"]
    }
  ]
)

instances = resp[:instance_status_set].map { |i| i[:instance_id] }


notifier = Slack::Notifier.new "WEBHOOKSURL"
notifier.channel  = '#sysops-notifications'
notifier.username = 'aws-events-status'


message = instances.flatten

unless instances.empty?
  notifier.ping "these instances have events pending #{message} https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Events:"
end
