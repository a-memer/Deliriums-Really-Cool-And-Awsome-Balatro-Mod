local alternia = {
    set = 'Planet',
    key = 'alternia',
    --! `h_` prefix was removed
    config = { hand_type = 'deliriumcoolmod_flushDuplex' },
    pos = {x = 0, y = 0 },
    atlas = 'mod-planets',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_planet_q'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    process_loc_text = function(self)
        --use another planet's loc txt instead
        local target_text = G.localization.descriptions[self.set]['c_mercury'].text
        SMODS.Consumable.process_loc_text(self)
        G.localization.descriptions[self.set][self.key].text = target_text
    end,
    generate_ui = 0,
    loc_txt = {
        name = 'Alternia'
    },
    in_pool = function(self, args)
        local hand = G.P_CENTERS[self.key].config.hand_type
        return G.GAME.hands[hand].visible
    end
}

local namek = {
    set = 'Planet',
    key = 'namek',
    --! `h_` prefix was removed
    config = { hand_type = 'deliriumcoolmod_duplex' },
    pos = {x = 1, y = 0 },
    atlas = 'mod-planets',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_planet_q'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    process_loc_text = function(self)
        --use another planet's loc txt instead
        local target_text = G.localization.descriptions[self.set]['c_mercury'].text
        SMODS.Consumable.process_loc_text(self)
        G.localization.descriptions[self.set][self.key].text = target_text
    end,
    generate_ui = 0,
    loc_txt = {
        name = 'Namek'
    },
    in_pool = function(self, args)
        local hand = G.P_CENTERS[self.key].config.hand_type
        return G.GAME.hands[hand].visible
    end
}

local theend = {
    set = 'Planet',
    key = 'theend',
    --! `h_` prefix was removed
    config = { hand_type = 'deliriumcoolmod_flushhotel' },
    pos = {x = 2, y = 0 },
    atlas = 'mod-planets',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Island?', get_type_colour(self or card.config, card), nil, 1.2)
    end,
    process_loc_text = function(self)
        --use another planet's loc txt instead
        local target_text = G.localization.descriptions[self.set]['c_mercury'].text
        SMODS.Consumable.process_loc_text(self)
        G.localization.descriptions[self.set][self.key].text = target_text
    end,
    generate_ui = 0,
    loc_txt = {
        name = 'The End'
    },
    in_pool = function(self, args)
        local hand = G.P_CENTERS[self.key].config.hand_type
        return G.GAME.hands[hand].visible
    end
}

local ssmario = {
    set = 'Planet',
    key = 'ssmario',
    --! `h_` prefix was removed
    config = { hand_type = 'deliriumcoolmod_hotel' },
    pos = {x = 3, y = 0 },
    atlas = 'mod-planets',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Starship', get_type_colour(self or card.config, card), nil, 1.2)
    end,
    process_loc_text = function(self)
        --use another planet's loc txt instead
        local target_text = G.localization.descriptions[self.set]['c_mercury'].text
        SMODS.Consumable.process_loc_text(self)
        G.localization.descriptions[self.set][self.key].text = target_text
    end,
    generate_ui = 0,
    loc_txt = {
        name = 'Starship Mario'
    },
    in_pool = function(self, args)
        local hand = G.P_CENTERS[self.key].config.hand_type
        return G.GAME.hands[hand].visible
    end
}

local deathstar = {
    set = 'Planet',
    key = 'deathstar',
    --! `h_` prefix was removed
    config = { hand_type = 'deliriumcoolmod_soak' },
    pos = {x = 0, y = 1 },
    atlas = 'mod-planets',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Non-Moon', get_type_colour(self or card.config, card), nil, 1.2)
    end,
    process_loc_text = function(self)
        --use another planet's loc txt instead
        local target_text = G.localization.descriptions[self.set]['c_mercury'].text
        SMODS.Consumable.process_loc_text(self)
        G.localization.descriptions[self.set][self.key].text = target_text
    end,
    generate_ui = 0,
    loc_txt = {
        name = 'Death Star'
    },
    in_pool = function(self, args)
        local hand = G.P_CENTERS[self.key].config.hand_type
        return G.GAME.hands[hand].visible
    end
}

local popstar = {
    set = 'Planet',
    key = 'popstar',
    --! `h_` prefix was removed
    config = { hand_type = 'deliriumcoolmod_ThreePair' },
    pos = {x = 2, y = 1 },
    atlas = 'mod-planets',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Planet???', get_type_colour(self or card.config, card), nil, 1.2)
    end,
    process_loc_text = function(self)
        --use another planet's loc txt instead
        local target_text = G.localization.descriptions[self.set]['c_mercury'].text
        SMODS.Consumable.process_loc_text(self)
        G.localization.descriptions[self.set][self.key].text = target_text
    end,
    generate_ui = 0,
    loc_txt = {
        name = 'Planet Popstar'
    },
    in_pool = function(self, args)
        local hand = G.P_CENTERS[self.key].config.hand_type
        return G.GAME.hands[hand].visible
    end
}

local krypton = {
    set = 'Planet',
    key = 'krypton',
    --! `h_` prefix was removed
    config = { hand_type = 'deliriumcoolmod_flushSix' },
    pos = {x = 1, y = 1 },
    atlas = 'mod-planets',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Planeted', get_type_colour(self or card.config, card), nil, 1.2)
    end,
    process_loc_text = function(self)
        --use another planet's loc txt instead
        local target_text = G.localization.descriptions[self.set]['c_mercury'].text
        SMODS.Consumable.process_loc_text(self)
        G.localization.descriptions[self.set][self.key].text = target_text
    end,
    generate_ui = 0,
    loc_txt = {
        name = 'Krypton'
    },
    in_pool = function(self, args)
        local hand = G.P_CENTERS[self.key].config.hand_type
        return G.GAME.hands[hand].visible
    end
}



return {
    list = {namek,ssmario,popstar,deathstar,alternia,theend,krypton}
}