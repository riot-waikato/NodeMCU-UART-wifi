-- Registers all wifi event callbacks with functions that write to the log file
function registerEvents()
    wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T) 
        print(rtctime.get().."\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
        T.BSSID.."\n\tChannel: "..T.channel)
    end)

    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T) 
        print(rtctime.get().."\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
        T.BSSID.."\n\treason: "..T.reason)
    end)

    wifi.eventmon.register(wifi.eventmon.STA_AUTHMODE_CHANGE, function(T) 
        print(rtctime.get().."\n\tSTA - AUTHMODE CHANGE".."\n\told_auth_mode: "..
        T.old_auth_mode.."\n\tnew_auth_mode: "..T.new_auth_mode) 
    end)

    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T) 
        print(rtctime.get().."\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..
        T.netmask.."\n\tGateway IP: "..T.gateway)
    end)

    wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT, function() 
        print(rtctime.get().."\n\tSTA - DHCP TIMEOUT")
    end)

--[[    wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED, function(T) 
        print("\n\tAP - STATION CONNECTED".."\n\tMAC: "..T.MAC.."\n\tAID: "..T.AID)
    end)
]]

--[[    wifi.eventmon.register(wifi.eventmon.AP_STADISCONNECTED, function(T) 
        print(rtctime.get().."\n\tAP - STATION DISCONNECTED".."\n\tMAC: "..T.MAC.."\n\tAID: "..T.AID)
    end)
]]

    --[[wifi.eventmon.register(wifi.eventmon.AP_PROBEREQRECVED, function(T) 
        print(rtctime.get().."\n\tAP - PROBE REQUEST RECEIVED".."\n\tMAC: ".. T.MAC.."\n\tRSSI: "..T.RSSI)
    end)
]]
end	-- function registerEvents

registerEvents()
