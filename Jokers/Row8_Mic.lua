local crosswalk = {
    key = 'crosswalk',
    name = 'crosswalk',
    config = {extra = {hands = 3}},
    loc_vars = function(self,info_queue,card)
        local waitperiod = 0
        if G.jokers then
            for j=1, #G.jokers.cards do
                if G.jokers.cards[j].config.center.key == 'j_deliriumcoolmod_crosswalk' then
                    waitperiod = waitperiod + card.ability.extra.hands
                end
            end
        end


        return {vars = {card.ability.extra.hands,math.max(3,waitperiod)}}
    end,
    loc_txt = {
        name = 'Crosswalk',
        text = {'{C:blue}+#1#{} Hands per round',
                'Your first {C:blue}#2#{} hands',
                'score no {C:chips}chips{}'}
    },
    rarity = 2,
    atlas = 'mod-jokers',
    pos = {x = 0, y = 5},
    calculate = function(self,card,context)
        local waitperiod = 0
        if G.jokers then
            for j=1, #G.jokers.cards do
                if G.jokers.cards[j].config.center.key == 'j_deliriumcoolmod_crosswalk' then
                    waitperiod = waitperiod + card.ability.extra.hands
                end
            end
        end


        if context.final_scoring_step and G.GAME.current_round.hands_played < waitperiod and not context.blueprint then
            hand_chips = 0
            mult = 0
            update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
            return {
                message = 'Wait!'
            }
        end
    end,
    add_to_deck = function(self,card,from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
    end,
    remove_from_deck = function(self,card,from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
    end
}

local stopSign = {
    key = 'stopSign',
    name = 'Stop Sign',
    loc_txt = {
        name = 'Stop Sign',
        text = {'When a hand is played,',
                '{C:red}Debuff{} the {C:attention}Joker{} to',
                'the right of this'}
    },
    atlas = 'mod-jokers',
    pos = {x = 4, y = 5},
    rarity = 1,
    cost = 4,
    calculate = function(self,card,context)
        local other_joker = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card and i ~= #G.jokers.cards then 
                other_joker = G.jokers.cards[i+1]
                break 
            end
        end

        if context.before and other_joker ~= nil then
            other_joker:set_debuff(true)
            other_joker:juice_up()                
        end

        if context.after and other_joker ~= nil then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function() 
                    other_joker:set_debuff(false)
                    other_joker:juice_up()
                    return true
                end,
                blocking = false
            }))
        end
    end
}

local noshow = {
    key = 'noshow',
    name = 'noshow',
    loc_txt = {
        name = 'No Show',
        text = {'{C:inactive}Does nothing?{}'}
    },
    rarity = 2,
    cost = -5,
    pos = { x = 0, y = 1},
    atlas = 'mod-jokers',
    calculate = function(self,card,context)
    end
}


local mysterysucker = {
    key = 'mysterysucker',
    name = 'mysterysucker',
    config = {extra = {chips = 1500, max_chips = 300}},
    loc_txt = {
        name = 'Mystery Flavor',
        text = {'',
                '{C:inactive}({C:chips}#1#{C:inactive} Chips left)'}
    },
    loc_vars = function(self,info_queue,card)
        local r_chips = {}
        local max = math.min(card.ability.extra.max_chips,card.ability.extra.chips)
        for i=1, 20 do
            table.insert(r_chips,tostring(pseudorandom('mysterysucker',0,max)))
        end

        return {
            vars = {card.ability.extra.chips},
            main_start = {
                {n=G.UIT.T, config={text = '  +',colour = G.C.BLUE, scale = 0.32}},
                {n=G.UIT.O, config={object = DynaText({string = r_chips, colours = {G.C.BLUE},pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.15, scale = 0.32, min_cycle_time = 0})}},
                {n=G.UIT.T, config={text = ' Chips',colour = G.C.L_BLACK, scale = 0.32}},
            }
    }
    end,
    rarity = 1,
    atlas = 'mod-jokers',
    pos = {x = 5, y = 5},
    eternal_compat = false,
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.joker_main then
            local max = math.min(card.ability.extra.max_chips,card.ability.extra.chips)
            local amount = pseudorandom('mystery',0,max)
            card.ability.extra.chips = card.ability.extra.chips - amount
            return {
                chips = amount,
                card = card
            }
        end

        if context.after and card.ability.extra.chips <= 0 and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                        func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                            return true; end})) 
                    return true
                end
            })) 
            return {
                message = localize('k_eaten_ex'),
                colour = G.C.CHIPS
            }
        end
    end
}

local ron = {
    key = 'ron',
    name = 'ron',
    config = {mult = 10},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.mult}}
    end,
    loc_txt = {
        name = 'Ron',
        text = {"{C:mult}+#1#{} Mult if played hand",
                "doesn't contain a {C:attention}Queen"}
    },
    rarity = 1,
    atlas = 'mod-jokers',
    pos = {x = 2, y = 3},
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.joker_main then
            local queenfromdeltarune = false
            for c=1, #context.full_hand do
                if context.full_hand[c]:get_id() == 12 then
                    queenfromdeltarune = true
                    break
                end
            end
            if not queenfromdeltarune then
                return {
                    mult = card.ability.mult,
                    card = card
                }
            end
        end
    end
}

return {
    list = {crosswalk,stopSign,noshow,mysterysucker,ron}
}