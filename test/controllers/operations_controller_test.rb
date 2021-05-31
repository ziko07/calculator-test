require "test_helper"

class OperationsControllerTest < ActionDispatch::IntegrationTest
  test "root url return success response" do
    get root_url
    assert_response :success
  end

  test "create url return success response with document object in response body" do
    post operations_url, params: {
      input1: rand(1..99),
      input2: rand(1..99),
      operation: 'sum'
    }, xhr: true
    assert_response :success
    assert_not_nil response.body
  end

  test "create url return null string fo any invalid operation" do
    post operations_url, params: {
      input1: rand(1..99),
      input2: 0,
      operation: 'division'
    }, xhr: true
    assert_response :success
    assert_equal "null", response.body
  end
end
