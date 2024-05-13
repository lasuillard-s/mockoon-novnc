setup_file() {
	docker compose up -d --build --wait --wait-timeout 30
}

teardown_file() {
	docker compose down
}

@test "NGINX forward traffic to Mockoon 3000 port by default" {
	curl -f http://localhost/users
}

@test "NGINX handle port range 3000-3999 in path component" {
	run curl -f http://localhost/2999/users
	[ "$status" -eq 22 ] # (22) The requested URL returned error: 404

	run curl -f http://localhost/3000/users

	run curl -f http://localhost/4000/users
	[ "$status" -eq 22 ] # (22) The requested URL returned error: 404
}

@test "can reach noVNC client" {
	curl -f http://localhost:8080/vnc.html
}
