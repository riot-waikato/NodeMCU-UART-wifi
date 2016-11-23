--[[
Contains callback functions that occur when the Wifi station status of this device changes.
]]

dofile("OpenSend.lua")

function on_sta_idle()
    print("STATION_IDLE")
end

function on_sta_connecting()
    print("STATION_CONNECTING")
end

function on_sta_wrongpwd()
    print("STATION_WRONG_PASSWORD")
end

function on_sta_apnotfound()
    print("STATION_NO_AP_FOUND")
end

function on_sta_fail()
    print("STATION_CONNECT_FAIL")
end

function on_sta_gotip()
    print("STATION_GOT_IP")

    -- sync time
    if synced == 0 then
        timesync()
    end
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
