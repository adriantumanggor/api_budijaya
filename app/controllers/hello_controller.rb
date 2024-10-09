# app/controllers/hello_controller.rb

class HelloController < ApplicationController
  def index
    render plain: "Hello, World"
  end
end