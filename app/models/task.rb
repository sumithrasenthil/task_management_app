class Task < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :description, :due_date, :status
  enum status: { backlog: 0, in_progress: 1, done: 2 }
end
