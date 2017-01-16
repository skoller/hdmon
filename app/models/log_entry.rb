class LogEntry < ApplicationRecord
  belongs_to :patient
  has_one :convo_handler

  include Delayed::RecurringJob
  run_every 1.minute
  run_at '6:45pm'
  timezone 'US/Pacific'
  queue 'slow-jobs'


  def drop_it
    self.destroy
  end

  def day_web_display
    if self.date
      day = self.date.to_time.strftime('%d').to_i.to_s
      return (self.date.to_time.strftime('%a %b ')) + day
    end
  end

  def year_web_display
    if self.date
      return self.date.to_time.strftime(' %Y')
    end
  end

  def time_web_display
    if self.date
      hour = self.date.to_time.strftime('%I').to_i.to_s
      return (hour + self.date.to_time.strftime(':%M%p'))
    end
  end

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
