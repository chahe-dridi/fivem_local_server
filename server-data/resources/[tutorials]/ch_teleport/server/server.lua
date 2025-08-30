RegisterNetEvent('ch_teleporter:goto', function(GetFreecamTarget)

    local playerId= source 

    local targetPed =GetPlayerPed(targetId)

    if targetPed<= 0 then 
        TriggerClientEvent('chat:addMessage',playerId,{
            args ={ 'sorry,'.. targetId..'dosen\'t seem to exit.', },
        })


        return
    end
    local targetPos=GetEntityCoords(targetPed)

    SetEntityCoords(playerPed, targetPos)

  [[TriggerClientEvent('ch_teleporter:ch_teleport',playerId,targetPos)]]

end)









RegisterNetEvent('ch_teleporter:summon',function (targetId)

    local playerId= source

    local playerPed =GetPlayerPed(playerId)
    local playerPos =GetEntityCoords(playerPed)
    local targetPed =GetPlayerPed(targetId)
    
     if targetPed<= 0 then 
        TriggerClientEvent('chat:addMessage',playerId,{
            args ={ 'sorry,'.. targetId..'dosen\'t seem to exit.', },
        })


        return
    end
    SetEntityCoords(targetPed, playerPos)

 
end)