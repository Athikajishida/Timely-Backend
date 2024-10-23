class AddLinkToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :link, :string
  end
end
