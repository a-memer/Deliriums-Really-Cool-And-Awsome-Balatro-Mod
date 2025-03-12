local irony = {
    key = 'irony',
    loc_txt = {
        name = 'Irony',
        text = {'{C:Gamer}Gamer{} cards can appear',
                'can appear in the {C:attention}Shop{}'}
    },
    pos = {x=1,y=0},
    atlas = 'mod-vouchers',
    redeem = function(self,card)
        G.GAME['gamer_rate'] = 1
    end
}

local qualitycontrol = {
    key = 'qualitycontrol',
    loc_txt = {
        name = 'Quality Control',
        text = {'{C:attention}1 Star {C:Gamer}Gamer{} cards',
                'cannot appear in {C:Gamer}Gamer{} packs'}
    },
    pos = {x=1,y=1},
    atlas = 'mod-vouchers',
    requires = {'v_deliriumcoolmod_irony'}
}

return {
    list = {irony,qualitycontrol}
}