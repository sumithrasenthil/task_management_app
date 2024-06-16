class TaskReminderEmailJob < ApplicationJob
  queue_as :default

  def perform(task_id, time_before)
    task = Task.find_by(id: task_id)
    return unless task.present? && task.status != 'Done'

    TaskMailer.reminder_email(task, time_before).deliver_later
  end
end
