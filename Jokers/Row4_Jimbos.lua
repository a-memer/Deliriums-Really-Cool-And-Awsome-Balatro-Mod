local quarterjoker = {
    key = 'quaterjoker',
    name = 'quarterjoker',
    config = {extra = {mult = 40, size = 2}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.size } }
    end, 
    loc_txt = {
        name = 'Quarter Joker',
        text = {
            "{C:red}+#1#{} Mult if played",
            "hand contains",
            "{C:attention}#2#{} or fewer cards"
        }
    },
    atlas = 'mod-jokers',
    rarity = 2,
    pos = {x = 4, y = 3},
    blueprint_compat = true,
    set_sprites = function(self, card, front)
        card.children.center.scale.y = card.children.center.scale.y/1.7
        card.T.h = card.T.h/1.7
    end,
    calculate = function(self,card,context)
        if context.joker_main and #context.full_hand <= card.ability.extra.size then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult
            }
        end
    end
}

local msJoker = {
    key = 'msJoker',
    name = 'MS Joker',
    config = {extra = {x_mult = 0.75, hand_size = 5}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.hand_size, card.ability.extra.x_mult}}
    end,
    loc_txt = {
        name = 'MS Joker',
        text = {'{C:attention}+#1#{} hand size,',
                '{C:white,X:mult}X#2#{} Mult'}
    },
    rarity = 1,
    cost = 3,
    atlas = 'mod-jokers',
    pos = {x=3,y=5},
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.store_joker_create and (pseudorandom('msJoker') < 1/10) then
            _card = SMODS.create_card({set = 'Joker', area = context.area, key = 'j_deliriumcoolmod_msJoker'})
            create_shop_card_ui(_card, 'Joker', context.area)
            return _card
        end


        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.x_mult,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult} },
                card = card
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.hand_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local dupeAmount = 0
        if G.jokers ~= nil then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == 'MS Joker' then
                    dupeAmount = dupeAmount + 1
                end
            end
        end
        card.ability.extra.x_mult = card.ability.extra.x_mult - (0.05 * dupeAmount)
        card.ability.extra.hand_size = card.ability.extra.hand_size + dupeAmount
    end
}

local expose = {
    key = 'expose',
    name = 'expose',
    config = {extra = {xmult = 4}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,
    loc_txt = {
        name = 'Exposé',
        text = {'{X:mult,C:white}X#1#{} Mult',
                'A random {C:attention}Joker{} is {C:red}Disabled{} on',
                'the start of every {C:attention}Blind{}.'}
    },
    atlas = 'mod-jokers',
    pos = {x=2,y=4},
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.setting_blind then
            local jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card then
                    jokers[#jokers+1] = G.jokers.cards[i]
                end
                G.jokers.cards[i]:set_debuff(false)
            end
            if #jokers > 0 then
                local _card = pseudorandom_element(jokers, pseudoseed('expose'))
                if _card then
                    _card:set_debuff(true)
                    _card:juice_up()
                end
            end
        end

        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.xmult,
                message = localize {type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}}
            }
        end
    end
}

local beastyJoker = {
    key = 'beastlyJoker',
    name = 'beastlyJoker',
    config = {extra = {hand = 1, gainedHands = 0, handsLeft = 3}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hand, card.ability.extra.gainedHands, card.ability.extra.handsLeft} }
    end, 
    loc_txt = {
        name = 'Beastly Joker',
        text = {"gain {C:blue}+#1#{} hand for every",
                "{C:attention}3{} cards {C:attention}destroyed{}.",
                '{C:inactive}(Currently {C:blue}+#2#{} {C:inactive}Hands){}',
                "{C:inactive} #3# cards left."}
    },
    rarity = 3,
    cost = 7,
    atlas = 'mod-jokers',
    pos = {x = 0, y = 4},
    blueprint_compat = false,
    calculate = function(self,card,context)
        if context.remove_playing_cards and not context.blueprint then
            for k, val in ipairs(context.removed) do
                card.ability.extra.handsLeft = card.ability.extra.handsLeft - 1
                if card.ability.extra.handsLeft == 0 then
                    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hand
                    card.ability.extra.gainedHands = card.ability.extra.gainedHands + 1
                    card.ability.extra.handsLeft = 3
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Sacrafices Made!"})
                end
            end
        end
    end
}

local clearance = {
    key = 'clearance',
    name = 'clearance',
    config = {extra = 4},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra}}
    end,
    loc_txt = {
        name = 'Clearance Joker',
        text = {'Your first played {C:attention}Ace{} is',
                'retriggered {C:attention}#1#{} times.'}
    },
    rarity = 1,
    atlas = 'mod-jokers',
    pos = {x = 6, y = 3},
    blueprint_compat= true,
    calculate = function(self,card,context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            firstace = nil
            for i=1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 14 then
                    firstace = context.scoring_hand[i]
                    break
                end
            end

            if context.other_card == firstace then
                return {
                    message = 'Again!',
                    repetitions = card.ability.extra,
                    card = card
                }
            end
        end
    end
}

return {
    list = {quarterjoker,msJoker,expose,beastyJoker,clearance}
}