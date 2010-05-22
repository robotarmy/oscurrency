class ReportsController < ApplicationController

  before_filter :login_required, :admin_required

  def show
    page = params[:id]
    render :template => "reports/#{params[:id]}"
  end

end
