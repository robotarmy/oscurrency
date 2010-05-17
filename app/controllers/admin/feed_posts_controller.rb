class Admin::FeedPostsController < ApplicationController
  before_filter :login_required, :admin_required
  active_scaffold :feed_post do |config|
    config.label = "Posts"
    config.columns = [:title, :date_published,  :content]
    config.list.columns = [:title, :date_published]
    config.columns[:date_published].form_ui = :calendar

    config.columns[:date_published].required = true
    config.columns[:title].required = true
    config.columns[:content].required = true
  end
end
