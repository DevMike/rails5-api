require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  before do
    sign_in(auth_user)

    allow(controller).to receive(:update_auth_header).and_return(auth_header)
    allow(controller).to receive(:authenticate_api_user!)
  end

  let(:auth_user) { FactoryGirl.build(:user, :admin) }
  let(:auth_header) { { :'access-token' => 'some'} }

  describe "GET #index" do
    let!(:users) { FactoryGirl.create_list(:user, 2) }

    subject { get :index }

    it "provides response with proper users" do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response.map{|u| u['email']}).to eq(users.map(&:email))
    end
  end

  describe "GET #show" do
    let!(:user) { FactoryGirl.create(:user) }

    subject { get :show, params: {id: user.id} }

    it "provides response with proper user" do
      subject

      expect(response.body).to include_json(user.as_json(only: %i(id first_name last_name email role)))
    end
  end

  shared_context 'roles' do |act|
    shared_examples_for 'not permitted error' do
      it 'return proper status' do
        subject

        expect(response.status).to eq(401)
      end
    end

    context 'user' do
      context 'updates himself' do
        let(:auth_user) { user }

        it 'success' do
          subject

          expect(response.status).to eq(act == :update ? 200 : 401)
        end
      end

      context 'updates another user' do
        let(:auth_user) { FactoryGirl.create(:user, :user) }

        it_behaves_like 'not permitted error'
      end
    end
  end

  describe "PUT #update" do
    let!(:user) { FactoryGirl.create(:user, :user) }

    subject { put :update, params: { id: user.id, user: new_attributes } }

    context "with valid params" do
      let(:new_attributes) { { first_name: 'Ivan', last_name: 'Q', email: 'some@lk.lk', role: 'admin' } }

      it "updates proper attributes" do
        subject

        user.reload
        new_attributes.reject{|k,_| k == :role }.each_pair do |k, v|
          expect(user[k]).to eq(v)
        end

        expect(user.role).to eq('user')

        expect(response.body).to include_json(user.as_json(only: %i(id first_name last_name email role)).merge(auth_header))
      end

      include_context 'roles', :update
    end

    context 'with invalid params' do
      let(:new_attributes) { { email: 'wrong' } }

      it 'returns error' do
        subject

        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user) { FactoryGirl.create(:user, :user) }

    subject { delete :destroy, params: { id: user.id } }

    include_context 'roles', :destroy

    it 'removes user' do
      expect{ subject }.to change(User, :count).by(-1)
    end
  end
end
