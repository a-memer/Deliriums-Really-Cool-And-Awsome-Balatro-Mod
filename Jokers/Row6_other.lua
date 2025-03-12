local happyhenry = {
    key = 'happyhenry',
    name = 'happyhenry',
    loc_txt = {
        name = ':Joker',
        text = {"When {C:attention}Blind{} is selected,",
                "Create a copy of this",
                'with a random {C:dark_edition}Edition{}',
                '{C:inactive}(Must have room)'}
    },
    rarity = 2,
    cost = 4,
    atlas = 'mod-jokers',
    rarity = 1,
    pos = {x = 4, y = 0},
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.setting_blind and context.cardarea == G.jokers and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then 
            G.GAME.joker_buffer = G.GAME.joker_buffer + 1

            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    local _card = copy_card(card, nil, nil, nil, card.edition)
                    _card:start_materialize()
                    _card:add_to_deck()
                    local edition = poll_edition('happyhenry', nil, false, true)
                    _card:set_edition(edition)
                    G.jokers:emplace(_card)
                    G.GAME.joker_buffer = 0
                return true
                end
            }))
        end
    end
}

local happyhenley = {
    key = 'happyhenley',
    name = 'happyhenley',
    config = {extra = 52},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
    loc_txt = {
        name = 'Another :Joker',
        text = {'If you have {C:attention}less than #1# cards{} in your deck',
                'at the start of the blind, add an ',
                '{C:attention}Enhanced{} {C:attention}King{} to your deck and draw it.'}
    },
    rarity = 2,
    cost = 6,
    atlas = 'mod-jokers',
    pos = {x=5,y=0},
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.setting_blind and (card.ability.extra - #G.playing_cards) > 0 then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local kings = {G.P_CARDS.H_K,G.P_CARDS.S_K,G.P_CARDS.C_K,G.P_CARDS.D_K}
                    local _card = create_playing_card({
                        front = pseudorandom_element(kings, pseudoseed('cert_fr')), 
                        center = G.P_CENTERS.c_base}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
                    _card:set_ability(pseudorandom_element({G.P_CENTERS.m_glass,G.P_CENTERS.m_lucky,G.P_CENTERS.m_steel,G.P_CENTERS.m_mult,G.P_CENTERS.m_bonus,G.P_CENTERS.m_wild,G.P_CENTERS.m_gold}, pseudoseed('cartridge')),nil,true)
                    _card:add_to_deck()
                    G.GAME.blind:debuff_card(_card)
                    G.hand:sort()
                    if context.blueprint_card then context.blueprint_card:juice_up() else card:juice_up() end
                    return true
                end
            }))
        end
    end
}

local codependence = {
    key = 'codependence',
    name = 'codependence',
    config = {extra = {mult = 10, chips = 50}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
    end,    
    loc_txt = {
        name = 'Codependence',
        text = {
            'Gives {C:chips}+#2#{} Chips or {C:mult}+#1#{} Mult',
            'Depending on whichever is {C:attention}lower{}'}
    },
    blueprint_compat = true,
    atlas = 'mod-jokers',
    pos = {x = 2,y = 5},
    cost = 4,
    rarity = 1,
    calculate = function(self,card,context)
        if context.joker_main then
            if hand_chips > mult then
                return {
                    mult_mod = card.ability.extra.mult, 
                    message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
                }
            else
                return {
                    chip_mod = card.ability.extra.chips, 
                    message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
                }
            end 
        end
    end
}

local gregory = {
    key = 'gregory',
    name = 'gregory',
    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue+1] = G.P_CENTERS['c_fool']
    end,
    loc_txt = {
        name = 'In Memoriam',
        text = {'Whenever a joker is {C:attention}sold{} or ',
                '{C:attention}destroyed{} create a {C:tarot}Fool{} card.',
                '{C:inactive}Must have room{}'}
    },
    rarity = 1,
    cost = 6,
    atlas = 'mod-jokers',
    pos = {x=5,y=4},
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.joker_destroyed and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                local _card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_fool', 'gregory')
                _card:add_to_deck()
                G.consumeables:emplace(_card)
                G.GAME.consumeable_buffer = 0
                return true
            end)}))
        end
    end
}

local badsquid = {
    key = 'badSquid',
    name = 'badSquid',
    config = {extra = {mult = 100, chips = 50}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.chips}}
    end,
    loc_txt = {
        name = 'Bad Squid',
        text = {'{C:mult}+#1#{} Mult and {C:chips}-#2#{} Chips',
                'If Played Hand is {C:attention}Level 1.'}
    },
    rarity = 1,
    atlas = 'mod-jokers',
    pos = {x=4,y=4},
    cost = 10,
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.joker_main and G.GAME.hands[context.scoring_name].level <= 1 then
            return {
                chips = -card.ability.extra.chips,
                mult = card.ability.extra.mult,
                card = card         
            }
        end
    end
}

return {
    name = 'Row 3',
    list = {happyhenry,happyhenley,codependence,gregory,badsquid}
}