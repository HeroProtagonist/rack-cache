require "#{File.dirname(__FILE__)}/spec_setup"
require 'rack/cache/core'

class MockCore
  include Rack::Cache::Core
  alias_method :initialize, :initialize_core
  public :on, :transition, :trigger
end

describe 'Rack::Cache::Core' do
  before(:each) { @core = MockCore.new }

  it 'has events after instantiation' do
    @core.events.should.respond_to :[]
  end

  it 'defines and triggers event handlers' do
    executed = false
    @core.on(:foo) { executed = true }
    @core.trigger :foo
    executed.should.be true
  end

  it 'executes multiple handlers in LOFO (last-on, first-off order)' do
    x = 'nothing executed'
    @core.on :foo do
      x.should.be == 'bottom executed'
      x = 'top executed'
    end
    @core.on :foo do
      x.should.be == 'nothing executed'
      x = 'bottom executed'
    end
    @core.trigger :foo
    x.should.be == 'top executed'
  end

  it 'records event execution history' do
    @core.on(:foo) {}
    @core.trigger :foo
    @core.should.a.performed :foo
  end

  it 'raises an exception when asked to perform an unknown event' do
    assert_raises NameError do
      @core.trigger :foo
    end
  end

  it 'raises an exception when asked to transition to an unknown event' do
    @core.on(:bling) {}
    @core.on(:foo) { bling! }
    lambda { @core.transition(from=:foo, to=[:bar, :baz]) }.
      should.raise Rack::Cache::IllegalTransition
  end

  it 'passes transition arguments to handlers' do
    passed = nil
    @core.meta_def(:perform_bar) do |*args|
      passed = args
      'hi'
    end
    @core.on(:bar) {}
    @core.on(:foo) { bar! 1, 2, 3 }
    result = @core.transition(from=:foo, to=[:bar])
    passed.should.be == [1,2,3]
    result.should.be == 'hi'
  end

  it 'runs events when a message matching the event name is sent to the receiver' do
    x = 'not executed'
    @core.on(:foo) { x = 'executed' }
    @core.should.respond_to :foo!
    @core.trigger(:foo).should.be.nil
    x.should.be == 'executed'
  end

  it 'fully transitions out of handlers when the next event is invoked' do
    x = []
    @core.on(:foo) {
      x << 'in foo, before transitioning to bar'
      bar!
      x << 'in foo, after transitioning to bar'
    }
    @core.on(:bar) { x << 'in bar' }
    @core.trigger(:foo).should.be == [:bar]
    @core.trigger(:bar).should.be.nil
    x.should.be == [
      'in foo, before transitioning to bar',
      'in bar'
    ]
  end

  it 'returns the transition event name' do
    @core.on(:foo) { throw(:transition, [:bar]) }
    @core.trigger(:foo).should.be == [:bar]
  end

end
