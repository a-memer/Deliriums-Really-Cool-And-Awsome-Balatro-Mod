local dustyTag = {
    key = 'dustyTag',
    atlas = 'mod-tags',
    loc_txt = {
        name = 'Dusty Tag',
        text = {'Creates a {C:attention}Perishable',
                '{C:red}Dusty Cartridge',
                '{C:inactive}Must have room.{}'}
    },
    loc_vars = function(self,info_queue,tag)
        info_queue[#info_queue+1] =  G.P_CENTERS['j_deliriumcoolmod_cartridge']
    end,
    config = {type = "eval"},
    pos = { x = 0, y = 0 },
    apply = function(self, tag, context)
        if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit and context.type == "new_blind_choice" then
            tag:yep("Uh oh.",G.C.Red,
            function()
                local _card = SMODS.create_card({set = 'Joker',area = G.jokers, no_edition = true, key = 'j_deliriumcoolmod_cartridge'})
                _card:start_materialize()
                _card:add_to_deck()
                _card.ability.extra.chaos = 2.5
                _card:set_perishable(true)
                G.jokers:emplace(_card)
                return true
            end)
            tag.triggered = true
        end
    end
}


return {
name = 'Dusty Tag',
list = {dustyTag}   
}