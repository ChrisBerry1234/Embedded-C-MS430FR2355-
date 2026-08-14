SPI Packet Transmission on Button Press

This project demonstrates how to configure the MSP430 eUSCI_A0 peripheral as an SPI master and transmit a 4-byte packet each time a pushbutton (S1) is pressed. It uses the TXIFG interrupt to pace each byte of the packet and illustrates how the SPI transmit state machine works internally.

Project Overview

When the user presses S1, the MSP430 sends the following 4-byte SPI packet:

{ 0xF0, 0xF0, 0xF0, 0x40 }

The SPI master uses:

SMCLK = 1 MHz

Prescaler = 10

SCLK = 100 kHz

3-wire SPI mode

LSB-first, 8-bit transfers

TXIFG interrupt to load the next byte

This project teaches:

How SPI clock generation works

How TXIFG indicates "TX buffer ready"

How to pace multi-byte transfers

How to configure MSP430 pins for SPI

How to send multi-byte packets using interrupts

SPI Configuration Summary

Clock Setup

BRCLK Source: SMCLK (1 MHz)

Prescaler: UCA0BRW = 10

Resulting SCLK: 100 kHz

SPI Mode

Master mode

3-wire SPI (default UCMODE = 00)

Clock phase/polarity: default

Data clocked out on 1st edge

Data sampled on 2nd edge

8-bit transfers

LSB-first

Pins

Pin

Function

Register Setting

P1.5

UCA0SCLK

P1SEL1=0, P1SEL0=1

P1.7

UCA0SIMO

P1SEL1=0, P1SEL0=1

P1.6

UCA0SOMI

P1SEL1=0, P1SEL0=1

TXIFG Interrupt Flow

This project uses TXIFG to pace each byte of the packet.

Sequence

Button ISR fires

Clear TXIFG

Load first byte into UCA0TXBUF

Enable TXIFG interrupt

Hardware copies byte into shift register

TXBUF becomes empty → TXIFG = 1

TXIFG ISR fires

Load next byte

Clear TXIFG

Repeat

After 4 bytes

Disable TXIFG interrupt

Reset packet index

This creates a simple transmit state machine.

What You Learn

How SPI clock generation works

How TXIFG differs from TX complete

How to pace multi-byte transfers

How to configure MSP430 pins for SPI

How interrupts drive peripheral state machines

How to build beginner-level HAL-style code

Recommended Next Steps

Once you understand this project, you can expand it into:

SPI RX + TX full-duplex

Interrupt-driven SPI HAL

FreeRTOS SPI service

VHDL SPI slave to receive the packet

Multi-packet communication protocol

Adding UART logging for debugging
