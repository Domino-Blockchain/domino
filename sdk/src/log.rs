#![cfg(feature = "program")]

pub use domino_program::log::*;

#[macro_export]
#[deprecated(
    since = "1.4.3",
    note = "Please use `domino_program::log::info` instead"
)]
macro_rules! info {
    ($msg:expr) => {
        $crate::log::dom_log($msg)
    };
}
