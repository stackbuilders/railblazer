# Railblazer: Quick Rails app configuration

[![Build Status](https://secure.travis-ci.org/stackbuilders/railblazer.png)](http://travis-ci.org/stackbuilders/railblazer)

Railblazer helps you to spend less time setting up Rails apps by providing three scripts:

1. `app_adapter`: given a Gemfile, detects whether the application runs on mysql, mysql2, or postgres
2. `blaze`: build script that can be used by Jenkins
3. `db_config`: outputs a database.yml when given an adapter and app name.

In other words, Railblazer tries to take the work out of setting up things like builds on CI servers, assuming you're using RVM and bundler in your applications.

# Compatibility

Should run on Ruby 1.9.2 or greater. The tests require MiniTest, so they'll only run without
configuration on Ruby 1.9.3 (which includes MiniTest in stdlib).

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

# auto_configure

`auto_configure` automatically generates a database.yml and sunspot.yml. This is generated from a template for mysql, mysql2, and postgres included with this gem.  If you want, you can also override the default templates by including templates in a directory named `~/.blaze/templates`.

Example usage:

```
auto_configure RAILS_ROOT APP_OR_BUILD_NAME
```

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