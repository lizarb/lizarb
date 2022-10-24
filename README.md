# Liza

Liza is a light, experimental framework primarily developed to help study the Ruby language and the Ruby ecosystem.

## Install

Install the gem by executing:

    $ gem install lizarb

You will get the following three shims:

    $ lizarb version
    $ liza version

## Try

Try Liza with an interactive prompt

    $ liza dev

## Running Tests

Run your Liza tests

    $ liza test

## Happy

Try Liza and build an ASCII game

    $ liza happy axo

## Networking

Try Liza to connect with Sqlite and Redis

    $ liza net

```ruby

NetBox.clients.get :sqlite
NetBox.clients.get :redis_url

NetBox.databases.sql
NetBox.databases.sqlite
NetBox.databases.redis

RedisDb.current
SqliteDb.current

RedisDb.current.call "TIME"
SqliteDb.current.call "SELECT name, sql FROM sqlite_master WHERE type = 'table';"

```

## Web Server

Try Liza with the Rack Web Server

    $ liza web

http://localhost:3000/
  
http://localhost:3000/xxxxxxx
  
http://localhost:3000/api/xxxxxxx
  
http://localhost:3000/api/auth/sign_up
  
http://localhost:3000/api/auth/sign_in
  
http://localhost:3000/api/auth/account
  
http://localhost:3000/api/auth/sign_out
  
http://localhost:3000/assets/app.css
  
http://localhost:3000/assets/app.js

## Usage

TODO: Write usage instructions here

## Development

To install dependencies, run this bash script:

    $ bin/setup

For development experiments, use the local executable script

    $ exe/lizarb test

To build and install lizarb in your local machine

    $ bundle exec rake install

## Release    

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rubyonrails-brasil/lizarb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/rubyonrails-brasil/lizarb/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Lizarb project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rubyonrails-brasil/lizarb/blob/master/CODE_OF_CONDUCT.md).
