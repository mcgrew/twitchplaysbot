-- Wait the specified number of frames
--
-- @param frames The number of frames to wait
function wait(frames)
	for j=1,frames do
		emu.frameadvance()
	end
end

-- Press A for the specified number of frames. The button will then be released
-- for 5 frames.
--
-- @param frames The number of frames to hold the button
function pressa(frames)
	if frames == nil then
		frames = 5
	end
	input = {}
	input.A = true
	for i=1,frames do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

-- Press B for the specified number of frames. The button will then be released
-- for 5 frames.
--
-- @param frames The number of frames to hold the button
function pressb(frames)
	if frames == nil then
		frames = 5
	end
	input = {}
	input.B = true
	for i=1,frames do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

-- Press SELECT for the specified number of frames. The button will then be 
-- released for 5 frames.
--
-- @param frames The number of frames to hold the button
function pressselect(frames)
	if frames == nil then
		frames = 5
	end
	input = {}
	input.select = true
	for i=1,frames do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

-- Press START for the specified number of frames. The button will then be
--  released for 5 frames.
--
-- @param frames The number of frames to hold the button
function pressstart(frames)
	if frames == nil then
		frames = 5
	end
	input = {}
	input.select = true
	for i=1,frames do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

-- Press DOWN for the specified number of frames. The button will then be
--  released for 5 frames.
--
-- @param frames The number of frames to hold the button
function pressdown(frames)
	if frames == nil then
		frames = 5
	end
	input = {}
	input.down = true
	for i=1,frames do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

-- Press UP for the specified number of frames. The button will then be
--  released for 5 frames.
--
-- @param frames The number of frames to hold the button
function pressup(frames)
	if frames == nil then
		frames = 5
	end
	input = {}
	input.up = true
	for i=1,frames do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

-- Press LEFT for the specified number of frames. The button will then be
--  released for 5 frames.
--
-- @param frames The number of frames to hold the button
function pressleft(frames)
	if frames == nil then
		frames = 5
	end
	input = {}
	input.left = true
	for i=1,frames do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

-- Press RIGHT for the specified number of frames. The button will then be
--  released for 5 frames.
--
-- @param frames The number of frames to hold the button
function pressright(frames)
	if frames == nil then
		frames = 5
	end
	input = {}
	input.right = true
	for i=1,frames do
		joypad.set(1, input)
		emu.frameadvance()
	end
	for i=1,5 do
		joypad.set(1, {})
		emu.frameadvance()
	end
end

