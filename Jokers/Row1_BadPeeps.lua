
local dumbo = {
    key = 'dumbo',
    name = 'Dumbo',
    config = {extra = {chips = 3, gainedchips = 0}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.gainedchips } }
    end,   
    loc_txt = {
        name = 'Dumbo',
        text = {'Whenever a {C:attention}Non-King{} card scores,',
                '{C:attention}destroy{} it and give this {C:chips}+#1#{} chips.',
                '{C:inactive}(Currently {C:chips}+#2# {C:inactive}chips)'}
    },
    rarity = 3,
    pos = {x = 1, y = 1},
    cost = 7,
    atlas = 'mod-jokers',
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.individual and context.other_card:get_id() ~= 13 and context.cardarea == G.play and not context.blueprint then
                card.ability.extra.gainedchips = card.ability.extra.gainedchips + card.ability.extra.chips           
                return {
                    extra = {focus = card, message = localize('k_upgrade_ex')},
                    card = card,
                    colour = G.C.CHIPS
                }
        end
        if context.destroying_card and context.destroying_card:get_id() ~= 13 and not context.blueprint  then
            return true
        end
        if context.joker_main then
            return {
                chip_mod = card.ability.extra.gainedchips,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.gainedchips } }
            }
        end
    end
}

local frank = {
    key = 'frank',
    name = 'Frank',
    config = {extra = {money = 3}},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.money}}
    end,
    loc_txt = {
        name = 'Frank',
        text = {'Whenever a {C:attention}Number Card{} scores,',
                '{C:attention}destroy{} it and earn {C:money}$#1#{}',}
    },
    rarity = 3,
    pos = {x = 2, y = 1},
    cost = 10,
    atlas = 'mod-jokers',
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.individual and (context.other_card:get_id() ~= 14 and context.other_card:is_face() ~= true) and context.cardarea == G.play then
            return {
                dollars = card.ability.extra.money,
                card = card
            }
        end
        if context.destroying_card and (context.destroying_card:get_id() ~= 14 and context.destroying_card:is_face() ~= true) and not context.blueprint  then
            return true
        end
    end
}


local trumbo = {
    key = 'trumbo',
    name = 'trumbo',
    config = {extra = {mult = 2, mult_gain = 0}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
    end,       
    loc_txt = {
        name = 'Trumbo',
        text = {'Whenever a {C:attention}Non-Ace{} card scores,',
                '{C:attention}destroy{} it and gain {C:mult}+#1#{} Mult.',
                '{C:inactive}(Currently {C:mult}+#2# {C:inactive}Mult)'}},
    rarity = 3,
    cost = 9,
    blueprint_compat= true,
    pos = {x=3,y=1},
    atlas = 'mod-jokers',
    calculate = function(self,card,context)
        if context.individual and context.other_card:get_id() ~= 14 and context.cardarea == G.play and not context.blueprint then
                card.ability.extra.mult_gain = card.ability.extra.mult_gain + card.ability.extra.mult           
                return {
                    extra = {focus = card, message = localize('k_upgrade_ex')},
                    card = card,
                    colour = G.C.MULT
                }
        end
        if context.destroying_card and context.destroying_card:get_id() ~= 14 and not context.blueprint then
            return true
        end
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult_gain,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_gain } }
            }
        end
    end
}



local cube = {
    key = 'cube',
    name = 'cube',
    config = {extra = {cards_left = 5}},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.cards_left}}
    end,
    loc_txt = {
        name = 'Cube',
        text = {'The {C:attention}First played hand{} each round is {C:attention}destroyed{},',
                'Every {C:attention}5{} cards destroyed by cube',
                'create a {C:spectral}Spectral{} card.',
                '{C:inactive}(Must have room)',
                '{C:inactive}({}#1# {C:inactive}cards left)'}
    },
    cost = 10,
    blueprint_compat= true,
    rarity = 3,
    pos = {x=4,y=1},
    soul_pos = {x=5,y=1},
    atlas = 'mod-jokers',
    blueprint_compat = false,
    calculate = function(self,card,context)
        local eval = function() return G.GAME.current_round.hands_played == 0 end
        juice_card_until(card, eval, true)

        if context.destroying_card and not context.blueprint and G.GAME.current_round.hands_played == 0 and not context.blueprint then
            card.ability.extra.cards_left = card.ability.extra.cards_left - 1
            if card.ability.extra.cards_left == 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                            local scard = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'cube')
                            scard:add_to_deck()
                            G.consumeables:emplace(scard)
                            G.GAME.consumeable_buffer = 0
                        return true
                    end)}))
                card.ability.extra.cards_left = 5
            end
            return true
        end
    end
}



local alvin = {
    key = 'alvin',
    name = 'alvin',
    config = {extra = {x_mult = 0.16, gained_x_mult = 1}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.gained_x_mult } }
    end,   
    loc_txt = {
        name = 'Anti-Alias Alvin',
        text = {'Whenever a {C:attention}Non-Number card{} scores,',
                '{C:attention}destroy{} it and give this {X:mult,C:white}X#1#{} mult.',
                '{C:inactive}(Currently {X:mult,C:white}X#2# {C:inactive} Mult)'}
    },
    rarity = 3,
    pos = {x = 0, y = 2},
    cost = 6,
    atlas = 'mod-jokers',
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.individual and (context.other_card:get_id() == 14 or context.other_card:is_face()) and context.cardarea == G.play and not context.blueprint then
                card.ability.extra.gained_x_mult = card.ability.extra.gained_x_mult + card.ability.extra.x_mult           
                return {
                    extra = {focus = card, message = localize('k_upgrade_ex')},
                    card = card,
                    colour = G.C.XMULT
                }
        end
        if context.destroying_card and (context.destroying_card:get_id() == 14 or context.destroying_card:is_face()) and not context.blueprint then
            return true
        end
        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.gained_x_mult,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.gained_x_mult } }
            }
        end
    end
}
return {
    list = {dumbo,frank,trumbo,cube,alvin}
}