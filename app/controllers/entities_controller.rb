class EntitiesController < ApplicationController
  before_action :set_entity, only: %i[show edit update destroy]

  # GET /entities or /entities.json
  def index
    @group = current_user.groups.includes(:entities).find(params[:group_id])
    @total_count = @group.entities.loaded? ? @group.entities.sum(&:amount) : @group.total_amount
  end

  # GET /entities/1 or /entities/1.json
  def show; end

  # GET /entities/new
  def new
    @group = current_user.groups.find(params[:group_id])
    @entity = Entity.new
  end

  # GET /entities/1/edit
  def edit; end

  # POST /entities or /entities.json
  def create
    @entity = Entity.new(entity_params.except(:group_ids, :group_id))

    entity_params[:group_ids].each do |group_id|
      @entity.groups << current_user.groups.select { |group| group.id == group_id.to_i }
    end

    respond_to do |format|
      if @entity.save
        format.html do
          redirect_to user_group_entities_path(current_user, params[:group_id]),
                      notice: 'Entity was successfully created.'
        end
        format.json { render :show, status: :created, location: @entity }
      else
        @group = current_user.groups.find(params[:group_id])
        flash.now[:alert] = @entity.errors.full_messages
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entities/1 or /entities/1.json
  def update
    respond_to do |format|
      if @entity.update(entity_params)
        format.html do
          redirect_to user_group_path(current_user, params[:group_id]), notice: 'Entity was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @entity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entities/1 or /entities/1.json
  def destroy
    @entity.destroy!

    respond_to do |format|
      format.html { redirect_to user_group_path(params[:group_id]), notice: 'Entity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_entity
    @entity = Entity.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def entity_params
    params.require(:entity).permit(:name, :amount, { group_ids: [] }, :author_id, :group_id).tap do |whitelisted|
      whitelisted[:group_ids].reject!(&:empty?)
    end
  end
end
