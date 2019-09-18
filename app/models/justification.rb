class Justification < ApplicationRecord
  belongs_to :stage
  belongs_to :line

  has_many :citations
  has_many :citeables, through: :citations

  # Each citation is of the form {id: type: }, where the types are "Line" and "Subproof"
  def self.create_with_citations(stage_id: , line_id: , rule: , citations: )
    just = Justification.create(stage_id: stage_id, line_id: line_id, rule: rule)
    citations.each_with_index{|cite, idx| Citation.create(justification_id: just.id, citeable_id: cite[:id], citeable_type: cite[:type], citation_order: idx + 1)}
  end

end
