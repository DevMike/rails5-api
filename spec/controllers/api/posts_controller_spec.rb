require 'rails_helper'

RSpec.describe Api::PostsController, type: :controller do
  before do
    sign_in(auth_user)

    allow(controller).to receive(:update_auth_header).and_return(auth_header)
    allow(controller).to receive(:authenticate_api_user!)
  end

  let(:auth_user) { FactoryGirl.build(:user, :admin) }
  let(:auth_header) { { :'access-token' => 'some'} }

  describe "GET #index" do
    let!(:auth_user) { FactoryGirl.create(:user) }
    let!(:another_user) { FactoryGirl.create(:user, :with_posts) }

    context 'users exist' do
      subject { get :index, email: another_user.email }

      context 'not in blocked' do
        it "provides response with proper posts" do
          subject
          expect(JSON.parse(response.body).map{|m| m['id'] }).to match_array(another_user.posts.pluck(:id))
        end
      end

      context 'in blocked' do
        before do
          FactoryGirl.create(:friendship, friend: auth_user, user: another_user, state: 'blocked')
          subject
        end

        it 'has 404 status' do
          expect(response.status).to eq(404)
        end
      end
    end

    context "user doesn't exist" do
      before { get :index, email: 'some' }

      it 'has 404 status' do
        subject
        expect(response.status).to eq(404)
      end
    end
  end

  describe "POST #create" do
    subject { post :create, params: params }

    before { subject }

    context "with valid params" do
      let(:params) { { post: { text: 'hi!' } } }

      it "creates post with proper attributes" do
        _post = Post.last
        params[:post].each_pair do |attr, value|
          expect(_post.send attr).to eq(value)
        end
        expect(_post.user).to eq(auth_user)
      end

      it "has proper status" do
        expect(response.status).to eq(201)
      end
    end

    context "with invalid params" do
      let(:params) { { post: { body: nil } } }

      it "doesn't create a new record" do
        expect(Post.count).to be_zero
      end

      it "has proper status" do
        expect(response.status).to eq(422)
      end
    end
  end

end
