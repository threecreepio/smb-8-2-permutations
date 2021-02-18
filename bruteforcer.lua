require('./utils/tas')
require('./configuration')
current_set = -1
local log = io.stdout
local s = os.clock()

function empty_permutation()
    local result = {}
    for i=1,#groups,1 do
        local v = groups[i].variations
        result[i] = v[#v].name
    end
    return result
end

function advance_permutation(set, force_group)
    local found = false
    local next = {}
    local changed_group = 1
    for i=1,#set,1 do
        next[i] = set[i]
    end

    local starting_group = #groups
    if force_group ~= nil and force_group < #groups then
        starting_group = force_group
        for i=force_group+1,#groups,1 do
            next[i] = groups[i].variations[#groups[i].variations].name
        end
    end

    for i=starting_group,1,-1 do
        local current = set[i]
        local v = groups[i].variations
        if current == nil then
            current = v[#v].name
        end
        local idx = array_find(groups[i].variations, function (v) return v.name == current end)
        if idx == 1 then
            next[i] = v[#v].name
        else
            next[i] = v[idx - 1].name
            changed_group = i
            found = true
            break
        end
    end
    if found == true then
        return next, changed_group
    end
end

if arg == nil then
    arg = io.stdin:read()
end

for set in string.gmatch(arg, "([^,]+)") do
    emu.poweron()
    emu.speedmode('turbo')
    emu.frameadvance() -- needed for beta version of fceux!
    current_set = set
    
    log:write(string.format("SET,%s,LO,HI,BLANT", table.concat(array_map(groups, function (g) return g.name end), ",")))
    
    -- run iterations
    local permutation = empty_permutation()
    local grp = 1
    local savestates = array_map(groups, function (v) return savestate.object() end)
    local verify_fail_msg = ""
    local signatures = {}
    while permutation ~= nil do
        local force_group = nil
        local sigs = {}
        local first_group = groups[1]
        for frame=emu.framecount(),first_group.frame-1,1 do
            joypad.set(1, base[frame] or {})
            emu.frameadvance()
        end
        for grp=grp,#groups,1 do
            local next_group = groups[grp+1]
            local group = groups[grp]
            local var_i, var = array_find(group.variations, function (v) return v.name == permutation[grp] end)
            savestate.save(savestates[grp])
            local ok = true
            local before = var.before and var.before()
            if #var.inputs >= 1 then
                local max = #var.inputs
                if groups[grp + 1] and groups[grp + 1].frame - group.frame < max then
                    max = groups[grp + 1].frame - group.frame
                end
                for frame=0,max,1 do
                    joypad.set(1, var.inputs[frame] or {})
                    emu.frameadvance()
                    if var.per_frame and var.per_frame() ~= true then
                        verify_fail_msg = var.per_frame()
                        ok = false
                        break
                    end
                end
            end
            if next_group ~= nil then
                for frame=emu.framecount(),next_group.frame-1,1 do
                    joypad.set(1, base[frame] or {})
                    emu.frameadvance()
                    if var.per_frame and var.per_frame() ~= true then
                        verify_fail_msg = var.per_frame()
                        ok = false
                        break
                    end
                end
            end
            local sig = string.format("%s::%s", table.concat(array_slice(permutation, grp), ","), signature())
            sigs[#sigs + 1] = sig
            if group.sigmatch ~= false and signatures[sig] then
                verify_fail_msg = string.format("sigmatch %s", group.name)
                force_group = grp -- + 1
                break
            end
            if ok == false then
                verify_fail_msg = string.format("per_frame %s failed - %d %s", group.name, emu.framecount(), tostring(verify_fail_msg))
                force_group = grp -- + 1
                break
            end
            if ok == false or (var.verify and var.verify(before) == false) then
                verify_fail_msg = string.format("verify %s failed", group.name)
                force_group = grp -- + 1
                break
            end
        end
        if force_group == nil then
            for frame=emu.framecount(),ending_frame-1,1 do
                joypad.set(1, base[frame])
                emu.frameadvance()
            end
            local result = get_result()
            log:write(string.format("\n%s,%s,%s",set, table.concat(permutation, ","),result))
            for i=1,#sigs,1 do
                signatures[sigs[i]] = result
            end
        else
            log:write(string.format("\n%s,%s,%s",set, table.concat(permutation, ","), verify_fail_msg))
            for i=1,#sigs,1 do
                signatures[sigs[i]] = verify_fail_msg
            end
        end
        log:flush()
        permutation, grp = advance_permutation(permutation, force_group)
        verify_fail_msg = ""
        force_group = nil
        if permutation ~= nil then
            savestate.load(savestates[grp])
        end
    end
end

print("\nDone.")
io.stderr:write(os.clock() - s)
emu.exit()