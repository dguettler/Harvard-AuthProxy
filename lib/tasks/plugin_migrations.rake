namespace :db do

  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x. Turn off output with VERBOSE=false."
  task :migrate_plugin => :environment do
    plugin = Desert::Plugin.new(File.dirname(__FILE__) + '/../../')
    Desert::PluginMigrations::Migrator.migrate_plugin(plugin, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end

end