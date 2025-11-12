#!/usr/bin/env bats

setup_file() {
	docker compose up --detach --build --wait --wait-timeout 30
}

setup() {
	load 'test_helper/bats-support/load'
	load 'test_helper/bats-assert/load'
}

teardown_file() {
	docker compose down
}

# Basic tests
# ============================================================================
@test "NGINX forward traffic to Mockoon 3000 port by default" {
	run curl --fail http://localhost/users
	assert_success
}

@test "Can reach noVNC client" {
	run curl --fail http://localhost:8080/vnc.html
	assert_success
}

# Path-based port forwarding
# ============================================================================
@test "NGINX handle port range 3000-3999 in path component" {
	# Out of range (below 3000)
	run curl --fail http://localhost/2999/users
	assert_failure 22 # (22) The requested URL returned error: 404

	# Demo (default)
	run curl --fail http://localhost/3000/users
	assert_success

	# Out of range (over 3999)
	run curl --fail http://localhost/4000/users
	assert_failure 22 # (22) The requested URL returned error: 404
}

# Header-based port forwarding
# ============================================================================
@test "Header-based port forwarding with X-Port-Forward header" {
	# Out of range (below 3000)
	run curl --fail http://localhost --header 'X-Port-Forward: 2999'
	assert_failure 22 # (22) The requested URL returned error: 404

	# Test open for 3678
	run curl --fail --silent http://localhost --header 'X-Port-Forward: 3678'
	assert_output '{"Hello": "World!"}'

	# Out of range (over 3999)
	run curl --fail http://localhost --header 'X-Port-Forward: 4000'
	assert_failure 22 # (22) The requested URL returned error: 404
}
