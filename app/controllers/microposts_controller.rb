class MicropostsController < ApplicationController
  before_action :set_micropost, only: %i[ show edit update destroy ]
  before_action :logged_in_user, only: [ :create, :destroy ]
  before_action :correct_user, only: :destroy

  # GET /microposts or /microposts.json
  def index
    @microposts = Micropost.all
  end

  # GET /microposts/1 or /microposts/1.json
  def show
    @micropost = Micropost.find(params[:id])
  end

  # GET /microposts/new
  def new
    @micropost = Micropost.new
  end

  # GET /microposts/1/edit
  def edit
  end

  # POST /microposts or /microposts.json
  def create

    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    respond_to do |format|
      if @micropost.save
        flash[:success] = "Micropost created!"
        # redirect_to root_url
        format.html { redirect_to root_url, notice: "Micropost was successfully created." }
        format.json { render :show, status: :created, location: @micropost }
      else
        @feed_items = current_user.feed.paginate(page: params[:page])
        format.html { render "static_pages/home", status: :unprocessable_entity }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /microposts/1 or /microposts/1.json
  def update
    respond_to do |format|
      if @micropost.update(micropost_params)
        format.html { redirect_to @micropost, notice: "Micropost was successfully updated." }
        format.json { render :show, status: :ok, location: @micropost }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /microposts/1 or /microposts/1.json
  def destroy
    @micropost.destroy!
    flash[:success] = "Micropost deleted"
    respond_to do |format|
      if request.referrer.nil? || request.referrer == micropost_url
        format.html { redirect_to root_url, status: :ok, notice: "Micropost was successfully destroyed." }
      else
        format.html { redirect_to request.referrer, status: :see_other, notice: "Micropost was successfully destroyed." }
      end
    end
  end

  def react
    reaction_type = params[:reaction_type]
    @micropost = Micropost.find(params[:micropost_id])
    @existence_reaction = Reaction.find_or_initialize_by(user_id: current_user.id, micropost_id: @micropost.id)
    respond_to do |format|
      if @existence_reaction.persisted? && @existence_reaction.reaction_type == reaction_type
        format.html { redirect_to @micropost, status: :unprocessable_entity }
      else
        @existence_reaction.reaction_type = reaction_type
        if @existence_reaction.save!
          format.html { redirect_to @micropost, status: :created }
        else
          format.html { redirect_to @micropost, status: :unprocessable_entity }
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_micropost
      @micropost = Micropost.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def micropost_params
      params.require(:micropost).permit(:title, :content, :image)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
