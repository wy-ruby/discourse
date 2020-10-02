class IntegralDetail < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic

  def self.integral_get_way
    @get_way = Enum.new(
        sponsor_reward: 0,
        acquire_reward: 1,
        post_topic: 2,
        reply_topic: 3,
        best_answer: 4,
        share_reward: 5,
        other_channels: 6
    )
  end
end
