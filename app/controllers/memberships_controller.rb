class MembershipsController < ApplicationController
  before_filter :login_required
  load_and_authorize_resource
  
  def edit
  end
  
  def create
    @group = Group.find(params[:group_id])

    respond_to do |format|
      if Membership.request(current_person, @group)
        if @group.public?
          flash[:notice] = "You have joined to '#{@group.name}'"
        else
          flash[:notice] = 'Membership request sent!'
        end
        format.html { redirect_to(home_url) }
      else
        # This should only happen when people do something funky
        # like trying to join a group that has a request pending
        flash[:notice] = "Invalid membership"
        format.html { redirect_to(home_url) }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @membership.update_attributes(params[:membership])
        flash[:notice] = 'Membership was successfully updated.'
        format.html { redirect_to(members_group_path(@membership.group)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @membership.breakup
    
    respond_to do |format|
      flash[:success] = "You have left the group #{@membership.group.name}"
      format.html { redirect_to( person_url(current_person)) }
    end
  end
  
  def unsuscribe
    @membership.breakup
    
    respond_to do |format|
      flash[:success] = "You have unsuscribe '#{@membership.person.name}' from group '#{@membership.group.name}'"
      format.html { redirect_to(members_group_path(@membership.group)) }
    end
  end
  
  def suscribe
    @membership.accept
    PersonMailer.deliver_membership_accepted(@membership)

    respond_to do |format|
      flash[:success] = "You have accept '#{@membership.person.name}' for group '#{@membership.group.name}'"
      format.html { redirect_to(members_group_path(@membership.group)) }
    end
  end
end
