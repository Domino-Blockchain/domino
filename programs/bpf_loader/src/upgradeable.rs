domino_sdk::declare_builtin!(
    domino_sdk::bpf_loader_upgradeable::ID,
    domino_bpf_loader_upgradeable_program,
    domino_bpf_loader_program::process_instruction,
    upgradeable::id
);
