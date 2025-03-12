local armageddonTag = {
    key = 'armageddonTag',
    atlas = 'mod-tags',
    loc_txt = {
        name = "Armageddon Tag",
        text = {
            "Gives a free",
            "{C:Gamer}Mega Gamer Pack"
        }
    },
    loc_vars = function(self,info_queue,tag)
        info_queue[#info_queue+1] =  G.P_CENTERS['p_deliriumcoolmod_gamerBoosterMega']
    end,
    config = {type = "eval"},
    pos = { x = 1, y = 0 },
    min_ante = 2,
    apply = function(self, tag, context)
        tag:yep('+', G.C.SECONDARY_SET.Planet,function() 
                local key = 'p_deliriumcoolmod_gamerBoosterMega'
                local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                card.cost = 0
                card.from_tag = true
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                return true
            end)
        tag.triggered = true
        return true
    end
}


return {
name = 'Armageddon Tag',
list = {armageddonTag}   
}













