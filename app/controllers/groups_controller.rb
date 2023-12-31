class GroupsController < ApplicationController
  before_action :set_group, only: %i[show edit update destroy]
  before_action :set_icons_array, only: %i[new edit]

  # GET /groups or /groups.json
  def index
    @groups = current_user.groups.includes(:entities)
    @total_count = @groups.sum do |group|
      group.entities.loaded? ? group.entities.sum(&:amount) : group.total_amount
    end
  end

  # GET /groups/1 or /groups/1.json
  def show; end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit; end

  # POST /groups or /groups.json
  def create
    @group = current_user.groups.build(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to user_groups_path(current_user), notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        set_icons_array
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to user_groups_path(current_user), notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy!

    respond_to do |format|
      format.html { redirect_to user_groups_path(current_user), notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def group_params
    params.require(:group).permit(:name, :icon)
  end

  def set_icons_array
    @icons_array = [
      { url: 'airplane.png', name: 'Travel' },
      { url: 'budget.png', name: 'Finance' },
      { url: 'cleaning.png', name: 'Finance' },
      { url: 'entertainment.png', name: 'Entertainment' },
      { url: 'food.png', name: 'Food' },
      { url: 'health.png', name: 'Health' },
      { url: 'shipping.png', name: 'Shipping' },
      { url: 'shopping.png', name: 'Shopping' },
      { url: 'taxes.png', name: 'Taxes' }
    ]
  end
end
