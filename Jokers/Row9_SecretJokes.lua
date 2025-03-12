local skibidtoilet = mod.path:match("Mods/[^/]+")


local wingdings = {file = skibidtoilet .. "/assets/fonts/Wingdings.ttf", 
    render_scale = G.TILESIZE*10, 
    TEXT_HEIGHT_SCALE = 1, 
    TEXT_OFFSET = {x=10,y=-20}, 
    FONTSCALE = 0.1, 
    squish = 5, 
    DESCSCALE = 1
}

wingdings.FONT = love.graphics.newFont(wingdings.file,wingdings.render_scale)

local gaster = {
    key = 'gaster',
    name = 'gaster',
    config = {mult = 666},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.mult},
            main_start = {
                {n=G.UIT.O, config={object = DynaText({string = '+666', colours = {G.C.RED}, silent = true, scale = 0.5, font = wingdings})}}
            },
            main_end = {
                {n=G.UIT.O, config={object = DynaText({string = 'MULT.', colours = {G.C.L_BLACK}, silent = true, scale = 0.5, font = wingdings})}}
            }
        }
    end,
    loc_txt = {
        name = 'GASTER',
        text = {
            ''
        }
    },
    
    rarity = 3,
    atlas = 'mod-jokers',
    pos = {x=6,y=6},
    calculate = function(self,card,context)
        if context.joker_main and not context.blueprint then
            return {
                mult = card.ability.mult,
                card = card
            }
        end
    end,
    set_sprites = function(self, card, front)
        card:set_font(wingdings)
        sendInfoMessage('ENTRY NUMBER 17')
    end
}


local notposting = {
    key = 'notposting',
    name = 'notposting',
    config = {extra = {x_chips = 4}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.x_chips}}
    end,
    loc_txt = {
        name = 'NOT POSTING',
        text = {'{C:white,X:chips}X#1#{} Chips if you',
                'have no {C:dark_edition}negative{} jokers'}
    },
    pos = {x=1,y=6},
    rarity = 3,
    atlas = 'mod-jokers',
    blueprint_compat = true,
    calculate = function(self,card,context)
        local nonegatives = true
        for j=1, #G.jokers.cards do
            if G.jokers.cards[j].edition and G.jokers.cards[j].edition.negative then
                nonegatives = false
                break
            end
        end

        if context.joker_main and nonegatives then
            return {
                x_chips = card.ability.extra.x_chips,
                card = card
            }
        end
    end,
    in_pool = function(self,args)
        if G.GAME.pool_flags.stopped_posting then
            return true
        else
            return false
        end
    end
}


local gamzee = {
    key = 'gamzee',
    name = 'Gamzee',
    config = {extra = {x_chips = 0.10, gained_xchips = 1.00}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.gained_xchips, card.ability.extra.x_chips}}
    end,
    loc_txt = {
        name = 'Gamzee',
        text = {
            'On {C:attention}even{} hands, played cards give {C:white,X:chips}X#1#{} Chips',
            'when scored, amount increases by {C:white,X:chips}X#2#{}',
            'whenever a card is {C:attention}destroyed.'
        }
    },
    pos = {x=8,y=8},
    soul_pos = {x=9,y=8},
    atlas = 'mod-jokers',
    blueprint_compat = true,
    rarity = 4,
    calculate = function(self,card, context)
        if context.individual and context.cardarea == G.play then
            if card.ability.extra.gained_xchips > 1 and (G.GAME.current_round.hands_left % 2) == 0 then
                return {
                    x_chips = card.ability.extra.gained_xchips,
                    card = card,
                }
            end
        end

        if context.remove_playing_cards and not context.blueprint then
            for i = 1, #context.removed do
                card.ability.extra.gained_xchips = card.ability.extra.gained_xchips + card.ability.extra.x_chips 
            end
            return {
                message = 'hOnK :o)'
            }
        end
    end
}

local missingJoker = {
    key = 'missingJoker',
    name = 'Missing Joker',
    config = {extra = {x_mult = 1.2, x_mult_mod = 0.2}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.x_mult,card.ability.extra.x_mult_mod}}
    end,
    loc_txt = {
        name = 'Missing Joker',
        text = {
            'Whenever a {C:attention}Joker{} is sold or destroyed',
            'create an {C:red,E:1}UNDEFINED{}, gives {C:white,X:mult}X#1#{} for each',
            '{C:red,E:1}UNDEFINED{} you own, Increases by {X:mult,C:white}X#2#{} ',
            'whenever the {C:attention}Boss Blind{} is defeated.'
        }
    },
    rarity = 'deliriumcoolmod_unknown',
    pos = {x=8,y=9},
    soul_pos = {x=9,y=9},
    atlas = 'mod-jokers',
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.joker_destroyed and not context.blueprint then
            if context.other_card.ability.name ~= 'deliriumcoolmod_undefined' then
                local _card = SMODS.add_card({set = 'Joker',key = 'j_deliriumcoolmod_brokenJoker'})
                _card:set_edition(context.other_card.edition)
            end
        end
        
        if context.end_of_round and context.cardarea == G.jokers and G.GAME.blind.boss and not context.blueprint then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod 
            return {
                message = 'Upgraded!'
            }
        end

        if context.other_joker then
            if context.other_joker.ability.name == 'deliriumcoolmod_undefined' then
                return {
                    x_mult = card.ability.extra.x_mult,
                }
            end
        end
    end,
    in_pool = function()
        return false
    end
}


local middlefinger = {
    key = 'middlefinger',
    name = 'middlefinger',
    config = {extra = {Xmult = 5}, type = 'High Card'},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.Xmult, card.ability.type}}
    end,
    loc_txt = {
        name = 'Middle Finger',
        text = {'{C:white,X:mult}X#1#{} Mult if played hand is',
                '{C:attention}#2#{}.'}
    },
    pos = {x=3,y=6},
    atlas = 'mod-jokers',
    rarity = 1,
    cost = 10,
    blueprint_compat = true,
    in_pool = function(self,args) 
        return G.GAME.starting_params.cards_per_hand == 1 
    end, 
    calculate = function(self,card,context)
        if context.joker_main and context.scoring_name == card.ability.type then
            return {
                Xmult = card.ability.extra.Xmult,
                card = card
            }
        end
    end
}

local brokenjoker = {
    key = 'brokenJoker',
    name = 'deliriumcoolmod_undefined',
    no_collection = true,
    loc_vars = function(self,info_queue,card)
        local strings = {
            'When this joker',
            '+4 Mult',
            'whenenever you play a',
            'Hearts give',
            'Copies the effect of',
            'ERROR',
            'NIL',
            'MISSING',
            'UNDEFINED',
            'Face Cards',
            'Retriggers the',
            'Chub Dislikes Smoke!'
        }
        local replaceChars = {'a','e','A','E','O','o','t','T','i','I'}
        local glitchChars = {'!','#','_','!=','==','<=','<3','NaN','0','1','2','3','4','5','6','7','8','9'}
        
        local finalStrings = {}

        for i=1, 10 do
            local finalString = pseudorandom_element(strings,pseudoseed('glitchtext'))
            finalString = string.gsub(finalString,pseudorandom_element(replaceChars,pseudoseed('glitchtext')),pseudorandom_element(glitchChars,pseudoseed('glitchtext')))
            finalStrings[#finalStrings+1] = finalString
        end
        return {
            main_start = {
                {n=G.UIT.O, config={object = DynaText({string = finalStrings, colours = {G.C.RED},pop_in_rate = 9999999, random_element = true, silent = true, pop_delay = 0.15, scale = 0.32, min_cycle_time = 0})}},
            },
        }
    end,
    loc_txt = {
        name = 'UNDEFINED',
        text = {}
    },
    cost = 0,
    pos = {x=5,y=6},
    hidden = true,
    atlas = 'mod-jokers',
    in_pool = function()
        return false
    end
}



return {
    list = {gaster,notposting,missingJoker,gamzee,middlefinger,brokenjoker}
}