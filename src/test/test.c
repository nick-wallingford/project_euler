#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <stdbool.h>
#include <string.h>
#include <time.h>

void is_prime();
void factor();

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

static void test_is_prime() {
  const size_t cnt = 3000000;
  bool *prime = malloc(cnt);
  memset(prime,1,cnt);
  prime[0] = 0;
  prime[1] = 0;
  uint64_t progress = 1;

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

    if(progress == n) {
      printf("Tested all numbers up to %"PRIu64"\n",n);
      progress *= 2;
    }
  }

  free(prime);

  puts("");
}

static inline uint64_t *c_factor(uint64_t n,size_t *factor_count) {
  uint64_t *factors;
  uint64_t count;
  asm("movq %[n],%%rsi    \n"
      "call factor     \n"
      "movq %%rax,%[count]  \n"
      "movq %%rsi,%[factors]    \n"
      : [factors] "=rm" (factors), [count] "=rm" (count)
      : [n] "rm" (n)
      : "%rax","%rbx","%rcx","%rdx","%rdi","%rsi","%r8","%r9","%r10","%r11","%r12","%r13","%r14"
      );

  *factor_count = count;

  return factors;
}

static void test_factor() {
  uint64_t n = time(NULL);
  printf("Seed is %"PRIu64"\n",n);
  uint64_t progress = 1;
  for(uint64_t i = 0;;i++) {
    if(i == progress) {
      printf("Successfully factored %"PRIu64" numbers\n",i);
      progress *= 2;
    }
    size_t count;
    uint64_t product = 1;
    n *= UINT64_C(6364136223846793005);
    n += UINT64_C(1442695040888963407);

    uint64_t *factors = c_factor(n,&count);

    for(int j = count;j--;) {
      if(!c_is_prime(factors[j]))
	printf("Error, returned non-prime factor %"PRIu64" for number %"PRIu64"\n",factors[j],n);
      product *= factors[j];
    }

    if(product != n) {
      printf("Error, products of factors does not equal the result.\n");
      printf("%"PRIu64,*factors);
      for(int j = 1; j <= count;j++)
	printf(" * %"PRIu64,factors[j]);

      printf(" != %"PRIu64,n);
    }
  }
}

int main() {
  test_factor();
  //test_is_prime();

  return 0;
}
