class PostsController < ApplicationController


	before_filter :user_logged

	def index
		@post = Post.new
	  	render action: "new"
	end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
   # respond_to do |format|
    #  format.html  new.html.erb
   # end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
  	current_user = User.find(session[:user_id])
  	updated_at = current_user.posts.create!(params[:post]).updated_at
  	message = params[:post][:message]
  	@post = Post.new
	  if current_user.save
	    @notice = "Post successfully saved."
	    followers = current_user.followers()
	    puts followers.size()
	    for user in followers
	    	params =	URI.escape("/users/newMessage?id=#{user.id}&message=#{message}&updated_at=#{updated_at}")
	    	res = Net::HTTP.start('localhost', 5000) do |http|
				  http.get(params)
				end
	    end
	  else
	    @notice = "Error."
	  end
	  render action: "new" 
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private

  def user_logged
  	redirect_to "/home" unless session[:user_id]
  end

end
