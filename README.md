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
