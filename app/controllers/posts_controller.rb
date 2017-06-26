class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:success] = "投稿完了"
      redirect_to post_url(@post)
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = "編集完了"
      redirect_to post_url(@post)
    else
      render 'index'
    end
  end

  def destroy
    Post.find(params[:id]).destroy
    flash[:success] = "削除完了"
    redirect_to posts_url
  end

  private
    def post_params
      params.require(:post).permit(:content, :picture)
    end
end
