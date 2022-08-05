require_relative 'lib/unity/client/version'

Gem::Specification.new do |spec|
  spec.name          = "unity-client"
  spec.version       = Unity::Client::VERSION
  spec.authors       = ["Julien D."]
  spec.email         = ["julien@pocketsizesun.com"]

  spec.summary       = %q{Unity::Client class}
  spec.description   = %q{unity client}
  spec.homepage      = "https://github.com/pocketsizesun/unity-client-ruby"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/pocketsizesun/unity-client-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/pocketsizesun/unity-client-ruby"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'http'
  spec.add_dependency 'symbol-fstring'
  spec.add_development_dependency 'pry'
end
