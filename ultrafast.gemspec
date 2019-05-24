
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ultrafast/version"

Gem::Specification.new do |spec|
  spec.name          = "ultrafast"
  spec.version       = Ultrafast::VERSION
  spec.authors       = ["Dayvson Lima"]
  spec.email         = ["dayvsonlima31@gmail.com"]

  spec.summary       = "optimize atomic inserts using the redis as buffer"
  spec.description   = "optimize atomic inserts using the redis as buffer"
  spec.homepage      = "https://github.com/dayvsonlima/ultrafast"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'redis'
  spec.add_dependency 'activerecord-import'
  spec.add_dependency 'rufus-scheduler'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
