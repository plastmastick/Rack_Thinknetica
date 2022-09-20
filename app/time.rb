# frozen_string_literal: true

class AppTime
  FORMATS = {
    'year' => :year,
    'month' => :month,
    'day' => :day,
    'hour' => :hour,
    'minute' => :min,
    'second' => :sec
  }.freeze

  def initialize(env)
    @query = env['QUERY_STRING']
    @user_format = Rack::Utils.parse_nested_query(@query).values.join.split(',')
    check_user_formats
  end

  def call(_env)
    [status, headers, body]
  end

  def available_formats?
    @unavailable_formats.empty?
  end

  private

  def status
    available_formats? ? 200 : 400
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body
    if available_formats?
      ["#{convert_user_format}\n"]
    else
      ["Unknown time format #{@unavailable_formats}\n"]
    end
  end

  def check_user_formats
    @unavailable_formats ||= []
    @user_format.each { |f| @unavailable_formats.push(f) unless FORMATS.keys.include?(f) }
  end

  def convert_user_format
    converted_time = @user_format.map { |f| Time.now.send(FORMATS[f]) }
    converted_time.join('-')
  end
end
