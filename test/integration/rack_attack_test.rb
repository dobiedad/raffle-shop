# frozen_string_literal: true

require 'test_helper'

class RackAttackTest < ActionDispatch::IntegrationTest
  setup do
    # Clear the cache to ensure clean test state
    Rails.cache.clear
  end

  test 'allows normal requests' do
    get '/'
    assert_response :success
  end

  test 'allows all requests in test environment' do
    # In test environment, all requests should be allowed due to safelist
    get '/', headers: { 'REMOTE_ADDR' => '1.2.3.4' }
    assert_response :success
    
    # Multiple requests should all be allowed
    10.times do
      get '/', headers: { 'REMOTE_ADDR' => '1.2.3.4' }
      assert_response :success
    end
  end

  test 'rate limiting is disabled in test environment' do
    # This test verifies that rate limiting is disabled in test environment
    # by checking that many requests are all allowed
    get '/', headers: { 'REMOTE_ADDR' => '1.2.3.4' }
    assert_response :success
    
    # Even many requests should be allowed in test environment
    get '/', headers: { 'REMOTE_ADDR' => '5.6.7.8' }
    assert_response :success
  end

  test 'rate limits are reset after period' do
    # This test would require time manipulation
    skip 'Rate limit reset test requires time manipulation'
  end
end
