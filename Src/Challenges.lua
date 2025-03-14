SMODS.Challenge {
    key = 'aceChallenge',
    loc_txt = {
        name = 'Unnamed Ace Challenge'
    },
    jokers = {
        {id = 'j_deliriumcoolmod_trumbo', eternal = true},
        {id = 'j_deliriumcoolmod_clearance'}
    },
    unlocked = function(self)
        return true
    end
}

SMODS.Challenge {
    key = 'thehoard',
    loc_txt = {
        name ='The Hoard'
    },
    jokers = {
        {id = 'j_deliriumcoolmod_happyhenry', eternal = true, edition = 'negative'}
    },
    rules = {
        modifiers = {
            {id = 'dollars', value = 100}
        }    
    },
    unlocked = function(self)
        return true
    end
}

SMODS.Challenge {
    key = 'inaloop',
    loc_txt = {
        name ='In a Loop'
    },
    jokers = {
        {id = 'j_deliriumcoolmod_johnnywizard', eternal = true},
        {id = 'j_runner', eternal = true}

    },
    unlocked = function(self)
        return true
    end
}