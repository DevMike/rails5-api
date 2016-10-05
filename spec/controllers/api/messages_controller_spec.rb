require 'rails_helper'

RSpec.describe Api::MessagesController, type: :controller do
  before do
    sign_in(auth_user)

    allow(controller).to receive(:update_auth_header).and_return(auth_header)
    allow(controller).to receive(:authenticate_api_user!)
  end

  let(:auth_user) { FactoryGirl.build(:user, :admin) }
  let(:auth_header) { { :'access-token' => 'some'} }

  describe "GET #index" do
    let!(:auth_user) { FactoryGirl.create(:user, :with_messages) }
    let!(:another_user) { FactoryGirl.create(:user, :with_messages) }

    subject { get :index }

    before { subject }

    it "provides response with proper users" do
      expect(JSON.parse(response.body).map{|m| m['id'] }).to match_array(auth_user.messages.pluck(:id))
    end
  end

  describe "POST #create" do
    subject { post :create, params: params }

    before { subject }

    context "with valid params" do
      let(:params) { { message: { receiver_id: FactoryGirl.create(:user).id, body: 'hi!' } } }

      it "creates message with proper attributes" do
        message = Message.last
        params[:message].each_pair do |attr, value|
          expect(message.send attr).to eq(value)
        end
        expect(message.sender).to eq(auth_user)
      end

      it "has proper status" do
        expect(response.status).to eq(201)
      end
    end

    context "with invalid params" do
      let(:params) { { message: { body: nil } } }

      it "doesn't create a new record" do
        expect(Message.count).to be_zero
      end

      it "has proper status" do
        expect(response.status).to eq(422)
      end
    end
  end

end
