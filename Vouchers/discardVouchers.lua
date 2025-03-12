local blackMarket = {
    key = 'blackmarket',
    config = {extra = {currentamount = 0}},
    loc_txt = {
        name = 'Black Market',
        text = {'Earn an extra {C:money}$1{} at the end of the round',
                'for every unused {C:red}Discard{} at',
                'the end of the round.'
        }
    },
    pos = {x=0,y=0},
    atlas = 'mod-vouchers',
    redeem = function(self,card)
        G.GAME.modifiers.money_per_discard = 1
    end
}



local Prostetic = {
    key = 'prostetic',
    loc_txt = {
        name = 'Prostetic',
        text = {'You may select {C:attention}one more card{}',
                'while {C:red}Disarding{}.'}
    },
    pos = {x=0,y=1},
    atlas = 'mod-vouchers',
    redeem = function(self,card)
        change_hand_select_size(0,1)
    end,
    requires = {'v_deliriumcoolmod_blackmarket'}
} 






return {
    name = 'Vouchers',
    list = {blackMarket,Prostetic}
}