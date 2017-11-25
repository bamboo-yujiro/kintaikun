# config valid only for current version of Capistrano
lock '3.4.1'

set :branch, ENV['BRANCH'] || "master"
set :application, 'kintaikun'
set :repo_url, 'git@github.com:bamboo-yujiro/kintaikun.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/kintaikun.bamboo-yujiro.com'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
#set :linked_files, fetch(:linked_files, []).push('.env')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'node_modules')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

#namespace :deploy do

#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
#    end
#  end

#end

Rake::Task["npm:install"].clear#既に登録されてる npm:install タスクを消す

before 'deploy:updated', 'npm:install'
set :npm_target_path, -> { release_path.join('node_modules') } # default not set

after 'deploy:publishing', 'deploy:restart'

namespace :npm do
  desc "npm のタスクです。"
  task :install do  # npm:install タスクを作成
    on roles fetch(:npm_roles) do
      within release_path do # これでpackage.json があるプロジェクトのルートまで入る
        execute :npm, 'install', fetch(:npm_flags)
      end
    end
  end

end

namespace :deploy do

  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

end
