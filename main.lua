mod = SMODS.current_mod
jokerpath = mod.path .. "/Jokers"
tagpath = mod.path .. "/Tags"
voucherpath = mod.path .. "/Vouchers"


loc_colour('red')
G.ARGS.LOC_COLOURS['Gamer'] = HEX("FD8F57")

NFS.load(mod.path .. '/src/' .. 'Utils.lua')()
NFS.load(mod.path .. '/src/' .. 'Challenges.lua')()
NFS.load(mod.path .. '/src/' .. 'Overrides.lua')()
NFS.load(mod.path .. '/src/' .. 'Poker Hands.lua')()


SMODS.Sound({key = 'babycat', path = 'babycat.ogg'})


SMODS.Atlas({key = "modicon",path = "mod-icon.png",px = 32,py = 32,}):register()
SMODS.Atlas({key = "gamer-cards",px = 71,py = 95,path = {['default'] = 'gamer-cards.png'}}):register()
SMODS.Atlas({key = "mod-jokers",px = 71,py = 95,path = {['default'] = 'mod-jokers.png'}}):register()
SMODS.Atlas({key = "mod-boosters",px = 71,py = 95,path = {['default'] = 'mod-boosters.png'}}):register()
SMODS.Atlas({key = "mod-tags",px = 34,py = 34,path = {['default'] = 'mod-tags.png'}}):register()
SMODS.Atlas({key = "mod-decks",px = 71,py = 95,path = {['default'] = 'mod-decks.png'}}):register()
SMODS.Atlas({key = "mod-vouchers",px = 71,py = 95,path = {['default'] = 'mod-vouchers.png'}}):register()
SMODS.Atlas({key = "mod-planets",px = 71,py = 95,path = {['default'] = 'mod-planets.png'}}):register()
SMODS.Atlas({key = "mod-stickers",px = 71,py = 95,path = {['default'] = 'mod-stickers.png'}}):register()

SMODS.ConsumableType {
    key = 'Gamer',
    primary_colour = HEX('FDBF51'),
    secondary_colour = HEX('FD7457'),
    collection_rows = {6,5},
    loc_txt = {
        name = 'Gamer', -- used on card type badges
        collection = 'Gamer Cards', -- label for the button to access the collection
        undiscovered = { -- description for undiscovered cards in the collection
            name = 'Not Discovered',
            text = { 'probably for the best, anyway.' },
        },
    }
}

SMODS.Rarity {
    key = 'unknown',
    loc_txt = {
        name = 'UNKNOWN'
    },
    pools = {
        ['Joker'] = {rate = 0.0}
    },
    badge_colour = HEX('BD199C')
}


local function loadJokers(folder)
    local jokers = NFS.getDirectoryItems(jokerpath)
    for _, file in pairs(jokers) do
        local path = mod.path..folder.."/"..file
        sendInfoMessage(path)
        local loadedfile = NFS.load(path)
        local curjoker = loadedfile()

        for _, joker in ipairs(curjoker.list) do
            SMODS.Joker(joker)
        end
    end
end

local function loadTags(folder)
    local jokers = NFS.getDirectoryItems(tagpath)
    for _, file in pairs(jokers) do
        local path = mod.path..folder.."/"..file
        sendInfoMessage(path)
        local loadedfile = NFS.load(path)
        local curjoker = loadedfile()

        for _, joker in ipairs(curjoker.list) do
            SMODS.Tag(joker)
        end
    end
end

local function loadVouchers(folder)
    local jokers = NFS.getDirectoryItems(voucherpath)
    for _, file in pairs(jokers) do
        local path = mod.path..folder.."/"..file
        sendInfoMessage(path)
        local loadedfile = NFS.load(path)
        local curjoker = loadedfile()

        for _, joker in ipairs(curjoker.list) do
            SMODS.Voucher(joker)
        end
    end
end

local function loadConsumables(folder)
    local jokers = NFS.getDirectoryItems(mod.path .. "/" .. folder)
    for _, file in pairs(jokers) do
        local path = mod.path..folder.."/"..file
        sendInfoMessage(path)
        local loadedfile = NFS.load(path)
        local curjoker = loadedfile()

        for _, joker in ipairs(curjoker.list) do
            SMODS.Consumable(joker)
        end
    end
end

loadJokers("Jokers")
loadTags("Tags")
loadVouchers("Vouchers")
loadConsumables("Consumables/Gamer")
loadConsumables("Consumables/Spectral")
loadConsumables("Consumables/Planet")

local dreamerDeck = SMODS.Back {
    key = 'dreamerDeck',
    loc_txt = {
        name = 'Dreamer Deck',
        text = {'You may play',
            '{C:attention}6 cards{} per hand'}
    },
    config = {cards_per_hand = 6, cards_per_discard = 6},
    atlas = 'mod-decks',
    pos = {x = 0,y = 0},
    unlocked = true
}

local deadmansDeck = SMODS.Back {
    key = 'deadmansDeck',
    loc_txt = {
        name = "Dead Man's Deck",
        text = {'Start run with the',
            '{T:v_deliriumcoolmod_irony,C:Gamer}Irony{} voucher',
            'and an {T:c_deliriumcoolmod_intrusivethought,C:Gamer}Intrusive Thought{} card'}
    },
    config = {vouchers = {'v_deliriumcoolmod_irony'}, consumables = {'c_deliriumcoolmod_intrusivethought'}},
    atlas = 'mod-decks',
    pos = {x = 1,y = 0},
    unlocked = true
}


SMODS.Booster {
    key = 'gamerBooster1',
    config = {extra = 3, choose = 1},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.choose, card.ability.extra}}
    end,
    loc_txt = {
        name = 'Gamer Pack',
        text = {'Choose {C:attention}#1#{} of up to',
                '{C:attention}#2# {C:Gamer}Gamer{} cards to',
                'be used immediately'},
        group_name = 'Gamer Pack'
    },
    pos = {x=0,y=0},
    atlas = 'mod-boosters',
    draw_hand = true,
    kind = 'gamer',
    weight = 0.5,
    create_card = function(self,card,i)
        if i == 1 or G.GAME.gamer_choices == nil then
            G.GAME.gamer_choices = {}
        end
        
        local qualityControl = false
        for v=1, #G.vouchers.cards do
            local lekey = G.vouchers.cards[v].config.center.key
            if lekey == 'v_deliriumcoolmod_qualitycontrol' then
                qualityControl = true
            end
        end

        local key = get_gamer_for_pack(qualityControl)
        local card = SMODS.create_card({set = "Gamer", area = G.pack_cards, key = key, skip_materialize = true, soulable = true, key_append = "gam"})
        return card
    end
}






SMODS.Booster {
    key = 'gamerBooster2',
    config = {extra = 3, choose = 1},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.choose, card.ability.extra}}
    end,
    loc_txt = {
        name = 'Gamer Pack',
        text = {'Choose {C:attention}#1#{} of up to',
                '{C:attention}#2# {C:Gamer}Gamer{} cards to',
                'be used immediately'},
        group_name = 'Gamer Pack'
    },
    pos = {x=1,y=0},
    kind = 'gamer',
    atlas = 'mod-boosters',
    draw_hand = true,
    weight = 0.5,
    create_card = function(self,card,i)
        if i == 1 or G.GAME.gamer_choices == nil then
            G.GAME.gamer_choices = {}
        end
        
        local qualityControl = false
        for v=1, #G.vouchers.cards do
            local lekey = G.vouchers.cards[v].config.center.key
            if lekey == 'v_deliriumcoolmod_qualitycontrol' then
                qualityControl = true
            end
        end

        local key = get_gamer_for_pack(qualityControl)
        local card = SMODS.create_card({set = "Gamer", area = G.pack_cards, key = key, skip_materialize = true, soulable = true, key_append = "gam"})
        return card
    end
}

SMODS.Booster {
    key = 'gamerBoosterJumbo',
    config = {extra = 4, choose = 1},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.choose, card.ability.extra}}
    end,
    loc_txt = {
        name = 'Jumbo Gamer Pack',
        text = {'Choose {C:attention}#1#{} of up to',
                '{C:attention}#2# {C:Gamer}Gamer{} cards to',
                'be used immediately'},
        group_name = 'Gamer Pack'
    },
    pos = {x=2  ,y=0},
    atlas = 'mod-boosters',
    kind = 'gamer',
    draw_hand = true,
    weight = 0.3,
    cost = 6,
    create_card = function(self,card,i)
        if i == 1 or G.GAME.gamer_choices == nil then
            G.GAME.gamer_choices = {}
        end
        
        local qualityControl = false
        for v=1, #G.vouchers.cards do
            local lekey = G.vouchers.cards[v].config.center.key
            if lekey == 'v_deliriumcoolmod_qualitycontrol' then
                qualityControl = true
            end
        end

        local key = get_gamer_for_pack(qualityControl)
        local card = SMODS.create_card({set = "Gamer", area = G.pack_cards, key = key, skip_materialize = true, soulable = true, key_append = "gam"})
        return card
    end
}

SMODS.Booster {
    key = 'gamerBoosterMega',
    config = {extra = 4, choose = 2},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.choose, card.ability.extra}}
    end,
    loc_txt = {
        name = 'Mega Gamer Pack',
        text = {'Choose {C:attention}#1#{} of up to',
                '{C:attention}#2# {C:Gamer}Gamer{} cards to',
                'be used immediately'},
        group_name = 'Gamer Pack'
    },
    pos = {x=3 ,y=0},
    kind = 'gamer',
    atlas = 'mod-boosters',
    draw_hand = true,
    weight = 0.25,
    cost = 6,
    create_card = function(self,card,i)
        if i == 1 or G.GAME.gamer_choices == nil then
            G.GAME.gamer_choices = {}
        end
        
        local qualityControl = false
        for v=1, #G.vouchers.cards do
            local lekey = G.vouchers.cards[v].config.center.key
            if lekey == 'v_deliriumcoolmod_qualitycontrol' then
                qualityControl = true
            end
        end

        local key = get_gamer_for_pack(qualityControl)
        local card = SMODS.create_card({set = "Gamer", area = G.pack_cards, key = key, skip_materialize = true, soulable = true, key_append = "gam"})
        return card
    end
}


SMODS.Sticker {
    key = 'golem',
    loc_txt = {
        name = 'GOLEM',
        text = {
            "When {C:attention}Blind{} is selected,",
            "destroy Joker to the right",
            "and permanently add {C:attention}0.25",
            "to this Joker's {C:attention}compatible{} values"
        },
        label = 'GOLEM'
    },
    badge_colour = HEX('A4615E'),
    atlas = 'mod-stickers',
    pos = {x=0,y=0},
    calculate = function(self,card,context)
        if context.setting_blind then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not card.getting_sliced and not G.jokers.cards[my_pos+1].ability.eternal and not G.jokers.cards[my_pos+1].getting_sliced then 
                local sliced_card = G.jokers.cards[my_pos+1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    increase_joker_values(card,0.25,false)
                    card:juice_up(0.8, 0.8)
                    sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    play_sound('slice1', 0.96+math.random()*0.08)
                return true end }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
            end
        end
    end
} 









-- SMODS.Joker{
--     key = 'frisk1',
--     loc_txt = {
--         name = 'Frisk',
--         text = {'Determined'}
--     },
--     atlas = 'mod-jokers',
--     pos = {x=2,y=7}
-- }

-- SMODS.Joker{
--     key = 'vent1',
--     loc_txt = {
--         name = 'Vent',
--         text = {'Not Determined'}
--     },
--     atlas = 'mod-jokers',
--     pos = {x=1,y=7}
-- }

SMODS.Sound({
    key = "gamerpack_music",
    path = "gamer_pack.ogg",
    sync = {
        ['music1'] = true,
        ['music2'] = true,
        ['music3'] = true,
        ['music4'] = true,
        ['music5'] = true,
    },
    select_music_track = function(self) 
        return G.booster_pack and not G.booster_pack.REMOVED and SMODS.OPENED_BOOSTER and SMODS.OPENED_BOOSTER.config.center.kind == 'gamer' and 100 or nil
    end
})







