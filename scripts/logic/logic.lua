-- put logic functions here using the Lua API: https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md#lua-interface
-- don't be afraid to use custom logic functions. it will make many things a lot easier to maintain, for example by adding logging.
-- to see how this function gets called, check: locations/locations.json
-- example:
function has_more_then_n_consumable(n)
    local count = Tracker:ProviderCountForCode('consumable')
    local val = (count > tonumber(n))
    if ENABLE_DEBUG_LOG then
        print(string.format("called has_more_then_n_consumable: count: %s, n: %s, val: %s", count, n, val))
    end
    if val then
        return 1 -- 1 => access is in logic
    end
    return 0 -- 0 => no access
end
function has(item, amount)
    local count = Tracker:ProviderCountForCode(item)
    amount = tonumber(amount)
    if not amount then
        return count > 0
    else
        return count >= amount
    end
end

levelaccess = Tracker:FindObjectForCode("progression")
bluecoinsenabled = Tracker:FindObjectForCode("blue_coin_sanity")
coin_shine_enabled = Tracker:FindObjectForCode("coin_shine_enabled")


----Shine Counter

function shines()
    return Tracker:ProviderCountForCode("shine")
end
function shinecount(targetshines)
    return shines() >= tonumber(targetshines)
end
function blues()
    return Tracker:ProviderCountForCode("blue")
end
function bluecount(targetblues)
    return blues() >= tonumber(targetblues)
end
function Boathousetrade()
    return Tracker:ProviderCountForCode("boat_maximum")
end
function hascoronashines()
    if Tracker:ProviderCountForCode("shine") >= Tracker:ProviderCountForCode("coronashines") then
        return true
    end
end


----Nozzles / Moves

function spray()
    return has("fludd")
end

function hover()
    return has("hover")
end

function turbo()
   return has("turbo")
end

function rocket()
    return has("rocket")
end

function yoshi()
    return has("yoshi")
end


----Movement Combos
-- (NO FLUDD)
function fluddless()
    return true
end

-- (ANY FLUDD)
function anyfludd()
    return has("fludd") or has("hover") or has("rocket") or has("turbo")
end

-- (spray OR hover)
function splasher()
    return has("fludd") or has("hover")
end

-- (SPLASHER (spray or hover) OR yoshi)
function anysplasher()
    return has("fludd") or has("hover") or has("yoshi")
end

-- (SPLASHER (spray or hover) OR turbo)
function splasherturbo()
    return has("fludd") or has("hover") or has("turbo")
end

-- (ANY_SPLASHER (spray or hover or yoshi) OR turbo)
function anysplasherturbo()
    return has("fludd") or has("hover") or has("turbo") or has("yoshi")
end

-- (hover OR rocket)
function height()
    return has("hover") or has("rocket")
end

-- (spray OR turbo)
function speed()
    return has("fludd") or has("turbo")
end

-- (spray OR yoshi)
function squirter()
    return has("fludd") or has("yoshi")
end

-- (spray + rocket)
function sprocket()
    return has("fludd") and has("rocket")
end

-- (spray + hover)
function sprover()
    return has("fludd") and has("hover")
end

-- (spray + turbo)
function spurbo()
    return has("fludd") and has("turbo")
end

-- (hover + turbo)
function hovurbo()
    return has("hover") and has("turbo")
end

----Intro Skips

function skipintro()
    return has("nozzlefluddless")
end

function skipforward()
    return has("nozzlefluddless") or has("progression_ticket")
end

----Difficulty Settings Logic

function StandardLogic()
    if has("StandardLogic") then
        return true
    end
end

function HardLogic()
    if has("HardLogic") then
        return AccessibilityLevel.Normal
    elseif has("OoLDisplay_off") then
        return AccessibilityLevel.None
    elseif has("StandardLogic") then
        return AccessibilityLevel.SequenceBreak
    end
end

function AdvancedLogic()
    if has("AdvancedLogic") then
        return AccessibilityLevel.Normal
    elseif has("OoLDisplay_off") then
        return AccessibilityLevel.None
    elseif has("HardLogic") then
        return AccessibilityLevel.SequenceBreak
    end
end

function SaltyLogic()
    if has("SaltyLogic") then
        return AccessibilityLevel.Normal
    elseif has("OoLDisplay_off") then
        return AccessibilityLevel.None
    elseif has("AdvancedLogic") then
        return AccessibilityLevel.SequenceBreak
    end
end

-- Entrance Functions
-- Function for Corona and Airstrip Entrances

function iscoronaenterable()
    return hascoronashines()
end

-- Boathouse

function isBoatHouseEnterable()
    if has("progression") == has("progression_vanilla") then
        return splasher() and shines() >= 3
    else
        return has("progression") == has("progression_ticket")
    end
end

-- Bianco

function isBiancoEnterable()
    if has("progression") == has("progression_ticket") then
        return has("bianco")
    elseif has("progression") == has("progression_vanilla") then
        return splasher() or skipintro()
    end
end

function Bianco1()
    return true
end

function Bianco2()
    if has("OpenEpisodes") then
        return true
    elseif has("AdvancedLogic") then
        return splasherturbo()
    elseif has("HardLogic") then
        return splasher()
    else
        return spray()
    end
end

function Bianco3()
    if has("OpenEpisodes") then
        return true
    elseif has("SaltyLogic") then
        return splasherturbo()
    elseif has("HardLogic") then
        return splasher()
    else
        return sprover()
    end
end

function Bianco4()
    return Bianco3()
end

function Bianco5()
    return Bianco3()
end

function Bianco6()
    if has("OpenEpisodes") then
        return true
    elseif has("HardLogic") then
        return spray()
    else
        return sprover()
    end
end

function Bianco7()
    return Bianco6()
end

function Bianco8()
    return Bianco6()
end

-- Ricco

function isRiccoEnterable()
    if has("progression") == has("progression_ticket") then
        return has("ricco")
    elseif has("progression") == has("progression_vanilla") then
        return splasher() and shines() >= 3
    end
end

function Ricco1()
    return true
end

function Ricco2()
    if has("OpenEpisodes") then
        return true
    elseif has("AdvancedLogic") then
        return anyfludd()
    elseif has("HardLogic") then
        return splasher() or turbo()
    else
        return splasher()
    end
end

function Ricco3()
    return Ricco2()
end

function Ricco4()
    if has("OpenEpisodes") then
        return true
    elseif has("HardLogic") then
        return splasher() or turbo()
    else
        return hover() or sprocket()
    end
end

function Ricco5()
    return Ricco4()
end

function Ricco6()
    return Ricco4()
end

function Ricco7()
    return Ricco4()
end

function Ricco8()
    if has("OpenEpisodes") then
        return true
    elseif has("HardLogic") then
        return splasher()
    else
        return sprover() or sprocket()
    end
end

-- Gelato

function isGelatoEnterable()
    if has("progression") == has("progression_ticket") then
        return has("gelato")
    elseif has("progression") == has("progression_vanilla") then
        return splasher() and shines() >= 5
    end
end

function Gelato1()
    return true
end

function Gelato2()
    if has("OpenEpisodes") then
        return true
    else
        return splasher() or turbo()
    end
end

function Gelato3()
    if has("OpenEpisodes") then
        return true
    elseif has("AdvancedLogic") then
        return splasher() or turbo()
    elseif has("HardLogic") then
        return splasher()
    else
        return spray()
    end
end

function Gelato4()
    return Gelato3()
end

function Gelato5()
    if has("OpenEpisodes") then
        return true
    elseif has("HardLogic") then
        return splasher()
    else
        return sprover()
    end
end

function Gelato6()
    return Gelato5()
end

function Gelato7()
    return Gelato5()
end

function Gelato8()
    return Gelato5()
end

-- Pinna

function isPinnaEnterable()
    if has("progression") == has("progression_ticket") then
        return has("pinna")
    elseif has("progression") == has("progression_vanilla") then
        return shines() >= 10
    end
end

function Pinna1()
    return true
end

function Pinna2()
    if has("OpenEpisodes") then
        return true
    else
        return spray()
    end
end

function Pinna3()
    return Pinna2()
end

function Pinna4()
    if has("OpenEpisodes") then
        return true
    elseif has("HardLogic") then
        return spray()
    else
        return sprover()
    end
end

function Pinna5()
    return Pinna4()
end

function Pinna6()
    return Pinna4()
end

function Pinna7()
    if has("OpenEpisodes") then
        return true
    elseif has("HardLogic") then
        return spray() and yoshi()
    else
        return sprover() and yoshi()
    end
end

function Pinna8()
    return Pinna7()
end

--Sirena

function isSirenaEnterable()
    if has("progression") == has("progression_ticket") then
        return has("sirena")
    elseif has("progression") == has("progression_vanilla") then
        return has("yoshi") and shines() >= 5
    end
end

function Sirena1()
    return true
end

function Sirena2()
    if has("OpenEpisodes") then
        return true
    elseif has("SaltyLogic") then
        return splasher() or turbo()
    elseif has("HardLogic") then
        return splasher()
    else
        return sprover()
    end
end

function Sirena3()
    if has("OpenEpisodes") then
        return true
    elseif has("HardLogic") then
        return splasher()
    else
        return sprover()
    end
end

function Sirena4()
    if has("OpenEpisodes") then
        return true
    elseif has("HardLogic") then
        return splasher() and yoshi()
    else
        return sprover() and yoshi()
    end
end

function Sirena5()
    if has("OpenEpisodes") then
        return true
    elseif has("HardLogic") then
        return spray() and yoshi()
    else
        return sprover() and yoshi()
    end
end

function Sirena6()
    return Sirena5()
end

function Sirena7()
    return Sirena5()
end

function Sirena8()
    return Sirena5()
end

--Noki

function isNokiEnterable()
    if has("progression") == has("progression_ticket") then
        return has("noki")
    elseif has("progression") == has("progression_vanilla") then
        return shines() >= 20
    end
end

function Noki1()
    return true
end

function Noki2()
    if has("OpenEpisodes") then
        return true
    elseif has("HardLogic") then
        return splasher()
    else
        return sprover()
    end
end

function Noki3()
    return Noki2()
end

function Noki4()
    if has("OpenEpisodes") then
        return true
    elseif has("HardLogic") then
        return hover()
    else
        return sprover()
    end
end

function Noki5()
    if has("OpenEpisodes") then
        return true
    elseif has("SaltyLogic") then
        return hover()
    else
        return sprover()
    end
end

function Noki6()
    return Noki5()
end

function Noki7()
    return Noki5()
end

function Noki8()
    return Noki5()
end

-- Pianta

function isPiantaEnterable()
    if has("progression") == has("progression_ticket") then
        return has("pianta")
    elseif has("progression") == has("progression_vanilla") then
        return true
    end
end

function Pianta1()
    return true
end

function Pianta2()
    if has("OpenEpisodes") then
        return true
    elseif has("HardLogic") then
        return splasher() or turbo()
    else
        return splasher()
    end
end

function Pianta3()
    return Pianta2()
end

function Pianta4()
    if has("OpenEpisodes") then
        return true
    elseif has("SaltyLogic") then
        return splasher() or turbo()
    elseif has("HardLogic") then
        return sprocket() or hover() or turbo()
    else
        return sprocket() or hover()
    end
end

function Pianta5()
    if has("OpenEpisodes") then
        return true
    elseif has("SaltyLogic") then
        return splasher() or turbo()
    elseif has("HardLogic") then
        return sprocket() or hover() or turbo()
    else
        return sprocket()
    end
end

function Pianta6()
    if has("OpenEpisodes") then
        return true
    elseif has("AdvancedLogic") then
        return hover() or yoshi()
    elseif has("HardLogic") then
        return (sprocket() or hover() or turbo()) and yoshi()
    else
        return sprocket() and yoshi()
    end
end

function Pianta7()
    return Pianta6()
end

function Pianta8()
    if has("OpenEpisodes") then
        return true
    elseif has("AdvancedLogic") then
        return splasher() or (yoshi() and spray())
    elseif has("HardLogic") then
        return (rocket() or hover() or turbo()) and yoshi() and spray()
    else
        return sprocket() and yoshi()
    end
end

-- Boathouse

function BH(amount,itemcode)
    if has("blues") == has("blues_on") or has("blues_boathouse") then
        return Tracker:ProviderCountForCode(itemcode) >= tonumber(amount)
    end
end

-- Episode Select

function allEpisodes()
    return has("episode1") or has("episode2") or has("episode3") or has("episode4") or has("episode5") or has("episode6") or has ("episode7") or has("episode8") or has("allepisodes")
end
