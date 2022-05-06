//! Example Rust-based BPF program tests loop iteration

extern crate domino_program;
use domino_program::log::*;

pub fn many_args(
    arg1: u64,
    arg2: u64,
    arg3: u64,
    arg4: u64,
    arg5: u64,
    arg6: u64,
    arg7: u64,
    arg8: u64,
    arg9: u64,
) -> u64 {
    dom_log("same package");
    dom_log_64(arg1, arg2, arg3, arg4, arg5);
    dom_log_64(arg6, arg7, arg8, arg9, 0);
    arg1 + arg2 + arg3 + arg4 + arg5 + arg6 + arg7 + arg8 + arg9
}
