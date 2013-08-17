require File.dirname(__FILE__) + '/../spec_helper'

describe CdnZip do
  include_context "mock without Rails"

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
        config.prefix = "assets"
        config.public_path = Pathname("./public")
      end
    end

    it "should have prefix of assets" do
      CdnZip.config.prefix.should == "assets"
    end

    it "should have prefix of assets" do
      CdnZip.config.public_path.to_s.should == "./public"
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

  end
end
