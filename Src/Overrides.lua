SMODS.Booster:take_ownership_by_kind('Arcana', {
    create_card = function(self, card, i)
        local _card
        if G.GAME.used_vouchers.v_omen_globe and pseudorandom('omen_globe') > 0.8 then
            _card = {set = "Spectral", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ar2"}
        else
            _card = {set = "Tarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ar1"}
        end

        if i == 1 and next(SMODS.find_card('j_deliriumcoolmod_mirrorguy')) then
            _card = {set = "Tarot", key = 'c_wheel_of_fortune', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ar2"}
        end
        return _card
    end,},  
    true
)


SMODS.Booster:take_ownership_by_kind('Buffoon', {
    create_card = function(self, card)
        card = SMODS.create_card({set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "buf"})
        if card.config.center.key == 'j_deliriumcoolmod_gaster' then
            card:remove()
            card = SMODS.create_card({set = 'Joker', key ='j_joker'})
        end

        return card
    end},
   true
)


SMODS.Consumable:take_ownership('wheel_of_fortune',{
    use = function(self,card,area,copier)
        local peepee = {}
        for j=1, #G.jokers.cards do
            if not G.jokers.cards[j].edition then
                peepee[#peepee + 1] = G.jokers.cards[j]
            end
        end

        if pseudorandom('wheel_of_fortune') < G.GAME.probabilities.normal/card.ability.extra then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                local over = false
                local eligible_card = pseudorandom_element(peepee, pseudoseed('wheel_of_fortune'))
                local edition = nil
                edition = poll_edition('wheel_of_fortune', nil, true, true)
                eligible_card:set_edition(edition, true)
                check_for_unlock({type = 'have_edition'})
                card:juice_up(0.3, 0.5)
                SMODS.calculate_context({wheel_used = true, other_card = card, successful = true})
            return true end }))
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
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
                    SMODS.calculate_context({wheel_used = true, other_card = card, successful = false})
            return true end }))
        end
        delay(0.6)
    end
    },
    true
)