--print all values that don't match 0x
--ie: all values that aren't memory addresses
print("--> List of all current values:") 
for k,v in pairs(_G) do
    if string.find(tostring(v), "0x") == nil then
       print(pad(tostring(k), 15, ' '), v)
    end
end
print()