#FI24_Projekt_ESP32_2
from machine import Pin, ADC, SoftI2C
import ssd1306
from time import sleep
from dht import DHT22
import json
import sys
import select
import network
import time
from umqtt.simple import MQTTClient

dht22_sensor = DHT22(Pin(19))
oled_width = 128
oled_height = 64
oled = ssd1306.SSD1306_I2C(oled_width, oled_height, SoftI2C(scl=Pin(22), sda=Pin(21)))
wlancon = False

server="mosquitto.nodered-fi.ipv64.net"
ClientID = "floeter+2008"
user = "FI"
password = "FI"
topic = "Met/FI/Floeter"

def connectMQTT():
    print('Connected to MQTT Broker "%s"' % (server))
    client = MQTTClient(ClientID, server, 1883, user, password)
    client.connect()
    return client

def try_connect_wifi():
    wlan = network.WLAN()
    wlan.active(True)
    wlan.connect('Iphone XR', 'FCKBSZWSW')
    return wlan.isconnected()

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
    movement = bool(Pin(18, Pin.IN).value())
    luminance = get_lux()
    
    if movement:
        Pin(23, Pin.OUT, drive=Pin.DRIVE_0).value(1)
    else:
        Pin(23, Pin.OUT, drive=Pin.DRIVE_0).value(0)
            
    dht22_sensor.measure()
    temp = dht22_sensor.temperature()
    humid = dht22_sensor.humidity()
    display_temp_leds(temp)

    dict_results = {
            "temperature": temp,
            "humidity": humid,
            "movement": movement,
            "luminance": luminance
        }
    return dict_results


while True:
    if try_connect_wifi():
        oled.fill(0)
        oled.text("Wifi connection healthy", 0, 0)
        print("wifi healthy")
        wlancon = True
        time.sleep(5)
        break;
        
    oled.fill(0)
    oled.text("Wifi connection failed", 0, 0)
    print("wifi unhealthy")
    wlancon = False
    time.sleep(5)

#No error handling, cause umqtt.simple for some reason doesnt provide a reconnect function
client = connectMQTT()
while True:    
    if select.select([sys.stdin], [], [], 0)[0]:
        line = sys.stdin.readline().strip()
        if line == "exit":
            oled.fill(0)
            wlan.disconnect()
            sys.exit()
            
    json_results = json.dumps(get_sensors_results())
    print(json_results + " Wifi: " + str(wlancon))
    dict_results = get_sensors_results()
    
    oled.fill(0)
    oled.text("Temperature:", 0, 0)
    oled.text(str(dict_results["temperature"]), 0, 10)
    oled.text("Humidity:", 0, 25)
    oled.text(str(dict_results["humidity"]), 0, 35)
    oled.text("Wifi: " + str(wlancon), 0, 45)
    oled.show()
    

        
    print('send message %s on topic %s' % (json_results, topic))
    client.publish(topic, json_results, qos=0)
    sleep(1)