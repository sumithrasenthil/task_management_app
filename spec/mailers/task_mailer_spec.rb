require 'rails_helper'

RSpec.describe TaskMailer, type: :mailer do
  describe 'reminder_email' do
    let(:user) { FactoryBot.create(:user, email: 'test@example.com') }
    let(:task) { FactoryBot.create(:task, user: user, due_date: Time.now + 1.day) }
    let(:mail) { TaskMailer.reminder_email(task, '1 day') }

    it 'renders the headers' do
      expect(mail.subject).to eq('Reminder: Task Deadline in 1 day')
      expect(mail.to).to eq(['test@example.com'])
      expect(mail.from).to eq(['notifications@taskmanagerapp.com']) # Update with your sender email
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Hello #{user.email},")
    end
  end
end
