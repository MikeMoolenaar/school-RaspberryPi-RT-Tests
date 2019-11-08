/* ========================================
 *
 * Copyright Mike Moolenaar, 2019
 * All Rights Reserved
 * ========================================
*/
#include "project.h"
#include <stdlib.h>

#define MAX_SAMPLES 20

void uartPrintInt(int x);

int count = 0;
int timer_is_running = 0;
CY_ISR(ISR_TIMER) {
    count++;
}

CY_ISR(ISR_INPUT) {
    Timer_Stop();
    
    UART_PutString("Time: ");
    uartPrintInt(count*10); // Because timer pulses every 10 microseconds
    UART_PutString("us\r\n");
    
    // Reset values
    count = 0;
    timer_is_running = 0;
    Pin_Input_ClearInterrupt();
}

int main(void)
{
    ISR_Timer_StartEx(ISR_TIMER);
    ISR_Input_StartEx(ISR_INPUT);
    CyGlobalIntEnable; /* Enable global interrupts. */
    
    UART_Start();
    UART_PutString("\r\nStart!\r\n");
    Pin_Output_Write(0);
    CyDelay(200);
    
    for(int i = 0; i < MAX_SAMPLES; i++)
    {
        timer_is_running = 1;
        
        // Pulse and start timer
        Pin_Output_Write(1);
        Timer_Start();
        CyDelay(200);
        Pin_Output_Write(0);
        
        // Start timer and wait till timer stops
        while (timer_is_running == 1) {}
        
        // Cool down
        CyDelay(1000);
    }
    
    UART_PutString("Done!\r\n");
}

void uartPrintInt(int x) {
	char ch[5];
	itoa(x, ch, 10);
	UART_PutString(ch);
}