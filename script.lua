obs=obslua

function script_description()
    return [[
        <h3>Discord Webhook When Stream</h3> 
        <p>^ simple  <a href="https://www.youtube.com/watch?v=Fd2UjUhkbpE"> tutorial on how<\a> Made By Dazigion</p>
    ]]
end


Webhook=nil
Message="EMPTY"


function send()
    --local Message = string.gsub(Message,"%p","\\%0")
    local win = false
    if package.config:sub(1,1) == "\\" then win = true end
    local Message = string.gsub(Message,"[\"\\$\n%%^&]", function (s)
        if string.find(s,"[\"\\]") then return "\\\\\\"..s
        elseif s == "\n" then return "\\n"
        elseif not win and string.find(s,"[%%&^]") then return s
        elseif win then return "^"..s
        else return "\\"..s
        end
    end)
    local exec = "curl --include --header \"Accept: application/json\" --header \"Content-Type:application/json\" --request POST --data \"{\\\"content\\\":\\\""..Message.."\\\"}\" "..Webhook
    print(exec)
    return os.execute(exec)
end

function script_load(settings)
    script_update(settings)
    obs.obs_frontend_add_event_callback(on_event)
end

function script_update(settings)
    Webhook = obs.obs_data_get_string(settings,"Webhook")
    WaitTime = obs.obs_data_get_double(settings,"WaitTime")
    Message = obs.obs_data_get_string(settings, "Message")
end

function script_properties()
    local properties = obs.obs_properties_create()
    obs.obs_properties_add_text(properties,"Webhook","Webhook",obs.OBS_TEXT_PASSWORD)
    obs.obs_properties_add_text(properties,"Message","Message\nto\nSend",obs.OBS_TEXT_MULTILINE)
    obs.obs_properties_add_button(properties,"testbtn","manual SEND MESSAGE",send)
    return properties
end

Starting = false
function on_event(event)
    if event == obs.OBS_FRONTEND_EVENT_STREAMING_STARTED then
        send()
    end
 end