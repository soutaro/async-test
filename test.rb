require 'async'
require 'async/barrier'
require 'async/http/internet'
require "async/http/internet/instance"

count = (ARGV[0] || 10000).to_i

Async do
  internet = Async::HTTP::Internet.new
  begin
    barrier = Async::Barrier.new
    semaphore = Async::Semaphore.new(10)

    count.times do
      semaphore.async(parent: barrier) do
        response = internet.get "http://127.0.0.1:5678/foo"
        puts "response #{response.status}"
      end
    end

    barrier.wait
  ensure
    internet.close
  end
end
