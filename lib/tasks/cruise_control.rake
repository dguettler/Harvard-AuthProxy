require 'rcov/rcovtask'
require 'spec/rake/verify_rcov'
RCov::VerifyTask.new(:harvard_pin_verify_rcov)            { |t| t.threshold = 100.0; t.require_exact_threshold = false }
RCov::VerifyTask.new(:harvard_pin_verify_controller_rcov) { |t| t.threshold = 100.0; t.require_exact_threshold = false }
RCov::VerifyTask.new(:harvard_pin_verify_helper_rcov)     { |t| t.threshold = 100.0; t.require_exact_threshold = false }
RCov::VerifyTask.new(:harvard_pin_verify_model_rcov)      { |t| t.threshold = 100.0; t.require_exact_threshold = false }

namespace :cruisecontrol do

  desc "Task for cruise Control"
  task :harvard_pin_full_test do
    RAILS_ENV = ENV['RAILS_ENV'] = 'test' # Without this, it will drop your production database.
    Rake::Task['db:migrate_plugin'].invoke
    Rake::Task["cruisecontrol:harvard_pin_full_coverage_test"].invoke
  end

  desc "Task for cruise Control"
  task :harvard_pin_full_coverage_test do
    RAILS_ENV = ENV['RAILS_ENV'] = 'test' # Without this, it will drop your production database.
    Rake::Task["cruisecontrol:harvard_pin_coverage_test"].invoke
    Rake::Task["cruisecontrol:harvard_pin_individual_coverage_test"].invoke
  end

  desc "Task for cruise Control"
  task :harvard_pin_coverage_test do
    RAILS_ENV = ENV['RAILS_ENV'] = 'test' # Without this, it will drop your production database.
    Rake::Task["cruisecontrol:harvard_pin_rcov"].invoke
    Rake::Task["harvard_pin_verify_rcov"].invoke
  end

  desc "Coverage test for Controllers, Models, Helpers"
  task :harvard_pin_individual_coverage_test do
    RAILS_ENV = ENV['RAILS_ENV'] = 'test' # Without this, it will drop your production database.
    Rake::Task["cruisecontrol:harvard_pin_controller_rcov"].invoke
    Rake::Task["harvard_pin_verify_controller_rcov"].invoke
    Rake::Task["cruisecontrol:harvard_pin_helper_rcov"].invoke
    Rake::Task["harvard_pin_verify_helper_rcov"].invoke
    Rake::Task["cruisecontrol:harvard_pin_model_rcov"].invoke
    Rake::Task["harvard_pin_verify_model_rcov"].invoke
  end

  desc "Rcov test mixing controllers, helpers and models"
  Rcov::RcovTask.new(:harvard_pin_rcov) do |t|
    t.test_files = FileList['spec/**/*.rb']
    t.rcov_opts << "--exclude config,lib,spec,stories,vendor"
    t.verbose = true
  end

  desc "Rcov test for controllers only"
  Rcov::RcovTask.new(:harvard_pin_controller_rcov) do |t|
    t.test_files = FileList['spec/controllers/**/*.rb']
    t.rcov_opts << "--exclude config,lib,spec,stories,vendor,helpers,models"
    t.verbose = true
  end

  desc "Rcov test for helpers only"
  Rcov::RcovTask.new(:harvard_pin_helper_rcov) do |t|
    t.test_files = FileList['spec/helpers/**/*.rb']
    t.rcov_opts << "--exclude config,lib,spec,stories,vendor,controllers,models"
    t.verbose = true
  end

  desc "Rcov test for models only"
  Rcov::RcovTask.new(:harvard_pin_model_rcov) do |t|
    t.test_files = FileList['spec/models/**/*.rb']
    t.rcov_opts << "--exclude config,lib,spec,stories,vendor,controllers,helpers"
    t.verbose = true
  end

end
