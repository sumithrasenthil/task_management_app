class TaskMailer < ApplicationMailer
  default from: 'notifications@taskmanagerapp.com'

  def reminder_email(task, time_left)
    @task = task
    @time_left = time_left
    mail(to: @task.user.email, subject: "Reminder: Task Deadline in #{@time_left}")
  end
end
