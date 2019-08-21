class Event < ApplicationRecord
	validates :start_date, 
		presence: true
	validate :in_the_future?
  validates :duration,
    presence: true,
    numericality: { only_integer: true, greater_than: 0}
  validate :multiple_of_5?
  validates :title, 
  	presence: true, 
  	length: { in: 5..140 }
  validates :description, 
  	presence: true, 
  	length: { in: 20..1000 }
  validates :price, 
  	presence: true,
  	numericality: { only_integer: true,  in: 0..1000}
  validates :location, presence: true
  validates :event_pic,
    presence: true

	belongs_to :admin, class_name: "User"
	has_many :attendances, dependent: :destroy
  has_many :participants, through: :attendances
  has_one_attached :event_pic

  def end_date
    return self.start_date + self.duration*60
  end

  def convert(date)
    return date.strftime("%d/%m/%y à %H:%M")
  end

  def get_month
    month = ["", "JANV.", "FEV.", "MARS", "AVR.", "MAI", "JUIN", "JUIL.", "AOUT", "SEPT.", "OCT.", "NOV.", "DEC."]
    return month[self.start_date.month]
  end

  def short_description
    if self.description.length < 80
      return self.description
    else
      return self.description[0..80] + "..."
    end
  end

  def can_participate?(user)
    return !(user == nil || user == self.admin || self.participants.include?(user))
  end

  def participate?(user)
    return self.participants.include?(user)
  end

  def is_free?
    return self.price == 0
  end

  private

  def multiple_of_5?
  	#return self.duration % 5 == 0
  	if self.duration.present? && self.duration % 5 != 0
        errors.add(:duration, "must be multiple of 5")
    end
  end

  def in_the_future?
  	#return self.start_date > Time.now
  	if self.start_date.present? && self.start_date < Time.now
        errors.add(:start_date, "can't be in the past")
    end
  end
end


