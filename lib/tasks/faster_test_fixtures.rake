class Fixture
  attr_reader :class_name
  
  def find_id
    klass = @class_name.is_a?(Class) ? @class_name : (Object.const_get(@class_name) rescue nil)
    if klass
      self[klass.primary_key]
    else
      self['id'] # if we can't find the class just assume id
    end
  end
end

namespace :db do
  namespace :fixtures do
    desc 'checks whether fixtures were modified before loading'
    task :lazy_loader do
      reload_fixtures = true
      fixtures_last_mod = File.join(File.dirname(__FILE__), '../../', 'tmp', 'fixtures_last_modified')
      if File.exists?(fixtures_last_mod)
        last_loaded_at = File.mtime(fixtures_last_mod)
        unless last_loaded_at < Time.now - 7200 # 2 hours ago
          reload_fixtures = false if Dir[File.dirname(__FILE__) + "/../../spec/fixtures/**/*.yml"].entries.find {|f| File.mtime(f) > last_loaded_at}.nil?
        end
      end
      if reload_fixtures
        original_env, RAILS_ENV = RAILS_ENV, 'test' # doubt this makes a difference, but let's be safe
        Rake::Task["db:fixtures:load_template_app_fixtures"].invoke
        FileUtils.touch(fixtures_last_mod)
        RAILS_ENV = original_env
      end
    end

    desc "loads fixtures into test database"
    task :load_template_app_fixtures => :environment do
      puts "loading template_app fixtures"
      require 'active_record/fixtures'
      fixture_accessors = []
      ActiveRecord::Base.establish_connection('test'.to_sym)
      main_fixtures = Dir.glob(File.join(File.dirname(__FILE__), '../..', 'spec', 'fixtures', '*')).reject { |file| File.directory?(file) }
      main_fixtures.each do |fixture_file|
        Fixtures.create_fixtures(File.dirname(__FILE__) + '/../../spec/fixtures', File.basename(fixture_file, '.*'))
      end
    end
    
  end
end
