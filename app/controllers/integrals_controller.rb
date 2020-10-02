class IntegralsController < ActionController::Base
  before_action :check_authorization
  before_action :check_user_info, except: :update_user
  # skip_before_action :verify_authenticity_token
  # 查询所有用户的积分
  def index
  end

  # 查询用户的积分
  def show
    @user_integral = Integral.find_or_create_by(user_id: params[:data][:id])
    data = {user_id: @user_integral.user_id, amount: @user_integral.amount, last_updated_time: @user_integral.updated_at.to_i }
    render json: { code: 200, message: "成功", data: data }
  end

  # 增减用户的积分
  def update
    id = params[:data][:id]
    score = params[:data][:score]
    @user_integral = Integral.find_or_create_by(user_id: id)
    if (@user_integral.amount + score.to_i) < 0
      render json: { code: 404, message: "该用户所剩积分不足" }
    else
      @user_integral.amount += score.to_i
      @user_integral.save
      IntegralDetail.create(score: score, user_id: id, topic_id: 0, get_way: IntegralDetail.integral_get_way[:other_channels])
      render json: { code: 200, message: '成功' }
    end
  end

  # 更新用户信息
  def update_user
    user_email = UserEmail.find_by_email(params[:data][:email])
    if user_email.present?
      user = user_email.user
      if params[:data][:phone_number].present?
        exist_user = User.find_by_phone_number(params[:data][:phone_number])
        if exist_user
          render json: { code: 406, message: "该手机号已经绑定到了其他账户下了" } and return
        else
          user.phone_number = params[:data][:phone_number]
        end
      end

      if params[:data][:username].present?
        exist_user = User.find_by_username(params[:data][:username])
        if exist_user
          render json: { code: 407, message: "该用户名已存在" } and return
        else
          user.username = params[:data][:username]
        end
      end
      user.password = params[:data][:password] if params[:data][:password].present?

      if user.save
        render json: { code: 200, message: '成功' }
      else
        message = user.errors.full_messages.join("\n")
        render json: { code: 405, message: message}
      end
    else
      render json: { code: 404, message: "该用户不存在" }
    end
  end

  protected

  def check_user_info
    @user = User.find_by(id: params[:data][:id])
    render json: { code: 404, message: "该用户不存在" } unless @user
  end

  def check_authorization
    for_sign_str = params[:data].to_s + Integral::PRIVATE_KEY
    params[:data] = JSON.parse(params[:data]).symbolize_keys
    sign_str = Digest::MD5.hexdigest(for_sign_str).downcase
    if sign_str != params[:sign]
      render json: { code: 401, message: "抱歉您无权操作" }
    end
  end

end
