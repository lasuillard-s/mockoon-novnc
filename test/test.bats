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

@test "NGINX forward traffic to Mockoon 3000 port by default" {
  run curl --fail http://localhost/users
}

@test "NGINX handle port range 3000-3999 in path component" {
  run curl --fail http://localhost/2999/users
  [ "$status" -eq 22 ] # (22) The requested URL returned error: 404

  run curl --fail http://localhost/3000/users

  run curl --fail http://localhost/4000/users
  [ "$status" -eq 22 ] # (22) The requested URL returned error: 404
}

@test "can reach noVNC client" {
  run curl --fail http://localhost:8080/vnc.html
}

@test "Header-based port forwarding with X-Port-Forward header" {
  run curl --fail http://localhost
  [ "$status" -eq 22 ] # (22) The requested URL returned error: 404

  run curl --fail --silent http://localhost --header 'X-Port-Forward: 3678'
  assert_output '{"Hello": "World!"}'
}
