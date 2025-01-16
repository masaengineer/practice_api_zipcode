class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :zipcode, null: false
      t.string :prefecture, null: false
      t.string :city, null: false
      t.string :street, null: false
      t.string :building

      t.timestamps
    end

    add_index :addresses, :zipcode
  end
end
