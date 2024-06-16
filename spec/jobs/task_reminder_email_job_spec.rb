# spec/jobs/task_reminder_email_job_spec.rb
require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe TaskReminderEmailJob, type: :job do
  let(:user) { FactoryBot.create(:user, email: 'test@example.com') }
  let(:task) { FactoryBot.create(:task, user: user, due_date: Time.now + 1.day) }

  before do
    Sidekiq::Testing.fake!   # Use fake! to queue jobs without executing them
    ActionMailer::Base.deliveries.clear
  end

  it "queues the job" do
    expect {
      TaskReminderEmailJob.perform_later(task.id, '1 day')
    }.to change(Sidekiq::Queues['default'], :size).by(1)
  end

  it "does not send reminder email if task status is 'Done'" do
    task.update(status: 'done')

    TaskReminderEmailJob.new.perform(task.id, '1 day')

    # Ensure no email was sent
    expect(ActionMailer::Base.deliveries.count).to eq(0)
  end
end
