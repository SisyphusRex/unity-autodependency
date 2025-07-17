#include "modules/mod1.h"
#include "unity.h"

void setUp(void) {};

void tearDown(void) {};

void test_isEven(void)
{
    int testReturn = isEven(48);
    TEST_ASSERT_EQUAL(1, testReturn);
};

int main(void)
{
    UNITY_BEGIN();
    RUN_TEST(test_isEven);
    return UNITY_END();
}