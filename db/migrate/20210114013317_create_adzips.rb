class CreateAdzips < ActiveRecord::Migration[6.1]
  def change
    create_table :adzips do |t|
      t.string :zipcode
      t.string :kana1
      t.string :kana2
      t.string :kana3
      t.string :address1
      t.string :address2
      t.string :address3

      t.timestamps
      
      t.index :zipcode
      t.index :address3
    end
  end
end
