local timothy = {
    key = 'timothy',
    name = 'timothy_TBD',
    loc_txt = {
        name = 'Timothy',
        text = {'{C:attention}Joker{} cards sold the shop',
        'are replaced with',
        '{C:spectral}Spectral{} cards.'}
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    atlas = 'mod-jokers',
    pos = {x=1,y=4},
    calculate = function(self,card,context)
        if context.store_joker_modify and context.shop_card.ability.set == 'Joker' then
            context.shop_card.ability.consumeable = true
            return true
        end
    end
}

local Violet = {
    key = 'Violet',
    name = 'Violet_TBD',
    loc_txt = {
        name = 'Violet',
        text = {'All {C:spectral}Spectral{} cards and',
                '{C:spectral}Spectral Packs{} in',
                'the shop are {C:attention}free'}
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    atlas = 'mod-jokers',
    pos = {x=6,y=4},
    add_to_deck = function(self,card,from_debuff)
        G.E_MANAGER:add_event(Event({func = function()
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
        return true end }))
    end,
    remove_from_deck = function(self,card,from_debuff)
        G.E_MANAGER:add_event(Event({func = function()
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
        return true end }))
    end
}



-- JOHNNY WIZARD
local johnny = {
    key = 'johnnywizard',
    name = 'johnnywizard',
    config = {extra = {gained_mult = 0}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.gained_mult}}
    end,
    loc_txt = {
        name = 'Johnny Wizard',
        text = {'Decrease the rank of all cards played ',
                'on {C:attention}First Hand{} by {C:attention}1{} and add '  ,
                'half of their {C:chips}Chip Value{} as {C:mult}Mult{},',
                '{C:inactive}(Currently {C:mult}+#1#{} {C:inactive}Mult)'}
    },
    cost = 10,
    blueprint_compat = true,
    rarity = 3,
    atlas = 'mod-jokers',
    pos = {x = 1, y = 3},
    calculate = function(self,card,context)
        if context.first_hand_drawn and not context.blueprint and context.cardarea == G.jokers then
            local eval = function() return G.GAME.current_round.hands_played == 0 end
            juice_card_until(card, eval, true)
        end

        if context.before and context.cardarea == G.jokers and G.GAME.current_round.hands_played == 0 then
            local pitch = 0.7
            local easeD = 0.1
            for c=1, #context.full_hand do
                local _card = context.full_hand[c]
                G.E_MANAGER:add_event(Event{
                    trigger = after, delay = 1, func = function()
                        card.ability.extra.gained_mult = card.ability.extra.gained_mult + (_card:get_chip_bonus() / 2)
                        _card:juice_up(0.3, 0.5)
                        local suit_prefix = string.sub(_card.base.suit, 1, 1)..'_'
                        local rank_suffix = _card.base.id == 2 and 14 or math.min(_card.base.id-1, 14)
                        if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                        elseif rank_suffix == 10 then rank_suffix = 'T'
                        elseif rank_suffix == 11 then rank_suffix = 'J'
                        elseif rank_suffix == 12 then rank_suffix = 'Q'
                        elseif rank_suffix == 13 then rank_suffix = 'K'
                        elseif rank_suffix == 14 then rank_suffix = 'A'
                        end
                        _card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                        play_sound('tarot1',pitch)
                        pitch = pitch + 0.1
                        return true
                end})
                if c == #context.full_hand then
                    delay(0.6)
                else
                    delay(easeD)
                    easeD = easeD * 1.5
                end
            end
        end

        if context.joker_main then
            return {
                mult_mod = card.ability.extra.gained_mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.gained_mult } }
            }
        end           

    end

}



-- BABY CAT
local babycat = {
    key = 'babycat',
    name = 'babycat',
    config = {extra = {x_dollars = 1.5, hands_left = 15}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_dollars, card.ability.extra.hands_left } }
    end, 
    loc_txt = {
        name = 'Baby Cat',
        text = {'{X:money,C:white}X#1#{} Dollars every',
                '{C:attention} 15{} Hands played.',
                '{C:inactive}#2# hands left'}
    },
    rarity = 2,
    atlas = 'mod-jokers',
    pos = {x = 0, y = 3},
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.after then
            card.ability.extra.hands_left = card.ability.extra.hands_left - 1
            if card.ability.extra.hands_left <= 0 then
                local MultMoney = (G.GAME.dollars * card.ability.extra.x_dollars) - G.GAME.dollars
                card.ability.extra.hands_left = 15
                ease_dollars(math.floor(MultMoney + 0.5))
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        play_sound('deliriumcoolmod_babycat',1,0.5)
                        return true 
                    end
                }))
                return {
                    card = card,
                    message = 'X' .. card.ability.extra.x_dollars .. " Dollars",
                    colour = G.C.MONEY
                }
            end
        end
    end
}

local mirrorguy = {
    key = 'mirrorguy',
    name = 'mirrorguy',
    config = {extra = {mult = 12, mult_gain = 0}},
    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_wheel_of_fortune 
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_gain}}
    end,
    loc_txt = {
        name = 'Mirror Guy',
        text = {'This joker gains {C:mult}+#1#{} Mult per each',
                '{C:attention}Wheel Of Fortune {C:green}Payout.{} {C:attention}Wheel Of Fortune{}',
                'is always available in {C:tarot}Arcana{} packs.',
                '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'}
    },
    cost = 6,
    rarity = 1,
    atlas = 'mod-jokers',
    pos = {x = 4, y = 6},
    calculate = function(self,card,context)
        if context.wheel_used and not context.blueprint then
            if context.successful then
                card.ability.extra.mult_gain = card.ability.extra.mult_gain + card.ability.extra.mult
                return {
                    message = 'Upgraded!',
                    card = card
                }
            end
        end

        if context.joker_main and card.ability.extra.mult_gain > 0 then
            return {
                mult = card.ability.extra.mult_gain,
                card = card
            }
        end
    end
}



return {
    list = {timothy,Violet,johnny,babycat,mirrorguy}
}