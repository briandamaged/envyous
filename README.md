# envyous #

Envyous provides a wrapper around [Confickle](https://github.com/briandamaged/confickle) so that configuration files can be partitioned by environment.  Hence, you can launch your application with different configuration profiles:

    ENV=staging bundle exec ruby ./my_application


## Installation ##

Envyous can be installed via the ```gem``` command:

    gem install envyous

Or, even better: you can update your application's ```Gemfile``` to specify ```envyous``` as a dependency:

    gem 'envyous'

Don't forget to run ```bundle install``` after updating the ```Gemfile```!

## Basic Setup ##

This setup assumes that all of the developers on your team will need access to the same configuration profiles.

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

## Basic Usage ##

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


## Advanced Setup ##

You probably don't want to persist you production configuration profile in your version control system.  Likewise, each developer would probably prefer to have his or her own application configuration files.  The Advanced Setup can address both of these concerns.

### Structure the config template directory ###

The config template directory will look nearly identical to the config directory that we created in the Basic Setup.  However, this directory simply provides templates / examples of configuration files:


    your_application/
    └── config.template
        ├── environments
        │   └── development
        │       ├── aws.json
        │       └── mongo.yml
        └── envyous.json

Notice that we're no longer specifying configuration profiles for ```production```, ```foo```, and ```bar```.  We're only providing a default setup for the ```development``` environment.

This directory will ultimately be used as a template for initializing our application's configuration directory.

### Ignore the config directory ###

Each instance of our application will now manage its own configuration.  Therefore, we do not want ```git``` to track the configuration directory anymore.  So, add the following to the application's ```.gitignore``` file:

    /config

(Assuming that your application's configuration directory is named ```config```)

## Advanced Usage ##

### Create Rake tasks for config ###

Users will need to copy the configuration template directory into the configuration directory before they can begin using the application.  To make life easier, we can just automate this task by adding the following to the ```Rakefile```:

    require 'envyous/rake'

    Envyous::Rake.default!(
      src:  "path/to/config.template/root",
      dest: "path/to/config/root"
    )

This will add the following ```Rake``` tasks:

    rake config:init           # Initializes envyous config
    rake config:soft_init      # Soft-initializes envyous config

### Initialize your config folder ###

When a user obtains a new copy of the application, they can initialize the ```config``` folder by running:

    rake config:init

This command will copy the configuration template into the configuration directory.  If the configuration directory already exists, then the command will raise an exception.

The ```rake config:soft_init``` command behaves similarly, but it will not raise an exception when the configuration directory already exists.  Instead, it will quietly refuse to overwrite the configuration directory.  This task is intended to be used as a dependency rather than invoked directly.


## Nitpicky Setup ##

Here are some various other ways that you can customize Envyous.

### Use a different environment variable ###

Suppose your application is already using the ```ENV``` environment variable for other purposes.  No worries - you can simply instruct Envyous to reference a different environment variable.  You just need to specify the ```:env_var``` key when obtaining your application's configuration:

    require 'envyous'

    config = Envyous.config(
      root:    "path/to/config/root",
      env_var: "MY_CUSTOM_ENV"
    )

Now, end-users can specify the configuration profile using the environment variable that you specified:

    MY_CUSTOM_ENV=qa bundle exec ruby ./my_application

