class MonthlySummary < ApplicationRecord
  belongs_to :project

  validates :project_id, presence: true
  validates :year, presence: true, numericality: { only_integer: true, greater_than: 2000, less_than: 2100 }
  validates :month, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 13 }
  validates :total_duration, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :project_id, uniqueness: { scope: [:year, :month], message: "should have only one summary per month" }
end
