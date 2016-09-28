if fileToPrint ~= nil then
   if file.open(fileToPrint, "r") ~= nil then
      print(file.read())
      file.close()
   else
      print("--> the file \""..fileToPrint.."\" does not exist")
      print("--> To print the contents of a file, set the 'fileToPrint'")
      print("--> global parameter, and then run 'printfile()")
      print("--> to find the value of all parameters, run 'globals()'")
   end
else
   print("--> To print the contents of a file, set the 'fileToPrint'")
   print("--> global parameter, and then run 'printfile()")
   print("--> to find the value of all parameters, run 'globals()'")
end