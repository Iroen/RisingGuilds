class RaidsController < ApplicationController
  filter_resource_access
  
  before_filter :setup_raidicons, :only => [:edit, :new]
  before_filter :setup_guild_id
  
  layout :choose_layout
  
  # GET /raids
  # GET /raids.xml
  def index
    params[:sort] = 'guild_id, start' if params[:sort].nil?
    
    @guild = Guild.find(params[:guild_id]) unless params[:guild_id].nil?
    
    filter_keys = ['guild_id', 'start', 'closed']
    conditions = Hash.new
    conditions.merge!(params)
    conditions.delete_if {|key,value| !filter_keys.include? key}
    
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    
    if conditions.empty? then
      @raids = Raid.with_permissions_to(:view).find(:all, :order => params[:sort])
    else
      @raids = Raid.with_permissions_to(:view).find(:all, :order => params[:sort], :conditions => conditions)
    end
    
    @upcomming_raids = @raids.find_all{|raid| raid.invite_start > Time.now}  #(:all, :conditions => "invite_start > #{Time.now}")
    @past_raids = @raids.find_all{|raid| raid.end <= Time.now} #(:all, :conditions => "end <= #{Time.now}")
    @running_raids = @raids.find_all{|raid| raid.start < Time.now && raid.end > Time.now} #(:all, :conditions => "start < #{Time.now} AND end > #{Time.now}")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @raids }
    end
  end

  # GET /raids/1
  # GET /raids/1.xml
  def show
    
    unless @raid.attendances.nil? || @raid.attendances.empty?
      @attendance = @raid.attendances.find_by_character_id(current_user.characters.collect{|c| c.id})
    else
      @attendance = Attendance.new(:raid_id => @raid.id)
    end 
    @guild = @raid.guild
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @raid }
    end
  end

  # GET /raids/new
  # GET /raids/new.xml
  def new
    @raid.guild_id = @guild.id
  	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @raid }
    end
  end

  # GET /raids/1/edit
  def edit

  end

  # POST /raids
  # POST /raids.xml
  def create

    respond_to do |format|
      if @raid.save
        flash[:notice] = 'Raid was successfully created.'
        format.html { redirect_to("/guilds/#{@raid.guild.id}/raids/#{@raid.id}") }
        format.xml  { render :xml => @raid, :status => :created, :location => @raid }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @raid.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /raids/1
  # PUT /raids/1.xml
  def update

    respond_to do |format|
      if @raid.update_attributes(params[:raid])
        flash[:notice] = 'Raid was successfully updated.'
        format.html { redirect_to(@raid) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @raid.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /raids/1
  # DELETE /raids/1.xml
  def destroy
    @raid.destroy

    respond_to do |format|
      format.html { redirect_to(raids_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def setup_raidicons
    raid_icons_files = Dir.entries(RAILS_ROOT + "/public/images/icons/raid").reject {|f| f[0,1] == "." || f == "nil.png"} 
  	@raid_icons = {}
  	raid_icons_files.each{|f| @raid_icons[f.chomp(".png")] = f}
  end
  
  def setup_guild_id
    @guild = Guild.find(params[:guild_id]) unless params[:guild_id].nil?
  end
  
  def choose_layout
    unless params[:guild_id].nil?
      return 'guild_tabs'
    else
      return 'application'
    end
  end
  
end
