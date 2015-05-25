require 'mongo'
require 'pry'

Mongo::Logger.logger.level = 1
client = Mongo::Client.new(['localhost:27017', 'localhost:27018', 'localhost:27019'], database: 'failover', replica_set: 'replica_set')

def failover
  begin
    yield if block_given?
  rescue Mongo::Error::SocketError, Errno::ECONNREFUSED => ex
    puts ex
    puts ex.class
    puts '- Server Down -'
    puts 'Retrying connections ...'
    sleep(2.5)
    puts '-' * 100
    retry
  end
end

loop do
  failover do
    client[:users].find.each do |user|
      puts "Servers Up and Running: #{ client.cluster.servers.map(&:address).map(&:seed) }"
      puts "Reading from server: #{ client.cluster.next_primary.address }"
      puts "Users name: #{ user }"
      puts '-' * 100
      sleep(3)
    end
  end
end

