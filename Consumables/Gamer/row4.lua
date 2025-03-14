local wheel = {
    key = 'wheelofpain',
    config = {extra = 6},
    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue+1] = G.P_CENTERS['e_negative']
        return {vars = {G.GAME.probabilities.normal, card.ability.extra}}
    end,
    loc_txt = {
        name = 'Wheel Of Pain',
        text = {'{C:green}#1# in #2#{} chance to add',
                '{C:dark_edition}Negative to a random {C:attention}Joker{}'}
    },
    set = 'Gamer',
    pos = {x=0,y=2},
    cost = 0,
    atlas = 'gamer-cards',
    can_use = function(self,card)
        for j=1, #G.jokers.cards do
            if not G.jokers.cards[j].edition then
                return true
            end
        end
        return false
    end,
    use = function(self,card,area,copier)
        if pseudorandom('wheel2') < G.GAME.probabilities.normal / card.ability.extra then
            local peepee = {}
            for j=1, #G.jokers.cards do
                if not G.jokers.cards[j].edition then
                    peepee[#peepee + 1] = G.jokers.cards[j]
                end
            end
            local chosen_joker = pseudorandom_element(peepee,pseudoseed('wheel2'))
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4, func = function() 
                    chosen_joker:set_edition({negative = true},true)
                    card:juice_up(0.3, 0.5)
                    return true
            end}))
        else
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = 'Nuh uh!',
                    scale = 1.3, 
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.SECONDARY_SET.Tarot,
                    align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                    offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                    silent = true
                    })
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
            return true end }))
        end
        delay(0.6) 
    end
}

local factory = {
    key = 'factorytemplate',
    name = 'Factory Template',
    loc_vars = function(self,info_queue,card)
        info_queue = {}
        local fool_c = G.GAME.last_gamer and G.P_CENTERS[G.GAME.last_gamer] or nil
        local last_tarot_planet = fool_c and localize{type = 'name_text', key = fool_c.key, set = fool_c.set} or localize('k_none')
        local colour = (not fool_c or fool_c.key == 'c_deliriumcoolmod_factorytemplate') and G.C.RED or G.C.GREEN
        if not (not fool_c or fool_c.key == 'Factory Template') then
            info_queue[#info_queue+1] = fool_c
        end

        return {
            main_end = {
                {n=G.UIT.C, config={align = "bm", padding = 0.02}, nodes={
                    {n=G.UIT.C, config={align = "m", colour = colour, r = 0.05, padding = 0.05}, nodes={
                        {n=G.UIT.T, config={text = ' '..last_tarot_planet..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
                    }}
                }}
            },
           loc_vars = {last_tarot_planet}
        }
    end,
    loc_txt = {
        name = 'Factory Template',
        text = {'Creates the last',
                '{C:Gamer}Gamer{} card used',
                'during this run',
                '{s:0.8,C:Gamer}Factory Template{s:0.8} excluded'}
    },
    set = 'Gamer',
    pos = {x=0,y=0},
    cost = 5,
    atlas = 'gamer-cards',
    can_use = function(self,card)
        return G.GAME.last_gamer and G.GAME.last_gamer ~= 'c_deliriumcoolmod_factorytemplate'
    end,
    use = function(self,card,area,copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            if G.consumeables.config.card_limit > #G.consumeables.cards then
                play_sound('timpani')
                local _card = SMODS.create_card({key = G.GAME.last_gamer})
                _card:add_to_deck()
                G.consumeables:emplace(_card)
                card:juice_up(0.3, 0.5)
            end
            return true end }))
        delay(0.6)
    end
}

local printingerror = {
    key = 'printingerror',
    config = {extra = 5},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra}}
    end,
    loc_txt = {
        name = 'Printing Error',
        text = {'Create {C:attention}#1# random',
                '{C:Gamer}Gamer{} Cards and use',
                'them immediately'}
    },
    set = 'Gamer',
    pos = {x=0,y=3},
    cost = 1,
    atlas = 'gamer-cards',
    can_use = function(self,card)
        return not card.ability.fromPrintingError
    end,
    use = function(self,card,area,copier)
        for i=1, card.ability.extra do
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                local bannedKeys = {'printingerror','intrusivethought','amputation'}
                local _card = SMODS.create_card({set = 'Gamer'})
                _card.ability.fromPrintingError = true

                card:juice_up(0.3, 0.5)
                if _card:can_use_consumeable(true,true) then
                    draw_card(G.hand, G.play, 1, 'up', true, _card, nil, mute)
                    _card:use_consumeable()
                else
                    draw_card(G.hand, G.play, 1, 'up', true, _card, nil, mute)
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        attention_text({
                            text = "Can't use!",
                            scale = 1.3, 
                            hold = 1.4,
                            major = _card,
                            backdrop_colour = G.C.SECONDARY_SET.Tarot,
                            align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                            offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                            silent = true
                            })
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                                play_sound('tarot2', 0.76, 0.4);return true end}))
                            play_sound('tarot2', 1, 0.4)
                            _card:juice_up(0.3, 0.5)
                    return true end }))
                    delay(0.2)
                end
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    _card:start_dissolve(nil, nil) 
                return true end}))
            return true end }))
            delay(0.3)
        end
        delay(0.6)
    end 
}

local vintagecard = {
    key = 'vintagecard',
    loc_txt = {
        name = 'Vintage Card',
        text = {'Create a random {C:Gamer}Gamer card',
                'with {C:attention}double{} the {C:attention}Sell Value{}',
                '{C:inactive}(Must have room)'}

    },
    set = 'Gamer',
    pos = {x=1,y=3},
    cost = 10,
    atlas = 'gamer-cards',
    can_use = function(self,card)
        return #G.consumeables.cards < G.consumeables.config.card_limit
    end,
    use = function(self,card,area,copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            card:juice_up(0.3, 0.5)
            local gcard = SMODS.create_card({set = 'Gamer'})
            gcard.ability.extra_value = gcard.cost
            gcard:set_cost()
            G.consumeables:emplace(gcard)
            return true 
        end}))
        delay(0.6)
    end
}


local stitchedCard = {
    key = 'stitchedCard',
    config = {extra = {posStat = 'h_size', negStat = ''}},
    loc_vars = function(self,info_queue,card)
        local m_start = {}
        local m_end = {}
        local Cpos = card.ability.extra.posStat
        local Cneg = card.ability.extra.negStat

        if Cpos == 'h_size' then
            table.insert(m_start,{n=G.UIT.O, config={object = DynaText({string = '+5 ', colours = {G.C.FILTER}, silent = true, scale = 0.32})}})
            table.insert(m_start,{n=G.UIT.O, config={object = DynaText({string = 'Hand Size', colours = {G.C.L_BLACK}, silent = true, scale = 0.32})}})
        elseif Cpos == 'money_25' then
            table.insert(m_start,{n=G.UIT.O, config={object = DynaText({string = 'Earn', colours = {G.C.L_BLACK}, silent = true, scale = 0.32})}})
            table.insert(m_start,{n=G.UIT.O, config={object = DynaText({string = ' $25', colours = {G.C.MONEY}, silent = true, scale = 0.32})}})       
        elseif Cpos == 'money_15' then
            table.insert(m_start,{n=G.UIT.O, config={object = DynaText({string = 'Earn', colours = {G.C.L_BLACK}, silent = true, scale = 0.32})}})
            table.insert(m_start,{n=G.UIT.O, config={object = DynaText({string = ' $15', colours = {G.C.MONEY}, silent = true, scale = 0.32})}})                    
        elseif Cpos == 'money_30' then
            table.insert(m_start,{n=G.UIT.O, config={object = DynaText({string = 'Earn', colours = {G.C.L_BLACK}, silent = true, scale = 0.32})}})
            table.insert(m_start,{n=G.UIT.O, config={object = DynaText({string = ' $30', colours = {G.C.MONEY}, silent = true, scale = 0.32})}})
        elseif Cpos == 'rand_size' then
            table.insert(m_start,{n=G.UIT.R,config = {align = "tm"}, nodes = {
                {n=G.UIT.T, config={text = "+1", colour = G.C.DARK_EDITION, scale = 0.32}},
                {n=G.UIT.T, config={text = " Hand Size, Joker slot,", colour = G.C.L_BLACK, scale = 0.32}}
            }})
            table.insert(m_start,{n=G.UIT.R,config = {align = "tm"}, nodes = {
                {n=G.UIT.T, config={text = "or Consumable Slot", colour = G.C.L_BLACK, scale = 0.32}}
            }})
        elseif Cpos == 'draw2' then
            table.insert(m_start,{n=G.UIT.R,config = {align = "tm"}, nodes = {
                {n=G.UIT.T, config={text = "Creates up to ", colour = G.C.L_BLACK, scale = 0.32}},
                {n=G.UIT.T, config={text = "2", colour = G.C.FILTER, scale = 0.32}}
            }})
            table.insert(m_start,{n=G.UIT.R,config = {align = "tm"}, nodes = {
                {n=G.UIT.T, config={text = "random ", colour = G.C.L_BLACK, scale = 0.32}},
                {n=G.UIT.T, config={text = "Gamer", colour = HEX('FD8F57'), scale = 0.32}},
                {n=G.UIT.T, config={text = " cards", colour = G.C.L_BLACK, scale = 0.32}}
            }})
        end    


        if Cneg == 'cPerHand' then
            table.insert(m_end,{n=G.UIT.R,config = {align = "tm"}, nodes = {
                {n=G.UIT.T, config={text = "-1", colour = G.C.BLUE, scale = 0.32}},
                {n=G.UIT.T, config={text = " Cards per hand", colour = G.C.L_BLACK, scale = 0.32}}
            }})         
        elseif Cneg == 'cPerDiscard' then
            table.insert(m_end,{n=G.UIT.R,config = {align = "tm"}, nodes = {
                {n=G.UIT.T, config={text = "-1", colour = G.C.RED, scale = 0.32}},
                {n=G.UIT.T, config={text = " Cards per discard", colour = G.C.L_BLACK, scale = 0.32}}
            }})   
        elseif Cneg == 'perish' then
            table.insert(m_end,{n=G.UIT.R,config = {align = "tm"}, nodes = {
                {n=G.UIT.T, config={text = "Make every owned joker ", colour = G.C.L_BLACK, scale = 0.32}},
                {n=G.UIT.T, config={text = "Perishable", colour = G.C.FILTER, scale = 0.32}}
            }})
        elseif Cneg == 'rental' then
            table.insert(m_end,{n=G.UIT.R,config = {align = "tm"}, nodes = {
                {n=G.UIT.T, config={text = "Give a random joker a ", colour = G.C.L_BLACK, scale = 0.32}},
                {n=G.UIT.T, config={text = "Rental", colour = G.C.FILTER, scale = 0.32}},
                {n=G.UIT.T, config={text = " sticker", colour = G.C.L_BLACK, scale = 0.32}},
            }})          
        elseif Cneg == 'ante' then
            table.insert(m_end,{n=G.UIT.R,config = {align = "tm"}, nodes = {
                {n=G.UIT.T, config={text = "+1", colour = G.C.FILTER, scale = 0.32}},
                {n=G.UIT.T, config={text = " Ante", colour = G.C.L_BLACK, scale = 0.32}}
            }}) 
        elseif Cneg == 'rand_size' then
            table.insert(m_end,{n=G.UIT.R,config = {align = "tm"}, nodes = {
                {n=G.UIT.T, config={text = "-1", colour = G.C.DARK_EDITION, scale = 0.32}},
                {n=G.UIT.T, config={text = " Hand Size, Joker slot,", colour = G.C.L_BLACK, scale = 0.32}}
            }})
            table.insert(m_end,{n=G.UIT.R,config = {align = "tm"}, nodes = {
                {n=G.UIT.T, config={text = "or Consumable Slot", colour = G.C.L_BLACK, scale = 0.32}}
            }})
        end

        return {
            main_start = m_start,
            main_end = m_end
        }
    end,
    loc_txt = {
        name = 'Stitched Card',
        text = {'','',''}
    },
    set = 'Gamer',
    pos = {x=4,y=3},
    cost = 2,
    atlas = 'gamer-cards',
    set_ability = function(self,card,initial,delay_sprites)
        local posEffects = {'h_size','money_25','money_15','money_30','rand_size','draw2'}
        local negEffects = {'cPerHand','cPerDiscard','perish','rental','ante','rand_size'}

        card.ability.extra.posStat = pseudorandom_element(posEffects,pseudoseed('stitched'))
        card.ability.extra.negStat = pseudorandom_element(negEffects,pseudoseed('stitched'))

    end,
    can_use = function(self,card)
        local requirements = {}

        if card.ability.extra.posStat == 'draw2' then
            requirements[#requirements + 1] = #G.consumeables.cards < G.consumeables.config.card_limit
        end
        
        if card.ability.extra.negStat == 'cPerHand' then
            requirements[#requirements + 1] = G.GAME.starting_params.cards_per_hand > 1 
        end

        if card.ability.extra.negStat == 'cPerDiscard' then
            requirements[#requirements + 1] = G.GAME.starting_params.cards_per_discard > 1 
        end

        if card.ability.extra.negStat == 'rand_size' then
            requirements[#requirements + 1] = G.jokers.config.card_limit >= 1 or G.consumeables.config.card_limit >= 1 or G.hand.config.card_limit >= 1
        end

        if card.ability.extra.negStat == 'perish' then
            if #G.jokers.cards < 1 then return false end
            for j=1, #G.jokers.cards do
                if not G.jokers.cards[j].ability.eternal and not G.jokers.cards[j].ability.perishable then
                    return true
                elseif j == #G.jokers.cards then
                    return false
                end
            end
        end

        if card.ability.extra.negStat == 'ante' then
            requirements[#requirements + 1] = G.GAME.round_resets.ante ~= G.GAME.win_ante
        end

        if card.ability.extra.negStat == 'rental' then
            if #G.jokers.cards < 1 then return false end
            for j=1, #G.jokers.cards do 
                if not G.jokers.cards[j].ability.rental then
                    return true
                elseif j == #G.jokers.cards then
                    return false
                end
            end
        end

        for i=1, #requirements do
            if not requirements[i] then
                return false
            end
        end
        return true
    end,
    use = function(self,card,area,copier)
        local posEffect = card.ability.extra.posStat
        local negEffect = card.ability.extra.negStat

        if posEffect == 'h_size' then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                G.hand:change_size(5)
                card:juice_up(0.3, 0.5)
                play_sound('tarot1')
                return true
            end}))
        elseif posEffect == 'money_25' then
            G.E_MANAGER:add_event(Event({
                delay = 0.5, func = function() 
                    card:juice_up(0.3, 0.5)
                    ease_dollars(25)
                    return true
                end
            }))
        elseif posEffect == 'money_15' then
            G.E_MANAGER:add_event(Event({
                delay = 0.5, func = function() 
                    card:juice_up(0.3, 0.5)
                    ease_dollars(15)
                    return true
                end
            }))
        elseif posEffect == 'money_30' then
            G.E_MANAGER:add_event(Event({
                delay = 0.5, func = function() 
                    card:juice_up(0.3, 0.5)
                    ease_dollars(30)
                    return true
                end
            }))
        elseif posEffect == 'draw2' then
            for i=1, math.min(G.consumeables.config.card_limit - #G.consumeables.cards, 2) do
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    play_sound('timpani')
                    card:juice_up(0.3, 0.5)
                    local gcard = SMODS.create_card({set = 'Gamer'})
                    G.consumeables:emplace(gcard)
                    return true 
                end}))
            end
        elseif posEffect == 'rand_size' then
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
        end

        delay(0.2)


        if negEffect == 'cPerHand' then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                change_hand_select_size(-1,0)
                card:juice_up(0.3, 0.5)
                play_sound('slice1')
                return true
            end}))
        elseif negEffect == 'cPerDiscard' then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                change_hand_select_size(0,-1)
                card:juice_up(0.3, 0.5)
                play_sound('slice1')
                return true
            end}))
        elseif negEffect == 'ante' then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                ease_ante(1)
                card:juice_up(0.3, 0.5)
                return true
            end}))
        elseif negEffect == 'rand_size' then
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

    
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                if plusStat == 'Hand Size' then
                    G.hand:change_size(-1)
                elseif plusStat == 'Joker Slot' then 
                    G.jokers.config.card_limit = G.jokers.config.card_limit - 1
                elseif plusStat == 'Consumable Slot' then
                    G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
                end
                card:juice_up(0.3, 0.5)
                play_sound('tarot1')
                return true
            end}))
        elseif negEffect == 'rental' then
            validJokers = {}
            for j=1, #G.jokers.cards do
                if not G.jokers.cards[j].ability.rental then
                    table.insert(validJokers,G.jokers.cards[j])
                end
            end
            chosenJoker = pseudorandom_element(validJokers,pseudoseed('Pyramid'))
            G.E_MANAGER:add_event(Event({
                delay = 0.5, func = function() 
                    chosenJoker:set_rental(true)
                    chosenJoker:juice_up(0.5,0.5)
                    play_sound('tarot2', 1, 0.4)
                    return true
                end
            }))
        elseif negEffect == 'perish' then
            local pitch = 1
            for j=1, #G.jokers.cards do
                if not G.jokers.cards[j].ability.eternal and not G.jokers.cards[j].ability.perishable then
                    G.E_MANAGER:add_event(Event({
                        delay = 0.5, func = function() 
                            G.jokers.cards[j]:set_perishable(true)
                            G.jokers.cards[j]:juice_up(0.5,0.5)
                            play_sound('tarot2', pitch, 0.4)
                            pitch = pitch + 0.1
                            return true
                        end
                    }))
                end
            end
        end
        delay(0.6)
    end
                       
}



return {
    list = {wheel,factory,printingerror,stitchedCard,vintagecard}
}