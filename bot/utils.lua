--Begin Utils.lua By #BeyondTeam :)
 local clock = os.clock
function sleep(time)  -- seconds
  local t0 = clock()
  while clock() - t0 <= time do end
end

function var_cb(msg, data)
  -------------Get Var------------
	bot = {}
	msg.to = {}
	msg.from = {}
	msg.media = {}
  msg.entity = {}
 if tonumber(msg.via_bot_user_id) ~= 0 then
     msg.inline = true
  end
 if msg.content and msg.reply_markup and  msg.reply_markup._ == "replyMarkupInlineKeyboard" then
   msg.keyboard = true
  end
if msg.content and msg.content.entities then
  for k,entities in pairs(msg.content.entities) do
    if entities.type._ == "textEntityTypeMentionName" then
   msg.entity.mention = true
   msg.entity.user_id = entities.type.user_id
      end
    if entities.type._ == "textEntityTypeBold" then
   msg.entity.bold = true
      end
    if entities.type._ == "textEntityTypeCode" then
   msg.entity.code = true
      end
    if entities.type._ == "textEntityTypePre" then
   msg.entity.pre = true
      end
    if entities.type._ == "textEntityTypeItalic" then
   msg.entity.italic = true
      end
    if entities.type._ == "textEntityTypeMention" then
   msg.entity.username = true
      end
    if entities.type._ == "textEntityTypeHashtag" then
   msg.entity.hashtag = true
      end
  if entities.type._ == "textEntityTypeUrl" or entities.type._ == "textEntityTypeTextUrl" then
      msg.entity.webpage = true
      end
  if entities.type._ == "textEntityTypeBold" or entities.type._ == "textEntityTypeCode" or entities.type._ == "textEntityTypePre" or entities.type._ == "textEntityTypeItalic" then
  msg.entity.markdown = true
          end
      end
 end
	msg.to.type = gp_type(data.chat_id)
	if data.content and data.content.caption then
		msg.media.caption = data.content.caption
	end

	if data.reply_to_message_id ~= 0 then
		msg.reply_id = data.reply_to_message_id
    else
		msg.reply_id = false
	end
	 function get_gp(arg, data)
		if gp_type(msg.chat_id) == "channel" or gp_type(msg.chat_id) == "chat" then
			msg.to.id = msg.chat_id or 0
			msg.to.title = data.title
		else
			msg.to.id = msg.chat_id or 0
			msg.to.title = false
		end
	end
	assert (tdbot_function ({ _ = "getChat", chat_id = data.chat_id }, get_gp, nil))
	function botifo_cb(arg, data)
		bot.id = data.id
		our_id = data.id
		if data.username then
			bot.username = data.username
		else
			bot.username = false
		end
		if data.first_name then
			bot.first_name = data.first_name
		end
		if data.last_name then
			bot.last_name = data.last_name
		else
			bot.last_name = false
		end
		if data.first_name and data.last_name then
			bot.print_name = data.first_name..' '..data.last_name
		else
			bot.print_name = data.first_name
		end
		if data.phone_number then
			bot.phone = data.phone_number
		else
			bot.phone = false
		end
	end
	assert (tdbot_function({ _ = 'getMe'}, botifo_cb, {chat_id=msg.chat_id}))
	 function get_user(arg, data)
     if data.id then
		msg.from.id = data.id
  else
     msg.from.id = 0
  end
		if data.username then
			msg.from.username = data.username
		else
			msg.from.username = false
		end
		if data.first_name then
			msg.from.first_name = data.first_name
		end
		if data.last_name then
			msg.from.last_name = data.last_name
		else
			msg.from.last_name = false
		end
		if data.first_name and data.last_name then
			msg.from.print_name = data.first_name..' '..data.last_name
		else
			msg.from.print_name = data.first_name
		end
		if data.phone_number then
			msg.from.phone = data.phone_number
		else
			msg.from.phone = false
		end
		match_plugins(msg)

	end
	assert (tdbot_function ({ _ = "getUser", user_id = (data.sender_user_id or 0)}, get_user, nil))
-------------End-------------

end

function set_config(msg)
local function config_cb(arg, data)
local hash = "gp_lang:"..msg.to.id
print(serpent.block(data))
local lang = redis:get(hash)
  --print(serpent.block(data))
   for k,v in pairs(data.members) do
   local function config_mods(arg, data)
       local administration = load_data(_config.moderation.data)
if data.username then
user_name = '@'..check_markdown(data.username)
else
user_name = check_markdown(data.first_name)
end
administration[tostring(msg.to.id)]['mods'][tostring(data.id)] = user_name
    save_data(_config.moderation.data, administration)
   end
assert (tdbot_function ({
    _ = "getUser",
    user_id = v.user_id
  }, config_mods, {user_id=v.user_id}))
 
if data.members[k].status._ == "chatMemberStatusCreator" then
owner_id = v.user_id
   local function config_owner(arg, data)
 -- print(serpent.block(data))
       local administration = load_data(_config.moderation.data)
if data.username then
user_name = '@'..check_markdown(data.username)
else
user_name = check_markdown(data.first_name)
end
administration[tostring(msg.to.id)]['owners'][tostring(data.id)] = user_name
    save_data(_config.moderation.data, administration)
   end
assert (tdbot_function ({
    _ = "getUser",
    user_id = owner_id
  }, config_owner, {user_id=owner_id}))
   end
end
  if not lang then
    return tdbot.sendText(msg.chat_id, msg.id, "_All group admins has been promoted and group creator is now group owner_", 0, 1, nil, 0, 'md', 0, nil)
else
    return tdbot.sendText(msg.chat_id, msg.id, "_تمام ادمین های گروه به مقام مدیر منتصب شدند و سازنده گروه به مقام مالک گروه منتصب شد_", 0, 1, nil, 0, 'md', 0, nil)
     end
 end
 --tdbot.getChannelMembers(msg.to.id, 0, 'Administrators', 200, config_cb, {chat_id=msg.to.id})
tdbot.getChannelMembers(msg.to.id, 0, 200, 'Administrators', config_cb, {chat_id=msg.to.id})
end

function serialize_to_file(data, file, uglify)
  file = io.open(file, 'w+')
  local serialized
  if not uglify then
    serialized = serpent.block(data, {
        comment = false,
        name = '_'
      })
  else
    serialized = serpent.dump(data)
  end
  file:write(serialized)
  file:close()
end
function string.random(length)
   local str = "";
   for i = 1, length do
      math.random(97, 122)
      str = str..string.char(math.random(97, 122));
   end
   return str;
end

function string:split(sep)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end

-- DEPRECATED
function string.trim(s)
  print("string.trim(s) is DEPRECATED use string:trim() instead")
  return s:gsub("^%s*(.-)%s*$", "%1")
end

-- Removes spaces
function string:trim()
  return self:gsub("^%s*(.-)%s*$", "%1")
end

function get_http_file_name(url, headers)
  -- Eg: foo.var
  local file_name = url:match("[^%w]+([%.%w]+)$")
  -- Any delimited alphanumeric on the url
  file_name = file_name or url:match("[^%w]+(%w+)[^%w]+$")
  -- Random name, hope content-type works
  file_name = file_name or str:random(5)

  local content_type = headers["content-type"]

  local extension = nil
  if content_type then
    extension = mimetype.get_mime_extension(content_type)
  end
  if extension then
    file_name = file_name.."."..extension
  end

  local disposition = headers["content-disposition"]
  if disposition then
    -- checking
    -- attachment; filename=CodeCogsEqn.png
    file_name = disposition:match('filename=([^;]+)') or file_name
  end
	-- return
  return file_name
end

--  Saves file to /tmp/. If file_name isn't provided,
-- will get the text after the last "/" for filename
-- do ski
msg_caption = '\n@'..string.reverse("maeTdnoyeB")
-- Waiting for ski:)
-- and content-type for extension
function download_to_file(url, file_name)
  -- print to server
  -- print("url to download: "..url)
  -- uncomment if needed
  local respbody = {}
  local options = {
    url = url,
    sink = ltn12.sink.table(respbody),
    redirect = true
  }

  -- nil, code, headers, status
  local response = nil

  if url:starts('https') then
    options.redirect = false
    response = {https.request(options)}
  else
    response = {http.request(options)}
  end

  local code = response[2]
  local headers = response[3]
  local status = response[4]

  if code ~= 200 then return nil end

  file_name = file_name or get_http_file_name(url, headers)

  local file_path = "data/"..file_name
  -- print("Saved to: "..file_path)
	-- uncomment if needed
  file = io.open(file_path, "w+")
  file:write(table.concat(respbody))
  file:close()

  return file_path
end
function run_command(str)
  local cmd = io.popen(str)
  local result = cmd:read('*all')
  cmd:close()
  return result
end
function string:isempty()
  return self == nil or self == ''
end

-- Returns true if the string is blank
function string:isblank()
  self = self:trim()
  return self:isempty()
end

-- DEPRECATED!!!!!
function string.starts(String, Start)
  -- print("string.starts(String, Start) is DEPRECATED use string:starts(text) instead")
  -- uncomment if needed
  return Start == string.sub(String,1,string.len(Start))
end
-- Returns true if String starts with Start
function string:starts(text)
  return text == string.sub(self,1,string.len(text))
end
function unescape_html(str)
  local map = {
    ["lt"]  = "<",
    ["gt"]  = ">",
    ["amp"] = "&",
    ["quot"] = '"',
    ["apos"] = "'"
  }
  new = string.gsub(str, '(&(#?x?)([%d%a]+);)', function(orig, n, s)
    var = map[s] or n == "#" and string.char(s)
    var = var or n == "#x" and string.char(tonumber(s,16))
    var = var or orig
    return var
  end)
  return new
end
function pairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
      i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end

function run_bash(str)
    local cmd = io.popen(str)
    local result = cmd:read('*all')
    return result
end

function scandir(directory)
  local i, t, popen = 0, {}, io.popen
  for filename in popen('ls -a "'..directory..'"'):lines() do
    i = i + 1
    t[i] = filename
  end
  return t
end

function plugins_names( )
  local files = {}
  for k, v in pairs(scandir("plugins")) do
    -- Ends with .lua
    if (v:match(".lua$")) then
      table.insert(files, v)
    end
  end
  return files
end

-- Function name explains what it does.
function file_exists(name)
  local f = io.open(name,"r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function gp_type(chat_id)
  local gp_type = "pv"
  local id = tostring(chat_id)
    if id:match("^-100") then
      gp_type = "channel"
    elseif id:match("-") then
      gp_type = "chat"
  end
  return gp_type
end

function is_reply(msg)
  local var = false
    if msg.reply_to_message_id ~= 0 then -- reply message id is not 0
      var = true
    end
  return var
end

function is_supergroup(msg)
  chat_id = tostring(msg.chat_id)
  if chat_id:match('^-100') then --supergroups and channels start with -100
    if not msg.is_post_ then
    return true
    end
  else
    return false
  end
end

function is_channel(msg)
  chat_id = tostring(msg.chat_id)
  if chat_id:match('^-100') then -- Start with -100 (like channels and supergroups)
  if msg.is_post_ then -- message is a channel post
    return true
  else
    return false
  end
  end
end

function is_group(msg)
  chat_id = tostring(msg.chat_id)
  if chat_id:match('^-100') then --not start with -100 (normal groups does not have -100 in first)
    return false
  elseif chat_id:match('^-') then
    return true
  else
    return false
  end
end

function is_private(msg)
  chat_id = tostring(msg.chat_id)
  if chat_id:match('^-') then --private chat does not start with -
    return false
  else
    return true
  end
end

function check_markdown(text) --markdown escape ( when you need to escape markdown , use it like : check_markdown('your text')
		str = text
        if str ~= nil then
		if str:match('_') then
			output = str:gsub('_',[[\_]])
		elseif str:match('*') then
			output = str:gsub('*','\\*')
		elseif str:match('`') then
			output = str:gsub('`','\\`')
		else
			output = str
		end
	return output
   end
end

function is_sudo(msg)
  local var = false
  -- Check users id in config
  for v,user in pairs(_config.sudo_users) do
    if user == msg.sender_user_id then
      var = true
    end
  end
  return var
end

function is_owner(msg)
  local var = false
  local data = load_data(_config.moderation.data)
  local user = msg.sender_user_id
  if data[tostring(msg.chat_id)] then
    if data[tostring(msg.chat_id)]['owners'] then
      if data[tostring(msg.chat_id)]['owners'][tostring(msg.sender_user_id)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == msg.sender_user_id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == msg.sender_user_id then
        var = true
    end
  end
  return var
end

function is_admin(msg)
  local var = false
  local user = msg.sender_user_id
  for v,user in pairs(_config.admins) do
    if user[1] == msg.sender_user_id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == msg.sender_user_id then
        var = true
    end
  end
  return var
end

--Check if user is the mod of that group or not
function is_mod(msg)
  local var = false
  local data = load_data(_config.moderation.data)
  local usert = msg.sender_user_id
  if data[tostring(msg.chat_id)] then
    if data[tostring(msg.chat_id)]['mods'] then
      if data[tostring(msg.chat_id)]['mods'][tostring(msg.sender_user_id)] then
        var = true
      end
    end
  end

  if data[tostring(msg.chat_id)] then
    if data[tostring(msg.chat_id)]['owners'] then
      if data[tostring(msg.chat_id)]['owners'][tostring(msg.sender_user_id)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == msg.sender_user_id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == msg.sender_user_id then
        var = true
    end
  end
  return var
end

function is_sudo1(user_id)
  local var = false
  -- Check users id in config
  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
      var = true
    end
  end
  return var
end

function is_owner1(chat_id, user_id)
  local var = false
  local data = load_data(_config.moderation.data)
  local user = user_id
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['owners'] then
      if data[tostring(chat_id)]['owners'][tostring(user)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == user_id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
        var = true
    end
  end
  return var
end

function is_admin1(user_id)
  local var = false
  local user = user_id
  for v,user in pairs(_config.admins) do
    if user[1] == user_id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
        var = true
    end
  end
  return var
end

--Check if user is the mod of that group or not
function is_mod1(chat_id, user_id)
  local var = false
  local data = load_data(_config.moderation.data)
  local usert = user_id
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['mods'] then
      if data[tostring(chat_id)]['mods'][tostring(usert)] then
        var = true
      end
    end
  end

  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['owners'] then
      if data[tostring(chat_id)]['owners'][tostring(usert)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == user_id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
        var = true
    end
  end
  return var
end

-- Check if user can use the plugin and warns user
-- Returns true if user was warned and false if not warned (is allowed)
function warns_user_not_allowed(plugin, msg)
  if not user_allowed(plugin, msg) then
    local text = '*This plugin requires privileged user*'
    local receiver = msg.chat_id
    tdbot.sendText(msg.chat_id, msg.id, text, 0, 1, nil, 0, 'md', 0, nil)
    return true
  else
    return false
  end
end

-- Check if user can use the plugin
function user_allowed(plugin, msg)
  if plugin.privileged and not is_sudo(msg) then
    return false
  end
  return true
end

 function is_banned(user_id, chat_id)
  local var = false
  local data = load_data(_config.moderation.data)
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['banned'] then
      if data[tostring(chat_id)]['banned'][tostring(user_id)] then
        var = true
      end
    end
  end
return var
end

function is_silent_user(userid, chatid, msg, func)
	function check_silent(arg, data)
		local var = false
		if data.members then
			for k,v in pairs(data.members) do
				if(v.user_id == userid)then var = true end
			end
		end
		if func then
			func(msg, var)
		end
	end
	tdbot.getChannelMembers(chatid, 0, 100000, 'Restricted', check_silent)
end

function is_whitelist(user_id, chat_id)
  local var = false
  local data = load_data(_config.moderation.data)
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['whitelist'] then
      if data[tostring(chat_id)]['whitelist'][tostring(user_id)] then
        var = true
      end
    end
  end
return var
end

function is_gbanned(user_id)
  local var = false
  local data = load_data(_config.moderation.data)
  local user = user_id
  local gban_users = 'gban_users'
  if data[tostring(gban_users)] then
    if data[tostring(gban_users)][tostring(user)] then
      var = true
    end
  end
return var
end

function is_filter(msg, text)
local var = false
local data = load_data(_config.moderation.data)
  if data[tostring(msg.chat_id)]['filterlist'] then
for k,v in pairs(data[tostring(msg.chat_id)]['filterlist']) do 
    if string.find(string.lower(text), string.lower(k)) then
       var = true
        end
     end
  end
 return var
end

 function kick_user(user_id, chat_id)
 if not tonumber(user_id) then
 return false
 end
   tdbot.changeChatMemberStatus(chat_id, user_id, 'Banned', {0}, dl_cb, nil)
 end

function del_msg(chat_id, message_ids)
local msgid = {[0] = message_ids}
  tdbot.deleteMessages(chat_id, msgid, true, dl_cb, nil)
end

 function channel_unblock(chat_id, user_id)
    tdbot.changeChatMemberStatus(chat_id, user_id, 'Left', dl_cb, nil)
 end

  function channel_set_admin(chat_id, user_id)
   tdbot.changeChatMemberStatus(chat_id, user_id, 'Administrators', {1, 1, 1, 1, 1, 1, 1, 1, 0}, dl_cb, nil)
 end

  function channel_demote(chat_id, user_id)
   tdbot.changeChatMemberStatus(chat_id, user_id, 'Restricted', {1, 0, 1, 1, 1, 1}, dl_cb, nil)
 end

  function silent_user(chat_id, user_id)
   tdbot.changeChatMemberStatus(chat_id, user_id, 'Restricted', {1, 0, 0, 0, 0, 0}, dl_cb, nil)
 end

  function unsilent_user(chat_id, user_id)
   tdbot.changeChatMemberStatus(chat_id, user_id, 'Restricted', {1, 0, 1, 1, 1, 1}, dl_cb, nil)
 end

function file_dl(file_id)
	tdbot.downloadFile(file_id, 32, dl_cb, nil)
end

 function banned_list(chat_id)
local hash = "gp_lang:"..chat_id
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(chat_id)] then
  if not lang then
    return '_Group is not added_'
else
    return 'گروه به لیست گروه های مدیریتی ربات اضافه نشده است'
   end
  end
  -- determine if table is empty
  if next(data[tostring(chat_id)]['banned']) == nil then --fix way
     if not lang then
					return "_No_ *banned* _users in this group_"
   else
					return "*هیچ کاربری از این گروه محروم نشده*"
              end
				end
       if not lang then
   message = '*List of banned users :*\n'
         else
   message = '_لیست کاربران محروم شده از گروه :_\n'
     end
  for k,v in pairs(data[tostring(chat_id)]['banned']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

function silent_users_list(msg)
	local hash = "gp_lang:"..msg.to.id
	local lang = redis:get(hash)
	local function GetRestricted(arg, data)
		msg=arg.msg
		local i = 1
		if not lang then
			message = '*List of silent users :*\n'
		else
			message = '_لیست کاربران سایلنت شده :_\n'
		end
		local un = ''
		if data.total_count > 0 then
			i = 1
			k = 0
			local function getuser(arg, mdata)
				local ST = data.members[k].status
				if ST.can_add_web_page_previews == false and ST.can_send_media_messages == false and ST.can_send_messages == false and ST.can_send_other_messages == false and ST.is_member == true then
					if mdata.username then
						un = '@'..mdata.username
					else
						un = mdata.first_name
					end
					message = message ..i.. '-'..' '..check_markdown(un)..' [' ..data.members[k].user_id.. '] \n'
					i = i + 1
				end
				k = k + 1
				if k < data.total_count then
					tdbot.getUser(data.members[k].user_id, getuser, nil)
				else
					if i == 1 then
						if not lang then
							return tdbot.sendMessage(msg.to.id, msg.id, 0, "_No_ *silent* _users in this group_", 0, "md")
						else
							return tdbot.sendMessage(msg.to.id, msg.id, 0, "*لیست کاربران سایلنت شده خالی است*", 0, "md")
						end
					else
						return tdbot.sendMessage(msg.to.id, msg.id, 0, message, 0, "md")
					end
				end
			end
			tdbot.getUser(data.members[k].user_id, getuser, nil)
		else
			if not lang then
				return tdbot.sendMessage(msg.to.id, msg.id, 0, "_No_ *silent* _users in this group_", 0, "md")
			else
				return tdbot.sendMessage(msg.to.id, msg.id, 0, "*لیست کاربران سایلنت شده خالی است*", 0, "md")
			end
		end
	end
	tdbot.getChannelMembers(msg.to.id, 0, 100000, 'Restricted', GetRestricted, {msg=msg})
end

function whitelist(chat_id)
local hash = "gp_lang:"..chat_id
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(chat_id)] then
  if not lang then
    return '_Group is not added_'
else
    return 'گروه به لیست گروه های مدیریتی ربات اضافه نشده است'
   end
  end
  if not data[tostring(chat_id)]['whitelist'] then
    data[tostring(chat_id)]['whitelist'] = {}
    save_data(_config.moderation.data, data)
    end
  -- determine if table is empty
  if next(data[tostring(chat_id)]['whitelist']) == nil then --fix way
     if not lang then
					return "_No_ *users* _in white list_"
   else
					return "*هیچ کاربری در لیست سفید وجود ندارد*"
              end
				end
       if not lang then
   message = '*Users of white list :*\n'
         else
   message = '_کاربران لیست سفید :_\n'
     end
  for k,v in pairs(data[tostring(chat_id)]['whitelist']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

 function gbanned_list(msg)
local hash = "gp_lang:"..msg.chat_id
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data['gban_users'] then
    data['gban_users'] = {}
    save_data(_config.moderation.data, data)
  end
  if next(data['gban_users']) == nil then --fix way
    if not lang then
					return "_No_ *globally banned* _users available_"
   else
					return "*هیچ کاربری از گروه های ربات محروم نشده*"
             end
				end
        if not lang then
   message = '*List of globally banned users :*\n'
   else
   message = '_لیست کاربران محروم شده از گروه های ربات :_\n'
   end
  for k,v in pairs(data['gban_users']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

 function filter_list(msg)
local hash = "gp_lang:"..msg.chat_id
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
  if not data[tostring(msg.chat_id)]['filterlist'] then
    data[tostring(msg.chat_id)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
  if not data[tostring(msg.chat_id)] then
  if not lang then
    return '_Group is not added_'
else
    return 'گروه به لیست گروه های مدیریتی ربات اضافه نشده است'
   end
  end
  -- determine if table is empty
  if next(data[tostring(msg.chat_id)]['filterlist']) == nil then --fix way
      if not lang then
    return "*Filtered words list* _is empty_"
      else
    return "_لیست کلمات فیلتر شده خالی است_"
     end
  end
  if not data[tostring(msg.chat_id)]['filterlist'] then
    data[tostring(msg.chat_id)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
      if not lang then
       filterlist = '*List of filtered words :*\n'
         else
       filterlist = '_لیست کلمات فیلتر شده :_\n'
    end
 local i = 1
   for k,v in pairs(data[tostring(msg.chat_id)]['filterlist']) do
              filterlist = filterlist..'*'..i..'* - _'..check_markdown(k)..'_\n'
             i = i + 1
         end
     return filterlist
   end

