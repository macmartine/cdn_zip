module CdnZip
  class Engine < Rails::Engine

    engine_name "cdn_zip"

    initializer "cdn_zip config", :group => :all do |app|

      CdnZip.log "CdnZip: using default configuration from built-in initializer"
      CdnZip.configure do |config|
        config.fog_provider           = ENV['FOG_PROVIDER'] if ENV.has_key?('FOG_PROVIDER')
        config.fog_directory          = ENV['FOG_DIRECTORY'] if ENV.has_key?('FOG_DIRECTORY')
        config.fog_region             = ENV['FOG_REGION'] if ENV.has_key?('FOG_REGION')
        
        config.aws_access_key_id      = ENV['AWS_ACCESS_KEY_ID'] if ENV.has_key?('AWS_ACCESS_KEY_ID')
        config.aws_secret_access_key  = ENV['AWS_SECRET_ACCESS_KEY'] if ENV.has_key?('AWS_SECRET_ACCESS_KEY')
        config.aws_reduced_redundancy = ENV['AWS_REDUCED_REDUNDANCY'] == true  if ENV.has_key?('AWS_REDUCED_REDUNDANCY')
        
        config.enabled                = (ENV['cdn_zip_ENABLED'] == 'true') if ENV.has_key?('cdn_zip_ENABLED')
        
        config.existing_remote_files  = ENV['cdn_zip_EXISTING_REMOTE_FILES'] || "keep"
        
        config.gzip_compression       = (ENV['cdn_zip_GZIP_COMPRESSION'] == 'true') if ENV.has_key?('cdn_zip_GZIP_COMPRESSION')
        config.manifest               = (ENV['cdn_zip_MANIFEST'] == 'true') if ENV.has_key?('cdn_zip_MANIFEST')
      end

      config.prefix = ENV['cdn_zip_PREFIX'] if ENV.has_key?('cdn_zip_PREFIX')

      config.existing_remote_files = ENV['cdn_zip_EXISTING_REMOTE_FILES'] || "keep"

      config.gzip_compression = (ENV['cdn_zip_GZIP_COMPRESSION'] == 'true') if ENV.has_key?('cdn_zip_GZIP_COMPRESSION')
      config.manifest = (ENV['cdn_zip_MANIFEST'] == 'true') if ENV.has_key?('cdn_zip_MANIFEST')
      
    end

  end
end
