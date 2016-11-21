log = nil		-- File pointer
log_name = "wifilog"	-- Name of the log file

-- Opens a log file for appending.
function openLogFile()
local file, err_mess = io.open(log_name, "a")
if file == null then
    print(err_mess)
else
    log = file
    print("Log file opened: "..log_name)
end	-- if
end	-- function openLogFile

-- Registers all wifi event callbacks with functions that write to the log file
function registerEvents()
if log ~= nil then -- cannot register callbacks if no log file is open
    wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T) 
        log:write("\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
        T.BSSID.."\n\tChannel: "..T.channel)
    end)

    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T) 
        log:write("\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
        T.BSSID.."\n\treason: "..T.reason)
    end)

    wifi.eventmon.register(wifi.eventmon.STA_AUTHMODE_CHANGE, function(T) 
        log:write("\n\tSTA - AUTHMODE CHANGE".."\n\told_auth_mode: "..
        T.old_auth_mode.."\n\tnew_auth_mode: "..T.new_auth_mode) 
    end)

    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T) 
        log:write("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..
        T.netmask.."\n\tGateway IP: "..T.gateway)
    end)

    wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT, function() 
        log:write("\n\tSTA - DHCP TIMEOUT")
    end)

    wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED, function(T) 
        log:write("\n\tAP - STATION CONNECTED".."\n\tMAC: "..T.MAC.."\n\tAID: "..T.AID)
    end)

    wifi.eventmon.register(wifi.eventmon.AP_STADISCONNECTED, function(T) 
        log:write("\n\tAP - STATION DISCONNECTED".."\n\tMAC: "..T.MAC.."\n\tAID: "..T.AID)
    end)

        wifi.eventmon.register(wifi.eventmon.AP_PROBEREQRECVED, function(T) 
        log:write("\n\tAP - STATION DISCONNECTED".."\n\tMAC: ".. T.MAC.."\n\tRSSI: "..T.RSSI)
    end)
else
    print("Wifi event registration failed: no log file open")
end	-- if
end	-- function registerEvents

openLogFile()
registerEvents()
