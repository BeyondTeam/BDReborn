do
local function pre_process(msg)
 local hash = 'muteall:'..msg.to.id
  if redis:get(hash) and msg.to.type == 'channel' and not is_mod(msg)  then
    tdcli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
       end
    return msg
 end
	
local function run(msg, matches)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if matches[1] == 'mute' and matches[2] == 'all' and is_mod(msg) then
local hash = 'muteall:'..msg.to.id
redis:set(hash, true)
if not lang then
return "mute all has been enabled"
elseif lang then
return "بصدا کردن گروه فعال شد"
end
end
 if matches[1] == 'mute' and is_mod(msg) then
local hour = string.gsub(matches[2], 'h', '')
local num1 = tonumber(hour) * 3600
local minutes = string.gsub(matches[3], 'm', '')
local num2 = tonumber(minutes) * 60
local second = string.gsub(matches[4], 's', '')
local num3 = tonumber(second) 
local num4 = tonumber(num1 + num2 + num3)
redis:setex(hash, num4, true)
if not lang then
 return "Mute all has been enabled for \n⏺ hours : "..matches[2].."\n⏺ minutes : "..matches[3].."\n⏺ seconds : "..matches[4].."\n@BeyondTeam"
 elseif lang then
 return "بی صدا کردن فعال شد در \n⏺ ساعت : "..matches[2].."\n⏺ دقیقه : "..matches[3].."\n⏺ ثانیه : "..matches[4].."\n@BeyondTeam"
 end
 end
 if matches[1] == 'mutehours' and is_mod(msg) then
       local hash = 'muteall:'..msg.to.id
local hour = string.gsub(matches[2], 'h', '')
local num1 = tonumber(hour) * 3600
local num4 = tonumber(num1)
redis:setex(hash, num4, true)
if not lang then
 return "Mute all has been enabled for \n⏺ hours : "..matches[2].."\n@BeyondTeam"
 elseif lang then
 return "بی صدا کردن فعال شد در \n⏺ ساعت : "..matches[2].."\n@BeyondTeam"
 end
 end
  if matches[1] == 'muteminutes' and is_mod(msg) then
       local hash = 'muteall:'..msg.to.id
local minutes = string.gsub(matches[2], 'm', '')
local num2 = tonumber(minutes) * 60
local num4 = tonumber(num2)
redis:setex(hash, num4, true)
if not lang then
 return "Mute all has been enabled for \n⏺ minutes : "..matches[2].."\n@BeyondTeam"
 elseif lang then
 return "بی صدا کردن فعال شد در \n⏺ دقیقه : "..matches[2].."\n@BeyondTeam"
 end
 end
  if matches[1] == 'muteseconds' and is_mod(msg) then
       local hash = 'muteall:'..msg.to.id
local second = string.gsub(matches[2], 's', '')
local num3 = tonumber(second) 
local num4 = tonumber(num3)
redis:setex(hash, num3, true)
if not lang then
 return "Mute all has been enabled for \n⏺ seconds : "..matches[2].."\n@BeyondTeam"
 elseif lang then
 return "بی صدا کردن فعال شد در \n⏺ ثانیه : "..matches[2].."\n@BeyondTeam"
 end
 end
 
 if matches[1] == 'unmute' and matches[2] == 'all' and is_mod(msg) then
         local hash = 'muteall:'..msg.to.id
        redis:del(hash)
		if not lang then
          return "mute all has been disabled"
		  elseif lang then
		  return "گروه ازاد شد و افراد می توانند دوباره پست بگذارند"
  end
end

if matches[1] == 'helpmute' then
if not lang then
text = [[
*Beyond Mute Commands:*
*!mute all*
_Mute groups_
*!mute* `(hour) (minute) (seconds)`
_Mute group at this time_ 
*!mutehours* `(number)`
_Mute group at this time_ 
*!muteminutes* `(number)`
_Mute group at this time_ 
*!muteseconds* `(number)`
_Mute group at this time_ 
*!unmute all*
_Unmute group at this time_ 
_You can use_ *[!/#]* _at the beginning of commands._				
]]
elseif lang then
text = [[
*راهنمای بیصدا های ربات بیوند:*
*!mute all*
_بیصدا کردن گروه_
*!mute* `(hour) (minute) (seconds)`
_بیصدا کردن گروه با ساعت و دقیقه و ثانیه_ 
*!mutehours* `(number)`
_بیصدا کردن گروه در ساعت_ 
*!muteminutes* `(number)`
_بیصدا کردن گروه در دقیقه_ 
*!muteseconds* `(number)`
_بیصدا کردن گروه در ثانیه_ 
*!unmute all*
_آزاد سازی بیصدایی گروه در آن زمان_ 
*شما میتوانید از [!/#] در اول دستورات برای اجرای آنها بهره بگیرید*
]]
end
return text
end
end
return {
   patterns = {
_config.cmd .. '([Uu]nmute) (all)$',
_config.cmd .. '([Mm]ute) (all)$',
_config.cmd .. '([Hh]elpmute)$',
_config.cmd .. '([Mm]ute) (.*) (.*) (.*)$',
_config.cmd .. '([Mm]utehours) (.*)$',
_config.cmd .. '([Mm]uteminutes) (.*)$',
_config.cmd .. '([Mm]uteseconds) (.*)$',
 },
run = run,
pre_process = pre_process
}
end
--by @BeyondTeam
