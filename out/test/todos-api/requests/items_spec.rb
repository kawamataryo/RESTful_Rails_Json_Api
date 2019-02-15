require 'rails_helper'

describe 'Items API' do
  let!(:todo) {create(:dodo)}
  let!(:items) {create_list(:item, 20, todo_id: todo.id)}
  let(:todo_id) {todo.id}
  let(:id) {items.first.id}


  describe 'GET /todos/:todo_id/items' do
    before {get "/todos/#{todo_id}/items"}

    context 'TODOが既にある場合' do
      it '200が返ること' do
        expect(response).to have_http_status 200
      end

      it '全てのTODOが返る' do
        expect(json.size).to eq 20
      end
    end

    context 'TODOがない場合' do
      let(:id) {0}

      it '404が返ること' do
        expect(response).to have_http_status 404
      end

      it 'messageに404が含まれること' do
        expect(response.body).to match /Could't find Item/
      end
    end
  end

  describe 'POST /todos/:todo_id/items' do
    let(:valid_attributes) {{name: 'Visit Narnia', done: false}}

    context 'validなリクエストの場合' do
      before {post "/todos/#{todo_id}/items", params: valid_attributes}

      it '201が返ること' do
        expect(response).to have_http_status 201
      end
    end

    context 'invalidなリクエストの場合' do
      before {post "/todos/#{todo_id}/items", params: {}}

      it '422が返ること' do
        expect(response).to have_attributes 422
      end

      it 'messageにfailedが含まれること' do
        expect(response.body).to match /Validation failed: Name can't be blank/
      end
    end
  end

  describe 'PUT /todos/:todo_id/items/:id' do
    let(:valid_attributes) {{name: 'Mozart'}}

    before {put "/todos/#{todo_id}/items/#{id}", params: valid_attributes}

    context '既に投稿がある場合' do
      it '204が返ること' do
        expect(response).to have_http_status 204
      end

      it 'itemをupdateする' do
        updated_item = Item.find(id)
        expect(updated_item.name).to eq match /Mozart/
      end
    end

    context '投稿がない場合' do
      let(:id) {0}

      it '404が返ること' do
        expect(response).to have_http_status 404
      end

      it 'messageにnot foundが含まれること' do
        expect(response.body).to match /Couldn't find Item/
      end
    end
  end

  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}/items/#{id}"}

    it '204が返ること' do
      expect(response).to have_http_status 204
    end

  end
end
