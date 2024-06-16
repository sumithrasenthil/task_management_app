require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
      expect(assigns(:tasks)).to eq([task])
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: task.id }
      expect(response).to be_successful
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:task)).to be_a_new(Task)
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: task.id }
      expect(response).to be_successful
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_attributes) { { title: 'New Task', description: 'Task description', due_date: '2024-12-31', status: 'backlog' } }

      it "creates a new Task" do
        expect {
          post :create, params: { task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it "redirects to the created task" do
        post :create, params: { task: valid_attributes }
        expect(response).to redirect_to(Task.last)
        expect(flash[:notice]).to eq('Task was successfully created.')
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { title: '', description: '', due_date: '', status: '' } }

      it "does not create a new Task" do
        expect {
          post :create, params: { task: invalid_attributes }
        }.to change(Task, :count).by(0)
      end

      it "renders the new template" do
        post :create, params: { task: invalid_attributes }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let(:new_attributes) { { title: 'Updated Task', description: 'Updated description', due_date: '2025-01-01', status: 'done' } }

      it "updates the requested task" do
        patch :update, params: { id: task.id, task: new_attributes }
        task.reload
        expect(task.title).to eq('Updated Task')
        expect(task.description).to eq('Updated description')
        expect(task.due_date.to_date).to eq(Date.parse('2025-01-01'))
        expect(task.status).to eq('done')
      end

      it "redirects to the task" do
        patch :update, params: { id: task.id, task: new_attributes }
        expect(response).to redirect_to(task)
        expect(flash[:notice]).to eq('Task was successfully updated.')
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { title: '', description: '', due_date: '', status: '' } }

      it "renders the edit template" do
        patch :update, params: { id: task.id, task: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested task" do
      task_to_delete = create(:task, user: user)
      expect {
        delete :destroy, params: { id: task_to_delete.id }
      }.to change(Task, :count).by(-1)
    end

    it "redirects to the tasks list" do
      delete :destroy, params: { id: task.id }
      expect(response).to redirect_to(tasks_url)
      expect(flash[:notice]).to eq('Task was successfully destroyed.')
    end
  end
end
