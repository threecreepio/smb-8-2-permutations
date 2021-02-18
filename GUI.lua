require('./configuration')
require('./utils/tas')
local tasarg = (arg or ""):split(",")
local base = load_tas_inputs("tas\\base.tas")
local ddls = {gap=8}
local select_set = iup.text{ value = tasarg[1] or "525",  expand = "HORIZONTAL" }
local result_text = iup.text{ value = "",  expand = "HORIZONTAL" }
ddls[#ddls+1] = iup.vbox{iup.label{ title = "Framerule" }, select_set, gap=0, margin=0}

local running_set = ""

local selections = {}
for i=1,#groups do
    local group = groups[i]
    local label = iup.label{title=group.description or group.name}

    local list = { dropdown = "YES", value = 1, expand = "HORIZONTAL" }
    for j=1,#group.variations do
        local v = group.variations[j]
        list[#list+1] = v.description or v.name
    end
    local v = #list
    if tasarg[1 + i] ~= nil then
        local idx, variant = array_find(group.variations, function (v) return v.name == tasarg[1 + i] end)
        v = idx
    end
    list.value = v
    selections[i] = v
    local lst = iup.list(list)
    function lst:valuechanged_cb()
        selections[i] = tonumber(self.value)
    end

    ddls[#ddls+1] = iup.vbox{label, lst, margin=0, gap=0}
end


local applybtn = iup.button{title = "Apply", expand = "HORIZONTAL"}
function applybtn:action()
    if taseditor.engaged() == false then
        iup.Message("8-2","Please open the TAS editor first.")
        return
    end

    current_set = tonumber(select_set.value)

    for i=3,#base,1 do
        local line = base[i]
        if line ~= nil then
            taseditor.submitinputchange(i, 1, tasline_to_value(line))
        end
    end
    
    for i=1,#groups,1 do
        local group = groups[i]
        local idx = selections[i]
        local variant = group.variations[idx]
        if variant == nil then
            print("could not find '" .. selected .. "' in group " .. (group.description or group.name))
        end
        print(string.format("Applying %s at frame %d (%s)", variant.inputs.filename, group.frame, group.description or group.name))

        for j=0,#variant.inputs,1 do
            local line = variant.inputs[j]
            if line ~= nil then
                taseditor.submitinputchange(j + group.frame, 1, tasline_to_value(line))
            end
        end
    end

    -- cache bust
    if tostring(running_set) ~= tostring(current_set) then
        local v = taseditor.getinput(1, 1)
        taseditor.submitinputchange(1, 1, bit.band(v + 1, 0xFF))
        running_set = current_set
        print("Changing framerule")
    end

    taseditor.applyinputchanges()
end


ddls[#ddls+1] = iup.vbox{iup.label{ title = "Results" }, result_text, gap=0, margin=0}

dlg = iup.dialog{
    iup.vbox{iup.vbox(ddls),applybtn},
    title = "8-2 Permutations",
    size = 240,
    margin = "8x8",
    resize = "NO"
}

gui.register(function()
    if emu.framecount() == ending_frame then
        result_text.value = get_result()
    end
end)

dlg:showxy(iup.MOUSEPOS, iup.MOUSEPOS)
emu.registerexit(function ()
    dlg:destroy()
end)
