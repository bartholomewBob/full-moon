local player = game:GetService('Players').LocalPlayer

label = nil
hop_label = nil

if player.PlayerGui:FindFirstChild('Injected') then
	player.PlayerGui:FindFirstChild('Injected'):Destroy()
end

local screen = Instance.new('ScreenGui')
screen.Name = 'Injected'
screen.Parent = player.PlayerGui
label = Instance.new('TextLabel')
label.Parent = screen
label.TextSize = 14
label.TextColor3 = Color3.new(1, 0, 0)
label.Position = UDim2.new(0, 650, 0, -40)	
label.Size = UDim2.new(0, 200, 0, 100)
hop_label = Instance.new('TextLabel')
hop_label.Parent = screen
hop_label.TextSize = 14
hop_label.Text = 'Not Hopping'
hop_label.TextColor3 = Color3.new(1, 0, 0)
hop_label.Position = UDim2.new(0, 650, 0, 60)	
hop_label.Size = UDim2.new(0, 200, 0, 40)



-- Get player character
function get_character()
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	return character
end

-- Tween to part 
function tween_to(part) 
	local character
	pcall(function() character = get_character() end)
	if character == nil then
		print('TWEEN: Failed to find character')	
		return	
	end		
	
	local dist = (part.Position - character.HumanoidRootPart.Position).Magnitude
	local speed = 0

	if dist < 150 then
		speed = 20000
	elseif dist < 200 then
		speed = 5000
	elseif dist < 300 then
		speed = 1030
	elseif dist < 500 then
		speed = 725
	elseif dist < 1000 then
		speed = 365
	elseif dist >= 1000 then
		speed = 365
	end

	game:GetService("TweenService"):Create(
		character.HumanoidRootPart,
		TweenInfo.new(dist/speed, Enum.EasingStyle.Linear),
		{CFrame = part.CFrame}
	):Play()

	wait(dist/speed)
end

function hop() 
	local remote = game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser", 9e9)
	local result = remote:InvokeServer(unpack({ [1] = 1 }))		
	for uuid, value in pairs(result) do		
		if value['Count'] <= 8 then			
			remote:InvokeServer(unpack({
				[1] = "teleport";
				[2] = uuid
			}))
		end		
	end	
end
function start_hop()
	local hop_time = 15
	while hop_time >= 0 do
		hop_label.Text = 'Hopping in ' .. tostring(hop_time) .. 's...'
		hop_time -= 1
		wait(1)		
	end
	hop()
end

-- Attempt to find for 5s
local attempt_time = 5
local attempts = 0
local wait_time = 0.1 

local found = false

while attempts <= (1/wait_time * attempt_time) do
    if game:GetService('Workspace').NPCs:FindFirstChild('Barista Cousin') then
        found = true

        label.TextColor3 = Color3.new(0, 1, 0)	
        label.Text = 'Found Barista ('..tostring(attempts)..'/'..tostring(1/wait_time * attempt_time)..')'

		local target = game:GetService('Workspace').NPCs['Barista Cousin']

        print(target.Position)
        tween_to(target)

		-- print('Found: ' .. target.Name)
	
		-- local position = game.Workspace.CurrentCamera:WorldToScreenPoint(target.Position)
		-- local udim = UDim2.new(0, position.X, 0, position.Y)
		
		-- local label = player.PlayerGui.Injected.TextLabel	
		-- label.Position = udim
        break
	end
        
    label.Text = 'Finding Barista... ('..tostring(attempts)..'/'..tostring(1/wait_time * attempt_time)..')'
    wait(wait_time)
    attempts += 1
end

if not found then
    label.Text = 'Failed to find Barista'
    start_hop()
end


print(game:GetService('Workspace').NPCs:FindFirstChild('Barista Cousin').ClassName)
