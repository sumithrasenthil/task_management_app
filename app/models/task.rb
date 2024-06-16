class Task < ApplicationRecord
    validates :title, :description, :date, :status, presence: :true
end
