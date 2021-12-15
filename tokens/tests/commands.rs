use {
    domino_client::rpc_client::RpcClient,
    domino_sdk::signature::{Keypair, Signer},
    domino_streamer::socket::SocketAddrSpace,
    domino_test_validator::TestValidator,
    domino_tokens::commands::test_process_distribute_tokens_with_client,
};

#[test]
fn test_process_distribute_with_rpc_client() {
    domino_logger::setup();

    let mint_keypair = Keypair::new();
    let test_validator =
        TestValidator::with_no_fees(mint_keypair.pubkey(), None, SocketAddrSpace::Unspecified);

    let client = RpcClient::new(test_validator.rpc_url());
    test_process_distribute_tokens_with_client(&client, mint_keypair, None);
}
