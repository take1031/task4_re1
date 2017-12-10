class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :current_user, only: [:edit, :update]
  before_action :set_current_user

def set_current_user
  @current_user = User.find_by(id: session[:user_id])
end

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.page(params[:page]).per(10)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find_by(id: params[:id])
    @user = User.find_by(id: @post.user_id)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
   
 
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: '投稿されました！' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: '投稿が更新されました！' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
    if @user.update_attributes(user_params)
      redirect_to @user
      flash[:success] = "プロフィールを更新しました"
    else
      render'edit'
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: '投稿が削除されました。' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :user_id, :image, :interest_list )
    end

    def correct_user
      post = Post.find(params[:id])
      if current_user.id != post.user_id
        redirect_to root_path
      end

      
    end
end
