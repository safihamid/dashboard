class Section < ActiveRecord::Base
  belongs_to :user
  has_many :followers, dependent: :nullify
  has_many :students, through: :followers, source: :student_user

  validates :name, uniqueness: { scope: :user_id }
  validates :name, presence: true

  before_create :assign_code

  def assign_code
    self.code = random_text(6)
  end

private
  CHARS = ("A".."Z").to_a
  def random_text(len)
    str = ""
    len.times { |i| str << CHARS[rand(CHARS.length - 1)] }
    str
  end
end
