-- HunterMarksmanship.lua
-- July 2024

-- TOPDO: Lunar Storm ICD

if UnitClassBase( "player" ) ~= "HUNTER" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local strformat = string.format

local spec = Hekili:NewSpecialization( 254, true )

spec:RegisterResource( Enum.PowerType.Focus, {
    chakram = {
        aura = "chakram",

        last = function ()
            return state.buff.chakram.applied + floor( ( state.query_time - state.buff.chakram.applied ) / class.auras.chakram.tick_time ) * class.auras.chakram.tick_time
        end,

        interval = function () return class.auras.chakram.tick_time end,
        value = function () return state.conduit.necrotic_barrage.enabled and 5 or 3 end,
    },
    rapid_fire = {
        channel = "rapid_fire",

        last = function ()
            local app = state.buff.casting.applied
            local t = state.query_time

            return app + floor( ( t - app ) / class.auras.rapid_fire.tick_time ) * class.auras.rapid_fire.tick_time
        end,

        interval = function () return class.auras.rapid_fire.tick_time * ( state.buff.trueshot.up and 0.667 or 1 ) end,
        value = 1,
    }
} )

-- Talents
spec:RegisterTalents( {
    -- Hunter
    binding_shackles          = { 102388, 321468, 1 }, -- Targets stunned by Binding Shot, knocked back by High Explosive Trap, knocked up by Implosive Trap, incapacitated by Scatter Shot, or stunned by Intimidation deal 10% less damage to you for 8 sec after the effect ends.
    binding_shot              = { 102386, 109248, 1 }, -- Fires a magical projectile, tethering the enemy and any other enemies within 5 yds for 10 sec, stunning them for 3 sec if they move more than 5 yds from the arrow.
    blackrock_munitions       = { 102392, 462036, 1 }, -- The damage of Explosive Shot is increased by 8%.
    born_to_be_wild           = { 102416, 266921, 1 }, -- Reduces the cooldowns of Aspect of the Cheetah, and Aspect of the Turtle by 30 sec.
    bursting_shot             = { 102421, 186387, 1 }, -- Fires an explosion of bolts at all enemies in front of you, knocking them back, snaring them by 50% for 6 sec, and dealing 643 Physical damage.
    camouflage                = { 102414, 199483, 1 }, -- You and your pet blend into the surroundings and gain stealth for 1 min. While camouflaged, you will heal for 2% of maximum health every 1 sec.
    concussive_shot           = { 102407, 5116  , 1 }, -- Dazes the target, slowing movement speed by 50% for 6 sec. Steady Shot will increase the duration of Concussive Shot on the target by 3.0 sec.
    counter_shot              = { 102402, 147362, 1 }, -- Interrupts spellcasting, preventing any spell in that school from being cast for 3 sec.
    devilsaur_tranquilizer    = { 102415, 459991, 1 }, -- If Tranquilizing Shot removes only an Enrage effect, its cooldown is reduced by 5 sec.
    disruptive_rounds         = { 102395, 343244, 1 }, -- When Tranquilizing Shot successfully dispels an effect or Counter Shot interrupts a cast, gain 10 Focus.
    emergency_salve           = { 102389, 459517, 1 }, -- Feign Death and Aspect of the Turtle removes poison and disease effects from you.
    entrapment                = { 102403, 393344, 1 }, -- When Tar Trap is activated, all enemies in its area are rooted for 4 sec. Damage taken may break this root.
    explosive_shot            = { 102420, 212431, 1 }, -- Fires an explosive shot at your target. After 3 sec, the shot will explode, dealing 35,498 Fire damage to all enemies within 8 yds. Deals reduced damage beyond 5 targets.
    ghillie_suit              = { 102385, 459466, 1 }, -- You take 20% reduced damage while Camouflage is active. This effect persists for 3 sec after you leave Camouflage.
    high_explosive_trap       = { 102739, 236776, 1 }, -- Hurls a fire trap to the target location that explodes when an enemy approaches, causing 5,110 Fire damage and knocking all enemies away. Limit 1. Trap will exist for 1 min.
    hunters_avoidance         = { 102423, 384799, 1 }, -- Damage taken from area of effect attacks reduced by 5%.
    implosive_trap            = { 102739, 462031, 1 }, -- Hurls a fire trap to the target location that explodes when an enemy approaches, causing 5,110 Fire damage and knocking all enemies up. Limit 1. Trap will exist for 1 min.
    improved_kill_shot        = { 102410, 343248, 1 }, -- Kill Shot's critical damage is increased by 25%.
    improved_traps            = { 102418, 343247, 1 }, -- The cooldown of Tar Trap, High Explosive Trap, Implosive Trap, and Freezing Trap is reduced by 5.0 sec.
    intimidation              = { 102397, 19577 , 1 }, -- Commands your pet to intimidate the target, stunning it for 5 sec.
    keen_eyesight             = { 102409, 378004, 2 }, -- Critical strike chance increased by 2%.
    kill_shot                 = { 102399, 53351 , 1 }, -- You attempt to finish off a wounded target, dealing 41,767 Physical damage. Only usable on enemies with less than 20% health.
    kindling_flare            = { 102425, 459506, 1 }, -- Stealthed enemies revealed by Flare remain revealed for 3 sec after exiting the flare.
    kodo_tranquilizer         = { 102415, 459983, 1 }, -- Tranquilizing Shot removes up to 1 additional Magic effect from up to 2 nearby targets.
    lone_survivor             = { 102391, 388039, 1 }, -- Reduce the cooldown of Survival of the Fittest by 30 sec, and increase its duration by 2.0 sec. Reduce the cooldown of Counter Shot and Muzzle by 2 sec.
    misdirection              = { 102419, 34477 , 1 }, -- Misdirects all threat you cause to the targeted party or raid member, beginning with your next attack within 30 sec and lasting for 8 sec.
    moment_of_opportunity     = { 102426, 459488, 1 }, -- When a trap triggers, you gain Aspect of the Cheetah for 3 sec. Can only occur every 1 min.
    natural_mending           = { 102401, 270581, 1 }, -- Every 10 Focus you spend reduces the remaining cooldown on Exhilaration by 1.0 sec.
    no_hard_feelings          = { 102412, 459546, 1 }, -- When Misdirection targets your pet, it reduces the damage they take by 50% for 5 sec.
    padded_armor              = { 102406, 459450, 1 }, -- Survival of the Fittest gains an additional charge.
    pathfinding               = { 102404, 378002, 1 }, -- Movement speed increased by 4%.
    posthaste                 = { 102411, 109215, 1 }, -- Disengage also frees you from all movement impairing effects and increases your movement speed by 50% for 4 sec.
    quick_load                = { 102413, 378771, 1 }, -- When you fall below 40% health, Bursting Shot and Scatter Shot have their cooldown immediately reset. This can only occur once every 25 sec.
    rejuvenating_wind         = { 102381, 385539, 1 }, -- Maximum health increased by 8%, and Exhilaration now also heals you for an additional 12.0% of your maximum health over 8 sec.
    roar_of_sacrifice         = { 102405, 53480 , 1 }, -- Instructs your pet to protect a friendly target from critical strikes, making attacks against that target unable to be critical strikes, but 10% of all damage taken by that target is also taken by the pet. Lasts 12 sec.
    scare_beast               = { 102382, 1513  , 1 }, -- Scares a beast, causing it to run in fear for up to 20 sec. Damage caused may interrupt the effect. Only one beast can be feared at a time.
    scatter_shot              = { 102421, 213691, 1 }, -- A short-range shot that deals 544 damage, removes all harmful damage over time effects, and incapacitates the target for 4 sec. Any damage caused will remove the effect. Turns off your attack when used.
    scouts_instincts          = { 102424, 459455, 1 }, -- You cannot be slowed below 80% of your normal movement speed while Aspect of the Cheetah is active.
    scrappy                   = { 102408, 459533, 1 }, -- Casting Aimed Shot reduces the cooldown of Intimidation and Binding Shot by 0.5 sec.
    serrated_tips             = { 102384, 459502, 1 }, -- You gain 5% more critical strike from critical strike sources.
    specialized_arsenal       = { 102390, 459542, 1 }, -- Aimed Shot deals 10% increased damage.
    survival_of_the_fittest   = { 102422, 264735, 1 }, -- Reduces all damage you and your pet take by 30% for 6 sec.
    tar_trap                  = { 102393, 187698, 1 }, -- Hurls a tar trap to the target location that creates a 8 yd radius pool of tar around itself for 30 sec when the first enemy approaches. All enemies have 50% reduced movement speed while in the area of effect. Limit 1. Trap will exist for 1 min.
    tarcoated_bindings        = { 102417, 459460, 1 }, -- Binding Shot's stun duration is increased by 1 sec.
    territorial_instincts     = { 102394, 459507, 1 }, -- Casting Intimidation without a pet now summons one from your stables to intimidate the target. Additionally, the cooldown of Intimidation is reduced by 5 sec.
    trailblazer               = { 102400, 199921, 1 }, -- Your movement speed is increased by 30% anytime you have not attacked for 3 sec.
    tranquilizing_shot        = { 102380, 19801 , 1 }, -- Removes 1 Enrage and 1 Magic effect from an enemy target.
    trigger_finger            = { 102396, 459534, 2 }, -- You and your pet have 5.0% increased attack speed. This effect is increased by 100% if you do not have an active pet.
    unnatural_causes          = { 102387, 459527, 1 }, -- Your damage over time effects deal 10% increased damage. This effect is increased by 50% on targets below 20% health.
    wilderness_medicine       = { 102383, 343242, 1 }, -- Mend Pet heals for an additional 25% of your pet's health over its duration, and has a 25% chance to dispel a magic effect each time it heals your pet.

    -- Marksmanship
    aimed_shot                = { 102297, 19434 , 1 }, -- A powerful aimed shot that deals 44,280 Physical damage.
    barrage                   = { 102332, 120360, 1 }, -- Rapidly fires a spray of shots for 2.4 sec, dealing an average of 18,785 Physical damage to all nearby enemies in front of you. Usable while moving. Deals reduced damage beyond 8 targets.
    bulletstorm               = { 102303, 389019, 1 }, -- Each additional target your Rapid Fire or Aimed Shot ricochets to from Trick Shots increases the damage of Multi-Shot by 7% for 15 sec, stacking up to 10 times. The duration of this effect is not refreshed when gaining a stack.
    bullseye                  = { 102298, 204089, 1 }, -- When your abilities damage a target below 20% health, you gain 1% increased critical strike chance for 6 sec, stacking up to 30 times.
    calling_the_shots         = { 102326, 260404, 1 }, -- Every 50 Focus spent reduces the cooldown of Trueshot by 2.5 sec.
    careful_aim               = { 102313, 260228, 1 }, -- Aimed Shot deals 50% bonus damage to targets who are above 70% health.
    chimaera_shot             = { 102323, 342049, 1 }, -- A two-headed shot that hits your primary target for 9,917 Nature damage and another nearby target for 4,958 Frost damage.
    crack_shot                = { 102329, 321293, 1 }, -- Arcane Shot and Chimaera Shot Focus cost reduced by 20.
    deathblow                 = { 102305, 378769, 1 }, -- Aimed Shot has a 15% and Rapid Fire has a 25% chance to grant a charge of Kill Shot, and cause your next Kill Shot to be usable on any target regardless of their current health.
    eagletalons_true_focus    = { 102306, 389449, 1 }, -- Trueshot lasts an additional 3.0 sec, reduces the Focus Cost of Aimed Shot by 50%, and causes your Arcane Shot, Chimaera Shot, and Multi-Shot to be cast again at 30% effectiveness.
    fan_the_hammer            = { 102314, 459794, 1 }, -- Rapid Fire shoots 3 additional shots.
    focused_aim               = { 102333, 378767, 2 }, -- Aimed Shot and Rapid Fire damage increased by 5.0%.
    heavy_ammo                = { 102334, 378910, 1 }, -- Trick Shots now ricochets to 2 fewer targets, but each ricochet deals an additional 25% damage.
    hydras_bite               = { 102301, 260241, 1 }, -- When Aimed Shot strikes an enemy affected with your Serpent Sting, it spreads Serpent Sting to 2 enemies nearby. Serpent Sting's damage over time is increased by 20%.
    improved_steady_shot      = { 102328, 321018, 1 }, -- Steady Shot now generates 10 Focus.
    in_the_rhythm             = { 102319, 407404, 1 }, -- When Rapid Fire fully finishes channeling, gain 8% haste for 6 sec.
    kill_zone                 = { 102310, 459921, 1 }, -- Your spells and attacks deal 8% increased damage and ignore line of sight against any target in your Volley.
    killer_accuracy           = { 102330, 378765, 1 }, -- Kill Shot critical strike chance and critical strike damage increased by 20%.
    legacy_of_the_windrunners = { 102327, 406425, 2 }, -- Aimed Shot coalesces 1 Wind Arrow that shoot your target for 1,782 Physical damage. Each time Rapid Fire deals damage, there is a 5% chance to coalesce a Wind Arrow at your target.
    light_ammo                = { 102334, 378913, 1 }, -- Trick Shots now causes Aimed Shot and Rapid Fire to ricochet to 2 additional targets.
    lock_and_load             = { 102324, 194595, 1 }, -- Your ranged auto attacks have a 8% chance to trigger Lock and Load, causing your next Aimed Shot to cost no Focus and be instant.
    lone_wolf                 = { 102300, 155228, 1 }, -- Increases your damage by 5% when you do not have an active pet.
    master_marksman           = { 102296, 260309, 1 }, -- Your melee and ranged special attack critical strikes cause the target to bleed for an additional 15% of the damage dealt over 6 sec.
    multishot                 = { 102295, 257620, 1 }, -- Fires several missiles, hitting your current target and all enemies within 10 yards for 6,192 Physical damage. Deals reduced damage beyond 5 targets.
    night_hunter              = { 102321, 378766, 1 }, -- Aimed Shot and Rapid Fire critical strike chance increased by 5%.
    penetrating_shots         = { 102331, 459783, 1 }, -- Gain critical strike damage equal to 40% of your critical strike chance.
    precise_shots             = { 102294, 260240, 1 }, -- Aimed Shot causes your next 2 Arcane Shots or Multi-Shots to deal 70% more damage and cost 50% less Focus.
    rapid_fire                = { 102318, 257044, 1 }, -- Shoot a stream of 7 shots at your target over 1.6 sec, dealing a total of 51,660 Physical damage. Usable while moving. Each shot generates 1 Focus.
    rapid_fire_barrage        = { 102302, 459800, 1 }, -- Barrage now instead shoots Rapid Fires at your target and up to 4 nearby enemies at 30% effectiveness, but its cooldown is increased by 40 sec.
    razor_fragments           = { 102322, 384790, 1 }, -- When the Trick Shots effect fades or is consumed, or after gaining Deathblow, your next Kill Shot will deal 75% increased damage, and shred up to 5 targets near your Kill Shot target for 25% of the damage dealt by Kill Shot over 6 sec.
    readiness                 = { 102307, 389865, 1 }, -- Trueshot grants Wailing Arrow and you generate 2 additional Wind Arrows while in Trueshot. Wailing Arrow resets the cooldown of Rapid Fire and generates 2 charges of Aimed Shot.
    salvo                     = { 102316, 400456, 1 }, -- Your next Multi-Shot or Volley now also applies Explosive Shot to up to 2 targets hit.
    serpentstalkers_trickery  = { 102315, 378888, 1 }, -- Aimed Shot also fires a Serpent Sting at the primary target.  Serpent Sting Fire a shot that poisons your target, causing them to take 1,836 Nature damage instantly and an additional 13,834 Nature damage over 18 sec.
    small_game_hunter         = { 102325, 459802, 1 }, -- Multi-Shot deals 75% increased damage and Explosive Shot deals 25% increased damage.
    steady_focus              = { 102293, 193533, 1 }, -- Using Steady Shot twice in a row increases your haste by 8% for 15 sec.
    streamline                = { 102308, 260367, 1 }, -- Rapid Fire's damage is increased by 15%, and Rapid Fire also causes your next Aimed Shot to cast 30% faster.
    surging_shots             = { 102320, 391559, 1 }, -- Rapid Fire deals 35% additional damage, and Aimed Shot has a 15% chance to reset the cooldown of Rapid Fire.
    tactical_reload           = { 102311, 400472, 1 }, -- Aimed Shot and Rapid Fire cooldown reduced by 10%.
    trick_shots               = { 102309, 257621, 1 }, -- When Multi-Shot hits 3 or more targets, your next Aimed Shot or Rapid Fire will ricochet and hit up to 5 additional targets for 65% of normal damage.
    trueshot                  = { 102304, 288613, 1 }, -- Reduces the cooldown of your Aimed Shot and Rapid Fire by 70%, and causes Aimed Shot to cast 50% faster for 15 sec. While Trueshot is active, you generate 50% additional Focus.
    unerring_vision           = { 102312, 386878, 1 }, --
    volley                    = { 102317, 260243, 1 }, -- Rain a volley of arrows down over 6 sec, dealing up to 43,036 Physical damage to any enemy in the area, and gain the effects of Trick Shots for as long as Volley is active.
    wailing_arrow             = { 102299, 459806, 1 }, -- After summoning 20 Wind Arrows, your next Aimed Shot becomes a Wailing Arrow. Wailing Arrow

    -- Dark Ranger
    black_arrow               = { 94987, 430703, 1, "dark_ranger" }, -- Fire a Black Arrow into your target, dealing 30,024 Shadow damage over 18 sec. Each time Black Arrow deals damage, you have a 10% chance to generate a charge of Aimed Shot and reduce its cast time by 50%.
    dark_chains               = { 94960, 430712, 1 }, -- Disengage will chain the closest target to the ground, causing them to move 40% slower until they move 8 yards away.
    dark_empowerment          = { 94986, 430718, 1 }, -- When Black Arrow resets the cooldown of an ability, gain 15 Focus.
    darkness_calls            = { 94974, 430722, 1 }, -- All Shadow damage you and your pets deal is increased by 10%.
    death_shade               = { 94968, 430711, 1 }, -- When you apply Black Arrow to a target, you gain the Deathblow effect.
    embrace_the_shadows       = { 94959, 430704, 1 }, -- You heal for 15% of all Shadow damage dealt by you or your pets.
    grave_reaper              = { 94986, 430719, 1 }, -- When a target affected by Black Arrow dies, the cooldown of Black Arrow is reduced by 12 sec.
    overshadow                = { 94961, 430716, 1 }, -- Aimed Shot and Rapid Fire deal 15% increased damage.
    shadow_erasure            = { 94974, 430720, 1 }, -- Kill Shot has a 15% chance to generate a charge of Aimed Shot when used on a target affected by Black Arrow.
    shadow_hounds             = { 94983, 430707, 1 }, -- Each time Black Arrow deals damage, you have a 10% chance to manifest a Dark Hound to charge to your target and deal Shadow damage.
    shadow_lash               = { 94957, 430717, 1 }, -- When Trueshot is active, Black Arrow deals damage 50% faster.
    shadow_surge              = { 94982, 430714, 1 }, -- When Multi-Shot hits a target affected by Black Arrow, a burst of Shadow energy erupts, dealing moderate Shadow damage to all enemies near the target. This can only occur once every 6 sec.
    smoke_screen              = { 94959, 430709, 1 }, -- Exhilaration grants you 3 sec of Survival of the Fittest. Survival of the Fittest activates Exhilaration at 50% effectiveness.
    withering_fire            = { 94993, 430715, 1 }, -- When Black Arrow resets the cooldown of Aimed Shot, a barrage of dark arrows will strike your target for Shadow damage and increase the damage you and your pets deal by 10% for 6 sec.

    -- Sentinel
    catch_out                 = { 94990, 451516, 1 }, -- When a target affected by Sentinel deals damage to you, they are rooted for 3 sec. May only occur every 1 min per target.
    crescent_steel            = { 94980, 451530, 1 }, -- Targets you damage below 20% health gain a stack of Sentinel every 3 sec.
    dont_look_back            = { 94989, 450373, 1 }, -- Each time Sentinel deals damage to an enemy you gain an absorb shield equal to 1% of your maximum health, up to 10%.
    extrapolated_shots        = { 94973, 450374, 1 }, -- When you apply Sentinel to a target not affected by Sentinel, you apply 1 additional stack.
    eyes_closed               = { 94970, 450381, 1 }, -- For 8 sec after activating Trueshot, all abilities are guaranteed to apply Sentinel.
    invigorating_pulse        = { 94971, 450379, 1 }, -- Each time Sentinel deals damage to an enemy it has an up to 15% chance to generate 5 focus. Chances decrease with each additional Sentinel currently imploding applied to enemies.
    lunar_storm               = { 94978, 450385, 1 }, -- Every 15 sec your next Rapid Fire summons a celestial owl that conjures a 10 yd radius Lunar Storm at the target's location for 8 sec. A random enemy affected by Sentinel within your Lunar Storm gets struck for 9,148 Arcane damage every 0.4 sec. Any target struck by this effect takes 10% increased damage from you and your pet for 8 sec.
    overwatch                 = { 94980, 450384, 1 }, -- All Sentinel debuffs implode when a target affected by more than 3 stacks of your Sentinel falls below 20% health.
    release_and_reload        = { 94958, 450376, 1 }, -- When you apply Sentinel on a target, you have a 15% chance to apply a second stack.
    sentinel                  = { 94976, 450369, 1, "sentinel" }, -- Your attacks have a chance to apply Sentinel on the target, stacking up to 10 times. While Sentinel stacks are higher than 3, applying Sentinel has a chance to trigger an implosion, causing a stack to be consumed on the target every sec to deal 9,551 Arcane damage.
    sentinel_precision        = { 94981, 450375, 1 }, -- Aimed Shot and Rapid Fire deal 5% increased damage.
    sentinel_watch            = { 94970, 451546, 1 }, -- Whenever a Sentinel deals damage, the cooldown of Trueshot is reduced by 1 sec, up to 15 sec.
    sideline                  = { 94990, 450378, 1 }, -- When Sentinel starts dealing damage, the target is snared by 40% for 3 sec.
    symphonic_arsenal         = { 94965, 450383, 1 }, -- Multi-Shot discharges arcane energy from all targets affected by your Sentinel, dealing 4,098 Arcane damage to up to 5 targets within 8 yds of your Sentinel targets.
} )


-- Auras
spec:RegisterAuras( {
    a_murder_of_crows = {
        id = 213835,
        duration = 15.0,
        tick_time = 1.0,
        pandemic = true,
        max_stack = 1,
    },
    aspect_of_the_chameleon = {
        id = 61648,
        duration = 60,
        max_stack = 1
    },
    -- Movement speed increased by $w1%.
    -- https://wowhead.com/beta/spell=186257
    aspect_of_the_cheetah_sprint = {
        id = 186257,
        duration = 3,
        max_stack = 1
    },
    -- Movement speed increased by $w1%.
    -- https://wowhead.com/beta/spell=186258
    aspect_of_the_cheetah = {
        id = 186258,
        duration = 9,
        max_stack = 1
    },
    -- The range of $?s259387[Mongoose Bite][Raptor Strike] is increased to $265189r yds.
    -- https://wowhead.com/beta/spell=186289
    aspect_of_the_eagle = {
        id = 186289,
        duration = 15,
        max_stack = 1
    },
    -- Deflecting all attacks.  Damage taken reduced by $w4%.
    -- https://wowhead.com/beta/spell=186265
    aspect_of_the_turtle = {
        id = 186265,
        duration = 8,
        max_stack = 1
    },
    -- Talent:
    -- https://wowhead.com/beta/spell=120360
    barrage = {
        id = 120360,
        duration = 2,
        tick_time = function() return 0.33 * ( 1 - 0.34 * talent.fan_the_hammer.rank ) end,
        max_stack = 1
    },
     -- Lore revealed.
     beast_lore = {
        id = 1462,
        duration = 30.0,
        max_stack = 1,
    },
    -- Dealing $s1% less damage to the Hunter.
    binding_shackles = {
        id = 321469,
        duration = 8.0,
        max_stack = 1,
    },
    -- Taking $w1 Shadow damage every $t1 seconds.
    black_arrow = {
        id = 194599,
        duration = 8.0,
        tick_time = 2.0,
        pandemic = true,
        max_stack = 1,
    },
    -- Bleeding for $w1 Physical damage every $t1 sec.  Taking $s2% increased damage from the Hunter's pet.
    -- https://wowhead.com/beta/spell=321538
    bloodshed = {
        id = 321538,
        duration = 18,
        tick_time = 3,
        max_stack = 1
    },
    bombardment = {
        id = 386875,
        duration = 120,
        max_stack = 1,
    },
    bulletstorm = {
        id = 389020,
        duration = 15,
        max_stack = 10
    },
    -- Talent: Critical strike chance increased by $s1%.
    -- https://wowhead.com/beta/spell=204090
    bullseye = {
        id = 204090,
        duration = 6,
        max_stack = 15
    },
    -- Talent: Movement speed reduced by $s4%.
    -- https://wowhead.com/beta/spell=186387
    bursting_shot = {
        id = 186387,
        duration = 6,
        type = "Ranged",
        max_stack = 1
    },
    -- Talent: Disoriented.
    -- https://wowhead.com/beta/spell=224729
    bursting_shot_disorient = {
        id = 224729,
        duration = 4,
        mechanic = "snare",
        max_stack = 1
    },
    -- Talent: Stealthed.
    -- https://wowhead.com/beta/spell=199483
    camouflage = {
        id = 199483,
        duration = 60,
        max_stack = 1
    },
    -- Rooted.
    catch_out = {
        id = 451517,
        duration = 3.0,
        max_stack = 1,
    },
    -- Taking $w2% increased damage from $@auracaster.
    chakram = {
        id = 375893,
        duration = 10.0,
        max_stack = 1,
    },
    -- Talent: Movement slowed by $s1%.
    -- https://wowhead.com/beta/spell=5116
    concussive_shot = {
        id = 5116,
        duration = 6,
        mechanic = "snare",
        type = "Ranged",
        max_stack = 1
    },
    -- Stunned.
    consecutive_concussion = {
        id = 357021,
        duration = 4.0,
        max_stack = 1,
    },
    -- Your abilities are empowered.    $@spellname187708: Reduces the cooldown of Wildfire Bomb by an additional 1 sec.  $@spellname320976: Applies Bleeding Gash to your target.
    -- https://wowhead.com/beta/spell=361738
    coordinated_assault = {
        id = 361738,
        duration = 5,
        max_stack = 1
    },
    -- Talent: Your next Kill Shot can be used on any target, regardless of their current health.
    -- https://wowhead.com/beta/spell=378770
    deathblow = {
        id = 378770,
        duration = 12,
        max_stack = 1
    },
    --[[ Talent: Your next Aimed Shot will fire a second time instantly at $s4% power and consume no Focus, or your next Rapid Fire will shoot $s3% additional shots during its channel.
    -- https://wowhead.com/beta/spell=260402
    double_tap = {
        id = 260402,
        duration = 15,
        max_stack = 1
    }, ]]
    -- Vision is enhanced.
    -- https://wowhead.com/beta/spell=6197
    eagle_eye = {
        id = 6197,
        duration = 60,
        type = "Magic",
        max_stack = 1
    },
    -- Rooted.
    entrapment = {
        id = 393456,
        duration = 4.0,
        max_stack = 1,
    },
    -- Talent: Exploding for $212680s1 Fire damage after $t1 sec.
    -- https://wowhead.com/beta/spell=212431
    explosive_shot = {
        id = 212431,
        duration = 3,
        tick_time = 3,
        type = "Ranged",
        max_stack = 1
    },
    -- All abilities are guaranteed to apply Sentinel.
    eyes_closed = {
        id = 451180,
        duration = 8.0,
        max_stack = 1,
    },
    -- Directly controlling pet.
    -- https://wowhead.com/beta/spell=321297
    eyes_of_the_beast = {
        id = 321297,
        duration = 60,
        type = "Magic",
        max_stack = 1
    },
    -- Feigning death.
    -- https://wowhead.com/beta/spell=5384
    feign_death = {
        id = 5384,
        duration = 360,
        max_stack = 1
    },
    -- Covenant: Bleeding for $s1 Shadow damage every $t1 sec.
    -- https://wowhead.com/beta/spell=324149
    flayed_shot = {
        id = 324149,
        duration = 18,
        tick_time = 2,
        mechanic = "bleed",
        type = "Ranged",
        max_stack = 1
    },
    freezing_trap = {
        id = 3355,
        duration = 60,
        max_stack = 1,
    },
    -- Can always be seen and tracked by the Hunter.; Damage taken increased by $428402s4% while above $s3% health.
    -- https://wowhead.com/beta/spell=257284
    hunters_mark = {
        id = 257284,
        duration = 3600,
        tick_time = 0.5,
        type = "Magic",
        max_stack = 1
    },
    in_the_rhythm = {
        id = 407405,
        duration = 6,
        max_stack = 1
    },
    -- Talent: Bleeding for $w2 damage every $t2 sec.
    -- https://wowhead.com/beta/spell=259277
    kill_command = {
        id = 259277,
        duration = 8,
        max_stack = 1
    },
    -- $@auracaster can attack this target regardless of line of sight.; $@auracaster deals $w2% increased damage to this target.
    kill_zone = {
        id = 393480,
        duration = 3600,
        max_stack = 1,
    },
    -- Injected with Latent Poison. $?s137015[Barbed Shot]?s137016[Aimed Shot]?s137017&!s259387[Raptor Strike][Mongoose Bite]  consumes all stacks of Latent Poison, dealing ${$378016s1/$s1} Nature damage per stack consumed.
    -- https://wowhead.com/beta/spell=378015
    latent_poison = {
        id = 378015,
        duration = 15,
        max_stack = 10
    },
   -- Talent: Aimed Shot costs no Focus and is instant.
    -- https://wowhead.com/beta/spell=194594
    lock_and_load = {
        id = 194594,
        duration = 15,
        max_stack = 1
    },
    lone_wolf = {
        id = 164273,
        duration = 3600,
        max_stack = 1,
    },
    -- Damage taken from $@auracaster and their pets increased by $w1%.
    lunar_storm = {
        id = 450884,
        duration = 8.0,
        max_stack = 1,
    },
    -- Talent: Threat redirected from Hunter.
    -- https://wowhead.com/beta/spell=34477
    misdirection = {
        id = 34477,
        duration = 30,
        max_stack = 1
    },
    -- Damage taken reduced by $w1%
    no_hard_feelings = {
        id = 459547,
        duration = 5.0,
        max_stack = 1,
    },
    pathfinding = {
        id = 264656,
        duration = 3600,
        max_stack = 1,
    },
    -- Suffering $w1 Fire damage every $t1 sec.
    -- https://wowhead.com/beta/spell=270332
    pheromone_bomb = {
        id = 270332,
        duration = 6,
        tick_time = 1,
        type = "Ranged",
        max_stack = 1
    },
    -- Talent: Increased movement speed by $s1%.
    -- https://wowhead.com/beta/spell=118922
    posthaste = {
        id = 118922,
        duration = 4,
        max_stack = 1
    },
    -- Damage of $?s342049[Chimaera Shot][Arcane Shot] or Multi-Shot increased by $s1 and their Focus cost is reduced by $s6%.
    precise_shots = {
        id = 260242,
        duration = 15,
        max_stack = 2
    },
    -- Recently benefitted from Quick Load.
    quick_load = {
        id = 385646,
        duration = 25.0,
        max_stack = 1,
        copy = "quick_load_icd"
    },
    rangers_finesse = {
        id = 408518,
        duration = 18,
        max_stack = 3
    },
    -- Talent: Being targeted by Rapid Fire.
    -- https://wowhead.com/beta/spell=257044
    rapid_fire = {
        id = 257044,
        duration = function () return 2 * haste end,
        tick_time = function ()
            return ( 2 * haste ) * ( 1 - 0.34 * talent.fan_the_hammer.rank ) / 7
        end,
        type = "Ranged",
        max_stack = 1
    },
    -- Your next Kill Shot will deal 75% increased damage, and shred up to 5 targets near your Kill shot target for 25% of the damage dealt by Kill Shot over 6 sec.
    razor_fragments = {
        id = 388998,
        duration = 15,
        max_stack = 1,
    },
    -- Bleeding for $w1 damage every $t1 sec.
    razor_fragments_bleed = {
        id = 385638,
        duration = 6,
        tick_time = 2,
        mechanic = "bleed",
        max_stack = 1
    },
    -- Heals you for $w1 every $t sec.
    rejuvenating_wind = {
        id = 385540,
        duration = 8.0,
        max_stack = 1,
    },
    salvo = {
        id = 400456,
        duration = 15,
        max_stack = 1
    },
    -- Talent: Feared.
    -- https://wowhead.com/beta/spell=1513
    scare_beast = {
        id = 1513,
        duration = 20,
        mechanic = "flee",
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Disoriented.
    -- https://wowhead.com/beta/spell=213691
    scatter_shot = {
        id = 213691,
        duration = 4,
        type = "Ranged",
        max_stack = 1
    },
    -- $w1% reduced movement speed.
    scorpid_venom = {
        id = 356723,
        duration = 3.0,
        max_stack = 1,
    },
    -- Sentinel from $@auracaster has a chance to start dealing $450412s1 Arcane damage every sec.
    sentinel = {
        id = 450387,
        duration = 1200.0,
        max_stack = 1,
    },
    -- Leech increased by $s1%.
    sentinels_protection = {
        id = 393777,
        duration = 12.0,
        max_stack = 1,
    },
    -- Movement slowed by $w1%.
    sideline = {
        id = 450845,
        duration = 3.0,
        max_stack = 1,
    },
    -- Range of all shots increased by $w3%.
    sniper_shot = {
        id = 203155,
        duration = 6.0,
        max_stack = 1,
    },
    -- Talent: Haste increased by $s1%.
    -- https://wowhead.com/beta/spell=193534
    steady_focus = {
        id = 193534,
        duration = 15,
        max_stack = 1
    },
    -- Talent: Bleeding for $w1 damage every $t1 seconds.
    -- https://wowhead.com/beta/spell=162487
    steel_trap = {
        id = 162487,
        duration = 20,
        tick_time = 2,
        mechanic = "bleed",
        type = "Ranged",
        max_stack = 1
    },
    -- Talent: Aimed Shot cast time reduced by $s1%.
    -- https://wowhead.com/beta/spell=342076
    streamline = {
        id = 342076,
        duration = 15,
        max_stack = 1
    },
    survival_of_the_fittest = {
        id = 281195,
        duration = function() return 6 + 2 * talent.lone_survivor.rank end,
        max_stack = 1,
    },
    -- Taming a pet.
    tame_beast = {
        id = 1515,
        duration = 6.0,
        pandemic = true,
        max_stack = 1,
    },
    tar_trap = {
        id = 135299,
        duration = 30,
        max_stack = 1
    },
    -- Dealing bonus Nature damage to the target every $t sec for $d.
    titans_thunder = {
        id = 207094,
        duration = 8.0,
        tick_time = 1.0,
        max_stack = 1,
    },
    trailblazer = {
        id = 231390,
        duration = 3600,
        max_stack = 1,
    },
    trick_shots = {
        id = 257622,
        duration = 20,
        max_stack = 1
    },
    trueshot = {
        id = 288613,
        duration = function () return ( 15 + ( legendary.eagletalons_true_focus.enabled and 3 or 0 ) + ( 3 * talent.eagletalons_true_focus.rank ) ) * ( 1 + ( conduit.sharpshooters_focus.mod * 0.01 ) ) end,
        max_stack = 1,
    },
    -- Talent: Critical strike chance increased by $s1%. Critical damage dealt increased by $s2%.
    -- https://wowhead.com/beta/spell=386877
    unerring_vision = {
        id = 386877,
        duration = 60,
        max_stack = 10,
        copy = 274447 -- Azerite.
    },
    -- Talent: Raining arrows down in the target area.
    -- https://wowhead.com/beta/spell=260243
    volley = {
        id = 260243,
        duration = 6,
        max_stack = 1
    },
    -- Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=195645
    wing_clip = {
        id = 195645,
        duration = 15,
        max_stack = 1
    },

    -- Conduit
    brutal_projectiles = {
        id = 339929,
        duration = 3600,
        max_stack = 1,
    },

    -- Legendaries
    nessingwarys_trapping_apparatus = {
        id = 336744,
        duration = 5,
        max_stack = 1,
        copy = { "nesingwarys_trapping_apparatus", "nesingwarys_apparatus", "nessingwarys_apparatus" }
    },
    secrets_of_the_unblinking_vigil = {
        id = 336892,
        duration = 20,
        max_stack = 1,
    },

    -- stub.
    eagletalons_true_focus_stub = {
        duration = 10,
        max_stack = 1,
        copy = "eagletalons_true_focus"
    }
} )


spec:RegisterStateExpr( "ca_execute", function ()
    return talent.careful_aim.enabled and ( target.health.pct > 70 )
end )

spec:RegisterStateExpr( "ca_active", function ()
    return talent.careful_aim.enabled and ( target.health.pct > 70 )
end )


local steady_focus_applied = 0
local steady_focus_casts = 0
local bombardment_arcane_shots = 0
local lunar_storm_expires = 0

spec:RegisterCombatLogEvent( function( _, subtype, _,  sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID, spellName )

    if sourceGUID == state.GUID then
        if ( subtype == "SPELL_AURA_APPLIED" or subtype == "SPELL_AURA_REFRESH" or subtype == "SPELL_AURA_APPLIED_DOSE" ) then
            if spellID == 193534 then -- Steady Aim.
                steady_focus_applied = GetTime()
                steady_focus_casts = 0
            elseif spellID == 378880 then
                bombardment_arcane_shots = 0
            elseif spellID == 450978 then
                lunar_storm_expires = GetTime() + 13.7
            end
        elseif subtype == "SPELL_CAST_SUCCESS" then
            if spellID == 185358 and state.talent.bombardment.enabled then
                bombardment_arcane_shots = ( bombardment_arcane_shots + 1 ) % 4
            end
        
            if state.talent.steady_focus.enabled then
                if spellID == 56641 and GetTime() - steady_focus_applied > 0.5 then
                    steady_focus_casts = ( steady_focus_casts + 1 ) % 2
                elseif class.abilities[ spellName ] and class.abilities[ spellName ].gcd ~= "off" then
                    steady_focus_casts = 0
                end
            end
        end
    end
end )

spec:RegisterStateExpr( "last_steady_focus", function ()
    return steady_focus_applied
end )

spec:RegisterStateExpr( "steady_focus_count", function ()
    return steady_focus_casts
end )

spec:RegisterStateExpr( "bombardment_count", function ()
    return bombardment_arcane_shots
end )


local ExpireNesingwarysTrappingApparatus = setfenv( function()
    focus.regen = focus.regen * 0.5
    forecastResources( "focus" )
end, state )


spec:RegisterStateTable( "tar_trap", setmetatable( {}, {
    __index = function( t, k )
        return state.debuff.tar_trap[ k ]
    end
} ) )


spec:RegisterGear( "tier29", 200390, 200392, 200387, 200389, 200391 )
spec:RegisterAuras( {
    -- 2pc
    find_the_mark = {
        id = 394366,
        duration = 15,
        max_stack = 1
    },
    hit_the_mark = {
        id = 394371,
        duration = 6,
        max_stack = 1
    },
    -- 4pc
    focusing_aim = {
        id = 394384,
        duration = 15,
        max_stack = 1
    }
} )

spec:RegisterGear( "tier30", 202482, 202480, 202479, 202478, 202477 )
spec:RegisterGear( "tier31", 207216, 207217, 207218, 207219, 207221, 217183, 217185, 217181, 217182, 217184 )




spec:RegisterHook( "reset_precast", function ()
    if debuff.tar_trap.up then
        debuff.tar_trap.expires = debuff.tar_trap.applied + 30
    end

    if buff.nesingwarys_apparatus.up then
        state:QueueAuraExpiration( "nesingwarys_apparatus", ExpireNesingwarysTrappingApparatus, buff.nesingwarys_apparatus.expires )
    end

    if legendary.eagletalons_true_focus.enabled then
        rawset( buff, "eagletalons_true_focus", buff.trueshot_aura )
    else
        rawset( buff, "eagletalons_true_focus", buff.eagletalons_true_focus_stub )
    end

    if now - action.volley.lastCast < 6 then applyBuff( "volley", 6 - ( now - action.volley.lastCast ) ) end

    if now - action.resonating_arrow.lastCast < 6 then applyBuff( "resonating_arrow", 10 - ( now - action.resonating_arrow.lastCast ) ) end

    last_steady_focus = nil
    steady_focus_count = nil

    if lunar_storm_expires > query_time then setCooldown( "lunar_storm", lunar_storm_expires - query_time ) end

    -- If the last GCD ability wasn't Stready Shot, reset the counter.
    if talent.steady_focus.enabled and steady_focus_count > 0 and prev_gcd.last ~= "steady_shot" then
        if Hekili.ActiveDebug then Hekili:Debug( "Resetting Steady Focus counter as last GCD spell was '%s'.", ( prev_gcd.last or "Unknown" ) ) end
        steady_focus_count = 0
    end
end )

spec:RegisterHook( "runHandler", function( token )
    if talent.steady_focus.enabled then
        if token == "steady_shot" then
            steady_focus_count = steady_focus_count + 1

            if steady_focus_count == 2 then
                applyBuff( "steady_focus" )
                steady_focus_count = 0
            end
        elseif class.abilities[ token ] and class.abilities[ token ].gcd ~= "off" then
            steady_focus_count = 0
        end
    end
end )


-- Abilities
spec:RegisterAbilities( {
    -- Trait: A powerful aimed shot that deals $s1 Physical damage$?s260240[ and causes your next 1-$260242u ][]$?s342049&s260240[Chimaera Shots]?s260240[Arcane Shots][]$?s260240[ or Multi-Shots to deal $260242s1% more damage][].$?s260228[    Aimed Shot deals $393952s1% bonus damage to targets who are above $260228s1% health.][]$?s378888[    Aimed Shot also fires a Serpent Sting at the primary target.][]
    aimed_shot = {
        id = 19434,
        cast = function ()
            if buff.lock_and_load.up then return 0 end
            return 2.5 * haste * ( buff.rapid_fire.up and 0.7 or 1 ) * ( buff.trueshot.up and 0.5 or 1 ) * ( buff.streamline.up and ( 1 - 0.15 * talent.streamline.rank ) or 1 )
        end,
        charges = 2,
        cooldown = function () return haste * ( buff.trueshot.up and 4.8 or 12 ) * ( 1 - 0.1 * talent.tactical_reload.rank ) end,
        recharge = function () return haste * ( buff.trueshot.up and 4.8 or 12 ) * ( 1 - 0.1 * talent.tactical_reload.rank ) end,
        gcd = "spell",
        school = "physical",

        spend = function ()
            if buff.lock_and_load.up or buff.secrets_of_the_unblinking_vigil.up then return 0 end
            return 35 * ( buff.trueshot.up and legendary.eagletalons_true_focus.enabled and 0.75 or 1 ) * ( buff.trueshot.up and ( 1 - 0.5 * talent.eagletalons_true_focus.rank ) or 1 )
        end,
        spendType = "focus",

        talent = "aimed_shot",
        startsCombat = true,

        usable = function ()
            if action.aimed_shot.cast > 0 and moving and settings.prevent_hardcasts then return false, "prevent_hardcasts is checked and player is moving" end
            return true
        end,

        handler = function ()
            if buff.lock_and_load.up then removeBuff( "lock_and_load" )
            elseif buff.secrets_of_the_unblinking_vigil.up then removeBuff( "secrets_of_the_unblinking_vigil" ) end
            if talent.precise_shots.enabled then applyBuff( "precise_shots" ) end
            if talent.bulletstorm.enabled and buff.trick_shots.up then
                addStack( "bulletstorm", nil, min( 8 - 2 * talent.heavy_ammo.rank + 2 * talent.light_ammo.rank, true_active_enemies ) )
            end
            if buff.find_the_mark.up then
                removeBuff( "find_the_mark" )
                applyDebuff( "target", "hit_the_mark" )
            end
            if buff.volley.down and buff.trick_shots.up then
                removeBuff( "trick_shots" )
                if talent.razor_fragments.enabled then applyBuff( "razor_fragments" ) end
            end
            if pvptalent.rangers_finesse.enabled then addStack( "rangers_finesse" ) end
        end,
    },

    -- A quick shot that causes $sw2 Arcane damage.$?s260393[    Arcane Shot has a $260393h% chance to reduce the cooldown of Rapid Fire by ${$260393m1/10}.1 sec.][]
    arcane_shot = {
        id = 185358,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "arcane",

        spend = function () return ( talent.crack_shot.enabled and 20 or 40 ) * ( buff.trueshot.up and legendary.eagletalons_true_focus.enabled and 0.75 or 1 ) end,
        spendType = "focus",

        startsCombat = true,

        notalent = "chimaera_shot",

        handler = function ()
            removeBuff( "focusing_aim" )
            removeStack( "precise_shots" )

            if talent.bombardment.enabled then
                if bombardment_count == 3 then
                    applyBuff( "bombardment" )
                    bombardment_count = 0
                else
                    bombardment_count = bombardment_count + 1
                end
            end
        end,
    },

    -- The Hunter takes on the aspect of a chameleon, becoming untrackable.
    aspect_of_the_chameleon = {
        id = 61648,
        cast = 0.0,
        cooldown = 180.0,
        gcd = "spell",

        startsCombat = false,

        handler = function ()
            applyBuff( "aspect_of_the_chameleon" )
        end,
    },

    -- Increases your movement speed by $s1% for $d, and then by $186258s1% for another $186258d$?a445701[, and then by $445701s1% for another $445701s2 sec][].$?a459455[; You cannot be slowed below $s2% of your normal movement speed.][]
    aspect_of_the_cheetah = {
        id = 186257,
        cast = 0.0,
        cooldown = function() return ( 180.0 - 30 * talent.born_to_be_wild.rank ) * ( talent.hunting_pack.enabled and 0.5 or 1 ) end,
        gcd = "off",

        startsCombat = false,

        handler = function ()
            applyBuff( "aspect_of_the_cheetah" )
        end,
    },

    -- Deflects all attacks and reduces all damage you take by $s4% for $d, but you cannot attack.$?s83495[  Additionally, you have a $83495s1% chance to reflect spells back at the attacker.][]
    aspect_of_the_turtle = {
        id = 186265,
        cast = 0.0,
        cooldown = function() return 180.0 - 30 * talent.born_to_be_wild.rank end,
        gcd = "off",

        startsCombat = false,

        handler = function ()
            applyBuff( "aspect_of_the_turtle" )
        end,
    },

    -- Talent: Rapidly fires a spray of shots for $120360d, dealing an average of $<damageSec> Physical damage to all nearby enemies in front of you. Usable while moving. Deals reduced damage beyond $120361s1 targets.
    barrage = {
        id = function() return talent.rapid_fire_barrage.enabled and 459796 or 120360 end,
        cast = function() return ( talent.rapid_fire_barrage.enabled and 2 or 3 ) * haste end,
        channeled = true,
        cooldown = function() return 20 + 40 * talent.rapid_fire_barrage.rank end,
        gcd = "spell",
        school = "physical",

        spend = function () return ( state.spec.marksmanship and 30 or 60 ) * ( legendary.eagletalons_true_focus.enabled and buff.trueshot.up and 0.75 or 1 ) end,
        spendType = "focus",

        talent = "barrage",
        startsCombat = true,

        start = function ()
            applyBuff( "barrage" )
        end,

        copy = { 120360, 459796, "rapid_fire_barrage" }
    },

    -- Talent: Fires a magical projectile, tethering the enemy and any other enemies within $s2 yards for $d, stunning them for $117526d if they move more than $s2 yards from the arrow.$?s321468[    Targets stunned by Binding Shot deal $321469s1% less damage to you for $321469d after the effect ends.][]
    binding_shot = {
        id = 109248,
        cast = 0,
        cooldown = 45,
        gcd = "spell",
        school = "nature",

        talent = "binding_shot",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "binding_shot" )
        end,
    },

    -- Fire a Black Arrow into your target, dealing $o1 Shadow damage over $d.; Each time Black Arrow deals damage, you have a $s2% chance to generate a charge of $?a137015[Barbed Shot]?a137016[Aimed Shot and reduce its cast time by $439659s2%][Barbed Shot or Aimed Shot].
    black_arrow = {
        id = 430703,
        cast = 0.0,
        cooldown = 30.0,
        gcd = "spell",

        spend = 10,
        spendType = 'focus',

        talent = "black_arrow",
        startsCombat = true,

        handler = function()
            applyDebuff( "target", "black_arrow" )
        end,
    },

    -- Talent: Fires an explosion of bolts at all enemies in front of you, knocking them back, snaring them by $s4% for $d, and dealing $s1 Physical damage.$?s378771[    When you fall below $378771s1% heath, Bursting Shot's cooldown is immediately reset. This can only occur once every $385646d.][]
    bursting_shot = {
        id = 186387,
        cast = 0,
        cooldown = 30,
        gcd = "spell",
        school = "physical",

        spend = function () return 10 * ( legendary.eagletalons_true_focus.enabled and buff.trueshot.up and 0.75 or 1 ) end,
        spendType = "focus",

        talent = "bursting_shot",
        startsCombat = true,

        handler = function ()
            if buff.rangers_finesse.stack == 3 then
                removeBuff( "rangers_finesse" )
                reduceCooldown( "aspect_of_the_turtle", 20 )
            end
            applyBuff( "bursting_shot" )
        end,
    },

    -- Throw a deadly chakram at your current target that will rapidly deal $375893s1 Physical damage $x times, bouncing to other targets if they are nearby. Enemies struck by Death Chakram take $375893s2% more damage from you and your pet for $375893d.; Each time the chakram deals damage, its damage is increased by $s3% and you generate $s4 Focus.
    chakram = {
        id = 375891,
        cast = 0.0,
        cooldown = 45.0,
        gcd = "spell",

        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "chakram" )
        end,
    },

    -- Talent: A two-headed shot that hits your primary target for $344120sw1 Nature damage and another nearby target for ${$344121sw1*($s1/100)} Frost damage.$?s260393[    Chimaera Shot has a $260393h% chance to reduce the cooldown of Rapid Fire by ${$260393m1/10}.1 sec.][]
    chimaera_shot = {
        id = 342049,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = function () return ( talent.crack_shot.enabled and 20 or 40 ) * ( buff.trueshot.up and legendary.eagletalons_true_focus.enabled and 0.75 or 1 ) * ( buff.precise_shots.up and 0.5 or 1 ) end,
        spendType = "focus",

        talent = "chimaera_shot",
        startsCombat = true,

        handler = function ()
            removeBuff( "focusing_aim" )
            removeStack( "precise_shots" )
        end,
    },

    -- Stings the target, dealing $s1 Nature damage and initiating a series of venoms. Each lasts $356723d and applies the next effect after the previous one ends.; $@spellicon356723 $@spellname356723:; $356723s1% reduced movement speed.; $@spellicon356727 $@spellname356727:; Silenced.; $@spellicon356730 $@spellname356730:; $356730s1% reduced damage and healing.
    chimaeral_sting = {
        id = 356719,
        cast = 0,
        cooldown = 60,
        gcd = "spell",

        pvptalent = "chimaeral_sting",
        startsCombat = false,
        texture = 132211,

        toggle = "cooldowns",

        handler = function ()
            applyDebuff( "target", "scorpid_venom" )
        end,

        auras = {
            scorpid_venom = {
                id = 356723,
                duration = 3,
                max_stack = 1
            },
            spider_venom = {
                id = 356727,
                duration = 3,
                max_stack = 1
            },
            viper_venom = {
                id = 356730,
                duration = 3,
                max_stack = 1
            }
        }
    },

    -- Talent: Dazes the target, slowing movement speed by $s1% for $d.    $?s193455[Cobra Shot][Steady Shot] will increase the duration of Concussive Shot on the target by ${$56641m3/10}.1 sec.
    concussive_shot = {
        id = 5116,
        cast = 0,
        cooldown = 5,
        gcd = "spell",
        school = "physical",

        talent = "concussive_shot",
        startsCombat = true,

        handler = function ()
            applyBuff( "concussive_shot" )
        end,
    },

    --[[ Removed in 10.0.5 -- Talent: Your next Aimed Shot will fire a second time instantly at $s4% power without consuming Focus, or your next Rapid Fire will shoot $s3% additional shots during its channel.
    double_tap = {
        id = 260402,
        cast = 0,
        cooldown = 60,
        gcd = "spell",
        school = "physical",

        talent = "double_tap",
        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "double_tap" )
        end,
    }, ]]


    interlope = {
        id = 248518,
        cast = 0,
        cooldown = 45,
        gcd = "off",

        pvptalent = "interlope",
        startsCombat = false,
        texture = 132180,

        handler = function ()
        end,
    },


    -- Talent: You attempt to finish off a wounded target, dealing $s1 Physical damage. Only usable on enemies with less than $s2% health.$?s343248[    Kill Shot deals $343248s1% increased critical damage.][]
    kill_shot = {
        id = 53351,
        cast = 0,
        charges = function() return talent.deadeye.enabled and 2 or nil end,
        cooldown = 10,
        recharge = function() return talent.deadeye.enabled and 7 or nil end,
        gcd = "spell",
        school = "physical",

        spend = function () return buff.flayers_mark.up and 0 or 10 end,
        spendType = "focus",

        talent = "kill_shot",
        startsCombat = true,

        usable = function () return buff.deathblow.up or buff.hunters_prey.up or buff.flayers_mark.up or target.health_pct < 20, "requires flayers_mark/hunters_prey or target health below 20 percent" end,
        handler = function ()
            if buff.razor_fragments.up then
                removeBuff( "razor_fragments" )
                applyDebuff( "target", "razor_fragments_bleed" )
            end
            if buff.flayers_mark.up and legendary.pouch_of_razor_fragments.enabled then
                applyDebuff( "target", "pouch_of_razor_fragments" )
            else
                removeBuff( "hunters_prey" )
                if buff.deathblow.up then
                    removeBuff( "deathblow" )
                    if talent.razor_fragments.enabled then applyBuff( "razor_fragments" ) end
                end
            end
            removeBuff( "flayers_mark" )

            if set_bonus.tier30_4pc > 0 then
                reduceCooldown( "aimed_shot", 1.5 )
                reduceCooldown( "rapid_fire", 1.5 )
            end
        end,
    },

    lunar_storm = {
        cast = 0,
        cooldown = 13.7,
        gcd = "off",
        hidden = true,
    },

    -- Talent: Fires several missiles, hitting your current target and all enemies within $A1 yards for $s1 Physical damage. Deals reduced damage beyond $2643s1 targets.$?s260393[    Multi-Shot has a $260393h% chance to reduce the cooldown of Rapid Fire by ${$260393m1/10}.1 sec.][]
    multishot = {
        id = 257620,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "physical",

        spend = function () return 30 * ( buff.trueshot.up and legendary.eagletalons_true_focus.enabled and 0.75 or 1 ) * ( buff.precise_shots.up and 0.5 or 1 ) end,
        spendType = "focus",

        talent = "multishot",
        startsCombat = true,

        handler = function ()
            removeBuff( "bulletstorm" )
            removeBuff( "focusing_aim" )
            removeStack( "precise_shots" )

            if buff.bombardment.up then
                applyBuff( "trick_shots" )
                removeBuff( "bombardment" )
            end

            if buff.salvo.up then
                applyDebuff( "target", "explosive_shot" )
                if active_enemies > 1 and active_dot.explosive_shot < active_enemies then active_dot.explosive_shot = active_dot.explosive_shot + 1 end
                removeBuff( "salvo" )
            end

            if talent.trick_shots.enabled and active_enemies > 2 then applyBuff( "trick_shots" ) end
        end,
    },

    -- Talent: Shoot a stream of $s1 shots at your target over $d, dealing a total of ${$m1*$257045sw1} Physical damage.  Usable while moving.$?s260367[    Rapid Fire causes your next Aimed Shot to cast $342076s1% faster.][]    |cFFFFFFFFEach shot generates $263585s1 Focus.|r
    rapid_fire = {
        id = 257044,
        cast = function () return ( 2 * haste ) end,
        channeled = true,
        cooldown = function() return 20 * ( buff.trueshot.up and 0.3 or 1 ) * ( 1 - 0.1 * talent.tactical_reload.rank ) end,
        gcd = "spell",
        school = "physical",

        talent = "rapid_fire",
        startsCombat = true,

        start = function ()
            removeBuff( "brutal_projectiles" )
            applyBuff( "rapid_fire" )
            if set_bonus.tier31_2pc > 0 then applyBuff( "volley", 2 * haste ) end
            if talent.bulletstorm.enabled and buff.trick_shots.up then
                addStack( "bulletstorm", nil, min( 8 - 2 * talent.heavy_ammo.rank + 2 * talent.light_ammo.rank, true_active_enemies ) )
            end
            if talent.lunar_storm.enabled and cooldown.lunar_storm.ready then
                setCooldown( "lunar_storm", 13.7 )
                applyDebuff( "target", "lunar_storm" )
            end
            if talent.streamline.enabled then applyBuff( "streamline" ) end
        end,

        finish = function ()
            if buff.volley.down then
                removeBuff( "trick_shots" )
                if talent.razor_fragments.enabled then applyBuff( "razor_fragments" ) end
            end

            if talent.in_the_rhythm.up then applyBuff( "in_the_rhythm" ) end
        end,
    },

    -- Your next Multi-Shot or Volley now also applies Explosive Shot to up to 2 targets hit.
    salvo = {
        id = 400456,
        cast = 0,
        cooldown = 45,
        gcd = "off",

        talent = "salvo",
        startsCombat = false,
        texture = 1033904,

        handler = function ()
            applyBuff( "salvo" )
        end,
    },

    sniper_shot = {
        id = 203155,
        cast = 3,
        cooldown = 10,
        gcd = "spell",

        spend = 40,
        spendType = "focus",

        pvptalent = "sniper_shot",
        startsCombat = false,
        texture = 1412205,

        handler = function ()
        end,
    },

    -- Talent: Summon a herd of stampeding animals from the wilds around you that deal ${$201594s1*6} Physical damage to your enemies over $d.    Enemies struck by the stampede are snared by $201594s2%, and you have $201594s3% increased critical strike chance against them for $201594d.
    stampede = {
        id = 201430,
        cast = 0,
        cooldown = 120,
        gcd = "spell",
        school = "physical",

        talent = "stampede",
        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "stampede" )
        end,
    },

    -- A steady shot that causes $s1 Physical damage.    Usable while moving.$?s321018[    |cFFFFFFFFGenerates $s2 Focus.|r][]
    steady_shot = {
        id = 56641,
        cast = 1.7,
        cooldown = 0,
        gcd = "spell",

        spend = function () return talent.improved_steady_shot.enabled and ( buff.trueshot.up and -15 or -10 ) or 0 end,
        spendType = "focus",

        startsCombat = true,
        texture = 132213,

        handler = function ()
            if debuff.concussive_shot.up then debuff.concussive_shot.expires = debuff.concussive_shot.expires + 3 end
        end,
    },

    -- Talent: Reduces the cooldown of your Aimed Shot and Rapid Fire by ${100*(1-(100/(100+$m1)))}%, and causes Aimed Shot to cast $s4% faster for $d.    While Trueshot is active, you generate $s5% additional Focus$?s386878[ and you gain $386877s1% critical strike chance and $386877s2% increased critical damage dealt every $386876t1 sec, stacking up to $386877u times.][].$?s260404[    Every $260404s2 Focus spent reduces the cooldown of Trueshot by ${$260404m1/1000}.1 sec.][]
    trueshot = {
        id = 288613,
        cast = 0,
        cooldown = 120,
        gcd = "off",
        school = "physical",

        talent = "trueshot",
        startsCombat = false,

        toggle = "cooldowns",

        nobuff = function ()
            if settings.trueshot_vop_overlap then return end
            return "trueshot"
        end,

        handler = function ()
            focus.regen = focus.regen * 1.5
            reduceCooldown( "aimed_shot", ( 1 - 0.3077 ) * 12 * haste )
            reduceCooldown( "rapid_fire", ( 1 - 0.3077 ) * 20 * haste )
            applyBuff( "trueshot" )

            if azerite.unerring_vision.enabled or talent.unerring_vision.enabled then
                applyBuff( "unerring_vision" )
            end
        end,

        meta = {
            duration_guess = function( t )
                return talent.calling_the_shots.enabled and 90 or t.duration
            end,
        }
    },

    -- Talent: Rain a volley of arrows down over $d, dealing up to ${$260247s1*12} Physical damage to any enemy in the area, and gain the effects of Trick Shots for as long as Volley is active.
    volley = {
        id = 260243,
        cast = 0,
        cooldown = 45,
        gcd = "spell",
        school = "physical",

        talent = "volley",
        startsCombat = true,

        handler = function ()
            applyBuff( "volley" )
            applyBuff( "trick_shots", 6 )

            if buff.salvo.up then
                applyDebuff( "target", "explosive_shot" )
                if active_enemies > 1 and active_dot.explosive_shot < active_enemies then active_dot.explosive_shot = active_dot.explosive_shot + 1 end
                removeBuff( "salvo" )
            end

            if buff.rangers_finesse.stack == 3 then
                removeBuff( "rangers_finesse" )
                reduceCooldown( "aspect_of_the_turtle", 20 )
            end
        end,
    },


    wild_kingdom = {
        id = 356707,
        cast = 0,
        cooldown = 60,
        gcd = "spell",

        pvptalent = "wild_kingdom",
        startsCombat = false,
        texture = 236159,

        toggle = "cooldowns",

        handler = function ()
        end,
    },
} )

spec:RegisterRanges( "aimed_shot", "scatter_shot", "wing_clip", "arcane_shot" )

spec:RegisterOptions( {
    enabled = true,

    aoe = 3,
    cycle = false,

    nameplates = false,
    nameplateRange = 40,
    rangeFilter = false,

    damage = true,
    damageExpiration = 6,

    potion = "spectral_agility",

    package = "Marksmanship",
} )


local beastMastery = class.specs[ 253 ]

spec:RegisterSetting( "mark_any", false, {
    name = strformat( "%s Any Target", Hekili:GetSpellLinkWithTexture( beastMastery.abilities.hunters_mark.id ) ),
    desc = strformat( "If checked, %s may be recommended for any target rather than only bosses.", Hekili:GetSpellLinkWithTexture( beastMastery.abilities.hunters_mark.id ) ),
    type = "toggle",
    width = "full"
} )

spec:RegisterSetting( "prevent_hardcasts", false, {
    name = "Prevent Hardcasts While Moving",
    desc = "If checked, the addon will not recommend |T135130:0|t Aimed Shot or |T132323:0|t Wailing Arrow when moving and hardcasting.",
    type = "toggle",
    width = "full"
} )

--[[ spec:RegisterSetting( "eagletalon_swap", false, {
    name = "Use |T132329:0|t Trueshot with Eagletalon's True Focus Runeforge",
    desc = "If checked, the default priority includes usage of |T132329:0|t Trueshot pre-pull, assuming you will successfully swap " ..
        "your legendary on your own.  The addon will not tell you to swap your gear.",
    type = "toggle",
    width = "full",
} ) ]]


spec:RegisterPack( "Marksmanship", 20240822, [[Hekili:T31)VnUnY()wwuCEJrY6yRSz7U9fBG31dlEDX1EfV0(6VzBfB5y9ISKpj5Knfb6V9Bgskj(DrjhVB2cd0UjrKC4WHd)mdhnIC6OP)20Rx6Nhm9x8g692HV3ZBWO3pA0BF30RZFCBW0R36V4o)BHFj2Fd8V)SF6DzB8JZwhUfl8XOe)LirYs2LUaQW3vmFDE(2SF48ZVnmF9UBgSizZ5zHB2f5NhMeVi1Fvo(3loF613Slmk)NINEJwM4IlNET)U81jPtV(6Wn)40RxhUCzaT6bzlMEnw93m89Vz0LNvm3Z7hkMJ1Ry(UTi5k(uXNQQXiSW8a)Lpwm)Jjl2Lvmpjoc(JWvfZZ9JcIZdwY3IHFaAXVtieu3vPjByuNVoiv)9SGI5)p7G2N(AOMOeQyEwqEEy8T1v(7FJ33dv(NdJtsHId3uYL)xWVOHc8n8cOH)2AOo)Hp02)aeRHXtVokmlpdf95PHlUlBDc5V(fYuAqS)nrblN(3NE9I0qGUH(q9iJYbzePWSvOqyaRIfZ7bmfxbZwKa8d5X3SB1kXgLgSXpmg40RkM)EyoAboXcQa06GCY0CyUezKYYc(82OKSW7dOfZXGqnVGVM3Neff8OunEBtdQu)THlNTkmny2n(PPGgRWqJmgiYjs)ZneMmUyEWNdwSlpywEiQIxYim6GD)Lg7(Uq4AEfP97St7u))mjD2kGt2aJZSb72wtO7cJIQe3FpVq8Miyz7myaK8GKK8927UTPblcZcydMLjpext0h8dJaDAgzbA9H2sRI5p9u1KXUaSaHbKspmAOXU4EF4hWJRO0Suu9RMyLpNqh5vfLvYhMzwY0jx84IiyUYp92ayPeSqQtZZ16B6KLiUvA4wAN)rek46G0T4mlOiFhD9)VHDtq6JNHatiZa)ex9hL8qqg8h0UgrxkBmcTb)9GI5)lcM2cFSEiYwi8Zhs2fbldGbN)9azEaWpyDc0ocVvm)FKe)AOQj3hK(aoOlM)RuUVSkePON7RdKMUfLf72slAffiEcWCjihFAXC6eZG65Lbyr1tyGDK8WQP1lAIHykzIkY34F7SKvZO4Me68w(fp84yclEYX5Vv(ahub0w2gcCzqQo0nbCW8u)4)ny1l8pr9CtyHCJOey5bymHdFKP3J)w0UaSRtIWXx9OnLAMd0dpPy(RafgFaVj4EeN0F5sa0)ZOPdUkWarVzxuuwWJCqNKjPWBxJlUk13Xjl5EC5UuI19z3cpiJmrknbWQqX8Zbl1Ckgv9jSaavihl)8n(FEgRS(8SCAy8Db5dYhnyTF2mWe6mSDukZvyfVYpaUyOT6reEA7lpB9LNJ9LNU(cRrJttYvaxgrluUKAX9PQfggtSC7DP(Uflg473n0iJX6x5hZpQhv36BsYOdcjfjgl0xcu8FeaRJ2eghudGfc12Vy(TjjGkjfJnpH520VvQHvm))f4hal(EcGycqUnH)jtkK7Fh6f320WeaHae5zK2dM3PupdqgxI4raGmbHzBuqj6l25zi6lc4I)gftLGxUmiY)rkSj43RFeHHHQuk)reza7o9bcsQFeaHZ6fWj6OigbYOJNiYGgfUuTRGvRcwKxP5Kb2d8JbU8H1bXi3tSa83zRtoRIzO2kiwayJWKvSNsMbkhM(FgD5dwybG7iQYmQh(sMt148vfMhmcMr)JzOZOuxszKzXYmDEo5uBlhW2Dp6KkVSZaqIuWDN4hzl1iZBdcZMr19ORLXEd8)CjORSMawNnBdXxDaYziPgS2HAyZYtMTDr(S3pKOo7nSM15BCLJxA5qwpgehSjmGQXFbLdRXC5TzwseWce80CIliojWYYT7ANmJGJO23lC7ZGyleTPNS5g)C7B7OESclHcM9qs0Q6rALn3DB2a952G6To0kJGQO0LGSki9Iq4UbYlAWjeu4cbxutrViaxZxKVlf8wjpztc64AfKnhjBUjMSrudLFLEdw1vqMeagaZLuPMwxG5Mm2ut61eFoUj(SFLTbBgYBEMrrk)xDHMztLe4DybnyKcnfXivbXUs2JXlkD7VKWOp))umAZiBrq8sIPKsRJ)GObikEXs)neBjSNDg1Gi2xqHaOqAo(7vK3u5eZsOibzGR3cBkWpI8yMn9fjXzHlXQ(ZKLluJxFSCbdyVVEfZdbGvDCWU2hgjjODwfohmsUiGzuElS)PuM9(TrOv8BcYFianMseFl3CBTrxILwYJ5POKLsIqE2OzLc(U5apOIZTzwfAQPh9e6rZbh5LIjszVaqlhLRnME9iUwM5hDFIo7(62WUWIHFLsZI5)3ynOBBfJXh()OpqOIYdjf1o1TloISxLhcq1oHTit8WJSE5)JenkkD4B(GMTZlV7kAGTe3BLMw6HRZ14wH2DNQxcugNZArG4ih9Rgh1(PbexFjR(feBKLIcXlGkioJToJ6plHYRtdyIxyHzGBcOjv7b0GSPNQOzm6ZcXVJk3d142rZR2mg3ibzjUTcQGQckbGzYzYmOQHPir4by95GDPygujhPfK(qa9aBuTp2T3Jh1OOzBaSV8pD2qDaqFE3W90f4cYEdPrrqEarSJcalHrmG59EM5HqCly3yB6HWp22eeJWGp0zrj58)n6NsYQvZUDXsPGj2GlpvAO1QikfPANWHOru70vx7c9my92(T7cZ5L4IQHuYEdpfnVOmavKDwh8tmY3VPy(OlBMaq1UKGqBGm9mwcW(V9schinWztikICpfrUvoZHQ0DMhJVTgHVPUaRU5(yVvEmf1obh(LKYw73tBIEAN1Q3bJErs56jZdwVH2QWv6jSS0OF72lL(TMq9TtlWafD3XGH6a8rJ6qQcvxaifLQn2jS6131iu(SmWKSM97zOpn6JZNYE1y7gjmJAYI4UgADJfWpwu(WahIpLggsIfYkRE1bdP(LcrcGzucjWK1bdTCZqerbShTpcDyg95ibOQmmZNS9FjTLRqAV)yvF4hHrB9MaXWSg5lUJrqiV2F72G4mfMutuwnn8ickFTBfMrSByIkYifgn9PoVkT)wndJW4vbPW)vn(jBMsCkKifjBToh2vnowZlh6G3bVX)24KS8Wf04pZCBbPsskzpVvbQnZFd)4BRFykzx0KDPKgKTlkNBUIwBAFBlORm65j5RINt(Q42srBos4zAbJU3st38vr1WPdMBSaWA3xfTnuNVkAGJTo4BLVk6iq3n33AFvuDp0kN5qv6oZR1xfZDXZHVkwuECkIUD1xfT0ZvFvuFDNpt(QyXZnJ(Q0CuD3FFvAyJw7dcLR9rZ(Qyaj45WxL2nWOHzjRH3RZxJ0jZCQE4CEsjKSzMZtkZbvvtWS4EdAsj6wP14QGGOl72m)oo5E3z7I9tHzXK0nIHqKQPxnlYxVkblwp71ycbqSFnJkMKAMFhNCQAnNgwYVHYY6uNupYbXk8wIo71yyHP(Kvgr2WmM7Ce3HHLDmNTYlBty(afTes4LlZFbtHMDQMuBt89U0qYsvhB5YStGLddmiQKuQ7TlW3BbnmRdQfgnNeC6IfEJjVMPSX7e1eYJwWQDWQgOrRrAw)kXaxehqYDGtPVohwjvWU6dPDjOpvEVyD4g)GuFAcEvPo3xMJ0LUDAY2oDRiv3Y1FqCA3C62v0(STZDfHGq6RNYScHq83ltzpFmzqcwrcSo5Dyfh85CQCxB3lKAi)itkB6fbGjNsDtxLgeuMp0kkN6sHs3TeOc5tv)6PKLyj8PPNKbGMY(q5umKlRg4v3M6qEdAMu(PGCPgBF0EKyYCwHQZ04rcwlSM10JmB2Od5vP8atiDIRnGkXcnKnXoN)LFGV3SL)LyAfz1Re9yzw8Ac0fQzSG0SG07Gvpo4XHsNuzHv(9zqMjkZdqBSY749mjjb0B2L(OUxUYxuwXpEbGeM6hndtpi7ohDGyNpuZn4sjIWrxKoCt)lcPF2S))DljolA3fm1ruVAtuegjAxw9qL9cYxh4hLVEWwmOqxv5dFtoWZj03Mq(PvFV0y3ZtsGZ8SryQvZRBNS2cSfKHpL9v4aqrGViPOPVmWvm0My4MTjP5Sa4968Q8b71OzY)9UqsgAKLGML93LNSXh)MAMdEqa78am38P)jjxvWpAMFmjg6osXVwJ5Jxt9LtxrLWNqvoz0N7xr13QNQQ4Vs02maDDpu8jndFwQG3UX(f65YYSDwI3KtiB5XSc1yBRtCROvev)ovDNOYBvudH1uLdiXBhzbvi7eLwH2ZVor4gjPN9jnLIDIpvFxeAiCxN06gXBhz1jB1uH2ZVorytKmzBan6wz0WW)ADw4ac07KxPpR(HcmSg)PNemmmrLYIFSfNkzPJv4FZ7PNOMOe(algl(SQpUI(idPhF4PNSSeCYfdnvom8fOQNjQQQJisv5zL(p9KrHQ6NQqVtm9XrCQ6x(WvExQs8W4jVBOMofOTHpbIjJW6Jw67jmzcKVFPs3lonMZpQX8cvJPcf67179qEDGsKCGix9RlObVAQsQ)25xJbF6QY4Fj(s5lbqgc3ZQrYYzxdgj5k2jIUxUlzNt7O5CZCAtFibA4EhAItDEZFfdAgLo0eh78QL0LRgTz(MRohuY3iH18gXS5RyB57Us(gjm3RDtNGGRmx5tJKBu7j3lEURXjLJ6QotEhi83k43DDQ7at(gjCxN6CKV7k5BKWV4XjEzZDnoPCux1zYxr43P3vzAKAFTOFYIVyAzw0W2bAfL0UjGSNhV)3Zi6AqqXL)csevtositZ3)miYyJ5H6jLWlBuIIAFV3ke(Winh9fpa5SLdT8TdOWMphg5nru1ajyddYq4rFEjEJKTRaqoY1DL8hmc)1MV3lhbFE1noOe)ar2J88rE(Ljp3vedh56Us(dgHpY3DJVf0TC61g6ih3Ec3gs2QDv1EoUvKVrcFq8URJBi(OJans2JcI9GSFv4zLmwWWARENO57TJ7HSMX9zFz99Y2)PNEvBjOklqi1e(1UYim)TleFVPwR8PEIVSyHXVLbZeT81BgDPTg9MlVsBZ6P9PN(2lNimqabOLVMNENyPNTwy7yRjJ9m((1zKBYy90RttM6ZqGYYVsqczOho1gfKKX97Bj5bmir8gQVGR0rO6rgPVmL4eCZyC2NgpuzrenZpTKSe71k2MPPKKWEQz4nSVPCBypyZg8r4BuCSZpIJ9xhCSZ)llo25hXXE2WXQ8y7YdH72Mi6ifoX2MLRRYbK4nswnkIoT7th56Us(dgH)AZ371MYFE1noOe)ar2J88rE(Ljp3vedh56Us(dgHpY3DJVf0TC6RCYroU9eUnK0OqqFDAlh3kY3iHpiE351Tml7OJans2JcI9GSFv4zZr(UPTfQpapE62yNk)4EeJ8CpIrAqXnh5BnvwmIrJmeXi1bJdrmsTrTl0mofXOr6IyKApBTW2Xwsrmsh56AeJ0ozQpybDmIrAOGTigjB0TZrmsJHqLiFlV4JNPBxeJmg432VITzAAoIrAw10Uig5kB2GpcFJIJzoY3hXXEgyRVS4yN)xwCmLiFFehRRSj6XwXN(jsoJJoQ9UYtPk8QWldpFY(eEvXKSkmQ62ZnBq1hO8PJpV(wd7SWvJFL8hxCXN(UI5hVKK(IFjjv8jDtwL6jNHxWgJvrcpJCTGmUA9G43YDTQKSkTudklGBnAZFc01lBB(lwUMt0bSv3NkLj0WsOb(gu(mTvCSMk2ZcNm2cNiGG5O8Kxe9n7WUnAMEkAMwmJRNW83dwic1jk3gxWyw4M4QFp2H6L8DW14H90E3BbyZ67BYr71z830wJhnKGi(f(MYsp7vFqeIcgXtYSRUO(WoH(ry90ts1WRV4q5fXvELHjI6JZq1H6epudGBK2tS8XEOnsgzbIXFptZ)C17vAzJFhVmD)cDz6YpTiJSWFejZqvQqP685a0Z05)ZECIrz64)rJRK8NtpY(P33IXCnq(6iPNmj)M(K)ryLV0vZlvLAXYSMRuPopFn)cBAYiVb)eSHgUiF8iDgcq)uuokJAMQ5vhnLwO(ec263bWK)ib(GSs(xP()(tXR2Lrq7OaeINBZ72oG2Ws8EyAa4LW47tUdi)NbrtSFerZLYpeVQNfYikYkIRbR0f8QTHqPz9rsRAR2TvRIZOluis1HjREIOddQETLUU4DYDH4He7bRBQo9xFM6Hpi3bsNnSQDdsE5grpSw1Xs9oHcFYDoXwTUQ(mI9kptyakcaQBDA9JOAWlEOVEf62xnzY04tIMpJ8EQxFd9idfDxDdx9Ej6xDGrxjtuVFgKAc3vXGujINc2Ag7JKAaD8l9W6pJDHyfuFKb80tN8QkrOMljbobSMsNWHwt7WsTaS7425aVlaeF023l5aPUT6UuOs0xEPh0t0NAQdIjUEc27(vzGedjCFgq60JNe)D(K4xs2YTlkHlacQ5oYSV69(aOORICQEBpC1TlwEA1MhbFZKSn7vBBw4CTOFn9vU)gMWF3n0tEzS8kihqPuHKWrypBq2eslWXgKvkquCNr(U2e2jMbh7RECAyfUZolqgYtWtY)tPvt(a(3eUScBYDI83Knp55gERl1oE528xxTYi0pMKycvs2OGqHUmn1ZOs9yHBKe99GO5N9IuTZ4Q44uNrwHAiGwBbezpBoBRM8NR(6jORwr)iICB2KYzDWMY)kgrHPXxQ(gPui8x0afr6eMHghSfnWWq1bW8gvz61UPlvNf47bUjkzyoWGH7qpsl1AbuJj4eYg3O2WlE2VL2f6EYgNpvoso1VhCwuCS7G3H4Qy3vUKwDgBQUOd5VWd(nRURmltN2sOXiLtJJfH5pEr6E8I09GCr6QvLfJhjGOV5m8xyxyUa8mYtLrzJawNRnWOUMzo6(0XuJ7P7jMJ7FsQAtCld5LJM6kKwog(Eu1ea3gtkh120UKFXPCYr3xJQAhBRS2XuIzKJoQ1XeYr7KO2OU3T0XrdbSKnoYrKVRjJJ2SLSV13Knhd3QmXPtFcQAxG2ifnMgoAwM0USWXrESRWCE8WCnn8AkFbT9gJChMZ98puRUKbyUMY(qdjFyxY9W9nh)CcMtxQhAlZd3xMseM7zmVd1ojAp5CAfmx7s6WNRCoul4TimNL8YPvWCDkFdTMUHn5UJkm3bjzd1WJtVoBBWIP)I3LVLCz3n9)m]] )