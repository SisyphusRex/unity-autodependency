#include "utils/math.h"
#include "unity.h"

void setUp(void) {};

void tearDown(void) {};

void test_ignore(void)
{
    
    TEST_IGNORE();
};

int main(void)
{
    UNITY_BEGIN();
    RUN_TEST(test_ignore);
    return UNITY_END();
}