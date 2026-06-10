class AddJtiToUsers < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :jti, :string

    # Preenche o jti dos usuários já existentes antes de tornar a coluna obrigatória
    execute "UPDATE users SET jti = gen_random_uuid()"

    change_column_null :users, :jti, false
    add_index :users, :jti, unique: true
  end

  def down
    remove_index :users, :jti
    remove_column :users, :jti
  end
end
