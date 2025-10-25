# frozen_string_literal: true

# Rack Attack configuration for rate limiting and security
module Rack
  class Attack
    # Configure cache store (using Rails cache)
    Rack::Attack.cache.store = Rails.cache

    # Disable rate limiting in test environment
    if Rails.env.test?
      # Allow all requests in test environment
      safelist('allow-all-test') do |_req|
        true
      end
    end

    # Allow requests from localhost in development
    if Rails.env.development?
      Rack::Attack.safelist('allow-localhost') do |req|
        ['127.0.0.1', '::1'].include?(req.ip)
      end
    end

    # Rate limiting for API endpoints
    # Limit API requests to 100 per minute per IP
    throttle('api/ip', limit: 100, period: 1.minute) do |req|
      if req.path.start_with?('/api/')
        req.ip
      end
    end

    # Rate limiting for authentication endpoints
    # Limit login attempts to 5 attempts per minute per IP
    throttle('auth/login', limit: 5, period: 1.minute) do |req|
      if req.path == '/users/sign_in' && req.post?
        req.ip
      end
    end

    # Rate limiting for password reset
    # Limit password reset requests to 3 per hour per IP
    throttle('auth/password_reset', limit: 3, period: 1.hour) do |req|
      if req.path == '/users/password' && req.post?
        req.ip
      end
    end

    # Rate limiting for user registration
    # Limit registration attempts to 3 per hour per IP
    throttle('auth/registration', limit: 3, period: 1.hour) do |req|
      if req.path == '/users' && req.post?
        req.ip
      end
    end

    # Rate limiting for general web requests
    # Limit to 1000 requests per minute per IP (more generous for testing)
    throttle('req/ip', limit: 1000, period: 1.minute, &:ip)

    # Block suspicious requests (commented out for testing)
    # Block requests with suspicious user agents
    # blocklist('block-suspicious-ua') do |req|
    #   suspicious_ua = %w[
    #     curl wget python-requests
    #     libwww-perl lwp-trivial
    #     masscan nmap sqlmap
    #     nikto dirb gobuster
    #   ]
    #
    #   suspicious_ua.any? { |ua| req.user_agent&.downcase&.include?(ua) }
    # end

    # Block requests with no user agent (commented out for testing)
    # blocklist('block-no-ua') do |req|
    #   req.user_agent.blank?
    # end

    # Block requests from known bad IPs (you can expand this list)
    blocklist('block-bad-ips') do |_req|
      # Add known malicious IPs here
      # Example: ['1.2.3.4', '5.6.7.8'].include?(req.ip)
      false # Set to false for now, add IPs as needed
    end

    # Custom response for blocked requests
    self.blocklisted_responder = lambda do |_env|
      [
        403, # status
        { 'Content-Type' => 'application/json' }, # headers
        [{ error: 'Access forbidden.' }.to_json] # body
      ]
    end

    # Custom response for throttled requests
    self.throttled_responder = lambda do |_env|
      [
        429,
        { 'Content-Type' => 'application/json' },
        [{ error: 'Rate limit exceeded. Please try again later.' }.to_json]
      ]
    end

    # Log blocked requests
    ActiveSupport::Notifications.subscribe('rack.attack') do |_name, _start, _finish, _request_id, payload|
      req = payload[:request]
      Rails.logger.warn "[Rack::Attack] #{req.ip} #{req.request_method} #{req.fullpath} - #{payload[:match_discriminator]}"
    end
  end
end
