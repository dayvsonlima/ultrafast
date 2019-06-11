# Ultrafast

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/ultrafast`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ultrafast'
```

And then execute:

    $ bundle

Add this rake task in yours `lib/tasks/ultrafast.rake`

```ruby
namespace :ultrafast do
  desc 'start ultrafast server'
  task start: [:environment] do
    Ultrafast::Server.start
  end
end
```

## Usage

Add this module in your module:

app/models/user.rb
```ruby
class User < ApplicationRecord
  extend Ultrafast::Model
end
```

Replace your `create` method by `fast_create`

```ruby
User.fast_create(user_params)
```

Start the fast_create server

    $ rake ultrafast:start

## Configurations

Redis connection
```sh
# Default is 6379
UF_REDIS_PORT

# Default is 127.0.0.1
UF_REDIS_HOST

# Default is 0
UF_REDIS_DB
```

Server loop
```sh
# Define the interval between loop inserts
# Default is 0.5
UF_LOOP_INTERVAL
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dayvsonlima/ultrafast. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Ultrafast project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/dayvsonlima/ultrafast/blob/master/CODE_OF_CONDUCT.md).
