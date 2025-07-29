class ApplicationController < ActionController::Base

  def hello
    render html: "hello,wirld!"
  end
end
