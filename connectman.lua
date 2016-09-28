function connectman_slave()
   mywifistatus=wifi.sta.status()
   if mywifistatus == 0 or mywifistatus == 4 or mywifistatus == 3 then
      tmr.stop(0)
      connectWifi()   
   elseif mywifistatus == 5 and hostip == nil then
      timerman()
   end
end

tmr.register(1, 5000, 1, connectman_slave)
tmr.start(1)