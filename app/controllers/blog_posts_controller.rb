class BlogPostsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_blog_post, except: [:index, :new, :create]

  def index
    @blog_posts = user_signed_in? ? BlogPost.sorted : BlogPost.published.sorted
  end

  def show

  end

  def new
    @blog_post = BlogPost.new
  end


  def create
    @blog_post = BlogPost.new(blog_post_params)
    if @blog_post.save
    redirect_to @blog_post
    else
    render :new, status: :unprocessable_entity
    flash.now[:error] = "Invalid entry"
    end
  end


  def edit
  end


  def update
    if @blog_post.update(blog_post_params)
      puts blog_post_params[:content]

    redirect_to @blog_post, flash: { success: "Blog post was successfully updated." }
  else
    render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog_post.destroy
    redirect_to blog_posts_path, flash: { success: "Blog post was successfully deleted." }
  end

  private

  def blog_post_params
    params.require(:blog_post).permit(:title, :content, :published_at)
  end

  def set_blog_post
    if user_signed_in?
      @blog_post = BlogPost.find(params[:id])
    else
      @blog_post = BlogPost.published.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end
end
