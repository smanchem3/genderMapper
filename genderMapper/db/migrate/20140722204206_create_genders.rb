class CreateGenders < ActiveRecord::Migration
  def change
    create_table :genders do |t|
      t.text :name
      t.text :place
      t.string :gender

      t.timestamps
    end
  end
end
