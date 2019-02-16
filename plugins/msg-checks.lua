--Begin msg_checks.lua By @SoLiD
local function pre_process(msg)
local data = load_data(_config.moderation.data)
local chat = msg.to.id
local user = msg.from.id
local is_channel = msg.to.type == "channel"
local is_chat = msg.to.type == "chat"
local auto_leave = 'auto_leave_bot'
local hash = "gp_lang:"..chat
local lang = redis:get(hash)
if not redis:get('autodeltime') then
	redis:setex('autodeltime', 14400, true)
     run_bash("rm -rf ~/.telegram-bot/cli/data/stickers/*")
     run_bash("rm -rf ~/.telegram-bot/cli/files/photos/*")
     run_bash("rm -rf ~/.telegram-bot/cli/files/animations/*")
     run_bash("rm -rf ~/.telegram-bot/cli/files/videos/*")
     run_bash("rm -rf ~/.telegram-bot/cli/files/music/*")
     run_bash("rm -rf ~/.telegram-bot/cli/files/voice/*")
     run_bash("rm -rf ~/.telegram-bot/cli/files/temp/*")
     run_bash("rm -rf ~/.telegram-bot/cli/data/temp/*")
     run_bash("rm -rf ~/.telegram-bot/cli/files/documents/*")
     run_bash("rm -rf ~/.telegram-bot/cli/data/profile_photos/*")
     run_bash("rm -rf ~/.telegram-bot/cli/files/video_notes/*")
	 run_bash("rm -rf ./data/photos/*")
end
   if is_channel or is_chat then
        local TIME_CHECK = 2
        if data[tostring(chat)] then
          if data[tostring(chat)]['settings']['time_check'] then
            TIME_CHECK = tonumber(data[tostring(chat)]['settings']['time_check'])
          end
        end
    if msg.text then
  if msg.text:match("(.*)") then
    if not data[tostring(msg.to.id)] and not redis:get(auto_leave) and not is_admin(msg) then
  tdbot.sendMessage(msg.to.id, "", 0, "_This Is Not One Of My_ *Groups*", 0, "md")
  tdbot.changeChatMemberStatus(chat, our_id, 'Left', dl_cb, nil)
      end
   end
end
    if data[tostring(chat)] and data[tostring(chat)]['mutes'] then
		mutes = data[tostring(chat)]['mutes']
	else
		return
	end
	if mutes.mute_all then
		mute_all = mutes.mute_all
	else
		mute_all = 'no'
	end
	if mutes.mute_gif then
		mute_gif = mutes.mute_gif
	else
		mute_gif = 'no'
	end
   if mutes.mute_photo then
		mute_photo = mutes.mute_photo
	else
		mute_photo = 'no'
	end
	if mutes.mute_sticker then
		mute_sticker = mutes.mute_sticker
	else
		mute_sticker = 'no'
	end
	if mutes.mute_contact then
		mute_contact = mutes.mute_contact
	else
		mute_contact = 'no'
	end
	if mutes.mute_inline then
		mute_inline = mutes.mute_inline
	else
		mute_inline = 'no'
	end
	if mutes.mute_game then
		mute_game = mutes.mute_game
	else
		mute_game = 'no'
	end
	if mutes.mute_text then
		mute_text = mutes.mute_text
	else
		mute_text = 'no'
	end
	if mutes.mute_keyboard then
		mute_keyboard = mutes.mute_keyboard
	else
		mute_keyboard = 'no'
	end
	if mutes.mute_forward then
		mute_forward = mutes.mute_forward
	else
		mute_forward = 'no'
	end
	if mutes.mute_location then
		mute_location = mutes.mute_location
	else
		mute_location = 'no'
	end
   if mutes.mute_document then
		mute_document = mutes.mute_document
	else
		mute_document = 'no'
	end
	if mutes.mute_voice then
		mute_voice = mutes.mute_voice
	else
		mute_voice = 'no'
	end
	if mutes.mute_audio then
		mute_audio = mutes.mute_audio
	else
		mute_audio = 'no'
	end
	if mutes.mute_video then
		mute_video = mutes.mute_video
	else
		mute_video = 'no'
	end
	if mutes.mute_video_note then
		mute_video_note = mutes.mute_video_note
	else
		mute_video_note = 'no'
	end
	if mutes.mute_tgservice then
		mute_tgservice = mutes.mute_tgservice
	else
		mute_tgservice = 'no'
	end
	if data[tostring(chat)] and data[tostring(chat)]['settings'] then
		settings = data[tostring(chat)]['settings']
	else
		return
	end
	if settings.lock_link then
		lock_link = settings.lock_link
	else
		lock_link = 'no'
	end
	if settings.lock_join then
		lock_join = settings.lock_join
	else
		lock_join = 'no'
	end
	if settings.lock_tag then
		lock_tag = settings.lock_tag
	else
		lock_tag = 'no'
	end
	if settings.lock_pin then
		lock_pin = settings.lock_pin
	else
		lock_pin = 'no'
	end
	if settings.lock_arabic then
		lock_arabic = settings.lock_arabic
	else
		lock_arabic = 'no'
	end
	if settings.lock_mention then
		lock_mention = settings.lock_mention
	else
		lock_mention = 'no'
	end
		if settings.lock_edit then
		lock_edit = settings.lock_edit
	else
		lock_edit = 'no'
	end
		if settings.lock_spam then
		lock_spam = settings.lock_spam
	else
		lock_spam = 'no'
	end
	if settings.flood then
		lock_flood = settings.flood
	else
		lock_flood = 'no'
	end
	if settings.strict then
		lock_strict = settings.strict
	else
		lock_strict = 'no'
	end
	if settings.lock_markdown then
		lock_markdown = settings.lock_markdown
	else
		lock_markdown = 'no'
	end
	if settings.lock_webpage then
		lock_webpage = settings.lock_webpage
	else
		lock_webpage = 'no'
	end
  if msg.adduser or msg.joinuser or msg.deluser then
  if mute_tgservice == "yes" then
del_msg(chat, tonumber(msg.id))
  end
end
 if not is_mod(msg) and not is_whitelist(msg.from.id, msg.to.id) and msg.from.id ~= our_id then
	if msg.adduser or msg.joinuser then
		if lock_join == "yes" then
			function join_kick(arg, data)
				kick_user(data.id, msg.to.id)
			end
			if msg.tab then
				if msg.content.member_user_ids then
					idss = msg.content.member_user_ids
					for k,v in pairs(idss) do
						tdbot.getUser(v, join_kick, nil)
					end

				end
				
			elseif msg.joinuser then
				tdbot.getUser(msg.joinuser, join_kick, nil)
			end
		end
	end
end
   if msg.pinned and is_channel then
  if lock_pin == "yes" then
     if is_owner(msg) then
      return
     end
     if tonumber(msg.from.id) == our_id then
      return
     end
    local pin_msg = data[tostring(chat)]['pin']
      if pin_msg then
tdbot.pinChannelMessage(msg.to.id, pin_msg, 1, dl_cb, nil)
       elseif not pin_msg then
   tdbot.unpinChannelMessage(msg.to.id, dl_cb, nil)
          end
    if lang then
     tdbot.sendMessage(msg.to.id, msg.id, 0, '<b>User ID :</b> <code>'..msg.from.id..'</code>\n<b>Username :</b> '..('@'..msg.from.username or '<i>No Username</i>')..'\n<i>شما اجازه دسترسی به سنجاق پیام را ندارید، به همین دلیل پیام قبلی مجدد سنجاق میگردد</i>', 0, "html")
     elseif not lang then
    tdbot.sendMessage(msg.to.id, msg.id, 0, '<b>User ID :</b> <code>'..msg.from.id..'</code>\n<b>Username :</b> '..('@'..msg.from.username or '<i>No Username</i>')..'\n<i>You Have Not Permission To Pin Message, Last Message Has Been Pinned Again</i>', 0, "html")
          end
      end
  end
if not is_mod(msg) and not is_whitelist(msg.from.id, msg.to.id) and msg.from.id ~= our_id then
if msg.edited and lock_edit == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
    end
  end
if (msg.fwd_from_user or msg.fwd_from_channel) and mute_forward == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
    end
  end
if msg.photo and mute_photo == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.video and mute_video == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.video_note and mute_video_note == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.document and mute_document == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.sticker and mute_sticker == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.animation and mute_gif == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.contact and mute_contact == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.location and mute_location == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.voice and mute_voice == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
   if msg.content and mute_keyboard == "yes" then
  if msg.keyboard then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
      end
   end
end
    if msg.inline and mute_inline == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.game and mute_game == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.audio and mute_audio == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
if msg.media.caption then
print('1')
local link_caption = msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.media.caption:match("[Tt].[Mm][Ee]/") or msg.media.caption:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
if link_caption and lock_link == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
local tag_caption = msg.media.caption:match("@") or msg.media.caption:match("#")
if tag_caption and lock_tag == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
if is_filter(msg, msg.media.caption) then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
      end
    end
local arabic_caption = msg.media.caption:match("[\216-\219][\128-\191]")
if arabic_caption and lock_arabic == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
      end
   end
end
if msg.text then
			local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
        local max_chars = 40
        if data[tostring(msg.to.id)] then
          if data[tostring(msg.to.id)]['settings']['set_char'] then
            max_chars = tonumber(data[tostring(msg.to.id)]['settings']['set_char'])
          end
        end
			 local _nl, real_digits = string.gsub(msg.text, '%d', '')
			local max_real_digits = tonumber(max_chars) * 50
			local max_len = tonumber(max_chars) * 51
			if lock_spam == "yes" then
			if string.len(msg.text) > max_len or ctrl_chars > max_chars or real_digits > max_real_digits then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
      end
   end
end
local link_msg = msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.text:match("[Tt].[Mm][Ee]/") or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
if link_msg
and lock_link == "yes" then
 if is_channel then
   if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
local tag_msg = msg.text:match("@") or msg.text:match("#")
if tag_msg and lock_tag == "yes" then
 if is_channel then
   if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
if is_filter(msg, msg.text) then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
      end
    end
local arabic_msg = msg.text:match("[\216-\219][\128-\191]")
if arabic_msg and lock_arabic == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
if msg.text:match("(.*)")
and mute_text == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
     end
   end
end
if mute_all == "yes" then 
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.entity.mention then
      if lock_mention == "yes" then
 if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
             end
          end
      end
  if msg.entity.webpage then
      if lock_webpage == "yes" then
if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
             end
          end
      end
  if msg.entity.markdown then
      if lock_markdown == "yes" then
if is_channel then
  if lock_strict == "kick" then
 del_msg(chat, tonumber(msg.id))
kick_user(user, chat)
  elseif lock_strict == "silent" then
 del_msg(chat, tonumber(msg.id))
		silent_user(chat, user)
  else
 del_msg(chat, tonumber(msg.id))
 end
  elseif is_chat then
kick_user(user, chat)
          end
      end
 end
if msg.to.type ~= 'pv' then
  if not is_mod(msg) and not is_whitelist(msg.from.id, msg.to.id) and not msg.adduser and not msg.deluser and msg.from.id ~= our_id then
    local hash = 'user:'..user..':msgs'
    local msgs = tonumber(redis:get(hash) or 0)
        local NUM_MSG_MAX = 5
        if data[tostring(chat)] then
          if data[tostring(chat)]['settings']['num_msg_max'] then
            NUM_MSG_MAX = tonumber(data[tostring(chat)]['settings']['num_msg_max'])
          end
        end
    if msgs > NUM_MSG_MAX then
   if msg.from.username and msg.from.username ~= "" then
      user_name = "@"..msg.from.username
         else
      user_name = msg.from.first_name
     end
  if lock_flood == "kick" then
if redis:get('sender:'..user..':flood') then
return
else
   del_msg(chat, msg.id)
    kick_user(user, chat)
   if not lang then
  tdbot.sendMessage(chat, msg.id, 0, "_User_ "..user_name.." `[ "..user.." ]` _has been_ *kicked* _because of_ *flooding*", 0, "md")
   elseif lang then
  tdbot.sendMessage(chat, msg.id, 0, "_کاربر_ "..user_name.." `[ "..user.." ]` _به دلیل ارسال پیام های مکرر اخراج شد_", 0, "md")
    end
redis:setex('sender:'..user..':flood', 30, true)
      end
   elseif lock_flood == "silent" then
if redis:get('sender:'..user..':flood') then
return
else
		silent_user(chat, user)
   del_msg(chat, msg.id)
   if not lang then
  tdbot.sendMessage(chat, msg.id, 0, "_User_ "..user_name.." `[ "..user.." ]` _has been_ *added to silent users list* _because of_ *flooding*", 0, "md")
   elseif lang then
  tdbot.sendMessage(chat, msg.id, 0, "_کاربر_ "..user_name.." `[ "..user.." ]` _به دلیل ارسال پیام های مکرر توانایی چت کردن رو از دست داد_", 0, "md")
    end
redis:setex('sender:'..user..':flood', 30, true)
          end
       end
    end
    redis:setex(hash, TIME_CHECK, msgs+1)
               end
           end
      end
   end
end
return {
	patterns = {},
	pre_process = pre_process
}
--End msg_checks.lua--
