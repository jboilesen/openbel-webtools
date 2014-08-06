class GraphsController < ApplicationController
  def new
  end
  def show
    @graph = Graph.find(params[:id])
  end
end
