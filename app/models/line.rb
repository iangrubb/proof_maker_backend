class Line < ApplicationRecord
  belongs_to :stage
  belongs_to :subproof
  belongs_to :goal, class_name: "Line", foreign_key: "goal_id", optional: true

  has_many :citations, as: :citeable
  has_many :justifications, through: :citations

  has_many :antecedent_proofs, class_name: "Subproof", foreign_key: "goal_id"
  has_many :antecedent_lines, class_name: "Line", foreign_key: "goal_id"

  def antecedents
    self.antecedent_proofs + self.antecedent_lines
  end

  has_one :justification


end
