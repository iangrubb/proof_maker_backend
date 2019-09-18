class Ptype < ApplicationRecord
    has_many :proofs
    has_many :users, through: :proofs
end
