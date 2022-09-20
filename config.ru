# frozen_string_literal: true

require_relative 'middleware/runtime'
require_relative 'middleware/logger'
require_relative 'app/application'

use Runtime
use AppLogger, logdev: File.expand_path('logs/app.log', __dir__)
run Application.new
