class SearchesController < ApplicationController
  include ApplicationHelper

  before_filter :login_required

  def index
    
    redirect_to(home_url) and return if params[:q].nil?
    
    query = params[:q].strip
    model = params[:model]
    klass = nil
    if !model.blank?
      klass = model.constantize
      unless [Person, Req, Offer, Message, ForumPost].include?(klass)
       flash[:error] = "Invalid search"
       redirect_to home_url and return
      end
    end
    page  = params[:page] || 1

    @results = []
    for klass in klass ? [klass] : [Person, Req, Offer, Message, ForumPost]
      @results.concat(klass.search(query))
    end
    # I'd like to sort the list here, but each search comes back rank ordered and I hate to throw that away...we could sort by time though

    @page_results = @results.paginate(:page=> page, :per_page => 10)
  end
  
  private
    
end
