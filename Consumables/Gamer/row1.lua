local intrusive = {
    key = 'intrusivethought',
    config = {extra =  {odds = 15, money = 100}},
    loc_vars = function(self,info_queue,card)
        return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds}}
    end,
    loc_txt = {
        name = 'Intrusive Thought',
        text = {'{C:green}#1# in #2#{} chance to gain {C:money}$100{}',
                'otherwise, {C:attention}die.{}'}
    },
    set = 'Gamer',
    pos = {x=1,y=0},
    cost = 1,
    atlas = 'gamer-cards',
    use = function(self, card, area, copier)
        if pseudorandom('intrusive') < G.GAME.probabilities.normal / card.ability.extra.odds then
            ease_dollars(card.ability.extra.money)
        else
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = localize('k_nope_ex'),
                    scale = 1.3, 
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.SECONDARY_SET.Tarot,
                    align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                    offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                    silent = true
                    })
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        delay(3);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
            return true end }))
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 5, func = function()
                delay(0.5)
                G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false
                return true end
            }))
        end
    end,
    can_use = function(self,card)
        return not card.ability.fromPrintingError
    end
}

local amputation = {
    key = 'amputation',
    config = {extra = {h_size = 5, select_penalty = -1}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.h_size,card.ability.extra.select_penalty}}
    end,
    loc_txt = {
        name = 'Amputation',
        text = {'{C:attention}+#1#{} Hand Size',
                '{C:blue}#2#{} Cards per hand',
                '{C:red}#2#{} Cards per discard'}
    },
    set = 'Gamer',
    cost = 1,
    pos = {x=3,y=2},
    atlas = 'gamer-cards',
    can_use = function(self,card)
        if not card.ability.fromPrintingError then
            return G.GAME.starting_params.cards_per_discard > 1 and  G.GAME.starting_params.cards_per_hand > 1
        else
            return false
        end
    end,
    use = function(self,card,area,copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            attention_text({
                text = 'Amputated!',
                scale = 1.3, 
                hold = 1.4,
                major = card,
                backdrop_colour = G.C.SECONDARY_SET.Tarot,
                align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                silent = true
                })
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4)
                    delay(3);return true end}))
                play_sound('slice1', 1, 0.4)
                change_hand_select_size(card.ability.extra.select_penalty,card.ability.extra.select_penalty)
                G.hand:change_size(card.ability.extra.h_size)
                card:juice_up(0.3, 0.5)
        return true end }))
    end
}

local pyramid = {
    key = 'pyamidscheme',
    config = {extra = 10},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra}}
    end,    
    loc_txt = {
        name = 'Pyramid Scheme',
        text = {'Give a random joker a {C:attention}Rental{} sticker',
                'then earn {C:money}$#1#{}'}
    },
    set = 'Gamer',
    pos = {x=3,y=1},
    cost = 1,
    atlas = 'gamer-cards',
    can_use = function(self,card)
        for j=1, #G.jokers.cards do 
            if not G.jokers.cards[j].ability.rental then
                return true
            end
        end
    end,
    use = function(self,card,area,copier)
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
        G.E_MANAGER:add_event(Event({
            delay = 0.5, func = function() 
                ease_dollars(card.ability.extra)
                return true
            end
        }))
        delay(0.5)
    end
}

local speedrun = {
    key = 'speedrun',
    config = {extra = 30},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra}}
    end,
    loc_txt = {
        name = 'Speedrun',
        text = {'Make every owned joker {C:attention}Perishable{}',
                'and earn {C:money}$#1#{}'}
    },
    set = 'Gamer',
    pos = {x=4,y=1},
    cost = 1,
    atlas = 'gamer-cards',
    can_use = function(self,card)
        for j=1, #G.jokers.cards do
            if not G.jokers.cards[j].ability.eternal and not G.jokers.cards[j].ability.perishable then
                return true
            end
        end
        return false
    end,
    use = function(self,card,area,copier)
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
        G.E_MANAGER:add_event(Event({
            delay = 0.5, func = function() 
                ease_dollars(card.ability.extra)
                return true
            end
        }))
        delay(0.5)
    end
}


local pinkSlip = {
    key = 'pinkSlip',
    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative 
    end,
    loc_txt = {
        name = 'Pink Slip',
        text = {'Permanently {C:attention}Debuff{} a random',
                'joker then make it {C:dark_edition}Negative'}
    },
    set = 'Gamer',
    pos = {x=3,y=3},
    atlas = 'gamer-cards',
    cost = 1,
    can_use = function(self,card)
        for j=1, #G.jokers.cards do
            if not G.jokers.cards[j].ability.eternal and G.jokers.cards[j].edition == nil then
                return true
            end
        end
        return false
    end,
    use = function(self,card,area,copier)
        local canChoose = {}
        for j=1, #G.jokers.cards do
            if not G.jokers.cards[j].ability.eternal and G.jokers.cards[j].edition == nil then
                table.insert(canChoose,G.jokers.cards[j])
            end
        end
        local chosenJoker = pseudorandom_element(canChoose,pseudoseed('pinkSlip'))
        G.E_MANAGER:add_event(Event({
            delay = 0.5, func = function()
                chosenJoker:set_edition({negative = true},false,true)
                play_sound('negative', 1.5, 0.4)
                chosenJoker:juice_up(0.5,0.5)
                card:juice_up(0.5,0.5)
                return true
        end}))
        G.E_MANAGER:add_event(Event({
            delay = 0.5, func = function()
                chosenJoker:set_perishable(true)
                return true
        end}))
        G.E_MANAGER:add_event(Event({
            delay = 0, func = function()
                chosenJoker.ability.perish_tally = 1
                chosenJoker:calculate_perishable()
                return true
        end}))
        delay(0.6)
    end
}


return {
    name = 'Row 1',
    list = {intrusive,amputation,pyramid,pinkSlip,speedrun}
}