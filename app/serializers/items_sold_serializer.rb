class ItemsSoldSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name

  # attribute :name do |object|
  #   object.name
  # end

  has_many :items

  attribute :count do |object|
    object.items.size
  end
end
