Config = {

    devMode = {
        active = false
    },
    -----------------------------------------------------

    escape = {
        active = true,          -- Set to false to disable escape mechanic
        maxRange = 5000,        -- Max range number for escape mechanic (higher number = harder to escape)
        numList = { 5, 6, 20 }, -- Numbers that will allow escape when randomly selected (between 0 and maxRange / more numbers = easier to escape)
        button = 0x760A9C6F,    -- 'G' key by default
        lang = {
            escape = 'Attempt to Break Blindfold',
            button = 'G'
        }
    },
    -----------------------------------------------------

    lang = {
        noPlayers = 'No players nearby',
        noItem = 'You are out of blindfolds'
    },
    -----------------------------------------------------

    commands = {
        blindPlayer = {
            active = true,     -- Set false to disable command to blind nearest player
            name = 'blindfold' -- Command name to blind nearest player
        },

        unBlindPlayer = {
            name = 'unblindfold' -- Command name to unblind nearest player (always active)
        },

        blindSelf = {
            active = true,       -- Set false to disable commands to blind and unblind yourself
            name = 'blindfoldme' -- Command name to blind yourself
        },
        unBlindSelf = {
            name = 'unblindfoldme' -- Command name to unblind yourself
        }
    },
    -----------------------------------------------------

    blindfoldItem = {
        active = true,         -- Set to true to use a blindfold item from inventory to blind players
        itemName = 'blindfold' -- Name of the blindfold item in database
    },
    -----------------------------------------------------

    -- Database seeding control. When true the resource will attempt to
    -- insert/update required items on resource start. Set to false to
    -- prevent automatic seeding and use the console commands instead.
    autoSeedDatabase = true
}
