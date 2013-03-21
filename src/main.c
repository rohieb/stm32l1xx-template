#include "stm32l1xx.h"

int main() {
	GPIO_InitTypeDef ledInit;
	long i = 0;

  	RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOB, ENABLE);

	ledInit.GPIO_Pin = GPIO_Pin_7 | GPIO_Pin_6;
	ledInit.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_Init(GPIOB, &ledInit);	
	GPIO_SetBits(GPIOB, GPIO_Pin_7 | GPIO_Pin_6);

	for (;;) {
		GPIO_ToggleBits(GPIOB, GPIO_Pin_7 | GPIO_Pin_6);
		for (i=0; i<25000; i++);
	}

    return 0;
}
