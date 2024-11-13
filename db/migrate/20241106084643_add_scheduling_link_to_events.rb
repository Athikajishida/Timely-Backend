class AddSchedulingLinkToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :scheduling_link, :string
  end
end
