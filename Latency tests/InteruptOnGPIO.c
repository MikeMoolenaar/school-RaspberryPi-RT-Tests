#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <wiringPi.h>

#define PIN_INPUT 0 // GPIO17
#define PIN_OUTPUT 1 // GPIO18

int isInput = 0;
void interrupt(void) {
	digitalWrite(PIN_OUTPUT, 1);
	delay(1000);
	digitalWrite(PIN_OUTPUT, 0);
}
 
int main(void) 
{
	if (wiringPiSetup() < 0) {
		printf(stderr, "Error setting up wiringPi: %s\n", strerror(errno));
		return 1;
	}
	pinMode(PIN_OUTPUT, OUTPUT);
	digitalWrite(PIN_OUTPUT, 0);

	// Setup interrupt on when a rising edge signal is detected
	if (wiringPiISR(PIN_INPUT, INT_EDGE_RISING, &interrupt) < 0) {
	  printf(stderr, "Error setting up interrupt: %s\n", strerror(errno));
	  return 1;
	}

	for(;;) {}

	return 0;
}