Sequel.migration do
  change do
    add_column :lists, :description, String
  end
end
