class IcdCodesController < ApplicationController
  # GET /icd_codes
  # GET /icd_codes.xml
  def index
    respond_to do |format|
      format.html {}
      format.json {
        @icd_codes = IcdCode.jtable_query(params[:jTableQuery])
        render :json => jtable_for_json(@icd_codes, params[:jTableQuery])
      }
      format.xml  { render :xml => @icd_codes }
    end
  end

  # GET /icd_codes/1
  # GET /icd_codes/1.xml
  def show
    @icd_code = IcdCode.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false }
      format.xml  { render :xml => @icd_code }
    end
  end

  # GET /icd_codes/new
  # GET /icd_codes/new.xml
  def new
    @icd_code = IcdCode.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @icd_code }
    end
  end

  # GET /icd_codes/1/edit
  def edit
    @icd_code = IcdCode.find(params[:id])
  end

  # POST /icd_codes
  # POST /icd_codes.xml
  def create
    @icd_code = IcdCode.new(params[:icd_code])

    respond_to do |format|
      if @icd_code.save
        format.html { redirect_to(@icd_code, :notice => 'Icd code was successfully created.') }
        format.xml  { render :xml => @icd_code, :status => :created, :location => @icd_code }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @icd_code.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /icd_codes/1
  # PUT /icd_codes/1.xml
  def update
    @icd_code = IcdCode.find(params[:id])

    respond_to do |format|
      if @icd_code.update_attributes(params[:icd_code])
        format.html { redirect_to(@icd_code, :notice => 'Icd code was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @icd_code.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /icd_codes/1
  # DELETE /icd_codes/1.xml
  def destroy
    @icd_code = IcdCode.find(params[:id])
    @icd_code.destroy

    respond_to do |format|
      format.js   { head :ok }
      format.html { redirect_to(icd_codes_url) }
      format.xml  { head :ok }
    end
  end
end
