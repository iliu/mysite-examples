class HomeController < ApplicationController
  def index
    #Load facebook.yml info
    config = YAML::load(File.open("#{RAILS_ROOT}/config/facebook.yml"));

    #Instantiate a new application with our app_id so we can get an access token
    my_app = FbGraph::Application.new(config['production']['app_id']);

    #Actually get the access token
    acc_tok = my_app.get_access_token(config['production']['client_secret']);

    #Instantiate a new page class using the page_id specified 
    @page = FbGraph::Page.new(config['production']['page_id'], :access_token => acc_tok).fetch;

    #Grab the events from the page 
    events = @page.events.sort_by{|e| e.start_time};
    
    #Get the events that are upcoming
    @upcoming_events = events.find_all{|e| e.start_time >= Time.now};

    #Get the events that have passed
    @past_events = events.find_all{|e| e.start_time < Time.now}.reverse;
  end
end
