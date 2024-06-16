namespace :reminders do
  desc 'Send reminders for tasks which due is one day or one hour from the current date'
  task send_reminders: :environment do
    tasks = Task.upcoming_tasks_to_remind_about

    tasks.find_each do |task|
      TaskReminderEmailJob.perform_later(task.id, '1 day') if task.due_soon?('1 day')

      TaskReminderEmailJob.perform_later(task.id, '1 hour') if task.due_soon?('1 hour')
    end
  end
end
