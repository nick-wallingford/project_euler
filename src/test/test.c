#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <stdbool.h>
#include <string.h>

bool is_prime(uint64_t);

static inline bool c_is_prime(uint64_t num) {
  bool retval;
  asm ("mov %1,%%rsi\n"
       "call is_prime\n"
       "mov %%al,%0"
       : "=rm" (retval)
       : "rm" (num)
       : "%rax","%rbx","%rcx","%rdx","%rdi","%rsi","%r8","%r9","%r10","%r11"
       );
  return retval;
}

void test_is_prime() {
  const size_t cnt = 300000000;
  bool *prime = malloc(cnt);
  memset(prime,1,cnt);
  prime[0] = 0;
  prime[1] = 0;

  for(uint64_t n = 0; n < cnt; n++) {
    if(prime[n]) {
      if(!c_is_prime(n))
	printf("Received composite for %" PRIu64 ", should be prime\n",n);
      for(size_t i = n*n; i < cnt; i+= n) {
	prime[i] = false;
      }
    } else {
      if(c_is_prime(n))
	printf("Received prime for %" PRIu64 ", should be composite\n",n);
    }

    if(__builtin_popcount(n)==1) {
      printf("Tested all numbers up to %"PRIu64"\n",n);
    }
  }

  free(prime);

  puts("");
}

int main() {
  test_is_prime();

  return 0;
}
