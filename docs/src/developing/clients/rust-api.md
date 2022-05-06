---
title: Rust API
---

Domino's Rust crates are [published to crates.io][crates.io] and can be found
[on docs.rs with the "domino-" prefix][docs.rs].

[crates.io]: https://crates.io/search?q=domino-
[docs.rs]: https://docs.rs/releases/search?query=domino-

Some important crates:

- [`domino-program`] &mdash; Imported by programs running on Domino, compiled
  to BPF. This crate contains many fundamental data types and is re-exported from
  [`domino-sdk`], which cannot be imported from a Domino program.

- [`domino-sdk`] &mdash; The basic off-chain SDK, it re-exports
  [`domino-program`] and adds more APIs on top of that. Most Domino programs
  that do not run on-chain will import this.

- [`domino-client`] &mdash; For interacting with a Domino node via the
  [JSON RPC API](jsonrpc-api).

- [`domino-cli-config`] &mdash; Loading and saving the Domino CLI configuration
  file.

- [`domino-clap-utils`] &mdash; Routines for setting up a CLI, using [`clap`],
  as used by the main Domino CLI. Includes functions for loading all types of
  signers supported by the CLI.

[`domino-program`]: https://docs.rs/domino-program
[`domino-sdk`]: https://docs.rs/domino-sdk
[`domino-client`]: https://docs.rs/domino-client
[`domino-cli-config`]: https://docs.rs/domino-cli-config
[`domino-clap-utils`]: https://docs.rs/domino-clap-utils
[`clap`]: https://docs.rs/clap
