class ErrorHandlingMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue ActiveRecord::RecordNotFound => e
      [ 404, { "Content-Type" => "application/json" }, [ { error: "Record not found", errors: e.errors.full_messages }.to_json ] ]
    rescue StandardError => e
      [ 500, { "Content-Type" => "application/json" }, [ { error: "Internal server error" }.to_json ] ]
    end
  end
end
