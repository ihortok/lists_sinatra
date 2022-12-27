Sequel.migration do
  change do
    create_table(:items) do
      primary_key :id
      String :name, null: false
      foreign_key :list_id, :lists, null: false
    end
  end
end
