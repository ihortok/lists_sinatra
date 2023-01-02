namespace :db do
  desc 'runs database migrations'
  task :migrate do
    db_username = ENV['LISTS_DATABASE_USERNAME']
    db_password = ENV['LISTS_DATABASE_PASSWORD']
    db_host = ENV['LISTS_DATABASE_HOST']
    db_name = ENV['LISTS_DATABASE_NAME']

    `sequel -m db/migrations postgresql://#{db_username}:#{db_password}@#{db_host}/#{db_name}`
  end
end
