# Liza

Liza is a light, experimental framework primarily developed to help study the Ruby language and the Ruby ecosystem.

## Install

Install the gem by executing:

    gem install lizarb

You will get the following three shims:

    lizarb version
    liza version
    lrb version

## Create a liza app

So you can run your experiments:

    liza new

Then enter your automagically generated liza app:

    cd app_1
    bundle install

Now you're ready to go and try some stuff!

## Try

Try Liza with an interactive terminal

    liza terminal

## Running Tests

Run your Liza tests

    liza test

## Development

To install dependencies, run this bash script:

    bin/setup

For development experiments, use the local executable script

    exe/lizarb test

To build and install lizarb in your local machine

    bundle exec rake install

For systems in development, see [README_SYSTEMS.md](https://github.com/rubyonrails-brasil/lizarb/blob/master/README_SYSTEMS.md).

## Release

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rubyonrails-brasil/lizarb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/rubyonrails-brasil/lizarb/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Lizarb project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rubyonrails-brasil/lizarb/blob/master/CODE_OF_CONDUCT.md).
