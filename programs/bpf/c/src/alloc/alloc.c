/**
 * @brief Example C-based BPF sanity rogram that prints out the parameters
 * passed to it
 */
#include <domino_sdk.h>

extern uint64_t entrypoint(const uint8_t *input) {
  {
    // Confirm large allocation fails
    void *ptr = dom_calloc(1, UINT64_MAX);
    if (ptr != NULL) {
      dom_log("Error: Alloc of very larger buffer should fail");
      dom_panic();
    }
  }

  {
    // Confirm large allocation fails
    void *ptr = dom_calloc(UINT64_MAX, 1);
    if (ptr != NULL) {
      dom_log("Error: Alloc of very larger buffer should fail");
      dom_panic();
    }
  }

  {
    // Test modest allocation and de-allocation
    void *ptr = dom_calloc(1, 100);
    if (ptr == NULL) {
      dom_log("Error: Alloc of 100 bytes failed");
      dom_panic();
    }
    dom_free(ptr);
  }

  {
    // Test allocated memory read and write

    const uint64_t iters = 100;
    uint8_t *ptr = dom_calloc(1, iters);
    if (ptr == NULL) {
      dom_log("Error: Alloc failed");
      dom_panic();
    }
    for (int i = 0; i < iters; i++) {
      *(ptr + i) = i;
    }
    for (int i = 0; i < iters; i++) {
      dom_assert(*(ptr + i) == i);
    }
    dom_log_64(0x3, 0, 0, 0, *(ptr + 42));
    dom_assert(*(ptr + 42) == 42);
    dom_free(ptr);
  }

  return SUCCESS;
}
