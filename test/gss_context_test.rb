require File.join(File.dirname(__FILE__), 'test_helper.rb')

class GssContextTest < Test::Unit::TestCase

if Net::SSH::Kerberos::Drivers.available.include? 'GSS'

  def setup
    @gss = Net::SSH::Kerberos::Drivers::GSS::Context.new 
  end

  def teardown
    @gss.dispose
  end

  def test_create
    @gss.create ENV['USER'], Socket.gethostbyname(`hostname || echo "localhost"`.strip)[0]
    assert @gss.credentials?, "Should have acquired credentials"
  end

  def test_init
    test_create
    @gss.init nil
    state = @gss.send(:state)
    assert ! state.handle.nil?, "Should have provided an initial context"
    assert ! state.token.nil?, "Should have built an initial token"
    assert state.token.length.nonzero?, "Should have built an initial token"
  end

else
  def test_nothing; assert true end
end

end

