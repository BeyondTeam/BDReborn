local function pre_process(msg)
chat = msg.chat_id_
user = msg.sender_user_id_
	local function check_newmember(arg, data)
		test = load_data(_config.moderation.data)
		lock_bots = test[arg.chat_id]['settings']['lock_bots']
    if data.type_.ID == "UserTypeBot" then
      if not is_owner(arg.msg) and lock_bots == 'yes' then
kick_user(data.id_, arg.chat_id)
end
end
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if is_banned(data.id_, arg.chat_id) then
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, "_User_ "..user_name.." *[ "..data.id_.." ]* _is banned_", 0, "md")
kick_user(data.id_, arg.chat_id)
end
if is_gbanned(data.id_) then
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, "_User_ "..user_name.." *[ "..data.id_.." ]* _is hammered_", 0, "md")
kick_user(data.id_, arg.chat_id)
     end
	end
	if msg.adduser then
			tdcli_function ({
	      ID = "GetUser",
      	user_id_ = msg.adduser
    	}, check_newmember, {chat_id=chat,msg_id=msg.id_,user_id=user,msg=msg})
	end
	if msg.joinuser then
			tdcli_function ({
	      ID = "GetUser",
      	user_id_ = msg.joinuser
    	}, check_newmember, {chat_id=chat,msg_id=msg.id_,user_id=user,msg=msg})
	end
if is_silent_user(user, chat) then
tdcli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
end
if is_banned(user, chat) then
tdcli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
    kick_user(user, chat)
   end
if is_gbanned(user) then
tdcli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
    kick_user(user, chat)
   end
end
local function action_by_reply(arg, data)
  local cmd = arg.cmd
if not tonumber(data.sender_user_id_) then return false end
  if cmd == "ban" then
local function ban_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
   if is_mod1(arg.chat_id, data.id_) then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_You can't ban_ *mods,owners and bot admins*", 0, "md")
     end
if administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] then
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already_ *banned*", 0, "md")
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id_, arg.chat_id)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *banned*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, ban_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
   if cmd == "unban" then
local function unban_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if not administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not_ *banned*", 0, "md")
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *unbanned*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, unban_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "silent" then
local function silent_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
   if is_mod1(arg.chat_id, data.id_) then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_You can't silent_ *mods,owners and bot admins*", 0, "md")
     end
if administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] then
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already_ *silent*", 0, "md")
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _added to_ *silent users list*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, silent_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "unsilent" then
local function unsilent_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if not administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not_ *silent*", 0, "md")
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _removed from_ *silent users list*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, unsilent_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "banall" then
local function gban_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
   if is_admin1(data.id_) then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_You can't_ *globally banned* _other admins_", 0, "md")
     end
if is_gbanned(data.id_) then
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already_ *globally banned*", 0, "md")
   end
  administration['gban_users'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id_, arg.chat_id)
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *globally banned*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, gban_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "unbanall" then
local function ungban_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
if not is_gbanned(data.id_) then
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not_ *globally banned*", 0, "md")
   end
  administration['gban_users'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *globally unbanned*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, ungban_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "kick" then
   if is_mod1(data.chat_id_, data.sender_user_id_) then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_You can't kick_ *mods,owners and bot admins*", 0, "md")
     else
     kick_user(data.sender_user_id_, data.chat_id_)
    end
  end
end
local function action_by_username(arg, data)
  local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
if data.type_.user_.username_ and not data.type_.user_.username_:match("_") then
user_name = '@'..data.type_.user_.username_
else
user_name = data.title_
end
if not arg.username then return false end
  if cmd == "ban" then
   if is_mod1(arg.chat_id, data.id_) then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_You can't ban_ *mods,owners and bot admins*", 0, "md")
     end
if administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] then
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already_ *banned*", 0, "md")
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id_, arg.chat_id)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *banned*", 0, "md")
end
   if cmd == "unban" then
if not administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not_ *banned*", 0, "md")
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *unbanned*", 0, "md")
end
  if cmd == "silent" then
   if is_mod1(arg.chat_id, data.id_) then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_You can't silent_ *mods,owners and bot admins*", 0, "md")
     end
if administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] then
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already_ *silent*", 0, "md")
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _added to_ *silent users list*", 0, "md")
end
  if cmd == "unsilent" then
if not administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not_ *silent*", 0, "md")
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _removed from_ *silent users list*", 0, "md")
end
  if cmd == "banall" then
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
   if is_admin1(data.id_) then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_You can't_ *globally banned* _other admins_", 0, "md")
     end
if is_gbanned(data.id_) then
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already_ *globally banned*", 0, "md")
   end
  administration['gban_users'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id_, arg.chat_id)
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *globally banned*", 0, "md")
end
  if cmd == "unbanall" then
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
if not is_gbanned(data.id_) then
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not_ *globally banned*", 0, "md")
   end
  administration['gban_users'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
     return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *globally unbanned*", 0, "md")
end
  if cmd == "kick" then
   if is_mod1(arg.chat_id, data.id_) then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_You can't kick_ *mods,owners and bot admins*", 0, "md")
     else
     kick_user(data.id_, arg.chat_id)
    end
  end
end
local function run(msg, matches)
local data = load_data(_config.moderation.data)
chat = msg.chat_id_
user = msg.sender_user_id_
 if matches[1] == "kick" and is_mod(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="kick"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if is_mod1(msg.chat_id_, matches[2]) then
     tdcli.sendMessage(msg.chat_id_, "", 0, "_You can't kick mods,owners or bot admins_", 0, "md")
     else
kick_user(matches[2], msg.chat_id_)
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="kick"})
         end
      end
 if matches[1] == "banall" and is_admin(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="banall"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if is_admin1(matches[2]) then
    return tdcli.sendMessage(msg.chat_id_, "", 0, "_You can't globally banned other admins_", 0, "md")
     end
   if is_gbanned(matches[2]) then
  return tdcli.sendMessage(msg.chat_id_, "", 0, "_User "..matches[2].." is already globally banned_", 0, "md")
     end
  data['gban_users'][tostring(matches[2])] = ""
    save_data(_config.moderation.data, data)
kick_user(matches[2], msg.chat_id_)
 return tdcli.sendMessage(msg.chat_id_, msg.id_, 0, "_User "..matches[2].." has been globally banned_", 0, "md")
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="banall"})
      end
   end
 if matches[1] == "unbanall" and is_admin(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="unbanall"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if not is_gbanned(matches[2]) then
   return tdcli.sendMessage(msg.chat_id_, "", 0, "_User "..matches[2].." is not globally banned_", 0, "md")
     end
  data['gban_users'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
return tdcli.sendMessage(msg.chat_id_, msg.id_, 0, "_User "..matches[2].." has been globally unbanned_", 0, "md")
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="unbanall"})
      end
   end
 if matches[1] == "ban" and is_mod(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="ban"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if is_mod1(msg.chat_id_, matches[2]) then
    return tdcli.sendMessage(msg.chat_id_, "", 0, "_You can't ban mods,owners or bot admins_", 0, "md")
     end
   if is_banned(matches[2], msg.chat_id_) then
  return tdcli.sendMessage(msg.chat_id_, "", 0, "_User "..matches[2].." is already banned_", 0, "md")
     end
data[tostring(chat)]['banned'][tostring(matches[2])] = ""
    save_data(_config.moderation.data, data)
kick_user(matches[2], msg.chat_id_)
 return tdcli.sendMessage(msg.chat_id_, msg.id_, 0, "_User "..matches[2].." has been banned_", 0, "md")
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
     tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="ban"})
      end
   end
 if matches[1] == "unban" and is_mod(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="unban"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if not is_banned(matches[2], msg.chat_id_) then
   return tdcli.sendMessage(msg.chat_id_, "", 0, "_User "..matches[2].." is not banned_", 0, "md")
     end
data[tostring(chat)]['banned'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
return tdcli.sendMessage(msg.chat_id_, msg.id_, 0, "_User "..matches[2].." has been unbanned_", 0, "md")
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="unban"})
      end
   end
 if matches[1] == "silent" and is_mod(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="silent"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if is_mod1(msg.chat_id_, matches[2]) then
   return tdcli.sendMessage(msg.chat_id_, "", 0, "_You can't silent mods,leaders or bot admins_", 0, "md")
     end
   if is_silent_user(matches[2], chat) then
   return tdcli.sendMessage(msg.chat_id_, "", 0, "_User "..matches[2].." is already silent_", 0, "md")
     end
data[tostring(chat)]['is_silent_users'][tostring(matches[2])] = ""
    save_data(_config.moderation.data, data)
 return tdcli.sendMessage(msg.chat_id_, msg.id_, 0, "_User "..matches[2].." added to silent users list_", 0, "md")
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="silent"})
      end
   end
 if matches[1] == "unsilent" and is_mod(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="unsilent"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if not is_silent_user(matches[2], chat) then
     return tdcli.sendMessage(msg.chat_id_, "", 0, "_User "..matches[2].." is not silent_", 0, "md")
     end
data[tostring(chat)]['is_silent_users'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
 return tdcli.sendMessage(msg.chat_id_, msg.id_, 0, "_User "..matches[2].." removed from silent users list_", 0, "md")
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="unsilent"})
      end
   end
		if matches[1]:lower() == 'clean' and is_owner(msg) then
			if matches[2] == 'bans' then
				if next(data[tostring(chat)]['banned']) == nil then
					return "_No_ *banned* _users in this group_"
				end
				for k,v in pairs(data[tostring(chat)]['banned']) do
					data[tostring(chat)]['banned'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "_All_ *banned* _users has been unbanned_"
			end
			if matches[2] == 'silentlist' then
				if next(data[tostring(chat)]['is_silent_users']) == nil then
					return "_No_ *silent* _users in this group_"
				end
				for k,v in pairs(data[tostring(chat)]['is_silent_users']) do
					data[tostring(chat)]['is_silent_users'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				    end
				return "*Silent list* _has been cleaned_"
			    end
        end
		if matches[1]:lower() == 'clean' and is_sudo(msg) then
			if matches[2] == 'gbans' then
				if next(data['gban_users']) == nil then
					return "_No_ *globally banned* _users available_"
				end
				for k,v in pairs(data['gban_users']) do
					data['gban_users'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "_All_ *globally banned* _users has been unbanned_"
			end
     end
if matches[1] == "gbanlist" and is_admin(msg) then
  return gbanned_list()
 end
if matches[1] == "silentlist" and is_mod(msg) then
  return silent_users_list(chat)
 end
if matches[1] == "banlist" and is_mod(msg) then
  return banned_list(chat)
 end
end
return {
	patterns = {
		"^[!/#](banall)$",
		"^[!/#](banall) (.*)$",
		"^[!/#](unbanall)$",
		"^[!/#](unbanall) (.*)$",
		"^[!/#](gbanlist)$",
		"^[!/#](ban)$",
		"^[!/#](ban) (.*)$",
		"^[!/#](unban)$",
		"^[!/#](unban) (.*)$",
		"^[!/#](banlist)$",
		"^[!/#](silent)$",
		"^[!/#](silent) (.*)$",
		"^[!/#](unsilent)$",
		"^[!/#](unsilent) (.*)$",
		"^[!/#](silentlist)$",
		"^[!/#](kick)$",
		"^[!/#](kick) (.*)$",
		"^[!/#](clean) (.*)$",
	},
	run = run,
pre_process = pre_process
}
