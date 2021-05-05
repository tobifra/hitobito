class AddSalutationToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column(:messages, :salutation, :string)
  end
end
