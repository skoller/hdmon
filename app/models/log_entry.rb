class LogEntry < ApplicationRecord
  has_secure_password
  belongs_to :patient
  has_one :convo_handler, dependent: :destroy

  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
         hourly.minute_of_hour(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
       11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
       21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
       31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
       41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
       51, 52, 53, 54, 55, 56, 57, 58, 59)
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



end
