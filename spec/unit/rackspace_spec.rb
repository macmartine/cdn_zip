require File.dirname(__FILE__) + '/../spec_helper'

describe CdnZip do
  include_context "mock Rails"

  describe 'using Rackspace with initializer' do
    before(:each) do
      set_rails_root('without_yml')
      CdnZip.config = CdnZip::Config.new
      CdnZip.configure do |config|
        config.fog_provider          = 'Rackspace'
        config.fog_directory         = 'mybucket'
        config.fog_region            = 'dunno'
        config.rackspace_username    = 'aaaa'
        config.rackspace_api_key     = 'bbbb'
        config.existing_remote_files = 'keep'
      end
    end

    it "should configure provider as Rackspace" do
      CdnZip.config.fog_provider.should == 'Rackspace'
      CdnZip.config.should be_rackspace
    end

    it "should keep existing remote files" do
      CdnZip.config.existing_remote_files?.should == true
    end

    it "should configure rackspace_username" do
      CdnZip.config.rackspace_username.should == "aaaa"
    end

    it "should configure rackspace_api_key" do
      CdnZip.config.rackspace_api_key.should == "bbbb"
    end

    it "should configure fog_directory" do
      CdnZip.config.fog_directory.should == "mybucket"
    end

    it "should configure fog_region" do
      CdnZip.config.fog_region.should == "dunno"
    end

    it "should configure existing_remote_files" do
      CdnZip.config.existing_remote_files.should == "keep"
    end

    it "should configure existing_remote_files" do
      CdnZip.config.existing_remote_files.should == "keep"
    end

    it "should default rackspace_auth_url to false" do
      CdnZip.config.rackspace_auth_url.should be_false
    end

  end

  describe 'using Rackspace from yml' do

    before(:each) do
      set_rails_root('rackspace_with_yml')
      CdnZip.config = CdnZip::Config.new
    end

    it "should keep existing remote files" do
      CdnZip.config.existing_remote_files?.should == true
    end

    it "should configure rackspace_username" do
      CdnZip.config.rackspace_username.should == "xxxx"
    end

    it "should configure rackspace_api_key" do
      CdnZip.config.rackspace_api_key.should == "zzzz"
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
  end
end
