RegisterCommand('goto', function(source, args, rawCommand)
    local targetId = args[1]
    if not targetId then
        TriggerServerEvent('chat:addMessage', {
            args = {'please provide a target id'},
        })
       return
    end
      TriggerServerEvent('ch_teleporter:goto', targetId) 
end)



RegisterCommand('summon',function (_,args)
    local targetId = args[1]
    if not targetId then
        TriggerServerEvent('chat:addMessage', {
            args = {'please provide a target id'},
        })
       return
    end
   TriggerServerEvent('ch_teleporter:summon', targetId)
end)


 
 
