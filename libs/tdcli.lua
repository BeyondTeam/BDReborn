--[[
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.

]]--

-- Vector example form is like this: {[0] = v} or {v1, v2, v3, [0] = v}
-- If false or true crashed your telegram-cli, try to change true to 1 and false to 0

-- Main Bot Framework
local M = {}

-- @chat_id = user, group, channel, and broadcast
-- @group_id = normal group
-- @channel_id = channel and broadcast
local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)

  if chat_id:match('^-100') then
    local channel_id = chat_id:gsub('-100', '')
    chat = {ID = channel_id, type = 'channel'}
  else
    local group_id = chat_id:gsub('-', '')
    chat = {ID = group_id, type = 'group'}
  end

  return chat
end

local function getInputFile(file)
  if file:match('/') then
    infile = {ID = "InputFileLocal", path_ = file}
  elseif file:match('^%d+$') then
    infile = {ID = "InputFileId", id_ = file}
  else
    infile = {ID = "InputFilePersistentId", persistent_id_ = file}
  end

  return infile
end

-- User can send bold, italic, and monospace text uses HTML or Markdown format.
local function getParseMode(parse_mode)
  if parse_mode then
    local mode = parse_mode:lower()

    if mode == 'markdown' or mode == 'md' then
      P = {ID = "TextParseModeMarkdown"}
    elseif mode == 'html' then
      P = {ID = "TextParseModeHTML"}
    end
  end

  return P
end

-- Returns current authorization state, offline request
local function getAuthState(dl_cb, cmd)
  tdcli_function ({
    ID = "GetAuthState",
  }, dl_cb, cmd)
end

M.getAuthState = getAuthState

-- Sets user's phone number and sends authentication code to the user.
-- Works only when authGetState returns authStateWaitPhoneNumber.
-- If phone number is not recognized or another error has happened, returns an error. Otherwise returns authStateWaitCode
-- @phone_number User's phone number in any reasonable format
-- @allow_flash_call Pass True, if code can be sent via flash call to the specified phone number
-- @is_current_phone_number Pass true, if the phone number is used on the current device. Ignored if allow_flash_call is False
local function setAuthPhoneNumber(phone_number, allow_flash_call, is_current_phone_number, dl_cb, cmd)
  tdcli_function ({
    ID = "SetAuthPhoneNumber",
    phone_number_ = phone_number,
    allow_flash_call_ = allow_flash_call,
    is_current_phone_number_ = is_current_phone_number
  }, dl_cb, cmd)
end

M.setAuthPhoneNumber = setAuthPhoneNumber

-- Resends authentication code to the user.
-- Works only when authGetState returns authStateWaitCode and next_code_type of result is not null.
-- Returns authStateWaitCode on success
local function resendAuthCode(dl_cb, cmd)
  tdcli_function ({
    ID = "ResendAuthCode",
  }, dl_cb, cmd)
end

M.resendAuthCode = resendAuthCode

-- Checks authentication code.
-- Works only when authGetState returns authStateWaitCode.
-- Returns authStateWaitPassword or authStateOk on success
-- @code Verification code from SMS, Telegram message, voice call or flash call
-- @first_name User first name, if user is yet not registered, 1-255 characters
-- @last_name Optional user last name, if user is yet not registered, 0-255 characters
local function checkAuthCode(code, first_name, last_name, dl_cb, cmd)
  tdcli_function ({
    ID = "CheckAuthCode",
    code_ = code,
    first_name_ = first_name,
    last_name_ = last_name
  }, dl_cb, cmd)
end

M.checkAuthCode = checkAuthCode

-- Checks password for correctness.
-- Works only when authGetState returns authStateWaitPassword.
-- Returns authStateOk on success
-- @password Password to check
local function checkAuthPassword(password, dl_cb, cmd)
  tdcli_function ({
    ID = "CheckAuthPassword",
    password_ = password
  }, dl_cb, cmd)
end

M.checkAuthPassword = checkAuthPassword

-- Requests to send password recovery code to email.
-- Works only when authGetState returns authStateWaitPassword.
-- Returns authStateWaitPassword on success
local function requestAuthPasswordRecovery(dl_cb, cmd)
  tdcli_function ({
    ID = "RequestAuthPasswordRecovery",
  }, dl_cb, cmd)
end

M.requestAuthPasswordRecovery = requestAuthPasswordRecovery

-- Recovers password with recovery code sent to email.
-- Works only when authGetState returns authStateWaitPassword.
-- Returns authStateOk on success
-- @recovery_code Recovery code to check
local function recoverAuthPassword(recovery_code, dl_cb, cmd)
  tdcli_function ({
    ID = "RecoverAuthPassword",
    recovery_code_ = recovery_code
  }, dl_cb, cmd)
end

M.recoverAuthPassword = recoverAuthPassword

-- Logs out user.
-- If force == false, begins to perform soft log out, returns authStateLoggingOut after completion.
-- If force == true then succeeds almost immediately without cleaning anything at the server, but returns error with code 401 and description "Unauthorized"
-- @force If true, just delete all local data. Session will remain in list of active sessions
local function resetAuth(force, dl_cb, cmd)
  tdcli_function ({
    ID = "ResetAuth",
    force_ = force or nil
  }, dl_cb, cmd)
end

M.resetAuth = resetAuth

-- Check bot's authentication token to log in as a bot.
-- Works only when authGetState returns authStateWaitPhoneNumber.
-- Can be used instead of setAuthPhoneNumber and checkAuthCode to log in.
-- Returns authStateOk on success
-- @token Bot token
local function checkAuthBotToken(token, dl_cb, cmd)
  tdcli_function ({
    ID = "CheckAuthBotToken",
    token_ = token
  }, dl_cb, cmd)
end

M.checkAuthBotToken = checkAuthBotToken

-- Returns current state of two-step verification
local function getPasswordState(dl_cb, cmd)
  tdcli_function ({
    ID = "GetPasswordState",
  }, dl_cb, cmd)
end

M.getPasswordState = getPasswordState

-- Changes user password.
-- If new recovery email is specified, then error EMAIL_UNCONFIRMED is returned and password change will not be applied until email confirmation.
-- Application should call getPasswordState from time to time to check if email is already confirmed
-- @old_password Old user password
-- @new_password New user password, may be empty to remove the password
-- @new_hint New password hint, can be empty
-- @set_recovery_email Pass True, if recovery email should be changed
-- @new_recovery_email New recovery email, may be empty
local function setPassword(old_password, new_password, new_hint, set_recovery_email, new_recovery_email, dl_cb, cmd)
  tdcli_function ({
    ID = "SetPassword",
    old_password_ = old_password,
    new_password_ = new_password,
    new_hint_ = new_hint,
    set_recovery_email_ = set_recovery_email,
    new_recovery_email_ = new_recovery_email
  }, dl_cb, cmd)
end

M.setPassword = setPassword

-- Returns set up recovery email.
-- This method can be used to verify a password provided by the user
-- @password Current user password
local function getRecoveryEmail(password, dl_cb, cmd)
  tdcli_function ({
    ID = "GetRecoveryEmail",
    password_ = password
  }, dl_cb, cmd)
end

M.getRecoveryEmail = getRecoveryEmail

-- Changes user recovery email.
-- If new recovery email is specified, then error EMAIL_UNCONFIRMED is returned and email will not be changed until email confirmation.
-- Application should call getPasswordState from time to time to check if email is already confirmed.
-- If new_recovery_email coincides with the current set up email succeeds immediately and aborts all other requests waiting for email confirmation
-- @password Current user password
-- @new_recovery_email New recovery email
local function setRecoveryEmail(password, new_recovery_email, dl_cb, cmd)
  tdcli_function ({
    ID = "SetRecoveryEmail",
    password_ = password,
    new_recovery_email_ = new_recovery_email
  }, dl_cb, cmd)
end

M.setRecoveryEmail = setRecoveryEmail

-- Requests to send password recovery code to email
local function requestPasswordRecovery(dl_cb, cmd)
  tdcli_function ({
    ID = "RequestPasswordRecovery",
  }, dl_cb, cmd)
end

M.requestPasswordRecovery = requestPasswordRecovery

-- Recovers password with recovery code sent to email
-- @recovery_code Recovery code to check
local function recoverPassword(recovery_code, dl_cb, cmd)
  tdcli_function ({
    ID = "RecoverPassword",
    recovery_code_ = tostring(recovery_code)
  }, dl_cb, cmd)
end

M.recoverPassword = recoverPassword

-- Returns current logged in user
local function getMe(dl_cb, cmd)
  tdcli_function ({
    ID = "GetMe",
  }, dl_cb, cmd)
end

M.getMe = getMe

-- Returns information about a user by its identifier, offline request if current user is not a bot
-- @user_id User identifier
local function getUser(user_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetUser",
    user_id_ = user_id
  }, dl_cb, cmd)
end

M.getUser = getUser

-- Returns full information about a user by its identifier
-- @user_id User identifier
local function getUserFull(user_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetUserFull",
    user_id_ = user_id
  }, dl_cb, cmd)
end

M.getUserFull = getUserFull

-- Returns information about a group by its identifier, offline request if current user is not a bot
-- @group_id Group identifier
local function getGroup(group_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetGroup",
    group_id_ = getChatId(group_id).ID
  }, dl_cb, cmd)
end

M.getGroup = getGroup

-- Returns full information about a group by its identifier
-- @group_id Group identifier
local function getGroupFull(group_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetGroupFull",
    group_id_ = getChatId(group_id).ID
  }, dl_cb, cmd)
end

M.getGroupFull = getGroupFull

-- Returns information about a channel by its identifier, offline request if current user is not a bot
-- @channel_id Channel identifier
local function getChannel(channel_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetChannel",
    channel_id_ = getChatId(channel_id).ID
  }, dl_cb, cmd)
end

M.getChannel = getChannel

-- Returns full information about a channel by its identifier, cached for at most 1 minute
-- @channel_id Channel identifier
local function getChannelFull(channel_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetChannelFull",
    channel_id_ = getChatId(channel_id).ID
  }, dl_cb, cmd)
end

M.getChannelFull = getChannelFull

-- Returns information about a secret chat by its identifier, offline request
-- @secret_chat_id Secret chat identifier
local function getSecretChat(secret_chat_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetSecretChat",
    secret_chat_id_ = secret_chat_id
  }, dl_cb, cmd)
end

M.getSecretChat = getSecretChat

-- Returns information about a chat by its identifier, offline request if current user is not a bot
-- @chat_id Chat identifier
local function getChat(chat_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetChat",
    chat_id_ = chat_id
  }, dl_cb, cmd)
end

M.getChat = getChat

-- Returns information about a message
-- @chat_id Identifier of the chat, message belongs to
-- @message_id Identifier of the message to get
local function getMessage(chat_id, message_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetMessage",
    chat_id_ = chat_id,
    message_id_ = message_id
  }, dl_cb, cmd)
end

M.getMessage = getMessage

-- Returns information about messages.
-- If message is not found, returns null on the corresponding position of the result
-- @chat_id Identifier of the chat, messages belongs to
-- @message_ids Identifiers of the messages to get
local function getMessages(chat_id, message_ids, dl_cb, cmd)
  tdcli_function ({
    ID = "GetMessages",
    chat_id_ = chat_id,
    message_ids_ = message_ids -- vector
  }, dl_cb, cmd)
end

M.getMessages = getMessages

-- Returns information about a file, offline request
-- @file_id Identifier of the file to get
local function getFile(file_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetFile",
    file_id_ = file_id
  }, dl_cb, cmd)
end

M.getFile = getFile

-- Returns information about a file by its persistent id, offline request
-- @persistent_file_id Persistent identifier of the file to get
local function getFilePersistent(persistent_file_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetFilePersistent",
    persistent_file_id_ = persistent_file_id
  }, dl_cb, cmd)
end

M.getFilePersistent = getFilePersistent

-- Returns list of chats in the right order, chats are sorted by (order, chat_id) in decreasing order.
-- For example, to get list of chats from the beginning, the offset_order should be equal 2^63 - 1
-- @offset_order Chat order to return chats from
-- @offset_chat_id Chat identifier to return chats from
-- @limit Maximum number of chats to be returned
local function getChats(offset_order, offset_chat_id, limit, dl_cb, cmd)
  if not limit or limit > 20 then
    limit = 20
  end

  tdcli_function ({
    ID = "GetChats",
    offset_order_ = offset_order or 9223372036854775807,
    offset_chat_id_ = offset_chat_id or 0,
    limit_ = limit
  }, dl_cb, cmd)
end

M.getChats = getChats

-- Searches public chat by its username.
-- Currently only private and channel chats can be public.
-- Returns chat if found, otherwise some error is returned
-- @username Username to be resolved
local function searchPublicChat(username, dl_cb, cmd)
  tdcli_function ({
    ID = "SearchPublicChat",
    username_ = username
  }, dl_cb, cmd)
end

M.searchPublicChat = searchPublicChat

-- Searches public chats by prefix of their username.
-- Currently only private and channel (including supergroup) chats can be public.
-- Returns meaningful number of results.
-- Returns nothing if length of the searched username prefix is less than 5.
-- Excludes private chats with contacts from the results
-- @username_prefix Prefix of the username to search
local function searchPublicChats(username_prefix, dl_cb, cmd)
  tdcli_function ({
    ID = "SearchPublicChats",
    username_prefix_ = username_prefix
  }, dl_cb, cmd)
end

M.searchPublicChats = searchPublicChats

-- Searches for specified query in the title and username of known chats, offline request.
-- Returns chats in the order of them in the chat list
-- @query Query to search for, if query is empty, returns up to 20 recently found chats
-- @limit Maximum number of chats to be returned
local function searchChats(query, limit, dl_cb, cmd)
  if not limit or limit > 20 then
    limit = 20
  end

  tdcli_function ({
    ID = "SearchChats",
    query_ = query,
    limit_ = limit
  }, dl_cb, cmd)
end

M.searchChats = searchChats

-- Adds chat to the list of recently found chats.
-- The chat is added to the beginning of the list.
-- If the chat is already in the list, at first it is removed from the list
-- @chat_id Identifier of the chat to add
local function addRecentlyFoundChat(chat_id, dl_cb, cmd)
  tdcli_function ({
    ID = "AddRecentlyFoundChat",
    chat_id_ = chat_id
  }, dl_cb, cmd)
end

M.addRecentlyFoundChat = addRecentlyFoundChat

-- Deletes chat from the list of recently found chats
-- @chat_id Identifier of the chat to delete
local function deleteRecentlyFoundChat(chat_id, dl_cb, cmd)
  tdcli_function ({
    ID = "DeleteRecentlyFoundChat",
    chat_id_ = chat_id
  }, dl_cb, cmd)
end

M.deleteRecentlyFoundChat = deleteRecentlyFoundChat

-- Clears list of recently found chats
local function deleteRecentlyFoundChats(dl_cb, cmd)
  tdcli_function ({
    ID = "DeleteRecentlyFoundChats",
  }, dl_cb, cmd)
end

M.deleteRecentlyFoundChats = deleteRecentlyFoundChats

-- Returns list of common chats with an other given user.
-- Chats are sorted by their type and creation date
-- @user_id User identifier
-- @offset_chat_id Chat identifier to return chats from, use 0 for the first request
-- @limit Maximum number of chats to be returned, up to 100
local function getCommonChats(user_id, offset_chat_id, limit, dl_cb, cmd)
  if not limit or limit > 100 then
    limit = 100
  end

  tdcli_function ({
    ID = "GetCommonChats",
    user_id_ = user_id,
    offset_chat_id_ = offset_chat_id,
    limit_ = limit
  }, dl_cb, cmd)
end

M.getCommonChats = getCommonChats

-- Returns messages in a chat.
-- Automatically calls openChat.
-- Returns result in reverse chronological order, i.e. in order of decreasing message.message_id
-- @chat_id Chat identifier
-- @from_message_id Identifier of the message near which we need a history, you can use 0 to get results from the beginning, i.e. from oldest to newest
-- @offset Specify 0 to get results exactly from from_message_id or negative offset to get specified message and some newer messages
-- @limit Maximum number of messages to be returned, should be positive and can't be greater than 100.
-- If offset is negative, limit must be greater than -offset.
-- There may be less than limit messages returned even the end of the history is not reached
local function getChatHistory(chat_id, from_message_id, offset, limit, dl_cb, cmd)
  if not limit or limit > 100 then
    limit = 100
  end

  tdcli_function ({
    ID = "GetChatHistory",
    chat_id_ = chat_id,
    from_message_id_ = from_message_id,
    offset_ = offset or 0,
    limit_ = limit
  }, dl_cb, cmd)
end

M.getChatHistory = getChatHistory

-- Deletes all messages in the chat.
-- Can't be used for channel chats
-- @chat_id Chat identifier
-- @remove_from_chat_list Pass true, if chat should be removed from the chat list
local function deleteChatHistory(chat_id, remove_from_chat_list, dl_cb, cmd)
  tdcli_function ({
    ID = "DeleteChatHistory",
    chat_id_ = chat_id,
    remove_from_chat_list_ = remove_from_chat_list
  }, dl_cb, cmd)
end

M.deleteChatHistory = deleteChatHistory

-- Searches for messages with given words in the chat.
-- Returns result in reverse chronological order, i. e. in order of decreasimg message_id.
-- Doesn't work in secret chats
-- @chat_id Chat identifier to search in
-- @query Query to search for
-- @from_message_id Identifier of the message from which we need a history, you can use 0 to get results from beginning
-- @limit Maximum number of messages to be returned, can't be greater than 100
-- @filter Filter for content of searched messages
-- filter = Empty|Animation|Audio|Document|Photo|Video|Voice|PhotoAndVideo|Url|ChatPhoto
local function searchChatMessages(chat_id, query, from_message_id, limit, filter, dl_cb, cmd)
  if not limit or limit > 100 then
    limit = 100
  end

  tdcli_function ({
    ID = "SearchChatMessages",
    chat_id_ = chat_id,
    query_ = query,
    from_message_id_ = from_message_id,
    limit_ = limit,
    filter_ = {
      ID = 'SearchMessagesFilter' .. filter
    },
  }, dl_cb, cmd)
end

M.searchChatMessages = searchChatMessages

-- Searches for messages in all chats except secret chats. Returns result in reverse chronological order, i. e. in order of decreasing (date, chat_id, message_id)
-- @query Query to search for
-- @offset_date Date of the message to search from, you can use 0 or any date in the future to get results from the beginning
-- @offset_chat_id Chat identifier of the last found message or 0 for the first request
-- @offset_message_id Message identifier of the last found message or 0 for the first request
-- @limit Maximum number of messages to be returned, can't be greater than 100
local function searchMessages(query, offset_date, offset_chat_id, offset_message_id, limit, dl_cb, cmd)
  if not limit or limit > 100 then
    limit = 100
  end

  tdcli_function ({
    ID = "SearchMessages",
    query_ = query,
    offset_date_ = offset_date,
    offset_chat_id_ = offset_chat_id,
    offset_message_id_ = offset_message_id,
    limit_ = limit
  }, dl_cb, cmd)
end

M.searchMessages = searchMessages

-- Invites bot to a chat (if it is not in the chat) and send /start to it.
-- Bot can't be invited to a private chat other than chat with the bot.
-- Bots can't be invited to broadcast channel chats and secret chats.
-- Returns sent message.
-- UpdateChatTopMessage will not be sent, so returned message should be used to update chat top message
-- @bot_user_id Identifier of the bot
-- @chat_id Identifier of the chat
-- @parameter Hidden parameter sent to bot for deep linking (https://api.telegram.org/bots#deep-linking)
-- parameter=start|startgroup or custom as defined by bot creator
local function sendBotStartMessage(bot_user_id, chat_id, parameter, dl_cb, cmd)
  tdcli_function ({
    ID = "SendBotStartMessage",
    bot_user_id_ = bot_user_id,
    chat_id_ = chat_id,
    parameter_ = parameter
  }, dl_cb, cmd)
end

M.sendBotStartMessage = sendBotStartMessage

-- Sends result of the inline query as a message.
-- Returns sent message.
-- UpdateChatTopMessage will not be sent, so returned message should be used to update chat top message.
-- Always clears chat draft message
-- @chat_id Chat to send message
-- @reply_to_message_id Identifier of a message to reply to or 0
-- @disable_notification Pass true, to disable notification about the message, doesn't works in secret chats
-- @from_background Pass true, if the message is sent from background
-- @query_id Identifier of the inline query
-- @result_id Identifier of the inline result
local function sendInlineQueryResultMessage(chat_id, reply_to_message_id, disable_notification, from_background, query_id, result_id, dl_cb, cmd)
  tdcli_function ({
    ID = "SendInlineQueryResultMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    query_id_ = query_id,
    result_id_ = result_id
  }, dl_cb, cmd)
end

M.sendInlineQueryResultMessage = sendInlineQueryResultMessage

-- Forwards previously sent messages.
-- Returns forwarded messages in the same order as message identifiers passed in message_ids.
-- If message can't be forwarded, null will be returned instead of the message.
-- UpdateChatTopMessage will not be sent, so returned messages should be used to update chat top message
-- @chat_id Identifier of a chat to forward messages
-- @from_chat_id Identifier of a chat to forward from
-- @message_ids Identifiers of messages to forward
-- @disable_notification Pass true, to disable notification about the message, doesn't works if messages are forwarded to secret chat
-- @from_background Pass true, if the message is sent from background
local function forwardMessages(chat_id, from_chat_id, message_ids, disable_notification, dl_cb, cmd)
  tdcli_function ({
    ID = "ForwardMessages",
    chat_id_ = chat_id,
    from_chat_id_ = from_chat_id,
    message_ids_ = message_ids, -- vector
    disable_notification_ = disable_notification,
    from_background_ = 1
  }, dl_cb, cmd)
end

M.forwardMessages = forwardMessages

-- Changes current ttl setting in a secret chat and sends corresponding message
-- @chat_id Chat identifier
-- @ttl New value of ttl in seconds
local function sendChatSetTtlMessage(chat_id, ttl, dl_cb, cmd)
  tdcli_function ({
    ID = "SendChatSetTtlMessage",
    chat_id_ = chat_id,
    ttl_ = ttl
  }, dl_cb, cmd)
end

M.sendChatSetTtlMessage = sendChatSetTtlMessage

-- Deletes messages.
-- UpdateDeleteMessages will not be sent for messages deleted through that function
-- @chat_id Chat identifier
-- @message_ids Identifiers of messages to delete
local function deleteMessages(chat_id, message_ids, dl_cb, cmd)
  tdcli_function ({
    ID = "DeleteMessages",
    chat_id_ = chat_id,
    message_ids_ = message_ids -- vector
  }, dl_cb, cmd)
end

M.deleteMessages = deleteMessages

-- Deletes all messages in the chat sent by the specified user.
-- Works only in supergroup channel chats, needs appropriate privileges
-- @chat_id Chat identifier
-- @user_id User identifier
local function deleteMessagesFromUser(chat_id, user_id, dl_cb, cmd)
  tdcli_function ({
    ID = "DeleteMessagesFromUser",
    chat_id_ = chat_id,
    user_id_ = user_id
  }, dl_cb, cmd)
end

M.deleteMessagesFromUser = deleteMessagesFromUser

-- Edits text of text or game message.
-- Non-bots can edit message in a limited period of time.
-- Returns edited message after edit is complete server side
-- @chat_id Chat the message belongs to
-- @message_id Identifier of the message
-- @reply_markup Bots only. New message reply markup
-- @input_message_content New text content of the message. Should be of type InputMessageText
local function editMessageText(chat_id, message_id, reply_markup, text, disable_web_page_preview, parse_mode, dl_cb, cmd)
  local TextParseMode = getParseMode(parse_mode)

  tdcli_function ({
    ID = "EditMessageText",
    chat_id_ = chat_id,
    message_id_ = message_id,
    reply_markup_ = reply_markup, -- reply_markup:ReplyMarkup
    input_message_content_ = {
      ID = "InputMessageText",
      text_ = text,
      disable_web_page_preview_ = disable_web_page_preview,
      clear_draft_ = 0,
      entities_ = {},
      parse_mode_ = TextParseMode,
    },
  }, dl_cb, cmd)
end

M.editMessageText = editMessageText

-- Edits message content caption.
-- Non-bots can edit message in a limited period of time.
-- Returns edited message after edit is complete server side
-- @chat_id Chat the message belongs to
-- @message_id Identifier of the message
-- @reply_markup Bots only. New message reply markup
-- @caption New message content caption, 0-200 characters
local function editMessageCaption(chat_id, message_id, reply_markup, caption, dl_cb, cmd)
  tdcli_function ({
    ID = "EditMessageCaption",
    chat_id_ = chat_id,
    message_id_ = message_id,
    reply_markup_ = reply_markup, -- reply_markup:ReplyMarkup
    caption_ = caption
  }, dl_cb, cmd)
end

M.editMessageCaption = editMessageCaption

-- Bots only.
-- Edits message reply markup.
-- Returns edited message after edit is complete server side
-- @chat_id Chat the message belongs to
-- @message_id Identifier of the message
-- @reply_markup New message reply markup
local function editMessageReplyMarkup(inline_message_id, reply_markup, caption, dl_cb, cmd)
  tdcli_function ({
    ID = "EditInlineMessageCaption",
    inline_message_id_ = inline_message_id,
    reply_markup_ = reply_markup, -- reply_markup:ReplyMarkup
    caption_ = caption
  }, dl_cb, cmd)
end

M.editMessageReplyMarkup = editMessageReplyMarkup

-- Bots only.
-- Edits text of an inline text or game message sent via bot
-- @inline_message_id Inline message identifier
-- @reply_markup New message reply markup
-- @input_message_content New text content of the message. Should be of type InputMessageText
local function editInlineMessageText(inline_message_id, reply_markup, text, disable_web_page_preview, dl_cb, cmd)
  tdcli_function ({
    ID = "EditInlineMessageText",
    inline_message_id_ = inline_message_id,
    reply_markup_ = reply_markup, -- reply_markup:ReplyMarkup
    input_message_content_ = {
      ID = "InputMessageText",
      text_ = text,
      disable_web_page_preview_ = disable_web_page_preview,
      clear_draft_ = 0,
      entities_ = {}
    },
  }, dl_cb, cmd)
end

M.editInlineMessageText = editInlineMessageText

-- Bots only.
-- Edits caption of an inline message content sent via bot
-- @inline_message_id Inline message identifier
-- @reply_markup New message reply markup
-- @caption New message content caption, 0-200 characters
local function editInlineMessageCaption(inline_message_id, reply_markup, caption, dl_cb, cmd)
  tdcli_function ({
    ID = "EditInlineMessageCaption",
    inline_message_id_ = inline_message_id,
    reply_markup_ = reply_markup, -- reply_markup:ReplyMarkup
    caption_ = caption
  }, dl_cb, cmd)
end

M.editInlineMessageCaption = editInlineMessageCaption

-- Bots only.
-- Edits reply markup of an inline message sent via bot
-- @inline_message_id Inline message identifier
-- @reply_markup New message reply markup
local function editInlineMessageReplyMarkup(inline_message_id, reply_markup, dl_cb, cmd)
  tdcli_function ({
    ID = "EditInlineMessageReplyMarkup",
    inline_message_id_ = inline_message_id,
    reply_markup_ = reply_markup -- reply_markup:ReplyMarkup
  }, dl_cb, cmd)
end

M.editInlineMessageReplyMarkup = editInlineMessageReplyMarkup


-- Sends inline query to a bot and returns its results.
-- Unavailable for bots
-- @bot_user_id Identifier of the bot send query to
-- @chat_id Identifier of the chat, where the query is sent
-- @user_location User location, only if needed
-- @query Text of the query
-- @offset Offset of the first entry to return
local function getInlineQueryResults(bot_user_id, chat_id, latitude, longitude, query, offset, dl_cb, cmd)
  tdcli_function ({
    ID = "GetInlineQueryResults",
    bot_user_id_ = bot_user_id,
    chat_id_ = chat_id,
    user_location_ = {
      ID = "Location",
      latitude_ = latitude,
      longitude_ = longitude
    },
    query_ = query,
    offset_ = offset
  }, dl_cb, cmd)
end

M.getInlineQueryResults = getInlineQueryResults

-- Bots only.
-- Sets result of the inline query
-- @inline_query_id Identifier of the inline query
-- @is_personal Does result of the query can be cached only for specified user
-- @results Results of the query
-- @cache_time Allowed time to cache results of the query in seconds
-- @next_offset Offset for the next inline query, pass empty string if there is no more results
-- @switch_pm_text If non-empty, this text should be shown on the button, which opens private chat with the bot and sends bot start message with parameter switch_pm_parameter
-- @switch_pm_parameter Parameter for the bot start message
local function answerInlineQuery(inline_query_id, is_personal, cache_time, next_offset, switch_pm_text, switch_pm_parameter, dl_cb, cmd)
  tdcli_function ({
    ID = "AnswerInlineQuery",
    inline_query_id_ = inline_query_id,
    is_personal_ = is_personal,
    results_ = results, --vector<InputInlineQueryResult>,
    cache_time_ = cache_time,
    next_offset_ = next_offset,
    switch_pm_text_ = switch_pm_text,
    switch_pm_parameter_ = switch_pm_parameter
  }, dl_cb, cmd)
end

M.answerInlineQuery = answerInlineQuery

-- Sends callback query to a bot and returns answer to it.
-- Unavailable for bots
-- @chat_id Identifier of the chat with a message
-- @message_id Identifier of the message, from which the query is originated
-- @payload Query payload
-- @text Text of the answer
-- @show_alert If true, an alert should be shown to the user instead of a toast
-- @url URL to be open
local function getCallbackQueryAnswer(chat_id, message_id, text, show_alert, url, dl_cb, cmd)
  tdcli_function ({
    ID = "GetCallbackQueryAnswer",
    chat_id_ = chat_id,
    message_id_ = message_id,
    payload_ = {
      ID = "CallbackQueryAnswer",
      text_ = text,
      show_alert_ = show_alert,
      url_ = url
    },
  }, dl_cb, cmd)
end

M.getCallbackQueryAnswer = getCallbackQueryAnswer

-- Bots only.
-- Sets result of the callback query
-- @callback_query_id Identifier of the callback query
-- @text Text of the answer
-- @show_alert If true, an alert should be shown to the user instead of a toast
-- @url Url to be opened
-- @cache_time Allowed time to cache result of the query in seconds
local function answerCallbackQuery(callback_query_id, text, show_alert, url, cache_time, dl_cb, cmd)
  tdcli_function ({
    ID = "AnswerCallbackQuery",
    callback_query_id_ = callback_query_id,
    text_ = text,
    show_alert_ = show_alert,
    url_ = url,
    cache_time_ = cache_time
  }, dl_cb, cmd)
end

M.answerCallbackQuery = answerCallbackQuery

-- Bots only.
-- Updates game score of the specified user in the game
-- @chat_id Chat a message with the game belongs to
-- @message_id Identifier of the message
-- @edit_message True, if message should be edited
-- @user_id User identifier
-- @score New score
-- @force Pass True to update the score even if it decreases. If score is 0, user will be deleted from the high scores table
local function setGameScore(chat_id, message_id, edit_message, user_id, score, force, dl_cb, cmd)
  tdcli_function ({
    ID = "SetGameScore",
    chat_id_ = chat_id,
    message_id_ = message_id,
    edit_message_ = edit_message,
    user_id_ = user_id,
    score_ = score,
    force_ = force
  }, dl_cb, cmd)
end

M.setGameScore = setGameScore

-- Bots only.
-- Updates game score of the specified user in the game
-- @inline_message_id Inline message identifier
-- @edit_message True, if message should be edited
-- @user_id User identifier
-- @score New score
-- @force Pass True to update the score even if it decreases. If score is 0, user will be deleted from the high scores table
local function setInlineGameScore(inline_message_id, edit_message, user_id, score, force, dl_cb, cmd)
  tdcli_function ({
    ID = "SetInlineGameScore",
    inline_message_id_ = inline_message_id,
    edit_message_ = edit_message,
    user_id_ = user_id,
    score_ = score,
    force_ = force
  }, dl_cb, cmd)
end

M.setInlineGameScore = setInlineGameScore

-- Bots only.
-- Returns game high scores and some part of the score table around of the specified user in the game
-- @chat_id Chat a message with the game belongs to
-- @message_id Identifier of the message
-- @user_id User identifie
local function getGameHighScores(chat_id, message_id, user_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetGameHighScores",
    chat_id_ = chat_id,
    message_id_ = message_id,
    user_id_ = user_id
  }, dl_cb, cmd)
end

M.getGameHighScores = getGameHighScores

-- Bots only.
-- Returns game high scores and some part of the score table around of the specified user in the game
-- @inline_message_id Inline message identifier
-- @user_id User identifier
local function getInlineGameHighScores(inline_message_id, user_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetInlineGameHighScores",
    inline_message_id_ = inline_message_id,
    user_id_ = user_id
  }, dl_cb, cmd)
end

M.getInlineGameHighScores = getInlineGameHighScores

-- Deletes default reply markup from chat.
-- This method needs to be called after one-time keyboard or ForceReply reply markup has been used.
-- UpdateChatReplyMarkup will be send if reply markup will be changed
-- @chat_id Chat identifier
-- @message_id Message identifier of used keyboard
local function deleteChatReplyMarkup(chat_id, message_id, dl_cb, cmd)
  tdcli_function ({
    ID = "DeleteChatReplyMarkup",
    chat_id_ = chat_id,
    message_id_ = message_id
  }, dl_cb, cmd)
end

M.deleteChatReplyMarkup = deleteChatReplyMarkup

-- Sends notification about user activity in a chat
-- @chat_id Chat identifier
-- @action Action description
-- action = Typing|Cancel|RecordVideo|UploadVideo|RecordVoice|UploadVoice|UploadPhoto|UploadDocument|GeoLocation|ChooseContact|StartPlayGame
local function sendChatAction(chat_id, action, progress, dl_cb, cmd)
  tdcli_function ({
    ID = "SendChatAction",
    chat_id_ = chat_id,
    action_ = {
      ID = "SendMessage" .. action .. "Action",
      progress_ = progress or 100
    }
  }, dl_cb, cmd)
end

M.sendChatAction = sendChatAction

-- Sends notification about screenshot taken in a chat.
-- Works only in secret chats
-- @chat_id Chat identifier
local function sendChatScreenshotTakenNotification(chat_id, dl_cb, cmd)
  tdcli_function ({
    ID = "SendChatScreenshotTakenNotification",
    chat_id_ = chat_id
  }, dl_cb, cmd)
end

M.sendChatScreenshotTakenNotification = sendChatScreenshotTakenNotification

-- Chat is opened by the user.
-- Many useful activities depends on chat being opened or closed. For example, in channels all updates are received only for opened chats
-- @chat_id Chat identifier
local function openChat(chat_id, dl_cb, cmd)
  tdcli_function ({
    ID = "OpenChat",
    chat_id_ = chat_id
  }, dl_cb, cmd)
end

M.openChat = openChat

-- Chat is closed by the user.
-- Many useful activities depends on chat being opened or closed.
-- @chat_id Chat identifier
local function closeChat(chat_id, dl_cb, cmd)
  tdcli_function ({
    ID = "CloseChat",
    chat_id_ = chat_id
  }, dl_cb, cmd)
end

M.closeChat = closeChat

-- Messages are viewed by the user.
-- Many useful activities depends on message being viewed. For example, marking messages as read, incrementing of view counter, updating of view counter, removing of deleted messages in channels
-- @chat_id Chat identifier
-- @message_ids Identifiers of viewed messages
local function viewMessages(chat_id, message_ids, dl_cb, cmd)
  tdcli_function ({
    ID = "ViewMessages",
    chat_id_ = chat_id,
    message_ids_ = message_ids -- vector
  }, dl_cb, cmd)
end

M.viewMessages = viewMessages

-- Message content is opened, for example the user has opened a photo, a video, a document, a location or a venue or have listened to an audio or a voice message
-- @chat_id Chat identifier of the message
-- @message_id Identifier of the message with opened content
local function openMessageContent(chat_id, message_id, dl_cb, cmd)
  tdcli_function ({
    ID = "OpenMessageContent",
    chat_id_ = chat_id,
    message_id_ = message_id
  }, dl_cb, cmd)
end

M.openMessageContent = openMessageContent

-- Returns existing chat corresponding to the given user
-- @user_id User identifier
local function createPrivateChat(user_id, dl_cb, cmd)
  tdcli_function ({
    ID = "CreatePrivateChat",
    user_id_ = user_id
  }, dl_cb, cmd)
end

M.createPrivateChat = createPrivateChat

-- Returns existing chat corresponding to the known group
-- @group_id Group identifier
local function createGroupChat(group_id, dl_cb, cmd)
  tdcli_function ({
    ID = "CreateGroupChat",
    group_id_ = getChatId(group_id).ID
  }, dl_cb, cmd)
end

M.createGroupChat = createGroupChat

-- Returns existing chat corresponding to the known channel
-- @channel_id Channel identifier
local function createChannelChat(channel_id, dl_cb, cmd)
  tdcli_function ({
    ID = "CreateChannelChat",
    channel_id_ = getChatId(channel_id).ID
  }, dl_cb, cmd)
end

M.createChannelChat = createChannelChat

-- Returns existing chat corresponding to the known secret chat
-- @secret_chat_id SecretChat identifier
local function createSecretChat(secret_chat_id, dl_cb, cmd)
  tdcli_function ({
    ID = "CreateSecretChat",
    secret_chat_id_ = secret_chat_id
  }, dl_cb, cmd)
end

M.createSecretChat = createSecretChat

-- Creates new group chat and send corresponding messageGroupChatCreate, returns created chat
-- @user_ids Identifiers of users to add to the group
-- @title Title of new group chat, 0-255 characters
local function createNewGroupChat(user_ids, title, dl_cb, cmd)
  tdcli_function ({
    ID = "CreateNewGroupChat",
    user_ids_ = user_ids, -- vector
    title_ = title
  }, dl_cb, cmd)
end

M.createNewGroupChat = createNewGroupChat

-- Creates new channel chat and send corresponding messageChannelChatCreate, returns created chat
-- @title Title of new channel chat, 0-255 characters
-- @is_supergroup True, if supergroup chat should be created
-- @about Information about the channel, 0-255 characters
local function createNewChannelChat(title, is_supergroup, about, dl_cb, cmd)
  tdcli_function ({
    ID = "CreateNewChannelChat",
    title_ = title,
    is_supergroup_ = is_supergroup,
    about_ = about
  }, dl_cb, cmd)
end

M.createNewChannelChat = createNewChannelChat

-- Creates new secret chat, returns created chat
-- @user_id Identifier of a user to create secret chat with
local function createNewSecretChat(user_id, dl_cb, cmd)
  tdcli_function ({
    ID = "CreateNewSecretChat",
    user_id_ = user_id
  }, dl_cb, cmd)
end

M.createNewSecretChat = createNewSecretChat

-- Creates new channel supergroup chat from existing group chat and send corresponding messageChatMigrateTo and messageChatMigrateFrom. Deactivates group
-- @chat_id Group chat identifier
local function migrateGroupChatToChannelChat(chat_id, dl_cb, cmd)
  tdcli_function ({
    ID = "MigrateGroupChatToChannelChat",
    chat_id_ = chat_id
  }, dl_cb, cmd)
end

M.migrateGroupChatToChannelChat = migrateGroupChatToChannelChat

-- Changes chat title.
-- Title can't be changed for private chats.
-- Title will not change until change will be synchronized with the server.
-- Title will not be changed if application is killed before it can send request to the server.
-- There will be update about change of the title on success. Otherwise error will be returned
-- @chat_id Chat identifier
-- @title New title of a chat, 0-255 characters
local function changeChatTitle(chat_id, title, dl_cb, cmd)
  tdcli_function ({
    ID = "ChangeChatTitle",
    chat_id_ = chat_id,
    title_ = title
  }, dl_cb, cmd)
end

M.changeChatTitle = changeChatTitle

-- Changes chat photo.
-- Photo can't be changed for private chats.
-- Photo will not change until change will be synchronized with the server.
-- Photo will not be changed if application is killed before it can send request to the server.
-- There will be update about change of the photo on success. Otherwise error will be returned
-- @chat_id Chat identifier
-- @photo New chat photo. You can use zero InputFileId to delete photo. Files accessible only by HTTP URL are not acceptable
local function changeChatPhoto(chat_id, photo, dl_cb, cmd)
  tdcli_function ({
    ID = "ChangeChatPhoto",
    chat_id_ = chat_id,
    photo_ = getInputFile(photo)
  }, dl_cb, cmd)
end

M.changeChatPhoto = changeChatPhoto

-- Changes chat draft message
-- @chat_id Chat identifier
-- @draft_message New draft message, nullable
local function changeChatDraftMessage(chat_id, reply_to_message_id, text, disable_web_page_preview, clear_draft, parse_mode, dl_cb, cmd)
  local TextParseMode = getParseMode(parse_mode)

  tdcli_function ({
    ID = "ChangeChatDraftMessage",
    chat_id_ = chat_id,
    draft_message_ = {
      ID = "DraftMessage",
      reply_to_message_id_ = reply_to_message_id,
      input_message_text_ = {
        ID = "InputMessageText",
        text_ = text,
        disable_web_page_preview_ = disable_web_page_preview,
        clear_draft_ = clear_draft,
        entities_ = {},
        parse_mode_ = TextParseMode,
      },
    },
  }, dl_cb, cmd)
end

M.changeChatDraftMessage = changeChatDraftMessage

-- Adds new member to chat.
-- Members can't be added to private or secret chats.
-- Member will not be added until chat state will be synchronized with the server.
-- Member will not be added if application is killed before it can send request to the server
-- @chat_id Chat identifier
-- @user_id Identifier of the user to add
-- @forward_limit Number of previous messages from chat to forward to new member, ignored for channel chats
local function addChatMember(chat_id, user_id, forward_limit, dl_cb, cmd)
  tdcli_function ({
    ID = "AddChatMember",
    chat_id_ = chat_id,
    user_id_ = user_id,
    forward_limit_ = forward_limit or 50
  }, dl_cb, cmd)
end

M.addChatMember = addChatMember

-- Adds many new members to the chat.
-- Currently, available only for channels.
-- Can't be used to join the channel.
-- Member will not be added until chat state will be synchronized with the server.
-- Member will not be added if application is killed before it can send request to the server
-- @chat_id Chat identifier
-- @user_ids Identifiers of the users to add
local function addChatMembers(chat_id, user_ids, dl_cb, cmd)
  tdcli_function ({
    ID = "AddChatMembers",
    chat_id_ = chat_id,
    user_ids_ = user_ids -- vector
  }, dl_cb, cmd)
end

M.addChatMembers = addChatMembers

-- Changes status of the chat member, need appropriate privileges.
-- In channel chats, user will be added to chat members if he is yet not a member and there is less than 200 members in the channel.
-- Status will not be changed until chat state will be synchronized with the server.
-- Status will not be changed if application is killed before it can send request to the server
-- @chat_id Chat identifier
-- @user_id Identifier of the user to edit status, bots can be editors in the channel chats
-- @status New status of the member in the chat
-- status = Creator|Editor|Moderator|Member|Left|Kicked
local function changeChatMemberStatus(chat_id, user_id, status, dl_cb, cmd)
  tdcli_function ({
    ID = "ChangeChatMemberStatus",
    chat_id_ = chat_id,
    user_id_ = user_id,
    status_ = {
      ID = "ChatMemberStatus" .. status
    },
  }, dl_cb, cmd)
end

M.changeChatMemberStatus = changeChatMemberStatus

-- Returns information about one participant of the chat
-- @chat_id Chat identifier
-- @user_id User identifier
local function getChatMember(chat_id, user_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetChatMember",
    chat_id_ = chat_id,
    user_id_ = user_id
  }, dl_cb, cmd)
end

M.getChatMember = getChatMember

-- Asynchronously downloads file from cloud.
-- Updates updateFileProgress will notify about download progress.
-- Update updateFile will notify about successful download
-- @file_id Identifier of file to download
local function downloadFile(file_id, dl_cb, cmd)
  tdcli_function ({
    ID = "DownloadFile",
    file_id_ = file_id
  }, dl_cb, cmd)
end

M.downloadFile = downloadFile

-- Stops file downloading.
-- If file already downloaded do nothing.
-- @file_id Identifier of file to cancel download
local function cancelDownloadFile(file_id, dl_cb, cmd)
  tdcli_function ({
    ID = "CancelDownloadFile",
    file_id_ = file_id
  }, dl_cb, cmd)
end

M.cancelDownloadFile = cancelDownloadFile

-- Next part of a file was generated
-- @generation_id Identifier of the generation process
-- @ready Number of bytes already generated. Negative number means that generation has failed and should be terminated
local function setFileGenerationProgress(generation_id, ready, dl_cb, cmd)
  tdcli_function ({
    ID = "SetFileGenerationProgress",
    generation_id_ = generation_id,
    ready_ = ready
  }, dl_cb, cmd)
end

M.setFileGenerationProgress = setFileGenerationProgress

-- Finishes file generation
-- @generation_id Identifier of the generation process
local function finishFileGeneration(generation_id, dl_cb, cmd)
  tdcli_function ({
    ID = "FinishFileGeneration",
    generation_id_ = generation_id
  }, dl_cb, cmd)
end

M.finishFileGeneration = finishFileGeneration

-- Generates new chat invite link, previously generated link is revoked.
-- Available for group and channel chats.
-- Only creator of the chat can export chat invite link
-- @chat_id Chat identifier
local function exportChatInviteLink(chat_id, dl_cb, cmd)
  tdcli_function ({
    ID = "ExportChatInviteLink",
    chat_id_ = chat_id
  }, dl_cb, cmd)
end

M.exportChatInviteLink = exportChatInviteLink

-- Checks chat invite link for validness and returns information about the corresponding chat
-- @invite_link Invite link to check. Should begin with "https://telegram.me/joinchat/"
local function checkChatInviteLink(link, dl_cb, cmd)
  tdcli_function ({
    ID = "CheckChatInviteLink",
    invite_link_ = link
  }, dl_cb, cmd)
end

M.checkChatInviteLink = checkChatInviteLink

-- Imports chat invite link, adds current user to a chat if possible.
-- Member will not be added until chat state will be synchronized with the server.
-- Member will not be added if application is killed before it can send request to the server
-- @invite_link Invite link to import. Should begin with "https://telegram.me/joinchat/"
local function importChatInviteLink(invite_link, dl_cb, cmd)
  tdcli_function ({
    ID = "ImportChatInviteLink",
    invite_link_ = invite_link
  }, dl_cb, cmd)
end

M.importChatInviteLink = importChatInviteLink

-- Adds user to black list
-- @user_id User identifier
local function blockUser(user_id, dl_cb, cmd)
  tdcli_function ({
    ID = "BlockUser",
    user_id_ = user_id
  }, dl_cb, cmd)
end

M.blockUser = blockUser

-- Removes user from black list
-- @user_id User identifier
local function unblockUser(user_id, dl_cb, cmd)
  tdcli_function ({
    ID = "UnblockUser",
    user_id_ = user_id
  }, dl_cb, cmd)
end

M.unblockUser = unblockUser

-- Returns users blocked by the current user
-- @offset Number of users to skip in result, must be non-negative
-- @limit Maximum number of users to return, can't be greater than 100
local function getBlockedUsers(offset, limit, dl_cb, cmd)
  tdcli_function ({
    ID = "GetBlockedUsers",
    offset_ = offset,
    limit_ = limit
  }, dl_cb, cmd)
end

M.getBlockedUsers = getBlockedUsers

-- Adds new contacts/edits existing contacts, contacts user identifiers are ignored.
-- Returns list of corresponding users in the same order as input contacts.
-- If contact doesn't registered in Telegram, user with id == 0 will be returned
-- @contacts List of contacts to import/edit
local function importContacts(phone_number, first_name, last_name, user_id, dl_cb, cmd)
  tdcli_function ({
    ID = "ImportContacts",
    contacts_ = {[0] = {
      phone_number_ = tostring(phone_number),
      first_name_ = tostring(first_name),
      last_name_ = tostring(last_name),
      user_id_ = user_id
      },
    },
  }, dl_cb, cmd)
end

M.importContacts = importContacts

-- Searches for specified query in the first name, last name and username of the known user contacts
-- @query Query to search for, can be empty to return all contacts
-- @limit Maximum number of users to be returned
local function searchContacts(query, limit, dl_cb, cmd)
  tdcli_function ({
    ID = "SearchContacts",
    query_ = query,
    limit_ = limit
  }, dl_cb, cmd)
end

M.searchContacts = searchContacts

-- Deletes users from contacts list
-- @user_ids Identifiers of users to be deleted
local function deleteContacts(user_ids, dl_cb, cmd)
  tdcli_function ({
    ID = "DeleteContacts",
    user_ids_ = user_ids -- vector
  }, dl_cb, cmd)
end

M.deleteContacts = deleteContacts

-- Returns profile photos of the user.
-- Result of this query can't be invalidated, so it must be used with care
-- @user_id User identifier
-- @offset Photos to skip, must be non-negative
-- @limit Maximum number of photos to be returned, can't be greater than 100
local function getUserProfilePhotos(user_id, offset, limit, dl_cb, cmd)
  tdcli_function ({
    ID = "GetUserProfilePhotos",
    user_id_ = user_id,
    offset_ = offset,
    limit_ = limit
  }, dl_cb, cmd)
end

M.getUserProfilePhotos = getUserProfilePhotos

-- Returns stickers corresponding to given emoji
-- @emoji String representation of emoji. If empty, returns all known stickers
local function getStickers(emoji, dl_cb, cmd)
  tdcli_function ({
    ID = "GetStickers",
    emoji_ = emoji
  }, dl_cb, cmd)
end

M.getStickers = getStickers

-- Returns list of installed sticker sets without archived sticker sets
-- @is_masks Pass true to return masks, pass false to return stickers
local function getStickerSets(is_masks, dl_cb, cmd)
  tdcli_function ({
    ID = "GetStickerSets",
    is_masks_ = is_masks
  }, dl_cb, cmd)
end

M.getStickerSets = getStickerSets

-- Returns list of archived sticker sets
-- @is_masks Pass true to return masks, pass false to return stickers
-- @offset_sticker_set_id Identifier of the sticker set from which return the result
-- @limit Maximum number of sticker sets to return
local function getArchivedStickerSets(is_masks, offset_sticker_set_id, limit, dl_cb, cmd)
  tdcli_function ({
    ID = "GetArchivedStickerSets",
    is_masks_ = is_masks,
    offset_sticker_set_id_ = offset_sticker_set_id,
    limit_ = limit
  }, dl_cb, cmd)
end

M.getArchivedStickerSets = getArchivedStickerSets

-- Returns list of trending sticker sets
local function getTrendingStickerSets(dl_cb, cmd)
  tdcli_function ({
    ID = "GetTrendingStickerSets"
  }, dl_cb, cmd)
end

M.getTrendingStickerSets = getTrendingStickerSets

-- Returns list of sticker sets attached to a file, currently only photos and videos can have attached sticker sets
-- @file_id File identifier
local function getAttachedStickerSets(file_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetAttachedStickerSets",
    file_id_ = file_id
  }, dl_cb, cmd)
end

M.getAttachedStickerSets = getAttachedStickerSets

-- Returns information about sticker set by its identifier
-- @set_id Identifier of the sticker set
local function getStickerSet(set_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetStickerSet",
    set_id_ = set_id
  }, dl_cb, cmd)
end

M.getStickerSet = getStickerSet

-- Searches sticker set by its short name
-- @name Name of the sticker set
local function searchStickerSet(name, dl_cb, cmd)
  tdcli_function ({
    ID = "SearchStickerSet",
    name_ = name
  }, dl_cb, cmd)
end

M.searchStickerSet = searchStickerSet

-- Installs/uninstalls or enables/archives sticker set.
-- Official sticker set can't be uninstalled, but it can be archived
-- @set_id Identifier of the sticker set
-- @is_installed New value of is_installed
-- @is_archived New value of is_archived
local function updateStickerSet(set_id, is_installed, is_archived, dl_cb, cmd)
  tdcli_function ({
    ID = "UpdateStickerSet",
    set_id_ = set_id,
    is_installed_ = is_installed,
    is_archived_ = is_archived
  }, dl_cb, cmd)
end

M.updateStickerSet = updateStickerSet

-- Trending sticker sets are viewed by the user
-- @sticker_set_ids Identifiers of viewed trending sticker sets
local function viewTrendingStickerSets(sticker_set_ids, dl_cb, cmd)
  tdcli_function ({
    ID = "ViewTrendingStickerSets",
    sticker_set_ids_ = sticker_set_ids -- vector
  }, dl_cb, cmd)
end

M.viewTrendingStickerSets = viewTrendingStickerSets

-- Changes the order of installed sticker sets
-- @is_masks Pass true to change masks order, pass false to change stickers order
-- @sticker_set_ids Identifiers of installed sticker sets in the new right order
local function reorderStickerSets(is_masks, sticker_set_ids, dl_cb, cmd)
  tdcli_function ({
    ID = "ReorderStickerSets",
    is_masks_ = is_masks,
    sticker_set_ids_ = sticker_set_ids -- vector
  }, dl_cb, cmd)
end

M.reorderStickerSets = reorderStickerSets

-- Returns list of recently used stickers
-- @is_attached Pass true to return stickers and masks recently attached to photo or video files, pass false to return recently sent stickers
local function getRecentStickers(is_attached, dl_cb, cmd)
  tdcli_function ({
    ID = "GetRecentStickers",
    is_attached_ = is_attached
  }, dl_cb, cmd)
end

M.getRecentStickers = getRecentStickers

-- Manually adds new sticker to the list of recently used stickers.
-- New sticker is added to the beginning of the list.
-- If the sticker is already in the list, at first it is removed from the list
-- @is_attached Pass true to add the sticker to the list of stickers recently attached to photo or video files, pass false to add the sticker to the list of recently sent stickers
-- @sticker Sticker file to add
local function addRecentSticker(is_attached, sticker, dl_cb, cmd)
  tdcli_function ({
    ID = "AddRecentSticker",
    is_attached_ = is_attached,
    sticker_ = getInputFile(sticker)
  }, dl_cb, cmd)
end

M.addRecentSticker = addRecentSticker

-- Removes a sticker from the list of recently used stickers
-- @is_attached Pass true to remove the sticker from the list of stickers recently attached to photo or video files, pass false to remove the sticker from the list of recently sent stickers
-- @sticker Sticker file to delete
local function deleteRecentSticker(is_attached, sticker, dl_cb, cmd)
  tdcli_function ({
    ID = "DeleteRecentSticker",
    is_attached_ = is_attached,
    sticker_ = getInputFile(sticker)
  }, dl_cb, cmd)
end

M.deleteRecentSticker = deleteRecentSticker

-- Clears list of recently used stickers
-- @is_attached Pass true to clear list of stickers recently attached to photo or video files, pass false to clear the list of recently sent stickers
local function clearRecentStickers(is_attached, dl_cb, cmd)
  tdcli_function ({
    ID = "ClearRecentStickers",
    is_attached_ = is_attached
  }, dl_cb, cmd)
end

M.clearRecentStickers = clearRecentStickers

-- Returns emojis corresponding to a sticker
-- @sticker Sticker file identifier
local function getStickerEmojis(sticker, dl_cb, cmd)
  tdcli_function ({
    ID = "GetStickerEmojis",
    sticker_ = getInputFile(sticker)
  }, dl_cb, cmd)
end

M.getStickerEmojis = getStickerEmojis

-- Returns saved animations
local function getSavedAnimations(dl_cb, cmd)
  tdcli_function ({
    ID = "GetSavedAnimations",
  }, dl_cb, cmd)
end

M.getSavedAnimations = getSavedAnimations

-- Manually adds new animation to the list of saved animations.
-- New animation is added to the beginning of the list.
-- If the animation is already in the list, at first it is removed from the list.
-- Only non-secret video animations with MIME type "video/mp4" can be added to the list
-- @animation Animation file to add. Only known to server animations (i. e. successfully sent via message) can be added to the list
local function addSavedAnimation(animation, dl_cb, cmd)
  tdcli_function ({
    ID = "AddSavedAnimation",
    animation_ = getInputFile(animation)
  }, dl_cb, cmd)
end

M.addSavedAnimation = addSavedAnimation

-- Removes animation from the list of saved animations
-- @animation Animation file to delete
local function deleteSavedAnimation(animation, dl_cb, cmd)
  tdcli_function ({
    ID = "DeleteSavedAnimation",
    animation_ = getInputFile(animation)
  }, dl_cb, cmd)
end

M.deleteSavedAnimation = deleteSavedAnimation

-- Returns up to 20 recently used inline bots in the order of the last usage
local function getRecentInlineBots(dl_cb, cmd)
  tdcli_function ({
    ID = "GetRecentInlineBots",
  }, dl_cb, cmd)
end

M.getRecentInlineBots = getRecentInlineBots

-- Get web page preview by text of the message.
-- Do not call this function to often
-- @message_text Message text
local function getWebPagePreview(message_text, dl_cb, cmd)
  tdcli_function ({
    ID = "GetWebPagePreview",
    message_text_ = message_text
  }, dl_cb, cmd)
end

M.getWebPagePreview = getWebPagePreview

-- Returns notification settings for a given scope
-- @scope Scope to return information about notification settings
-- scope = Chat(chat_id)|PrivateChats|GroupChats|AllChats|
local function getNotificationSettings(scope, chat_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetNotificationSettings",
    scope_ = {
      ID = 'NotificationSettingsFor' .. scope,
      chat_id_ = chat_id or nil
    },
  }, dl_cb, cmd)
end

M.getNotificationSettings = getNotificationSettings

-- Changes notification settings for a given scope
-- @scope Scope to change notification settings
-- @notification_settings New notification settings for given scope
-- scope = Chat(chat_id)|PrivateChats|GroupChats|AllChats|
local function setNotificationSettings(scope, chat_id, mute_for, show_preview, dl_cb, cmd)
  tdcli_function ({
    ID = "SetNotificationSettings",
    scope_ = {
      ID = 'NotificationSettingsFor' .. scope,
      chat_id_ = chat_id or nil
    },
    notification_settings_ = {
      ID = "NotificationSettings",
      mute_for_ = mute_for,
      sound_ = "default",
      show_preview_ = show_preview
    }
  }, dl_cb, cmd)
end

M.setNotificationSettings = setNotificationSettings

-- Resets all notification settings to the default value.
-- By default the only muted chats are supergroups, sound is set to 'default' and message previews are showed
local function resetAllNotificationSettings(dl_cb, cmd)
  tdcli_function ({
    ID = "ResetAllNotificationSettings"
  }, dl_cb, cmd)
end

M.resetAllNotificationSettings = resetAllNotificationSettings

-- Uploads new profile photo for logged in user.
-- Photo will not change until change will be synchronized with the server.
-- Photo will not be changed if application is killed before it can send request to the server.
-- If something changes, updateUser will be sent
-- @photo_path Path to new profile photo
local function setProfilePhoto(photo_path, dl_cb, cmd)
  tdcli_function ({
    ID = "SetProfilePhoto",
    photo_path_ = photo_path
  }, dl_cb, cmd)
end

M.setProfilePhoto = setProfilePhoto

-- Deletes profile photo.
-- If something changes, updateUser will be sent
-- @profile_photo_id Identifier of profile photo to delete
local function deleteProfilePhoto(profile_photo_id, dl_cb, cmd)
  tdcli_function ({
    ID = "DeleteProfilePhoto",
    profile_photo_id_ = profile_photo_id
  }, dl_cb, cmd)
end

M.deleteProfilePhoto = deleteProfilePhoto

-- Changes first and last names of logged in user.
-- If something changes, updateUser will be sent
-- @first_name New value of user first name, 1-255 characters
-- @last_name New value of optional user last name, 0-255 characters
local function changeName(first_name, last_name, dl_cb, cmd)
  tdcli_function ({
    ID = "ChangeName",
    first_name_ = first_name,
    last_name_ = last_name
  }, dl_cb, cmd)
end

M.changeName = changeName

-- Changes about information of logged in user
-- @about New value of userFull.about, 0-255 characters
local function changeAbout(about, dl_cb, cmd)
  tdcli_function ({
    ID = "ChangeAbout",
    about_ = about
  }, dl_cb, cmd)
end

M.changeAbout = changeAbout

-- Changes username of logged in user.
-- If something changes, updateUser will be sent
-- @username New value of username. Use empty string to remove username
local function changeUsername(username, dl_cb, cmd)
  tdcli_function ({
    ID = "ChangeUsername",
    username_ = username
  }, dl_cb, cmd)
end

M.changeUsername = changeUsername

-- Changes user's phone number and sends authentication code to the new user's phone number.
-- Returns authStateWaitCode with information about sent code on success
-- @phone_number New user's phone number in any reasonable format
-- @allow_flash_call Pass True, if code can be sent via flash call to the specified phone number
-- @is_current_phone_number Pass true, if the phone number is used on the current device. Ignored if allow_flash_call is False
local function changePhoneNumber(phone_number, allow_flash_call, is_current_phone_number, dl_cb, cmd)
  tdcli_function ({
    ID = "ChangePhoneNumber",
    phone_number_ = phone_number,
    allow_flash_call_ = allow_flash_call,
    is_current_phone_number_ = is_current_phone_number
  }, dl_cb, cmd)
end

M.changePhoneNumber = changePhoneNumber

-- Resends authentication code sent to change user's phone number.
-- Works only if in previously received authStateWaitCode next_code_type was not null.
-- Returns authStateWaitCode on success
local function resendChangePhoneNumberCode(dl_cb, cmd)
  tdcli_function ({
    ID = "ResendChangePhoneNumberCode",
  }, dl_cb, cmd)
end

M.resendChangePhoneNumberCode = resendChangePhoneNumberCode

-- Checks authentication code sent to change user's phone number.
-- Returns authStateOk on success
-- @code Verification code from SMS, voice call or flash call
local function checkChangePhoneNumberCode(code, dl_cb, cmd)
  tdcli_function ({
    ID = "CheckChangePhoneNumberCode",
    code_ = code
  }, dl_cb, cmd)
end

M.checkChangePhoneNumberCode = checkChangePhoneNumberCode

-- Returns all active sessions of logged in user
local function getActiveSessions(dl_cb, cmd)
  tdcli_function ({
    ID = "GetActiveSessions",
  }, dl_cb, cmd)
end

M.getActiveSessions = getActiveSessions

-- Terminates another session of logged in user
-- @session_id Session identifier
local function terminateSession(session_id, dl_cb, cmd)
  tdcli_function ({
    ID = "TerminateSession",
    session_id_ = session_id
  }, dl_cb, cmd)
end

M.terminateSession = terminateSession

-- Terminates all other sessions of logged in user
local function terminateAllOtherSessions(dl_cb, cmd)
  tdcli_function ({
    ID = "TerminateAllOtherSessions",
  }, dl_cb, cmd)
end

M.terminateAllOtherSessions = terminateAllOtherSessions

-- Gives or revokes all members of the group editor rights.
-- Needs creator privileges in the group
-- @group_id Identifier of the group
-- @anyone_can_edit New value of anyone_can_edit
local function toggleGroupEditors(group_id, anyone_can_edit, dl_cb, cmd)
  tdcli_function ({
    ID = "ToggleGroupEditors",
    group_id_ = getChatId(group_id).ID,
    anyone_can_edit_ = anyone_can_edit
  }, dl_cb, cmd)
end

M.toggleGroupEditors = toggleGroupEditors

-- Changes username of the channel.
-- Needs creator privileges in the channel
-- @channel_id Identifier of the channel
-- @username New value of username. Use empty string to remove username
local function changeChannelUsername(channel_id, username, dl_cb, cmd)
  tdcli_function ({
    ID = "ChangeChannelUsername",
    channel_id_ = getChatId(channel_id).ID,
    username_ = username
  }, dl_cb, cmd)
end

M.changeChannelUsername = changeChannelUsername

-- Gives or revokes right to invite new members to all current members of the channel.
-- Needs creator privileges in the channel.
-- Available only for supergroups
-- @channel_id Identifier of the channel
-- @anyone_can_invite New value of anyone_can_invite
local function toggleChannelInvites(channel_id, anyone_can_invite, dl_cb, cmd)
  tdcli_function ({
    ID = "ToggleChannelInvites",
    channel_id_ = getChatId(channel_id).ID,
    anyone_can_invite_ = anyone_can_invite
  }, dl_cb, cmd)
end

M.toggleChannelInvites = toggleChannelInvites

-- Enables or disables sender signature on sent messages in the channel.
-- Needs creator privileges in the channel.
-- Not available for supergroups
-- @channel_id Identifier of the channel
-- @sign_messages New value of sign_messages
local function toggleChannelSignMessages(channel_id, sign_messages, dl_cb, cmd)
  tdcli_function ({
    ID = "ToggleChannelSignMessages",
    channel_id_ = getChatId(channel_id).ID,
    sign_messages_ = sign_messages
  }, dl_cb, cmd)
end

M.toggleChannelSignMessages = toggleChannelSignMessages

-- Changes information about the channel.
-- Needs creator privileges in the broadcast channel or editor privileges in the supergroup channel
-- @channel_id Identifier of the channel
-- @about New value of about, 0-255 characters
local function changeChannelAbout(channel_id, about, dl_cb, cmd)
  tdcli_function ({
    ID = "ChangeChannelAbout",
    channel_id_ = getChatId(channel_id).ID,
    about_ = about
  }, dl_cb, cmd)
end

M.changeChannelAbout = changeChannelAbout

-- Pins a message in a supergroup channel chat.
-- Needs editor privileges in the channel
-- @channel_id Identifier of the channel
-- @message_id Identifier of the new pinned message
-- @disable_notification True, if there should be no notification about the pinned message
local function pinChannelMessage(channel_id, message_id, disable_notification, dl_cb, cmd)
  tdcli_function ({
    ID = "PinChannelMessage",
    channel_id_ = getChatId(channel_id).ID,
    message_id_ = message_id,
    disable_notification_ = disable_notification
  }, dl_cb, cmd)
end

M.pinChannelMessage = pinChannelMessage

-- Removes pinned message in the supergroup channel.
-- Needs editor privileges in the channel
-- @channel_id Identifier of the channel
local function unpinChannelMessage(channel_id, dl_cb, cmd)
  tdcli_function ({
    ID = "UnpinChannelMessage",
    channel_id_ = getChatId(channel_id).ID
  }, dl_cb, cmd)
end

M.unpinChannelMessage = unpinChannelMessage

-- Reports some supergroup channel messages from a user as spam messages
-- @channel_id Channel identifier
-- @user_id User identifier
-- @message_ids Identifiers of messages sent in the supergroup by the user, the list should be non-empty
local function reportChannelSpam(channel_id, user_id, message_ids, dl_cb, cmd)
  tdcli_function ({
    ID = "ReportChannelSpam",
    channel_id_ = getChatId(channel_id).ID,
    user_id_ = user_id,
    message_ids_ = message_ids -- vector
  }, dl_cb, cmd)
end

M.reportChannelSpam = reportChannelSpam

-- Returns information about channel members or kicked from channel users.
-- Can be used only if channel_full->can_get_members == true
-- @channel_id Identifier of the channel
-- @filter Kind of channel users to return, defaults to channelMembersRecent
-- @offset Number of channel users to skip
-- @limit Maximum number of users be returned, can't be greater than 200
-- filter = Recent|Administrators|Kicked|Bots
local function getChannelMembers(channel_id, offset, filter, limit, dl_cb, cmd)
  if not limit or limit > 200 then
    limit = 200
  end

  tdcli_function ({
    ID = "GetChannelMembers",
    channel_id_ = getChatId(channel_id).ID,
    filter_ = {
      ID = "ChannelMembers" .. filter
    },
    offset_ = offset,
    limit_ = limit
  }, dl_cb, cmd)
end

M.getChannelMembers = getChannelMembers

-- Deletes channel along with all messages in corresponding chat.
-- Releases channel username and removes all members.
-- Needs creator privileges in the channel.
-- Channels with more than 1000 members can't be deleted
-- @channel_id Identifier of the channel
local function deleteChannel(channel_id, dl_cb, cmd)
  tdcli_function ({
    ID = "DeleteChannel",
    channel_id_ = getChatId(channel_id).ID
  }, dl_cb, cmd)
end

M.deleteChannel = deleteChannel

-- Returns list of created public channels
local function getCreatedPublicChannels(dl_cb, cmd)
  tdcli_function ({
    ID = "GetCreatedPublicChannels"
  }, dl_cb, cmd)
end

M.getCreatedPublicChannels = getCreatedPublicChannels

-- Closes secret chat
-- @secret_chat_id Secret chat identifier
local function closeSecretChat(secret_chat_id, dl_cb, cmd)
  tdcli_function ({
    ID = "CloseSecretChat",
    secret_chat_id_ = secret_chat_id
  }, dl_cb, cmd)
end

M.closeSecretChat = closeSecretChat

-- Returns user that can be contacted to get support
local function getSupportUser(dl_cb, cmd)
  tdcli_function ({
    ID = "GetSupportUser",
  }, dl_cb, cmd)
end

M.getSupportUser = getSupportUser

-- Returns background wallpapers
local function getWallpapers(dl_cb, cmd)
  tdcli_function ({
    ID = "GetWallpapers",
  }, dl_cb, cmd)
end

M.getWallpapers = getWallpapers

-- Registers current used device for receiving push notifications
-- @device_token Device token
-- device_token = apns|gcm|mpns|simplePush|ubuntuPhone|blackberry
local function registerDevice(device_token, token, device_token_set, dl_cb, cmd)
  local dToken = {ID = device_token .. 'DeviceToken', token_ = token}

  if device_token_set then
    dToken = {ID = "DeviceTokenSet", token_ = device_token_set} -- tokens:vector<DeviceToken>
  end

  tdcli_function ({
    ID = "RegisterDevice",
    device_token_ = dToken
  }, dl_cb, cmd)
end

M.registerDevice = registerDevice

-- Returns list of used device tokens
local function getDeviceTokens(dl_cb, cmd)
  tdcli_function ({
    ID = "GetDeviceTokens",
  }, dl_cb, cmd)
end

M.getDeviceTokens = getDeviceTokens

-- Changes privacy settings
-- @key Privacy key
-- @rules New privacy rules
-- @privacyKeyUserStatus Privacy key for managing visibility of the user status
-- @privacyKeyChatInvite Privacy key for managing ability of invitation of the user to chats
-- @privacyRuleAllowAll Rule to allow all users
-- @privacyRuleAllowContacts Rule to allow all user contacts
-- @privacyRuleAllowUsers Rule to allow specified users
-- @user_ids User identifiers
-- @privacyRuleDisallowAll Rule to disallow all users
-- @privacyRuleDisallowContacts Rule to disallow all user contacts
-- @privacyRuleDisallowUsers Rule to disallow all specified users
-- key = UserStatus|ChatInvite
-- rules = AllowAll|AllowContacts|AllowUsers(user_ids)|DisallowAll|DisallowContacts|DisallowUsers(user_ids)
local function setPrivacy(key, rule, allowed_user_ids, disallowed_user_ids, dl_cb, cmd)
  local rules = {[0] = {ID = 'PrivacyRule' .. rule}}

  if allowed_user_ids then
    rules = {
      {
        ID = 'PrivacyRule' .. rule
      },
      [0] = {
        ID = "PrivacyRuleAllowUsers",
        user_ids_ = allowed_user_ids -- vector
      },
    }
  end
  if disallowed_user_ids then
    rules = {
      {
        ID = 'PrivacyRule' .. rule
      },
      [0] = {
        ID = "PrivacyRuleDisallowUsers",
        user_ids_ = disallowed_user_ids -- vector
      },
    }
  end
  if allowed_user_ids and disallowed_user_ids then
    rules = {
      {
        ID = 'PrivacyRule' .. rule
      },
      {
        ID = "PrivacyRuleAllowUsers",
        user_ids_ = allowed_user_ids
      },
      [0] = {
        ID = "PrivacyRuleDisallowUsers",
        user_ids_ = disallowed_user_ids
      },
    }
  end
  tdcli_function ({
    ID = "SetPrivacy",
    key_ = {
      ID = 'PrivacyKey' .. key
    },
    rules_ = {
      ID = "PrivacyRules",
      rules_ = rules
    },
  }, dl_cb, cmd)
end

M.setPrivacy = setPrivacy

-- Returns current privacy settings
-- @key Privacy key
-- key = UserStatus|ChatInvite
local function getPrivacy(key, dl_cb, cmd)
  tdcli_function ({
    ID = "GetPrivacy",
    key_ = {
      ID = "PrivacyKey" .. key
    },
  }, dl_cb, cmd)
end

M.getPrivacy = getPrivacy

-- Returns value of an option by its name.
-- See list of available options on https://core.telegram.org/tdlib/options
-- @name Name of the option
local function getOption(name, dl_cb, cmd)
  tdcli_function ({
    ID = "GetOption",
    name_ = name
  }, dl_cb, cmd)
end

M.getOption = getOption

-- Sets value of an option.
-- See list of available options on https://core.telegram.org/tdlib/options.
-- Only writable options can be set
-- @name Name of the option
-- @value New value of the option
local function setOption(name, option, value, dl_cb, cmd)
  tdcli_function ({
    ID = "SetOption",
    name_ = name,
    value_ = {
      ID = 'Option' .. option,
      value_ = value
    },
  }, dl_cb, cmd)
end

M.setOption = setOption

-- Changes period of inactivity, after which the account of currently logged in user will be automatically deleted
-- @ttl New account TTL
local function changeAccountTtl(days, dl_cb, cmd)
  tdcli_function ({
    ID = "ChangeAccountTtl",
    ttl_ = {
      ID = "AccountTtl",
      days_ = days
    },
  }, dl_cb, cmd)
end

M.changeAccountTtl = changeAccountTtl

-- Returns period of inactivity, after which the account of currently logged in user will be automatically deleted
local function getAccountTtl(dl_cb, cmd)
  tdcli_function ({
    ID = "GetAccountTtl",
  }, dl_cb, cmd)
end

M.getAccountTtl = getAccountTtl

-- Deletes the account of currently logged in user, deleting from the server all information associated with it.
-- Account's phone number can be used to create new account, but only once in two weeks
-- @reason Optional reason of account deletion
local function deleteAccount(reason, dl_cb, cmd)
  tdcli_function ({
    ID = "DeleteAccount",
    reason_ = reason
  }, dl_cb, cmd)
end

M.deleteAccount = deleteAccount

-- Returns current chat report spam state
-- @chat_id Chat identifier
local function getChatReportSpamState(chat_id, dl_cb, cmd)
  tdcli_function ({
    ID = "GetChatReportSpamState",
    chat_id_ = chat_id
  }, dl_cb, cmd)
end

M.getChatReportSpamState = getChatReportSpamState

-- Reports chat as a spam chat or as not a spam chat.
-- Can be used only if ChatReportSpamState.can_report_spam is true.
-- After this request ChatReportSpamState.can_report_spam became false forever
-- @chat_id Chat identifier
-- @is_spam_chat If true, chat will be reported as a spam chat, otherwise it will be marked as not a spam chat
local function changeChatReportSpamState(chat_id, is_spam_chat, dl_cb, cmd)
  tdcli_function ({
    ID = "ChangeChatReportSpamState",
    chat_id_ = chat_id,
    is_spam_chat_ = is_spam_chat
  }, dl_cb, cmd)
end

M.changeChatReportSpamState = changeChatReportSpamState

-- Bots only.
-- Informs server about number of pending bot updates if they aren't processed for a long time
-- @pending_update_count Number of pending updates
-- @error_message Last error's message
local function setBotUpdatesStatus(pending_update_count, error_message, dl_cb, cmd)
  tdcli_function ({
    ID = "SetBotUpdatesStatus",
    pending_update_count_ = pending_update_count,
    error_message_ = error_message
  }, dl_cb, cmd)
end

M.setBotUpdatesStatus = setBotUpdatesStatus

-- Returns Ok after specified amount of the time passed
-- @seconds Number of seconds before that function returns
local function setAlarm(seconds, dl_cb, cmd)
  tdcli_function ({
    ID = "SetAlarm",
    seconds_ = seconds
  }, dl_cb, cmd)
end

M.setAlarm = setAlarm

-- Text message
-- @text Text to send
-- @disable_notification Pass true, to disable notification about the message, doesn't works in secret chats
-- @from_background Pass true, if the message is sent from background
-- @reply_markup Bots only. Markup for replying to message
-- @disable_web_page_preview Pass true to disable rich preview for link in the message text
-- @clear_draft Pass true if chat draft message should be deleted
-- @entities Bold, Italic, Code, Pre, PreCode and TextUrl entities contained in the text. Non-bot users can't use TextUrl entities. Can't be used with non-null parse_mode
-- @parse_mode Text parse mode, nullable. Can't be used along with enitities
local function sendMessage(chat_id, reply_to_message_id, disable_notification, text, disable_web_page_preview, parse_mode)
  local TextParseMode = getParseMode(parse_mode)
  
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = 1,
    reply_markup_ = nil,
    input_message_content_ = {
      ID = "InputMessageText",
      text_ = text,
      disable_web_page_preview_ = disable_web_page_preview,
      clear_draft_ = 0,
      entities_ = {},
      parse_mode_ = TextParseMode,
    },
  }, dl_cb, nil)
end

M.sendMessage = sendMessage

-- Animation message
-- @animation Animation file to send
-- @thumb Animation thumb, if available
-- @width Width of the animation, may be replaced by the server
-- @height Height of the animation, may be replaced by the server
-- @caption Animation caption, 0-200 characters
local function sendAnimation(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, animation, width, height, caption, dl_cb, cmd)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessageAnimation",
      animation_ = getInputFile(animation),
      --thumb_ = {
        --ID = "InputThumb",
        --path_ = path,
        --width_ = width,
        --height_ = height
      --},
      width_ = width or '',
      height_ = height or '',
      caption_ = caption or ''
    },
  }, dl_cb, cmd)
end

M.sendAnimation = sendAnimation

-- Audio message
-- @audio Audio file to send
-- @album_cover_thumb Thumb of the album's cover, if available
-- @duration Duration of audio in seconds, may be replaced by the server
-- @title Title of the audio, 0-64 characters, may be replaced by the server
-- @performer Performer of the audio, 0-64 characters, may be replaced by the server
-- @caption Audio caption, 0-200 characters
local function sendAudio(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, audio, duration, title, performer, caption, dl_cb, cmd)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessageAudio",
      audio_ = getInputFile(audio),
      --album_cover_thumb_ = {
        --ID = "InputThumb",
        --path_ = path,
        --width_ = width,
        --height_ = height
      --},
      duration_ = duration or '',
      title_ = title or '',
      performer_ = performer or '',
      caption_ = caption or ''
    },
  }, dl_cb, cmd)
end

M.sendAudio = sendAudio

-- Document message
-- @document Document to send
-- @thumb Document thumb, if available
-- @caption Document caption, 0-200 characters
local function sendDocument(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, document, caption, dl_cb, cmd)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessageDocument",
      document_ = getInputFile(document),
      --thumb_ = {
        --ID = "InputThumb",
        --path_ = path,
        --width_ = width,
        --height_ = height
      --},
      caption_ = caption
    },
  }, dl_cb, cmd)
end

M.sendDocument = sendDocument

-- Photo message
-- @photo Photo to send
-- @caption Photo caption, 0-200 characters
local function sendPhoto(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, photo, caption, dl_cb, cmd)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessagePhoto",
      photo_ = getInputFile(photo),
      added_sticker_file_ids_ = {},
      width_ = 0,
      height_ = 0,
      caption_ = caption
    },
  }, dl_cb, cmd)
end

M.sendPhoto = sendPhoto

-- Sticker message
-- @sticker Sticker to send
-- @thumb Sticker thumb, if available
local function sendSticker(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, sticker, dl_cb, cmd)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessageSticker",
      sticker_ = getInputFile(sticker),
      --thumb_ = {
        --ID = "InputThumb",
        --path_ = path,
        --width_ = width,
        --height_ = height
      --},
    },
  }, dl_cb, cmd)
end

M.sendSticker = sendSticker

-- Video message
-- @video Video to send
-- @thumb Video thumb, if available
-- @duration Duration of video in seconds
-- @width Video width
-- @height Video height
-- @caption Video caption, 0-200 characters
local function sendVideo(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, video, duration, width, height, caption, dl_cb, cmd)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessageVideo",
      video_ = getInputFile(video),
      --thumb_ = {
        --ID = "InputThumb",
        --path_ = path,
        --width_ = width,
        --height_ = height
      --},
      added_sticker_file_ids_ = {},
      duration_ = duration or '',
      width_ = width or '',
      height_ = height or '',
      caption_ = caption or ''
    },
  }, dl_cb, cmd)
end

M.sendVideo = sendVideo

-- Voice message
-- @voice Voice file to send
-- @duration Duration of voice in seconds
-- @waveform Waveform representation of the voice in 5-bit format
-- @caption Voice caption, 0-200 characters
local function sendVoice(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, voice, duration, waveform, caption, dl_cb, cmd)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessageVoice",
      voice_ = getInputFile(voice),
      duration_ = duration or '',
      waveform_ = waveform or '',
      caption_ = caption or ''
    },
  }, dl_cb, cmd)
end

M.sendVoice = sendVoice

-- Message with location
-- @latitude Latitude of location in degrees as defined by sender
-- @longitude Longitude of location in degrees as defined by sender
local function sendLocation(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, latitude, longitude, dl_cb, cmd)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessageLocation",
      location_ = {
        ID = "Location",
        latitude_ = latitude,
        longitude_ = longitude
      },
    },
  }, dl_cb, cmd)
end

M.sendLocation = sendLocation

-- Message with information about venue
-- @venue Venue to send
-- @latitude Latitude of location in degrees as defined by sender
-- @longitude Longitude of location in degrees as defined by sender
-- @title Venue name as defined by sender
-- @address Venue address as defined by sender
-- @provider Provider of venue database as defined by sender. Only "foursquare" need to be supported currently
-- @id Identifier of the venue in provider database as defined by sender
local function sendVenue(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, latitude, longitude, title, address, id, dl_cb, cmd)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessageVenue",
      venue_ = {
        ID = "Venue",
        location_ = {
          ID = "Location",
          latitude_ = latitude,
          longitude_ = longitude
        },
        title_ = title,
        address_ = address,
        provider_ = 'foursquare',
        id_ = id
      },
    },
  }, dl_cb, cmd)
end

M.sendVenue = sendVenue

-- User contact message
-- @contact Contact to send
-- @phone_number User's phone number
-- @first_name User first name, 1-255 characters
-- @last_name User last name
-- @user_id User identifier if known, 0 otherwise
local function sendContact(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, phone_number, first_name, last_name, user_id, dl_cb, cmd)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessageContact",
      contact_ = {
        ID = "Contact",
        phone_number_ = phone_number,
        first_name_ = first_name,
        last_name_ = last_name,
        user_id_ = user_id
      },
    },
  }, dl_cb, cmd)
end

M.sendContact = sendContact

-- Message with a game
-- @bot_user_id User identifier of a bot owned the game
-- @game_short_name Game short name
local function sendGame(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, bot_user_id, game_short_name, dl_cb, cmd)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessageGame",
      bot_user_id_ = bot_user_id,
      game_short_name_ = game_short_name
    },
  }, dl_cb, cmd)
end

M.sendGame = sendGame

-- Forwarded message
-- @from_chat_id Chat identifier of the message to forward
-- @message_id Identifier of the message to forward
local function sendForwarded(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, from_chat_id, message_id, dl_cb, cmd)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessageForwarded",
      from_chat_id_ = from_chat_id,
      message_id_ = message_id
    },
  }, dl_cb, cmd)
end

M.sendForwarded = sendForwarded

return M
