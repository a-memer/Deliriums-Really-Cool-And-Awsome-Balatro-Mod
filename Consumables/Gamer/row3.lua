local defence = {
    key = 'selfdefence',
    loc_txt = {
        name = 'Self Defence',
        text = {'Add {C:attention}Eternal{} and {C:dark_edition}Polychrome{}',
                'to a random Joker'}
    },
    set = 'Gamer',
    pos = {x=2,y=0},
    cost = 4,
    atlas = 'gamer-cards',
    can_use = function(self,card)
        for j=1, #G.jokers.cards do 
            _card = G.jokers.cards[j]
            if _card.edition == nil and (not _card.ability.eternal and not _card.ability.perishable) then
                return true
            end
        end
    end,
    use = function(self,card,area,copier) 
        local validJokers = {}
        for j=1, #G.jokers.cards do 
            _card = G.jokers.cards[j]
            if _card.edition == nil and (not _card.ability.eternal and not _card.ability.perishable) then
                table.insert(validJokers,_card)
            end
        end
        local chosen_joker = pseudorandom_element(validJokers,pseudoseed('Self Defence'))
        G.E_MANAGER:add_event(Event({
            delay = 0.5, func = function() 
                chosen_joker:set_edition({polychrome = true})
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            delay = 0.5, func = function() 
                chosen_joker:set_eternal(true)
                chosen_joker:juice_up(0.5,0.5)
                play_sound('tarot2', 1, 0.4)
                return true
            end
        }))
        delay(0.5)
    end
}

local draw2 = {
    key = 'draw2',
    loc_txt = {
        name = 'Draw 2',
        text = {'Creates up to {C:attention}2{}',
                'random {C:Gamer}Gamer{} cards',
                '{C:inactive}(Must have room)'}
    },
    set = 'Gamer',
    pos = {x=1,y=2},
    cost = 4,
    atlas = 'gamer-cards',
    can_use = function(self,card)
        return #G.consumeables.cards < G.consumeables.config.card_limit
    end,
    use = function(self,card,area,copier)
        for i=1, math.min(G.consumeables.config.card_limit - #G.consumeables.cards, 2) do
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                local gcard = SMODS.create_card({set = 'Gamer'})
                G.consumeables:emplace(gcard)
                return true 
            end}))
        end
        delay(0.6)
    end
}

local rockknight = {
    key = 'rockknight',
    loc_txt = {
        name = 'Rock Knight',
        text = {'Enhances {C:attention}every{} card {C:attention}held{} in hand',
                'into a {C:attention}Stone Card{}'}
    },
    set = 'Gamer',
    pos = {x=2,y=1},
    atlas = 'gamer-cards',
    cost = 5,
    can_use = function(self,card)
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED or card.ability.fromPrintingError then
            return #G.hand.cards > 1
        end
    end,
    use = function(self,card,area,copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        for i=1, #G.hand.cards do
            local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('card1', percent);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
        end
        for i=1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({trigger = 'after',func = function() G.hand.cards[i]:set_ability(G.P_CENTERS['m_stone']);return true end }))
        end
        for i=1, #G.hand.cards do
            local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay =  0.1,func = function() G.hand.cards[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.2)
    end
}

local determination = {
    key = 'determination',
    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_mr_bones
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative 
    end,
    loc_txt = {
        name = 'Determination',
        text = {'Adds {C:dark_edition}Negative{} to a random joker,',
                'then converts it into {C:attention}Mr. Bones{}',
                '{s:0.8}(Targets lower {s:0.8,C:attention}rarity{s:0.8} cards)'}

                
    },
    set = 'Gamer',
    pos = {x=3,y=0},
    cost = 5,
    atlas = 'gamer-cards',
    can_use = function(self,card)
        for j=1, #G.jokers.cards do
            if not G.jokers.cards[j].ability.eternal then
                return true
            end
        end
        return false
    end,
    use = function(self,card,area,copier)
        local commons = {}
        local uncommons = {}
        local rares = {}
        local other = {}

        for j=1, #G.jokers.cards do 
            local _card = G.jokers.cards[j]
            if _card.config.center.rarity == 1 then
                table.insert(commons,_card)
            elseif _card.config.center.rarity == 2 then
                table.insert(uncommons,_card)
            elseif _card.config.center.rarity == 3 then
                table.insert(rares,_card)
            else 
                table.insert(other,_card)
            end
        end

        local chosenJoker = nil

        if #commons > 0 then
            chosenJoker = pseudorandom_element(commons,pseudoseed('DT'))
        elseif #uncommons > 0 then
            chosenJoker = pseudorandom_element(uncommons,pseudoseed('DT'))
        elseif #rares > 0 then
            chosenJoker = pseudorandom_element(rares,pseudoseed('DT'))
        else
            chosenJoker = pseudorandom_element(other,pseudoseed('DT'))
        end
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() chosenJoker:flip();play_sound('card1', percent);chosenJoker:juice_up(0.3, 0.3);return true end }))
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
            chosenJoker:set_edition({negative = true})
            card:juice_up(0.3, 0.5)
            return true
        end}))
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            chosenJoker:remove_from_deck()
            chosenJoker.config.center = G.P_CENTERS['j_mr_bones']
            chosenJoker:set_ability(chosenJoker.config.center,true)
            chosenJoker:add_to_deck()
            return true 
        end}))
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() chosenJoker:flip();play_sound('tarot2', percent);chosenJoker:juice_up(0.3, 0.3);return true end }))
    end
}

local rareCoin = {
    key = 'rareCoin',
    loc_vars = function(self,info_queue,card)
        return {vars = {G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/5), G.GAME.interest_cap/5)}}
    end,
    loc_txt = {
        name = 'Rare Coin',
        text = {'Earn your current',
                'amount of {C:money}Interest{}',
                '{C:inactive}(Currently {C:money}$#1#{C:inactive})'}
    },
    set = 'Gamer',
    pos = {x=0,y=4},
    atlas = 'gamer-cards',
    cost = 4,
    can_use = function(self,card)
        return true
    end,
    use = function(self,card,area,copier)
        G.E_MANAGER:add_event(Event({trigger = 'immediate',func = function()
            ease_dollars(G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/5), G.GAME.interest_cap/5))
            return true
        end}))
        delay(0.6)
    end
}

return {
    name = 'Row 1',
    list = {rareCoin,draw2,defence,rockknight,determination}
}