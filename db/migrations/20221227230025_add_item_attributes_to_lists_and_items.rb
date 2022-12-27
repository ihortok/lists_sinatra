Sequel.migration do
  change do
    add_column :lists, :item_attributes, String
    add_column :items, :attributes, String
  end
end
