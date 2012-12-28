# Hokuto

Hokuto: a lightweight appserver for rack-dependent ruby web applications.

## Character

Hokuto is a lightweight web application server focused to handle many many requests. This gem is based on Jetty. Due to Jetty's very artful request handling, this gem can take over the well known "C10K Problem".

"Hokuto" is named after the express operated by Hokkaido Railway Company (a.k.a. JR Hokkaido). The express is the fastest train of the narrow guage trains in Japan for the average speed. It runs on tight curves quickly with the tilting system which is often called 'pendular'. I thought that this gem can be liken to the express train because of the fine mechanism to handle many many requests. This is why I named this gem.

## Installation

Add this line to your application's Gemfile:

    gem 'hokuto'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hokuto

## Usage

If you just run it by the commands as follows:

    $ hokuto

Currently implemented options are below:

    -p, --http-port=HTTP_PORT                   specify the HTTP port(default: 7080)
    -c, --context-root=PATH                     specify the context root(default: /)
    -d, --base-directory=DIR                    specify the root of apps(default: working directory)
    -e, --environment=ENV                       specify the rack environment (default: 'development')
    -s, --min-instances=INSTANCES_ON_STARTUP    specify the number of JRuby instances on startup(default: 1)
    -x, --max-instances=MAXIMUM_INSTANCES       specify the maximum number of JRuby instances(default: 1)
Note that your app will run the multithreaded mode if --min-instances == --max-instances == 1 (default). If you want to perform highly with limited resources, you should not use multiple instances. Just you should implement apps in the multithreaded manner.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
