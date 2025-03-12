local mario3joker = {
    key = "mario",
    name = 'Super Joker Bros 3',
    config = {extra = {mult = 3, multgain = 0}},
    loc_txt = {
            name = 'Super Jimbo Bros 3',
            text = {"This gains {C:mult}+#1#{} Mult",
                    "Whenever a played {C:attention}3{} scores.",
                    "Resets on end of {C:attention}boss blind{}.",
                    "{C:inactive}(Currently {C:mult}+#2#{} {C:inactive}Mult)"}
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.multgain } }
    end,    
    rarity = 1,
    cost = 3,
    pos = { x = 0, y = 0 },
    atlas = 'mod-jokers',
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.individual and context.other_card:get_id() == 3 and context.cardarea == G.play and not context.blueprint then
            card.ability.extra.multgain = card.ability.extra.multgain + card.ability.extra.mult
            return {
                message = 'Yahoo!',
                colour = G.C.MULT,
                card = card
            }
        end
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.multgain,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.multgain } }
            }
        end
        if context.end_of_round and G.GAME.blind.boss and not context.blueprint and context.cardarea == G.jokers then
            card.ability.extra.multgain = 0
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Mama Mia!"})

        end


    end
}

local evilmario3joker = {
    key = "evilmario",
    name = 'EVIL Super Joker Bros 3',
    config = {extra = {mult = 0.3, multgain = 1}},
    loc_txt = {
            name = 'Sketchy Game',
            text = {"Whenever a played {C:attention}3{} scores,",
                    "{C:attention}Destroy{} it and give this {X:mult,C:white}X#1#{} Mult",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{}{C:inactive} Mult)"}
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.multgain } }
    end,    
    rarity = 2,
    cost = 9,
    pos = { x = 1, y = 0 },
    atlas = 'mod-jokers',
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.individual and context.other_card:get_id() == 3 and context.cardarea == G.play and not context.blueprint then
            card.ability.extra.multgain = card.ability.extra.multgain + card.ability.extra.mult
            return {
                message = 'MAMA MIA!',
                colour = G.C.MULT,
                card = card
            }
        end
        
        if context.destroying_card and (context.destroying_card:get_id() == 3) and not context.blueprint then
            return true
        end


        if context.joker_main then
            return {
                x_mult = card.ability.extra.multgain,
                card = card
            }
        end

    end
}

local cartridge = {
    key = 'cartridge',
    name = 'dustyCartridge',
    config = {extra = {chaos = 0}},
    loc_txt = {
        name = 'Dusty Cartridge',
        text = {'{C:red}You might wanna blow',
                '{C:red}in this...'}
    },
    pos = {x = 2, y = 0},
    soul_pos = {x = 3, y = 0},
    cost = 2,
    atlas = 'mod-jokers',
    rarity = 3,
    blueprint_compat = true,
    calculate = function(self,card,context)
        local cchaos = card.ability.extra.chaos
        local messages = {'THE GASH WEAVES DOWN AS IF YOU CRY','I AM ERROR','AN EXCEPTION HAS OCCURED;','IT IS NOW SAFE TO TURN OFF YOUR COMPUTER','ALAN PLEASE ADD DETAILS','JIMBO HAS PASSED','TASK FAILED SUCESSFULLY','A WINNER IS YOU'}
        local cardNames = {'Spectral','Tarot','Tarot_Planet','Gamer'}
        local Cardslots = {G.jokers, G.hand,G.consumeables}
        local funnytest = pseudorandom_element(Cardslots, pseudoseed('cartridge'))

        -- This is after 30 hands!
        if cchaos > 7.5 then
            G.ROOM.jiggle = G.ROOM.jiggle + pseudorandom('cartridge_create',-1,1)
            G.ROOM.jiggle = G.ROOM.jiggle + pseudorandom('cartridge_create',-1,1)
            ease_background_colour{new_colour = GetRandomHexColor('cartridge_color')}
        end
        if context.individual then


            if context.other_card.base.id == nil then
                context.other_card.getting_sliced = true
            end


            if pseudorandom('cartridge_create') < cchaos/300 then
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local _card = copy_card(context.other_card, nil, nil, G.playing_card)
                _card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, _card)
                G.hand:emplace(_card)
                
                _card.states.visible = nil
                G.E_MANAGER:add_event(Event({
                    func = function()
                        _card:start_materialize()
                        return true
                    end
                })) 
            end

            if pseudorandom('cartridge') < cchaos/200 then
                local _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('cartridge'))
                local hcard = context.other_card
                G.E_MANAGER:add_event(Event({func = function()
                    local suit_prefix = _suit..'_'
                    if hcard.base.id == nil then hcard.base.id = 2 end
                    local rank_suffix = hcard.base.id < 10 and tostring(hcard.base.id) or
                    hcard.base.id == 10 and 'T' or hcard.base.id == 11 and 'J' or
                    hcard.base.id == 12 and 'Q' or hcard.base.id == 13 and 'K' or
                    hcard.base.id == 14 and 'A'
                    hcard:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                return true end }))          
            end



            if pseudorandom('cartridge') < cchaos/160 then             
                context.other_card:set_ability(pseudorandom_element({G.P_CENTERS.m_glass,G.P_CENTERS.m_lucky,G.P_CENTERS.m_stone,G.P_CENTERS.m_steel,G.P_CENTERS.m_mult,G.P_CENTERS.m_bonus,G.P_CENTERS.m_wild,G.P_CENTERS.m_gold}, pseudoseed('cartridge')),nil,true)
            end

            if pseudorandom('cartridge') < cchaos/170 then
                context.other_card:set_seal(pseudorandom_element({'Red','Blue','Gold','Purple'}))
            end

            if pseudorandom('cartridge') < cchaos/180 then
                local edition = poll_edition('cartridge', nil, false, true)
                context.other_card:set_edition(edition)
            end
        end
                
        if context.joker_main then
            local tempmult = 1
            local tempchips = 1
            local tempxmult = 1
            

            if pseudorandom('cartridge_joker') < cchaos/275 then
                local jokerb = create_card('Joker',G.jokers, nil, nil, nil, nil, nil, 'cartridge')
                jokerb:add_to_deck()
                funnytest:emplace(jokerb)
                jokerb:start_materialize() 
            end

            if pseudorandom('cartridge_joker') < cchaos/25 then
                local jokerb = create_card(pseudorandom_element(cardNames, pseudoseed('cartridge')),G.consumeables, nil, nil, nil, nil, nil, 'cartridge')
                jokerb:add_to_deck()
                funnytest:emplace(jokerb)              
                jokerb:start_materialize() 
            end

            if pseudorandom('cartridge_money') < cchaos/130 then
                ease_dollars(pseudorandom('cartridge', -100, 255))
            end

            if pseudorandom('cartridge_discard') < cchaos/150 then
                ease_discard(pseudorandom('cartridge',-2, 5))
            end

            if pseudorandom('cartridge_mult') < cchaos/100 then
                tempmult = pseudorandom('cartridge', -20, 25.5)
            end
            if pseudorandom('cartridge_chips') < cchaos/100 then
                tempchips = pseudorandom('cartridge', -50, 25.5)
            end
            if pseudorandom('cartridge_xmult') < cchaos/100 then
                tempxmult = pseudorandom('cartridge', -0.5, 2.55)
            end
            if (tempmult + tempchips + tempxmult) ~= 3 then
                return {
                    mult_mod = tempmult,
                    chip_mod = tempchips,
                    Xmult_mod = tempxmult, 
                    message = "+NULL"
                }
            end
        end

        if context.other_joker then
            if pseudorandom('cartridge') < cchaos/170 then
                local edition = poll_edition('cartridge', nil, false, true)
                context.other_joker:set_edition(edition)
            end
            if pseudorandom('cartridge') < cchaos/300 and context.other_joker ~= card then
                context.other_joker:start_dissolve({G.C.RED}, nil, 1.6)
            end            

            if pseudorandom('cartridge') < cchaos/300 and context.other_joker ~= card then
                local _card = copy_card(context.other_joker, nil, nil, nil, card.edition)
                _card:start_materialize()
                _card:add_to_deck()
                G.jokers:emplace(_card)            
            end    

            if pseudorandom('cartridge') < 1/240 and context.other_joker ~= card then
                corruptJoker(context.other_joker,cchaos,'cartridge')
                context.other_joker:juice_up(1, 1)
            end
  

 

        end 



        if context.destroying_card and pseudorandom('cartridge') < cchaos/50 then
            return {
                remove = true
            }
        end

        if context.final_scoring_step then
            if pseudorandom('cartridge_balance') < cchaos/180 then
                local tot = hand_chips + mult
                hand_chips = math.floor(tot/2)
                mult = math.floor(tot/2)
                update_hand_text({delay = 0}, {mult = mult, chips = hand_chips})
        
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        local text = localize('k_balanced')
                        play_sound('gong', 0.94, 0.3)
                        play_sound('gong', 0.94*1.5, 0.2)
                        play_sound('tarot1', 1.5)
                        ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
                        ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
                        attention_text({
                            scale = 1.4, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
                        })
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            blockable = false,
                            blocking = false,
                            delay =  4.3,
                            func = (function() 
                                    ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
                                    ease_colour(G.C.UI_MULT, G.C.RED, 2)
                                return true
                            end)
                        }))
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            blockable = false,
                            blocking = false,
                            no_delete = true,
                            delay =  6.3,
                            func = (function() 
                                G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                                G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                                return true
                            end)
                        }))
                        return true
                    end)
                }))
        
                delay(0.6)
            end
        end
        if context.end_of_round then
            if pseudorandom('cartidge_ante') < cchaos/300 then
                ease_ante(pseudorandom('cartidge_ante',-2,2))
                if G.GAME.round_resets.ante >= G.GAME.win_ante then
                    G.GAME.round_resets.ante = G.GAME.win_ante
                    ease_ante(0)
                end
            end
        end
    


        if context.using_consumeable then
            if pseudorandom('cartridge_discard') < cchaos/80 then
                local _card = copy_card(context.consumeable, nil, nil, nil, card.edition)
                _card:start_materialize()
                _card:add_to_deck()
                G.consumeables:emplace(_card)
            end
        end


        if context.discard then
            if pseudorandom('cartridge_discard') < cchaos/300 then
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local _card = copy_card(context.other_card, nil, nil, G.playing_card)
                _card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, _card)
                G.hand:emplace(_card)
                _card.states.visible = nil
                G.E_MANAGER:add_event(Event({
                    func = function()
                        _card:start_materialize()
                        return true
                    end
                }))
            end
            if pseudorandom('cartridge_discard') < cchaos/300 then
                return {
                    colour = G.C.RED,
                    delay = 0.45, 
                    remove = true,
                    card = self
                }
            end            
        end
        if context.after then
            if pseudorandom('cartridge_pack') < cchaos/40 then
                local TagNames = {'tag_uncommon','tag_rare','tag_negative','tag_foil','tag_holo','tag_polychrome','tag_investment','tag_voucher','tag_boss','tag_standard',
                                'tag_charm','tag_meteor','tag_buffoon','tag_handy','tag_garbage','tag_ethereal','tag_coupon','tag_double','tag_juggle','tag_d_six',
                                'tag_top_up','tag_skip','tag_economy'}
                
                add_tag(Tag(pseudorandom_element(TagNames,pseudoseed('cartridge'))))
            end
            card.ability.extra.chaos = cchaos + 0.25
        end

        if context.store_joker_create and (pseudorandom('cartridge') < cchaos/100) then
            _card = SMODS.create_card({set = 'Joker', area = context.area, key = 'j_deliriumcoolmod_brokenJoker'})
            create_shop_card_ui(_card, 'Joker', context.area)
            return _card
        end

    end

}

local invitation = {
    key = 'invitation',
    name = 'invitation',
    config = {extra = 0},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra}}
    end,
    loc_txt = {
        name = 'Invitation',
        text = {'After {C:attention}4{} rounds, sell this card to',
                'create a {C:dark_edition}Negative {C:red}Rare{} Joker',
                '{C:inactive}Currently {C:attention}#1#{C:inactive}/4)'}
    },
    eternal_compat = false,
    rarity = 3,
    cost = 1,
    atlas = 'mod-jokers',
    pos = {x = 6, y = 2},
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra = card.ability.extra + 1
            if  card.ability.extra == 4 then 
                local eval = function(card) return not card.REMOVED end
                juice_card_until(card, eval, true)
            end
            return {
                message = (card.ability.extra < 4) and (card.ability.extra..'/'..4) or localize('k_active_ex'),
                colour = G.C.FILTER
            }
        end

        if context.selling_self and card.ability.extra >= 4 then
            _card = SMODS.create_card({set = 'Joker', rarity = 3})
            _card:start_materialize()
            _card:add_to_deck()
            _card:set_edition({negative = true})
            G.jokers:emplace(_card)
        end
    end

}

local candycornvampire = {
    key = 'candycornvampire',
    name = 'candycornvampire',
    config = {extra = {x_mult = 0.25, gained_xmult = 1.00}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.x_mult,card.ability.extra.gained_xmult}}
    end,
    loc_txt = {
        name = 'Candy Corn Vampire',
        text = {'When {C:attention}Blind{} is selected, gain {C:white,X:mult}X#1#{} for each',
                '{C:dark_edition}Edition{} on owned jokers, Removes {C:dark_edition}Editions{}.',
                '{s:0.9}{s:0.9,C:attention}Negative{s:0.9} excluded',
                '{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)'}

    },
    rarity = 2  ,
    atlas = 'mod-jokers',
    pos = {x = 2, y = 6},
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.setting_blind and context.cardarea == G.jokers then
            local hasUpgraded = false

            G.hand:change_size(pseudorandom('cartridge',-5,5))
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + pseudorandom('cartridge',-5,5)
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + pseudorandom('cartridge',-5,5)
            change_hand_select_size(pseudorandom('cartridge',-2,2),pseudorandom('cartridge',-2,2))

            for j=1, #G.jokers.cards do
                _card = G.jokers.cards[j]
                if _card.edition and _card.edition.type ~= 'negative' then
                    _card:set_edition({},true,true)
                    hasUpgraded = true
                    _card:juice_up(1, 1)
                    card.ability.extra.gained_xmult = card.ability.extra.gained_xmult + card.ability.extra.x_mult 
                end
            end
            if hasUpgraded then
                return {
                    message = 'Upgraded!',
                    card = card
                }
            end
        end

        if context.joker_main and card.ability.extra.gained_xmult > 1 then
            return {
                x_mult = card.ability.extra.gained_xmult,
                card = card
            }
        end
    end

}

return {
    list = {mario3joker,evilmario3joker,cartridge,invitation,candycornvampire}
}