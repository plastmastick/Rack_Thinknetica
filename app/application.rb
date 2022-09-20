# frozen_string_literal: true

require 'rack'
require_relative 'time'

class Application

  PATHS = {
    '/time' => :time
  }.freeze

  def call(env)
    request_path = env['REQUEST_PATH'] || :error
    send(PATHS[request_path], env)
  end

  private

  def time(env)
    AppTime.new(env).call(env)
  end

  def error
    [
      404,
      { 'Content-Type' => 'text/plain' },
      ['Resource not found']
    ]
  end

end
