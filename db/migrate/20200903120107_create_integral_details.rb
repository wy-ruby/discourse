class CreateIntegralDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :integral_details do |t|
      t.integer :score, null:false, default: 0, comment: "分值"
      t.integer :topic_id, comment: "帖子的id,如果get_way字段为6的时候该id设置为null"
      t.integer :get_way, limit:1, comment:"0.发起的悬赏，1.获得的悬赏，2.发帖，3.回帖，4.回帖被采纳为最佳答案，5.分得奖励的，6.其他渠道"
      t.references :user
      t.timestamps
    end
  end
end
