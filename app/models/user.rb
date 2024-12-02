class User < ApplicationRecord
    has_many :messages
    validates_uniqueness_of :username
    scope :all_except, ->(user) { where.not(id: user) }
    after_create_commit { broadcast_append_to "users" }

    def initialize(username)
        private_key = rand(2..(Rails.application.config.p-2))
        username[:private_key] = private_key
        username[:public_key] = (Rails.application.config.alpha ** private_key) % Rails.application.config.p
        super(username)
    end

    def decrypt(room, encrypted_message)
        other_user = Participant.where({room_id: room.id}).where.not(user: self)[0].user
        other_user = User.find(other_user.id)
        recievers_public_key = other_user.public_key
        session_key = (recievers_public_key ** self.private_key) % Rails.application.config.p
        inverse_session_key = inverse(session_key, Rails.application.config.p)
        decrypted_message = encrypted_message.to_i * inverse_session_key % Rails.application.config.p
        decrypted_message.to_s
    end

    def encrypt(room_id, decrypted_message)
        other_user = Participant.where({room_id: room_id}).where.not(user: self)[0].user
        other_user = User.find(other_user.id)
        recievers_public_key = other_user.public_key
        session_key = (recievers_public_key ** self.private_key) % Rails.application.config.p
        encrypted_message = (decrypted_message.to_i * session_key) % Rails.application.config.p
        encrypted_message.to_s
    end


    def inverse(a, b)
        remainder = [[a, b].max, [a, b].min]
        quotient = [nil, nil]
        s = [1, 0]
        t = [0, 1]
        i = 2
        while remainder[i-1] != 0
            remainder.push(remainder[i - 2] % remainder[i - 1])
            quotient.push((remainder[i - 2] - remainder[i]) / remainder[i - 1])
            s.push(s[i - 2] - quotient[i] * s[i - 1])
            t.push(t[i - 2] - quotient[i] * t[i - 1])
            i+=1
        end
        b_inverse = t[-2]
        b_inverse % [a, b].max
    end
end
  