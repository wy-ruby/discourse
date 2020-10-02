class AddIntegralToTopics < ActiveRecord::Migration[6.0]
  def change
    add_column :topics, :reward_integral, :integer, default:0, comment: "悬赏的分值"
    add_column :topics, :accept_post_id, :integer, comment: "被发帖者采纳为最佳答案的回复id"
  end
end
