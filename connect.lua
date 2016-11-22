ssid_pattern = ""

--From https://learn.adafruit.com/adafruit-huzzah-esp8266-breakout/using-nodemcu-lua
--[[a callback function to receive the AP table when the scan is done. This function receives a table, the key is the BSSID, the value is other info in format: SSID, RSSID, auth mode, channel.
]]
function listap(t)
    print("Available access points:")
    print("\n"..string.format("%32s","SSID").."\tBSSID\t\t\t\t  RSSI\t\tAUTHMODE\tCHANNEL")
    for ssid,v in pairs(t) do
        local authmode, rssi, bssid, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]+)")
        print(string.format("%32s",ssid).."\t"..bssid.."\t  "..rssi.."\t\t"..authmode.."\t\t\t"..channel)
    end
end	-- function listap

function matchSSIDPattern(p)
end	-- function matchSSIDPattern

wifi.setmode(wifi.STATION)

-- Scan for Wifi APs.
print("Scanning access points...")
wifi.sta.getap(listap)

--wifi.sta.config("wific", "wifiwifi")
