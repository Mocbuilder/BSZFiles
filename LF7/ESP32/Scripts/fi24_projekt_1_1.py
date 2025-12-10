#FI24_Projekt_1 Aufgb. 1
from machine import Pin
from time import sleep
from dht import DHT22
import json

dht22_sensor = DHT22(Pin(19))
am312_pir = Pin(18, Pin.IN)
motion_detector_led = Pin(23, Pin.OUT, drive=Pin.DRIVE_0)
#lm393_pico =

def get_sensors_results():
    dht22_sensor.measure()
    temp = dht22_sensor.temperature()
    humid = dht22_sensor.humidity()
    movement = bool(am312_pir.value())
    
    
    dict_results = {
            "temperature": temp,
            "humidity": humid,
            "movement": movement
        }
    return dict_results

while True:
    json_results = json.dumps(get_sensors_results())
    
    print(json_results)
    sleep(1)

