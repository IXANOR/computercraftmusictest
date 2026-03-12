local args = {...}

if #args < 1 then
  print("Uzycie: ghmusic <folder> [numer]")
  return
end

local folder = args[1]
local num = tonumber(args[2]) or 1

local base = "https://raw.githubusercontent.com/IXANOR/computercraftmusictest/main/"
local url = base .. folder .. "/" .. num .. ".dfpwm"
local tmp = "temp.dfpwm"

local drive = peripheral.find("tape_drive")

if not drive then
  print("Nie znaleziono napedu kasety.")
  return
end

if fs.exists(tmp) then
  fs.delete(tmp)
end

print("Pobieram:")
print(url)

shell.run("wget", url, tmp)

if not fs.exists(tmp) then
  print("Nie udalo sie pobrac pliku.")
  return
end

print("Nagrywam kasete...")

local file = fs.open(tmp, "rb")

drive.stop()
drive.seek(-drive.getSize())

while true do
  local chunk = file.read(8192)
  if not chunk then break end
  drive.write(chunk)
end

file.close()

fs.delete(tmp)

print("Gotowe.")
