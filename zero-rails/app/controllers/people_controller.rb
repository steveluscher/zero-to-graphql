class PeopleController < ApplicationController
  def index
    render json: Person.all
  end
  def show
    render json: Person.find(params[:id])
  end
end
