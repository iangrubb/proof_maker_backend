class Stage < ApplicationRecord
  belongs_to :proof
  belongs_to :parent, class_name: "Stage", foreign_key: "parent_id", optional: true

  has_many :subproofs
  has_many :lines
  has_many :justifications

  def elements
    self.subproofs + self.lines + self.justifications
  end

  def number
    if self.parent
      self.parent + 1
    else
      1
    end
  end



end
