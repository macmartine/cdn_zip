module AssetSync
  class Engine < Rails::Engine

    engine_name "cdn_zip"

    initializer "cdn_zip config", :group => :all do |app|
      app_initializer = Rails.root.join('config', 'initializers', 'cdn_zip.rb').to_s
      app_yaml = Rails.root.join('config', 'cdn_zip.yml').to_s

      if File.exists?( app_initializer )
        AssetSync.log "AssetSync: using #{app_initializer}"
        load app_initializer
      elsif !File.exists?( app_initializer ) && !File.exists?( app_yaml )
        AssetSync.log "AssetSync: using default configuration from built-in initializer"
        AssetSync.configure do |config|
          config.fog_provider = ENV['FOG_PROVIDER'] if ENV.has_key?('FOG_PROVIDER')
          config.fog_directory = ENV['FOG_DIRECTORY'] if ENV.has_key?('FOG_DIRECTORY')
          config.fog_region = ENV['FOG_REGION'] if ENV.has_key?('FOG_REGION')

          config.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID'] if ENV.has_key?('AWS_ACCESS_KEY_ID')
          config.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY'] if ENV.has_key?('AWS_SECRET_ACCESS_KEY')
          config.aws_reduced_redundancy = ENV['AWS_REDUCED_REDUNDANCY'] == true  if ENV.has_key?('AWS_REDUCED_REDUNDANCY')

          config.rackspace_username = ENV['RACKSPACE_USERNAME'] if ENV.has_key?('RACKSPACE_USERNAME')
          config.rackspace_api_key = ENV['RACKSPACE_API_KEY'] if ENV.has_key?('RACKSPACE_API_KEY')

          config.google_storage_access_key_id = ENV['GOOGLE_STORAGE_ACCESS_KEY_ID'] if ENV.has_key?('GOOGLE_STORAGE_ACCESS_KEY_ID')
          config.google_storage_secret_access_key = ENV['GOOGLE_STORAGE_SECRET_ACCESS_KEY'] if ENV.has_key?('GOOGLE_STORAGE_SECRET_ACCESS_KEY')

          config.enabled = (ENV['cdn_zip_ENABLED'] == 'true') if ENV.has_key?('cdn_zip_ENABLED')

          config.existing_remote_files = ENV['cdn_zip_EXISTING_REMOTE_FILES'] || "keep"

          config.gzip_compression = (ENV['cdn_zip_GZIP_COMPRESSION'] == 'true') if ENV.has_key?('cdn_zip_GZIP_COMPRESSION')
          config.manifest = (ENV['cdn_zip_MANIFEST'] == 'true') if ENV.has_key?('cdn_zip_MANIFEST')
        end

        config.prefix = ENV['cdn_zip_PREFIX'] if ENV.has_key?('cdn_zip_PREFIX')

        config.existing_remote_files = ENV['cdn_zip_EXISTING_REMOTE_FILES'] || "keep"

        config.gzip_compression = (ENV['cdn_zip_GZIP_COMPRESSION'] == 'true') if ENV.has_key?('cdn_zip_GZIP_COMPRESSION')
        config.manifest = (ENV['cdn_zip_MANIFEST'] == 'true') if ENV.has_key?('cdn_zip_MANIFEST')

      end

      if File.exists?( app_yaml )
        AssetSync.log "AssetSync: YAML file found #{app_yaml} settings will be merged into the configuration"
      end
    end

  end
end
