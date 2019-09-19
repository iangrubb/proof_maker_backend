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

  def self.create_with_lines(stage_id: , stage_order: , goal_id: , subproof_id: , premises:, conclusion: )

    subproof = Subproof.create(stage_id: stage_id, stage_order: stage_order, goal_id: goal_id, subproof_id: subproof_id)

    conclusion = Line.create(stage_id: stage_id, subproof_id: subproof.id, stage_order: 1 + premises.length, goal_id: nil, sentence: conclusion)

    premises.each_with_index do |prem, idx|
      line = Line.create(stage_id: stage_id, subproof_id: subproof.id, stage_order: idx + 1, goal_id: conclusion.id, sentence: prem)
      Justification.create(stage_id: stage_id, rule: "premise", line_id: line.id)
    end

  end




    

    

    





end
