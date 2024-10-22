# frozen_string_literal: true

class AddPhonenumberToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :phonenumber, :string
  end
end
