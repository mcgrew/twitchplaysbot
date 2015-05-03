local socket = require("socket")
local table = require("table")
local io = io
local string = string
local emu = emu

module("irc")
local connection
local host
local port
local channel
local nickname
local password
local messages = {
	ptr = 0, 
	size = -1
}
local connected = false

local ops = {}

function initialize(settings)
	host = settings.host
	port = settings.port
	nickname = settings.nickname
	channel = settings.channel
	password = settings.password
	connection, err = socket.tcp()
	if err ~= nil then
		emu.print(err)
	end
	connection:settimeout(0)
end

function connect()
	if connection == nil then
		connection, err = socket.tcp()
		if err ~= nil then
			emu.print(err)
		end
		connection:settimeout(0)
	end
	connection:connect(host, port)
end

function disconnect()
	if connection ~= nil then
		connection:close()
	end
	connection = nil
end

function read()
	local buffer, err
	local prefix, cmd, param, param1, param2
	local user, userhost
	err = nil
	if connection ~= nil then
		buffer, err = connection:receive("*l")
		if err == nil or err == "timeout" then
			if not connected then
				socket.sleep(1)
				if password ~= nil and password ~= "" then
					send("PASS "..password)
				end
				send("NICK "..nickname)
				send("USER "..nickname.." 0 * :TwitchPlaysBot by mcgrew http://github.com/mcgrew/twitchplaysbot")
				connected = true
			end
		else
      if #buffer > 0 then
        emu.print(buffer)
      end
		end
		if buffer ~= nil then
      if #buffer > 0 then
        emu.print(buffer)
      end
			io.flush()
			if string.sub(buffer,1,4) == "PING" then
				send(string.gsub(buffer,"PING","PONG",1))
			else
				prefix, cmd, param = string.match(buffer, "^:([^ ]+) ([^ ]+)(.*)$")
				if cmd == "376" then
					send("JOIN "..channel)
				end
        if cmd == "353" then
          _parseops(param)
        end
				if param ~= nil then
					param = string.sub(param,2)
					param1, param2 = string.match(param,"^([^:]+) :(.*)$")
					if cmd == "PRIVMSG" then
						user, userhost = string.match(prefix,"^([^!]+)!(.*)$")
						messages.size = messages.size + 1
						messages[messages.size] = {}
						messages[messages.size].nick = user
						messages[messages.size].message = param2
					end
					if cmd == "PART" or cmd == "QUIT" then
						user, userhost = string.match(prefix,"^([^!]+)!(.*)$")
            _removeop(user)
          end
					if cmd == "MODE" then
						user, userhost = string.match(prefix,"^([^!]+)!(.*)$")
            modechange, modeuser = string.match(param, "([+-]o) (.*)")
            if modechange == "+o" then
              _addop(modeuser)
            elseif modechange == "-o" then
              _removeop(modeuser)
            end
          end
				end
			end
		end
	end
	return buffer, err
end

function send(data)
	if connection ~= nil then
		connection:send(data.."\r\n")
		emu.print(data.."\n")
		io.flush()
	end
end

function message()
	local ptr = messages.ptr
	if ptr > messages.size then 
		return nil
	end
	local message = messages[ptr]
	messages[ptr] = nil
	messages.ptr = ptr + 1
	return message
end

function messages_size()
   return messages.size
end

function _parseops(param)
  local nicks = string.match(param, "^.*:(.*)")
  for i=1,#nicks do
    if string.sub(nicks, i, i) == "@" then
      for j=i,#nicks do
        if string.sub(nicks, j, j) == " " then
          table.insert(ops, string.sub(nicks, i+1, j-1))
          break
        end
        if j == #nicks then
          table.insert(ops, string.sub(nicks, i+1))
          break
        end
      end
    end
  end
end

function _addop(nick)
  table.insert(ops, string.lower(nick))
  return true
end

function _removeop(nick)
  local returnvalue = false
  for i=#ops,1,-1 do
    if string.lower(nick) == ops[i] then
      table.remove(ops, i)
      returnvalue = true
    end
  end
  return returnvalue
end

function user_isop(nick)
  for i=1,#ops do
    if nick == ops[i] then
      return true
    end
  end
  return false
end


