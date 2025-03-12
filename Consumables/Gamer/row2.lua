local ai = {
    key = 'ai',
    loc_txt = {
        name = 'A.I.',
        text = {'Create a {C:attention}Corrupted{} Joker.',
                '{C:inactive}(Must have room)'}
    },
    set = 'Gamer',
    pos = {x=0,y=1},
    atlas = 'gamer-cards',
    cost = 2,
    can_use = function(self,card)
        if #G.jokers.cards < G.jokers.config.card_limit or card.area == G.jokers then
            return true
        else
            return false
        end
    end,
    use = function(self,card,area,copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            local _card = SMODS.create_card({set = 'Joker'})
            _card:add_to_deck()
            G.jokers:emplace(_card)
            corruptJoker(_card,5,'AI')
            card:juice_up(0.3, 0.5)
            return true end }))
        delay(0.6)
    end
}
local briefcase = {
    key = 'breifCase',
    loc_txt = {
        name = 'Mysterious Briefcase',
        text = {'{C:dark_edition}+1{} Hand Size, Joker slot,', 
                'or Consumable Slot',
                '{C:dark_edition}-1{} Hand Size, Joker slot,', 
                'or Consumable Slot'}
    },
    set = 'Gamer',
    pos = {x=2,y=3},
    atlas = 'gamer-cards',
    cost = 2,
    can_use = function(self,card)
        if G.jokers.config.card_limit >= 1 or G.consumeables.config.card_limit >= 1 or G.hand.config.card_limit >= 1 then
            return true
        end
        return false
    end,
    use = function(self,card,area,copier)
        local Statoptions = {}

        if G.hand.config.card_limit > 0 then
            table.insert(Statoptions,'Hand Size')
        end

        if G.consumeables.config.card_limit > 0 then
            table.insert(Statoptions,'Consumable Slot')
        end        

        if G.jokers.config.card_limit > 0 then
            table.insert(Statoptions,'Joker Slot')
        end        


        local plusStat = pseudorandom_element(Statoptions,pseudoseed('Briefcase'))
        local minusStat = plusStat
        
        while minusStat == plusStat do
            minusStat = pseudorandom_element(Statoptions,pseudoseed('Briefcase'))
        end

        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            if plusStat == 'Hand Size' then
                G.hand:change_size(1)
            elseif plusStat == 'Joker Slot' then 
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            elseif plusStat == 'Consumable Slot' then
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
            end
            card:juice_up(0.3, 0.5)
            play_sound('tarot1')
            return true
        end}))

        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1, func = function()
            if minusStat == 'Hand Size' then
                G.hand:change_size(-1)
            elseif minusStat == 'Joker Slot' then 
                G.jokers.config.card_limit = G.jokers.config.card_limit - 1
            elseif minusStat == 'Consumable Slot' then
                G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
            end
            card:juice_up(0.3, 0.5)
            play_sound('tarot1')
            return true
        end}))
        delay(0.6)
    end
}

local punchcard = {
    key = 'punchcard',
    config = {extra = 25},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra}}
    end,
    loc_txt = {
        name = 'Punch Card',
        text = {'{C:attention}+1{} Ante,',
                'Gain {C:money}$#1#{}'}
    },
    set = 'Gamer',
    pos = {x=4,y=0},
    cost = 3,
    atlas = 'gamer-cards',
    can_use = function(self,card)
        return G.GAME.round_resets.ante ~= G.GAME.win_ante
    end,
    use = function(self,card,area,copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            card:juice_up(0.3, 0.5)
            ease_dollars(card.ability.extra)
            delay(0.2)
            ease_ante(1)
            return true end }))
        delay(0.6)
    end
}

local royalty = {
    key = 'royalty',
    config = {extra = 1},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra}}
    end,
    loc_txt = {
        name = 'Royalty',
        text = {'Earn {C:money}#1#${} for every',
                '{C:attention}Face{} card held in hand'}
    },
    set = 'Gamer',
    cost = 3,
    pos = {x=1,y=1},
    atlas = 'gamer-cards',
    can_use = function(self,card)
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED or card.ability.fromPrintingError then
            return #G.hand.cards > 1
        end
    end,
    use = function(self,card,area,copier)
        for i=1, #G.hand.cards do 
            local _card = G.hand.cards[i]
            if _card:is_face() then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
                    play_sound('generic1')
                    card:juice_up(0.3, 0.5)
                    _card:juice_up(0.3, 0.5)
                    return true
                end}))
                ease_dollars(card.ability.extra)
                delay(0.1)
            end
        end
        delay(0.6)
    end
              
}

local offbrand = {
    key = 'offbrand',
    config = {extra = 2},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra}}
    end,
    loc_txt = {
        name = 'Off Brand',
        text = {'Create {C:attention}#1#{}',
                'random {C:attention}Tags{}'}
    },
    set = 'Gamer',
    cost = 3,
    pos = {x=2,y=2},
    atlas = 'gamer-cards',
    can_use = function(self,card)
        return true
    end,
    use = function(self,card,area,copier)
        for i=1, card.ability.extra do
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                local tagkey = get_next_tag_key()
                local tag = Tag(tagkey)
                if tagkey == 'tag_orbital' then
                    local _poker_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible then _poker_hands[#_poker_hands+1] = k end
                    end
                    
                    tag.ability.orbital_hand = pseudorandom_element(_poker_hands, pseudoseed('orbital'))
                end
                play_sound('timpani')
                add_tag(tag)
                card:juice_up(0.3, 0.5)
                return true
            end}))
        end
        delay(0.6)
    end
}

return {
    list = {ai,briefcase,punchcard,royalty,offbrand}
}