class PlatformLinkToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :platform, :integer, default: 0, null: false
    add_column :events, :customlink, :string
  end
end
