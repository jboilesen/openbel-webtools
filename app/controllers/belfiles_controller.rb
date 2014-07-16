require 'open-uri'
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
    ## Treating file upload (:belfile) or download from URL (:url)
    if !belfile_params[:belfile].nil?
      filename = belfile_params[:belfile].original_filename
      directory = "public/belfiles/"
      belfile_path = directory + filename
      if !File.exist?(belfile_path)
        @belfile.belfile_path = belfile_path
        path = File.join(directory, filename)
        File.open(path, "wb") { |f| f.write(belfile_params[:belfile].read) }
        @belfile.save
        redirect_to @belfile
      else

        redirect_to new_belfile_path
      end
    elsif !belfile_params[:url].nil?
      @belfile = Belfile.new
      @belfile.title = belfile_params[:title]
      @belfile.description = belfile_params[:description]
      ## Filename will be based on title
      filename = @belfile.title
      ## So, we sanitize it
      filename.gsub!(/^.*(\\|\/)/, '')
      filename.gsub!(/[^0-9A-Za-z.\-]/, '_')
      directory = 'public/belfiles/'
      filename = filename + '.txt'
      belfile_path = directory + filename
      ## If it not exists, create it
      if !File.exist?(belfile_path)
        @belfile.belfile_path = belfile_path
        path = File.join(directory, filename)
        open(path, 'wb') do |file|
          file << open(belfile_params[:url]).read
        end
        @belfile.save
        redirect_to @belfile
      else
        redirect_to new_belfile_path
      end
    else
      redirect_to new_belfile_path
    end
  end
private
  def belfile_params
    params.require(:belfile).permit(:title, :description, :belfile, :url)
  end
end
