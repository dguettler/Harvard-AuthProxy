# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key        => '_cmir_session',
  :secret     => '47c6611016fc280054d5e6808e8957eb6cceba3102e045b3f01d8c038a614a24de68215fe6286f7a17a1aabc6b1b1a24adcb5a612be5dafe5633bf0738d9b33f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
ActionController::Base.session_store = :mem_cache_store
