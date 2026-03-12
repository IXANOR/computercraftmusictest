local args = {...}

if #args < 1 then
  print("Uzycie: ghmusic <folder> [numer]")
  return
end

local folder = args[1]
local num = tonumber(args[2]) or 1
local label = folder:gsub("/+$", ""):match("([^/]+)$") or folder
local tapeMetadataFile = "./musicdata/tape_metadata"
local function normalizeDurationKey(name)
  return (name or ""):lower():gsub("[^%w]", "")
end

local function loadTapeMetadata()
  if not fs.exists(tapeMetadataFile) then
    return {}
  end
  local file = fs.open(tapeMetadataFile, "r")
  if not file then
    return {}
  end
  local raw = file.readAll()
  file.close()
  local parsed = textutils.unserialize(raw)
  if type(parsed) == "table" then
    return parsed
  end
  return {}
end

local function saveTapeMetadata(metadata)
  if not fs.exists("./musicdata") then
    fs.makeDir("./musicdata")
  end
  local file = fs.open(tapeMetadataFile, "w")
  if not file then
    return false
  end
  file.write(textutils.serialize(metadata))
  file.close()
  return true
end

local base = "https://raw.githubusercontent.com/IXANOR/computercraftmusictest/main/music/"
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
local bytesWritten = 0
local maxTapeBytes = drive.getSize()

drive.stop()
drive.seek(-drive.getSize())

while true do
  local chunk = file.read(8192)
  if not chunk then break end
  local remaining = maxTapeBytes - bytesWritten
  if remaining <= 0 then break end
  if #chunk > remaining then
    chunk = chunk:sub(1, remaining)
  end
  drive.write(chunk)
  bytesWritten = bytesWritten + #chunk
end

file.close()

drive.seek(-drive.getSize())
drive.setLabel(label)

local metadata = loadTapeMetadata()
local duration = math.floor(bytesWritten / 6000)
if duration > 0 then
  metadata[label] = duration
  metadata[normalizeDurationKey(label)] = duration
  if saveTapeMetadata(metadata) then
    local min = math.floor(duration / 60)
    local sec = duration % 60
    print(("Ustawiono metadata dlugosci: %d:%02d"):format(min, sec))
  else
    print("Nie udalo sie zapisac metadanych dlugosci.")
  end
else
  print("Nie udalo sie wyliczyc dlugosci utworu.")
end

fs.delete(tmp)

print("Gotowe. Ustawiono nazwe kasety: " .. label)
