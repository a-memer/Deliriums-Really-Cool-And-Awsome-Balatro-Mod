local threePair = SMODS.PokerHand {
    key = 'ThreePair',
    mult = 2,
    chips = 30,
    l_mult = 2,
    l_chips = 25,
    example = {
        { 'H_A', true },
        { 'D_A', true },
        { 'C_Q', true },
        { 'S_Q', true },
        { 'H_4', true },
        { 'C_4', true }
    },
    loc_txt = {
        name = 'Three Pair',
        description = {'3 pairs of cards with different ranks'}
    },
    visible = false,
    evaluate = function(parts, hand)        
        if next(parts._2) then
            local asdf = SMODS.merge_lists(parts._all_pairs)

            if #parts._2 == 3 then
                return {asdf} 
            end
        end
    end
}

local hotel = SMODS.PokerHand {
    key = 'hotel',
    mult = 8,
    chips = 70,
    l_mult = 3,
    l_chips = 40,
    example = {
        { 'S_A', true },
        { 'D_A', true },
        { 'H_A', true },
        { 'C_A', true },
        { 'S_2', true },
        { 'H_2', true }
    },
    loc_txt = {
        name = 'Hotel',
        description = {'A Four Of A Kind and a Pair'}
    },
    visible = false,
    evaluate = function(parts, hand)        
        if next(parts._2) and next(parts._4) then
            local asdf = SMODS.merge_lists(parts._2,parts._4)
            if #parts._4 == 1 and #parts._2 == 2 then
                return {asdf} 
            end
        end
    end
}


local flushhotel = SMODS.PokerHand {
    key = 'flushhotel',
    mult = 16,
    chips = 180,
    l_mult = 4,
    l_chips = 50,
    example = {
        { 'S_A', true },
        { 'S_A', true },
        { 'S_A', true },
        { 'S_A', true },
        { 'S_2', true },
        { 'S_2', true }
    },
    loc_txt = {
        name = 'Flush Hotel',
        description = {'A Four Of A Kind and a Pair with',
                        'all cards sharing the same suit'}
    },
    visible = false,
    evaluate = function(parts, hand)        
        if next(parts._2) and next(parts._4) then
            local asdf = SMODS.merge_lists(parts._2,parts._4)
            local isFlush = false
            local canSalvage = next(SMODS.find_card('j_four_fingers'))
            local suit = asdf[1].base.suit
            for i=2, #asdf do
                if asdf[i]:is_suit(suit, nil, true) then
                    isFlush = true
                else
                    if canSalvage then
                        canSalvage = false
                        isFlush = true
                    else
                        isFlush = false
                        break
                    end
                end
            end

            if #parts._4 == 1 and #parts._2 == 2 and isFlush then
                return {asdf}
            end
        end
    end
}


local duplex = SMODS.PokerHand {
    key = 'duplex',
    mult = 5,
    chips = 60,
    l_mult = 2,
    l_chips = 25,
    example = {
        { 'C_K', true },
        { 'D_A', true },
        { 'H_A', true },
        { 'S_J', true },
        { 'H_J', true },
        { 'C_J', true }
    },
    loc_txt = {
        name = 'Duplex',
        description = {'A Three of a Kind and ',
                    'another Three of a Kind'}
    },
    visible = false,
    evaluate = function(parts, hand)        
        if next(parts._3) then
            local asdf = SMODS.merge_lists(parts._3)

            if #parts._3 == 2 then
                return {asdf}
            end
        end
    end
}

local flushDuplex = SMODS.PokerHand {
    key = 'flushDuplex',
    mult = 17,
    chips = 130,
    l_mult = 2,
    l_chips = 35,
    example = {
        { 'C_K', true },
        { 'C_A', true },
        { 'C_A', true },
        { 'C_J', true },
        { 'C_J', true },
        { 'C_J', true }
    },
    loc_txt = {
        name = 'Flush Duplex',
        description = {'A Three of a Kind and ',
                    'another Three of a Kind with',
                    'all cards sharing the same suit'}

    },
    visible = false,
    evaluate = function(parts, hand)        
        if next(parts._3) then
            local asdf = SMODS.merge_lists(parts._3)
            local isFlush = false
            local canSalvage = next(SMODS.find_card('j_four_fingers'))
            local suit = asdf[1].base.suit
            for i=2, #asdf do
                if asdf[i]:is_suit(suit, nil, true) then
                    isFlush = true
                else
                    if canSalvage then
                        canSalvage = false
                        isFlush = true
                    else
                        isFlush = false
                        break
                    end
                end
            end

            if #parts._3 == 2 and isFlush then
                return {asdf}
            end
        end
    end
}

local soak = SMODS.PokerHand {
    key = 'soak',
    mult = 16,
    chips = 160,
    l_mult = 4,
    l_chips = 50,
    example = {
        { 'S_Q', true },
        { 'D_Q', true },
        { 'S_Q', true },
        { 'H_Q', true },
        { 'C_Q', true },
        { 'S_Q', true }
    },
    loc_txt = {
        name = 'Six of a Kind',
        description = {'6 cards with the same with',
                'all cards sharing the same suit'}
    },
    visible = false,
    evaluate = function(parts, hand)        
        local _6 = get_X_same(6, hand, true)
        local asdf = SMODS.merge_lists(_6)
        
        if next(_6) then
            return {asdf}
        end
    end
}





local flushSix = SMODS.PokerHand {
    key = 'flushSix',
    mult = 16,
    chips = 666,
    l_mult = 6,
    l_chips = 66,
    example = {
        { 'H_K', true },
        { 'H_K', true },
        { 'H_K', true },
        { 'H_K', true },
        { 'H_K', true },
        { 'H_K', true }
    },
    loc_txt = {
        name = 'Flush Six',
        description = {'6 cards with the same rank and suit'}
    },
    visible = false,
    evaluate = function(parts, hand)        
        local _6 = get_X_same(6, hand, true)
        
        if next(_6) then
            local asdf = SMODS.merge_lists(_6)
            local isFlush = false
            local canSalvage = next(SMODS.find_card('j_four_fingers'))
            local suit = asdf[1].base.suit
            for i=2, #asdf do
                if asdf[i]:is_suit(suit, nil, true) then
                    isFlush = true
                else
                    if canSalvage then
                        canSalvage = false
                        isFlush = true
                    else
                        isFlush = false
                        break
                    end
                end
            end
                       
            if #_6 and isFlush then
                return {asdf}
            end
        end
    end
}