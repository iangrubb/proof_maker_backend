
def sentences_equal(x, y)
  if x['type'] == "atom" && y['type'] == "atom"
    x['letter'] == y['letter']
  elsif x['type'] == "negation" && y['type'] == "negation"
    sentences_equal(x['right'], y['right'])
  elsif x['type'] == y['type']
    sentences_equal(x['left'], y['left']) && sentences_equal(x['right'], y['right'])
  else
    false
  end
end


class Proof < ApplicationRecord
  belongs_to :user
  belongs_to :ptype
  has_many :stages

  has_many :lines, through: :stages
  has_many :subproofs, through: :stages
  has_many :justifications, through: :stages


  after_create :initialize_elements

  def initialize_elements

    stage = Stage.create(proof_id: self.id, parent_id: nil)

    subproof = Subproof.create(stage_id: stage.id, stage_order: 1, goal_id: nil, subproof_id: nil)

    conclusion = Line.create(stage_id: stage.id, subproof_id: subproof.id, stage_order: 1 + self.ptype.sentences["premises"].length, goal_id: nil, sentence: self.ptype.sentences["conclusion"])

    self.ptype.sentences["premises"].each_with_index{|prem, idx| Line.create(stage_id: stage.id, subproof_id: subproof.id, stage_order: idx + 1, goal_id: conclusion.id, sentence: prem)}

  end


  # This will get redefined later for browsing.
  def current_stage
    self.stages.max_by{|s| s.number}
  end




  def fill(target_id: , goal_id:, method: , options: )

    next_stage = Stage.create(proof_id: self.id, parent_id: current_stage.id)

    target = Proof.lines.find_by{|line| line.id == target_id}
    goal = Proof.lines.find_by{|line| line.id == goal_id}

    if target_id == goal_id 

      # Intro Rules

      case method
      when "canon"
        case target.sentence.type
        when "conjunction"
          
        when "disjunction"
  
        when "conditional"

        when "negation"
          
        end
      when "dne"

      when "reit"

      when "cont"

      end



    else 
      # Elim Rules
      case target.sentence.type
      when "conjunction"
        conjunct = target.sentence[options[:side]]
        # Either make a new line or fill in goal justification.
        if sentences_equal(goal.sentence, conjunct)
          Justification.create_with_citations(stage_id: next_stage.id, line_id: goal.id, rule: "conjunction elimination", citations: [{id: target.id, type: "Line"}])
        else
          line = Line.create(stage_id: next_stage.id, subproof_id: goal.subproof_id, stage_order: 1, goal_id: goal_id)
          Justification.create_with_citations(stage_id: next_stage.id, line_id: line.id, rule: "conjunction elimination", citations: [{id: line.id, type: "Line"}])
        end


      when "disjunction"

      when "conditional"

      when "negation"

      end
    end
  end
end
