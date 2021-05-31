require "test_helper"

class OperationTest < ActiveSupport::TestCase
  test "check new operation count default 0" do
    operation = Operation.new(input1: 1, input2: 1, result: 2, action: 'sum')
    assert_equal 0, operation.count
  end

  test "check operation process with empty input" do
    params = {
      input1: '',
      input2: 1,
      operation: 'sum'
    }
    assert_nil Operation.process(params)
  end

  test "check operation process invalid with input greater than 99" do
    params = {
      input1: 10,
      input2: 100,
      operation: 'sum'
    }
    assert_nil Operation.process(params)
  end

  test "check operation process invalid with input lower than 0" do
    params = {
      input1: -10,
      input2: 10,
      operation: 'sum'
    }
    assert_nil Operation.process(params)
  end

  test "check operation process invalid with division when input2 is 0" do
    params = {
      input1: 10,
      input2: 0,
      operation: 'division'
    }
    assert_nil Operation.process(params)
  end

  test "check operation process invalid action name" do
    params = {
      input1: 10,
      input2: 10,
      operation: 'invalid'
    }
    assert_nil Operation.process(params)
  end

  test "check valid operation process count increment" do
    params = {
      input1: rand(1..99),
      input2: rand(1..99),
      operation: 'sum'
    }
    operation1 = Operation.process(params)
    operation2 = Operation.process(params)
    assert_equal operation1.count + 1, operation2.count
  end

  test "check same operation process will return same document" do
    params = {
      input1: rand(1..99),
      input2: rand(1..99),
      operation: 'sum'
    }
    operation1 = Operation.process(params)
    operation2 = Operation.process(params)
    assert_equal operation1._id.to_s, operation2._id.to_s
  end

  test "check valid operation process sum" do
    a = rand(0..99)
    b = rand(0..99)
    params = {
      input1: a,
      input2: b,
      operation: 'sum'
    }
    operation = Operation.process(params)
    assert_equal a + b, operation.result
  end

  test "check valid operation process difference" do
    a = rand(0..99)
    b = rand(0..99)
    params = {
      input1: a,
      input2: b,
      operation: 'difference'
    }
    operation = Operation.process(params)
    assert_equal a - b, operation.result
  end

  test "check valid operation process multiplication" do
    a = rand(0..99)
    b = rand(0..99)
    params = {
      input1: a,
      input2: b,
      operation: 'multiplication'
    }
    operation = Operation.process(params)
    assert_equal a * b, operation.result
  end

  test "check valid operation process division" do
    a = rand(0..99)
    b = rand(1..99)
    params = {
      input1: a,
      input2: b,
      operation: 'division'
    }
    operation = Operation.process(params)
    assert_equal a.to_f / b.to_f, operation.result
  end

  test "check as json integer result" do
    params = {
      input1: 10,
      input2: 5,
      operation: 'division'
    }
    operation = Operation.process(params)
    assert_equal 2, operation.as_json[:result]
  end

  test "check as json float result" do
    params = {
      input1: 1,
      input2: 2,
      operation: 'division'
    }
    operation = Operation.process(params)
    assert_equal 0.5, operation.as_json[:result]
  end

  test "check as json always show integer value in operation" do
    params = {
      input1: 10.5,
      input2: 2,
      operation: 'division'
    }
    operation = Operation.process(params)
    assert_equal "10 / 2", operation.as_json[:operation]
  end
end
