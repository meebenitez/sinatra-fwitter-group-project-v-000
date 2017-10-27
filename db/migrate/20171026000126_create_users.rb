class CreateUsers < ActiveRecord::Migration
<<<<<<< HEAD
  def up
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
    end
  end

  def down
        drop_table :users
    end
=======
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
    end
  end
>>>>>>> 2d0217ab2154911c8fa19b21ec7279b101a00cc9
end
