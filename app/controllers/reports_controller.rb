class ReportsController < ApplicationController

  def show
    page = params[:id]
    render :template => "reports/#{params[:id]}"
  end

end
