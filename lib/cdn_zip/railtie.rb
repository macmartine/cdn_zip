class Rails::Railtie::Configuration
  def cdn_zip
    AssetSync.config
  end
end
