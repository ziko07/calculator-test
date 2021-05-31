class OperationsController < ApplicationController
  def new
    @operation = Operation.new
  end

  def create
    @operation = Operation.process(params)
    render json: @operation
  end
end
