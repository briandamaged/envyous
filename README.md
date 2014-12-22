# envyous #

Envyous provides a wrapper around [Confickle](https://github.com/briandamaged/confickle) so that configuration files can be partitioned by environment.  Hence, you can launch your application with different configuration profiles:

    ENV=staging bundle exec ruby ./my_application


## Installation ##

### Grab the library ###

Envyous can be installed via the ```gem``` command:

    gem install envyous

Or, even better: you can update your application's ```Gemfile``` to specify ```envyous``` as a dependency:

    gem 'envyous'

Don't forget to run ```bundle install``` after updating the ```Gemfile```!

### Structure the config directory ###

Your application needs to structure its config directory as follows:

    your_application/
    └── config
        ├── environments
        │   ├── development
        │   │   ├── aws.json
        │   │   └── mongo.yml
        │   ├── production
        │   │   ├── aws.json
        │   │   └── mongo.yml
        │   ├── foo
        │   │   ├── aws.json
        │   │   └── mongo.yml
        │   └── bar
        │       ├── aws.json
        │       └── mongo.yml
        └── envyous.json

Notice:

* The ```config``` folder contains:
  * An ```environments``` folder.
  * An ```envyous.json``` configuration.
* Each folder in ```environments``` is named after one of your application's environments.


### Add envyous.json ###

The ```envyous.json``` configuration contains the default settings for envyous.  That is, these are the values that will be used when no overrides are specified on the command-line.  At the moment, this file only needs to specify the name of the default environment:

    {
      "env": "development"
    }

## Usage ##

### Obtain the Environment's Configuration ###

Your application can use the ```envyous``` library to obtain the environment-specific config.  Your code just needs to point to the configuration root directory.  Envyous will find the appropriate environment subdirectory:

    require 'envyous'

    config = Envyous.config(
      root: "path/to/config/root"
    )

### Launch your application ###

When launching your application, you can specify the configuration profile via the ```ENV``` environment variable:

    ENV=qa bundle exec ruby ./my_application

If you omit the ```ENV``` environment variable, then Envyous will default to the environment specified in the ```envyous.json``` configuration file:

    bundle exec ruby ./my_application


