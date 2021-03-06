require File.dirname(__FILE__) + '/../spec_helper'

describe CdnZip::MultiMime do

  before(:each) do
    Object.send(:remove_const, :Rails) if defined?(Rails)
    Object.send(:remove_const, :Mime) if defined?(Mime)
    Object.send(:remove_const, :Rack) if defined?(Rack)
  end

  after(:each) do
    Object.send(:remove_const, :Rails) if defined?(Rails)
    Object.send(:remove_const, :Mime) if defined?(Mime)
    Object.send(:remove_const, :Rack) if defined?(Rack)
  end

  after(:all) do
    require 'mime/types'
  end

  describe 'Mime::Type' do

    it 'should detect mime type' do
      pending "Fails on Travis CI only as of https://travis-ci.org/rumblelabs/cdn_zip/builds/4188196"
      require 'rails'
      CdnZip::MultiMime.lookup('css').should == "text/css"
    end

  end

  describe 'Rack::Mime' do

    it 'should detect mime type' do
      require 'rack/mime'
      CdnZip::MultiMime.lookup('css').should == "text/css"
    end

  end

  describe 'MIME::Types' do

    it 'should detect mime type' do
      require 'mime/types'
      CdnZip::MultiMime.lookup('css').should == "text/css"
    end

  end

end
