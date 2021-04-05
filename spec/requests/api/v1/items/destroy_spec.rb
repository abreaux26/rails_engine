require 'rails_helper'
RSpec.describe 'Destroy Item API' do
  before :each do
    @item = create(:item)
    @invoice = create(:invoice)

    @invoice_item = create(:invoice_item, item: @item, invoice: @invoice)
  end

  describe 'happy path' do
    it "can destroy an item" do
      expect{ delete "/api/v1/items/#{@item.id}" }.to change(Item, :count).by(-1)

      expect(response).to be_successful
      expect(response.status).to eq 204
      expect{Item.find(@item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'can destory an invoice' do
      expect{ delete "/api/v1/items/#{@item.id}" }.to change(Item, :count).by(-1)
      expect(response.status).to eq 204

      expect{Invoice.find(@invoice.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect{InvoiceItem.find(@invoice_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'sad path' do
    it 'cannot destory an invoice because it is linked to another item' do
      @item_2 = create(:item)
      @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice)

      expect{ delete "/api/v1/items/#{@item.id}" }.to change(Item, :count).by(-1)
      expect(response.status).to eq 204

      expect(Invoice.find(@invoice.id)).to eq(@invoice)
      expect(InvoiceItem.find(@invoice_item_2.id)).to eq(@invoice_item_2)
      expect{InvoiceItem.find(@invoice_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
