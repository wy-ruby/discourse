class CreateIntegrals < ActiveRecord::Migration[6.0]
  def change
    create_table :integrals do |t|
      t.integer :amount, default: 0, comment: "用户的分数"
      t.references :user

      t.timestamps
    end
  end
end
