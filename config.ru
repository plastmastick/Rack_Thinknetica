# frozen_string_literal: true

require_relative 'middleware/runtime'
require_relative 'middleware/logger'
require_relative 'apps/time_app'

ROUTES = {
  '/time' => TimeApp.new
}.freeze

use Runtime
use AppLogger, logdev: File.expand_path('logs/app.log', __dir__)
run Rack::URLMap.new(ROUTES)
