#include "modules/mod2.h"
#include "unity.h"

void setUp(void) {};

void tearDown(void) {};

void test_isPositive(void)
{
    int testReturn = isPositive(-3);
    TEST_ASSERT_EQUAL(1, testReturn);
};

int main(void)
{
    UNITY_BEGIN();
    RUN_TEST(test_isPositive);
    return UNITY_END();
}