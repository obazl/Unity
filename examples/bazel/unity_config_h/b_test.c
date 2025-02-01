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

void float_test(void) {
    /* TEST_ASSERT_EQUAL_FLOAT(1.23, 1.23); */
    /* TEST_ASSERT_FLOAT_WITHIN(0.00003f, 187245.03485f, 187245.03488f); */
    TEST_ASSERT_FLOAT_WITHIN(0.05f, 9273.2649f, 9273.2049f);

}

void test4(void) {
    /* int a = 0xfab1; */
    TEST_PRINTF("Decimal   %d\n", -7);
}

/*=======MAIN=====*/
int main(void)
{
  UnityBegin("atest");

  /* RUN_TEST(test1); */
  /* RUN_TEST(test2); */
  RUN_TEST(float_test);
  /* RUN_TEST(test4); */

  return (UnityEnd());
}
