#NodeMCU-UART-wifi readme

This repository contains Lua scripts that run on an ESP8266 board running NodeMCU firmware.  The board will transmit light sensor readings over wifi when an access point is available.

##Requirements

ESP8266 with init data block from Espressif SDK patch 1.5.4.1 and a custom firmware binary containing the following modules:
- file
- GPIO
- net
- node
- RTC time
- timer
- UART
- WiFi

##Recommended Tools

esppressif/esptool (on Github)
- communicates with ESP8266 bootloader
- erases and flashes memory

ESPlorer
- uploads Lua files
- delivers Lua commands via UART to allow interactive debugging

##Configuration Options

The following options are available to configure the scripts.

###Syncing Time With Host (timesync.lua)
- timeout: Controls how long the process will wait for data to be received or a connection to be made before closing the port and retrying.
- timeport: The port of the host which will provide the time.

###UART (uart.lua)
- wifitimeout: The UART sends a success/failure response if it has attempted to send a light sensor reading.  This controls how long the process will wait before sending a failure response back if the packet has not been acknowledged.  (In ms.)
- interactive_mode: Debugging via ESPlore is very useful but requires a '\n' terminator to all messages sent.  The Arduino light sensor sends '$' terminated lines.  Setting interactive_mode to true allows interactive debugging via ESPlore but cannot be used when the ESP8266 is directly connected to the light sensor.  Interactive mode also uses a different baud rate.  The Arduino sensor uses 9600 but the default baud rate for the ESP8266 is 115200 (which is used to transmit useful error messages).

###Selecting Valid APs (wifiapselection.lua)
- ssid_pattern: The SSIDs of access points are checked against this string.  This string can be any Lua pattern.  If the pattern matches, the AP is considered part of the network and the ESP8266 may attempt to connect to it.
- password: The password that will be used to connect to any available APs.
- minrssi: The minimum signal strength that the ESP8266 will try to connect to. (In dB.)
- retryinterval: How often the ESP8266 will scan for APs if it is unable to connect.
- bssidlist: A list of BSSIDs (MAC addresses) that are part of the network.  The format of the list is {"<bssid1>": true, "<bssid2>": true ... }.
- selector: The scheme that will be used to select the AP to connect to.  Current options are:
  - selectionscheme.random: Chooses randomly out of any valid APs that are in range.
  - selectionscheme.bestsignal: Chooses the valid AP that has the strongest signal.

###Sending Data To The Host (wifisend.lua)
- hostport: The port on the host to connect via TCP and send data.
