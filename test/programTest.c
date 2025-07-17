#include "program.h"
#include "unity.h"

void setUp(void) {};

void tearDown(void) {};

void test_isOdd(void)
{
    int testReturn = isOdd(47);
    TEST_ASSERT_EQUAL(1, testReturn);
};

int main(void)
{
    UNITY_BEGIN();
    RUN_TEST(test_isOdd);
    return UNITY_END();
}