Sequel.migration do
  change do
    alter_table(:lists) { add_foreign_key :user_id, :users, null: false }
    alter_table(:items) { add_foreign_key :user_id, :users, null: false }
  end
end
