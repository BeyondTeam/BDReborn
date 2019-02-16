
local tdbot = {}

function dl_cb(arg, data)
end

local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)

  if chat_id:match('^-100') then
    local channel_id = chat_id:gsub('-100', '')
    chat = {id = channel_id, type = 'channel'}
  else
    local group_id = chat_id:gsub('-', '')
    chat = {id = group_id, type = 'group'}
  end

  return chat
end

local function getInputFile(file, conversion_str, expectedsize)
  local input = tostring(file)
  local infile = {}

  if (conversion_str and expectedsize) then
    infile = {
      _ = 'inputFileGenerated',
      original_path = tostring(file),
      conversion = tostring(conversion_str),
      expected_size = expectedsize
    }
  else
    if input:match('/') then
      infile = {_ = 'inputFileLocal', path = file}
    elseif input:match('^%d+$') then
      infile = {_ = 'inputFileId', id = file}
    else
      infile = {_ = 'inputFilePersistentId', persistent_id = file}
    end
  end

  return infile
end

local function getParseMode(parse_mode)
  local P = {}
  if parse_mode then
    local mode = parse_mode:lower()

    if mode == 'markdown' or mode == 'md' then
      P._ = 'textParseModeMarkdown'
    elseif mode == 'html' then
      P._ = 'textParseModeHTML'
    end
  end

  return P
end

local function getVector(str)
  local v = {}
  local i = 1

  for k in string.gmatch(str, '(%d%d%d+)') do
    v[i] = '[' .. i-1 .. ']="' .. k .. '"'
    i = i+1
  end
  v = table.concat(v, ',')
  return load('return {' .. v .. '}')()
end

function tdbot.getAuthState(callback, data)
  assert (tdbot_function ({
    _ = 'getAuthState'
  }, callback or dl_cb, data))
end

function tdbot.setAuthPhoneNumber(phonenumber, allowflashcall, iscurrentphonenumber, callback, data)
  assert (tdbot_function ({
    _ = 'setAuthPhoneNumber',
    phone_number = tostring(),
    allow_flash_call = allowflashcall,
    is_current_phone_number = iscurrentphonenumber
  }, callback or dl_cb, data))
end

function tdbot.resendAuthCode(callback, data)
  assert (tdbot_function ({
    _ = 'resendAuthCode'
  }, callback or dl_cb, data))
end

function tdbot.checkAuthCode(cod, firstname, lastname, callback, data)
  assert (tdbot_function ({
    _ = 'checkAuthCode',
    code = tostring(cod),
    first_name = tostring(firstname),
    last_name = tostring(lastname)
  }, callback or dl_cb, data))
end

function tdbot.checkAuthPassword(passwd, callback, data)
  assert (tdbot_function ({
    _ = 'checkAuthPassword',
    password = tostring(passwd)
  }, callback or dl_cb, data))
end

function tdbot.requestAuthPasswordRecovery(callback, data)
  assert (tdbot_function ({
    _ = 'requestAuthPasswordRecovery'
  }, callback or dl_cb, data))
end

function tdbot.recoverAuthPassword(recoverycode, callback, data)
  assert (tdbot_function ({
    _ = 'recoverAuthPassword',
    recovery_code = tostring(recoverycode)
  }, callback or dl_cb, data))
end

function tdbot.resetAuth(force, callback, data)
  assert (tdbot_function ({
    _ = 'resetAuth',
    force = force
  }, callback or dl_cb, data))
end

function tdbot.checkAuthBotToken(token, callback, data)
  assert (tdbot_function ({
    _ = 'checkAuthBotToken',
    token = tostring(token)
  }, callback or dl_cb, data))
end

function tdbot.getPasswordState(callback, data)
  assert (tdbot_function ({
    _ = 'getPasswordState'
  }, callback or dl_cb, data))
end

function tdbot.setPassword(oldpassword, newpassword, newhint, setrecoveryemail, newrecoveryemail, callback, data)
  assert (tdbot_function ({
    _ = 'setPassword',
    old_password = tostring(oldpassword),
    new_password = tostring(newpassword),
    new_hint = tostring(newhint),
    set_recovery_email = setrecoveryemail,
    new_recovery_email = tostring(newrecoveryemail)
  }, callback or dl_cb, data))
end

function tdbot.getRecoveryEmail(passwd, callback, data)
  assert (tdbot_function ({
    _ = 'getRecoveryEmail',
    password = tostring(passwd)
  }, callback or dl_cb, data))
end

function tdbot.setRecoveryEmail(passwd, newrecoveryemail, callback, data)
  assert (tdbot_function ({
    _ = 'setRecoveryEmail',
    password = tostring(passwd),
    new_recovery_email = tostring(newrecoveryemail)
  }, callback or dl_cb, data))
end

function tdbot.requestPasswordRecovery(callback, data)
  assert (tdbot_function ({
    _ = 'requestPasswordRecovery'
  }, callback or dl_cb, data))
end

function tdbot.recoverPassword(recoverycode, callback, data)
  assert (tdbot_function ({
    _ = 'recoverPassword',
    recovery_code = tostring(recoverycode)
  }, callback or dl_cb, data))
end

function tdbot.createTemporaryPassword(passwd, validfor, callback, data)
  assert (tdbot_function ({
    _ = 'createTemporaryPassword',
    password = tostring(passwd),
    valid_for = validfor
  }, callback or dl_cb, data))
end

function tdbot.getTemporaryPasswordState(callback, data)
  assert (tdbot_function ({
    _ = 'getTemporaryPasswordState'
  }, callback or dl_cb, data))
end

function tdbot.processDcUpdate(dc, addr, callback, data)
  assert (tdbot_function ({
    _ = 'processDcUpdate',
    dc = tostring(dc),
    addr = tostring(addr)
  }, callback or dl_cb, data))
end

function tdbot.getMe(callback, data)
  assert (tdbot_function ({
    _ = 'getMe'
  }, callback or dl_cb, data))
end

function tdbot.getUser(userid, callback, data)
  assert (tdbot_function ({
    _ = 'getUser',
    user_id = userid
  }, callback or dl_cb, data))
end

function tdbot.getUserFull(userid, callback, data)
  assert (tdbot_function ({
    _ = 'getUserFull',
    user_id = userid
  }, callback or dl_cb, data))
end

function tdbot.getGroup(groupid, callback, data)
  assert (tdbot_function ({
    _ = 'getGroup',
    group_id = getChatId(groupid).id
  }, callback or dl_cb, data))
end

function tdbot.getGroupFull(groupid, callback, data)
  assert (tdbot_function ({
    _ = 'getGroupFull',
    group_id = getChatId(groupid).id
  }, callback or dl_cb, data))
end

function tdbot.getChannel(channelid, callback, data)
  assert (tdbot_function ({
    _ = 'getChannel',
    channel_id = getChatId(channelid).id
  }, callback or dl_cb, data))
end

function tdbot.getChannelFull(channelid, callback, data)
  assert (tdbot_function ({
    _ = 'getChannelFull',
    channel_id = getChatId(channelid).id
  }, callback or dl_cb, data))
end

function tdbot.getSecretChat(secretchatid, callback, data)
  assert (tdbot_function ({
    _ = 'getSecretChat',
    secret_chat_id = secretchatid
  }, callback or dl_cb, data))
end

function tdbot.getChat(chatid, callback, data)
  assert (tdbot_function ({
    _ = 'getChat',
    chat_id = chatid
  }, callback or dl_cb, data))
end

function tdbot.getMessage(chatid, messageid, callback, data)
  assert (tdbot_function ({
    _ = 'getMessage',
    chat_id = chatid,
    message_id = messageid
  }, callback or dl_cb, data))
end

function tdbot.getMessages(chatid, messageids, callback, data)
  assert (tdbot_function ({
    _ = 'getMessages',
    chat_id = chatid,
    message_ids = messageids
  }, callback or dl_cb, data))
end

function tdbot.getFile(fileid, callback, data)
  assert (tdbot_function ({
    _ = 'getFile',
    file_id = fileid
  }, callback or dl_cb, data))
end

function tdbot.getFilePersistent(persistentfileid, filetype, callback, data)
  assert (tdbot_function ({
    _ = 'getFilePersistent',
    persistent_file_id = tostring(persistentfileid),
    file_type = FileType
  }, callback or dl_cb, data))
end

function tdbot.getChats(offsetorder, offsetchatid, lim, callback, data)
  assert (tdbot_function ({
    _ = 'getChats',
    offset_order = offsetorder,
    offset_chat_id = offsetchatid,
    limit = lim
  }, callback or dl_cb, data))
end

function tdbot.searchPublicChat(username, callback, data)
  assert (tdbot_function ({
    _ = 'searchPublicChat',
    username = tostring(username)
  }, callback or dl_cb, data))
end

function tdbot.searchPublicChats(usernameprefix, callback, data)
  assert (tdbot_function ({
    _ = 'searchPublicChats',
    username_prefix = tostring(usernameprefix)
  }, callback or dl_cb, data))
end

function tdbot.searchChats(query, lim, callback, data)
  assert (tdbot_function ({
    _ = 'searchChats',
    query = tostring(query),
    limit = lim
  }, callback or dl_cb, data))
end

function tdbot.getTopChats(cat, lim, callback, data)
  assert (tdbot_function ({
    _ = 'getTopChats',
    category = {
      _ = 'topChatCategory' .. cat
    },
    limit = lim
  }, callback or dl_cb, data))
end

function tdbot.deleteTopChat(cat, chatid, callback, data)
  assert (tdbot_function ({
    _ = 'deleteTopChat',
    category = {
      _ = 'topChatCategory' .. cat
    },
    chat_id = chatid
  }, callback or dl_cb, data))
end

function tdbot.addRecentlyFoundChat(chatid, callback, data)
  assert (tdbot_function ({
    _ = 'addRecentlyFoundChat',
    chat_id = chatid
  }, callback or dl_cb, data))
end

function tdbot.deleteRecentlyFoundChat(chatid, callback, data)
  assert (tdbot_function ({
    _ = 'deleteRecentlyFoundChat',
    chat_id = chatid
  }, callback or dl_cb, data))
end

function tdbot.deleteRecentlyFoundChats(callback, data)
  assert (tdbot_function ({
    _ = 'deleteRecentlyFoundChats'
  }, callback or dl_cb, data))
end

function tdbot.getCommonChats(userid, offsetchatid, lim, callback, data)
  assert (tdbot_function ({
    _ = 'getCommonChats',
    user_id = userid,
    offset_chat_id = offsetchatid,
    limit = lim
  }, callback or dl_cb, data))
end

function tdbot.getCreatedPublicChats(callback, data)
  assert (tdbot_function ({
    _ = 'getCreatedPublicChats'
  }, callback or dl_cb, data))
end

function tdbot.getChatHistory(chatid, frommessageid, off, lim, onlylocal, callback, data)
  assert (tdbot_function ({
    _ = 'getChatHistory',
    chat_id = chatid,
    from_message_id = frommessageid,
    offset = off,
    limit = lim,
    only_local = onlylocal
  }, callback or dl_cb, data))
end

function tdbot.deleteChatHistory(chatid, removefromchatlist, callback, data)
  assert (tdbot_function ({
    _ = 'deleteChatHistory',
    chat_id = chatid,
    remove_from_chat_list = removefromchatlist
  }, callback or dl_cb, data))
end

function tdbot.searchChatMessages(chatid, query, senderuserid, frommessageid, off, lim, searchmessagesfilter, callback, data)
  assert (tdbot_function ({
    _ = 'searchChatMessages',
    chat_id = chatid,
    query = tostring(query),
    sender_user_id = senderuserid,
    from_message_id = frommessageid,
    offset = off,
    limit = lim,
    filter = {
      _ = 'searchMessagesFilter' .. searchmessagesfilter,
    },
  }, callback or dl_cb, data))
end

function tdbot.searchMessages(query, offsetdate, offsetchatid, offsetmessageid, lim, callback, data)
  assert (tdbot_function ({
    _ = 'searchMessages',
    query = tostring(query),
    offset_date = offsetdate,
    offset_chat_id = offsetchatid,
    offset_message_id = offsetmessageid,
    limit = lim
  }, callback or dl_cb, data))
end

function tdbot.searchSecretMessages(chatid, query, fromsearchid, lim, searchmessagesfilter, callback, data)
  assert (tdbot_function ({
    _ = 'searchSecretMessages',
    chat_id = chatid,
    query = tostring(query),
    from_search_id = fromsearchid,
    limit = lim,
    filter = {
      _ = 'searchMessagesFilter' .. searchmessagesfilter,
    },
  }, callback or dl_cb, data))
end

function tdbot.searchCallMessages(frommessageid, lim, onlymissed, callback, data)
  assert (tdbot_function ({
    _ = 'searchCallMessages',
    from_message_id = frommessageid,
    limit = lim,
    only_missed = onlymissed
  }, callback or dl_cb, data))
end

function tdbot.getPublicMessageLink(chatid, messageid, callback, data)
  assert (tdbot_function ({
    _ = 'getPublicMessageLink',
    chat_id = chatid,
    message_id = messageid
  }, callback or dl_cb, data))
end

local function sendAllMessage(chatid, replytomessageid, InputMessageContent, disablenotification, frombackground, replymarkup, callback, data)
  assert (tdbot_function ({
    _ = 'sendMessage',
    chat_id = chatid,
    reply_to_message_id = replytomessageid,
    disable_notification = disablenotification or 0,
    from_background = frombackground or 1,
    reply_markup = replymarkup,
    input_message_content = InputMessageContent
  }, callback or dl_cb, data))
end

tdbot.sendAllMessage = sendAllMessage

function tdbot.sendMessage(chat_id, reply_to_message_id, disable_notification, text, disablewebpagepreview,  parsemode)
  local input_message_content = {
    _ = 'inputMessageText',
    text = tostring(text),
    disable_web_page_preview = disablewebpagepreview,
    parse_mode = getParseMode(parsemode),
    clear_draft = 0,
    entities = nil
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, 0, nil, callback, nil)
end

function tdbot.sendBotStartMessage(botuserid, chatid, parameter, callback, data)
  assert (tdbot_function ({
    _ = 'sendBotStartMessage',
    bot_user_id = botuserid,
    chat_id = chatid,
    parameter = tostring(parameter)
  }, callback or dl_cb, data))
end

function tdbot.sendInlineQueryResultMessage(chatid, replytomessageid, disablenotification, frombackground, queryid, resultid, callback, data)
  assert (tdbot_function ({
    _ = 'sendInlineQueryResultMessage',
    chat_id = chatid,
    reply_to_message_id = replytomessageid,
    disable_notification = disablenotification,
    from_background = frombackground,
    query_id = queryid,
    result_id = tostring(resultid)
  }, callback or dl_cb, data))
end

function tdbot.forwardMessages(chatid, fromchatid, messageids, disablenotification, frombackground, callback, data)
  assert (tdbot_function ({
    _ = 'forwardMessages',
    chat_id = chatid,
    from_chat_id = fromchatid,
    message_ids = messageids,
    disable_notification = disablenotification,
    from_background = frombackground
  }, callback or dl_cb, data))
end

function tdbot.sendChatSetTtlMessage(chatid, seconds, callback, data)
  assert (tdbot_function ({
    _ = 'sendChatSetTtlMessage',
    chat_id = chatid,
    ttl = seconds
  }, callback or dl_cb, data))
end

function tdbot.editMessageReplyMarkup(chatid, messageid, replymarkup, callback, data)
  assert (tdbot_function ({
    _ = 'editMessageReplyMarkup',
    chat_id = chatid,
    message_id = messageid,
    reply_markup = replymarkup
  }, callback or dl_cb, data))
end

function tdbot.editInlineMessageText(inlinemessageid, replymarkup, inputmessagecontent, callback, data)
  assert (tdbot_function ({
    _ = 'editInlineMessageText',
    inline_message_id = tostring(inlinemessageid),
    reply_markup = replymarkup,
    input_message_content = InputMessageContent
  }, callback or dl_cb, data))
end

function tdbot.editInlineMessageCaption(inlinemessageid, replymarkup, caption, callback, data)
  assert (tdbot_function ({
    _ = 'editInlineMessageCaption',
    inline_message_id = tostring(inlinemessageid),
    reply_markup = replymarkup,
    caption = tostring(caption)
  }, callback or dl_cb, data))
end

function tdbot.editInlineMessageReplyMarkup(inlinemessageid, replymarkup, callback, data)
  assert (tdbot_function ({
    _ = 'editInlineMessageReplyMarkup',
    inline_message_id = tostring(inlinemessageid),
    reply_markup = replymarkup
  }, callback or dl_cb, data))
end

function tdbot.answerInlineQuery(inlinequeryid, ispersonal, results, cachetime, nextoffset, switchpmtext, switchpmparameter, callback, data)
  assert (tdbot_function ({
    _ = 'answerInlineQuery',
    inline_query_id = inlinequeryid,
    is_personal = ispersonal,
    results = results,
    cache_time = cachetime,
    next_offset = tostring(nextoffset),
    switch_pm_text = tostring(switchpmtext),
    switch_pm_parameter = tostring(switchpmparameter)
  }, callback or dl_cb, data))
end

function tdbot.sendChatScreenshotTakenNotification(chatid, callback, data)
  assert (tdbot_function ({
    _ = 'sendChatScreenshotTakenNotification',
    chat_id = chatid
  }, callback or dl_cb, data))
end

function tdbot.deleteMessages(chatid, messageids, revok, callback, data)
  assert (tdbot_function ({
    _ = 'deleteMessages',
    chat_id = chatid,
    message_ids = messageids,
    revoke = revok
  }, callback or dl_cb, data))
end

function tdbot.deleteMessagesFromUser(chatid, userid, callback, data)
  assert (tdbot_function ({
    _ = 'deleteMessagesFromUser',
    chat_id = chatid,
    user_id = userid
  }, callback or dl_cb, data))
end

function tdbot.editMessageText(chatid, messageid, replymarkup, teks, disablewebpagepreview, cleardraft, entity, textparsemode, callback, data)
  assert (tdbot_function ({
    _ = 'editMessageText',
    chat_id = chatid,
    message_id = messageid,
    reply_markup = replymarkup,
    input_message_content = {
      _ = 'inputMessageText',
      text = tostring(teks),
      disable_web_page_preview = disablewebpagepreview,
      clear_draft = cleardraft,
      entities = entity,
      parse_mode = getParseMode(textparsemode)
    },
  }, callback or dl_cb, data))
end

function tdbot.editMessageCaption(chatid, messageid, replymarkup, capt, callback, data)
  assert (tdbot_function ({
    _ = 'editMessageCaption',
    chat_id = chatid,
    message_id = messageid,
    reply_markup = replymarkup,
    caption = tostring(capt)
  }, callback or dl_cb, data))
end

function tdbot.getTextEntities(text, callback, data)
  assert (tdbot_function ({
    _ = 'getTextEntities',
    text = tostring(text)
  }, callback or dl_cb, data))
end

function tdbot.getFileMimeType(filename, callback, data)
  assert (tdbot_function ({
    _ = 'getFileMimeType',
    file_name = tostring(filename)
  }, callback or dl_cb, data))
end

function tdbot.getFileExtension(mimetype, callback, data)
  assert (tdbot_function ({
    _ = 'getFileExtension',
    mime_type = tostring(mimetype)
  }, callback or dl_cb, data))
end

function tdbot.getInlineQueryResults(botuserid, chatid, lat, lon, query, off, callback, data)
  assert (tdbot_function ({
    _ = 'getInlineQueryResults',
    bot_user_id = botuserid,
    chat_id = chatid,
    user_location = {
      _ = 'location',
      latitude = lat,
      longitude = lon
    },
    query = tostring(query),
    offset = tostring(off)
  }, callback or dl_cb, data))
end

function tdbot.getCallbackQueryAnswer(chatid, messageid, query_payload, cb_query_payload, callback, data)
  local callback_query_payload = {}

  if query_payload == 'Data' then
    callback_query_payload.data = cb_query_payload
  elseif query_payload == 'Game' then
    callback_query_payload.game_short_name = cb_query_payload
  end

  callback_query_payload._ = 'callbackQueryPayload' .. query_payload,

  assert (tdbot_function ({
    _ = 'getCallbackQueryAnswer',
    chat_id = chatid,
    message_id = messageid,
    payload = callback_query_payload
  }, callback or dl_cb, data))
end

function tdbot.answerCallbackQuery(callbackqueryid, text, showalert, url, cachetime, callback, data)
  assert (tdbot_function ({
    _ = 'answerCallbackQuery',
    callback_query_id = callbackqueryid,
    text = tostring(text),
    show_alert = showalert,
    url = tostring(url),
    cache_time = cachetime
  }, callback or dl_cb, data))
end

function tdbot.answerShippingQuery(shippingqueryid, shippingoptions, errormessage, callback, data)
  assert (tdbot_function ({
    _ = 'answerShippingQuery',
    shipping_query_id = shippingqueryid,
    shipping_options = shippingoptions,
    error_message = tostring(errormessage)
  }, callback or dl_cb, data))
end

function tdbot.answerPreCheckoutQuery(precheckoutqueryid, errormessage, callback, data)
  assert (tdbot_function ({
    _ = 'answerPreCheckoutQuery',
    pre_checkout_query_id = precheckoutqueryid,
    error_message = tostring(errormessage)
  }, callback or dl_cb, data))
end

function tdbot.setGameScore(chatid, messageid, editmessage, userid, score, force, callback, data)
  assert (tdbot_function ({
    _ = 'setGameScore',
    chat_id = chatid,
    message_id = messageid,
    edit_message = editmessage,
    user_id = userid,
    score = score,
    force = force
  }, callback or dl_cb, data))
end

function tdbot.setInlineGameScore(inlinemessageid, editmessage, userid, score, force, callback, data)
  assert (tdbot_function ({
    _ = 'setInlineGameScore',
    inline_message_id = tostring(inlinemessageid),
    edit_message = editmessage,
    user_id = userid,
    score = score,
    force = force
  }, callback or dl_cb, data))
end

function tdbot.getGameHighScores(chatid, messageid, userid, callback, data)
  assert (tdbot_function ({
    _ = 'getGameHighScores',
    chat_id = chatid,
    message_id = messageid,
    user_id = userid
  }, callback or dl_cb, data))
end

function tdbot.getInlineGameHighScores(inlinemessageid, userid, callback, data)
  assert (tdbot_function ({
    _ = 'getInlineGameHighScores',
    inline_message_id = tostring(inlinemessageid),
    user_id = userid
  }, callback or dl_cb, data))
end

function tdbot.deleteChatReplyMarkup(chatid, messageid, callback, data)
  assert (tdbot_function ({
    _ = 'deleteChatReplyMarkup',
    chat_id = chatid,
    message_id = messageid
  }, callback or dl_cb, data))
end

function tdbot.sendChatAction(chatid, act, uploadprogress, callback, data)
  assert (tdbot_function ({
    _ = 'sendChatAction',
    chat_id = chatid,
    action = {
      _ = 'chatAction' .. act,
      progress = uploadprogress
    },
  }, callback or dl_cb, data))
end

function tdbot.openChat(chatid, callback, data)
  assert (tdbot_function ({
    _ = 'openChat',
    chat_id = chatid
  }, callback or dl_cb, data))
end

function tdbot.closeChat(chatid, callback, data)
  assert (tdbot_function ({
    _ = 'closeChat',
    chat_id = chatid
  }, callback or dl_cb, data))
end

function tdbot.viewMessages(chatid, messageids, callback, data)
  assert (tdbot_function ({
    _ = 'viewMessages',
    chat_id = chatid,
    message_ids = messageids
  }, callback or dl_cb, data))
end

function tdbot.openMessageContent(chatid, messageid, callback, data)
  assert (tdbot_function ({
    _ = 'openMessageContent',
    chat_id = chatid,
    message_id = messageid
  }, callback or dl_cb, data))
end

function tdbot.createPrivateChat(userid, callback, data)
  assert (tdbot_function ({
    _ = 'createPrivateChat',
    user_id = userid
  }, callback or dl_cb, data))
end

function tdbot.createGroupChat(groupid, callback, data)
  assert (tdbot_function ({
    _ = 'createGroupChat',
    group_id = getChatId(groupid).id
  }, callback or dl_cb, data))
end

function tdbot.createChannelChat(channelid, callback, data)
  assert (tdbot_function ({
    _ = 'createChannelChat',
    channel_id = getChatId(channelid).id
  }, callback or dl_cb, data))
end

function tdbot.createSecretChat(secretchatid, callback, data)
  assert (tdbot_function ({
    _ = 'createSecretChat',
    secret_chat_id = secretchatid
  }, callback or dl_cb, data))
end

function tdbot.createNewGroupChat(userids, chattitle, callback, data)
  assert (tdbot_function ({
    _ = 'createNewGroupChat',
    user_ids = userids,
    title = tostring(chattitle)
  }, callback or dl_cb, data))
end

function tdbot.createNewChannelChat(title, issupergroup, channelldescription, callback, data)
  assert (tdbot_function ({
    _ = 'createNewChannelChat',
    title = tostring(title),
    is_supergroup = issupergroup,
    description = tostring(channelldescription)
  }, callback or dl_cb, data))
end

function tdbot.createNewSecretChat(userid, callback, data)
  assert (tdbot_function ({
    _ = 'createNewSecretChat',
    user_id = userid
  }, callback or dl_cb, data))
end

function tdbot.migrateGroupChatToChannelChat(chatid, callback, data)
  assert (tdbot_function ({
    _ = 'migrateGroupChatToChannelChat',
    chat_id = chatid
  }, callback or dl_cb, data))
end

function tdbot.changeChatTitle(chatid, title, callback, data)
  assert (tdbot_function ({
    _ = 'changeChatTitle',
    chat_id = chatid,
    title = tostring(title)
  }, callback or dl_cb, data))
end

function tdbot.changeChatPhoto(chatid, foto, callback, data)
  assert (tdbot_function ({
    _ = 'changeChatPhoto',
    chat_id = chatid,
    photo = getInputFile(foto)
  }, callback or dl_cb, data))
end

function tdbot.changeChatDraftMessage(chatid, replytomessageid, teks, disablewebpagepreview, cleardraft, entity, parsemode, callback, data)
  assert (tdbot_function ({
    _ = 'changeChatDraftMessage',
    chat_id = chatid,
    draft_message = {
      _ = 'draftMessage',
      reply_to_message_id = replytomessageid,
      input_message_text = {
        _ = 'inputMessageText',
        text = tostring(teks),
        disable_web_page_preview = disablewebpagepreview,
        clear_draft = cleardraft,
        entities = entity,
        parse_mode = getParseMode(parsemode)
      },
    },
  }, callback or dl_cb, data))
end

function tdbot.toggleChatIsPinned(chatid, ispinned, callback, data)
  assert (tdbot_function ({
    _ = 'toggleChatIsPinned',
    chat_id = chatid,
    is_pinned = ispinned
  }, callback or dl_cb, data))
end

function tdbot.setChatClientData(chatid, clientdata, callback, data)
  assert (tdbot_function ({
    _ = 'setChatClientData',
    chat_id = chatid,
    client_data = tostring(clientdata)
  }, callback or dl_cb, data))
end

function tdbot.addChatMember(chatid, userid, forwardlimit, callback, data)
  assert (tdbot_function ({
    _ = 'addChatMember',
    chat_id = chatid,
    user_id = userid,
    forward_limit = forwardlimit
  }, callback or dl_cb, data))
end

function tdbot.addChatMembers(chatid, userids, callback, data)
  assert (tdbot_function ({
    _ = 'addChatMembers',
    chat_id = chatid,
    user_ids = userids,
  }, callback or dl_cb, data))
end

function tdbot.changeChatMemberStatus(chatid, userid, rank, right, callback, data)
  local chat_member_status = {}

  if rank == 'Administrator' then
    chat_member_status = {
      can_be_edited = right and right[1] or 1,
      can_change_info = right and right[2] or 1,
      can_post_messages = right and right[3] or 1,
      can_edit_messages = right and right[4] or 1,
      can_delete_messages = right and right[5] or 1,
      can_invite_users = right and right[6] or 1,
      can_restrict_members = right and right[7] or 1,
      can_pin_messages = right and right[8] or 1,
      can_promote_members = right and right[9] or 1
    }
  elseif rank == 'Restricted' then
    chat_member_status = {
      is_member = right and right[1] or 1,
      restricted_until_date = right and right[2] or 0,
      can_send_messages = right and right[3] or 1,
      can_send_media_messages = right and right[4] or 1,
      can_send_other_messages = right and right[5] or 1,
      can_add_web_page_previews = right and right[6] or 1
    }
  elseif rank == 'Banned' then
    chat_member_status = {
      banned_until_date = right and right[1] or 0
    }
  end

  chat_member_status._ = 'chatMemberStatus' .. rank

  assert (tdbot_function ({
    _ = 'changeChatMemberStatus',
    chat_id = chatid,
    user_id = userid,
    status = chat_member_status
  }, callback or dl_cb, data))
end

function tdbot.getChatMember(chatid, userid, callback, data)
  assert (tdbot_function ({
    _ = 'getChatMember',
    chat_id = chatid,
    user_id = userid
  }, callback or dl_cb, data))
end

function tdbot.searchChatMembers(chatid, query, lim, callback, data)
  assert (tdbot_function ({
    _ = 'searchChatMembers',
    chat_id = chatid,
    query = tostring(query),
    limit = lim
  }, callback or dl_cb, data))
end

function tdbot.setPinnedChats(chatids, callback, data)
  assert (tdbot_function ({
    _ = 'setPinnedChats',
    chat_ids = chatids
  }, callback or dl_cb, data))
end

function tdbot.downloadFile(fileid, priorities, callback, data)
  assert (tdbot_function ({
    _ = 'downloadFile',
    file_id = fileid,
    priority = priorities
  }, callback or dl_cb, data))
end

function tdbot.cancelDownloadFile(fileid, callback, data)
  assert (tdbot_function ({
    _ = 'cancelDownloadFile',
    file_id = fileid
  }, callback or dl_cb, data))
end

function tdbot.uploadFile(filetoupload, filetype, prior, callback, data)
  assert (tdbot_function ({
    _ = 'uploadFile',
    file = getInputFile(filetoupload),
    file_type = {
      _ = 'fileType' .. filetype,
    },
    priority = prior
  }, callback or dl_cb, data))
end

function tdbot.cancelUploadFile(fileid, callback, data)
  assert (tdbot_function ({
    _ = 'cancelUploadFile',
    file_id = fileid
  }, callback or dl_cb, data))
end

function tdbot.setFileGenerationProgress(generationid, size, localsize, callback, data)
  assert (tdbot_function ({
    _ = 'setFileGenerationProgress',
    generation_id = generationid,
    size = size,
    local_size = localsize
  }, callback or dl_cb, data))
end

function tdbot.finishFileGeneration(generationid, callback, data)
  assert (tdbot_function ({
    _ = 'finishFileGeneration',
    generation_id = generationid
  }, callback or dl_cb, data))
end

function tdbot.deleteFile(fileid, callback, data)
  assert (tdbot_function ({
    _ = 'deleteFile',
    file_id = fileid
  }, callback or dl_cb, data))
end

function tdbot.exportChatInviteLink(chatid, callback, data)
  assert (tdbot_function ({
    _ = 'exportChatInviteLink',
    chat_id = chatid
  }, callback or dl_cb, data))
end

function tdbot.checkChatInviteLink(invitelink, callback, data)
  assert (tdbot_function ({
    _ = 'checkChatInviteLink',
    invite_link = tostring(invitelink)
  }, callback or dl_cb, data))
end

function tdbot.importChatInviteLink(invitelink, callback, data)
  assert (tdbot_function ({
    _ = 'importChatInviteLink',
    invite_link = tostring(invitelink)
  }, callback or dl_cb, data))
end

function tdbot.createCall(userid, udpp2p, udpreflector, minlayer, maxlayer, callback, data)
  assert (tdbot_function ({
    _ = 'createCall',
    user_id = userid,
    protocol = {
      _ = 'callProtocol',
      udp_p2p = udpp2p,
      udp_reflector = udpreflector,
      min_layer = minlayer,
      max_layer = maxlayer or 65
    },
  }, callback or dl_cb, data))
end

function tdbot.acceptCall(callid, udpp2p, udpreflector, minlayer, maxlayer, callback, data)
  assert (tdbot_function ({
    _ = 'acceptCall',
    call_id = callid,
    protocol = {
      _ = 'callProtocol',
      udp_p2p = udpp2p,
      udp_reflector = udpreflector,
      min_layer = minlayer,
      max_layer = maxlayer
    },
  }, callback or dl_cb, data))
end

function tdbot.discardCall(callid, isdisconnected, callduration, connectionid, callback, data)
  assert (tdbot_function ({
    _ = 'discardCall',
    call_id = callid,
    is_disconnected = isdisconnected,
    duration = callduration,
    connection_id = connectionid
  }, callback or dl_cb, data))
end

function tdbot.rateCall(callid, rating, usercomment, callback, data)
  assert (tdbot_function ({
    _ = 'rateCall',
    call_id = callid,
    rating = rating,
    comment = tostring(usercomment)
  }, callback or dl_cb, data))
end

function tdbot.debugCall(callid, debg, callback, data)
  assert (tdbot_function ({
    _ = 'debugCall',
    call_id = callid,
    debug = tostring(debg)
  }, callback or dl_cb, data))
end

function tdbot.blockUser(userid, callback, data)
  assert (tdbot_function ({
    _ = 'blockUser',
    user_id = userid
  }, callback or dl_cb, data))
end

function tdbot.unblockUser(userid, callback, data)
  assert (tdbot_function ({
    _ = 'unblockUser',
    user_id = userid
  }, callback or dl_cb, data))
end

function tdbot.getBlockedUsers(off, lim, callback, data)
  assert (tdbot_function ({
    _ = 'getBlockedUsers',
    offset = off,
    limit = lim
  }, callback or dl_cb, data))
end

function tdbot.importContacts(phonenumber, firstname, lastname, userid, callback, data)
  assert (tdbot_function ({
    _ = 'importContacts',
    contacts = {
      [0] = {
        _ = 'contact',
        phone_number = tostring(phonenumber),
        first_name = tostring(firstname),
        last_name = tostring(lastname),
        user_id = userid
      }
    },
  }, callback or dl_cb, data))
end

function tdbot.searchContacts(que, lim, callback, data)
  assert (tdbot_function ({
    _ = 'searchContacts',
    query = tostring(que),
    limit = lim
  }, callback or dl_cb, data))
end

function tdbot.deleteContacts(userids, callback, data)
  assert (tdbot_function ({
    _ = 'deleteContacts',
    user_ids = userids,
  }, callback or dl_cb, data))
end

function tdbot.getImportedContactCount(callback, data)
  assert (tdbot_function ({
    _ = 'getImportedContactCount'
  }, callback or dl_cb, data))
end

function tdbot.deleteImportedContacts(callback, data)
  assert (tdbot_function ({
    _ = 'deleteImportedContacts'
  }, callback or dl_cb, data))
end

function tdbot.getUserProfilePhotos(userid, off, lim, callback, data)
  assert (tdbot_function ({
    _ = 'getUserProfilePhotos',
    user_id = userid,
    offset = off,
    limit = lim
  }, callback or dl_cb, data))
end

function tdbot.getStickers(emo, lim, callback, data)
  assert (tdbot_function ({
    _ = 'getStickers',
    emoji = tostring(emo),
    limit = lim
  }, callback or dl_cb, data))
end

function tdbot.getInstalledStickerSets(ismasks, callback, data)
  assert (tdbot_function ({
    _ = 'getInstalledStickerSets',
    is_masks = ismasks
  }, callback or dl_cb, data))
end

function tdbot.getArchivedStickerSets(ismasks, offsetstickersetid, lim, callback, data)
  assert (tdbot_function ({
    _ = 'getArchivedStickerSets',
    is_masks = ismasks,
    offset_sticker_set_id = offsetstickersetid,
    limit = lim
  }, callback or dl_cb, data))
end

function tdbot.getTrendingStickerSets(callback, data)
  assert (tdbot_function ({
    _ = 'getTrendingStickerSets'
  }, callback or dl_cb, data))
end

function tdbot.getAttachedStickerSets(fileid, callback, data)
  assert (tdbot_function ({
    _ = 'getAttachedStickerSets',
    file_id = fileid
  }, callback or dl_cb, data))
end

function tdbot.getStickerSet(setid, callback, data)
  assert (tdbot_function ({
    _ = 'getStickerSet',
    set_id = setid
  }, callback or dl_cb, data))
end

function tdbot.searchStickerSet(sticker_name, callback, data)
  assert (tdbot_function ({
    _ = 'searchStickerSet',
    name = tostring(sticker_name)
  }, callback or dl_cb, data))
end

function tdbot.changeStickerSet(setid, isinstalled, isarchived, callback, data)
  assert (tdbot_function ({
    _ = 'changeStickerSet',
    set_id = setid,
    is_installed = isinstalled,
    is_archived = isarchived
  }, callback or dl_cb, data))
end

function tdbot.viewTrendingStickerSets(stickersetids, callback, data)
  assert (tdbot_function ({
    _ = 'viewTrendingStickerSets',
    sticker_set_ids = stickersetids
  }, callback or dl_cb, data))
end

function tdbot.reorderInstalledStickerSets(ismasks, stickersetids, callback, data)
  assert (tdbot_function ({
    _ = 'reorderInstalledStickerSets',
    is_masks = ismasks,
    sticker_set_ids = stickersetids
  }, callback or dl_cb, data))
end

function tdbot.getRecentStickers(isattached, callback, data)
  assert (tdbot_function ({
    _ = 'getRecentStickers',
    is_attached = isattached
  }, callback or dl_cb, data))
end

function tdbot.addRecentSticker(isattached, sticker_path, callback, data)
  assert (tdbot_function ({
    _ = 'addRecentSticker',
    is_attached = isattached,
    sticker = getInputFile(sticker_path)
  }, callback or dl_cb, data))
end

function tdbot.deleteRecentSticker(isattached, sticker_path, callback, data)
  assert (tdbot_function ({
    _ = 'deleteRecentSticker',
    is_attached = isattached,
    sticker = getInputFile(sticker_path)
  }, callback or dl_cb, data))
end

function tdbot.clearRecentStickers(isattached, callback, data)
  assert (tdbot_function ({
    _ = 'clearRecentStickers',
    is_attached = isattached
  }, callback or dl_cb, data))
end

function tdbot.getFavoriteStickers(callback, data)
  assert (tdbot_function ({
    _ = 'getFavoriteStickers'
  }, callback or dl_cb, data))
end

function tdbot.addFavoriteSticker(sticker_file, callback, data)
  assert (tdbot_function ({
    _ = 'addFavoriteSticker',
    sticker = getInputFile(sticker_file)
  }, callback or dl_cb, data))
end

function tdbot.deleteFavoriteSticker(sticker_file, callback, data)
  assert (tdbot_function ({
    _ = 'deleteFavoriteSticker',
    sticker = getInputFile(sticker_file)
  }, callback or dl_cb, data))
end

function tdbot.getStickerEmojis(sticker_path, callback, data)
  assert (tdbot_function ({
    _ = 'getStickerEmojis',
    sticker = getInputFile(sticker_path)
  }, callback or dl_cb, data))
end

function tdbot.getSavedAnimations(callback, data)
  assert (tdbot_function ({
    _ = 'getSavedAnimations'
  }, callback or dl_cb, data))
end

function tdbot.addSavedAnimation(animation_path, callback, data)
  assert (tdbot_function ({
    _ = 'addSavedAnimation',
    animation = getInputFile(animation_path)
  }, callback or dl_cb, data))
end

function tdbot.deleteSavedAnimation(animation_path, callback, data)
  assert (tdbot_function ({
    _ = 'deleteSavedAnimation',
    animation = getInputFile(animation_path)
  }, callback or dl_cb, data))
end

function tdbot.getRecentInlineBots(callback, data)
  assert (tdbot_function ({
    _ = 'getRecentInlineBots'
  }, callback or dl_cb, data))
end

function tdbot.searchHashtags(prefix, lim, callback, data)
  assert (tdbot_function ({
    _ = 'searchHashtags',
    prefix = tostring(prefix),
    limit = lim
  }, callback or dl_cb, data))
end

function tdbot.deleteRecentHashtag(hash, callback, data)
  assert (tdbot_function ({
    _ = 'deleteRecentHashtag',
    hashtag = tostring(hash)
  }, callback or dl_cb, data))
end

function tdbot.getWebPagePreview(messagetext, callback, data)
  assert (tdbot_function ({
    _ = 'getWebPagePreview',
    message_text = tostring(messagetext)
  }, callback or dl_cb, data))
end

function tdbot.getWebPageInstantView(uri, forcefull, callback, data)
  assert (tdbot_function ({
    _ = 'getWebPageInstantView',
    url = tostring(uri),
    force_full = forcefull
  }, callback or dl_cb, data))
end

function tdbot.getNotificationSettings(scop, chatid, callback, data)
  assert (tdbot_function ({
    _ = 'getNotificationSettings',
    scope = {
      _ = 'notificationSettingsScope' .. scop,
      chat_id = chatid
    },
  }, callback or dl_cb, data))
end

function tdbot.setNotificationSettings(scop, chatid, mutefor, isound, showpreview, callback, data)
  assert (tdbot_function ({
    _ = 'setNotificationSettings',
    scope = {
      _ = 'notificationSettingsScope' .. scop,
      chat_id = chatid
    },
    notification_settings = {
      _ = 'notificationSettings',
      mute_for = mutefor,
      sound = tostring(isound),
      show_preview = showpreview
    },
  }, callback or dl_cb, data))
end

function tdbot.resetAllNotificationSettings(callback, data)
  assert (tdbot_function ({
    _ = 'resetAllNotificationSettings'
  }, callback or dl_cb, data))
end

function tdbot.setProfilePhoto(photo_path, callback, data)
  assert (tdbot_function ({
    _ = 'setProfilePhoto',
    photo = getInputFile(photo_path)
  }, callback or dl_cb, data))
end

function tdbot.deleteProfilePhoto(profilephotoid, callback, data)
  assert (tdbot_function ({
    _ = 'deleteProfilePhoto',
    profile_photo_id = profilephotoid
  }, callback or dl_cb, data))
end

function tdbot.changeName(firstname, lastname, callback, data)
  assert (tdbot_function ({
    _ = 'changeName',
    first_name = tostring(firstname),
    last_name = tostring(lastname)
  }, callback or dl_cb, data))
end

function tdbot.changeAbout(abo, callback, data)
  assert (tdbot_function ({
    _ = 'changeAbout',
    about = tostring(abo)
  }, callback or dl_cb, data))
end

function tdbot.changeUsername(uname, callback, data)
  assert (tdbot_function ({
    _ = 'changeUsername',
    username = tostring(uname)
  }, callback or dl_cb, data))
end

function tdbot.changePhoneNumber(phonenumber, allowflashcall, iscurrentphonenumber, callback, data)
  assert (tdbot_function ({
    _ = 'changePhoneNumber',
    phone_number = tostring(phonenumber),
    allow_flash_call = allowflashcall,
    is_current_phone_number = iscurrentphonenumber
  }, callback or dl_cb, data))
end

function tdbot.resendChangePhoneNumberCode(callback, data)
  assert (tdbot_function ({
    _ = 'resendChangePhoneNumberCode'
  }, callback or dl_cb, data))
end

function tdbot.checkChangePhoneNumberCode(cod, callback, data)
  assert (tdbot_function ({
    _ = 'checkChangePhoneNumberCode',
    code = tostring(cod)
  }, callback or dl_cb, data))
end

function tdbot.getActiveSessions(callback, data)
  assert (tdbot_function ({
    _ = 'getActiveSessions'
  }, callback or dl_cb, data))
end

function tdbot.terminateSession(sessionid, callback, data)
  assert (tdbot_function ({
    _ = 'terminateSession',
    session_id = sessionid
  }, callback or dl_cb, data))
end

function tdbot.terminateAllOtherSessions(callback, data)
  assert (tdbot_function ({
    _ = 'terminateAllOtherSessions'
  }, callback or dl_cb, data))
end

function tdbot.toggleGroupAdministrators(groupid, everyoneisadministrator, callback, data)
  assert (tdbot_function ({
    _ = 'toggleGroupAdministrators',
    group_id = getChatId(groupid).id,
    everyone_is_administrator = everyoneisadministrator
  }, callback or dl_cb, data))
end

function tdbot.changeChannelUsername(channelid, uname, callback, data)
  assert (tdbot_function ({
    _ = 'changeChannelUsername',
    channel_id = getChatId(channelid).id,
    username = tostring(uname)
  }, callback or dl_cb, data))
end

function tdbot.setChannelStickerSet(channelid, stickersetid, callback, data)
  assert (tdbot_function ({
    _ = 'setChannelStickerSet',
    channel_id = getChatId(channelid).id,
    sticker_set_id = stickersetid
  }, callback or dl_cb, data))
end

function tdbot.toggleChannelInvites(channelid, anyonecaninvite, callback, data)
  assert (tdbot_function ({
    _ = 'toggleChannelInvites',
    channel_id = getChatId(channelid).id,
    anyone_can_invite = anyonecaninvite
  }, callback or dl_cb, data))
end

function tdbot.toggleChannelSignMessages(channelid, signmessages, callback, data)
  assert (tdbot_function ({
    _ = 'toggleChannelSignMessages',
    channel_id = getChatId(channelid).id,
    sign_messages = signmessages
  }, callback or dl_cb, data))
end

function tdbot.changeChannelDescription(channelid, descript, callback, data)
  assert (tdbot_function ({
    _ = 'changeChannelDescription',
    channel_id = getChatId(channelid).id,
    description = tostring(descript)
  }, callback or dl_cb, data))
end

function tdbot.pinChannelMessage(channelid, messageid, disablenotification, callback, data)
  assert (tdbot_function ({
    _ = 'pinChannelMessage',
    channel_id = getChatId(channelid).id,
    message_id = messageid,
    disable_notification = disablenotification
  }, callback or dl_cb, data))
end

function tdbot.unpinChannelMessage(channelid, callback, data)
  assert (tdbot_function ({
    _ = 'unpinChannelMessage',
    channel_id = getChatId(channelid).id
  }, callback or dl_cb, data))
end

function tdbot.reportChannelSpam(channelid, userid, messageids, callback, data)
  assert (tdbot_function ({
    _ = 'reportChannelSpam',
    channel_id = getChatId(channelid).id,
    user_id = userid,
    message_ids = messageids
  }, callback or dl_cb, data))
end

function tdbot.getChannelMembers(channelid, off, lim, mbrfilter, callback, data)
 -- local lim = lim or 200
--  lim = lim > 200 and 200 or lim

  assert (tdbot_function ({
    _ = 'getChannelMembers',
    channel_id = getChatId(channelid).id,
    filter = {
      _ = 'channelMembersFilter' .. mbrfilter,
      --query = tostring(searchquery)
    },
    offset = off,
    limit = lim
  }, callback or dl_cb, data))
end

function tdbot.deleteChannel(channelid, callback, data)
  assert (tdbot_function ({
    _ = 'deleteChannel',
    channel_id = getChatId(channelid).id
  }, callback or dl_cb, data))
end

function tdbot.closeSecretChat(secretchatid, callback, data)
  assert (tdbot_function ({
    _ = 'closeSecretChat',
    secret_chat_id = secretchatid
  }, callback or dl_cb, data))
end

function tdbot.getChatEventLog(chatid, searchquery, fromeventid, lim, userids, msgedits, msgdeletions, msgpins, mbrjoins, mbrleaves, mbrinvites, mbrpromotions, mbrrestrictions, infochanges, settingchanges, callback, data)
  assert (tdbot_function ({
    _ = 'getChatEventLog',
    chat_id = chatid,
    query = tostring(searchquery),
    from_event_id = fromeventid,
    limit = lim,
    filters = {
      _ = 'chatEventLogFilters',
      message_edits = msgedits or 1,
      message_deletions = msgdeletions or 1,
      message_pins = msgpins or 1,
      member_joins = mbrjoins or 1,
      member_leaves = mbrleaves or 1,
      member_invites = mbrinvites or 1,
      member_promotions = mbrpromotions or 1,
      member_restrictions = mbrrestrictions or 1,
      info_changes = infochanges or 1,
      setting_changes = settingchanges or 1
    },
    user_ids = userids
  }, callback or dl_cb, data))
end

function tdbot.getPaymentForm(chatid, messageid, callback, data)
  assert (tdbot_function ({
    _ = 'getPaymentForm',
    chat_id = chatid,
    message_id = messageid
  }, callback or dl_cb, data))
end

function tdbot.validateOrderInfo(chatid, messageid, orderinfo, allowsave, callback, data)
  assert (tdbot_function ({
    _ = 'validateOrderInfo',
    chat_id = chatid,
    message_id = messageid,
    order_info = orderInfo,
    allow_save = allowsave
  }, callback or dl_cb, data))
end

function tdbot.sendPaymentForm(chatid, messageid, orderinfoid, shippingoptionid, credent, input_credentials, callback, data)
  local input_credentials = input_credentials or {}

  if credent == 'Saved' then
    input_credentials = {
      saved_credentials_id = tostring(input_credentials[1])
    }
  elseif credent == 'New' then
    input_credentials = {
      data = tostring(input_credentials[1]),
      allow_save = input_credentials[2]
    }
  end

  input_credentials._ = 'inputCredentials' .. credent

  assert (tdbot_function ({
    _ = 'sendPaymentForm',
    chat_id = chatid,
    message_id = messageid,
    order_info_id = tostring(orderinfoid),
    shipping_option_id = tostring(shippingoptionid),
    credentials = input_credentials
  }, callback or dl_cb, data))
end

function tdbot.getPaymentReceipt(chatid, messageid, callback, data)
  assert (tdbot_function ({
    _ = 'getPaymentReceipt',
    chat_id = chatid,
    message_id = messageid
  }, callback or dl_cb, data))
end

function tdbot.getSavedOrderInfo(callback, data)
  assert (tdbot_function ({
    _ = 'getSavedOrderInfo'
  }, callback or dl_cb, data))
end

function tdbot.deleteSavedOrderInfo(callback, data)
  assert (tdbot_function ({
    _ = 'deleteSavedOrderInfo'
  }, callback or dl_cb, data))
end

function tdbot.deleteSavedCredentials(callback, data)
  assert (tdbot_function ({
    _ = 'deleteSavedCredentials'
  }, callback or dl_cb, data))
end

function tdbot.getSupportUser(callback, data)
  assert (tdbot_function ({
    _ = 'getSupportUser'
  }, callback or dl_cb, data))
end

function tdbot.getWallpapers(callback, data)
  assert (tdbot_function ({
    _ = 'getWallpapers'
  }, callback or dl_cb, data))
end

function tdbot.registerDevice(devicetoken, tokn, callback, data)
  assert (tdbot_function ({
    _ = 'registerDevice',
    device_token = {
      _ = 'deviceToken' .. devicetoken,
      token = tokn
    },
  }, callback or dl_cb, data))
end

function tdbot.setPrivacy(privacy_key, rule, allowed_user_ids, disallowed_user_ids, callback, data)
  local privacy_rules = {[0] = {_ = 'privacyRule' .. rule}}

  if allowed_user_ids then
    privacy_rules = {
      {
        _ = 'privacyRule' .. rule
      },
      [0] = {
        _ = 'privacyRuleAllowUsers',
        user_ids = allowed_user_ids
      },
    }
  end
  if disallowed_user_ids then
    privacy_rules = {
      {
        _ = 'privacyRule' .. rule
      },
      [0] = {
        _ = 'privacyRuleDisallowUsers',
        user_ids = disallowed_user_ids
      },
    }
  end
  if allowed_user_ids and disallowed_user_ids then
    privacy_rules = {
      {
        _ = 'privacyRule' .. rule
      },
      {
        _ = 'privacyRuleAllowUsers',
        user_ids = allowed_user_ids
      },
      [0] = {
        _ = 'privacyRuleDisallowUsers',
        user_ids = disallowed_user_ids
      },
    }
  end
  assert (tdbot_function ({
    _ = 'setPrivacy',
    key = {
      _ = 'privacyKey' .. privacy_key
    },
    rules = {
      _ = 'privacyRules',
      rules = privacy_rules,
    },
  }, callback or dl_cb, data))
end

function tdbot.getPrivacy(pkey, callback, data)
  assert (tdbot_function ({
    _ = 'getPrivacy',
    key = {
      _ = 'privacyKey' .. pkey
    },
  }, callback or dl_cb, data))
end

function tdbot.getOption(optionname, callback, data)
  assert (tdbot_function ({
    _ = 'getOption',
    name = tostring(optionname)
  }, callback or dl_cb, data))
end

function tdbot.setOption(optionname, option, optionvalue, callback, data)
  assert (tdbot_function ({
    _ = 'setOption',
    name = tostring(optionname),
    value = {
      _ = 'optionValue' .. option,
      value = optionvalue
    },
  }, callback or dl_cb, data))
end

function tdbot.changeAccountTtl(day, callback, data)
  assert (tdbot_function ({
    _ = 'changeAccountTtl',
    ttl = {
      _ = 'accountTtl',
      days = day
    },
  }, callback or dl_cb, data))
end

function tdbot.getAccountTtl(callback, data)
  assert (tdbot_function ({
    _ = 'getAccountTtl'
  }, callback or dl_cb, data))
end

function tdbot.deleteAccount(rea, callback, data)
  assert (tdbot_function ({
    _ = 'deleteAccount',
    reason = tostring(rea)
  }, callback or dl_cb, data))
end

function tdbot.getChatReportSpamState(chatid, callback, data)
  assert (tdbot_function ({
    _ = 'getChatReportSpamState',
    chat_id = chatid
  }, callback or dl_cb, data))
end

function tdbot.changeChatReportSpamState(chatid, isspamchat, callback, data)
  assert (tdbot_function ({
    _ = 'changeChatReportSpamState',
    chat_id = chatid,
    is_spam_chat = isspamchat
  }, callback or dl_cb, data))
end

function tdbot.reportChat(chatid, reasn, teks, callback, data)
  assert (tdbot_function ({
    _ = 'reportChat',
    chat_id = chatid,
    reason = {
      _ = 'chatReportReason' .. reasn,
      text = teks
    },
  }, callback or dl_cb, data))
end

function tdbot.getStorageStatistics(chatlimit, callback, data)
  assert (tdbot_function ({
    _ = 'getStorageStatistics',
    chat_limit = chatlimit
  }, callback or dl_cb, data))
end

function tdbot.getStorageStatisticsFast(callback, data)
  assert (tdbot_function ({
    _ = 'getStorageStatisticsFast'
  }, callback or dl_cb, data))
end

function tdbot.optimizeStorage(siz, tt, cnt, immunitydelay, filetypes, chatids, excludechatids, chatlimit, callback, data)
  assert (tdbot_function ({
    _ = 'optimizeStorage',
    size = siz or -1,
    ttl = tt or -1,
    count = cnt or -1,
    immunity_delay = immunitydelay or -1,
    file_types = {
      _ = 'fileType' .. filetypes
    },
    chat_ids = chatids,
    exclude_chat_ids = excludechatids,
    chat_limit = chatlimit
  }, callback or dl_cb, data))
end

function tdbot.setNetworkType(network_type, callback, data)
  assert (tdbot_function ({
    _ = 'setNetworkType',
    type = {
      _ = 'networkType' .. network_type
    },
  }, callback or dl_cb, data))
end

function tdbot.getNetworkStatistics(onlycurrent, callback, data)
  assert (tdbot_function ({
    _ = 'getNetworkStatistics',
    only_current = onlycurrent
  }, callback or dl_cb, data))
end

function tdbot.addNetworkStatistics(entri, filetype, networktype, sentbytes, receivedbytes, durasi, callback, data)
  assert (tdbot_function ({
    _ = 'addNetworkStatistics',
    entry = {
      _ = 'networkStatisticsEntry' .. entri,
      file_type = {
        _ = 'fileType' .. filetype
      },
      network_type = {
        _ = 'networkType' .. networktype
      },
      sent_bytes = sentbytes,
      received_bytes = receivedbytes,
      duration = durasi
    },
  }, callback or dl_cb, data))
end

function tdbot.resetNetworkStatistics(callback, data)
  assert (tdbot_function ({
    _ = 'resetNetworkStatistics'
  }, callback or dl_cb, data))
end

function tdbot.setBotUpdatesStatus(pendingupdatecount, errormessage, callback, data)
  assert (tdbot_function ({
    _ = 'setBotUpdatesStatus',
    pending_update_count = pendingupdatecount,
    error_message = tostring(errormessage)
  }, callback or dl_cb, data))
end

function tdbot.uploadStickerFile(userid, pngsticker, callback, data)
  assert (tdbot_function ({
    _ = 'uploadStickerFile',
    user_id = userid,
    png_sticker = getInputFile(pngsticker)
  }, callback or dl_cb, data))
end

function tdbot.createNewStickerSet(userid, title, name, ismasks, pngsticker, emoji, points, x_shifts, y_shifts, scales, callback, data)
  assert (tdbot_function ({
    _ = 'createNewStickerSet',
    user_id = userid,
    title = tostring(title),
    name = tostring(name),
    is_masks = ismasks,
    stickers = {
      _ = 'inputSticker',
      png_sticker = getInputFile(pngsticker),
      emojis = tostring(emoji),
      mask_position = {
        _ = 'maskPosition',
        point = points,
        x_shift = x_shifts,
        y_shift = y_shifts,
        scale = scales
      },
    },
  }, callback or dl_cb, data))
end

function tdbot.addStickerToSet(userid, name, pngsticker, mpoint, xshift, yshift, mscale, callback, data)
  assert (tdbot_function ({
    _ = 'addStickerToSet',
    user_id = userid,
    name = tostring(name),
    sticker = {
      _ = 'inputSticker',
      png_sticker = getInputFile(pngsticker),
      emojis = tostring(emoji),
      mask_position = {
        _ = 'maskPosition',
        point = mpoint,
        x_shift = xshift,
        y_shift = yshift,
        scale = mscale
      },
    },
  }, callback or dl_cb, data))
end

function tdbot.setStickerPositionInSet(sticker, position, callback, data)
  assert (tdbot_function ({
    _ = 'setStickerPositionInSet',
    sticker = getInputFile(sticker),
    position = position
  }, callback or dl_cb, data))
end

function tdbot.deleteStickerFromSet(sticker, callback, data)
  assert (tdbot_function ({
    _ = 'deleteStickerFromSet',
    sticker = getInputFile(sticker)
  }, callback or dl_cb, data))
end

function tdbot.sendCustomRequest(method, parameters, callback, data)
  assert (tdbot_function ({
    _ = 'sendCustomRequest',
    method = tostring(method),
    parameters = tostring(parameters)
  }, callback or dl_cb, data))
end

function tdbot.answerCustomQuery(customqueryid, data, callback, data)
  assert (tdbot_function ({
    _ = 'answerCustomQuery',
    custom_query_id = customqueryid,
    data = tostring(data)
  }, callback or dl_cb, data))
end

function tdbot.setAlarm(sec, callback, data)
  assert (tdbot_function ({
    _ = 'setAlarm',
    seconds = sec
  }, callback or dl_cb, data))
end

function tdbot.getInviteText(callback, data)
  assert (tdbot_function ({
    _ = 'getInviteText'
  }, callback or dl_cb, data))
end

function tdbot.getTermsOfService(callback, data)
  assert (tdbot_function ({
    _ = 'getTermsOfService'
  }, callback or dl_cb, data))
end

function tdbot.setProxy(proksi, serv, pport, uname, passwd, callback, data)
  assert (tdbot_function ({
    _ = 'setProxy',
    proxy = {
      _ = 'proxy' .. proksi,
      server = tostring(serv),
      port = pport,
      username = tostring(uname),
      password = tostring(passwd),
    },
  }, callback or dl_cb, data))
end

function tdbot.getProxy(callback, data)
  assert (tdbot_function ({
    _ = 'getProxy'
  }, callback or dl_cb, data))
end

function tdbot.sendText(chat_id, reply_to_message_id, text, disable_notification, from_background, reply_markup, disablewebpagepreview, parsemode, cleardraft, entity, callback, data)
  local input_message_content = {
    _ = 'inputMessageText',
    text = tostring(text),
    disable_web_page_preview = disablewebpagepreview,
    parse_mode = getParseMode(parsemode),
    clear_draft = cleardraft,
    entities = entity
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendAnimation(chat_id, reply_to_message_id, animation_file, aniwidth, aniheight, anicaption, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    _ = 'inputMessageAnimation',
    animation = getInputFile(animation_file),
    thumb = inputThumb,
    duration = duration,
    width = aniwidth,
    height = aniheight,
    caption = tostring(anicaption)
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup, callback, data)
end
function tdbot.sendAudio(chat_id, reply_to_message_id, audio, duration, title, performer, caption, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    _ = 'inputMessageAudio',
    audio = getInputFile(audio),
    album_cover_thumb = inputThumb,
    duration = duration or 0,
    title = tostring(title) or 0,
    performer = tostring(performer),
    caption = tostring(caption)
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendDocument(chat_id, document, caption, doc_thumb, reply_to_message_id, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    _ = 'inputMessageDocument',
    document = getInputFile(document),
    thumb = doc_thumb, -- inputThumb
    caption = tostring(caption)
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendPhoto(chat_id, reply_to_message_id, photo_file, photo_thumb, addedstickerfileids, photo_width, photo_height, photo_caption, photo_ttl, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    _ = 'inputMessagePhoto',
    photo = getInputFile(photo_file),
    -- thumb = photo_thumb, -- inputThumb
    added_sticker_file_ids = addedstickerfileids,
    width = photo_width,
    height = photo_height,
    caption = tostring(photo_caption),
    ttl = photo_ttl
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendSticker(chat_id, reply_to_message_id, sticker_file, sticker_width, sticker_height, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    _ = 'inputMessageSticker',
    sticker = getInputFile(sticker_file),
    thumb = sticker_thumb, -- inputThumb
    width = sticker_width,
    height = sticker_height
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendVideo(chat_id, reply_to_message_id, video_file, vid_thumb, addedstickerfileids, vid_duration, vid_width, vid_height, vid_caption, vid_ttl, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    _ = 'inputMessageVideo',
    video = getInputFile(video_file),
    thumb = vid_thumb, -- inputThumb
    added_sticker_file_ids = addedstickerfileids,
    duration = vid_duration or 0,
    width = vid_width or 0,
    height = vid_height or 0,
    caption = tostring(vid_caption),
    ttl = vid_ttl
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendVideoNote(chat_id, reply_to_message_id, videonote, vnote_thumb, vnote_duration, vnote_length, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    _ = 'inputMessageVideoNote',
    video_note = getInputFile(videonote),
    thumb = vidnote_thumb, -- inputThumb
    duration = vnote_duration,
    length = vnote_length
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendVoice(chat_id, reply_to_message_id, voice_file, voi_duration, voi_waveform, voi_caption, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    _ = 'inputMessageVoice',
    voice = getInputFile(voice_file),
    duration = voi_duration or 0,
    waveform = voi_waveform,
    caption = tostring(voi_caption)
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendLocation(chat_id, reply_to_message_id, lat, lon, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    _ = 'inputMessageLocation',
    location = {
      _ = 'location',
      latitude = lat,
      longitude = lon
    },
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendVenue(chat_id, reply_to_message_id, lat, lon, ven_title, ven_address, ven_provider, ven_id, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    _ = 'inputMessageVenue',
    venue = {
      _ = 'venue',
      location = {
        _ = 'location',
        latitude = lat,
        longitude = lon
      },
      title = tostring(ven_title),
      address = tostring(ven_address),
      provider = tostring(ven_provider) or 'foursquare',
      id = tostring(ven_id)
    },
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendContact(chat_id, reply_to_message_id, phonenumber, firstname, lastname, userid, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    _ = 'inputMessageContact',
    contact = {
      _ = 'contact',
      phone_number = tostring(phonenumber),
      first_name = tostring(firstname),
      last_name = tostring(lastname),
      user_id = userid
    },
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendGame(chat_id, reply_to_message_id, botuserid, gameshortname, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    _ = 'inputMessageGame',
    bot_user_id = botuserid,
    game_short_name = tostring(gameshortname)
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendInvoice(chat_id, reply_to_message_id, the_invoice, inv_title, inv_desc, photourl, photosize, photowidth, photoheight, inv_payload, providertoken, startparameter, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    _ = 'inputMessageInvoice',
    invoice = the_invoice,
    -- invoice = {
      -- _ = 'invoice',
      -- currency = tostring(currency),
      -- prices = prices, -- vector<labeledPrice>
      -- is_test = is_test,
      -- need_name = need_name,
      -- need_phone_number = need_phone_number,
      -- need_email = need_email,
      -- need_shipping_address = need_shipping_address,
      -- is_flexible = is_flexible
    -- },
    title = tostring(inv_title),
    description = tostring(inv_desc),
    photo_url = tostring(photourl),
    photo_size = photosize,
    photo_width = photowidth,
    photo_height = photoheight,
    payload = inv_payload,
    provider_token = tostring(providertoken),
    start_parameter = tostring(startparameter)
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendForwarded(chat_id, reply_to_message_id, fromchatid, messageid, ingameshare, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    _ = 'inputMessageForwarded',
    from_chat_id = fromchatid,
    message_id = messageid,
    in_game_share = ingameshare
  }
  sendAllMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup, callback, data)
end

return tdbot
