#include <stdlib.h>

#include "unity.h"

void setUp(void) {
    if (fflush(stdout) == EOF) {
        /* Handle error */
    }
}

void tearDown(void) {
    if (fflush(stdout) == EOF) {
        /* Handle error */
    }
}

void test1(void) {
    TEST_ASSERT_EQUAL_STRING("hello", "hello");
}

void test2(void) {
    TEST_ASSERT_EQUAL_INT(2, 2);
}

/*=======MAIN=====*/
int main(void)
{
  UnityBegin("atest");

  RUN_TEST(test1);
  RUN_TEST(test2);

  return (UnityEnd());
}
