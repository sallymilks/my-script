if gg.isVisible(true) then
  gg.setVisible(false)
end

SURVIVE_VALUE = 2000000000000000
POINTS_VALUE = 2.0E+24
XP_VALUE = 70000
ONE_PUNCH_DAMAGE = 3.4E+38
PASSWORD = "GOD&KING"

function requirePassword()
  local input = gg.prompt({"Enter password"}, {""}, {"text"})
  if not input or not input[1] or input[1] ~= PASSWORD then
    gg.toast("Access denied")
    return false
  end
  return true
end

function searchCurrentValue(label)
  local input = gg.prompt({"Enter your current " .. label}, {""}, {"number"})
  local currentValue = input and tonumber(input[1])
  if not currentValue then
    gg.toast("Enter your current " .. label .. " first")
    return nil
  end

  gg.clearResults()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber(tostring(currentValue), gg.TYPE_FLOAT)

  if gg.getResultCount() < 1 then
    gg.toast(label .. " value not found; check the value and try again")
    gg.clearResults()
    return nil
  end

  local results = gg.getResults(2000)
  gg.clearResults()
  return results
end

function applyValue(results, value, message)
  for _, v in ipairs(results) do
    v.value = value
  end
  gg.setValues(results)
  gg.toast(message)
end

function onePunchNow()
  local results = searchCurrentValue("damage")
  if not results then
    return
  end

  applyValue(results, ONE_PUNCH_DAMAGE, "ONE PUNCH! DAMAGE SET TO 3.4E+38")
end

function cyclopsHealthNow()
  gg.clearResults()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("50000", gg.TYPE_FLOAT)

  if gg.getResultCount() < 1 then
    gg.toast("Cyclops health value 50000 not found")
    gg.clearResults()
    return
  end

  local results = gg.getResults(2000)
  applyValue(results, 0, "Matching health values set to 0")
  gg.clearResults()
end

function cyclopsSpawnSearch()
  gg.clearResults()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchNumber("1", gg.TYPE_FLOAT)

  local count = gg.getResultCount()
  if count < 1 then
    gg.toast("No matches found for Cyclops spawn search value 1")
    gg.clearResults()
    return
  end

  gg.toast("Found " .. count .. " matches for 1; inspect results before editing")
end

function nameSearchNow()
  if not requirePassword() then
    return
  end

  local nameInput = gg.prompt({"Enter any name to search"}, {""}, {"text"})
  if not nameInput or not nameInput[1] or nameInput[1] == "" then
    gg.toast("Name is required")
    return
  end

  local targetName = nameInput[1]
  gg.clearResults()
  gg.setRanges(gg.REGION_ANONYMOUS)
  gg.searchText(targetName, gg.TYPE_AUTO)

  if gg.getResultCount() < 1 then
    gg.toast("Name not found")
    gg.clearResults()
    return
  end

  local results = gg.getResults(5000)
  gg.editAll(targetName, gg.TYPE_AUTO)
  gg.clearResults()
  gg.toast("NAME SEARCH COMPLETE: " .. targetName)
  return results
end

function godModeNow()
  local healthResults = searchCurrentValue("health")
  if not healthResults then
    return
  end

  applyValue(healthResults, SURVIVE_VALUE, "GOD MODE ACTIVE: UNTOUCHABLE")
  gg.toast("GOD MODE ACTIVE: UNTOUCHABLE")

  while not gg.isVisible(true) do
    local currentHealth = gg.getValues(healthResults)
    local restore = {}
    for _, result in ipairs(currentHealth) do
      local value = tonumber(result.value)
      if value and value < SURVIVE_VALUE then
        result.value = SURVIVE_VALUE
        restore[#restore + 1] = result
      end
    end

    if #restore > 0 then
      gg.setValues(restore)
    end

    gg.sleep(50)
  end
end

function surviveNow()
  local results = searchCurrentValue("health")
  if not results then
    return
  end

  applyValue(results, SURVIVE_VALUE, "SURVIVE ACTIVATED")
end

function givePointsNow()
  local results = searchCurrentValue("points")
  if not results then
    return
  end

  applyValue(results, POINTS_VALUE, "POINTS SET TO 2.0E+24")
end

function giveXPNow()
  local results = searchCurrentValue("XP")
  if not results then
    return
  end

  applyValue(results, XP_VALUE, "XP SET TO 70000")
end

function noDeath()
  local healthResults = searchCurrentValue("health")
  if not healthResults then
    return
  end

  gg.toast("No Death active; reopen Game Guardian to stop")
  while not gg.isVisible(true) do
    local currentHealth = gg.getValues(healthResults)
    local restore = {}
    for _, result in ipairs(currentHealth) do
      local value = tonumber(result.value)
      if value and value < 1 then
        result.value = SURVIVE_VALUE
        restore[#restore + 1] = result
      end
    end

    if #restore > 0 then
      gg.setValues(restore)
    end

    gg.sleep(50)
  end
end

function main()
  local menu = gg.choice({
    "NAME SEARCHER (PASSWORD)",
    "GOD MODE (SEARCH HEALTH)",
    "ONE PUNCH DAMAGE 3.4E+38",
    "SURVIVE 2000000000000000",
    "GIVE POINTS 2.0E+24",
    "GIVE XP 70000",
    "NO DEATH (RESTORE BELOW 1 HP)",
    "CYCLOPS HEALTH (SEARCH 50000 -> 0)",
    "CYCLOPS SPAWN SEARCH (1)",
    "EXIT"
  }, nil, "enjoy the script hope you have fun go wild🥳")

  if menu == 1 then
    nameSearchNow()
  end

  if menu == 2 then
    godModeNow()
  end

  if menu == 3 then
    onePunchNow()
  end

  if menu == 4 then
    surviveNow()
  end

  if menu == 5 then
    givePointsNow()
  end

  if menu == 6 then
    giveXPNow()
  end

  if menu == 7 then
    noDeath()
  end

  if menu == 8 then
    cyclopsHealthNow()
  end

  if menu == 9 then
    cyclopsSpawnSearch()
  end

  if menu == 10 then
    gg.clearResults()
    gg.alert("Script closed")
    os.exit()
  end
end

main()

while true do
  if gg.isVisible(true) then
    gg.setVisible(false)
    main()
  end
  gg.sleep(100)
end
