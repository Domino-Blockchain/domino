#![cfg_attr(RUSTC_WITH_SPECIALIZATION, feature(min_specialization))]
#![allow(clippy::integer_arithmetic)]
use domino_sdk::genesis_config::GenesisConfig;
#[deprecated(
    since = "1.8.0",
    note = "Please use `domino_sdk::stake::program::id` or `domino_program::stake::program::id` instead"
)]
pub use domino_sdk::stake::program::{check_id, id};

pub mod config;
pub mod stake_instruction;
pub mod stake_state;

pub fn add_genesis_accounts(genesis_config: &mut GenesisConfig) -> u64 {
    config::add_genesis_account(genesis_config)
}
