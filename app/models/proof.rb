
def sentences_equal(x, y)
  if x['type'] == "atom" && y['type'] == "atom"
    x['letter'] == y['letter']
  elsif x['type'] == "contradiction" && y['type'] == "contradiction"
    true
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

  def goals
    self.lines.select{|line| !line.justification}
  end

  def initialize_elements

    stage = Stage.create(proof_id: self.id, parent_id: nil)

    Subproof.create_with_lines(stage_id: stage.id, stage_order: 1, goal_id: nil, subproof_id: nil, premises: self.ptype.sentences["premises"], conclusion: self.ptype.sentences["conclusion"])

  end


  # This will get redefined later for browsing.
  def current_stage
    self.stages.max_by{|s| s.number}
  end




  def fill(target_id: , goal_id: , method: , options: )

    next_stage = Stage.create(proof_id: self.id, parent_id: current_stage.id)

    target = self.lines.find{|line| line.id == target_id}
    goal = self.lines.find{|line| line.id == goal_id}

    if target_id == goal_id 

      # Intro Rules

      case method
      when "canon"
        case target.sentence["type"]
        when "conjunction"

          left = Line.create(stage_id: next_stage.id, subproof_id: goal.subproof_id, stage_order: 1, goal_id: goal_id, sentence: target.sentence["left"])
          
          right = Line.create(stage_id: next_stage.id, subproof_id: goal.subproof_id, stage_order: 2, goal_id: goal_id, sentence: target.sentence["right"] )

          Justification.create_with_citations(stage_id: next_stage.id, line_id: goal.id, rule: "conjunction introduction", citations: [{id: left.id, type: "Line"}, {id: right.id, type: "Line"}])
          
        when "disjunction"

          disjunct = goal.sentence[options[:side]]

          line = Line.create(stage_id: next_stage.id, subproof_id: goal.subproof_id, stage_order: 1, goal_id: goal_id, sentence: disjunct)
          
          Justification.create_with_citations(stage_id: next_stage.id, line_id: goal.id, rule: "disjunction introduction", citations: [{id: line.id, type: "Line"}])
  
        when "conditional"

          sub = Subproof.create_with_lines(stage_id: next_stage.id, stage_order: 1, goal_id: goal_id, subproof_id: goal.subproof_id, premises: [goal.sentence["left"]], conclusion: goal.sentence["right"])

          Justification.create_with_citations(stage_id: next_stage.id, line_id: goal.id, rule: "conditional introduction", citations: [{id: sub.id, type: "Subproof"}])

        when "negation"

          sub = Subproof.create_with_lines(stage_id: next_stage.id, stage_order: 1, goal_id: goal_id, subproof_id: goal.subproof_id, premises: [goal.sentence["right"]], conclusion: {type: "contradiction"})

          Justification.create_with_citations(stage_id: next_stage.id, line_id: goal.id, rule: "conditional introduction", citations: [{id: sub.id, type: "Subproof"}])

        when "contradiction"

          if target.sentence["type"] == "negation"
            opposite = target.sentence["right"]
          else
            opposite = {"type": "negation", "right": target.sentence}
          end

          line = Line.create(stage_id: next_stage.id, subproof_id: goal.subproof_id, stage_order: 1, goal_id: goal_id, sentence: opposite)

          Justification.create_with_citations(stage_id: next_stage.id, line_id: goal.id, rule: "negation elimination", citations: [{id: target_id, type: "Line"}, {id: line.id, type: "Line"}])
          
        end
      when "dne"

        line = Line.create(stage_id: next_stage.id, subproof_id: goal.subproof_id, stage_order: 1, goal_id: goal_id, sentence: {"type":"negation", "right": {"type":"negation", "right": goal.sentence}})

        Justification.create_with_citations(stage_id: next_stage.id, line_id: goal.id, rule: "double negation elimination", citations: [{id: line.id, type: "Line"}])

      when "reit"

        Justification.create_with_citations(stage_id: next_stage.id, line_id: goal_id, rule: "reiteration", citations: [{id: target_id, type: "Line"}])

      when "cont"

        Justification.create_with_citations(stage_id: next_stage.id, line_id: goal_id, rule: "explosion", citations: [{id: target_id, type: "Line"}])

      end

    else 
      # Elim Rules
      case target.sentence["type"]
      when "conjunction"

        conjunct = target.sentence[options[:side]]

        if sentences_equal(goal.sentence, conjunct)
          Justification.create_with_citations(stage_id: next_stage.id, line_id: goal.id, rule: "conjunction elimination", citations: [{id: target.id, type: "Line"}])
        else
          line = Line.create(stage_id: next_stage.id, subproof_id: goal.subproof_id, stage_order: 1, goal_id: goal_id, sentence: conjunct)
          Justification.create_with_citations(stage_id: next_stage.id, line_id: line.id, rule: "conjunction elimination", citations: [{id: line.id, type: "Line"}])
        end

      when "disjunction"

        leftproof = Subproof.create_with_lines(stage_id: next_stage.id, stage_order: 1, goal_id: goal_id, subproof_id: goal.subproof_id, premises: [target.sentence["left"]], conclusion: goal.sentence)

        rightproof = Subproof.create_with_lines(stage_id: next_stage.id, stage_order: 2, goal_id: goal_id, subproof_id: goal.subproof_id, premises: [target.sentence["right"]], conclusion: goal.sentence)

        Justification.create_with_citations(stage_id: next_stage.id, line_id: goal.id, rule: "disjunction elimination", citations: [{id: target_id, type: "Line"}, {id: leftproof.id, type: "Subproof"}, {id: rightproof.id, type: "Subproof"}])

      when "conditional"

        if !options[:minor_id]
          minor_id = Line.create(stage_id: next_stage.id, subproof_id: goal.subproof_id , stage_order: 1, goal_id: goal_id, sentence: target.sentence["left"]).id
        else
          minor_id = options[:minor_id]
        end

        if sentences_equal(goal.sentence, target.sentence["right"])
          Justification.create_with_citations(stage_id: next_stage.id, line_id: goal_id, rule: "conditional elimination", citations: [{id: minor_id, type:"Line"}, {id: target_id, type:"Line"}])
        else 
          line = Line.create(stage_id: next_stage.id, subproof_id: goal.subproof_id, stage_order: options[:minor_id] ? 1 : 2 , goal_id: goal_id, sentence: target.sentence["right"])
          Justification.create_with_citations(stage_id: next_stage.id, line_id: line.id, rule: "conditional elimination", citations: [{id: minor_id, type:"Line"}, {id: target_id, type:"Line"}])
        end

      when "negation"

        if !options[:minor_id]
          minor_id = Line.create(stage_id: next_stage.id, subproof_id: goal.subproof_id , stage_order: 1, goal_id: goal_id, sentence: target.sentence["right"]).id
        else
          minor_id = options[:minor_id]
        end

        if sentences_equal(goal.sentence, {type: "contradiction"})
          Justification.create_with_citations(stage_id: next_stage.id, line_id: goal_id, rule: "negation elimination", citations: [{id: minor_id, type:"Line"}, {id: target_id, type:"Line"}])
        else 
          line = Line.create(stage_id: next_stage.id, subproof_id: goal.subproof_id, stage_order: options[:minor_id] ? 1 : 2 , goal_id: goal_id, sentence: {type: "contradiction"})
          Justification.create_with_citations(stage_id: next_stage.id, line_id: line.id, rule: "negation elimination", citations: [{id: minor_id, type:"Line"}, {id: target_id, type:"Line"}])
        end

      when "contradiction"
        
        Justification.create_with_citations(stage_id: next_stage.id, line_id: goal_id, rule: 'explosion', citations: [{id: target_id, type: "Line"}])

      end
    end
  end
end
