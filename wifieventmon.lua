
--[[Examine the disconnection reason and respond appropriately.]]
function handledc(reason)

    -- Scan for APs and start process again
    if reason == wifi.eventmon.reason.NO_AP_FOUND then
        wifiscan()
    end

end

dofile("wifistatusvalues.lua")

-- Registers all wifi event callbacks with functions that write to the log file
function registerevents()
    wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T) 
        print(rtctime.get().."\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
        T.BSSID.."\n\tChannel: "..T.channel)

    retries = 0 --clear the unsuccessful retry attempts
    end)

    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T) 
        print(rtctime.get().."\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
        T.BSSID.."\n\treason: "..dcreason_tostr(T.reason))

        handledc(T.reason)
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

end	-- function registerEvents

registerevents()
