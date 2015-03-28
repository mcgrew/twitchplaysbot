
require("irc")
require("settings")
require("controls")

moveframes = 16

function cancel(c)
	if c == nil then
		c = 3
	end
	for j=1,c do
		pressb()
	end
end

function movedown(c)
	if c == nil or c < 1 then 
		c = 1
	end
	pressdown()
	input = {}
	input.down = true
	for j=1,c do
		for i=1,moveframes do
			joypad.set(1, input)
			emu.frameadvance()
		end
		for i=1,16 do
			joypad.set(1, {})
			emu.frameadvance()
		end
	end
end

function moveup(c)
	if c == nil or c < 1 then 
		c = 1
	end
	pressup()
	input = {}
	input.up = true
	for j=1,c do
		for i=1,moveframes do
			joypad.set(1, input)
			emu.frameadvance()
		end
		for i=1,16 do
			joypad.set(1, {})
			emu.frameadvance()
		end
	end
end

function moveleft(c)
	if c == nil or c < 1 then 
		c = 1
	end
	pressleft()
	input = {}
	input.left = true
	for j=1,c do
		for i=1,moveframes do
			joypad.set(1, input)
			emu.frameadvance()
		end
		for i=1,16 do
			joypad.set(1, {})
			emu.frameadvance()
		end
	end
end

function moveright(c)
	if c == nil or c < 1 then 
		c = 1
	end
	pressright()
	input = {}
	input.right = true
	for j=1,c do
		for i=1,moveframes do
			joypad.set(1, input)
			emu.frameadvance()
		end
		for i=1,16 do
			joypad.set(1, {})
			emu.frameadvance()
		end
	end
end

function talk() 
	cancel()
	pressa(2)
	wait(30)
	pressa(2)
end

function status() 
	cancel()
	pressa(2)
	wait(30)
	pressdown()
	pressa(2)
end


function stairs() 
	cancel()
	pressa(2)
	wait(30)
	pressdown()
	pressdown()
	pressa(2)
end


function search() 
	cancel()
	pressa(2)
	wait(30)
	pressdown()
	pressdown()
	pressdown()
	pressa(2)
end


function spell(c) 
	cancel(5)
	pressa(2)
	wait(30)
	pressright()
	pressa(2)
	wait(30)
	if c ~= nil then
		for j=1,c-1 do
			pressdown()
		end
		pressa(2)
	end
end


function item(c) 
	cancel(5)
	pressa(2)
	wait(30)
	pressdown()
	pressright()
	pressa(2)
	wait(30)
	if c ~= nil then
		for j=1,c-1 do
			pressdown()
		end
		pressa(2)
	end
end


function door() 
	cancel(5)
	pressa(2)
	wait(30)
	pressdown()
	pressdown()
	pressright()
	pressa(2)
end


function take() 
	cancel()
	pressa(2)
	wait(30)
	pressdown()
	pressdown()
	pressdown()
	pressright()
	pressa(2)
end

function fight() 
	cancel()
	wait(30)
	pressa(2)
end

function run() 
	cancel()
	wait(30)
	pressdown()
	pressa(2)
end

function commandlist()
	say("General Commands:")
	say("up#, down#, left#, right#, a, b, select, start")
	say("Overworld Commands:")
	say("talk, status, stairs, search, spell#, item#, door, take")
	say("Battle Commands:")
	say("fight, run, spell#, item#")
	say("Menu Commands:")
	say("pup, pdown, pleft, pright")
end

function say(str) 
	irc.send(string.format("PRIVMSG %s :%s", irc.settings.channel, str))
end

irc.initialize(irc.settings)
irc.connect()

while(true) do
    irc.read()
    if irc.messages_size() > 0 then
		msg = irc.message()
		if msg ~= nil then
			command = string.lower(msg.message)
				c = tonumber(string.sub(command, -2))
				if c == nil then
					c = tonumber(string.sub(command, -1))
				end
				if string.sub(command, 1, 2) == "up" then
					moveup(c)
				elseif string.sub(command, 1, 4) == "down" then
					movedown(c)
				elseif string.sub(command, 1, 4) == "left" then
					moveleft(c)
				elseif string.sub(command, 1, 5) == "right" then
					moveright(c)
				elseif string.sub(command, 1, 3) == "pup" then
					pressup()
				elseif string.sub(command, 1, 5) == "pdown" then
					pressdown()
				elseif string.sub(command, 1, 5) == "pleft" then
					pressleft()
				elseif string.sub(command, 1, 6) == "pright" then
					pressright()
				elseif string.sub(command, 1, 1) == "a" then
					pressa(2)
				elseif string.sub(command, 1, 1) == "b" then
					pressb()
				elseif string.sub(command, 1, 5) == "start" then
					pressselect()
				elseif string.sub(command, 1, 6) == "select" then
					pressstart()
				elseif string.sub(command, 1, 4) == "talk" then
					talk()
				elseif string.sub(command, 1, 6) == "status" then
					status()
				elseif string.sub(command, 1, 6) == "stairs" then
					stairs()
				elseif string.sub(command, 1, 6) == "search" then
					search()
				elseif string.sub(command, 1, 5) == "spell" then
					spell()
				elseif string.sub(command, 1, 4) == "item" then
					item(c)
				elseif string.sub(command, 1, 4) == "door" then
					door()
				elseif string.sub(command, 1, 4) == "take" then
					take()
				elseif string.sub(command, 1, 5) == "fight" then
					fight()
				elseif string.sub(command, 1, 3) == "run" then
					run()
				elseif string.sub(command, 1, 8) == "!command" then
					commandlist()
				elseif string.sub(command, 1, 5) == "!help" then
					commandlist()
				else
				end
		end
	end
	emu.frameadvance()
end


