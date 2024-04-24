# UTMConversion

A Ruby on Rails gem for capturing, storing, and retrieving UTM parameters for conversion tracking and analytics.

**Important**

Tracking and recording conversions using this Gems requires concent from the user. Please ensure that you are compliant with all relevant data protection laws and regulations.

## Installation

Add this line to your application's Gemfile:

> gem 'utm_conversion'

And then execute:

> $ bundle install

## Usage

1.  Configuration (Optional):

* Configure the storage adapter within a Rails initializer (e.g., `config/initializers/utm_conversion.rb`) using a block:

```ruby
UTMConversion.configure do |config|
  config.storage_adapter = MyCustomStorageAdapter.new
end
```

* The default adapter is `UTMConversion::Storage::InMemory`, which stores UTM data in memory.

2. Automatic UTM Capture:

* The gem automatically includes the `UTMConversion::Capture::UTMParamsMiddleware` to capture UTM parameters from incoming requests and store them in the session and the configured storage adapter.

To include the middleware in your rails app you can add the following line to your `config/application.rb` file:

```ruby
config.middleware.use UTMConversion::Capture::UTMParamsMiddleware
```

3. Accessing UTM Data:
* In your controllers or models, you can access the captured UTM data using the `UTMConversion::Session::UTMData` class:

```ruby
utm_data = UTMConversion::Session::UTMData.load(session)
if utm_data
    # Access UTM parameters: utm_data.data['utm_source'], etc.
end
```

If the data was already stored in the storage adapter (e.g., from a previous session), you can retrieve it using the `UTMConversion` module directly:

```ruby
UTMConversion.retrieve_utm_data(session_id)
```

4. Recording Conversions:

* Implement the `record_conversion(session_id, event_data)` method in your chosen storage adapter to record conversions along with the associated session ID and any relevant event data.

To record a new conversion:

```ruby
UTMConversion.record_conversion(session, event_data)
```

UTM data is stored automatically, but to call it manually you can use the following method:

```ruby
UTMConversion.store_utm_data(session, event_data)
```

## Customization

* Storage Adapters:
    * Create custom storage adapters by extending the `UTMConversion::Storage::Base` class and implementing the required methods (`store`, `retrieve`, `record_conversion`).

    * Refer to the `UTMConversion::Storage::InMemory` adapter for an example implementation.

## Contributing

1. Fork the project
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new pull request

## License

The gem is available as open source under the terms of the MIT License.