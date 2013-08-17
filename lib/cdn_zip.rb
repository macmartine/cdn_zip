require 'fog'
require 'active_model'
require 'erb'
require "cdn_zip/cdn_zip"
require 'cdn_zip/config'
require 'cdn_zip/storage'
require 'cdn_zip/multi_mime'


require 'cdn_zip/railtie' if defined?(Rails)
require 'cdn_zip/engine'  if defined?(Rails)
