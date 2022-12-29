Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :email, null: false
      String :password_digest, null: false
    end
  end
end
