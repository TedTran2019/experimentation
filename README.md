# experimentation

Testing various things
Time to stop using -m for commit haha...

## Updating old Ruby code from 2.2.3 and Rails 4.2

- Starting with Ruby 2.3.1 instead as it's compatible with 2.2.3
- Use `gem 'andand', git: 'git@github.com:raganwald/andand.git'` instead of `gem 'andand', :github => 'raganwald/andand'` where applicable
- Where possible, get gems from Rubygems.org instead of directly from git
- bundler update ffi -> ffi (1.15.5)
- gem install pg -v '0.17.1' -- --with-cflags="-Wno-error=implicit-function-declaration"
- redis-server, redis-cli, shutdown, deleting dump.rdb if switching Redis versions
- pg_ctl start, pg_ctl stop
