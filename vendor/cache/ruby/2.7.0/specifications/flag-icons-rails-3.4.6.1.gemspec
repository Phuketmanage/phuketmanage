# -*- encoding: utf-8 -*-
# stub: flag-icons-rails 3.4.6.1 ruby lib

Gem::Specification.new do |s|
  s.name = "flag-icons-rails".freeze
  s.version = "3.4.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Evgeny Garlukovich".freeze]
  s.date = "2020-03-20"
  s.description = "Gem allows to use `flag-icon-css` - a collection of all country flags in SVG - in your Rails projects".freeze
  s.email = ["evgeny.garlukovich@gmail.com".freeze]
  s.homepage = "https://github.com/evgenygarl/flag-icons-rails".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Gem to use `flag-icon-css` library in your Rails projects".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<sass-rails>.freeze, [">= 0"])
    s.add_development_dependency(%q<railties>.freeze, [">= 3.2", "< 6"])
    s.add_development_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry>.freeze, [">= 0"])
    s.add_development_dependency(%q<minitest>.freeze, ["~> 5.10.0"])
    s.add_development_dependency(%q<minitest-have_tag>.freeze, ["~> 0.1.0"])
    s.add_development_dependency(%q<minitest-emoji>.freeze, ["~> 2.0.0"])
    s.add_development_dependency(%q<yard>.freeze, ["~> 0.9.5"])
    s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.50.0"])
  else
    s.add_dependency(%q<sass-rails>.freeze, [">= 0"])
    s.add_dependency(%q<railties>.freeze, [">= 3.2", "< 6"])
    s.add_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.10.0"])
    s.add_dependency(%q<minitest-have_tag>.freeze, ["~> 0.1.0"])
    s.add_dependency(%q<minitest-emoji>.freeze, ["~> 2.0.0"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9.5"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.50.0"])
  end
end
