/// Module responsible for notifying plugins of transactions
use {
    crate::accountsdb_plugin_manager::AccountsDbPluginManager,
    log::*,
    domino_accountsdb_plugin_interface::accountsdb_plugin_interface::{
        ReplicaTransactionInfo, ReplicaTransactionInfoVersions,
    },
    domino_measure::measure::Measure,
    domino_metrics::*,
    domino_rpc::transaction_notifier_interface::TransactionNotifier,
    domino_runtime::bank,
    domino_sdk::{clock::Slot, signature::Signature, transaction::SanitizedTransaction},
    domino_transaction_status::TransactionStatusMeta,
    std::sync::{Arc, RwLock},
};

/// This implementation of TransactionNotifier is passed to the rpc's TransactionStatusService
/// at the validator startup. TransactionStatusService invokes the notify_transaction method
/// for new transactions. The implementation in turn invokes the notify_transaction of each
/// plugin enabled with transaction notification managed by the AccountsDbPluginManager.
pub(crate) struct TransactionNotifierImpl {
    plugin_manager: Arc<RwLock<AccountsDbPluginManager>>,
}

impl TransactionNotifier for TransactionNotifierImpl {
    fn notify_transaction(
        &self,
        slot: Slot,
        signature: &Signature,
        transaction_status_meta: &TransactionStatusMeta,
        transaction: &SanitizedTransaction,
    ) {
        let mut measure = Measure::start("accountsdb-plugin-notify_plugins_of_transaction_info");
        let transaction_log_info =
            Self::build_replica_transaction_info(signature, transaction_status_meta, transaction);

        let mut plugin_manager = self.plugin_manager.write().unwrap();

        if plugin_manager.plugins.is_empty() {
            return;
        }

        for plugin in plugin_manager.plugins.iter_mut() {
            if !plugin.transaction_notifications_enabled() {
                continue;
            }
            match plugin.notify_transaction(
                ReplicaTransactionInfoVersions::V0_0_1(&transaction_log_info),
                slot,
            ) {
                Err(err) => {
                    error!(
                        "Failed to notify transaction, error: ({}) to plugin {}",
                        err,
                        plugin.name()
                    )
                }
                Ok(_) => {
                    trace!(
                        "Successfully notified transaction to plugin {}",
                        plugin.name()
                    );
                }
            }
        }
        measure.stop();
        inc_new_counter_debug!(
            "accountsdb-plugin-notify_plugins_of_transaction_info-us",
            measure.as_us() as usize,
            10000,
            10000
        );
    }
}

impl TransactionNotifierImpl {
    pub fn new(plugin_manager: Arc<RwLock<AccountsDbPluginManager>>) -> Self {
        Self { plugin_manager }
    }

    fn build_replica_transaction_info<'a>(
        signature: &'a Signature,
        transaction_status_meta: &'a TransactionStatusMeta,
        transaction: &'a SanitizedTransaction,
    ) -> ReplicaTransactionInfo<'a> {
        ReplicaTransactionInfo {
            signature,
            is_vote: bank::is_simple_vote_transaction(transaction),
            transaction,
            transaction_status_meta,
        }
    }
}
