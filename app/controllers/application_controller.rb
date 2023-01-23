class ApplicationController < ActionController::Base
  rescue_from 'ActionController::ParameterMissing' do |e|
    render json: {
             error_message: "Missing parameter: #{e.param}",
           },
           status: :bad_request
  end

  skip_before_action :verify_authenticity_token
end
