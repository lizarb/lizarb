# Liza

Liza is a light, experimental framework primarily developed to help study the Ruby language and the Ruby ecosystem.

## Install

Install the gem by executing:

    gem install lizarb

You will get the following shims:

    lizarb version
    liza version

## Create a liza app

So you can run your experiments:

    liza new

Then enter your automagically generated liza app:

    cd app_1
    liza help

Now you're ready to go and try some stuff!

---

## Try

Try Liza with Interactive Ruby

    liza irb

Try Liza with Pry

    liza pry

---

## Running Tests

Run your Liza tests

    liza test


## DevSystem

Generate a command

    liza generate
    liza generate command
    liza generate command my
    liza my
    liza my 1 2 3

Generate a system

    liza generate
    liza generate system my
    liza generate system my

Generate a command in a system

    liza generate
    liza generate command
    liza generate command other
    liza generate command other place=my
    liza other

Gemify a system

    # TODO

Investigate the framework

    liza loc
    liza shell

---

## Development

To install dependencies, run this bash script:

    bin/setup

For development experiments, use the local executable script

    exe/lizarb test

To build and install lizarb in your local machine

    bundle exec rake install

<!--
For systems in development, see [README_SYSTEMS.md](https://github.com/lizarb/lizarb/blob/master/README_SYSTEMS.md).

## Release

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).
-->
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lizarb/lizarb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/lizarb/lizarb/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Lizarb project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/lizarb/lizarb/blob/master/CODE_OF_CONDUCT.md).
