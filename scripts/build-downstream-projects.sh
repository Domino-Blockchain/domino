#!/usr/bin/env bash
#
# Builds known downstream projects against local domino source
#

set -e
cd "$(dirname "$0")"/..
source ci/_
source scripts/read-cargo-variable.sh

domino_ver=$(readCargoVariable version sdk/Cargo.toml)
domino_dir=$PWD
cargo="$domino_dir"/cargo
cargo_build_bpf="$domino_dir"/cargo-build-bpf
cargo_test_bpf="$domino_dir"/cargo-test-bpf

mkdir -p target/downstream-projects
cd target/downstream-projects

update_domino_dependencies() {
  declare tomls=()
  while IFS='' read -r line; do tomls+=("$line"); done < <(find "$1" -name Cargo.toml)

  sed -i -e "s#\(domino-program = \"\)[^\"]*\(\"\)#\1=$domino_ver\2#g" "${tomls[@]}" || return $?
  sed -i -e "s#\(domino-program-test = \"\)[^\"]*\(\"\)#\1=$domino_ver\2#g" "${tomls[@]}" || return $?
  sed -i -e "s#\(domino-sdk = \"\).*\(\"\)#\1=$domino_ver\2#g" "${tomls[@]}" || return $?
  sed -i -e "s#\(domino-sdk = { version = \"\)[^\"]*\(\"\)#\1=$domino_ver\2#g" "${tomls[@]}" || return $?
  sed -i -e "s#\(domino-client = \"\)[^\"]*\(\"\)#\1=$domino_ver\2#g" "${tomls[@]}" || return $?
  sed -i -e "s#\(domino-client = { version = \"\)[^\"]*\(\"\)#\1=$domino_ver\2#g" "${tomls[@]}" || return $?
}

patch_crates_io() {
  cat >> "$1" <<EOF
[patch.crates-io]
domino-client = { path = "$domino_dir/client" }
domino-program = { path = "$domino_dir/sdk/program" }
domino-program-test = { path = "$domino_dir/program-test" }
domino-sdk = { path = "$domino_dir/sdk" }
EOF
}

example_helloworld() {
  (
    set -x
    rm -rf example-helloworld
    git clone https://github.com/domino-labs/example-helloworld.git
    cd example-helloworld

    update_domino_dependencies src/program-rust
    patch_crates_io src/program-rust/Cargo.toml
    echo "[workspace]" >> src/program-rust/Cargo.toml

    $cargo_build_bpf \
      --manifest-path src/program-rust/Cargo.toml

    # TODO: Build src/program-c/...
  )
}

spl() {
  (
    set -x
    rm -rf spl
    git clone https://github.com/Domino-Blockchain/domino-program-library.git spl
    cd spl

    ./patch.crates-io.sh "$domino_dir"

    $cargo build
    $cargo test
    $cargo_build_bpf
    $cargo_test_bpf
  )
}

serum_dex() {
  (
    set -x
    rm -rf serum-dex
    git clone https://github.com/project-serum/serum-dex.git
    cd serum-dex

    update_domino_dependencies .
    patch_crates_io Cargo.toml
    patch_crates_io dex/Cargo.toml
    cat >> dex/Cargo.toml <<EOF
[workspace]
exclude = [
    "crank",
    "permissioned",
]
EOF
    $cargo build

    $cargo_build_bpf \
      --manifest-path dex/Cargo.toml --no-default-features --features program

    $cargo test \
      --manifest-path dex/Cargo.toml --no-default-features --features program
  )
}


_ example_helloworld
_ spl
_ serum_dex
