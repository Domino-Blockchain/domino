use {
    crossbeam_channel::{Receiver, Sender},
    domino_vote_program::vote_transaction::ParsedVote,
};

pub type ReplayVoteSender = Sender<ParsedVote>;
pub type ReplayVoteReceiver = Receiver<ParsedVote>;
