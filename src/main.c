#include "stm32l1xx.h"

int main() {
    GPIO_InitTypeDef ledInit;
    long i = 0;

    // enable the GPIOB peripheral
    RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOB, ENABLE);

    // configure pins 6 and 7 as GPIO output
    ledInit.GPIO_Pin = GPIO_Pin_7 | GPIO_Pin_6;
    ledInit.GPIO_Mode = GPIO_Mode_OUT;
    // initialize the peripheral
    GPIO_Init(GPIOB, &ledInit);
    // turn pins 6 and 7 on
    GPIO_SetBits(GPIOB, GPIO_Pin_7 | GPIO_Pin_6);

    // loop forever
    for (;;) {
        // toggle pins 6 and 7
        GPIO_ToggleBits(GPIOB, GPIO_Pin_7 | GPIO_Pin_6);
        // waste time
        for (i=0; i<25000; i++);
    }
    return 0;
}
