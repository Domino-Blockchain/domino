#pragma once
/**
 * @brief Domino logging utilities
 */

#include <domi/types.h>
#include <domi/string.h>
#include <domi/entrypoint.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Prints a string to stdout
 */
void dom_log_(const char *, uint64_t);
#define dom_log(message) dom_log_(message, dom_strlen(message))

/**
 * Prints a 64 bit values represented in hexadecimal to stdout
 */
void dom_log_64_(uint64_t, uint64_t, uint64_t, uint64_t, uint64_t);
#define dom_log_64 dom_log_64_

/**
 * Prints the current compute unit consumption to stdout
 */
void dom_log_compute_units_();
#define dom_log_compute_units() dom_log_compute_units_()

/**
 * Prints the hexadecimal representation of an array
 *
 * @param array The array to print
 */
static void dom_log_array(const uint8_t *array, int len) {
  for (int j = 0; j < len; j++) {
    dom_log_64(0, 0, 0, j, array[j]);
  }
}

/**
 * Print the base64 representation of some arrays.
 */
void dom_log_data(SolBytes *fields, uint64_t fields_len);

/**
 * Prints the program's input parameters
 *
 * @param params Pointer to a SolParameters structure
 */
static void dom_log_params(const SolParameters *params) {
  dom_log("- Program identifier:");
  dom_log_pubkey(params->program_id);

  dom_log("- Number of KeyedAccounts");
  dom_log_64(0, 0, 0, 0, params->ka_num);
  for (int i = 0; i < params->ka_num; i++) {
    dom_log("  - Is signer");
    dom_log_64(0, 0, 0, 0, params->ka[i].is_signer);
    dom_log("  - Is writable");
    dom_log_64(0, 0, 0, 0, params->ka[i].is_writable);
    dom_log("  - Key");
    dom_log_pubkey(params->ka[i].key);
    dom_log("  - Lamports");
    dom_log_64(0, 0, 0, 0, *params->ka[i].lamports);
    dom_log("  - data");
    dom_log_array(params->ka[i].data, params->ka[i].data_len);
    dom_log("  - Owner");
    dom_log_pubkey(params->ka[i].owner);
    dom_log("  - Executable");
    dom_log_64(0, 0, 0, 0, params->ka[i].executable);
    dom_log("  - Rent Epoch");
    dom_log_64(0, 0, 0, 0, params->ka[i].rent_epoch);
  }
  dom_log("- Instruction data\0");
  dom_log_array(params->data, params->data_len);
}

#ifdef DOMI_TEST
/**
 * Stub functions when building tests
 */
#include <stdio.h>

void dom_log_(const char *s, uint64_t len) {
  printf("Program log: %s\n", s);
}
void dom_log_64(uint64_t arg1, uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5) {
  printf("Program log: %llu, %llu, %llu, %llu, %llu\n", arg1, arg2, arg3, arg4, arg5);
}

void dom_log_compute_units_() {
  printf("Program consumption: __ units remaining\n");
}
#endif

#ifdef __cplusplus
}
#endif

/**@}*/
