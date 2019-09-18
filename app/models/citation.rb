class Citation < ApplicationRecord
  belongs_to :justification
  belongs_to :citeable, polymorphic: true
end
