# Railblazer: Quick Rails app configuration

[![Build Status](https://secure.travis-ci.org/stackbuilders/railblazer.png)](http://travis-ci.org/stackbuilders/railblazer)

Railblazer helps you to spend less time setting up Rails apps, particularly on CI servers, by providing five scripts:

1. `app_adapter`: given a Gemfile, determines whether the application runs on mysql, mysql2, or postgres
2. `auto_configure`: outputs a database.yml based on a template when given an adapter and app name.
3. `blaze`: build script that can be used by Jenkins
4. `cap_deploy`: deploys an application with migrations using capistrano
5. `heroku_deploy`: deploys an application to heroku, runs migrations, and restarts the app
6. `runner`: script to run anything as the RVM Ruby

In other words, Railblazer tries to take the work out of setting up things like builds on CI servers, assuming you're using RVM and bundler in your applications.

# Compatibility

Railblazer only runs on Ruby 1.9.3 or newer Ruby versions. It can, however, be used to configure Rails apps using previous ruby versions.

# Installation

You can install railblazer via the gem, but since gems that you install are limited to a particular gemset or Ruby version (assuming you're running rvm), you can just clone this repository. In order to
run the scripts in this package, just add the `bin` directory in this repository to your path.

# app_adapter

`app_adapter` detects the database adapter used in a Rails application when given a Gemfile path
as an argument:

```
app_adapter ~/Code/project/Gemfile
```

This will return a string like `mysql2` without a trailing newline (for easier inclusion in other scripts). The program will raise an error if exactly one adapter is not found. It currently only
works with applications that use the mysql, mysql2, or postgres (pg) adapters.

# auto_configure

`auto_configure` automatically generates a database.yml, sunspot.yml and redis configuration. This is generated from a template for mysql, mysql2, and postgres included with this gem.  If you want, you can also override the default templates by including templates in a directory named `~/.blaze/templates`.

Example usage:

```
auto_configure RAILS_ROOT APP_OR_BUILD_NAME
```

# blaze

`blaze` is a shell script that can be used by Jenkins. It assumes that for your build you don't want to run migrations, and that instead we should just drop the test db, re-create it, and load the schema.rb file.

It also does the following, which we find useful in our CI builds:

1. Load the RVM environment
2. Run bundle (excluding the production environment)
3. Run the tests with xvfb-run, autodetecting an available buffer (for simultaneous builds that need to open windows, for things like Selenium)
4. Auto-generate a database.yml (requires `app_adapter` to be in the `$PATH`)

The script uses variables like ${WORKSPACE} and ${JOB_NAME}, which are passed by default to scripts
invoked from Jenkins.

Example usage:

```
blaze
```

# cap_deploy

Loads rvm, and deploys application with migrations using capistrano. Usage:

```
cap_deploy DEPLOY_ENVIRONMENT
```

This script depends on the variables $GIT_COMMIT and $WORKSPACE being set in the environment
prior to invocation.

# deploy_heroku

Pushes an application to Heroku, runs migrations, and restarts the app. Usage:

```
heroku_deploy APP_NAME
```

# runner

Runs the given argument as if it was run from the command line after loading RVM. Usage:

```
runner "rake db:migrate"
```
This script depends on the variables $GIT_COMMIT and $WORKSPACE being set in the environment
prior to invocation.

# Concurrency

Railblazer is designed to help you run multiple builds in parallel for different projects. This means that it has to
namespace the data stores your application may use. It namespaces things in the following way:

1. Databases - databases are namespaced according to the application name given to the auto-configuration scripts
2. SOLR - If your application uses sunspot_rails, Railblazer generates a sunspot.yml that chooses a random port in the 8900 range
3. Redis - If your application uses resque, we randomly choose a database number from 0 - 63, initialize a redis connection and whack this into your rails app with a sledgehammer (overwriting any connections you may initialize with Resque.redis or $redis). You will probably need to set your redis.conf databases to 64, instead of the default 16 for this to work.

Suggestions are always welcome about how to make Rails applications automatically play nicer in the same sandbox.

# Summary

Railblazer helps with configuration of database connections in Rails apps, and provides scripts which can help with configuraiton of Rails apps for CI server builds.

Instead of relying on the database.sample.yml files included in many Rails apps, I find that it's often easier to just copy a working database.yml from another project on my computer. These settings reflect things like the correct host and username / password configuration for my local workstation. I think that we can move towards slightly less configuration work for new Rails apps on workstations that are already in use by developers by building up frameworks that:

1. use local templates for database configuration and
2. auto-detect the database adapter from the Rails application configuration.

Railblazer provides a first pass at automating this type of configuration, and provides a script showing how this is useful in the context of auto-configuring apps for Jenkins CI server.

# Author

Justin Leitgeb <justin@stackbuilders.com>

# License

See the LICENSE file included with the program.