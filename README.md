# Working with Events in Ruby

[Samuel Mullen](http://samuelmullen.com/) gave a nice talk at the Kansas City
Ruby user group in June 2013 about the dangers of relying on Rails' callbacks
and observers. His presentation highlighted most of what he covers in
[his blogpost](http://samuelmullen.com/2013/05/the-problem-with-rails-callbacks/)
on the same topic.

I've used a similar pattern when working with PHP but taken it a step further
in decoupling my domain objects from performing service object behavior by
relying on events.

I explained my ideas to the group and a few said they would love to see the
code for such an implementation.

There are a few existing gems that tackle events already, and I'll try them
out in different "attempt" directories within this repository.

## Attempt 1 - My Custom Implementation

This is a custom proof of concept I've written to implement the Observer
pattern in Ruby. I based it off of an implementation I'm familiar with from
working with the PHP library [Symfony2 Event Dispatcher](http://symfony.com/doc/current/components/event_dispatcher/introduction.html#the-dispatcher).
There may be "a more Ruby-way" to do things, of which I'm still ignorant of.

This is my first Ruby thing ever, and it was mostly an exercise in learning
but also in showing a concept others found interesting from the KC Ruby group.

Supports:

* Dispatch named events
* Registering listeners to handle events as:
    * Object instance methods
    * Procs

To run:

    ruby attempt1/app.rb
