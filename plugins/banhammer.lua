local function pre_process(msg)
   if msg.to.type ~= 'pv' then
chat = msg.to.id
user = msg.from.id
	local function check_newmember(arg, data)
		test = load_data(_config.moderation.data)
		if test[arg.chat_id] then
  if test[arg.chat_id]['settings'] then
  lock_bots = test[arg.chat_id]['settings']['lock_bots']
   end
end
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    if data.type._ == "userTypeBot" then
      if not is_owner(arg.msg) and lock_bots == 'yes' then
kick_user(data.id, arg.chat_id)
end
end
if data.username then
user_name = '@'..check_markdown(data.username)
else
user_name = check_markdown(data.first_name)
end
if is_banned(data.id, arg.chat_id) then
   if not lang then
		tdbot.sendMessage(arg.chat_id, arg.msg_id, 0, "_User_ "..user_name.." *[ "..data.id.." ]* _is banned_", 0, "md")
   else
		tdbot.sendMessage(arg.chat_id, arg.msg_id, 0, "_کاربر_ "..user_name.." *[ "..data.id.." ]* _از گروه محروم است_", 0, "md")
end
kick_user(data.id, arg.chat_id)
end
if is_gbanned(data.id) then
     if not lang then
		tdbot.sendMessage(arg.chat_id, arg.msg_id, 0, "_User_ "..user_name.." *[ "..data.id.." ]* _is globally banned_", 0, "md")
    else
		tdbot.sendMessage(arg.chat_id, arg.msg_id, 0, "_کاربر_ "..user_name.." *[ "..data.id.." ]* _از تمام گروه های ربات محروم است_", 0, "md")
   end
kick_user(data.id, arg.chat_id)
     end
	end
	if msg.adduser then
			assert(tdbot_function ({
	      _ = "getUser",
      	user_id = msg.adduser
    	}, check_newmember, {chat_id=chat,msg_id=msg.id,user_id=user,msg=msg}))
	end
	if msg.joinuser then
			assert(tdbot_function ({
	      _ = "getUser",
      	user_id = msg.joinuser
    	}, check_newmember, {chat_id=chat,msg_id=msg.id,user_id=user,msg=msg}))
	   end
   end
   -- return msg
end
local function action_by_reply(arg, data)
local hash = "gp_lang:"..data.chat_id
local lang = redis:get(hash)
  local cmd = arg.cmd
if not tonumber(data.sender_user_id) then return false end
if data.sender_user_id then
  if cmd == "ban" then
local function ban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username then
user_name = '@'..check_markdown(data.username)
else
user_name = check_markdown(data.first_name)
end
     if data.id == our_id then
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_I can't ban_ *my self*", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*من نمیتوانم خودم رو از گروه محروم کنم*", 0, "md")
         end
     end
   if is_mod1(arg.chat_id, data.id) then
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_You can't ban_ *mods,owners and bot admins*", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید مدیران،صاحبان گروه، و ادمین های ربات رو از گروه محروم کنید*", 0, "md")
         end
     end
if administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] then
    if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _is already_ *banned*", 0, "md")
   else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* * از گروه محروم بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id, arg.chat_id)
    if not lang then
    return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _has been_ *banned*", 0, "md")
    else
    return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از گروه محروم شد*", 0, "md")
   end
end
assert(tdbot_function ({
    _ = "getUser",
    user_id = data.sender_user_id
  }, ban_cb, {chat_id=data.chat_id,user_id=data.sender_user_id}))
  end
   if cmd == "unban" then
local function unban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username then
user_name = '@'..check_markdown(data.username)
else
user_name = check_markdown(data.first_name)
end
if not administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] then
    if not lang then
    return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _is not_ *banned*", 0, "md")
   else
    return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از گروه محروم نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] = nil
    save_data(_config.moderation.data, administration)
channel_unblock(arg.chat_id, data.id)
   if not lang then
    return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _has been_ *unbanned*", 0, "md")
   else
    return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از محرومیت گروه خارج شد*", 0, "md")
   end
end
assert(tdbot_function ({
    _ = "getUser",
    user_id = data.sender_user_id
  }, unban_cb, {chat_id=data.chat_id,user_id=data.sender_user_id}))
  end
  if cmd == "silent" then
local function silent_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username then
user_name = '@'..check_markdown(data.username)
else
user_name = check_markdown(data.first_name)
end
     if data.id == our_id then
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_I can't silent_ *my self*", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*من نمیتوانم توانایی چت کردن رو از خودم بگیرم*", 0, "md")
         end
     end
   if is_mod1(arg.chat_id, data.id) then
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_You can't silent_ *mods,owners and bot admins*", 0, "md")
    else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید توانایی چت کردن رو از مدیران،صاحبان گروه، و ادمین های ربات بگیرید*", 0, "md")
       end
     end
if administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] then
    if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _is already_ *silent*", 0, "md")
  else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از قبل توانایی چت کردن رو نداشت*", 0, "md")
     end
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] = user_name
    save_data(_config.moderation.data, administration)
  if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _added to_ *silent users list*", 0, "md")
  else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *توانایی چت کردن رو از دست داد*", 0, "md")
   end
end
assert(tdbot_function ({
    _ = "getUser",
    user_id = data.sender_user_id
  }, silent_cb, {chat_id=data.chat_id,user_id=data.sender_user_id}))
  end
  if cmd == "unsilent" then
local function unsilent_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username then
user_name = '@'..check_markdown(data.username)
else
user_name = check_markdown(data.first_name)
end
if not administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] then
   if not lang then
    return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _is not_ *silent*", 0, "md")
   else
    return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از قبل توانایی چت کردن را داشت*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] = nil
    save_data(_config.moderation.data, administration)
    if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _removed from_ *silent users list*", 0, "md")
  else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *توانایی چت کردن رو به دست آورد*", 0, "md")
   end
end
assert(tdbot_function ({
    _ = "getUser",
    user_id = data.sender_user_id
  }, unsilent_cb, {chat_id=data.chat_id,user_id=data.sender_user_id}))
  end
  if cmd == "banall" then
local function gban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username then
user_name = '@'..check_markdown(data.username)
else
user_name = check_markdown(data.first_name)
end
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
     if data.id == our_id then
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_I can't globally ban_ *my self*", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*من نمیتوانم خودم رو از تمام گروه های ربات محروم کنم*", 0, "md")
         end
     end
   if is_admin1(data.id) then
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_You can't_ *globally ban* _other admins_", 0, "md")
  else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید ادمین های ربات رو از تمامی گروه های ربات محروم کنید*", 0, "md")
        end
     end
if is_gbanned(data.id) then
   if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _is already_ *globally banned*", 0, "md")
    else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از گروه های ربات محروم بود*", 0, "md")
      end
   end
  administration['gban_users'][tostring(data.id)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id, arg.chat_id)
     if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _has been_ *globally banned*", 0, "md")
   else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از تمام گروه های ربات محروم شد*", 0, "md")
   end
end
assert(tdbot_function ({
    _ = "getUser",
    user_id = data.sender_user_id
  }, gban_cb, {chat_id=data.chat_id,user_id=data.sender_user_id}))
  end
  if cmd == "unbanall" then
local function ungban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username then
user_name = '@'..check_markdown(data.username)
else
user_name = check_markdown(data.first_name)
end
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
if not is_gbanned(data.id) then
   if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _is not_ *globally banned*", 0, "md")
   else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از گروه های ربات محروم نبود*", 0, "md")
      end
   end
  administration['gban_users'][tostring(data.id)] = nil
    save_data(_config.moderation.data, administration)
    if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _has been_ *globally unbanned*", 0, "md")
   else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از محرومیت گروه های ربات خارج شد*", 0, "md")
   end
end
assert(tdbot_function ({
    _ = "getUser",
    user_id = data.sender_user_id
  }, ungban_cb, {chat_id=data.chat_id,user_id=data.sender_user_id}))
  end
  if cmd == "kick" then
     if data.sender_user_id == our_id then
  if not lang then
  return tdbot.sendMessage(data.chat_id, "", 0, "_I can't kick_ *my self*", 0, "md")
   else
  return tdbot.sendMessage(data.chat_id, "", 0, "*من نمیتوانم خودم رو از گروه اخراج کنم کنم*", 0, "md")
         end
   elseif is_mod1(data.chat_id, data.sender_user_id) then
   if not lang then
  return tdbot.sendMessage(data.chat_id, "", 0, "_You can't kick_ *mods,owners and bot admins*", 0, "md")
    elseif lang then
  return tdbot.sendMessage(data.chat_id, "", 0, "*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو اخراج کنید*", 0, "md")
   end
  else
     kick_user(data.sender_user_id, data.chat_id)
    sleep(1)
channel_unblock(data.chat_id, data.sender_user_id)
     end
  end
  if cmd == "delall" then
   if is_mod1(data.chat_id, data.sender_user_id) then
   if not lang then
  return tdbot.sendMessage(data.chat_id, "", 0, "_You can't delete messages_ *mods,owners and bot admins*", 0, "md")
   elseif lang then
  return tdbot.sendMessage(data.chat_id, "", 0, "*شما نمیتوانید پیام های مدیران،صاحبان گروه و ادمین های ربات رو پاک کنید*", 0, "md")
   end
  else
tdbot.deleteMessagesFromUser(data.chat_id, data.sender_user_id, dl_cb, nil)
   if not lang then
  return tdbot.sendMessage(data.chat_id_, "", 0, "_All_ *messages* _of_ *[ "..data.sender_user_id.." ]* _has been_ *deleted*", 0, "md")
      elseif lang then
  return tdbot.sendMessage(data.chat_id, "", 0, "*تمام پیام های* *[ "..data.sender_user_id.." ]* *پاک شد*", 0, "md")
       end
    end
  end
else
    if lang then
  return tdbot.sendMessage(data.chat_id, "", 0, "_کاربر یافت نشد_", 0, "md")
   else
  return tdbot.sendMessage(data.chat_id, "", 0, "*User Not Found*", 0, "md")
      end
   end
end
local function action_by_username(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
  local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
if not arg.username then return false end
    if data.id then
  if cmd == "ban" then
local function ban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if not data.id then 
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_This user doesn't exists._", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*کاربر موردنظر وجود ندارد*", 0, "md")
     end
 end
    local administration = load_data(_config.moderation.data)
if data.username then
user_name = '@'..check_markdown(data.username)
else
user_name = check_markdown(data.first_name)
end
     if data.id == our_id then
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_I can't ban_ *my self*", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*من نمیتوانم خودم رو از گروه محروم کنم*", 0, "md")
         end
     end
   if is_mod1(arg.chat_id, data.id) then
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_You can't ban_ *mods,owners and bot admins*", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید مدیران،صاحبان گروه، و ادمین های ربات رو از گروه محروم کنید*", 0, "md")
         end
     end
if administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] then
    if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _is already_ *banned*", 0, "md")
   else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* * از گروه محروم بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id, arg.chat_id)
    if not lang then
    return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _has been_ *banned*", 0, "md")
    else
    return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از گروه محروم شد*", 0, "md")
   end
end
assert(tdbot_function ({
    _ = "getUser",
    user_id = data.id
  }, ban_cb, {chat_id=arg.chat_id,user_id=data.id}))
  end
   if cmd == "unban" then
local function unban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if not data.id then 
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_This user doesn't exists._", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*کاربر موردنظر وجود ندارد*", 0, "md")
     end
 end
    local administration = load_data(_config.moderation.data)
if data.username then
user_name = '@'..check_markdown(data.username)
else
user_name = check_markdown(data.first_name)
end
if not administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] then
    if not lang then
    return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _is not_ *banned*", 0, "md")
   else
    return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از گروه محروم نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id)] = nil
    save_data(_config.moderation.data, administration)
channel_unblock(arg.chat_id, data.id)
   if not lang then
    return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _has been_ *unbanned*", 0, "md")
   else
    return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از محرومیت گروه خارج شد*", 0, "md")
   end
end
assert(tdbot_function ({
    _ = "getUser",
    user_id = data.id
  }, unban_cb, {chat_id=arg.chat_id,user_id=data.id}))
  end
  if cmd == "silent" then
local function silent_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if not data.id then 
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_This user doesn't exists._", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*کاربر موردنظر وجود ندارد*", 0, "md")
     end
 end
    local administration = load_data(_config.moderation.data)
if data.username then
user_name = '@'..check_markdown(data.username)
else
user_name = check_markdown(data.first_name)
end
     if data.id == our_id then
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_I can't silent_ *my self*", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*من نمیتوانم توانایی چت کردن رو از خودم بگیرم*", 0, "md")
         end
     end
   if is_mod1(arg.chat_id, data.id) then
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_You can't silent_ *mods,owners and bot admins*", 0, "md")
    else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید توانایی چت کردن رو از مدیران،صاحبان گروه، و ادمین های ربات بگیرید*", 0, "md")
       end
     end
if administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] then
    if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _is already_ *silent*", 0, "md")
  else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از قبل توانایی چت کردن رو نداشت*", 0, "md")
     end
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] = user_name
    save_data(_config.moderation.data, administration)
  if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _added to_ *silent users list*", 0, "md")
  else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *توانایی چت کردن رو از دست داد*", 0, "md")
   end
end
assert(tdbot_function ({
    _ = "getUser",
    user_id = data.id
  }, silent_cb, {chat_id=arg.chat_id,user_id=data.id}))
  end
  if cmd == "unsilent" then
local function unsilent_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if not data.id then 
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_This user doesn't exists._", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*کاربر موردنظر وجود ندارد*", 0, "md")
     end
 end
    local administration = load_data(_config.moderation.data)
if data.username then
user_name = '@'..check_markdown(data.username)
else
user_name = check_markdown(data.first_name)
end
if not administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] then
   if not lang then
    return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _is not_ *silent*", 0, "md")
   else
    return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از قبل توانایی چت کردن را داشت*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id)] = nil
    save_data(_config.moderation.data, administration)
    if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _removed from_ *silent users list*", 0, "md")
  else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *توانایی چت کردن رو به دست آورد*", 0, "md")
   end
end
assert(tdbot_function ({
    _ = "getUser",
    user_id = data.id
  }, unsilent_cb, {chat_id=arg.chat_id,user_id=data.id}))
  end
  if cmd == "banall" then
local function gban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if not data.id then 
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_This user doesn't exists._", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*کاربر موردنظر وجود ندارد*", 0, "md")
     end
 end
    local administration = load_data(_config.moderation.data)
if data.username then
user_name = '@'..check_markdown(data.username)
else
user_name = check_markdown(data.first_name)
end
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
     if data.id == our_id then
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_I can't globally ban_ *my self*", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*من نمیتوانم خودم رو از تمام گروه های ربات محروم کنم*", 0, "md")
         end
     end
   if is_admin1(data.id) then
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_You can't_ *globally ban* _other admins_", 0, "md")
  else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید ادمین های ربات رو از تمامی گروه های ربات محروم کنید*", 0, "md")
        end
     end
if is_gbanned(data.id) then
   if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _is already_ *globally banned*", 0, "md")
    else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از گروه های ربات محروم بود*", 0, "md")
      end
   end
  administration['gban_users'][tostring(data.id)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id, arg.chat_id)
     if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _has been_ *globally banned*", 0, "md")
   else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از تمام گروه های ربات محروم شد*", 0, "md")
   end
end
assert(tdbot_function ({
    _ = "getUser",
    user_id = data.id
  }, gban_cb, {chat_id=arg.chat_id,user_id=data.id}))
  end
  if cmd == "unbanall" then
local function ungban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if not data.id then 
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_This user doesn't exists._", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*کاربر موردنظر وجود ندارد*", 0, "md")
     end
 end
    local administration = load_data(_config.moderation.data)
if data.username then
user_name = '@'..check_markdown(data.username)
else
user_name = check_markdown(data.first_name)
end
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
if not is_gbanned(data.id) then
   if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _is not_ *globally banned*", 0, "md")
   else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از گروه های ربات محروم نبود*", 0, "md")
      end
   end
  administration['gban_users'][tostring(data.id)] = nil
    save_data(_config.moderation.data, administration)
    if not lang then
     return tdbot.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id.."* _has been_ *globally unbanned*", 0, "md")
   else
     return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id.."* *از محرومیت گروه های ربات خارج شد*", 0, "md")
   end
end
assert(tdbot_function ({
    _ = "getUser",
    user_id = data.id
  }, ungban_cb, {chat_id=arg.chat_id,user_id=data.id}))
  end
  if cmd == "kick" then
     if data.id == our_id then
  if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_I can't kick_ *my self*", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*من نمیتوانم خودم رو از گروه اخراج کنم کنم*", 0, "md")
         end
   elseif is_mod1(arg.chat_id, data.id) then
   if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_You can't kick_ *mods,owners and bot admins*", 0, "md")
    elseif lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو اخراج کنید*", 0, "md")
   end
  else
     kick_user(data.id, arg.chat_id)
    sleep(1)
channel_unblock(arg.chat_id, data.id)
     end
  end
  if cmd == "delall" then
   if is_mod1(arg.chat_id, data.id) then
   if not lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_You can't delete messages_ *mods,owners and bot admins*", 0, "md")
   elseif lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "*شما نمیتوانید پیام های مدیران،صاحبان گروه و ادمین های ربات رو پاک کنید*", 0, "md")
   end
  else
tdbot.deleteMessagesFromUser(arg.chat_id, data.id, dl_cb, nil)
   if not lang then
  return tdbot.sendMessage(arg.chat_id_, "", 0, "_All_ *messages* _of_ "..data.title.." *[ "..data.id.." ]* _has been_ *deleted*", 0, "md")
      elseif lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "*تمام پیام های* "..data.title.." *[ "..data.id.." ]* *پاک شد*", 0, "md")
       end
    end
  end
else
    if lang then
  return tdbot.sendMessage(arg.chat_id, "", 0, "_کاربر یافت نشد_", 0, "md")
   else
  return tdbot.sendMessage(arg.chat_id, "", 0, "*User Not Found*", 0, "md")
      end
   end
end
local function run(msg, matches)
local userid = tonumber(matches[2])
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local Chash = "cmd_lang:"..msg.to.id
local Clang = redis:get(Chash)
local data = load_data(_config.moderation.data)
chat = msg.to.id
user = msg.from.id
   if msg.to.type ~= 'pv' then
 if (matches[1] == "kick" and is_mod(msg) and not Clang) or (matches[1] == "اخراج" and is_mod(msg) and Clang) then
if not matches[2] and msg.reply_id then
    assert(tdbot_function ({
      _ = "getMessage",
      chat_id = msg.to.id,
      message_id = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="kick"}))
end
  if matches[2] and string.match(matches[2], '^%d+$') then
    if userid == our_id then
  if not lang then
  return tdbot.sendMessage(msg.to.id, msg.id, 0, "_I can't kick_ *my self*", 0, "md")
   else
  return tdbot.sendMessage(msg.to.id, msg.id, 0, "*من نمیتوانم خودم رو از گروه اخراج کنم*", 0, "md")
         end
   elseif is_mod1(msg.to.id, userid) then
   if not lang then
     tdbot.sendMessage(msg.to.id, "", 0, "_You can't kick mods,owners or bot admins_", 0, "md")
   elseif lang then
     tdbot.sendMessage(msg.to.id, "", 0, "*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو اخراج کنید*", 0, "md")
         end
     else
kick_user(matches[2], msg.to.id)
   sleep(1)
channel_unblock(msg.to.id, matches[2])
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    assert(tdbot_function ({
      _ = "searchPublicChat",
      username = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="kick"}))
         end
      end
 if (matches[1] == "delall" and is_mod(msg) and not Clang) or (matches[1] == "حذف پیام" and is_mod(msg) and Clang) then
if not matches[2] and msg.reply_id then
    assert(tdbot_function ({
      _ = "getMessage",
      chat_id = msg.to.id,
      message_id = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="delall"}))
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if is_mod1(msg.to.id, userid) then
   if not lang then
   return tdbot.sendMessage(msg.to.id, "", 0, "_You can't delete messages mods,owners or bot admins_", 0, "md")
     elseif lang then
   return tdbot.sendMessage(msg.to.id, "", 0, "*شما نمیتوانید پیام های مدیران،صاحبان گروه و ادمین های ربات رو پاک کنید*", 0, "md")
   end
     else
tdbot.deleteMessagesFromUser(msg.to.id, matches[2], dl_cb, nil)
    if not lang then
  return tdbot.sendMessage(msg.to.id, "", 0, "_All_ *messages* _of_ *[ "..matches[2].." ]* _has been_ *deleted*", 0, "md")
   elseif lang then
  return tdbot.sendMessage(msg.to.id, "", 0, "*تمامی پیام های* *[ "..matches[2].." ]* *پاک شد*", 0, "md")
         end
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    assert(tdbot_function ({
      _ = "searchPublicChat",
      username = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="delall"}))
         end
      end
   end
 if (matches[1] == "banall" and is_admin(msg) and not Clang) or (matches[1] == "سوپر بن" and is_admin(msg) and Clang) then
if not matches[2] and msg.reply_id then
    assert(tdbot_function ({
      _ = "getMessage",
      chat_id = msg.to.id,
      message_id = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="banall"}))
end
  if matches[2] and string.match(matches[2], '^%d+$') then
    if userid == our_id then
  if not lang then
  return tdbot.sendMessage(msg.to.id, msg.id, 0, "_I can't globally ban_ *my self*", 0, "md")
   else
  return tdbot.sendMessage(msg.to.id, msg.id, 0, "*من نمیتوانم خودم رو از تمام گروه های ربات محروم کنم*", 0, "md")
         end
     end
   if is_admin1(userid) then
   if not lang then
    return tdbot.sendMessage(msg.to.id, "", 0, "_You can't globally ban other admins_", 0, "md")
else
    return tdbot.sendMessage(msg.to.id, "", 0, "*شما نمیتوانید ادمین های ربات رو از گروه های ربات محروم کنید*", 0, "md")
        end
     end
   if is_gbanned(matches[2]) then
   if not lang then
  return tdbot.sendMessage(msg.to.id, "", 0, "*User "..matches[2].." is already globally banned*", 0, "md")
    else
  return tdbot.sendMessage(msg.to.id, "", 0, "*کاربر "..matches[2].." از گروه های ربات محروم بود*", 0, "md")
        end
     end
  data['gban_users'][tostring(matches[2])] = ""
    save_data(_config.moderation.data, data)
kick_user(matches[2], msg.to.id)
   if not lang then
 return tdbot.sendMessage(msg.to.id, msg.id, 0, "*User "..matches[2].." has been globally banned*", 0, "md")
    else
 return tdbot.sendMessage(msg.to.id, msg.id, 0, "*کاربر "..matches[2].." از تمام گروه هار ربات محروم شد*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    assert(tdbot_function ({
      _ = "searchPublicChat",
      username = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="banall"}))
      end
   end
 if (matches[1] == "unbanall" and is_admin(msg) and not Clang) or (matches[1] == "حذف سوپر بن" and is_admin(msg) and Clang) then
if not matches[2] and msg.reply_id then
    assert(tdbot_function ({
      _ = "getMessage",
      chat_id = msg.to.id,
      message_id = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="unbanall"}))
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if not is_gbanned(matches[2]) then
     if not lang then
   return tdbot.sendMessage(msg.to.id, "", 0, "*User "..matches[2].." is not globally banned*", 0, "md")
    else
   return tdbot.sendMessage(msg.to.id, "", 0, "*کاربر "..matches[2].." از گروه های ربات محروم نبود*", 0, "md")
        end
     end
  data['gban_users'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
   if not lang then
return tdbot.sendMessage(msg.to.id, msg.id, 0, "*User "..matches[2].." has been globally unbanned*", 0, "md")
   else
return tdbot.sendMessage(msg.to.id, msg.id, 0, "*کاربر "..matches[2].." از محرومیت گروه های ربات خارج شد*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    assert(tdbot_function ({
      _ = "searchPublicChat",
      username = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="unbanall"}))
      end
   end
   if msg.to.type ~= 'pv' then
 if (matches[1] == "ban" and is_mod(msg) and not Clang) or (matches[1] == "بن" and is_mod(msg) and Clang) then
if not matches[2] and msg.reply_id then
    assert(tdbot_function ({
      _ = "getMessage",
      chat_id = msg.to.id,
      message_id = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="ban"}))
end
  if matches[2] and string.match(matches[2], '^%d+$') then
    if userid == our_id then
  if not lang then
  return tdbot.sendMessage(msg.to.id, msg.id, 0, "_I can't ban_ *my self*", 0, "md")
   else
  return tdbot.sendMessage(msg.to.id, msg.id, 0, "*من نمیتوانم خودم رو از گروه محروم کنم*", 0, "md")
         end
     end
   if is_mod1(msg.to.id, userid) then
     if not lang then
    return tdbot.sendMessage(msg.to.id, "", 0, "_You can't ban mods,owners or bot admins_", 0, "md")
    else
    return tdbot.sendMessage(msg.to.id, "", 0, "*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو از گروه محروم کنید*", 0, "md")
        end
     end
   if is_banned(matches[2], msg.to.id) then
   if not lang then
  return tdbot.sendMessage(msg.to.id, "", 0, "_User "..matches[2].." is already banned_", 0, "md")
  else
  return tdbot.sendMessage(msg.to.id, "", 0, "*کاربر "..matches[2].." از گروه محروم بود*", 0, "md")
        end
     end
data[tostring(chat)]['banned'][tostring(matches[2])] = ""
    save_data(_config.moderation.data, data)
kick_user(matches[2], msg.to.id)
   if not lang then
 return tdbot.sendMessage(msg.to.id, msg.id, 0, "_User "..matches[2].." has been banned_", 0, "md")
  else
 return tdbot.sendMessage(msg.to.id, msg.id, 0, "*کاربر "..matches[2].." از گروه محروم شد*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
     assert(tdbot_function ({
      _ = "searchPublicChat",
      username = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="ban"}))
      end
   end
 if (matches[1] == "unban" and is_mod(msg) and not Clang) or (matches[1] == "حذف بن" and is_mod(msg) and Clang) then
if not matches[2] and msg.reply_id then
    assert(tdbot_function ({
      _ = "getMessage",
      chat_id = msg.to.id,
      message_id = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="unban"}))
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if not is_banned(matches[2], msg.to.id) then
   if not lang then
   return tdbot.sendMessage(msg.to.id, "", 0, "_User "..matches[2].." is not banned_", 0, "md")
  else
   return tdbot.sendMessage(msg.to.id, "", 0, "*کاربر "..matches[2].." از گروه محروم نبود*", 0, "md")
        end
     end
data[tostring(chat)]['banned'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
channel_unblock(msg.to.id, matches[2])
   if not lang then
return tdbot.sendMessage(msg.to.id, msg.id, 0, "_User "..matches[2].." has been unbanned_", 0, "md")
   else
return tdbot.sendMessage(msg.to.id, msg.id, 0, "*کاربر "..matches[2].." از محرومیت گروه خارج شد*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    assert(tdbot_function ({
      _ = "searchPublicChat",
      username = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="unban"}))
      end
   end
 if (matches[1] == "silent" and is_mod(msg) and not Clang) or (matches[1] == "سکوت" and is_mod(msg) and Clang) then
if not matches[2] and msg.reply_id then
    assert(tdbot_function ({
      _ = "getMessage",
      chat_id = msg.to.id,
      message_id = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="silent"}))
end
  if matches[2] and string.match(matches[2], '^%d+$') then
    if userid == our_id then
  if not lang then
  return tdbot.sendMessage(msg.to.id, msg.id, 0, "_I can't silent_ *my self*", 0, "md")
   else
  return tdbot.sendMessage(msg.to.id, msg.id, 0, "*من نمیتوانم توانایی چت کردن رو از خودم بگیرم*", 0, "md")
         end
     end
   if is_mod1(msg.to.id, userid) then
   if not lang then
   return tdbot.sendMessage(msg.to.id, "", 0, "_You can't silent mods,leaders or bot admins_", 0, "md")
 else
   return tdbot.sendMessage(msg.to.id, "", 0, "*شما نمیتوانید توانایی چت کردن رو از مدیران،صاحبان گروه و ادمین های ربات بگیرید*", 0, "md")
        end
     end
   if is_silent_user(matches[2], chat) then
   if not lang then
   return tdbot.sendMessage(msg.to.id, "", 0, "_User "..matches[2].." is already silent_", 0, "md")
   else
   return tdbot.sendMessage(msg.to.id, "", 0, "*کاربر "..matches[2].." از قبل توانایی چت کردن رو نداشت*", 0, "md")
        end
     end
data[tostring(chat)]['is_silent_users'][tostring(matches[2])] = ""
    save_data(_config.moderation.data, data)
    if not lang then
 return tdbot.sendMessage(msg.to.id, msg.id, 0, "_User "..matches[2].." added to silent users list_", 0, "md")
  else
 return tdbot.sendMessage(msg.to.id, msg.id, 0, "*کاربر "..matches[2].." توانایی چت کردن رو از دست داد*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    assert(tdbot_function ({
      _ = "searchPublicChat",
      username = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="silent"}))
      end
   end
 if (matches[1] == "unsilent" and is_mod(msg) and not Clang) or (matches[1] == "حذف سکوت" and is_mod(msg) and Clang) then
if not matches[2] and msg.reply_id then
    assert(tdbot_function ({
      _ = "getMessage",
      chat_id = msg.to.id,
      message_id = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="unsilent"}))
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if not is_silent_user(matches[2], chat) then
     if not lang then
     return tdbot.sendMessage(msg.to.id, "", 0, "_User "..matches[2].." is not silent_", 0, "md")
   else
     return tdbot.sendMessage(msg.to.id, "", 0, "*کاربر "..matches[2].." از قبل توانایی چت کردن رو داشت*", 0, "md")
        end
     end
data[tostring(chat)]['is_silent_users'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
   if not lang then
 return tdbot.sendMessage(msg.to.id, msg.id, 0, "_User "..matches[2].." removed from silent users list_", 0, "md")
  else
 return tdbot.sendMessage(msg.to.id, msg.id, 0, "*کاربر "..matches[2].." توانایی چت کردن رو به دست آورد*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   assert(tdbot_function ({
      _ = "searchPublicChat",
      username = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="unsilent"}))
      end
   end
		if (matches[1] == "clean" and is_owner(msg) and not Clang) or (matches[1] == "پاک کردن" and is_owner(msg) and Clang) then
			if (matches[2] == 'bans' and not Clang) or (matches[2] == 'لیست بن' and Clang) then
				if next(data[tostring(chat)]['banned']) == nil then
     if not lang then
					return "_No_ *banned* _users in this group_"
   else
					return "*هیچ کاربری از این گروه محروم نشده*"
              end
				end
				for k,v in pairs(data[tostring(chat)]['banned']) do
					data[tostring(chat)]['banned'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
     if not lang then
				return "_All_ *banned* _users has been unbanned_"
    else
				return "*تمام کاربران محروم شده از گروه از محرومیت خارج شدند*"
           end
			end
			if (matches[2] == 'silentlist' and not Clang) or (matches[2] == 'لیست سکوت' and Clang) then
				if next(data[tostring(chat)]['is_silent_users']) == nil then
        if not lang then
					return "_No_ *silent* _users in this group_"
   else
					return "*لیست کاربران سایلنت شده خالی است*"
             end
				end
				for k,v in pairs(data[tostring(chat)]['is_silent_users']) do
					data[tostring(chat)]['is_silent_users'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				    end
       if not lang then
				return "*Silent list* _has been cleaned_"
   else
				return "*لیست کاربران سایلنت شده پاک شد*"
               end
			    end
        end
     end
		if (matches[1] == "clean" and is_sudo(msg) and not Clang) or (matches[1] == "پاک کردن" and is_sudo(msg) and Clang) then
			if (matches[2] == 'gbans' and not Clang) or (matches[2] == 'لیست سوپر بن' and Clang) then
				if next(data['gban_users']) == nil then
    if not lang then
					return "_No_ *globally banned* _users available_"
   else
					return "*هیچ کاربری از گروه های ربات محروم نشده*"
             end
				end
				for k,v in pairs(data['gban_users']) do
					data['gban_users'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
      if not lang then
				return "_All_ *globally banned* _users has been unbanned_"
   else
				return "*تمام کاربرانی که از گروه های ربات محروم بودند از محرومیت خارج شدند*"
          end
			end
     end
 if (matches[1] == "gbanlist" and is_admin(msg) and not Clang) or (matches[1] == "لیست سوپر بن" and is_admin(msg) and Clang) then
  return gbanned_list(msg)
 end
   if msg.to.type ~= 'pv' then
 if (matches[1] == "silentlist" and is_mod(msg) and not Clang) or (matches[1] == "لیست سکوت" and is_mod(msg) and Clang) then
  return silent_users_list(chat)
 end
 if (matches[1] == "banlist" and is_mod(msg) and not Clang) or (matches[1] == "لیست بن" and is_mod(msg) and Clang) then
  return banned_list(chat)
     end
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
		"^[!/#](delall)$",
		"^[!/#](delall) (.*)$",
		"^[!/#](clean) (.*)$",
		"^(سوپر بن)$",
		"^(سوپر بن) (.*)$",
		"^(حذف سوپر بن)$",
		"^(حذف سوپر بن) (.*)$",
		"^(لیست سوپر بن)$",
		"^(بن)$",
		"^(بن) (.*)$",
		"^(حذف بن)$",
		"^(حذف بن) (.*)$",
		"^(لیست بن)$",
		"^(سکوت)$",
		"^(سکوت) (.*)$",
		"^(حذف سکوت)$",
		"^(حذف سکوت) (.*)$",
		"^(لیست سکوت)$",
		"^(اخراج)$",
		"^(اخراج) (.*)$",
		"^(حذف پیام)$",
		"^(حذف پیام) (.*)$",
		"^(پاک کردن) (.*)$",
	},
	run = run,
pre_process = pre_process
}
