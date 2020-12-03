include [[perfectbob]]

do
    local keybinds = {
        ['#1'] = '/magicfruit stpc',
        ['#2'] = '/batterycharge',
        ['#3'] = '/erraticflutter',
        ['#4'] = '/occultation',
        ['#to 5'] = '/natmeditation',
        ['#6'] = '/subduction stnpc',
        ['#7'] = '/magichammer stnpc',
        ['#8'] = '/blankgaze stnpc',
        ['#9'] = '/dreamflower stnpc',
        ['#0'] = '/suddenlunge stnpc',

        ['#-'] = '/chainaffinity',
        ['#='] = '/burstaffinity',

        ['#backspace'] = '/diffusion',

        ['^-'] = '/berserk',
        ['^='] = '/aggressor',

        ['!-'] = '/warcry',
        ['!='] = '/defender',
    }

    for keys, command in pairs(keybinds) do
        send_command('bind '.. keys ..' input '.. command)
    end

    _G.file_unload = function()
        for keys in pairs(keybinds) do
            send_command('unbind '.. keys)
        end
    end
end


local blue_spell_map = {
    magic_fruit = 'cure potency',
    magic_hammer = 'magic attack',
    subduction = 'magic attack',
    spectral_floe = 'magic attack',
    molting_plumage = 'magic attack',
    cursed_sphere = 'magic attack',
    sudden_lunge = 'magic accuracy',
    blank_gaze = 'magic accuracy',
    dream_flower = 'magic accuracy',
    blazing_bound = 'magic defense',
    quad_continuum = 'physical attack',
    delta_thrust = 'physical attack',
    barbed_cresent = 'physical attack',
}


local ring = {
    fenrir = { {name = 'fenrir ring', bag = 'wardrobe'}, {name = 'fenrir ring', bag = 'wardrobe 2'} },
    ephedra = { {name = 'ephedra ring', bag = 'wardrobe'}, {name = 'ephedra ring', bag = 'wardrobe 2'} },
}


_G.sets = {
    naked = sets.naked,

    fast_cast = {
        head = "Haruspex Hat +1",
        body = "Foppish Tunica", hands = "Magavan Mitts",
        back = "Swith Cape", waist = "Witful Belt", legs = "Orvail Pants +1", feet = "Chelona Boots",
    },

    quick_magic = { ammo = "Impatiens", ring2 = "Veneficium Ring" },

    cure_potency = {
        neck="Healing Torque", ear1="Healing Earring",
        body="Chelona Blazer", hands="Weath. Cuffs +1", ring1 = ring.ephedra[1], ring2 = ring.ephedra[2],
        back="Tempered Cape",
    },

    magic_attack = {
        ammo = "Hydrocera",
        head = "Weath. Corona +1", neck = "Mirage Stole +1",ear1 = "Friomisi Earring", ear2 = "Saviesa Pearl",
        body = "Sombra Harness", hands = "Orvail Cuffs +1", ring1 = ring.fenrir[1], ring2 = ring.fenrir[2],
        back = "Toro Cape", waist = "Salire Belt", legs="Shned. Tights +1", feet = "Weatherspoon souliers +1",
    },

    magic_accuracy = {
        ammo = "Hydrocera",
        head = "Weath. Corona +1", neck = "Mirage Stole +1", ear1 = "Friomisi Earring", ear2 = "Saviesa Pearl",
        body = "Haruspex Coat", hands = "Orvail Cuffs +1", ring1 = ring.fenrir[1], ring2 = ring.fenrir[2],
        back = "Ogapepo Cape", waist = "Salire Belt", legs = "Orvail Pants +1", feet = "Shned. Boots +1",
    },

    magic_defense = {
        ammo = "Vanir Battery",
        head = "Weath. Corona +1", neck = "Mirage Stole +1", ear1 = "Friomisi Earring", ear2 = "Saviesa Pearl",
        body = "Shned. Tabard +1", hands = "Orvail Cuffs +1", ring1 = ring.fenrir[1], ring2 = ring.fenrir[2],
        back = "Ogapepo Cape", waist = "Salire Belt", legs = "Orvail Pants +1", feet = "Shned. Boots +1",
    },

    physical_attack = {
        ammo = "Hasty Pinion +1",
        head = "Adhemar Bonnet", neck = "Lacono Neck. +1", ear1 = "Mache Earring", ear2 = "Grit Earring",
        body = "Sombra Harness", hands = "Adhemar Wristbands", ring1 = "Tyrant's Ring", ring2 = "Ambuscade Ring",
        back = "Bleating Mantle", waist = "Prosilio Belt", legs = "Sombra Tights", feet = "Shned. Boots +1",
    },

    weapon_skill = {
        ammo = "Hasty Pinion +1",
        head = "Adhemar Bonnet", neck = "Lacono Neck. +1", ear1 = "Ishvara Earring", ear2 = "Grit Earring",
        body = "Sombra Harness", hands = "Adhemar Wristbands", ring1 = "Tyrant's Ring", ring2 = "Ambuscade Ring",
        back = "Bleating Mantle", waist = "Chiner's Belt +1", legs = "Sombra Tights", feet = "Shned. Boots +1",
    },

    engaged = {
        ammo = "Vanir Battery",
        head = "Adhemar Bonnet", neck = "Mirage Stole +1", ear1 = "Mache Earring", ear2 = "Mache Earring",
        body = "Sombra Harness", hands = "Adhemar Wristbands", ring1 = "Yacuruna Ring", ring2 = "Ambuscade Ring",
        back = "Blithe Mantle", waist = "Cetl Belt", legs = "Sombra Tights", feet = "Thur. Boots +1",
    },

    idle = {
        head = "Weath. Corona +1",
        body = "Wayfarer Robe", hands = "Wayfarer Cuffs",
        legs = "Wayfarer Slops", feet = "Wayfarer Clogs",
    },
}


_G.status_change = function(current, previous)
    if player.status:lower() == 'engaged' then
        equip(sets.engaged)
    else
        equip(set_combine(sets.engaged, sets.idle))
    end
end


_G.precast = function(action)
    local gear_set = {}

    if action.prefix == '/magic' then
        gear_set = set_combine(sets.fast_cast, sets.quick_magic)
    elseif action.prefix == '/weaponskill' then
        gear_set = sets.weapon_skill
    end

    equip(gear_set)
end


_G.midcast = function(action)
    local gear_set = {}
    local action_name = action.name:gsub('%s','_'):gsub('\'',''):lower()

    if action.prefix == '/magic' then
        local action_type = blue_spell_map[action_name]

        if action_type then
            equip(sets[action_type])
        end
    end
end


_G.aftercast = function()
    return status_change()
end
include [[perfectbob]]

do
    local keybinds = {
        ['#1'] = '/magicfruit stpc',
        ['#2'] = '/batterycharge',
        ['#3'] = '/erraticflutter',
        ['#4'] = '/occultation',
        ['#to 5'] = '/natmeditation',
        ['#6'] = '/subduction stnpc',
        ['#7'] = '/magichammer stnpc',
        ['#8'] = '/blankgaze stnpc',
        ['#9'] = '/dreamflower stnpc',
        ['#0'] = '/suddenlunge stnpc',

        ['#-'] = '/chainaffinity',
        ['#='] = '/burstaffinity',

        ['#backspace'] = '/diffusion',

        ['^-'] = '/berserk',
        ['^='] = '/aggressor',

        ['!-'] = '/warcry',
        ['!='] = '/defender',
    }

    for keys, command in pairs(keybinds) do
        send_command('bind '.. keys ..' input '.. command)
    end

    _G.file_unload = function()
        for keys in pairs(keybinds) do
            send_command('unbind '.. keys)
        end
    end
end


local blue_spell_map = {
    magic_fruit = 'cure potency',
    magic_hammer = 'magic attack',
    subduction = 'magic attack',
    spectral_floe = 'magic attack',
    molting_plumage = 'magic attack',
    cursed_sphere = 'magic attack',
    sudden_lunge = 'magic accuracy',
    blank_gaze = 'magic accuracy',
    dream_flower = 'magic accuracy',
    blazing_bound = 'magic defense',
    quad_continuum = 'physical attack',
    delta_thrust = 'physical attack',
    barbed_cresent = 'physical attack',
}


local ring = {
    fenrir = { {name = 'fenrir ring', bag = 'wardrobe'}, {name = 'fenrir ring', bag = 'wardrobe 2'} },
    ephedra = { {name = 'ephedra ring', bag = 'wardrobe'}, {name = 'ephedra ring', bag = 'wardrobe 2'} },
}


_G.sets = {
    naked = sets.naked,

    fast_cast = {
        head = "Haruspex Hat +1",
        body = "Foppish Tunica", hands = "Magavan Mitts",
        back = "Swith Cape", waist = "Witful Belt", legs = "Orvail Pants +1", feet = "Chelona Boots",
    },

    quick_magic = { ammo = "Impatiens", ring2 = "Veneficium Ring" },

    cure_potency = {
        neck="Healing Torque", ear1="Healing Earring",
        body="Chelona Blazer", hands="Weath. Cuffs +1", ring1 = ring.ephedra[1], ring2 = ring.ephedra[2],
        back="Tempered Cape",
    },

    magic_attack = {
        ammo = "Hydrocera",
        head = "Weath. Corona +1", neck = "Mirage Stole +1",ear1 = "Friomisi Earring", ear2 = "Saviesa Pearl",
        body = "Sombra Harness", hands = "Orvail Cuffs +1", ring1 = ring.fenrir[1], ring2 = ring.fenrir[2],
        back = "Toro Cape", waist = "Salire Belt", legs="Shned. Tights +1", feet = "Weatherspoon souliers +1",
    },

    magic_accuracy = {
        ammo = "Hydrocera",
        head = "Weath. Corona +1", neck = "Mirage Stole +1", ear1 = "Friomisi Earring", ear2 = "Saviesa Pearl",
        body = "Haruspex Coat", hands = "Orvail Cuffs +1", ring1 = ring.fenrir[1], ring2 = ring.fenrir[2],
        back = "Ogapepo Cape", waist = "Salire Belt", legs = "Orvail Pants +1", feet = "Shned. Boots +1",
    },

    magic_defense = {
        ammo = "Vanir Battery",
        head = "Weath. Corona +1", neck = "Mirage Stole +1", ear1 = "Friomisi Earring", ear2 = "Saviesa Pearl",
        body = "Shned. Tabard +1", hands = "Orvail Cuffs +1", ring1 = ring.fenrir[1], ring2 = ring.fenrir[2],
        back = "Ogapepo Cape", waist = "Salire Belt", legs = "Orvail Pants +1", feet = "Shned. Boots +1",
    },

    physical_attack = {
        ammo = "Hasty Pinion +1",
        head = "Adhemar Bonnet", neck = "Lacono Neck. +1", ear1 = "Mache Earring", ear2 = "Grit Earring",
        body = "Sombra Harness", hands = "Adhemar Wristbands", ring1 = "Tyrant's Ring", ring2 = "Ambuscade Ring",
        back = "Bleating Mantle", waist = "Prosilio Belt", legs = "Sombra Tights", feet = "Shned. Boots +1",
    },

    weapon_skill = {
        ammo = "Hasty Pinion +1",
        head = "Adhemar Bonnet", neck = "Lacono Neck. +1", ear1 = "Ishvara Earring", ear2 = "Grit Earring",
        body = "Sombra Harness", hands = "Adhemar Wristbands", ring1 = "Tyrant's Ring", ring2 = "Ambuscade Ring",
        back = "Bleating Mantle", waist = "Chiner's Belt +1", legs = "Sombra Tights", feet = "Shned. Boots +1",
    },

    engaged = {
        ammo = "Vanir Battery",
        head = "Adhemar Bonnet", neck = "Mirage Stole +1", ear1 = "Mache Earring", ear2 = "Mache Earring",
        body = "Sombra Harness", hands = "Adhemar Wristbands", ring1 = "Yacuruna Ring", ring2 = "Ambuscade Ring",
        back = "Blithe Mantle", waist = "Cetl Belt", legs = "Sombra Tights", feet = "Thur. Boots +1",
    },

    idle = {
        head = "Weath. Corona +1",
        body = "Wayfarer Robe", hands = "Wayfarer Cuffs",
        legs = "Wayfarer Slops", feet = "Wayfarer Clogs",
    },
}


_G.status_change = function(current, previous)
    if player.status:lower() == 'engaged' then
        equip(sets.engaged)
    else
        equip(set_combine(sets.engaged, sets.idle))
    end
end


_G.precast = function(action)
    local gear_set = {}

    if action.prefix == '/magic' then
        gear_set = set_combine(sets.fast_cast, sets.quick_magic)
    elseif action.prefix == '/weaponskill' then
        gear_set = sets.weapon_skill
    end

    equip(gear_set)
end


_G.midcast = function(action)
    local gear_set = {}
    local action_name = action.name:gsub('%s','_'):gsub('\'',''):lower()

    if action.prefix == '/magic' then
        local action_type = blue_spell_map[action_name]

        if action_type then
            equip(sets[action_type])
        end
    end
end


_G.aftercast = function()
    return status_change()
end

