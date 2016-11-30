--[[
Contains callback functions that occur when the Wifi station status of this device changes.
]]

function on_sta_idle()
    print("STATION_IDLE")
end

function on_sta_connecting()
    print("STATION_CONNECTING")
end

function on_sta_wrongpwd()
    print("STATION_WRONG_PASSWORD")

    --Remove AP that device doesn't have correct password for
    local ssid, password, bssid_set, bssid = wifi.sta.getconfig()
    available[bssid] = nil

    printmatchingaps()

    --Choose again from remaining available APs
    chooseavailableap()
end

function on_sta_apnotfound()
    print("STATION_NO_AP_FOUND")
end

function on_sta_fail()
    print("STATION_CONNECT_FAIL")
end

function on_sta_gotip()
    print("STATION_GOT_IP")
    print("Wifi connection established...")
    
    get_ip()
    synced = false
    timesync()
    sendpacket()	-- sends a test packet
    
end


--[[
Register the callback functions.
]]
function initSTAcallbacks()
    --register callback
    wifi.sta.eventMonReg(wifi.STA_IDLE, on_sta_idle)
    wifi.sta.eventMonReg(wifi.STA_CONNECTING, on_sta_connecting)
    wifi.sta.eventMonReg(wifi.STA_WRONGPWD, on_sta_wrongpwd)
    wifi.sta.eventMonReg(wifi.STA_APNOTFOUND, on_sta_apnotfound)
    wifi.sta.eventMonReg(wifi.STA_FAIL, on_sta_fail)
    wifi.sta.eventMonReg(wifi.STA_GOTIP, on_sta_gotip)
end

initSTAcallbacks()
wifi.sta.eventMonStart()
