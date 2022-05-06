domino_sdk::declare_builtin!(
    domino_sdk::bpf_loader_upgradeable::ID,
    domino_bpf_loader_upgradeable_program_with_jit,
    domino_bpf_loader_program::process_instruction_jit,
    upgradeable_with_jit::id
);
