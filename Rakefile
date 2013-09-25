require 'pathname'

subprojects = %w| elasticsearch elasticsearch-transport elasticsearch-api |
__current__ = Pathname( File.expand_path('..', __FILE__) )

task :default do
  system "rake --tasks"
end

namespace :test do
  desc "Run `bundle install` in all subprojects"
  task :bundle do
    subprojects.each do |project|
      sh "bundle install --gemfile #{__current__.join(project)}/Gemfile"
      puts '-'*80
    end
  end

  desc "Run unit tests in all subprojects"
  task :unit do
    subprojects.each do |project|
      sh "cd #{__current__.join(project)} && bundle exec rake test:unit"
      puts '-'*80
    end
  end

  desc "Run integration tests in all subprojects"
  task :integration do
    subprojects.each do |project|
      sh "cd #{__current__.join(project)} && SERVER=y bundle exec rake test:integration"
      puts '-'*80
    end
  end

  desc "Run all tests in all subprojects"
  task :all do
    subprojects.each do |project|
      sh "cd #{__current__.join(project)} && SERVER=y bundle exec rake test:all"
      puts '-'*80
    end
  end

  namespace :server do
    desc "Start Elasticsearch nodes for tests"
    task :start do
      $LOAD_PATH << File.expand_path('../../elasticsearch-transport/lib', __FILE__) << File.expand_path('../test', __FILE__)
      require 'elasticsearch/transport'
      require 'elasticsearch/transport/extensions/test_cluster'
      Elasticsearch::TestCluster.start
    end

    desc "Stop Elasticsearch nodes for tests"
    task :stop do
      $LOAD_PATH << File.expand_path('../lib', __FILE__) << File.expand_path('../test', __FILE__)
      require 'elasticsearch/transport'
      require 'elasticsearch/transport/extensions/test_cluster'
      Elasticsearch::TestCluster.stop
    end
  end
end

desc "Generate documentation for all subprojects"
task :doc do
  subprojects.each do |project|
    sh "cd #{__current__.join(project)} && rake doc"
    puts '-'*80
  end
end