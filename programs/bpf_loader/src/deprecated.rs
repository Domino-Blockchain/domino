domino_sdk::declare_builtin!(
    domino_sdk::bpf_loader_deprecated::ID,
    domino_bpf_loader_deprecated_program,
    domino_bpf_loader_program::process_instruction,
    deprecated::id
);
