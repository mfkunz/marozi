class PhoneNumber
  include Mongoid::Document

  field :type, type: String
  field :phone_number, type: String
end
