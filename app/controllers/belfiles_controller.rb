require 'open-uri'
require 'json'
require 'bel'

class BelfilesController < ApplicationController
  respond_to :html, :json
  
  BELFILES_FOLDER = "public/belfiles/"
  def build_graph(graph, statement)
    if graph.is_a?(Graph) && statement.is_a?(Statement)

      ## 1. identify statement type
      ## 2. find nodes and, if they don't exist, create them
      ## 3. create edges following each case rules
      if statement.simple?
        # Statement subject
        @source_node = Node.find_by('label' => "#{statement.subject}")
        if @source_node.blank?
          @source_node = Node.new
          @source_node.label = "#{statement.subject}"
          @source_node.fx = "#{statement.subject.fx}"
          @source_node.graph = graph
          @source_node.save
        end
        # Statement object
        @target_node = Node.find_by('label' => "#{statement.object}")
        if @target_node.blank?
          @target_node = Node.new
          @target_node.label = "#{statement.object}"
          @target_node.fx = "#{statement.object.fx}"
          @target_node.graph = graph
          @target_node.save
        end
        ## In a simple statement, edges simply connect subject to object
        @edge = Edge.new
        @edge.label = "#{statement.relationship}"
        @edge.source = @source_node
        @edge.target = @target_node
        @edge.graph = graph
        @edge.save
      elsif statement.nested?
        # Statement subject node
        @statement_subject_node = Node.find_by('label' => "#{statement.subject}")
        if @statement_subject_node.blank?
          @statement_subject_node = Node.new
          @statement_subject_node.label = "#{statement.subject}"
          @statement_subject_node.fx = "#{statement.subject.fx}"
          @statement_subject_node.graph = graph
          @statement_subject_node.save
        end

        # Statement object subject node
        @statement_object_subject_node = Node.find_by('label' => "#{statement.object.subject}")
        if @statement_object_subject_node.blank?
          @statement_object_subject_node = Node.new
          @statement_object_subject_node.label = "#{statement.object.subject}"
          @statement_object_subject_node.fx = "#{statement.object.subject.fx}"
          @statement_object_subject_node.graph = graph
          @statement_object_subject_node.save
        end
        
        # Statement object object node
        @statement_object_object_node = Node.find_by('label' => "#{statement.object.object}")
        if @statement_object_object_node.blank?
          @statement_object_object_node = Node.new
          @statement_object_object_node.label = "#{statement.object.object}"
          @statement_object_object_node.fx = "#{statement.object.object.fx}"
          @statement_object_object_node.graph = graph
          @statement_object_object_node.save
        end
        ## In nested statements, edges connect inner object subject to its object
        @object_subject_to_object_edge = Edge.new
        @object_subject_to_object_edge.label = "#{statement.object.relationship}"
        @object_subject_to_object_edge.source = @statement_object_subject_node
        @object_subject_to_object_edge.target = @statement_object_object_node
        @object_subject_to_object_edge.graph = graph
        @object_subject_to_object_edge.save

        ## And then edges connect statement subject to inner object subject...
        @statement_subject_to_subject_edge = Edge.new
        @statement_subject_to_subject_edge.label = "#{statement.relationship}"
        @statement_subject_to_subject_edge.source = @statement_subject_node
        @statement_subject_to_subject_edge.target = @statement_object_subject_node
        @statement_subject_to_subject_edge.graph = graph
        @statement_subject_to_subject_edge.save
        ## ...and to inner object object
        @statement_subject_to_object_edge = Edge.new
        @statement_subject_to_object_edge.label = "#{statement.relationship}"
        @statement_subject_to_object_edge.source = @statement_subject_node
        @statement_subject_to_object_edge.target = @statement_object_object_node
        @statement_subject_to_object_edge.graph = graph
        @statement_subject_to_object_edge.save
      elsif statement.subject_only?
        ## Statement subject
        @subject_statement_node = Node.find_by('label' => "#{statement.subject}")
        if @subject_statement_node.blank?
          @subject_statement_node = Node.new
          @subject_statement_node.label = "#{statement.subject}"
          @subject_statement_node.fx = "#{statement.subject.fx}"
          @subject_statement_node.graph = graph
          @subject_statement_node.save
        end

        ## Edges connect statement subject to its arguments
        statement.subject.arguments.each do |argument|
          @subject_statement_argument_node = Node.find_by('label' => "#{argument}")
          if @subject_statement_argument_node.blank?
            @subject_statement_argument_node = Node.new
            @subject_statement_argument_node.label = "#{argument}"
            @subject_statement_argument_node.graph = graph
            @subject_statement_argument_node.save
          end
          @subject_statement_edge = Edge.new
          @subject_statement_edge.label = "hasComponent"
          @subject_statement_edge.source = @subject_statement_node
          @subject_statement_edge.target = @subject_statement_argument_node
          @subject_statement_edge.graph = graph
          @subject_statement_edge.save
        end
      end
    end
  end

  def new
  end

  def index
    @belfiles = Belfile.all
  end

  def show
    @belfile = Belfile.find(params[:id])
  end

  def graph
    @belfile = Belfile.find(params[:id])
    @graph = @belfile.graph
  end
  def create
    @belfile = Belfile.new
    @belfile.title = belfile_params[:title]
    @belfile.description = belfile_params[:description]
    @graph = Graph.new
    @graph.label = @belfile.title
    @graph.directed = true
    @graph.belfile = @belfile
    ## Treating file upload (:belfile) or download from URL (:url)
    if !belfile_params[:belfile].nil?
      filename = belfile_params[:belfile].original_filename
      belfile_path = BELFILES_FOLDER + filename
      if !File.exist?(belfile_path)
        @belfile.belfile_path = belfile_path
        path = File.join(BELFILES_FOLDER, filename)
        File.open(path, "wb") { |f| f.write(belfile_params[:belfile].read) }
        @belfile.save
        @graph.save
      else
        ## TODO: file already exists error message
        redirect_to new_belfile_path
      end
    elsif !belfile_params[:url].nil?
      @belfile.title = belfile_params[:title]
      @belfile.description = belfile_params[:description]
      ## Filename will be based on title
      filename = @belfile.title
      ## So, we sanitize it
      filename.gsub!(/^.*(\\|\/)/, '')
      filename.gsub!(/[^0-9A-Za-z.\-]/, '_')
      filename = filename + '.bel'
      belfile_path = BELFILES_FOLDER + filename
      ## If it not exists, create it
      if !File.exist?(belfile_path)
        @belfile.belfile_path = belfile_path
        path = File.join(BELFILES_FOLDER, filename)
        url = URI.parse(belfile_params[:url])
        open(path, 'wb') do |file|
          file << url.open.read
        end
        @belfile.save
        @graph.save
      else
        ## TODO: file already exists error message
        redirect_to new_belfile_path
      end
    else
      ## TODO: fill in form correctly error message
      redirect_to new_belfile_path
    end
    bel_content = File.open(@belfile.belfile_path, 'r:UTF-8').read
    BEL::Script.parse(bel_content) do |parsed_object|
      ## here we get bel expressions parsed from belfile
      if parsed_object.is_a?(Statement)
        build_graph(@graph, parsed_object)
      end
    end
    redirect_to @belfile
  end

private
  def belfile_params
    params.require(:belfile).permit(:title, :description, :belfile, :url)
  end
end
