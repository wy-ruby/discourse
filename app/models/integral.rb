class Integral < ActiveRecord::Base
  belongs_to :user

  POST_TOPIC_SCORE = 2
  REPLY_TOPIC_SCORE = 2
  BEST_REPLY_SCORE = 4
  POST_TOPIC_REWARD_NUM = 5
  REPLY_TOPIC_REWARD_NUM = 10
  PRIVATE_KEY = "89c9abe8003299da00fc2a40c81a12b1c599aaea5876db78dcea55e72"

  def self.increase_integral(user_id, topic_id, score, get_way, type)
    key = "#{user_id}_#{type}_num"
    num = Discourse.redis.get(key).to_i || 0
    if (type == "topic" && num < POST_TOPIC_REWARD_NUM) || (type == "reply" && num < REPLY_TOPIC_REWARD_NUM)
      Discourse.redis.set(key, num + 1)
      Discourse.redis.expireat(key, Time.parse("24:00").to_i)
      integral = self.find_or_create_by(user_id: user_id)
      integral.amount += score
      integral.save
      IntegralDetail.create(score: score, user_id: user_id, topic_id: topic_id, get_way: get_way)
    end
  end

  def self.increase_integral_unconditional(user_id, topic_id, score, get_way)
    integral = self.find_or_create_by(user_id: user_id)
    integral.amount += score
    integral.save
    IntegralDetail.create(score: score, user_id: user_id, topic_id: topic_id, get_way: get_way)
  end

end
