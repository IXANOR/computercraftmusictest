local args = {...}

if #args < 1 then
  print("Uzycie: ghmusic <folder> [numer]")
  print("Przyklad: ghmusic bijmenela 1")
  return
end

local folder = args[1]
local num = tonumber(args[2]) or 1

local base = "https://raw.githubusercontent.com/IXANOR/computercraftmusictest/main/"
local url = base .. folder .. "/" .. tostring(num) .. ".dfpwm"
local tmp = "temp.dfpwm"

if fs.exists(tmp) then
  fs.delete(tmp)
end

print("Pobieram:")
print(url)

shell.run("wget", url, tmp)

if not fs.exists(tmp) then
  print("Plik nie zostal pobrany.")
  return
end

print("Zapisuje na kasete...")
shell.run("tape", "write", tmp)

if fs.exists(tmp) then
  fs.delete(tmp)
end

print("Gotowe.")
