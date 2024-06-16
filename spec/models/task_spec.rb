# spec/models/task_spec.rb

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:due_date) }
    it { should validate_presence_of(:status) }
  end

  describe "scopes" do
    describe ".upcoming_tasks_to_remind_about" do
      let!(:task1) { create(:task, due_date: Time.current+ 1.day, status: :backlog) }
      let!(:task2) { create(:task, due_date: Time.current+ 2.days, status: :in_progress) }
      let!(:task3) { create(:task, due_date: Time.current- 1.day, status: :done) }
      let!(:task4) { create(:task, due_date: Time.current+ 1.day, status: :done) }

      it "returns tasks with due_date in the future and not in 'Done' status" do
        expect(Task.upcoming_tasks_to_remind_about).to match_array([task1, task2])
      end
    end
  end

  describe "instance methods" do
    describe "#due_soon?" do
      let(:task) { create(:task, due_date: Time.current + 1.day + 10.minutes) }

      it "returns true if due_date is within 1 day from now" do
        expect(task.due_soon?('1 day')).to be_truthy
      end

      it "returns false if due_date is not within 1 day from now" do
        expect(task.due_soon?('1 hour')).to be_falsey
      end
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values([:backlog, :in_progress, :done]) }
  end
end
