local args = {...}

if not shell.resolveProgram("tape-util") then
  print("Brak programu tape-util")
  return
end

if #args < 2 then
  print("Uzycie:")
  print("gitape <folder> <liczba_plikow>")
  print("")
  print("Przyklad:")
  print("gitape bijmenela 1")
  return
end

local folder = args[1]
local count = tonumber(args[2])

if not count or count < 1 then
  print("Nieprawidlowa liczba plikow")
  return
end

local base = "https://raw.githubusercontent.com/IXANOR/computercraftmusictest/main/"
local url = base .. folder .. "/"

print("Folder: " .. folder)
print("Pliki: " .. count)
print("URL: " .. url)
print("Uruchamiam tape-util...")

shell.run("tape-util", "dl", tostring(count), url)
