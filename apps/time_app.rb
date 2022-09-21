# frozen_string_literal: true

require 'rack'
require_relative 'services/time_format_service'

class TimeApp

  def call(env)
    @query = env['QUERY_STRING']
    @format = TimeFormatService.new(@query) unless @query.empty?

    [status, headers, body]
  end

  private

  def status
    @format&.available_formats? ? 200 : 400
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body
    if @format.nil?
      ["Format doesn't set\n"]
    elsif @format.available_formats?
      ["#{@format.convert_user_format}\n"]
    else
      ["Unknown time format #{@format.unavailable_formats}\n"]
    end
  end

end
