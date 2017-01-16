module Recurring
 class DailySmsPrompt
  include Delayed::RecurringJob
  run_every 1.minute
  run_at '9:35pm'
  timezone 'US/Central'
  queue 'slow-jobs'
  def perform
    number_to_send_to = '3108090426'
    account_sid = 'AC0e331b7fa11f13be73a32e5311a74969'
    auth_token = 'e948aaf8caad373ae54918c175fd8786'
    twilio_phone_number = "3104992061"

    @twilio_client = Twilio::REST::Client.new account_sid, auth_token
    @twilio_client.account.messages.create(
                 :from => "+1#{twilio_phone_number}",
                 :to => number_to_send_to,
                 :body => "Congratulations!"
               )
           @twilio_client.account.messages.create(
                 :from => "+1#{twilio_phone_number}",
                 :to => number_to_send_to,
                 :body => "You have communicated with HdMon"
               )
  end
 end
end
