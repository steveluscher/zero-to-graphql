class GraphqlController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def query
    result_hash = Schema.execute(params[:query], variables: params[:variables])
    render json: result_hash
  end
end
