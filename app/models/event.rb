class Event < ApplicationRecord
  belongs_to :user

  validates :title, :description, :start_time, :end_time, presence: true
  validate :end_time_after_start_time

  scope :upcoming, -> { where("start_time >= ?", Time.now) }
  scope :past, -> { where("end_time <= ?", Time.now) }
  after_commit :clear_events_cache
  after_update :update_most_viewed_cache, if: :saved_change_to_views_count?


  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after the start time")
    end
  end


  def clear_events_cache
      Rails.cache.delete("events")
      Rails.cache.delete("events_#{id}")
  end


  def increment_views
      self.increment!(:views_count)
  end
  def update_most_viewed_cache
    Rails.cache.delete("most_viewed_events")
  end
end
