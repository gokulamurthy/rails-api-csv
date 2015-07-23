class DevicesController < ApplicationController

  def show
    data = Alloc.find_by_ip(params[:id])

    resp = if data
      { device: data[:device], ip: data[:ip] }
    else
      { ip: params[:id], error: 'Not Found', status: 404 }
    end

    render_response(resp)
  end

  def assign
    alloc = Alloc.new(assign_params)

    resp = if alloc.save
      { device: alloc.device, ip: alloc.ip, status: 201 }
    else
      error_msg = alloc.errors.full_messages.first # one at a time
      status = error_msg.include?('already assigned') ? 409 : 400 # hacky!

      { ip: alloc.ip, error: error_msg, status: status }
    end

    render_response(resp)
  end

  private

  def assign_params
    params.permit(:ip, :device)
  end
end
