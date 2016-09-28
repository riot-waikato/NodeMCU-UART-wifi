--print name and size for all files in file system
l = file.list();
for k,v in pairs(l) do
  print("name:"..k..", size:"..v)
end
print()