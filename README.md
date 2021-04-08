# Rails Engine

An E-Commerce Application with a service-oriented architecture. This software exposes data that powers the site through an API.

## Summary

  - [Getting Started](#getting-started)
  - [Runing the tests](#running-the-tests)
  - [Built With](#built-with)
  - [Authors](#authors)

## Getting Started

These instructions will get you a copy of the project up and running on
your local machine for development and testing purposes.

### Prerequisites

    Fork and clone this repo
    bundle install
    rails db:{drop,create,migrate,seed}

### Installing

1. Fork and clone the repo

2. Install the gem package

    `bundle install`

3. Create the database

    `rails db:create`

4. Migrate the existing Schema

    `rails db:migrate`

Optional: Seed the datebase
    `rails db:seed`

5. Run tests (See Runing the tests](#running-the-tests) section for more details)

    `bundle exec rspec`

6. Start localhostserver

    `rails s`

7. Access localhost server in browser

    `localhost:3000`


## Running the tests

1. All tests: insert `bundle exec rspec` in your terminal.
2. `request` tests only: insert `bundle exec rspec spec/requests` in your terminal.
3. `model` tests only: insert `bundle exec rspec spec/models` in your terminal.

### Break down into end to end tests

Below are two examples of a happy and sad path when trying to destroy an invoice.

    it 'can destory an invoice and invoice item' do
      expect{ delete "/api/v1/items/#{@item.id}" }.to change(Item, :count).by(-1)
      expect(response.status).to eq 204

      expect{Invoice.find(@invoice.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect{InvoiceItem.find(@invoice_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
    
    it 'cannot destory an invoice because it is linked to another item' do
      @item_2 = create(:item)
      @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice)
      
      expect{ delete "/api/v1/items/#{@item.id}" }.to change(Item, :count).by(-1)
      expect(response.status).to eq 204
      expect(Invoice.find(@invoice.id)).to eq(@invoice)
      expect(InvoiceItem.find(@invoice_item_2.id)).to eq(@invoice_item_2)
      expect{InvoiceItem.find(@invoice_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

### And coding style tests

* I used `RuboCop` - static code analyzer and code formatter
* Steps to install [RuboCop](https://github.com/rubocop/rubocop)

## Authors

  - [Angel Breaux](https://github.com/abreaux26)
