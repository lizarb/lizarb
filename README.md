# Liza

Liza is a light, experimental framework primarily developed to help study the Ruby language and the Ruby ecosystem.

Liza is a < 2500 LOC framework, which provides an abstract architecture for organizing Ruby code using systems.

It defines 3 top level constants [Lizarb, App, Liza]and works with any gem or app that doesn't implement these constants.

## Author note

I am happy with the project and I am starting to focus on documentation.

I will be updating the website https://lizarb.org/ to include more vivid examples and tutorials.

## Installing

Install the gem by executing:

    gem install lizarb

You will get the following shims:

    lizarb version
    liza version

## REPL

Try Liza with IRB or Pry:

    liza irb
    liza pry

## Create a liza app

So you can run your experiments:

    liza new

Then enter your automagically generated liza app:

    cd app_1
    liza help

Now you're ready to go and try some stuff!

---

## Running Tests

OK, one more thing!

> All controllers you generate come paired with a test file.

You can run the tests with:

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

## Check out our beta features

To clone this repository, run this bash script:

    gh repo clone lizarb/lizarb

To install dependencies, run this:

    bundle

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
