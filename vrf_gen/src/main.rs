 use rand_chacha::{ChaChaRng};
 use schnorrkel::{Keypair,Signature,signing_context};
 use rand_core::{CryptoRng, RngCore, SeedableRng};



fn main(){
    
    let mut Cspring : ChaChaRng = ChaChaRng::from_seed([0u8;32]);
    let keypair : Keypair = Keypair::generate_with(&mut Cspring);


    let context = signing_context(b"this signature does this thing");
    let message: &[u8] = "This is a test of the tsunami alert system.".as_bytes();
    let signature: Signature = keypair.sign(context.bytes(message));

    println!{"{:?}",keypair};
}
