require 'test_helper'

class AllocTest < ActiveSupport::TestCase

  test "columns" do
    cols = Alloc.columns
    assert_equal [:range, :ip, :device], cols
  end

  test "column attributes" do
    alloc = Alloc.new
    assert alloc.respond_to?(:range)
    assert alloc.respond_to?(:ip)
    assert alloc.respond_to?(:device)
  end

  test "unknown attributes" do
    alloc = Alloc.new
    assert_not alloc.respond_to?(:admin)
    assert_not alloc.respond_to?(:something)
  end

  test "initialize" do
    alloc = Alloc.new(ip: '1.2.3.4', device: 'device12', range: '1.2.3.0/10')
    assert_equal '1.2.3.4', alloc.ip
    assert_equal 'device12', alloc.device
    assert_equal '1.2.3.0/10', alloc.range
  end

  test "initialize with unknown attributes" do
    assert_raises(Exception) do
      Alloc.new(ip: '1.2.3.4', admin: true)
    end
  end

  test "validates presence" do
    alloc = Alloc.new
    assert_not alloc.valid?
    assert_equal ["Ip can't be blank", "Device can't be blank"], alloc.errors.full_messages

    alloc.ip = '1.2.123.124'
    alloc.device = 'device12'
    assert alloc.valid?
  end

  test "validates ip format" do
    alloc = Alloc.new(device: 'device1', ip: '1.3.45.xx')
    assert_not alloc.valid?
    assert_equal ['Ip is invalid'], alloc.errors.full_messages

    alloc.ip = '1.2.3'
    assert_not alloc.valid?
    assert_equal ['Ip is invalid'], alloc.errors.full_messages
  end

  test "validates device format" do
    alloc = Alloc.new(device: 'device', ip: '1.3.45.23')
    assert_not alloc.valid?
    assert_equal ['Device is invalid'], alloc.errors.full_messages

    alloc.device = 'devicexx'
    assert_not alloc.valid?
    assert_equal ['Device is invalid'], alloc.errors.full_messages
  end
  
end
