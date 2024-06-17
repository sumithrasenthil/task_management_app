---

## Task Management Application

This Task Management web application, built with Ruby on Rails, helps users organize their tasks into Backlog, In-progress, and Done states with deadlines. The application also sends email notifications to users 1 day and 1 hour before the task deadline if the task is not marked as Done.

### Features

- **User Authentication**: Users can sign up, sign in, and securely manage their tasks.
- **Task Management**: Users can create, view, edit, and delete tasks.
- **Task States**: Each task can be in one of three states: Backlog, In-progress, and Done.
- **Deadline Tracking**: Tasks have deadlines, and email alerts are sent 1 day and 1 hour before the deadline if the task is not marked as Done.

### Installation Prerequisites

- Ruby (v3.0.0+)
- Rails (v7.0+)
- MySQL as the database server
- Bundler for installing Ruby gems
- Redis for background job processing

### Getting Started

1. **Clone the repository**:
    ```bash
    git clone https://github.com/sumithrasenthil/task_management_app.git
    cd task-management-app
    ```

2. **Install dependencies**:
    ```bash
    bundle install
    ```

3. **Set up the database**:
    ```bash
    rails db:create
    rails db:migrate
    ```

4. **Start Redis server**:
    ```bash
    redis-server
    ```

5. **Start MailCatcher for email testing**:
    ```bash
    mailcatcher
    ```

6. **Start the Sidekiq server**:
    ```bash
    bundle exec sidekiq
    ```

7. **Start the Rails server**:
    ```bash
    rails server
    ```

8. **Access the application**: Open a web browser and navigate to [http://localhost:3000](http://localhost:3000).

### Testing

RSpec is used for testing the application. Run the tests with:
```bash
bundle exec rspec
```
---

## Technical Approach

This section outlines the technical design and implementation approach for the Task Management application built with Ruby on Rails.

### 1. Project Setup

1. **Initialize Rails Project**: Create a new Rails application using Myswl as the default database.
    ```bash
    rails new task_management_app
    ```
### 2. User Authentication

1. **Add Devise Gem**: Include Devise for handling user authentication.
    ```ruby
    # Gemfile
    gem 'devise'
    ```
2. **Install and Configure Devise**:
    ```bash
    bundle install
    rails generate devise:install
    rails generate devise User
    rails db:migrate
    ```

### 3. Task Management

1. **Generate Task Model**: Create the Task model to manage task-related data.
    ```bash
    rails generate model Task title:string description:text due_date:datetime status:string user:references
    rails db:migrate
    ```
2. **Model Associations and Validations**:
    ```ruby
    # app/models/task.rb
    class Task < ApplicationRecord
      belongs_to :user
      validates :title, :due_date, :status, presence: true
    end

    # app/models/user.rb
    class User < ApplicationRecord
      has_many :tasks, dependent: :destroy
    end
    ```

### 4. Controllers and Views

1. **Generate Tasks Controller**:
    ```bash
    rails generate controller Tasks
    ```
2. **Implement CRUD Actions**:
    ```ruby
    # app/controllers/tasks_controller.rb
    class TasksController < ApplicationController
      before_action :authenticate_user!
      before_action :set_task, only: %i[show edit update destroy]

      def index
        @tasks = current_user.tasks
      end

      def show; end

      def new
        @task = Task.new
      end

      def edit; end

      def create
        @task = current_user.tasks.build(task_params)
        if @task.save
          redirect_to @task, notice: 'Task was successfully created.'
        else
          render :new
        end
      end

      def update
        if @task.update(task_params)
          redirect_to @task, notice: 'Task was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        @task.destroy
        redirect_to tasks_url, notice: 'Task was successfully destroyed.'
      end

      private

      def set_task
        @task = current_user.tasks.find(params[:id])
      end

      def task_params
        params.require(:task).permit(:title, :description, :due_date, :status)
      end
    end
    ```

3. **Create Views for Tasks**:
    - `index.html.erb`: List all tasks.
    - `show.html.erb`: Display a single task.
    - `new.html.erb` and `edit.html.erb`: Forms for creating and editing tasks.

### 5. Background Job Processing

1. **Add Sidekiq Gem**:
    ```ruby
    # Gemfile
    gem 'sidekiq'
    ```
2. **Configure Sidekiq**:
    ```ruby
    # config/initializers/sidekiq.rb
    Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://localhost:6379/0' }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://localhost:6379/0' }
    end
    ```

3. **Generate Job for Email Reminders**:
    ```bash
    rails generate job TaskReminderEmail
    ```

4. **Implement the Job**:
    ```ruby
    # app/jobs/task_reminder_email_job.rb
    class TaskReminderEmailJob < ApplicationJob
      queue_as :default
      retry_on StandardError, wait: :exponentially_longer, attempts: 1

      def perform(task_id, time_before)
        task = Task.find_by(id: task_id)
        return unless task.present? && task.status != 'Done'

        TaskMailer.reminder_email(task, time_before).deliver_later
      end
    end
    ```

5. **Set Up Mailer for Task Reminders**:
    ```ruby
    # app/mailers/task_mailer.rb
    class TaskMailer < ApplicationMailer
      default from: 'notifications@taskmanagerapp.com'

      def reminder_email(task, time_left)
        @task = task
        @time_left = time_left
        mail(to: @task.user.email, subject: "Reminder: Task Deadline in #{@time_left}")
      end
    end
    ```

### 6. Email Testing with MailCatcher

1. **Add MailCatcher Gem**:
    ```ruby
    # Gemfile
    gem 'mailcatcher', '~> 0.7.1', group: :development
    ```
2. **Configure ActionMailer to Use MailCatcher**:
    ```ruby
    # config/environments/development.rb
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = { address: 'localhost', port: 1025 }
    ```

### 7. Testing

1. **Set Up RSpec and FactoryBot**:
    ```ruby
    # Gemfile
    group :development, :test do
      gem 'rspec-rails'
      gem 'factory_bot_rails'
    end
    ```
2. **Generate RSpec Configuration**:
    ```bash
    rails generate rspec:install
    ```
3. **Write Unit and Integration Tests**: Create tests for models, controllers, and jobs.

---

    



