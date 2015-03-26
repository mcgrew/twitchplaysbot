
function wait(c)
	for j=1,c do
		emu.frameadvance()
	end
end

function pressa()
	input = {}
	input.A = true
	for i=1,2 do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

function pressb()
	input = {}
	input.B = true
	for i=1,5 do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

function pressselect()
	input = {}
	input.select = true
	for i=1,5 do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

function pressstart()
	input = {}
	input.select = true
	for i=1,5 do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

function pressdown()
	input = {}
	input.down = true
	for i=1,5 do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

function pressup()
	input = {}
	input.up = true
	for i=1,5 do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

function pressleft()
	input = {}
	input.left = true
	for i=1,5 do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

function pressright()
	input = {}
	input.right = true
	for i=1,5 do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

