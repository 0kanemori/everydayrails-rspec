module Api
	class NotesController < Api::ApplicationController

		def index
			@notes = current_user.notes
			render json: @notes
		end

		def show
			@note = Note.find(params[:id])
			render json: @note
		end

		def create
			@note = current_user.notes.new(note_params.merge(user: current_user))

			if @note.save
				render json: { status: :created }
			else
				render json: @note.errors, status: :unprocessable_entity
			end
		end

		private

		def note_params
      params.require(:note).permit(:message, :project_id)
    end
	end
end  