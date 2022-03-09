# Async HTTP Test

## Commandline

```
# Start HTTP server
$ docker run --rm -p 5678:5678 hashicorp/http-echo -text="hello world"

# Start the test script
$ bundle install
$ bundle exec ruby test.rb 10000
```

## Environment

```
$ uname -a
Darwin Quartet.local 21.3.0 Darwin Kernel Version 21.3.0: Wed Jan  5 21:37:58 PST 2022; root:xnu-8019.80.24~20/RELEASE_X86_64 x86_64

$ ruby -v
ruby 3.1.1p18 (2022-02-18 revision 53f5fc4236) [x86_64-darwin21]
```

## Result

Two unexpected things happening:

1. It raises `Too many open files` errors
2. It doesn't finish, even with smaller # of requests

### It raises errors

I'm assuming the `Async::Semaphore.new(10)` limits the number of the concurrent requests to 10, so this won't happen.

```
               |   Errno::EMFILE: Too many open files - socket(2)
               |   → /Users/soutaro/.rbenv/versions/3.1.1/lib/ruby/gems/3.1.0/gems/async-io-1.33.0/lib/async/io/socket.rb:87 in `initialize'
               |     /Users/soutaro/.rbenv/versions/3.1.1/lib/ruby/gems/3.1.0/gems/async-io-1.33.0/lib/async/io/socket.rb:87 in `new'
               |     /Users/soutaro/.rbenv/versions/3.1.1/lib/ruby/gems/3.1.0/gems/async-io-1.33.0/lib/async/io/socket.rb:87 in `build'
               |     /Users/soutaro/.rbenv/versions/3.1.1/lib/ruby/gems/3.1.0/gems/async-io-1.33.0/lib/async/io/socket.rb:123 in `connect'
               |     /Users/soutaro/.rbenv/versions/3.1.1/lib/ruby/gems/3.1.0/gems/async-io-1.33.0/lib/async/io/host_endpoint.rb:59 in `block in connect'
               |     /Users/soutaro/. 1.83s    error: Async::Task [oid=0x3818] [ec=0x382c] [pid=87756] [2022-03-09 15:21:23 +0900]
               |   Errno::EMFILE: Too many open files - socket(2)
               |   → /Users/soutaro/.rbenv/versions/3.1.1/lib/ruby/gems/3.1.0/gems/async-io-1.33.0/lib/async/io/socket.rb:87 in `initialize'
               |     /Users/soutaro/.rbenv/versions/3.1.1/lib/ruby/gems/3.1.0/gems/async-io-1.33.0/lib/async/io/socket.rb:87 in `new'
               |     /Users/soutaro/.rbenv/versions/3.1.1/lib/ruby/gems/3.1.0/gems/async-io-1.33.0/lib/async/io/socket.rb:87 in `build'
               |     /Users/soutaro/.rbenv/versions/3.1.1/lib/ruby/gems/3.1.0/gems/async-io-1.33.0/lib/async/io/socket.rb:123 in `connect'
               |     /Users/soutaro/.rbenv/versions/3.1.1/lib/ruby/gems/3.1.0/gems/async-io-1.33.0/lib/async/io/host_endpoint.rb:59 in `block in connect'
               |     /Users/soutaro/. 1.84s    error: Async::Task [oid=0x3840] [ec=0x3854] [pid=87756] [2022-03-09 15:21:23 +0900]
```

![toomany.gif](https://raw.githubusercontent.com/soutaro/async-test/master/toomany.gif)

## It doesn't finish

It prints the following message, and stops.

```
 0.05s     warn: Async::HTTP::Client [oid=0xde8] [ec=0xdfc] [pid=87983] [2022-03-09 15:33:10 +0900]
               | Waiting for Async::HTTP::Protocol::HTTP1 pool to drain: #<Async::Pool::Controller(100/∞) 1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1;1/1/1>
```

![stop.gif](https://raw.githubusercontent.com/soutaro/async-test/master/stop.gif)
