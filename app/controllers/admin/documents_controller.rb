class Admin::DocumentsController < Admin::AdminController

  def show
    authorize! with: Admin::DocumentsPolicy
    @clients = User.with_role('Owner').includes(:houses).order(:name, :surname)
  end


  def prepare
    authorize! with: Admin::DocumentsPolicy
    
    @client = User.find(params[:client_id])

    respond_to do |format|
      format.html { render :prepare }
      format.pdf do 
        @house = House.find(params[:house_id])
        doc_type = params[:doc_type].to_s
        
        p = design_agreement_params
        date = p[:date].present? ? p[:date] : Date.current

        @document = {
          date: date,
          client: "#{@client.name} #{@client.surname}",
          passport: @client.passport,
          email: @client.email,
          phone: @client.phone,
          property: "#{@house.project} #{@house.house_no}",
          amount: p[:amount],
          suffix: p[:suffix],
          text: p[:text] || ""
        }
        @document[:number] = "#{@document[:date].to_date.strftime('%Y%m%d')}-#{@document[:suffix].presence || "1" }"

        template = 
          case doc_type
            when "agreement" then :agreement_pdf
            when "invoice" then :invoice_pdf
            when "receipt" then :receipt_pdf
            else
              raise ActionController::BadRequest, "Unknown doc_type"
          end
        
        @document[:file_name] = 
          case doc_type
            when "agreement" then "Design_agreement_#{@document[:client].split.join("_")}_#{@document[:number]}.pdf"
            when "invoice" then "Invoice_#{@document[:client].split.join("_")}_#{@document[:number]}.pdf"
            when "receipt" then "Receipt_#{@document[:client].split.join("_")}_#{@document[:number]}.pdf"
          end

        html = render_to_string(
          template,
          layout: 'print',
          formats: [:html],
        )
        
        if template == :agreement_pdf
          footer_html = render_to_string(
            partial: "admin/documents/agreement_footer",
            formats: [:html],
            locals: { agreement_no: @document[:number] }
          )
        else
          footer_html = nil
        end

        pdf_bytes = PdfRenderer.call(
          html: html,
          footer_html: footer_html
        )

        send_data pdf_bytes,
                  filename: @document[:file_name],
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
  end

  def statement
    authorize! with: Admin::DocumentsPolicy
    @usd = @settings['usd_rate'].present? ? @settings['usd_rate'].to_f : 30

    if params[:trsc_id].present?
      @t = Transaction.find(params[:trsc_id])
      @date = @t.date
      if @t.type.name_en == 'Rental'
        @owner = @t.user
        @to = { name: Booking.find(@t.booking_id).client_details,
                address: '' }
      else
        @owner = @t.user
        @to = { name: "#{@t.user.name} #{@t.user.surname}",
                address: '' }
      end
    elsif params[:owner_id].present?
      @date = Time.current
      @owner = User.find(params[:owner_id])
      @to = { name: "#{@owner.name} #{@owner.surname}",
              address: '' }

    end
  end

  def reimbersment
    authorize! with: Admin::DocumentsPolicy
    @t = Transaction.find(params[:trsc_id])
    @date = @t.date
    @usd = 29
    @to = if @t.type.name_en == 'Rental'
      { name: Booking.find(@t.booking_id).client_details,
        address: '' }
    else
      { name: "#{@t.user.name} #{@t.user.surname}",
        address: '' }
    end
  end

  def invoice
    authorize! with: Admin::DocumentsPolicy
  end

  def receipt
    authorize! with: Admin::DocumentsPolicy
  end

  private

  def design_agreement_params
    params.permit(
      :date,
      :suffix,
      :amount,
      :text
    )
  end
end
