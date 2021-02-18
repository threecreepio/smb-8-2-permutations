require('./utils/smb')
require('./utils/tas')
-- base file to include before all the variations
base = load_tas_inputs("tas\\base.tas")

local logmsg = function (msg)
    if emu.nesl == nil then
        emu.print(msg)
    end
end

function register_score()
    return smb1_readscore()
end

function expect_score_increase(prev)
    local new = smb1_readscore()
    return prev < new
end

function expect_full_speed(prev)
    local xspeed = memory.readbyte(Player_X_Speed)
    if xspeed >= 40 then
        return true
    else
        return xspeed
    end
end

groups = {
    {
        name = "1K",
        description = "Koop #1",
        frame = 320,
        variations = {
            -- bop first koop
            { name = " E", description = "Bop", inputs = load_tas_inputs("tas\\firstkoop-early.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "  ", inputs = load_tas_inputs("tas\\empty.tas"), per_frame = expect_full_speed }
        }
    },
    {
        name = "2K",
        description = "Koop #2",
        frame = 377,
        variations = {
            -- bop second koop.. hard..
            { name = " E", description = "Bop", inputs = load_tas_inputs("tas\\secondkoop-bop.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "  ", description = "", inputs = load_tas_inputs("tas\\empty.tas"), per_frame = expect_full_speed }
        }
    },

     {
         name = "LA",
         description = "Lakitu",
         frame = 419,
         variations = {
             { name = " D", description = "Spiny despawn", inputs = load_tas_inputs("tas\\lakitu-spiny-despawn.tas"), per_frame = expect_full_speed },
             { name = " E", description = "Early bop", inputs = load_tas_inputs("tas\\lakitu-early-bop.tas"), per_frame = expect_full_speed },
             { name = " L", description = "Late bop", inputs = load_tas_inputs("tas\\lakitu-late-bop.tas"), per_frame = expect_full_speed },
             { name = "  ", description = "", inputs = load_tas_inputs("tas\\empty.tas"), per_frame = expect_full_speed }
         }
     },
-- 
     {
         name = "H1",
         description = "Koop #3",
         frame = 580,
         variations = {
             { name = " E", description = "Early bop", inputs = load_tas_inputs("tas\\hallway-1-early.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
             { name = " L", description = "Late bop", inputs = load_tas_inputs("tas\\hallway-1-late.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
             { name = "  ", description = "", inputs = load_tas_inputs("tas\\empty.tas"), per_frame = expect_full_speed }
         }
     },
-- 
     {
         name = "H2       ",
         description = "Koop #4 and #5",
         frame = 640,
         variations = {
            { name = "BothEarly", description = "Bop #4 and #5 early", inputs = load_tas_inputs("tas\\hallway-2-bothearly.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "BothLate ", description = "Bop #4 and #5 late", inputs = load_tas_inputs("tas\\hallway-2-bothlate.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "BothLate2", description = "Bop #4 and #5 late alt. 2", inputs = load_tas_inputs("tas\\hallway-2-bothlate2.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "BackEarly", description = "Bop #5 early", inputs = load_tas_inputs("tas\\hallway-2-backearly.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "BackLate ", description = "Bop #5 late", inputs = load_tas_inputs("tas\\hallway-2-backlate.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "         ", description = "", inputs = load_tas_inputs("tas\\empty.tas"), per_frame = expect_full_speed }
         }
     },
-- 
    {
        name = "BB1",
        description = "Bullet bill #1",
        frame = 750,
        variations = {
            { name = "  B", description = "Bop", inputs = load_tas_inputs("tas\\cannonbill-1.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "   ", description = "", inputs = load_tas_inputs("tas\\empty.tas"), per_frame = expect_full_speed }
        }
    },
    {
        name = "C1",
        description = "Koop #6",
        frame = 803,
        variations = {
            { name = " E", description = "Bop timing 1", inputs = load_tas_inputs("tas\\cannonkoop-1-1.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "E2", description = "Bop timing 2", inputs = load_tas_inputs("tas\\cannonkoop-1-4.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "E3", description = "Bop timing 3", inputs = load_tas_inputs("tas\\cannonkoop-1-5.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = " L", description = "Bop timing 4", inputs = load_tas_inputs("tas\\cannonkoop-1-2.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "L2", description = "Bop timing 5", inputs = load_tas_inputs("tas\\cannonkoop-1-3.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "L3", description = "Bop timing 6", inputs = load_tas_inputs("tas\\cannonkoop-1-L3.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "  ", description = "", inputs = load_tas_inputs("tas\\empty.tas"), per_frame = expect_full_speed }
        }
    },
    {
        name = "C2",
        description = "Koop #7",
        frame = 849,
        variations = {
            { name = "WO", description = "Walk-off", inputs = load_tas_inputs("tas\\cannonkoop-2-walkoff.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "EB", description = "Bop timing 1", inputs = load_tas_inputs("tas\\cannonkoop-2-earlybop.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "MB", description = "Bop timing 2", inputs = load_tas_inputs("tas\\cannonkoop-2-midbop.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "LB", description = "Bop timing 3", inputs = load_tas_inputs("tas\\cannonkoop-2-latebop.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "  ", description = "", inputs = load_tas_inputs("tas\\empty.tas"), per_frame = expect_full_speed }
        }
    },
    {
        name = "BB2",
        description = "Bullet bill #3",
        frame = 892,
        variations = {
            { name = " WO", description = "Walk-off", inputs = load_tas_inputs("tas\\bb2-walkoff.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "  B", description = "Bop", inputs = load_tas_inputs("tas\\bb2-bop.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "   ", description = "", inputs = load_tas_inputs("tas\\empty.tas"), per_frame = expect_full_speed }
        }
    },
     
    {
        name = "BZ",
        description = "Buzzy #1",
        frame = 927,
        variations = {
            { name = " E", description = "Bop early", inputs = load_tas_inputs("tas\\cannonbuzzy-1.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = " L", description = "Bop late", inputs = load_tas_inputs("tas\\cannonbuzzy-2.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "  ", description = "", inputs = load_tas_inputs("tas\\cannonbuzzy-0.tas"), per_frame = expect_full_speed }
        }
    },

    {
        name = "BB3",
        description = "Bullet bill #3 / Buzzy #2",
        frame = 978,
        variations = {
            { name = " BZ", description = "Buzzy bop", inputs = load_tas_inputs("tas\\cannonbill-3-bz.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = " B2", description = "Bullet bop 1", inputs = load_tas_inputs("tas\\cannonbill-3-bop2.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "  B", description = "Bullet bop 2", inputs = load_tas_inputs("tas\\cannonbill-3.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "   ", description = "", inputs = load_tas_inputs("tas\\empty.tas"), per_frame = expect_full_speed }
        }
    },
    {
        name = "BB4",
        description = "Bullet bill #4",
        frame = 1016,
        variations = {
            { name = " B3", description = "Bop timing 1", inputs = load_tas_inputs("tas\\bb4-bop3.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = " B2", description = "Bop timing 2", inputs = load_tas_inputs("tas\\bb4-bop2.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "  B", description = "Bop timing 3", inputs = load_tas_inputs("tas\\bb4-bop.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "   ", description = "", inputs = load_tas_inputs("tas\\empty.tas"), per_frame = expect_full_speed }
        }
    },
     
     {
         name = "PN",
        description = "Koop #8 (Pen)",
         frame = 1060,
         variations = {
             { name = " B", description = "Bop", inputs = load_tas_inputs("tas\\pen-1.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
             { name = "  ", description = "", inputs = load_tas_inputs("tas\\empty.tas"), per_frame = expect_full_speed }
         }
     },
--
     {
         name = "Clear",
         description = "Clear speed",
         frame = 1199,
         sigmatch = false,
         variations = {
            { name = "    5", description = "Slowest", inputs = load_tas_inputs("tas\\clear-5.tas") },
            { name = "    3", description = "Slower", inputs = load_tas_inputs("tas\\clear-3.tas") },
            { name = "    1", description = "Fast", inputs = load_tas_inputs("tas\\clear-1.tas") }
         }
     },
-- 
     {
         name = "GTLT",
         description = "Koop #9, #10, #11 (End koops)",
         frame = 1299,
         sigmatch = false,
         variations = {
            { name = "   6", description = "Bop pattern 6", inputs = load_tas_inputs("tas\\gtlt-6.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "   5", description = "Bop pattern 5", inputs = load_tas_inputs("tas\\gtlt-5.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "   4", description = "Bop pattern 4", inputs = load_tas_inputs("tas\\gtlt-4.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "   3", description = "Bop pattern 3", inputs = load_tas_inputs("tas\\gtlt-3.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "   2", description = "Bop pattern 2", inputs = load_tas_inputs("tas\\gtlt-2.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "   1", description = "Bop pattern 1", inputs = load_tas_inputs("tas\\gtlt-1.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "   0", description = "Bop pattern 0", inputs = load_tas_inputs("tas\\gtlt-0.tas"), per_frame = expect_full_speed, before = register_score, verify = expect_score_increase },
            { name = "    ", description = "", inputs = load_tas_inputs("tas\\empty.tas"), per_frame = expect_full_speed }
         }
     }
}

--- final frame where the result is printed
ending_frame = 1529

--- run before each segment, if this returns the same signature for two patterns we ignore the rest of that path!
function signature()
    return memory.readbyterange(0x10, 0xFF - 0x10) .. memory.readbyterange(0x200, 0x4FF - 0x200)
end

function get_bullet_positions()
    -- find all currently spawned bullets, storing them based on their y position
    local bullets = {}
    for i=0,5,1 do
        if memory.readbyte(Enemy_ID + i) == BulletBill_CannonVar then
            -- ignore any bullets heading the wrong direction
            if memory.readbytesigned(Enemy_X_Speed + i) > 0 then
                local mf = memory.readbyte(Enemy_X_MoveForce + i)
                local mfi = 0
                if mf >= 0x80 then mfi = 1 end
                bullets[EnemyY(i)] = { x = EnemyX(i), mf = mfi } -- bit.ror(mf, 4) }
            end
        end
    end
    return bullets
end

local is_plant_spawned = 0
local cannon_timers = ""

function get_result()
    -- mark as failed if mario didnt make it to the end of the stage
    if EnemyX(-1) < 3000 then
        --print("failed to reach the end!")
        return string.format("FAIL mario X was %i", EnemyX(-1))
    end

    local s = ""
    local bullets = get_bullet_positions()
    -- write out bullet positions to the log file
    if bullets[56] ~= nil then
        s = s .. string.format("L-%X-%04d,", bullets[56].mf, bullets[56].x)
    else
        s = s ..  "        ,"
    end
    if bullets[88] ~= nil then
        s = s .. string.format("H-%X-%04d", bullets[88].mf, bullets[88].x)
    else
        s = s .. "        "
    end
    s = s .. string.format(",P%d", is_plant_spawned)
    -- s = s .. string.format(",%s", cannon_timers)
    return s
end

local hovercraft = false

-- run on each frame
emu.registerafter(function ()
    -- set player to have 1 frame of iframes every frame
    memory.writebyte(InjuryTimer, 0x02)

    -- move player up to ground if we're falling to our death
    if memory.readbyte(Player_Y_Position) > 178 and memory.readbyte(Player_Y_HighPos) > 0 then
        memory.writebyte(Player_Y_Position, 176)
    end

    if emu.framecount() == 1258 then
        is_plant_spawned = 0
        cannon_timers = ""
        if EnemyX(getclosestenemy()) == 2504 then
            is_plant_spawned = 1
        end
    end
    
    -- log some cannon timers
    if EnemyX(-1) >= 0xC15 and EnemyX(-1) < 0xC18 then
        local ct = string.format("CT:%x,%x,%x,%x,%x",
            memory.readbyte(Cannon_Timer + 0),
            memory.readbyte(Cannon_Timer + 1),
            memory.readbyte(Cannon_Timer + 2),
            memory.readbyte(Cannon_Timer + 3),
            memory.readbyte(Cannon_Timer + 4),
            memory.readbyte(Cannon_Timer + 5)
        )
        local ef = string.format("EF:%x,%x,%x,%x,%x",
            memory.readbyte(Enemy_Flag + 0),
            memory.readbyte(Enemy_Flag + 1),
            memory.readbyte(Enemy_Flag + 2),
            memory.readbyte(Enemy_Flag + 3),
            memory.readbyte(Enemy_Flag + 4),
            memory.readbyte(Enemy_Flag + 5)
        )

        cannon_timers = string.format("%s,%s", ct, ef)
    end
    
    -- move player out of the way when holding select
    if joypad.get(1)["select"] then
        memory.writebyte(Player_Y_Position, 0x3E)
    end

    if emu.framecount() >= 1015 and emu.framecount() <= 1016 and memory.readbyte(Player_Y_Position) < 0x70 then
        memory.writebyte(Player_Y_Position, 0x60)
    end
    if emu.framecount() == 893 then
        memory.writebyte(Player_Y_Position, 0xB0)
    end

    -- print result
    if emu.nesl == nil and emu.framecount() == ending_frame then
        logmsg(get_result())
    end

    -- if we're on the frame before the level becomes visible in base.tas
    if emu.framecount() == 250 and current_set ~= nil then
        local seed = smb1rng_init()
        -- step the rng the amount of frames needed to advance to the framerule we want
        -- which is 4 frames before the actual framerule
        seed = smb1rng_advance(seed, (tonumber(current_set) * 21) - 4)
        -- then advance for power-up state!
        -- seed = smb1rng_advance(seed, 63 + 59)
        logmsg(string.format("setting rng to %02X%02X%02X%02X%02X%02X%02X", seed[1], seed[2], seed[3], seed[4], seed[5], seed[6], seed[7]))
        -- and overwrite the games rng values
        smb1rng_apply(seed)
    end
end)