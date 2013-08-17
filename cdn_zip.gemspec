# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "cdn_zip/version"

Gem::Specification.new do |s|
  s.name        = "cdn_zip"
  s.version     = CdnZip::VERSION
  s.date        = "2013-08-16"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mac Martine"]
  s.email       = ["mac.martine@gmail.com"]
  s.homepage    = "https://github.com/macmartine/cdn_zip"
  s.summary     = %q{}
  s.description = %q{}

  s.add_dependency('fog', ">= 1.8.0")
  s.add_dependency('activemodel')

  s.add_development_dependency "rspec"
  s.add_development_dependency "bundler"
  s.add_development_dependency "jeweler"

  s.add_development_dependency "uglifier"
  s.add_development_dependency "cdn_zip"
  s.add_development_dependency "appraisal"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
