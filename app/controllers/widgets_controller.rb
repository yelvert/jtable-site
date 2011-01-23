class WidgetsController < ApplicationController
  # GET /widgets
  # GET /widgets.xml
  def index
    if params[:query]
      query = params[:query]
      unless query[:search].blank?
        where_clause = []
        columns_hash = {}
        where_clause << query[:searchable_columns].collect do |column|
          columns_hash[column.to_sym] = column
          "#{column.to_sym} LIKE :query_string"
        end.join(" OR ")
        where_clause << columns_hash.merge({:query_string => "%#{query[:search]}%"})
      end
      Rails.logger.info where_clause.inspect
      unless query[:sort_column].blank? and query[:sort_direction].blank?
        order_clause = "#{query[:sort_column]} #{query[:sort_direction]}"
      end
      @widgets = Widget.where(where_clause).order(order_clause)
    else
      @widgets = Widget.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @widgets }
      format.xml  { render :xml => @widgets }
    end
  end

  # GET /widgets/1
  # GET /widgets/1.xml
  def show
    @widget = Widget.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @widget }
    end
  end

  # GET /widgets/new
  # GET /widgets/new.xml
  def new
    @widget = Widget.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @widget }
    end
  end

  # GET /widgets/1/edit
  def edit
    @widget = Widget.find(params[:id])
  end

  # POST /widgets
  # POST /widgets.xml
  def create
    @widget = Widget.new(params[:widget])

    respond_to do |format|
      if @widget.save
        format.html { redirect_to(@widget, :notice => 'Widget was successfully created.') }
        format.xml  { render :xml => @widget, :status => :created, :location => @widget }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @widget.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /widgets/1
  # PUT /widgets/1.xml
  def update
    @widget = Widget.find(params[:id])

    respond_to do |format|
      if @widget.update_attributes(params[:widget])
        format.html { redirect_to(@widget, :notice => 'Widget was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @widget.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /widgets/1
  # DELETE /widgets/1.xml
  def destroy
    @widget = Widget.find(params[:id])
    @widget.destroy

    respond_to do |format|
      format.html { redirect_to(widgets_url) }
      format.js   { head :ok }
      format.xml  { head :ok }
    end
  end
end
