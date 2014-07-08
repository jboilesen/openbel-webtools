class BelfilesController < ApplicationController
  def new
  end
  def index
    @belfiles = Belfile.all
  end
  def show
    @belfile = Belfile.find(params[:id])
  end
  def create
    @belfile = Belfile.new
    @belfile.title = belfile_params[:title]
    @belfile.description = belfile_params[:description]
    @belfile.belfile = belfile_params[:belfile].read
    @belfile.url = belfile_params[:url]
    @belfile.save
    redirect_to @belfile
  end
private
  def belfile_params
    params.require(:belfile).permit(:title, :description, :belfile, :url)
  end
end
