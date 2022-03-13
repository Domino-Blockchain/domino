use bip32::{Mnemonic, Prefix, XPrv};
use rand_core::OsRng;
use std::{time ,thread};
use rusqlite::{params, Connection, Result ,NO_PARAMS};
use crate::{
    cli::{
        log_instruction_custom_error, request_and_confirm_airdrop, CliCommand, CliCommandInfo,
        CliConfig, CliError, ProcessResult,
    },
    memo::WithMemo,
    nonce::check_nonce_account,
    spend_utils::{resolve_spend_tx_and_check_account_balances, SpendAmount},
};
use domino_clap_utils::{
    input_parsers::*,
    keypair::{DefaultSigner, SignerIndex},
};
use domino_remote_wallet::remote_wallet::RemoteWalletManager;
use std::{fmt::Write as FmtWrite, fs::File, io::Write, sync::Arc};
use clap::{value_t_or_exit, App, Arg, ArgMatches, SubCommand};
use domino_sdk::{
    pubkey::Pubkey,
};
use std::any::Any;
use uuid::Uuid;

use hex::{encode};
#[derive(Debug)]
struct Details {
    uuid: String,
    pubkey: String,
    partkey: String,
    firstround: i64,
    lastround: i64,
}

#[derive(Debug)]
struct key_details {
    pubkey: String,
    partkey: String,
}

pub trait PartkeySubCommands {
    fn partkey_subcommands(self) -> Self;
}

impl PartkeySubCommands for App<'_, '_> {
    fn partkey_subcommands(self) -> Self {
        self.subcommand(
            SubCommand::with_name("addpartkey")
                .about("Generates a Participation key")
                .alias("addpartkey"),           
        )
        .subcommand(
            SubCommand::with_name("listpartkeys")
                .about("Get List of participation key")
                .alias("listpartkeys"),
        )
    
    }
}

pub fn parse_addPartKey(
    matches: &ArgMatches<'_>,
    default_signer: &DefaultSigner,
    wallet_manager: &mut Option<Arc<RemoteWalletManager>>,
) -> Result<CliCommandInfo, CliError> {
    let pubkey = pubkey_of_signer(matches, "pubkey", wallet_manager)?;
    let signers = if pubkey.is_some() {
        vec![]
    } else {
        vec![default_signer.signer_from_path(matches, wallet_manager)?]
    };
    Ok(CliCommandInfo {
        command: CliCommand::AddPartkey,
        signers,
    })
}

// pub fn process_genPartKey(/** pubkey: &Option<Pubkey>, **/config: &CliConfig) -> ProcessResult {
pub fn process_genPartKey(config: &CliConfig) -> ProcessResult {

    let pubkey = config.pubkey()?;

    // create a new randomly generated mnemonic phrase
    let mnemonic = Mnemonic::random(&mut OsRng, Default::default());
    let seed = mnemonic.to_seed("password");
    let root_xprv = XPrv::new(&seed)?;
    let child_path = "m/0/2147483647'/1/2147483646'";
    let child_xprv = XPrv::derive_from_path(&seed, &child_path.parse()?)?;
    let child_xpub = child_xprv.to_bytes();
    let child_xpub_str = encode(child_xpub);
    let (left ,right) = child_xpub.split_at(16);
    let uuid = Uuid::from_slice(&left).unwrap();

    //saving partkey related with pubkey
    let conn = Connection::open("partkeyDB.db")?;
    conn.execute(
        "CREATE TABLE IF NOT EXISTS partKeys (uuid TEXT ,userPubKey TEXT , userPartKey TEXT ,firstround INTEGER ,lastround INTEGER)",
        NO_PARAMS,
    )?;
    conn.execute(
        "INSERT INTO partKeys (uuid ,userPubKey, userPartKey ,firstround ,lastround) VALUES (?1, ?2 ,?3 ,?4 ,?5)",
        params![uuid.to_string() ,pubkey.to_string() ,child_xpub_str ,0 , 0],
    )?;
        println!("Participation Key is generated : {}",child_xpub_str);
    Ok(child_xpub_str)
}

pub fn parse_listpartkey(
    matches: &ArgMatches<'_>,
    default_signer: &DefaultSigner,
    wallet_manager: &mut Option<Arc<RemoteWalletManager>>,
) -> Result<CliCommandInfo, CliError> {
    let pubkey = pubkey_of_signer(matches, "pubkey", wallet_manager)?;
    let signers = if pubkey.is_some() {
        vec![]
    } else {
        vec![default_signer.signer_from_path(matches, wallet_manager)?]
    };
    Ok(CliCommandInfo {
        command: CliCommand::ListPartKeys,
        signers,
    })
}

pub fn process_listpartkeys()-> ProcessResult {
    let conn = Connection::open("partkeyDB.db")?;
    let mut stmt = conn.prepare("SELECT userPubKey, userPartKey FROM partKeys")?;

    let person_iter = stmt.query_map([], |row| {
        Ok(key_details {
            pubkey: row.get(0)?,
            partkey: row.get(1)?,
        })
    })?;

    for person in person_iter {
        println!("{:?}", person.unwrap());
    }
    Ok(String::from(""))
}