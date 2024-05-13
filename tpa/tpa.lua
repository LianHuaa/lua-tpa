--创建命令
mc.listen("onServerStarted",function()
    local cmd = mc.newCommand("tpa", "玩家传送", PermType.Any)
    cmd:overload({})
    cmd:setCallback(function (cmd, ori, out, res)
        local pl = ori.player
        return main(pl)
        end
    )
    cmd:setup()
    end
)
--函数入口
function main(pl)
local pl_all = mc.getOnlinePlayers()
local pl_list = {}
for k,v in pairs(pl_all) do
if (v.realName ~= pl.realName) then
table.insert(pl_list,v.realName)
end
end
local fmss = {
    "传送过去","传送过来"
}
local fm = mc.newCustomForm()
fm:setTitle("TPA")
fm:addDropdown("玩家列表",pl_list)
fm:addStepSlider("传送选项",fmss)
pl:sendForm(fm,function (pl,data)
    if (data ~= null) then
    local p = tonumber(data[1]) + 1
    local s = tonumber(data[2]) + 1
    if (pl_list == {}) then
    local pla = mc.getPlayer(pl_list[p])
    if (fmss[s] == "传送过去") then
    return tp_go(pl,pla)
    elseif (fmss[s] == "传送过来") then
    return tp_come(pl,pla)
    end
    else
       pl:tell('你不能传送空气')
    end
    end
    end
)
end
--go函数
function tp_go(pl,pla)
pl:sendModalForm("传送请求",pl.realName.."想来你这里","接受","拒绝",function(pl,res)
    if (res == true) then
        pl:teleport(pla.pos)
        pl:tell("传送到"..pla.realName.."完成")
        pla:tell(pl.realName.."已传送过来")
    elseif (res == false) then
        pl:tell(pla.realName.."在忙或不方便让你过去")
        pla:tell("以拒绝或错过"..pl.realName.."的传送请求")
    end
    end
)
end
--come函数
function tp_come(pl,pla)
pl:sendModalForm("传送请求",pl.realName.."想让你过去","接受","拒绝",function(pl,res)
    if (res == true) then
        pla:teleport(pl.pos)
        pla:tell("传送到"..pl.realName.."完成")
        pl:tell(pla.realName.."已传送过来")
    elseif (res == false) then
        pl:tell(pla.realName.."在忙或不方便让你过去")
        pla:tell("以拒绝或错过"..pl.realName.."的传送请求")
    end
    end
)
end