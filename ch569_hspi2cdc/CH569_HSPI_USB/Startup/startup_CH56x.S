;/********************************** (C) COPYRIGHT *******************************
;* File Name          : startup_CH56x.s
;* Author             : WCH
;* Version            : V1.1
;* Date               : 2023/11/11
;* Description        : CH56x vector table for eclipse toolchain.
;*********************************************************************************
;* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
;* Attention: This software (modified or not) and binary are used for 
;* microcontroller manufactured by Nanjing Qinheng Microelectronics.
;*******************************************************************************/

	.section	.init,"ax",@progbits
	.global	_start
	.align	1
_start:
	j	handle_reset

    .section    .vector,"ax",@progbits
    .align  1
_vector_base:
    .option norvc;
    .word   0
    .word   0
        j   NMI_Handler                 /* NMI Handler */
        j   HardFault_Handler           /* Hard Fault Handler */
    .word   0xf7f9bf11
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
        j   SysTick_Handler            /* SysTick Handler */
    .word   0
        j   SW_Handler                 /* SW Handler */
    .word   0
    /* External Interrupts */
        j   WDOG_IRQHandler			   /* WDOG */
        j   TMR0_IRQHandler            /* TMR0 */
        j   GPIO_IRQHandler            /* GPIO */
        j   SPI0_IRQHandler            /* SPI0 */
        j   USBSS_IRQHandler           /* USBSS */
        j   LINK_IRQHandler            /* LINK */
        j   TMR1_IRQHandler            /* TMR1 */
        j   TMR2_IRQHandler            /* TMR2 */
        j   UART0_IRQHandler           /* UART0 */
        j   USBHS_IRQHandler           /* USBHS */
        j   EMMC_IRQHandler            /* EMMC */
        j   DVP_IRQHandler             /* DVP */
        j   HSPI_IRQHandler            /* HSPI */
        j   SPI1_IRQHandler            /* SPI1 */
        j   UART1_IRQHandler           /* UART1 */
        j   UART2_IRQHandler           /* UART2 */
        j   UART3_IRQHandler           /* UART3 */
        j   SERDES_IRQHandler          /* SERDES */
        j   ETH_IRQHandler             /* ETH */
        j   PMT_IRQHandler             /* PMT */
        j   ECDC_IRQHandler            /* ECDC */

    .option rvc;
    .section    .text.vector_handler, "ax", @progbits
    .weak   NMI_Handler
    .weak   HardFault_Handler
    .weak   SysTick_Handler
    .weak   SW_Handler
    .weak   WDOG_IRQHandler
    .weak   TMR0_IRQHandler
    .weak   GPIO_IRQHandler
    .weak   SPI0_IRQHandler
    .weak   USBSS_IRQHandler
    .weak   LINK_IRQHandler
    .weak   TMR1_IRQHandler
    .weak   TMR2_IRQHandler
    .weak   UART0_IRQHandler
    .weak   USBHS_IRQHandler
    .weak   EMMC_IRQHandler
    .weak   DVP_IRQHandler
    .weak   HSPI_IRQHandler
    .weak   SPI1_IRQHandler
    .weak   UART1_IRQHandler
    .weak   UART2_IRQHandler
    .weak   UART3_IRQHandler
    .weak   SERDES_IRQHandler
    .weak   ETH_IRQHandler
    .weak   PMT_IRQHandler
    .weak   ECDC_IRQHandler

NMI_Handler:
HardFault_Handler:
SysTick_Handler:
SW_Handler:
WDOG_IRQHandler:
TMR0_IRQHandler:
GPIO_IRQHandler:
SPI0_IRQHandler:
USBSS_IRQHandler:
LINK_IRQHandler:
TMR1_IRQHandler:
TMR2_IRQHandler:
UART0_IRQHandler:
USBHS_IRQHandler:
EMMC_IRQHandler:
DVP_IRQHandler:
HSPI_IRQHandler:
SPI1_IRQHandler:
UART1_IRQHandler:
UART2_IRQHandler:
UART3_IRQHandler:
SERDES_IRQHandler:
ETH_IRQHandler:
PMT_IRQHandler:
ECDC_IRQHandler:
1:
	j 1b

	.section	.text.handle_reset,"ax",@progbits
	.weak	handle_reset
	.align	1
handle_reset:
.option push 
.option	norelax 
	la gp, __global_pointer$
.option	pop 
1:
	la sp, _eusrstack 
2:	
/* Load data section from flash to RAM */
	la a0, _data_lma
	la a1, _data_vma
	la a2, _edata
	bgeu a1, a2, 2f
1:
	lw t0, (a0)
	sw t0, (a1)
	addi a0, a0, 4
	addi a1, a1, 4
	bltu a1, a2, 1b
2:
/* Clear bss section */
	la a0, _sbss
	la a1, _ebss
	bgeu a0, a1, 2f
1:
	sw zero, (a0)
	addi a0, a0, 4
	bltu a0, a1, 1b
2:
/* Clear dmadata section */
    la a0, _dmadata_start
    la a1, _dmadata_end
    bgeu a0, a1, 2f
1:
    sw zero, (a0)
    addi a0, a0, 4
    bltu a0, a1, 1b
2:
/* Enable global interrupt and configure privileged mode */
    li t0, 0x88
    csrw mstatus, t0
/* Configure entry address mode */
	la t0, _vector_base
    ori t0, t0, 1
	csrw mtvec, t0

	la t0, main
	csrw mepc, t0
	mret


