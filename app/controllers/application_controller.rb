class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  # rescue_from StandardError, with: :render_server_error

  # private

  # def render_not_found
  #   render json: { error: "Record not found" }, status: :not_found
  # end

  # def render_server_error(e)
  #   render json: { message: "Internal server error handler + #{e.message}" }, status: :internal_server_error
  # end

  rescue_from StandardError, with: :handle_exception

  private

  def handle_exception(e)
    case e
    when ActiveRecord::RecordNotFound
        render json: { erros: "Record not found", message: e.message }, status: :not_found
    when ActionController::RoutingError
        render json: { error: "Route not found" }, status: :not_found
    else
        render json: { error: "Internal server error", message: e.message }, status: :internal_server_error
    end
  end
end
