if not BCCBlindfoldDebug then
    ---@class BCCBlindfoldDebugLib
    ---@field Info fun(message: string)
    ---@field Error fun(message: string)
    ---@field Warning fun(message: string)
    ---@field Success fun(message: string)
    ---@field DevModeActive boolean
    BCCBlindfoldDebug = {}

    BCCBlindfoldDebug.DevModeActive = (Config and Config.devMode and Config.devMode.active) or false

    local function noop() end

    local function createLogger(prefix, color)
        if BCCBlindfoldDebug.DevModeActive then
            return function(message)
                print(("^%d[%s] ^3%s^0"):format(color, prefix, message))
            end
        else
            return noop
        end
    end

    -- Create loggers with appropriate colors
    BCCBlindfoldDebug.Info = createLogger("INFO", 5)       -- Purple
    BCCBlindfoldDebug.Error = createLogger("ERROR", 1)     -- Red
    BCCBlindfoldDebug.Warning = createLogger("WARNING", 3) -- Yellow
    BCCBlindfoldDebug.Success = createLogger("SUCCESS", 2) -- Green
end
