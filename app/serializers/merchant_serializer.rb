class MerchantSerializer
  def self.format_merchants(merchants)
    { data: data(merchants) }
  end

  def self.data(merchants)
    merchants.map do |merchant|
      {
        id: merchant.id.to_s,
        type: 'merchant',
        attributes: { name: merchant.name }
      }
    end
  end
end
