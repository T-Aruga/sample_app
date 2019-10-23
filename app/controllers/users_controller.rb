class UsersController < ApplicationController

before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                      :following, :followers]
before_action :correct_user,   only: [:edit, :update]
before_action :admin_user,     only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])          # Userを取り出して分割した値を@usersに代入
  end

  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])                                              # paramsで:idパラメータを受け取る(/users/1にアクセスしたら1を受け取る)
    @microposts = @user.microposts.paginate(page: params[:page])                # pageを受け取ってmicropostsに渡して表示する。
    redirect_to root_url and return unless @user.activated?                     # activatedがfalseならルートURLヘリダイレクト
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
  end
  
   def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
   end
   
   def destroy
      User.find(params[:id]).destroy
      flash[:success] = "User deleted"
      redirect_to users_url
   end
   
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    # beforeアクション

    def correct_user                                                            # 正しいユーザーかどうか確認
      @user = User.find(params[:id])                                            # URLのidの値と同じユーザーを@userに代入
      redirect_to(root_url) unless current_user?(@user)                         # @userと記憶トークンcookieに対応するユーザー(current_user)を比較して、失敗したらroot_urlへリダイレクト
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
