local jo_e = {
    key = "jo_e",
    name = "jo_e",
    config = {extra = {x_chips = 0.5, gained_x_chips = 1}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_chips, card.ability.extra.gained_x_chips } }
    end, 
    loc_txt = {
        name = "Jo'e-ker",
        text = {'This Joker gains {X:chips,C:white}X#1#{} Chips',
                'whenever a {C:spectral}Spectral{} card is used.',
                '{C:inactive}(Currently {X:chips,C:white}X#2# {C:inactive} Chips)'}
    },
    pos = {x = 1, y = 2},
    cost = 6,
    atlas = 'mod-jokers',
    rarity = 2,
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.using_consumeable and context.consumeable.ability.set == 'Spectral' and not context.blueprint then
            card.ability.extra.gained_x_chips = card.ability.extra.gained_x_chips + card.ability.extra.x_chips
            G.E_MANAGER:add_event(Event({
                func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xchips',vars={card.ability.extra.gained_x_chips}}}); return true
                end}))
            return
        end

        if context.joker_main then
            return {
                x_chips = card.ability.extra.gained_x_chips,
                colour = G.C.CHIPS
            }
        end
    end
}

local rocky = {
    key = 'rocky',
    name = 'rocky',
    config = {extra = {x_chips = 1, gained_x_chips = 1}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.x_chips,card.ability.extra.gained_x_chips}}
    end,
    loc_txt = {
        name = 'Rocky',
        text = {'This joker gains {X:chips,C:white}X#1#{} Chips',
                'Whenever a {C:attention}Stone Card{} is played',
                '{C:inactive}Resets on end of round.{}',
                '{C:inactive}(Currently {X:chips,C:white}X#2# {C:inactive} Chips)'}
    },
    atlas = 'mod-jokers',
    pos = {x=2, y=2},
    rarity = 2,
    cost = 7,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.effect == 'Stone Card' then
                card.ability.extra.gained_x_chips = card.ability.extra.gained_x_chips + card.ability.extra.x_chips
                return {
                    extra = {focus = card, message = localize{type='variable',key='a_xchips',vars={card.ability.extra.gained_x_chips}}},
                    card = card,
                    colour = G.C.CHIPS
                }
            end
        end


        if context.joker_main then 
            return {
            x_chips = card.ability.extra.gained_x_chips,
            colour = G.C.CHIPS
        }
        end

        if context.end_of_round and not context.blueprint and not context.repetition and context.cardarea == G.jokers then
            card.ability.extra.gained_x_chips = 1
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

local thisguy = {
    key = 'thisguy',
    name = 'ThisGuy',
    loc_txt = {
        name = 'This Guy',
        text = {'When {C:attention}Blind{} is selected, {C:attention}Destroys{}',
        "a random {C:attention}Joker{} and",
        "gives triple it's {C:money}Sell Price{}."}
    },
    atlas = 'mod-jokers',
    pos = {x = 3, y = 2},
    rarity = 2,
    cost = 7,
    calculate = function(self,card,context)
        if context.setting_blind and #G.jokers.cards > 1 then
            local destructable_jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card and not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i] end
            end
            local joker_to_destroy = #destructable_jokers > 0 and pseudorandom_element(destructable_jokers, pseudoseed('thisguy')) or nil
            ease_dollars(joker_to_destroy.sell_cost * 3)
            if joker_to_destroy and not (context.blueprint_card or card).getting_sliced then 
                joker_to_destroy.getting_sliced = true
                G.E_MANAGER:add_event(Event({func = function()
                    (context.blueprint_card or card):juice_up(0.8, 0.8)
                    joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                return true end }))
            end
        end
    end
}

local Shrodo = {
    key = 'shrodo',
    name = 'shrodo',
    config = {extra = {x_chips = 5}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.x_chips}}
    end,    
    loc_txt = {
        name = 'Shrodo',
        text = {'Gives {X:chips,C:white}X#1#{} Chips when',
                'You have half of your {C:blue}Hands{} left,',
                'Otherwise {C:attention}destroys{} every card scored.'}
    },
    rarity = 3,
    blueprint_compat = true,
    atlas = 'mod-jokers',
    pos = {x = 4, y = 2},
    cost = 10,
    calculate = function(self,card,context) 
        if context.destroying_card and (G.GAME.current_round.hands_left < roundNumber(G.GAME.round_resets.hands / 2,0)) then
            return true
        end

        if context.joker_main and (G.GAME.current_round.hands_left >= roundNumber(G.GAME.round_resets.hands / 2,0)) then
            return {
                x_chips = card.ability.extra.x_chips,
                colour = G.C.CHIPS
            }
        end
    end
}


local softwork = {
    key = 'softwork',
    name = 'softwork',
    loc_txt = {
        name = 'Softwork',
        text = {"Converts your held {C:attention}Consumables",
                "Into more {C:attention}Useful{} ones at the",
                'Start of the blind.'}
    },
    rarity = 2,
    atlas = 'mod-jokers',
    pos = {x = 5, y = 2},
    cost = 4,
    blueprint_compat = false,
    calculate = function(self,card,context)
        if context.first_hand_drawn and context.cardarea == G.jokers and not context.blueprint then
            local mostUsed = {hand = 'High Card',amount = 0}
            local secondmostUsed = {hand = 'Pair',amount = 0}
            local chosenCards = {}
            local suits = {['Diamonds'] = 0, ['Hearts'] = 0, ['Clubs'] = 0, ['Spades'] = 0 }
            local ranks = {['2'] = 0, ['3'] = 0, ['4'] = 0, ['5'] = 0, ['6'] = 0,    
                            ['7'] = 0, ['8'] = 0, ['9'] = 0, ['10'] = 0, ['11'] = 0, 
                            ['12'] = 0, ['13'] = 0, ['14'] = 0, }

            -- Getting the target hands
            for k,v in pairs(G.GAME.hands) do
                if v.played > mostUsed.amount then
                    mostUsed.hand = k 
                    mostUsed.amount = v.played
                elseif v.played > secondmostUsed.amount then
                    secondmostUsed.hand = k 
                    secondmostUsed.amount = v.played
                end 
            end

            sendInfoMessage(#G.hand.cards)

            -- Getting the first drawn hand
            for c=1, #G.hand.cards do
                sendInfoMessage('Card' .. c .. ' drawn')
                local _card = G.hand.cards[c]
                ranks[tostring(_card:get_id())] = ranks[tostring(_card:get_id())] + 1
                suits[_card.base.suit] = suits[_card.base.suit] + 1
            end


            for k,v in pairs(suits) do 
                sendInfoMessage(k .. ' = ' .. tostring(v))
            end
           
            for k,v in pairs(ranks) do 
                sendInfoMessage(k .. ' = ' .. tostring(v))
            end

            -- choosing the consumables
            for c=1, #G.consumeables.cards do
                if mostUsed.hand == 'Flush' then
                    -- First checks if you don't already have a suit card chosen
                    -- Then checks if you don't already have a flush
                    if (not tableContains(chosenCards,'c_star') and not tableContains(chosenCards,'c_sun')
                    and not tableContains(chosenCards,'c_moon') and not tableContains(chosenCards,'c_world')) 
                    and not (suits['Spades'] >= 5 or suits['Diamonds'] >= 5 or suits['Hearts'] >= 5 or suits['Clubs'] >= 5) then
                        if suits['Hearts'] > 1 and suits['Hearts'] < 5 and not tableContains(chosenCards,'c_sun') then
                            table.insert(chosenCards, 'c_sun')
                        elseif suits['Spades'] > 1 and suits['Spades']  < 5 and not tableContains(chosenCards,'c_world') then
                            table.insert(chosenCards, 'c_world')
                        elseif suits['Clubs'] > 1 and suits['Clubs'] < 5 and not tableContains(chosenCards,'c_moon') then
                            table.insert(chosenCards, 'c_moon')
                        elseif suits['Diamonds'] > 1 and suits['Diamonds'] < 5 and not tableContains(chosenCards,'c_star') then
                            table.insert(chosenCards, 'c_star')
                        end
                    else 
                        table.insert(chosenCards, 'c_jupiter')
                    end
                elseif mostUsed.hand == 'Straight' then
                    local canMakeStraight = false
                    local alreadyStraight = false
                    
                    for k,v in pairs(ranks) do
                        if tonumber(k) <= 10 then
                            -- Check if this card is the high card of straight
                            if v >= 1 and ranks[tostring(tonumber(k) + 1)] >= 1 and ranks[tostring(tonumber(k) + 2)] >= 1 and ranks[tostring(tonumber(k) + 3)] >= 1 
                            and ranks[tostring(tonumber(k) + 4)] >= 1 then
                                alreadyStraight = true
                            end
                        elseif tonumber(k) >= 7 then
                            -- Check if this card is the low card of straight
                            if v >= 1 and ranks[tostring(tonumber(k) - 1)] >= 1 and ranks[tostring(tonumber(k) - 2)] >= 1 and ranks[tostring(tonumber(k) - 3)] >= 1 
                            and ranks[tostring(tonumber(k) - 4)] >= 1 then
                                alreadyStraight = true
                            end
                        end
                    end

                    for k,v in pairs(ranks) do
                        if tonumber(k) <= 10 then
                            -- Check if straight can be made by strengthing the fourth card into the fifth
                            if v >= 1 and ranks[tostring(tonumber(k) + 1)] >= 1 and ranks[tostring(tonumber(k) + 2)] >= 1 and ranks[tostring(tonumber(k) + 3)] >= 2 
                            and ranks[tostring(tonumber(k) + 4)] == 0 then
                                if not tableContains(chosenCards,'c_strength') then
                                    canMakeStraight = true
                                    table.insert(chosenCards, 'c_strength')
                                end
                            end
                        elseif tonumber(k) >= 7 then
                            -- Check if straight can be made by strengthing a card into the low card
                            if v >= 1 and ranks[tostring(tonumber(k) - 1)] >= 1 and ranks[tostring(tonumber(k) - 2)] >= 1 and ranks[tostring(tonumber(k) - 3)] >= 1 
                            and ranks[tostring(tonumber(k) - 4)] == 0 and ranks[tostring(tonumber(k) - 5)] >= 1 then
                                if not tableContains(chosenCards,'c_strength') then
                                    canMakeStraight = true
                                    table.insert(chosenCards, 'c_strength')
                                end
                            end
                        end
                    end
                    if alreadyStraight then
                        if not tableContains(chosenCards,'c_saturn') then 
                            table.insert(chosenCards, 'c_saturn')
                        end
                    elseif not canMakeStraight then
                        table.insert(chosenCards, 'c_hanged_man')
                    end
                elseif mostUsed.hand == 'Three of a Kind' or mostUsed.hand == 'Four of a Kind' then
                    for k,v in pairs(ranks) do
                        if v >= 1 and v < 3 and ranks[tostring(tonumber(k) - 1)] > 0 then
                            if not tableContains(chosenCards,'c_strength') then
                                table.insert(chosenCards, 'c_strength')
                            else
                                table.insert(chosenCards, 'c_death')
                            end
                        end
                    end
                elseif mostUsed.hand == 'Five of a Kind' then     
                    local has5oak = false
                    for k,v in pairs(ranks) do
                        if v == 4 then
                            if not tableContains(chosenCards,'c_death') then
                                table.insert(chosenCards, 'c_death')
                            end
                        elseif v >= 5 then
                            has5oak = true
                            break
                        end
                    end
                    if has5oak then
                        table.insert(chosenCards, 'c_planet_x')
                    elseif not tableContains(chosenCards,'c_hanged_man') then
                        table.insert(chosenCards, 'c_hanged_man')
                    end
                elseif mostUsed.hand == 'Two Pair' or mostUsed.hand == 'Full House' then 
                    local pairamt = 0
                    local has3oak = false
                    for k,v in pairs(ranks) do
                        if v >= 2 then
                            if v >= 3 then
                                has3oak = true
                            end
                            pairamt = pairamt + 1
                        end
                    end
                    
                    if mostUsed.hand == 'Full House' then
                        if pairamt >= 2 and not has3oak then
                            if not tableContains(chosenCards,'c_death') then
                                table.insert(chosenCards, 'c_death')
                            end
                        elseif has3oak and pairamt == 1 then
                            if not tableContains(chosenCards,'c_death') then
                                table.insert(chosenCards, 'c_death')
                            end
                        elseif pairamt >= 2 and has3oak then
                            if not tableContains(chosenCards,'c_earth') then
                                table.insert(chosenCards, 'c_earth')
                            else
                                table.insert(chosenCards, 'c_hanged_man')
                            end
                        else 
                            table.insert(chosenCards, 'c_hanged_man')
                        end
                    else          
                        if pairamt == 1 then
                            if not tableContains(chosenCards,'c_death') then
                                table.insert(chosenCards, 'c_death')
                            end
                        elseif pairamt >= 2 then
                            if not tableContains(chosenCards,'c_uranus') then
                                table.insert(chosenCards, 'c_uranus') 
                            end                             
                        else
                            if not tableContains(chosenCards,'c_hanged_man') then
                                table.insert(chosenCards, 'c_hanged_man')
                            end
                        end
                    end
                elseif mostUsed.hand == 'Straight Flush' then
                    local hasStraight = false
                    for k,v in pairs(ranks) do
                        if tonumber(k) <= 10 then
                            -- Check if this card is the high card of straight
                            if v >= 1 and ranks[tostring(tonumber(k) + 1)] >= 1 and ranks[tostring(tonumber(k) + 2)] >= 1 and ranks[tostring(tonumber(k) + 3)] >= 1 
                            and ranks[tostring(tonumber(k) + 4)] >= 1 then
                                hasStraight = true
                            end
                        elseif tonumber(k) >= 7 then
                            -- Check if this card is the low card of straight
                            if v >= 1 and ranks[tostring(tonumber(k) - 1)] >= 1 and ranks[tostring(tonumber(k) - 2)] >= 1 and ranks[tostring(tonumber(k) - 3)] >= 1 
                            and ranks[tostring(tonumber(k) - 4)] >= 1 then
                                hasStraight = true
                            end
                        end
                    end
                    if hasStraight then
                        if not tableContains(chosenCards,'c_sigil') then
                            table.insert(chosenCards, 'c_sigil')
                        else                           
                            if not tableContains(chosenCards,'c_hanged_man') then
                                table.insert(chosenCards, 'c_hanged_man')
                            end
                        end
                    end
                elseif mostUsed.hand == 'Flush House' then
                    local pairamt = 0
                    local has3oak = false
                    for k,v in pairs(ranks) do
                        if v >= 2 then
                            if v >= 3 then
                                has3oak = true
                            end
                            pairamt = pairamt + 1
                        end
                    end
                    if pairamt >= 2 and has3oak then
                        if not tableContains(chosenCards,'c_sigil') then 
                            table.insert(chosenCards, 'c_sigil')
                        end
                    else
                        if not tableContains(chosenCards,'c_death') then
                            table.insert(chosenCards, 'c_death')
                        end
                    end
                elseif mostUsed.hand == 'Flush Five' then
                    local has5oak = false
                    local hasSuit = false
                    for k,v in pairs(ranks) do
                        if v == 4 then
                            if not tableContains(chosenCards,'c_death') then
                                table.insert(chosenCards, 'c_death')
                            end
                        elseif v >= 5 then
                            has5oak = true
                            break
                        end
                    end
                    for k,v in pairs(suits) do
                        if v >= 5 then
                            hasSuit = true
                        end
                    end
                    if has5oak and not hasSuit then
                        table.insert(chosenCards, 'c_sigil')
                    elseif not has5oak then
                        if not tableContains(chosenCards,'c_ouija') then 
                            table.insert(chosenCards, 'c_ouija')
                        end                
                    elseif not tableContains(chosenCards,'c_hanged_man') then
                        table.insert(chosenCards, 'c_hanged_man')
                    end
                elseif mostUsed.hand == 'Pair' then
                    local hasPair = false
                    for k,v in pairs(ranks) do
                        if v >= 2 then
                            hasPair = true
                        end
                    end
                    if not hasPair then
                        if not tableContains(chosenCards,'c_death') then
                            table.insert(chosenCards, 'c_death')
                        end
                    else 
                        table.insert(chosenCards, 'c_mercury')
                    end
                elseif mostUsed.hand == 'High Card' then
                    if ranks['11'] == 0 and ranks['12'] == 0 and ranks['13'] == 0 and ranks['14'] == 0 then
                        if not tableContains(chosenCards,'c_strength') then
                            table.insert(chosenCards, 'c_strength') 
                        end
                    else
                        table.insert(chosenCards, 'c_cryptid')
                    end
                end
            end

            while #chosenCards < #G.consumeables.cards do
                table.insert(chosenCards, 'c_fool')
            end

            for c=1, #G.consumeables.cards do
                local bazinga = G.consumeables.cards[c]
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() bazinga:flip();play_sound('card1', percent);bazinga:juice_up(0.3, 0.3);return true end }))
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                    bazinga:remove_from_deck()
                    bazinga.config.center = G.P_CENTERS[chosenCards[c]]
                    bazinga:set_ability(bazinga.config.center,true)
                    bazinga:add_to_deck()
                    return true 
                end}))
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() bazinga:flip();play_sound('tarot2', percent);bazinga:juice_up(0.3, 0.3);return true end }))
            end
        end
    end           
}

return {
    list = {jo_e,rocky,thisguy,Shrodo,softwork}
}