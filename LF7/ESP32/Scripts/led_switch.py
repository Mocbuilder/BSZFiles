#LED Switch as first test with ESP32 and MicroPython
from machine import Pin
from time import sleep

switch_1 = Pin(2, Pin.IN, drive=Pin.DRIVE_0)

switch_2 = Pin(4, Pin.OUT, drive=Pin.DRIVE_0)

led = Pin(15, Pin.OUT, drive=Pin.DRIVE_0)

while True:
    print(f"Switch 1: {switch_1.value()}\nSwitch 2: {switch_2.value()}\nLED : {led.value()}")
    
    if switch_1.value() == 1 and switch_2.value() == 1:
        led.value(1)
    else:
        led.value(0)
    sleep(1)