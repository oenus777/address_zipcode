module Types
  class AdzipType < Types::BaseObject
    field :id, ID, null: false
    field :zipcode, String, null: true
    field :kana1, String, null: true
    field :kana2, String, null: true
    field :kana3, String, null: true
    field :address1, String, null: true
    field :address2, String, null: true
    field :address3, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
