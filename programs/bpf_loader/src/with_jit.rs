domino_sdk::declare_builtin!(
    domino_sdk::bpf_loader::ID,
    domino_bpf_loader_program_with_jit,
    domino_bpf_loader_program::process_instruction_jit
);
