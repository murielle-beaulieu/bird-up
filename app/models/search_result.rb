class SearchResult < ApplicationRecord
  broadcasts_refreshes # When CRUD happens to a record, it will broadcast a page refresh to anyone listening
  after_update_commit -> { broadcast_replace_to self, partial: "search_results/search_result", locals: { search_result: self } }

  belongs_to :photo
  belongs_to :user
  has_many :search_result_birds, dependent: :destroy
  has_many :birds, through: :search_result_birds

  enum :status, { searching: 0, success: 1, failed: 2 }

  after_create :run_async_ai_lookup_job

  private

  def run_async_ai_lookup_job
    AiPhotoLookupJob.perform_later(self)
  end
end
