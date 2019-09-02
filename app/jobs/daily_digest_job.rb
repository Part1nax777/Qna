class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    Services::DailyDigest.new.call
  end
end
