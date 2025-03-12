local chicken = {
    key = 'roastchicken',
    name = 'roastchicken',
    config = {extra = 5},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra}}
    end,
    loc_txt = {
        name = 'Roast Chicken',
        text = {'The next {C:attention}#1#{} Jokers ',
                'bought or created are {C:dark_edition}negative{}.'}
    },
    rarity = 3,
    cost = 10,
    eternal_compat = false,
    atlas = 'mod-jokers',
    pos = {x = 0, y = 6},
    cost = 10,
    calculate = function(self,card,context)
        local has_eaten = false
        if context.checking_buy_space and context.card_type == 'Joker' then
            if context.checking_card.edition == nil then
                context.checking_card:set_edition({negative = true})
                has_eaten = true
            elseif not context.checking_card.edition.negative then
                context.checking_card:set_edition({negative = true})
                has_eaten = true
            end
        end

        if context.joker_added then
            if context.added_joker.edition == nil then
                context.added_joker:set_edition({negative = true})
                has_eaten = true
            elseif not context.added_joker.edition.negative then
                context.added_joker:set_edition({negative = true})
                has_eaten = true
            end
        end

        if has_eaten then
            card.ability.extra = card.ability.extra - 1
            if card.ability.extra <= 0 then
                G.GAME.pool_flags.stopped_posting = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = 'NOT POSTING!',
                    colour = G.C.CHIPS
                }
            else
                return {
                    message = card.ability.extra .. ' Left!',
                    card = card
                }
            end

        end
    end,
    in_pool = function(self,args)
        if G.GAME.pool_flags.stopped_posting then
            return false
        else
            return true
        end
    end
}

local dave = {
    key = 'dave',
    name = 'dave',
    config = {extra = {mult = 5, multgain = 0, sign = '+'}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.mult,card.ability.extra.multgain,card.ability.extra.sign}}
    end,
    loc_txt = {
        name = 'TurntechGodhead',
        text = {'This joker gains {C:mult}+#1#{} mult for ',
        'every {C:money}1${} in {C:attention}debt{} you are',
        '{C:inactive}(Currently {C:mult}#3##2#{C:inactive} Mult){}'}
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    atlas = 'mod-jokers',
    pos = {x=1,y=5},
    calculate = function(self,card,context)
        curmult = math.max((G.GAME.dollars * card.ability.extra.mult) * -1,0)
        if curmult >= 0 then
            card.ability.extra.sign = '+'
        else
            card.ability.extra.sign = ''
        end
        card.ability.extra.multgain = curmult

        if context.joker_main then
            return {
                mult_mod = card.ability.extra.multgain,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.multgain} }
            }
        end
    end
}

local skyghost = {
    key = 'skyghost',
    name = 'projectskybox',
    loc_txt = {
        name = 'PROJECT//SKYBOX',
        text = {'Any {C:attention}Blind{} can appear',
                'as the {C:attention}Boss Blind{}'}
    },
    rarity = 2,
    cost = 4,
    atlas = 'mod-jokers',
    pos = {x = 0, y = 7}
}

local friendInsideMe = {
    key = 'FriendInsideMe',
    name = 'FriendInsideMe',
    loc_txt = {
        name = 'Friend Inside Me.',
        text = {'{C:attention}Jokers{} sold in the shop ',
                'are {C:green}+25%{} more likely',
                'to be {C:dark_edition}Negative{}'}
    },
    blueprint_compat = false,
    atlas = 'mod-jokers',
    pos = {x = 5, y = 3},
    rarity = 3,
    cost = 11,
    calculate = function(self,card,context)
        if context.store_joker_modify and context.shop_card.ability.set == 'Joker' and not context.blueprint then
            local _card = nil
            if context.shop_card == nil then
                sendInfoMessage(context.debugstring)
                return false
            else
                _card = context.shop_card
            end 

            if pseudorandom('Friend') < 1/4 then
                _card:set_edition({negative = true}, true)
                _card.temp_edition = nil
            end
            return true
        end
    end
}

local spamtonvaluenetwork = {
    key = 'spamtonvaluenetwork',
    name = 'spamtonvaluenetwork',
    config = {extra = {x_mult = 1.5, gained_x_mult = 1}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.gained_x_mult } }
    end,    
    loc_txt = {
        name = 'SPAMTON VALUE NETWORK',
        text = {
            'This gains {X:mult,C:white}X#1#{} Mult for ',
            'every {C:attention}Rental{} Joker you own,',
            'Jokers sold in shops are {C:green}+15%{}', 
            'more likely to be {C:attention}Rental{}',
            "{C:inactive}(Currently {X:mult,C:white}X#2#{}{C:inactive} Mult)"}
    },
    blueprint_compat = true,
    atlas = 'mod-jokers',
    pos = {x = 3,y = 4},
    cost = 5,
    rarity = 3,
    calculate = function(self,card,context)
        card.ability.extra.gained_x_mult = 1
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.rental then
                card.ability.extra.gained_x_mult = card.ability.extra.gained_x_mult + card.ability.extra.x_mult
            end
        end  

        if context.store_joker_modify and context.shop_card.ability.set == 'Joker' and not context.blueprint then
            local _card = nil
            if context.shop_card == nil then
                sendInfoMessage(context.debugstring)
                return false
            else
                _card = context.shop_card
            end 

            if pseudorandom('Spamton') < 15/100 then
                _card:set_rental(true)
            end
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
    list = {spamtonvaluenetwork,chicken,skyghost,dave,friendInsideMe}
}