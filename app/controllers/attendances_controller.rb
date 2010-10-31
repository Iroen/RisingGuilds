class AttendancesController < ApplicationController
  filter_resource_access
  
  # GET /attendances
  # GET /attendances.xml
  def index
    @attendances = Attendance.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @attendances }
    end
  end

  # GET /attendances/1
  # GET /attendances/1.xml
  def show
    @attendance = Attendance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @attendance }
    end
  end

  # GET /attendances/new
  # GET /attendances/new.xml
  def new
    @attendance = Attendance.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @attendance }
    end
  end

  # GET /attendances/1/edit
  def edit
    @attendance = Attendance.find(params[:id])
  end

  # POST /attendances
  # POST /attendances.xml
  def create
    @attendance = Attendance.new(params[:attendance])

    respond_to do |format|
      unless @attendance.raid.closed?
      if @attendance.save
        flash[:notice] = t(:created, :item => 'Attendance')
        format.html { redirect_to guild_raid_path(@attendance.raid.guild,@attendance.raid) }
        format.xml  { render :xml => @attendance, :status => :created, :location => @attendance }
      else
        format.html { render :controller => "raid", :action => "show", :id => @attendance.raid.id }
        format.xml  { render :xml => @attendance.errors, :status => :unprocessable_entity }
      end
      else
        flash[:error] = t("raids.closed")
        format.html { redirect_to guild_raids_path(@attendance.raid.guild) }
      end
    end
  end

  # PUT /attendances/1
  # PUT /attendances/1.xml
  def update
    @attendance = Attendance.find(params[:id])

    respond_to do |format|
      unless @attendance.raid.closed?
        if @attendance.update_attributes(params[:attendance])
          flash[:notice] = t(:updated,:item => 'Attendance')
          format.html { redirect_to guild_raid_path(@attendance.raid.guild,@attendance.raid) }
          format.xml  { head :ok }
        else
          format.html {  render :controller => "raid", :action => "show", :id => @attendance.raid.id  }
          format.xml  { render :xml => @attendance.errors, :status => :unprocessable_entity }
        end
      else
        flash[:error] = t("raids.closed")
        format.html {  redirect_to guild_raids_path(@attendance.raid.guild) }
      end
    end
  end

  # DELETE /attendances/1
  # DELETE /attendances/1.xml
  def destroy
    @attendance = Attendance.find(params[:id])
    @attendance.destroy

    respond_to do |format|
      format.html { redirect_to(attendances_url) }
      format.xml  { head :ok }
    end
  end
  
  def approve
    @attendance = Attendance.find(params[:id])
    respond_to do |format|
      if @attendance.status == 2
        new_status = 3
      elsif @attendance.status == 3
        new_status = 2
      end
      if @attendance.update_attribute(:status,new_status)
        flash[:notice] = t(:updated,:item => 'Attendance')
        format.html { redirect_to guild_raid_path(@attendance.raid.guild, @attendance.raid) }
        format.xml  { head :ok }
      else
        flash[:error] = t(:error)
        format.html { redirect_to guild_raid_path(@attendance.raid.guild, @attendance.raid)  }
        format.xml  { render :xml => @attendance.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
