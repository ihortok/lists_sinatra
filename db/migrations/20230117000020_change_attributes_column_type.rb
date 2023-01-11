Sequel.migration do
  up do
    alter_table(:lists) { set_column_type(:item_attributes, 'json USING item_attributes::json') }
    alter_table(:items) { set_column_type(:attributes, 'jsonb USING attributes::jsonb') }
  end

  down do
    alter_table(:lists) { set_column_type(:item_attributes, 'varchar(255)') }
    alter_table(:items) { set_column_type(:attributes, 'varchar(255)') }
  end
end
