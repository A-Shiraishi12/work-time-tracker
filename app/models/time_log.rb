class TimeLog < ApplicationRecord
  belongs_to :project

  validates :project_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true, comparison: { greater_than: :start_time }
  validates :duration, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :duration_matches_time_difference

  after_create :update_summaries
  after_update :update_summaries

  private

    def duration_matches_time_difference
      if start_time && end_time && duration
        calculated_duration = (end_time - start_time).to_i
        if calculated_duration != duration
          errors.add(:duration, "must match the time difference between start and end times")
        end
      end
    end

    def update_summaries
      update_daily_summary
      update_monthly_summary
    end

    def update_daily_summary
      summary = DailySummary.find_or_create_by(project: project, date: start_time.to_date)
      summary.update(total_duration: project.time_logs.where("DATE(start_time) = ?", start_time.to_date).sum(:duration))
    end

    def update_monthly_summary
      summary = MonthlySummary.find_or_create_by(project: project, year: start_time.year, month: start_time.month)
      summary.update(total_duration: project.time_logs.where("EXTRACT(YEAR FROM start_time) = ? AND EXTRACT(MONTH FROM start_time) = ?", start_time.year,
                                                             start_time.month).sum(:duration))
    end
end
