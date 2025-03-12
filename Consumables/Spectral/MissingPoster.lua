local MissingPoster = {
    key = 'missingposter',
    set = 'Spectral',
    loc_txt = {
        name = 'Missing Poster',
        text = {'Does... {C:legendary,E:1}something?'}
    },
    pos = {x = 4, y = 2},
    atlas = 'gamer-cards',
    cost = 6,
    hidden = true,
    soul_set = 'Gamer',
    soul_rate = 0.05,
    can_repeat_soul = false,
    can_use = function(self,card)
        for j=1, #G.jokers.cards do
            if G.jokers.cards[j].ability.name == 'noshow' then
                return true
            end
        end
        return false
    end,       
    in_pool = function(self,args)
        for j=1, #G.jokers.cards do
            if G.jokers.cards[j].ability.name == 'noshow' then
                return true
            end
        end
        return false
    end,
    use = function(self,card,area,copier)
        local noShow = nil
        for j=1, #G.jokers.cards do
            if G.jokers.cards[j].ability.name == 'noshow' then
                noShow = G.jokers.cards[j]
                break
            end
        end

        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() noShow:flip();play_sound('card1', percent);noShow:juice_up(0.3, 0.3);return true end }))
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            noShow:remove_from_deck()
            noShow.config.center = G.P_CENTERS['j_deliriumcoolmod_missingJoker']
            noShow:set_ability(noShow.config.center,true)
            noShow:add_to_deck()
            return true 
        end}))
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() noShow:flip();play_sound('tarot2', percent);noShow:juice_up(0.3, 0.3);return true end }))
    end
}



return {
    list = {MissingPoster}
}