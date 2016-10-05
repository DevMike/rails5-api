require 'rails_helper'

RSpec.describe Api::FriendshipsController, type: :controller do
  before do
    sign_in(auth_user)

    allow(controller).to receive(:update_auth_header).and_return(auth_header)
    allow(controller).to receive(:authenticate_api_user!)
  end

  let(:auth_user) { FactoryGirl.build(:user, :admin) }
  let(:auth_header) { { :'access-token' => 'some'} }

  describe "GET #index" do
    let!(:auth_user) { FactoryGirl.create(:user, :with_friends) }
    let!(:another_user) { FactoryGirl.create(:user, :with_messages) }

    subject { get :index }

    before { subject }

    it "provides response with proper friends" do
      expect(JSON.parse(response.body).map{|m| m['id'] }).to match_array(auth_user.all_friends.pluck(:id))
    end
  end

  describe "POST #create" do
    subject { post :create, params: params }

    before { subject }

    context "friend doesn't exist" do
      context "with valid params" do
        let(:params) { { friendship: { friend_id: FactoryGirl.create(:user).id, state: 'blocked' } } }

        it "creates friend with proper attributes" do
          friend = Friendship.last
          params[:friendship].each_pair do |attr, value|
            expect(friend.send attr).to eq(value)
          end
          expect(friend.user).to eq(auth_user)
        end

        it "has proper status" do
          expect(response.status).to eq(201)
        end
      end

      context "with invalid params" do
        let(:params) { { friendship: { friend_id: nil } } }

        it "doesn't create a new record" do
          expect(Friendship.count).to be_zero
        end

        it "has proper status" do
          expect(response.status).to eq(422)
        end
      end
    end

    context 'friend exists' do
      context 'block' do
        let!(:auth_user) { FactoryGirl.create(:user, :with_friends) }

        let(:params) { { friendship: { friend_id: auth_user.friendships.first.friend_id, state: 'blocked' } } }

        it "update friend with proper attributes" do
          friend = Friendship.last
          params[:friendship].each_pair do |attr, value|
            expect(friend.send attr).to eq(value)
          end
          expect(friend.user).to eq(auth_user)
        end

        it "doesn't create a new record" do
          expect { subject }.not_to change(Friendship, :count)
        end
      end

      context 'friend' do
        let!(:auth_user) { FactoryGirl.create(:user, :with_blocked_friends) }

        let(:params) { { friendship: { friend_id: auth_user.blocked_friendships.first.friend_id, state: 'blocked' } } }

        it "doesn't create a new record" do
          expect { subject }.not_to change(Friendship, :count)
        end

        it "has proper status" do
          expect(response.status).to eq(403)
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:auth_user) { FactoryGirl.create(:user, :with_friends) }

    subject { delete :destroy, params: params }

    context 'valid attributes' do
      let(:params) { { id: auth_user.friendships.first.id } }

      it 'destroys friendship' do
        expect { subject }.to change(Friendship, :count).by(-1)
      end

      it 'provides successful response' do
        subject

        expect(response.status).to eq(204)
      end
    end

    context 'invalid attributes' do
      let!(:another_user) { FactoryGirl.create(:user, :with_friends) }
      let(:params) { { id: another_user.friendships.first.id } }

      it 'destroys friendship' do
        expect { subject }.to_not change(Friendship, :count)
      end

      it 'provides successful response' do
        subject

        expect(response.status).to eq(404)
      end
    end
  end

end
