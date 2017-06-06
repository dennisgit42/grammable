require 'rails_helper'

RSpec.describe GramsController, type: :controller do

  describe "grams#destroy action" do
    it "should not allow unauthenticated users to destroy a gram" do
      gram = FactoryGirl.create(:gram)
      delete :destroy, params: { id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end
    it "should allow users to destroy grams" do
      gram = FactoryGirl.create(:gram)
      sign_in gram.user
      delete :destroy, params: {id: gram.id}
      expect(response).to redirect_to root_path
      gram = Gram.find_by(id: gram.id)
      expect(gram).to eq(nil)
    end
    it "should return 404 error if user tries to destroy gram with id that is not found in database" do
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, params: { id: "SPACEDUCK" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#edit action" do
    it "should not allow unauthenticated users to edit a gram" do
      gram = FactoryGirl.create(:gram)
      get :edit, params: { id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end
    it "should successfully show the edit form if gram is found" do
      gram = FactoryGirl.create(:gram)
      sign_in gram.user
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end
    it "should return 404 error if gram is not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, params: { id: "TACOCAT" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#update action" do
    it "should not allow unauthenticated users to update a gram" do
      gram = FactoryGirl.create(:gram)
      patch :update, params: { id: gram.id, gram: { message: "Hello!" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update existing grams" do
      gram = FactoryGirl.create(:gram, message: "initial value")
      sign_in gram.user
      patch :update, params: { id: gram.id, gram: { message: "Changed" } }
      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.message).to eq "Changed"
    end
    
    it "should have http 404 error if the gram cannot be found" do
      user = FactoryGirl.create(:user)
      sign_in user 
      patch :update, params: { id: "TACOCAT", gram: { message: "Changed" } }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity if update contains validation errors" do
      gram = FactoryGirl.create(:gram, message: "initial value")
      sign_in gram.user
      patch :update, params: { id: gram.id, gram: { message: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq("initial value")
    end
  end


  describe "grams#show action" do
    it "should successfully show the page if the gram is found" do
      gram = FactoryGirl.create(:gram)
      get :show, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return 404 error if the gram is not found" do
      get :show, params: {id: "TACOCAT"}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end


  describe "grams#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryGirl.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do
    it "should require users to be logged in" do
      post :create, params: { gram: { message: "Hello" } }
      expect(response).to redirect_to new_user_session_path

    end

    it "Should successfully submit the form contents as new gram in database." do
      user = FactoryGirl.create(:user) 
      sign_in user
      
      post :create, params: { gram: { message: 'Hello!' } }
      expect(response).to redirect_to root_path
      
      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors." do
      user = FactoryGirl.create(:user)
      sign_in user

      gram_count = Gram.count
      post :create, params: { gram: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(gram_count).to eq Gram.count
    end
  end

end
