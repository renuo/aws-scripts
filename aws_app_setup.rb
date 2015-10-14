#!/usr/bin/env ruby
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: aws_app_setup.rb [options]"
  opts.on('-p', '--project NAME', 'Project name') { |v| options[:project] = v }
  opts.on('-s', '--suffix PURPOSE', 'Suffix') { |v| options[:purpose] = v }
  opts.on('-h', '--help', 'Display this screen') do
    puts opts
    exit
  end
end.parse!

raise OptionParser::MissingArgument.new('--project') if options[:project].nil?
raise OptionParser::MissingArgument.new('--suffix') if options[:purpose].nil?

PROJECT = options[:project]
PURPOSE = options[:purpose]

def aws_common_setup(profile, region, user, app_group)
  <<-SETUP_COMMANDS
aws --profile #{profile} iam create-user --user-name #{user}
aws --profile #{profile} iam add-user-to-group --user-name #{user} --group-name #{app_group}
aws --profile #{profile} iam create-access-key --user-name #{user}
aws --profile #{profile} s3 mb s3://#{user} --region #{region}
  SETUP_COMMANDS
end

def aws_versioning_setup(profile, bucket)
 <<-VERSIONING_COMMANDS
aws --profile #{profile} s3api put-bucket-versioning --bucket #{bucket} --versioning-configuration Status=Enabled
  VERSIONING_COMMANDS
end

puts ''
%w(master develop testing).each do |branch|
  aws_profile = 'renuo-app-setup'
  aws_region = 'eu-central-1'
  aws_user = "#{PROJECT}-#{branch}-#{PURPOSE}"
  aws_app_group = 'renuo-apps-v2'

  puts aws_common_setup(aws_profile, aws_region, aws_user, aws_app_group)
  puts ''

  if branch == 'master'
    puts aws_versioning_setup(aws_profile, aws_user) 
    puts ''
  end
end
