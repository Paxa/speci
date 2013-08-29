# Speci

It's a continuously turbo-fast rspec runner with IRB-like console.

## Install

    gem install speci

## Usage

Inside your rails folder

    speci


#### Command-line options

    "*" or "spec all"         # => run all spec from ./spec frolder
    "spec" or "spec again"    # => run specs again
    "spec/intergration/*"     # => run all integration specs

    "exit" or "quit"          # => exit
    "restart"                 # => restart itself
    "reload!"                 # => reload rails environment (same as "reload!" in rails console)


License
-----------------

Please see [LICENSE](https://github.com/Paxa/speci/blob/master/LICENSE) for licensing details.


Author
-----------------

Pavel Evstigneev