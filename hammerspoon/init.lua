-- init.lua

-- CONFIGURATION

-- How close to the top before firing (pixels)
local threshold         = 35
-- How often to poll the mouse (seconds)
local pollInterval      = 0.05
-- Minimum seconds between triggers
local cooldown          = 1.0

-- The names of the Shortcuts to run
local enterShortcutName = "Reduce Transparency"
local exitShortcutName  = "Increase Transparency"

-- INTERNAL STATE

local inZone            = false
local lastTrigger       = 0

-- FUNCTION: run a macOS Shortcut in the background
local function runShortcut(name)
    local task = hs.task.new(
        "/usr/bin/shortcuts",
        function(exitCode, stdOut, stdErr)
            if exitCode ~= 0 then
                hs.console.printStyledtext("Shortcut “" .. name .. "” failed with code " .. exitCode .. ": " .. stdErr)
            end
        end,
        { "run", name }
    )
    task:start()
end

-- POLL LOOP

hs.timer.doEvery(pollInterval, function()
    local pos = hs.mouse.absolutePosition()
    local now = hs.timer.secondsSinceEpoch()

    if pos.y <= threshold then
        -- Mouse is in the top zone
        if not inZone and (now - lastTrigger) > cooldown then
            inZone      = true
            lastTrigger = now
            runShortcut(enterShortcutName)
        end
    else
        -- Mouse is outside the top zone
        if inZone and (now - lastTrigger) > cooldown then
            inZone      = false
            lastTrigger = now
            runShortcut(exitShortcutName)
        end
    end
end)
