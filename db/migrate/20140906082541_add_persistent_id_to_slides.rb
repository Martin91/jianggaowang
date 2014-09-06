class AddPersistentIdToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :persistent_id, :integer, after: :downloadable
  end
end
