packer        := "packer"
build_dir     := "build"

# Discovery: Get all files from the iso directory for the "dropdown"
available_configs := `ls packerfiles/iso`

# Credentials (Overridable via environment variables)
username      := env_var_or_default("PACKER_USER", "admin")
password      := env_var_or_default("PACKER_PASS", "password123")
rootpassword  := env_var_or_default("PACKER_ROOT_PASS", "root123")

# Default: Show help
default:
    @just --list

# --- Utility Recipes ---

# Clean build artifacts
clean:
    rm -rf {{build_dir}}

# Prepare files and replace @tokens@ (Equivalent to Gradle processResources)
[private]
process-resources:
    @echo "Preparing resources in {{build_dir}}..."
    mkdir -p {{build_dir}}/unattended
    mkdir -p {{build_dir}}/packerfiles
    cp -r unattended/* {{build_dir}}/unattended/
    cp -r packerfiles/* {{build_dir}}/packerfiles/
    @# Token replacement using sed
    @find {{build_dir}} -type f \( -name "*.xml" -o -name "*.cfg" -o -name "*.hcl" \) -exec sed -i \
        -e 's/username/{{username}}/g' \
        -e 's/password/{{password}}/g' \
        -e 's/rootpassword/{{rootpassword}}/g' {} +

# Guard to ensure the config file actually exists
[private]
check-config name:
    @echo "{{available_configs}}" | grep -q "{{name}}" || (echo "Error: Config '{{name}}' not found." && exit 1)

# --- Primary Entry Points ---

# Build Windows: opens a dropdown if no config is provided
# Usage: 'just build-windows' OR 'just build-windows my-config.json'
build-windows config="":
    @if [ -z "{{config}}" ]; then \
        selected=$(echo "{{available_configs}}" | tr ' ' '\n' | fzf --prompt="Select Windows Config > "); \
        [ -z "$selected" ] && exit 0; \
        just _run-windows-pipeline $selected; \
    else \
        just _run-windows-pipeline {{config}}; \
    fi

# Build Linux: opens a dropdown if no config is provided
build-linux config="":
    @if [ -z "{{config}}" ]; then \
        selected=$(echo "{{available_configs}}" | tr ' ' '\n' | fzf --prompt="Select Linux Config > "); \
        [ -z "$selected" ] && exit 0; \
        just _run-linux-pipeline $selected; \
    else \
        just _run-linux-pipeline {{config}}; \
    fi

# --- Execution Pipelines (Internal) ---

[private]
_run-windows-pipeline config: (check-config config) process-resources
    @echo "Starting Windows Multi-Stage Build: {{config}}"
    just _step-windows-base {{config}}
    just _step-windows-updates {{config}}
    just _step-windows-package {{config}}

[private]
_run-linux-pipeline config: (check-config config) process-resources
    @echo "Starting Linux Build: {{config}}"
    cd {{build_dir}} && {{packer}} build \
        -var-file=./packerfiles/iso/{{config}} \
        -var-file=./packerfiles/variables.pkrvars.hcl \
        ./packerfiles/linux.pkr.hcl

# --- Individual Packer Steps ---

[private]
_step-windows-base config:
    cd {{build_dir}} && {{packer}} build \
        -var-file=./packerfiles/iso/{{config}} \
        -var-file=./packerfiles/variables.pkrvars.hcl \
        ./packerfiles/windows_1_base.pkr.hcl

[private]
_step-windows-updates config:
    cd {{build_dir}} && {{packer}} build \
        -var-file=./packerfiles/iso/{{config}} \
        -var-file=./packerfiles/variables.pkrvars.hcl \
        ./packerfiles/windows_2_updates.pkr.hcl

[private]
_step-windows-package config:
    cd {{build_dir}} && {{packer}} build \
        -var-file=./packerfiles/iso/{{config}} \
        -var-file=./packerfiles/variables.pkrvars.hcl \
        ./packerfiles/windows_3_package.pkr.hcl

# --- Automation ---

# Run the Windows pipeline for EVERY config found in the directory
build-all-windows:
    @for cfg in {{available_configs}}; do \
        just build-windows $cfg; \
    done

# Display discovered configs
list-configs:
    @echo "Discovered configurations in packerfiles/iso/:"
    @echo "{{available_configs}}" | tr ' ' '\n' | sed 's/^/- /'
