
function tableContains(table, value)
    for i = 1,#table do
        if (table[i] == value) then
            return true
        end
    end
    return false
end


function roundNumber(num, numDecimalPlaces)
    local bmult = 10^(numDecimalPlaces or 0)
    return math.floor(num * bmult + 0.5) / bmult
end

function GetRandomHexColor(key)
    local characters = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'}
    local finishedcolor = ''
    local counter = 1
    while counter <= 6 do
        finishedcolor = finishedcolor.. pseudorandom_element(characters,pseudoseed('randomcolor'))
        counter = counter + 1
    end
    sendInfoMessage(finishedcolor)
    return HEX(finishedcolor)
end

local function ShuffleInPlace(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

function CorruptString(normalString)
  local stringTable = {}
  local glitchCharacters = {'▁','ⱑ','≧','ⴚ','♢','⑊','{','.','Dusty','Cart','ridge','Half','ide the','bus','Quar','Sta','Hologr','ram','1','2','3','4','5','6','7','8','9','0',
  'Missing','Poster','No','Show','The', 'gash', 'weaves', 'down', 'as', 'if', 'you', 'cry', 'Blood', 'stone', 'Jolly','Crazy','Clever'}
  local stringLength = string.len(normalString)
  local startPoint = 1
  local completedString= ""

  while startPoint < stringLength do
    local endPoint = math.random(1,stringLength)
    table.insert(stringTable,string.sub(normalString,startPoint,endPoint))
    startPoint = endPoint
  end
  
  ShuffleInPlace(stringTable)
 
  for i,v in ipairs(stringTable) do
    completedString = completedString .. v .. glitchCharacters[math.random(#glitchCharacters)]
    if math.random(0,10) == 10 then
      completedString:gsub(v,glitchCharacters[math.random(#glitchCharacters)])
    end
  end

  completedString:gsub(" ","_")
  return TrimString('j_' .. completedString,50)
end 


function TrimString(string,length)
    local cutString = string
    if #string > length then
      cutString = string.sub(string,1,length)
    end
    return cutString
  end


function corruptJoker(Card,chaos,pseudostring)
    local sounds = {'gong','win','tarot2','negative','polychrome1'}
    local _center = Card.config.center
    play_sound(pseudorandom_element(sounds,pseudoseed(pseudostring)), pseudorandom(pseudostring,0.1,3), pseudorandom(pseudostring,0.1,0.5))
    Card:remove_from_deck(true)
    Card:set_nickname(CorruptString(Card.ability.name))
    Card.children.center.scale.y = Card.children.center.scale.y/pseudorandom(pseudostring,0.8,3)
    Card.T.h = Card.T.h/pseudorandom(pseudostring,0.8,3)

    if pseudorandom(pseudostring) < 1/15 then
        Card.glitched_pos = {x = _center.pos.x + pseudorandom(pseudostring,-2,2),y = _center.pos.y + pseudorandom(pseudostring,-2,2)}
    end


    Card:set_ability(Card.config.center,true)




    local _poker_hands = {}
    for k, v in pairs(G.GAME.hands) do
        _poker_hands[#_poker_hands+1] = k 
    end
    Card.ability.type = pseudorandom_element(_poker_hands,pseudoseed(pseudostring))

    -- Bandaid fix but I hope it works
    if Card.ability.type == nil or Card.ability.type == '' then
        card.ability.type = 'High Card'
    end

    for k,v in pairs(Card.ability) do
        if type(v) == "number" and k ~= 'order' and k ~= 'type' then
            Card.ability[k] = v + (pseudorandom(pseudostring,-10,10)  * (chaos / 10))
        end
    end

    if type(Card.ability.extra) == "table" then
        for k,v in pairs(Card.ability.extra) do
            if k ~= 'poker_hand' then
                if type(v) == "number" then
                    Card.ability.extra[k] = v + (pseudorandom(pseudostring,-10,10)  * (chaos / 10))
                    Card.ability.extra[k] = math.max(Card.ability.extra[k],0.01)
                end
            end
        end
    elseif type(Card.ability.extra) == "number" then
        Card.ability.extra = Card.ability.extra + (pseudorandom(pseudostring,-10,10) * (chaos / 10)) 
    end
    

    Card:add_to_deck(true)

end

function change_hand_select_size(handmod,disardmod)
    G.GAME.starting_params.cards_per_discard = G.GAME.starting_params.cards_per_hand + disardmod
    G.GAME.starting_params.cards_per_hand = G.GAME.starting_params.cards_per_hand + handmod

    G.hand.config.highlighted_limit = math.max(G.GAME.starting_params.cards_per_discard,G.GAME.starting_params.cards_per_hand)

end


function shuffle(t,seed)
    local tbl = {}
    for i = 1, #t do
        tbl[i] = t[i]
    end
    for i = #tbl, 2, -1 do
        local j = pseudorandom(seed,1,i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end



function get_gamer_for_pack(no_one_stars)
    local pool = {
        {key = 'ai',weight = 0.1,onestar = false},
        {key = 'breifCase',weight = 0.15,onestar = false},
        {key = 'royalty',weight = 0.2,onestar = false},
        {key = 'punchcard',weight = 0.1,onestar = false},
        {key = 'selfdefence',weight = 0.25,onestar = false},
        {key = 'offbrand',weight = 0.3,onestar = false},
        {key = 'draw2',weight = 0.4,onestar = false},
        {key = 'rockknight',weight = 0.85,onestar = false},
        {key = 'determination',weight = 0.85,onestar = false},
        {key = 'rareCoin',weight = 0.5,onestar = false},
        {key = 'wheelofpain',weight = 0.6,onestar = false},
        {key = 'factorytemplate',weight = 0.6,onestar = false},        
        {key = 'printingerror', weight = 0.6, onestar = false},
        {key = 'stitchedCard', weight = 0.7, onestar = true},
        {key = 'missingposter',weight = 0.95,onestar = false}
    }

    if not no_one_stars then
        table.insert(pool,{key = 'intrusivethought', weight = 0,onestar = true})
        table.insert(pool,{key = 'amputation', weight = 0,onestar = true})
        table.insert(pool,{key = 'pyamidscheme', weight = 0,onestar = true})
        table.insert(pool,{key = 'speedrun', weight = 0,onestar = true})
        table.insert(pool,{key = 'pinkSlip', weight = 0,onestar = true})
        table.insert(pool,{key = 'vintagecard', weight =  0.75,onestar = true})

    end

    if not next(find_joker("Showman")) then
        for i = #pool, 1, -1 do 
            local entry = pool[i]
            if tableContains(G.GAME.gamer_choices,'c_deliriumcoolmod_' .. pool[i].key) then
                table.remove(pool, i)
            else
                local conKeys = {}
                for j=1, #G.consumeables.cards do
                    table.insert(conKeys,G.consumeables.cards[j].config.center.key)
                end
                if tableContains(conKeys,'c_deliriumcoolmod_' .. pool[i].key) then
                    table.remove(pool, i)
                end
            end
        end
    end




    local poolLuck = pseudorandom('gamerPack')
    local lowestWeight = 1


    for i=1, #pool do
        if pool[i].weight < lowestWeight then
            lowestWeight = pool[i].weight
        end
    end
    poolLuck = math.max(poolLuck,lowestWeight + pseudorandom('gamerPack',0.01,0.1))




    local shuffledPool = shuffle(pool,'gamerPack')

    for i=1, #shuffledPool do
        if shuffledPool[i].weight < poolLuck then
            table.insert(G.GAME.gamer_choices,'c_deliriumcoolmod_' .. shuffledPool[i].key)
            return 'c_deliriumcoolmod_' .. shuffledPool[i].key
        end
    end

    return 'c_deliriumcoolmod_ai'
end
            