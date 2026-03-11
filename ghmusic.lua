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

local ok = shell.run("wget", url, tmp)
if not ok then
  print("Nie udalo sie pobrac pliku.")
  return
end

print("Zapisuje na kasete...")
local wrote = shell.run("tape", "write", tmp)

fs.delete(tmp)

if not wrote then
  print("Nie udalo sie zapisac kasety.")
  return
end

print("Gotowe.")
