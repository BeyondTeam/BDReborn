-- #Beyond Reborn Robot
-- #@BeyondTeam
package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'.. ';.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'
tdbot = dofile('./td/tdbot.lua')
serpent = (loadfile "./libs/serpent.lua")()
feedparser = (loadfile "./libs/feedparser.lua")()
require('./bot/utils')
require('./libs/lua-redis')
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
plugins = {}
helper_username = 'UltraBeyondBot'  -- Input Helper Username Here Without @
local bot_profile = 'cli'

function do_notify (user, msg)
	local n = notify.Notification.new(user, msg)
	n:show ()
end

function dl_cb (arg, data)
	-- vardump(data)
end

function serpdump(value)
	print(serpent.block(value, {comment=false}))
end

function vardump(value, depth, key)
  local linePrefix = ""
  local spaces = ""
  if key ~= nil then
    linePrefix = ""..key.." = "
  end
  if depth == nil then
    depth = 0
  else
    depth = depth + 1
    for i=1, depth do 
		spaces = spaces .. "  " 
	end
  end
  if type(value) == 'table' then
    mTable = getmetatable(value)
	if mTable == nil then
    print(spaces ..linePrefix.." (table)")
  else
    print(spaces .."(metatable) ")
    value = mTable
  end   
  for tableKey, tableValue in pairs(value) do
    vardump(tableValue, depth, tableKey)
  end
  elseif type(value)  == 'function' or type(value) == 'thread' or type(value) == 'userdata' or value == nil then
    print(spaces..tostring(value))
  else
    print(spaces..linePrefix..tostring(value))
  end
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

function whoami()
	local usr = io.popen("whoami"):read('*a')
	usr = string.gsub(usr, '^%s+', '')
	usr = string.gsub(usr, '%s+$', '')
	usr = string.gsub(usr, '[\n\r]+', ' ') 
	if usr:match("^root$") then
		tcpath = '/root/.telegram-bot/'..bot_profile
	elseif not usr:match("^root$") then
		tcpath = '/home/'..usr..'/.telegram-bot/'..bot_profile
	end
  print('>> Download Path = '..tcpath)
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
	config = {
    enabled_plugins = {
		 "banhammer",
		 "groupmanager",
		 "msg-checks",
		 "plugins",
		 "tools",
		 "fun"
	},
    sudo_users = {157059515,111334847,157059515},
    admins = {},
    disabled_channels = {},
    moderation = {data = './data/moderation.json'},
    info_text = [[》BDReborn (TDBot Branch) V2
An advanced administration bot based on Beyond Reborn V6 updated for https://valtman.name/telegram-bot

》https://github.com/BeyondTeam/BDReborn

》Admins :
》@SoLiD ➣ Founder & Developer《
》@ToOfan ➣ Developer《
》@Xamarin_Developer ➣ Developer《
》 MAKAN ➣ Developer《
》@SenatorHost ➣ Sponsor《

》Special thanks to :
》@kuncen
》@Vysheng
》@MrHalix
》Beyond Team Members

》Our channel :
》@BeyondTeam《

》Our website :
》http://Beyond-Dev.iR
]],
  }
	serialize_to_file(config, './data/config.lua')
	print ('saved config into config.lua')
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
		print("SUDO USER: " .. user)
	end
	return config
end

whoami()
_config = load_config()

function load_plugins()
	local config = loadfile ("./data/config.lua")()
	for k, v in pairs(config.enabled_plugins) do
		print("Loaded Plugin	", v)
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
	print('\n'..#config.enabled_plugins..' Plugins Are Active\n\nStarting TDBD Robot...\n')
end

load_plugins()

function msg_valid(msg)
	if msg.date and msg.date < os.time() - 60 then
		print('\27[36m>>-- OLD MESSAGE --<<\27[39m')
		return false
	end
  if msg.sender_user_id == our_id and not msg.content.member_user_ids and msg.content._ ~= "messageChatDeleteMember" then
		print('\27[36m>>-- BOT MESSAGE --<<\27[39m')
		return false
	end
	if is_banned((msg.sender_user_id or 0), msg.chat_id) then
		del_msg(msg.chat_id, tonumber(msg.id))
		kick_user((msg.sender_user_id or 0), msg.chat_id)
		return false
	end
	if is_gbanned((msg.sender_user_id or 0)) then
		del_msg(msg.chat_id, tonumber(msg.id))
		kick_user((msg.sender_user_id or 0), msg.chat_id)
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
end

-- Check if plugin is on _config.disabled_plugin_on_chat table
local function is_plugin_disabled_on_chat(plugin_name, receiver)
  local disabled_chats = _config.disabled_plugin_on_chat
  -- Table exists and chat has disabled plugins
  if disabled_chats and disabled_chats[receiver] then
    -- Checks if plugin is disabled on this chat
    for disabled_plugin,disabled in pairs(disabled_chats[receiver]) do
      if disabled_plugin == plugin_name and disabled then
        local warning = '_Plugin_ *'..check_markdown(disabled_plugin)..'* _is disabled on this chat_'
        print(warning)
						-- tdbot.sendMessage(receiver, "", 0, warning, 0, "md")
        return true
      end
    end
  end
  return false
end

function match_plugin(plugin, plugin_name, msg)
	if plugin.pre_process then
        --If plugin is for privileged users only
		local result = plugin.pre_process(msg)
		if result then
			print("pre process: ", plugin_name)
        -- tdbot.sendMessage(msg.chat_id, "", 0, result, 0, "md")
		end
	end
	for k, pattern in pairs(plugin.patterns) do
		matches = match_pattern(pattern, msg.text  or msg.media.caption)
		if matches then
      if is_plugin_disabled_on_chat(plugin_name, msg.chat_id) then
        return nil
      end
			print("Message matches: ", pattern..' | Plugin: '..plugin_name)
			if plugin.run then
        if not warns_user_not_allowed(plugin, msg) then
				local result = plugin.run(msg, matches)
					if result then
						tdbot.sendText(msg.chat_id, msg.id, result, 0, 1, nil, 0, 'md', 0, nil)
                 end
					end
			end
			return
		end
	end
end

function file_cb(msg)
	if msg.content._ == "messagePhoto" then
		photo_id = ''
		local function get_cb(arg, data)
            if data.content then
		if data.content.photo.sizes[2] then
			photo_id = data.content.photo.sizes[2].photo.id
			elseif data.content.photo.sizes[1] then
			photo_id = data.content.photo.sizes[1].photo.id
			end
			tdbot.downloadFile(photo_id, 32, dl_cb, nil)
        end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = msg.chat_id, message_id = msg.id }, get_cb, nil))
	elseif msg.content._ == "messageVideo" then
		video_id = ''
		local function get_cb(arg, data)
            if data.content then
			video_id = data.content.video.video.id
			tdbot.downloadFile(video_id, 32, dl_cb, nil)
         end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = msg.chat_id, message_id = msg.id }, get_cb, nil))
	elseif msg.content._ == "messageAnimation" then
		anim_id, anim_name = '', ''
		local function get_cb(arg, data)
            if data.content then
			anim_id = data.content.animation.animation.id
			anim_name = data.content.animation.file_name
			 tdbot.downloadFile(anim_id, 32, dl_cb, nil)
         end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = msg.chat_id, message_id = msg.id }, get_cb, nil))
	elseif msg.content._ == "messageVoice" then
		voice_id = ''
		local function get_cb(arg, data)
            if data.content then
			voice_id = data.content.voice.voice.id
			tdbot.downloadFile(voice_id, 32, dl_cb, nil)
        end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = msg.chat_id, message_id = msg.id }, get_cb, nil))
	elseif msg.content._ == "messageAudio" then
		audio_id, audio_name, audio_title = '', '', ''
		local function get_cb(arg, data)
            if data.content then
			audio_id = data.content.audio.audio.id
			audio_name = data.content.audio.file_name
			audio_title = data.content.audio.title
			tdbot.downloadFile(audio_id, 32, dl_cb, nil)
        end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = msg.chat_id, message_id = msg.id }, get_cb, nil))
	elseif msg.content._ == "messageSticker" then
		sticker_id = ''
		local function get_cb(arg, data)
            if data.content then
			sticker_id = data.content.sticker.sticker.id
			tdbot.downloadFile(sticker_id, 32, dl_cb, nil)
        end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = msg.chat_id, message_id = msg.id }, get_cb, nil))
	elseif msg.content._ == "messageDocument" then
		document_id, document_name = '', ''
		local function get_cb(arg, data)
            if data.content then
			document_id = data.content.document.document.id
			document_name = data.content.document.file_name
			tdbot.downloadFile(document_id, 32, dl_cb, nil)
        end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = msg.chat_id, message_id = msg.id }, get_cb, nil))
end
end

function tdbot_update_callback (data)
	if data.message then
		if msg_caption ~= get_text_msg() then
			msg_caption = get_text_msg()
		end
	end
	if (data._ == "updateNewMessage") then
		local msg = data.message
		local d = data.disable_notification
		local chat = chats[msg.chat_id]
		 local hash = 'msgs:'..(msg.sender_user_id or 0)..':'..msg.chat_id
		 redis:incr(hash)
		if redis:get('markread') == 'on' then
          tdbot.openChat(msg.chat_id)
			tdbot.viewMessages(msg.chat_id, {[0] = msg.id}, dl_cb, nil)
		end
		if ((not d) and chat) then
			if msg.content._ == "messageText" then
				do_notify (chat.title, msg.content.text)
			else
				do_notify (chat.title, msg.content._)
			end
		end
		if msg_valid(msg) then
		var_cb(msg, msg)
  if redis:get("AutoDL:"..msg.chat_id) then
		 file_cb(msg)
 end
    if msg.forward_info then
	if msg.forward_info._ == "messageForwardedFromUser" then
		msg.fwd_from_user = true

	elseif msg.forward_info._ == "messageForwardedPost" then
		msg.fwd_from_channel = true
  end
end
	if msg.content._ == "messageText" then
			msg.text = msg.content.text
			msg.edited = false
			msg.pinned = false
		print('Message Text: '..'['..msg.sender_user_id..']->['..msg.chat_id..'] >>  '..msg.text)
	elseif msg.content._ == "messagePinMessage" then
		msg.pinned = true
	elseif msg.content._ == "messagePhoto" then
		msg.photo = true 
	elseif msg.content._ == "messageVideo" then
		msg.video = true

	elseif msg.content._ == "messageVideoNote" then
		msg.video_note = true

	elseif msg.content._ == "messageAnimation" then
		msg.animation = true

	elseif msg.content._ == "messageVoice" then
		msg.voice = true

	elseif msg.content._ == "messageAudio" then
		msg.audio = true

	elseif msg.content._ == "messageSticker" then
		msg.sticker = true

	elseif msg.content._ == "messageContact" then
		msg.contact = true

	elseif msg.content._ == "messageDocument" then
		msg.document = true

	elseif msg.content._ == "messageLocation" then
		msg.location = true
	elseif msg.content._ == "messageGame" then
		msg.game = true
	elseif msg.content._ == "messageChatAddMembers" then
   for k,v in pairs(msg.content.member_user_ids) do
			--for i=0,#msg.content.member_user_ids do
				msg.adduser = v
		end
		msg.tab = true
	elseif msg.content._ == "messageChatJoinByLink" then
			msg.joinuser = (msg.sender_user_id or 0)
	elseif msg.content._ == "messageChatDeleteMember" then
			msg.deluser = true
			
      end
	end
	elseif data._ == "updateMessageContent" then  
		 cmsg = data
		 local function edited_cb(arg, data)
			 msg = data
			 msg.media = {}
			if cmsg.new_content.text then
				 msg.text = cmsg.new_content.text
			 end
			 if cmsg.new_content.caption then
				 msg.media.caption = cmsg.new_content.caption
			 end
			 msg.edited = true
		 if msg_valid(msg) then
			 var_cb(msg, msg)
         end
		 end
	 assert (tdbot_function ({ _ = "getMessage", chat_id = data.chat_id, message_id = data.message_id }, edited_cb, nil))
	elseif (data._ == "updateChat") then
		chat = data.chat
		chats[chat.id] = chat
	elseif (data._ == "updateOption" and data.name == "my_id") then
		assert(tdbot_function ({_="getChats", offset_order="9223372036854775807", offset_chat_id=0, limit=20}, dl_cb, nil))    
	end
end

