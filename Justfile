_default:
    just --list

# Install deps and tools
install:
    git submodule update --init --recursive

# Update deps and tools
update:
    pre-commit autoupdate

alias up := update

# =============================================================================
# Development
# =============================================================================

# Run all checks
ci: (format "yes") lint test

# Autoformat code
[arg("check", long="check", value="yes")]
format check="no":
    git ls-files --cached --others --exclude-standard '*.sh' \
        | xargs shfmt {{ if check == "yes" { "--list" } else { "--list --write" } }}

alias fmt := format

# Run all linters
lint:
    git ls-files --cached --others --exclude-standard '*.sh' \
        | tee /dev/tty \
        | xargs shellcheck

# Run all tests
test:
    ./test/bats/bin/bats --formatter pretty --verbose-run ./test

# Build the Docker image with tag mockoon-novnc:local
build:
    docker build --tag mockoon-novnc:local .

# Run application via Docker Compose
run:
    docker compose up --build

# =============================================================================
# Utility
# =============================================================================

# Remove temporary files
clean:
    find . -path '*.log*' -delete
