setup_file() {
  docker compose up -d --build --wait --wait-timeout 30
}

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
}

teardown_file() {
  docker compose down
}

@test "NGINX forward traffic to Mockoon 3000 port by default" {
  run curl -f http://localhost/users
}

@test "NGINX handle port range 3000-3999 in path component" {
  run curl -f http://localhost/2999/users
  [ "$status" -eq 22 ] # (22) The requested URL returned error: 404

  run curl -f http://localhost/3000/users

  run curl -f http://localhost/4000/users
  [ "$status" -eq 22 ] # (22) The requested URL returned error: 404
}

@test "can reach noVNC client" {
  run curl -f http://localhost:8080/vnc.html
}

@test "Header-based port forwarding with X-Port-Forward header" {
  run curl -f http://localhost
  [ "$status" -eq 22 ] # (22) The requested URL returned error: 404

  run curl -fs http://localhost -H 'X-Port-Forward: 3678'
  assert_output '{"Hello": "World!"}'
}
