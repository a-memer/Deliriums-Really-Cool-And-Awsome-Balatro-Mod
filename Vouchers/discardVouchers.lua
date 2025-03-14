local blackMarket = {
    key = 'blackmarket',
    config = {extra = {currentamount = 0}},
    loc_txt = {
        name = 'Black Market',
        text = {'Earn {C:money}$1{} per unused',
                '{C:attention}discard{} at end of round'
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
        text = {'You may select an {C:attention}additional{}',
                'card while {C:attention}disarding{}'}
    },
    pos = {x=0,y=1},
    atlas = 'mod-vouchers',
    redeem = function(self,card)
        change_hand_select_size(0,1)
    end,
    requires = {'v_deliriumcoolmod_blackmarket'}
} 






return {
    list = {blackMarket,Prostetic}
}