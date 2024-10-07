class DailySummary < ApplicationRecord
  belongs_to :project

  validates :project_id, presence: true
  validates :date, presence: true
  validates :total_duration, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :project_id, uniqueness: { scope: :date, message: "should have only one summary per day" }
end
