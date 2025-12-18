#FI24_Projekt_1 Aufgb. 1
from machine import Pin, ADC, SoftI2C
import ssd1306
from time import sleep
from dht import DHT22
import json
import sys
import select

dht22_sensor = DHT22(Pin(19))
oled_width = 128
oled_height = 64
oled = ssd1306.SSD1306_I2C(oled_width, oled_height, SoftI2C(scl=Pin(22), sda=Pin(21)))

def get_lux():
    return pow(50 * 1e3 * pow(10, 0.7) / (2000 * ((ADC(Pin(34, Pin.IN)).read() / 4) / 1024 * 5) / (1 - ((ADC(Pin(34, Pin.IN)).read() / 4) / 1024 * 5) / 5)), (1 / 0.7))

def display_temp_leds(temp):    
    if temp >= 30:
        Pin(12, Pin.OUT).value(1)
    elif temp >= 25 and temp < 30:
        Pin(13, Pin.OUT).value(1)
    elif temp >= 20:
        Pin(14, Pin.OUT).value(1)
    else:
        oled.fill(0)
        oled.text("Temperature Error", 0, 0)
        oled.text("Are you currently in Antarctica ?", 0, 10)
        oled.show()
    
def get_sensors_results():
    dht22_sensor.measure()
    temp = dht22_sensor.temperature()
    humid = dht22_sensor.humidity()
    movement = bool(Pin(18, Pin.IN).value())
    luminance = get_lux()
    
    if movement:
        Pin(23, Pin.OUT, drive=Pin.DRIVE_0).value(1)
    else:
        Pin(23, Pin.OUT, drive=Pin.DRIVE_0).value(0)
        
    display_temp_leds(temp)
    
    dict_results = {
            "temperature": temp,
            "humidity": humid,
            "movement": movement,
            "luminance": luminance
        }
    return dict_results

while True:
    if select.select([sys.stdin], [], [], 0)[0]:
        line = sys.stdin.readline().strip()
        if line == "exit":
            oled.fill(0)
            sys.exit()
            
    json_results = json.dumps(get_sensors_results())
    print(json_results)
    dict_results = get_sensors_results()
    
    oled.fill(0)
    oled.text("Temperature:", 0, 0)
    oled.text(str(dict_results["temperature"]), 0, 10)
    oled.text("Humidity:", 0, 25)
    oled.text(str(dict_results["humidity"]), 0, 35)
    oled.show()
    sleep(1)