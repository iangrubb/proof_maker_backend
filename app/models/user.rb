class User < ApplicationRecord
    has_secure_password
    has_many :proofs
    has_many :ptypes, through: :proofs
end
