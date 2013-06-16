# Proof of concept Event Dispatcher implementing the Observer pattern

class EventDispatcher
  def initialize
    @storage = {}
  end

  def register(name, callback)
    @storage[name] = [] if !@storage.has_key?(name)
    @storage[name].push(callback)
  end

  def notify(name, event)
    return false if !self.has_callbacks_for?(name)

    # Execute all callbacks of this name
    for callback in @storage[name]
      if callback.instance_of? Array
        self.call_instance_method(callback.first, callback.last)
      else
        callback.call(event, self) if callback.instance_of? Proc
      end
    end
  end

  def has_callbacks_for?(name)
    @storage.has_key?(name) or !@storage.empty?
  end

  def call_instance_method(object, method)
    object.__send__(method)
  end
end

# Our plain old Ruby object from our domain model
class Post
  attr_accessor :author, :title, :body

  def save
    puts '**Yay! A Post was saved!**'
  end
end

# Event object passed to each callback
class PostEvent
  attr :post

  def initialize(post)
    @post = post
  end
end

# Constants for our event names
class PostEvents
  CREATE = 'post.create'
end

# Some service class
class Emailer
  def send_some_email
    puts "Spam email from an instance method!"
  end
end

# Setup the EventDispatcher
dispatcher = EventDispatcher.new

# Register listeners. Anonymous functions here for simplicity
# but you could add class methods?
# You could do this in a Rails initializer
dispatcher.register(PostEvents::CREATE, Proc.new {|event, dispatcher|
  post = event.post
  puts 'New post by %s: %s' % [post.author, post.title]
  puts post.body

  # Could trigger a chained event
  # event = PostEvent.new(post)
  # dispatcher.notify('chained.event', event)
})
# A chained event
dispatcher.register('chained.event', Proc.new {|event, dispatcher|
  puts 'Chained event was called too!'
})

# Common use case: call instance method on a service object
dispatcher.register(PostEvents::CREATE, [Emailer.new, :send_some_email])


# Imagine this were a Controller method if your web app...

# Do work to hydrate an object
post = Post.new
post.author = 'John Kary'
post.title = 'Event Dispatcher Proof of Concept'
post.body = 'This is a basic implementation of the Observer pattern in Ruby. Away with yee ActiveRecord callbacks and Observers!'
post.save # or however you persist YOUR objects

# Build and dispatch an Event object
event = PostEvent.new(post)
dispatcher.notify(PostEvents::CREATE, event)
