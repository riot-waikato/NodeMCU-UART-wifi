--sendManagerFlag #TODO assign

sendManagerFlag = 1
while sendManagerFlag ~= nil do
   get_ip()
   if hostip == nil then
      print("test")
      sendManagerFlag = nil
      do return end
   else
      sendManagerFlag = 1
      sendtest()
   end
end