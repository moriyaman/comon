# -*- encoding: utf-8 -*-
# stub: watir-nokogiri 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "watir-nokogiri"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Justin Ko"]
  s.date = "2013-08-21"
  s.description = "Watir-Nokogiri is an HTML parser using Watir's API."
  s.email = "jkotest@gmail.com"
  s.homepage = "https://github.com/jkotests/watir-nokogiri"
  s.rubygems_version = "2.2.2"
  s.summary = "Watir HTML parser"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 0"])
  end
end
