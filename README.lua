getgenv().Key = "72e0fa9a82bac27e6e874dfe" 

getgenv().Config = {
    ["Max Plant Fruit"] = 200,
    ["Buy Expand Plot"] = true,
    ["Pet"] = {
        ["Auto Buy"] = {
            ["Enable"] = true,
            ["Pet"] = {
                ["IceSerpent"]      = true,   -- $20M
                ["Raccoon"]         = true,   -- $5M
                ["Unicorn"]         = true,   -- $4M
                ["GoldenDragonfly"] = true,   -- $3M
                ["BlackDragon"]     = true,   -- $1M
                ["Monkey"]          = true,   -- $1M
                ["Bee"]             = true,   -- $1M
                ["Robin"]           = true,   -- $75K
                ["Deer"]            = false,  -- $50K
                ["Owl"]             = false,  -- $25K
                ["Bunny"]           = false,  -- $20K
                ["Frog"]            = false,  -- $10K
            },
        },
    },
    ["Mail"] = {
        ["Enable"]      = false,
        ["Username"]    = "",
        ["Note"]        = "auto-shipped from main",
        ["IntervalSec"] = 30,
        ["Pet"] = {
            ["IceSerpent"]      = false,
            ["Raccoon"]         = false,
            ["Unicorn"]         = false,
            ["GoldenDragonfly"] = false,
            ["BlackDragon"]     = false,
            ["Monkey"]          = false,
            ["Bee"]             = false,
            ["Robin"]           = false,
            ["Deer"]            = false,
            ["Owl"]             = false,
            ["Bunny"]           = false,
            ["Frog"]            = false,
        },
        ["Seed"] = {
            ["Rainbow"] = false,
            ["Gold"]    = false,
        },
    },
    ["Plant Seed"] = {
        ["Enable"] = true,
        ["Seed"] = {
            ["Bamboo"]          = true,   -- $10
            ["Blueberry"]       = true,   -- $25
            ["Tulip"]           = true,   -- $40
            ["Apple"]           = true,   -- $50
            ["Tomato"]          = true,   -- $200
            ["Banana"]          = true,   -- $1K
            ["Sunflower"]       = true,   -- $1K
            ["Corn"]            = true,   -- $2.5K
            ["Mushroom"]        = true,   -- $15K
            ["Cherry"]          = true,   -- $30K
            ["Mango"]           = true,   -- $35K
            ["Grape"]           = true,   -- $50K
            ["Coconut"]         = true,   -- $70K
            ["Cactus"]          = true,   -- $100K
            ["Baby Cactus"]     = true,   -- $100K
            ["Pomegranate"]     = true,   -- $200K
            ["Pineapple"]       = true,   -- $250K
            ["Dragon Fruit"]    = true,   -- $500K
            ["Poison Apple"]    = true,   -- $1M
            ["Moon Bloom"]      = true,   -- $1M
            ["Poison Ivy"]      = true,   -- $1M
            ["Ghost Pepper"]    = true,   -- $1M
            ["Venus Fly Trap"]  = true,   -- $5M
            ["Dragon's Breath"] = true,   -- $10M
        },
    },
    ["Buy Seed"] = {
        ["Enable"] = true,
        ["Seed"] = {
            ["Bamboo"]          = true,   -- $10
            ["Blueberry"]       = true,   -- $25
            ["Tulip"]           = true,   -- $40
            ["Apple"]           = true,   -- $50
            ["Tomato"]          = true,   -- $200
            ["Banana"]          = true,   -- $1K
            ["Sunflower"]       = true,   -- $1K
            ["Corn"]            = true,   -- $2.5K
            ["Mushroom"]        = true,   -- $15K
            ["Cherry"]          = true,   -- $30K
            ["Mango"]           = true,   -- $35K
            ["Grape"]           = true,   -- $50K
            ["Coconut"]         = true,   -- $70K
            ["Cactus"]          = true,   -- $100K
            ["Baby Cactus"]     = true,   -- $100K
            ["Pomegranate"]     = true,   -- $200K
            ["Pineapple"]       = true,   -- $250K
            ["Dragon Fruit"]    = true,   -- $500K
            ["Poison Apple"]    = true,   -- $1M
            ["Moon Bloom"]      = true,   -- $1M
            ["Poison Ivy"]      = true,   -- $1M
            ["Ghost Pepper"]    = true,   -- $1M
            ["Venus Fly Trap"]  = true,   -- $5M
            ["Dragon's Breath"] = true,   -- $10M
        },
    },
    
    ["Buy Gear"] = {
        ["Enable"] = false,
        ["Gear"] = {
            ["Common Watering Can"]  = true,   -- $2K
            ["Super Watering Can"]   = true,   -- $250K
            ["Common Sprinkler"]     = true,   -- $3K
            ["Uncommon Sprinkler"]   = true,   -- $10K
            ["Rare Sprinkler"]       = true,   -- $50K
            ["Legendary Sprinkler"]  = true,   -- $100K
            ["Super Sprinkler"]      = true,   -- $300K
        },
    },
    ["Auto Water"] = {
        ["Enable"] = false,
    },
    ["Auto Sprinkler"] = {
        ["Enable"] = false,
    },

    ["Webhook"] = {
        ["Enable"]            = false,
        ["URL"]               = "",      -- https://discord.com/api/webhooks/...
        ["Username"]          = "OneClick GAG2",
        ["OnRarePet"]         = true,    -- ping when a rare pet is tamed
        ["OnRareSeed"]        = true,    -- ping when Rainbow/Gold seed claimed
        ["PetMinPrice"]       = 0,       -- only notify pets with BasePrice >= this
        ["PetRarity"] = {                -- which rarities trigger pet notify
            ["Common"]    = false,
            ["Uncommon"]  = false,
            ["Rare"]      = false,
            ["Legendary"] = true,
            ["Mythic"]    = true,
            ["Super"]     = true,
            ["Divine"]    = true,
            ["Prismatic"] = true,
        },
        ["ProfileReport"]     = false,   -- send periodic profile summary
        ["ProfileIntervalMin"]= 30,      -- minutes between profile reports
    },
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/OneclickGAG2.lua"))()
