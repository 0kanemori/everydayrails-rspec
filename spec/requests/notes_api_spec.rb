require 'rails_helper'

RSpec.describe "Notes Api", type: :request do
  # 1件のノートを読み出すこと
  it 'loads a note' do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project,
      name: "Sample Project",
      owner: user)
    FactoryBot.create(:note, 
      message: "Sample Note",
      project: project)
    
    get api_notes_path, params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json.length).to eq 1
    note_id = json[0]['id']

    get api_note_path(note_id), params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    expect(response).to have_http_status(:success) 
    json = JSON.parse(response.body)
    expect(json["message"]).to eq "Sample Note"
  end

  # ノートを作成できること
  it 'creates a note' do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user)
    note_attributes = FactoryBot.attributes_for(:note, project: project)
    expect {
      post api_notes_path, params: {
        user_email: user.email,
        user_token: user.authentication_token,
        note: note_attributes.merge(project_id: project.id)
      }
    }.to change(project.notes, :count).by(1)

    expect(response).to have_http_status(:success)
  end
end
