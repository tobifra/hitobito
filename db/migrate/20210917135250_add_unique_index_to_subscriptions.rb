class AddUniqueIndexToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    index_name = 'index_subscription_uniqueness' # generated name is too long
    add_index :subscriptions, [:mailing_list_id, :subscriber_type, :subscriber_id], unique: true, name: index_name
  end
end
