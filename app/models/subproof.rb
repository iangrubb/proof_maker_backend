class Subproof < ApplicationRecord
  belongs_to :stage
  belongs_to :subproof, class_name: "Subproof", foreign_key: "subproof_id", optional: true
  belongs_to :goal, class_name: "Line", foreign_key: "goal_id", optional: true

  has_many :subproofs
  has_many :lines

  def elements 
    self.subproofs + self.lines
  end

  has_many :citings, as: :citeable
  has_many :justifications, through: :citings
end
