# frozen_string_literal: true

class TimeFormatService
  attr_reader :unavailable_formats, :user_format

  FORMATS = {
    'year' => :year,
    'month' => :month,
    'day' => :day,
    'hour' => :hour,
    'minute' => :min,
    'second' => :sec
  }.freeze

  def initialize(format)
    @user_format = Rack::Utils.parse_nested_query(format).values.join.split(',')
    check_user_formats
  end

  def available_formats?
    @unavailable_formats.empty?
  end

  def convert_user_format
    converted_time = @user_format.map { |f| Time.now.send(FORMATS[f]) }
    converted_time.join('-')
  end

  private

  def check_user_formats
    @unavailable_formats ||= []
    @user_format.each { |f| @unavailable_formats.push(f) unless FORMATS.keys.include?(f) }
  end

end
