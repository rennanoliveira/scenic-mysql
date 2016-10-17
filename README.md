# Scenic::Mysql

Scenic-Mysql adds a Mysql Adapter to [scenic](https://github.com/thoughtbot/scenic)

## Installing

Add to your `Gemfile`:

```ruby
gem 'scenic'
gem 'scenic-mysql'
```

Then `bundle install`.

## Configuring scenic to use the Mysql adapter

```ruby
# config/initializers/scenic.rb
Scenic.configure do |config|
  config.adapter = Scenic::Adapters::Mysql.new
end
```

And that's all!

## Caveats

Mysql does not offer support for materialized views, so any calls to materialized views
will either result in `false`, or raise a `Scenic::Adapters::Mysql::MaterializedViewsNotSupportedError`

## About

scenic-mysql is currently maintained by [Rennan Oliveira] and [Abraão Miranda].
 
This gem is merely a Mysql adapter implementation to the awesome [scenic](https://github.com/thoughtbot/scenic) project,
and in no way claims to have any direct relation with its maintainers.

[Rennan Oliveira]: https://github.com/rennanoliveira
[Abraão Miranda]: https://github.com/abraaomiranda

