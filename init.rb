require 'ruprint'

ActionController::Base.class_eval do

  helper Ruprint::Helpers

end
