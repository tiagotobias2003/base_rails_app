class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :full_name
      t.string :cpf
      t.string :rg
      t.string :rg_issuer
      t.date :birth_date
      t.integer :gender
      t.string :phone
      t.string :mobile_phone
      t.string :mother_name
      t.string :nationality
      t.integer :marital_status
      t.string :cep
      t.string :street
      t.string :number
      t.string :complement
      t.string :neighborhood
      t.string :city
      t.string :state

      t.timestamps
    end

    add_index :profiles, :user_id, unique: true
    add_index :profiles, :cpf, unique: true
  end
end
