tdcli = dofile('./tg/tdcli.lua')
serpent = (loadfile "./libs/serpent.lua")()
feedparser = (loadfile "./libs/feedparser.lua")()
require('./bot/utils')
URL = require "socket.url"
http = require "socket.http"
https = require "ssl.https"
ltn12 = require "ltn12"

json = (loadfile "./libs/JSON.lua")()
mimetype = (loadfile "./libs/mimetype.lua")()
redis = (loadfile "./libs/redis.lua")()
JSON = (loadfile "./libs/dkjson.lua")()
local lgi = require ('lgi')

local notify = lgi.require('Notify')

notify.init ("Telegram updates")


chats = {}


function do_notify (user, msg)
  local n = notify.Notification.new(user, msg)
  n:show ()
end

function dl_cb (arg, data)

end
function vardump(value)
  print(serpent.block(value, {comment=false}))
end
function load_data(filename)
	local f = io.open(filename)
	if not f then
		return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)
	return data
end

function save_data(filename, data)
	local s = JSON.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()
end

function match_plugins(msg)
  for name, plugin in pairs(plugins) do
    match_plugin(plugin, name, msg)
  end
end

function save_config( )
  serialize_to_file(_config, './data/config.lua')
  print ('saved config into ./data/config.lua')
end

function create_config( )
  -- A simple config with basic plugins and ourselves as privileged user
  config = {
    enabled_plugins = {
    "banhammer",
    "groupmanager",
    "msg-checks",
    "plugins",
    "tools"
 },
    sudo_users = {157059515},
    admins = {},
    disabled_channels = {},
    moderation = {data = './data/moderation.json'},
    info_text = [[》Beyond Reborn v3.0
An advanced administration bot based on https://valtman.name/telegram-cli

》https://github.com/BeyondTeam/BDReborn 

》Admins :
》@SoLiD ➣ Founder & Developer《
》@Makan ➣ Developer《
》@Rixel ➣ Developer 《
》@Exacute ➣ Developer《
》@To0fan ➣ Developer《
》@Tele_Sudo ➣ Developer《
》@CiveY ➣ Developer
》@ArmanDev ➣ Manager《
》@MrPars ➣ Manager《

》Special thanks to :
》@Vysheng
》@MrHalix
》@K_a_I_i_I_i_n_u_x
》@Nero_Dev
》And Beyond Team Members

》Our channel :
》@BeyondTeam《

》Our website :
》http://BeyondTeam.ir
]],
  }
  serialize_to_file(config, './data/config.lua')
  print ('saved config into conf.lua')
end

-- Returns the config from config.lua file.
-- If file doesn't exist, create it.
function load_config( )
  local f = io.open('./data/config.lua', "r")
  -- If config.lua doesn't exist
  if not f then
    print ("Created new config file: ./data/config.lua")
    create_config()
  else
    f:close()
  end
  local config = loadfile ("./data/config.lua")()
  for v,user in pairs(config.sudo_users) do
    print("Allowed user: " .. user)
  end
  return config
end
plugins = {}
_config = load_config()

function load_plugins()
  local config = loadfile ("./data/config.lua")()
      for k, v in pairs(config.enabled_plugins) do
        
        print("Loading Plugins", v)

        local ok, err =  pcall(function()
          local t = loadfile("plugins/"..v..'.lua')()
          plugins[v] = t
        end)

        if not ok then
          print('\27[31mError loading plugins '..v..'\27[39m')
        print(tostring(io.popen("lua plugins/"..v..".lua"):read('*all')))
            print('\27[31m'..err..'\27[39m')
        end
    end
end

function msg_valid(msg)
  if msg.date_ < os.time() - 60 then
    print('\27[36mOld msg\27[39m')
    return false
  end
  return true
end

function match_pattern(pattern, text, lower_case)
  if text then
    local matches = {}
    if lower_case then
      matches = { string.match(text:lower(), pattern) }
    else
      matches = { string.match(text, pattern) }
end
      if next(matches) then
        return matches
      end
  end
  -- nil
end

function match_plugin(plugin, plugin_name, msg)
    if plugin.pre_process then
        -- If plugin is for privileged users only
          local result = plugin.pre_process(msg)
          if result then
            print("pre process: ", plugin_name)
            --tdcli.sendMessage(msg.chat_id_, msg.id_, 0, result, 0, "md")
          end
     end
  for k, pattern in pairs(plugin.patterns) do
     matches = match_pattern(pattern, msg.text or msg.media.caption)
    if matches then
        print("Message matches: ", pattern..' | Plugin: '..plugin_name)
      if plugin.run then
        local result = plugin.run(msg, matches)
        if result then
            tdcli.sendMessage(msg.chat_id_, msg.id_, 0, result, 0, "md")
        end
      end
      return
    end
  end
end
_config = load_config()
load_plugins()

local function var_cb(msg, data)
  -------------Get Var------------
bot = {}
msg.to = {}
msg.from = {}
msg.media = {}
msg.id = msg.id_
msg.to.type = gp_type(data.chat_id_)
if data.content_.caption_ then
   msg.media.caption = data.content_.caption_
 end

if data.reply_to_message_id_ ~= 0 then
   msg.reply_id = data.reply_to_message_id_
    else
   msg.reply_id = false
   end
local function get_gp(arg, data)
	if gp_type(msg.chat_id_) == "channel" or gp_type(msg.chat_id_) == "chat" then
		msg.to.id = msg.chat_id_
		msg.to.title = data.title_
	else
		msg.to.id = msg.sender_user_id_
		msg.to.title = false
    end
end
	tdcli_function ({
		ID = "GetChat",
		chat_id_ = data.chat_id_
		}, get_gp, nil)

function botifo_cb(arg, data)
	bot.id = data.id_
   our_id = data.id_
	if data.username_ then
		bot.username = data.username_
	else
		bot.username = false
	end
	if data.first_name_ then
		bot.first_name = data.first_name_
	end
	if data.last_name_ then
		bot.last_name = data.last_name_
	else
		bot.last_name = false
	end
	if data.first_name_ and data.last_name_ then
		bot.print_name = data.first_name_..' '..data.last_name_
	else
		bot.print_name = data.first_name_
	end
	if data.phone_number_ then
		bot.phone = data.phone_number_
	else
		bot.phone = false
	end
end
tdcli_function({ ID = 'GetMe'}, botifo_cb, {chat_id=msg.chat_id_})
local function get_user(arg, data)
	msg.from.id = data.id_
	if data.username_ then
		msg.from.username = data.username_
	else
		msg.from.username = false
	end
	if data.first_name_ then
		msg.from.first_name = data.first_name_
	end
	if data.last_name_ then
		msg.from.last_name = data.last_name_
	else
		msg.from.last_name = false
	end
	if data.first_name_ and data.last_name_ then
		msg.from.print_name = data.first_name_..' '..data.last_name_
	else
		msg.from.print_name = data.first_name_
	end
	if data.phone_number_ then
		msg.from.phone = data.phone_number_
	else
		msg.from.phone = false
	end
	match_plugins(msg)

end
	tdcli_function ({
		ID = "GetUser",
		user_id_ = data.sender_user_id_
		}, get_user, nil)

-------------End-------------
end

function tdcli_update_callback (data)

  if (data.ID == "UpdateNewMessage") then
--print(serpent.block(msg))
    local msg = data.message_

    local d = data.disable_notification_

    local chat = chats[msg.chat_id_]
  local hash = 'msgs:'..msg.sender_user_id_..':'..msg.chat_id_
  redis:incr(hash)
    if redis:get('markread') == 'on' then
  tdcli.viewMessages(msg.chat_id_, {[0] = msg.id_}, dl_cb, nil)
    end
    if ((not d) and chat) then

      if msg.content_.ID == "MessageText" then

        do_notify (chat.title_, msg.content_.text_)

      else

        do_notify (chat.title_, msg.content_.ID)

      end

    end
	var_cb(msg, msg)
if msg.content_.ID == "MessageText" then
      if msg_valid(msg) then
      msg.text = msg.content_.text_
        msg.edited = false
        msg.pinned = false

      end
    elseif msg.content_.ID == "MessagePinMessage" then
        msg.pinned = true

elseif msg.content_.ID == "MessagePhoto" then
  msg.photo_ = true 

elseif msg.content_.ID == "MessageVideo" then
        msg.video_ = true

elseif msg.content_.ID == "MessageAnimation" then
		msg.animation_ = true
  
elseif msg.content_.ID == "MessageVoice" then
        msg.voice_ = true

elseif msg.content_.ID == "MessageAudio" then
        msg.audio_ = true

elseif msg.content_.ID == "MessageForwardedFromUser" then
        msg.forward_info_ = true

elseif msg.content_.ID == "MessageSticker" then
        msg.sticker_ = true

elseif msg.content_.ID == "MessageContact" then
        msg.contact_ = true

elseif msg.content_.ID == "MessageDocument" then
        msg.document_ = true

elseif msg.content_.ID == "MessageLocation" then
        msg.location_ = true
 
elseif msg.content_.ID == "MessageGame" then
        msg.game_ = true

    elseif msg.content_.ID == "MessageChatAddMembers" then
				if msg_valid(msg) then
					for i=0,#msg.content_.members_ do
						msg.adduser = msg.content_.members_[i].id_
					end
				end
		elseif msg.content_.ID == "MessageChatJoinByLink" then
				if msg_valid(msg) then
						msg.joinuser = msg.sender_user_id_
				end
    elseif msg.content_.ID == "MessageChatDeleteMember" then
        if msg_valid(msg) then
          msg.deluser = true
        end
    end
    if msg.content_.photo_ then
      --write_file("test.txt", vardump(msg))
      return false
    end

elseif data.ID == "UpdateMessageContent" then  

cmsg = data
    local function edited_cb(arg, data)
        msg = data
        msg.media = {}
    if cmsg.new_content_.text_ then
        msg.text = cmsg.new_content_.text_
     end
    if cmsg.new_content_.caption_ then
     msg.media.caption = cmsg.new_content_.caption_
 end
		msg.edited = true
        var_cb(msg, msg)
    end
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = data.chat_id_,
      message_id_ = data.message_id_
    }, edited_cb, nil)

  elseif (data.ID == "UpdateChat") then

    chat = data.chat_

    chats[chat.id_] = chat

  elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then

    tdcli_function ({ID="GetChats", offset_order_="9223372036854775807", offset_chat_id_=0, limit_=20}, dl_cb, nil)    
  
	end

  end

