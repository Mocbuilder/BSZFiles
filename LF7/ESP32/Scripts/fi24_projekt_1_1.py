#FI24_Projekt_1 Aufgb. 1
from machine import Pin, ADC, SoftI2C
import ssd1306
from time import sleep
from dht import DHT22
import json
import sys
import select

dht22_sensor = DHT22(Pin(19))
am312_pir = Pin(18, Pin.IN)
motion_detector_led = Pin(23, Pin.OUT, drive=Pin.DRIVE_0)
lm393_pico = ADC(Pin(34, Pin.IN))
i2c = SoftI2C(scl=Pin(22), sda=Pin(21))

def display_to_i2c(input, height):
    oled_width = 128
    oled_height = 64
    oled = ssd1306.SSD1306_I2C(oled_width, oled_height, i2c)
    
    oled.text(str(input), 0, int(height))
    oled.show()

def get_lux():
    gamma = 0.7
    rl10 = 50
    
    analog_value =   lm393_pico.read() / 4
    voltage = analog_value / 1024 * 5
    resistance = 2000 * voltage / (1 - voltage / 5)
    return pow(rl10 * 1e3 * pow(10, gamma) / resistance, (1 / gamma))

def get_sensors_results():
    dht22_sensor.measure()
    temp = dht22_sensor.temperature()
    humid = dht22_sensor.humidity()
    movement = bool(am312_pir.value())
    luminance = get_lux()
    
    if movement:
        motion_detector_led.value(1)
    else:
        motion_detector_led.value(0)
    
    dict_results = {
            "temperature": temp,
            "humidity": humid,
            "movement": movement,
            "luminance": luminance
        }
    return dict_results

    
oled_width = 128
oled_height = 64
oled = ssd1306.SSD1306_I2C(oled_width, oled_height, i2c)
    
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
    
display_to_i2c("")

