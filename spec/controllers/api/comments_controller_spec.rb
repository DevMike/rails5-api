require 'rails_helper'

RSpec.describe Api::CommentsController, type: :controller do
  before do
    sign_in(auth_user)

    allow(controller).to receive(:update_auth_header).and_return(auth_header)
    allow(controller).to receive(:authenticate_api_user!)
  end

  let!(:auth_user) { create(:user, :with_posts) }
  let(:auth_header) { { :'access-token' => 'some'} }

  let!(:_post) { auth_user.posts.first }

  describe "POST #create" do
    subject { post :create, params: params }

    before { subject }

    context "with valid params" do
      let(:params) { { comment: { text: 'hi!' }, post_id: _post.id } }

      it "creates comment with proper attributes" do
        comment = Comment.last
        params[:comment].each_pair do |attr, value|
          expect(comment.send attr).to eq(value)
        end
        expect(comment.user).to eq(auth_user)
      end

      it "has proper status" do
        expect(response.status).to eq(201)
      end
    end

    context "with invalid params" do
      let(:params) { { comment: { text: nil }, post_id: _post.id } }

      it "doesn't create a new record" do
        expect(Comment.count).to be_zero
      end

      it "has proper status" do
        expect(response.status).to eq(422)
      end
    end
  end

end
