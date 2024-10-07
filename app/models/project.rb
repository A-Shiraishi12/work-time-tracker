class Project < ApplicationRecord
  has_many :time_logs
  has_many :daily_summaries
  has_many :monthly_summaries

  validates :project_name, presence: true, uniqueness: true, length: { maximum: 100 }
end
