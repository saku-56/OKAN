require File.expand_path(File.dirname(__FILE__) + "/environment")

ENV.each { |k, v| env(k, v) }
rails_env = ENV["RAILS_ENV"] || :development
set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"
every 1.day, at: "0:00 am" do
  rake "medicine_stock:reduce_medicine_stock"
  rake "consultation_schedule:update_status"
end
