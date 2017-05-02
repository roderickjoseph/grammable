require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe '.create' do
    context 'without a user' do
      let(:gram) { FactoryGirl.create :gram }

      it 'requires user to be logged in to comment on a gram' do
        post :create, params: { gram_id: gram.id, comment: { message: 'test' } }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with a logged in user' do
      let(:user) { FactoryGirl.create :user }
      let(:gram) { FactoryGirl.create :gram }

      before { sign_in user }

      it 'allows users to create comments on a gram' do
        post :create, params: { gram_id: gram.id, comment: { message: 'testa' } }

        expect(response).to redirect_to root_path
        expect(gram.comments.length).to eq 1
        expect(gram.comments.first.message).to eq 'testa'
      end

      it "returns status of 'not found' if the gram is not found" do
        post :create, params: { gram_id: 'test', comment: { message: 'testy' } }

        expect(response).to have_http_status :not_found
      end
    end
  end
end
