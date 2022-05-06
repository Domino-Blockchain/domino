/**
 * @brief Example C-based BPF program that prints out the parameters
 * passed to it
 */
#include <domino_sdk.h>
#include "helper.h"

void helper_function(void) {
  dom_log(__FILE__);
}
