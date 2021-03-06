require File.dirname(__FILE__) + '/../spec_helper'

describe CdnZip do
  include_context "mock Rails without_yml"

  describe 'with initializer' do
    before(:each) do
      CdnZip.config = CdnZip::Config.new
      CdnZip.configure do |config|
        config.fog_provider = 'AWS'
        config.aws_access_key_id = 'aaaa'
        config.aws_secret_access_key = 'bbbb'
        config.fog_directory = 'mybucket'
        config.fog_region = 'eu-west-1'
        config.existing_remote_files = "keep"
      end
    end

    it "should default to running on precompile" do
      CdnZip.config.run_on_precompile.should be_true
    end

    it "should default CdnZip to enabled" do
      CdnZip.config.enabled?.should be_true
      CdnZip.enabled?.should be_true
    end

    it "should configure provider as AWS" do
      CdnZip.config.fog_provider.should == 'AWS'
      CdnZip.config.should be_aws
    end

    it "should should keep existing remote files" do
      CdnZip.config.existing_remote_files?.should == true
    end

    it "should configure aws_access_key" do
      CdnZip.config.aws_access_key_id.should == "aaaa"
    end

    it "should configure aws_secret_access_key" do
      CdnZip.config.aws_secret_access_key.should == "bbbb"
    end

    it "should configure aws_access_key" do
      CdnZip.config.fog_directory.should == "mybucket"
    end

    it "should configure fog_region" do
      CdnZip.config.fog_region.should == "eu-west-1"
    end

    it "should configure existing_remote_files" do
      CdnZip.config.existing_remote_files.should == "keep"
    end

    it "should default gzip_compression to false" do
      CdnZip.config.gzip_compression.should be_false
    end

    it "should default manifest to false" do
      CdnZip.config.manifest.should be_false
    end

    it "should default log_silently to true" do
      CdnZip.config.log_silently.should be_true
    end

    it "should default cdn_distribution_id to nil" do
      CdnZip.config.cdn_distribution_id.should be_nil
    end

    it "should default invalidate to empty array" do
      CdnZip.config.invalidate.should == []
    end
  end

  describe 'from yml' do
    before(:each) do
      set_rails_root('aws_with_yml')
      CdnZip.config = CdnZip::Config.new
    end

    it "should default CdnZip to enabled" do
      CdnZip.config.enabled?.should be_true
      CdnZip.enabled?.should be_true
    end

    it "should configure run_on_precompile" do
      CdnZip.config.run_on_precompile.should be_false
    end

    it "should configure aws_access_key_id" do
      CdnZip.config.aws_access_key_id.should == "xxxx"
    end

    it "should configure aws_secret_access_key" do
      CdnZip.config.aws_secret_access_key.should == "zzzz"
    end

    it "should configure fog_directory" do
      CdnZip.config.fog_directory.should == "rails_app_test"
    end

    it "should configure fog_region" do
      CdnZip.config.fog_region.should == "eu-west-1"
    end

    it "should configure existing_remote_files" do
      CdnZip.config.existing_remote_files.should == "keep"
    end

    it "should default gzip_compression to false" do
      CdnZip.config.gzip_compression.should be_false
    end

    it "should default manifest to false" do
      CdnZip.config.manifest.should be_false
    end
  end

  describe 'from yml, exporting to a mobile hybrid development directory' do
    before(:each) do
      Rails.env.replace('hybrid')
      set_rails_root('aws_with_yml')
      CdnZip.config = CdnZip::Config.new
    end

    it "should be disabled" do
      expect{ CdnZip.sync }.not_to raise_error()
    end

    after(:each) do
      Rails.env.replace('test')
    end
  end

  describe 'with no configuration' do
    before(:each) do
      CdnZip.config = CdnZip::Config.new
    end

    it "should be invalid" do
      expect{ CdnZip.sync }.to raise_error()
    end
  end

  describe "with no other configuration than enabled = false" do
    before(:each) do
      CdnZip.config = CdnZip::Config.new
      CdnZip.configure do |config|
        config.enabled = false
      end
    end

    it "should do nothing, without complaining" do
      expect{ CdnZip.sync }.not_to raise_error()
    end
  end

  describe 'with fail_silent configuration' do
    before(:each) do
      CdnZip.stub(:stderr).and_return(@stderr = StringIO.new)
      CdnZip.config = CdnZip::Config.new
      CdnZip.configure do |config|
        config.fail_silently = true
      end
    end

    it "should not raise an invalid exception" do
      expect{ CdnZip.sync }.not_to raise_error()
    end

    it "should output a warning to stderr" do
      CdnZip.sync
      @stderr.string.should =~ /can't be blank/
    end
  end

  describe 'with disabled config' do
    before(:each) do
      CdnZip.stub(:stderr).and_return(@stderr = StringIO.new)
      CdnZip.config = CdnZip::Config.new
      CdnZip.configure do |config|
        config.enabled = false
      end
    end

    it "should not raise an invalid exception" do
      lambda{ CdnZip.sync }.should_not raise_error()
    end
  end

  describe 'with gzip_compression enabled' do
    before(:each) do
      CdnZip.config = CdnZip::Config.new
      CdnZip.config.gzip_compression = true
    end

    it "config.gzip? should be true" do
      CdnZip.config.gzip?.should be_true
    end
  end

  describe 'with manifest enabled' do
    before(:each) do
      CdnZip.config = CdnZip::Config.new
      CdnZip.config.manifest = true
    end

    it "config.manifest should be true" do
      CdnZip.config.manifest.should be_true
    end

    it "config.manifest_path should default to public/assets.." do
      CdnZip.config.manifest_path.should =~ /public\/assets\/manifest.yml/
    end

    it "config.manifest_path should default to public/assets.." do
      Rails.application.config.assets.manifest = "/var/assets"
      CdnZip.config.manifest_path.should == "/var/assets/manifest.yml"
    end

    it "config.manifest_path should default to public/custom_assets.." do
      Rails.application.config.assets.prefix = 'custom_assets'
      CdnZip.config.manifest_path.should =~ /public\/custom_assets\/manifest.yml/
    end
  end

  describe 'with invalid yml' do

    before(:each) do
      set_rails_root('with_invalid_yml')
      CdnZip.config = CdnZip::Config.new
    end

    it "config should be invalid" do
      CdnZip.config.valid?.should be_false
    end

    it "should raise a config invalid error" do
      expect{ CdnZip.sync }.to raise_error()
    end


  end

end
