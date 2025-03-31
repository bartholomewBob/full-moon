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
function hop() 
	local remote = game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser", 9e9)
	local result = remote:InvokeServer(unpack({ [1] = 1 }))		

	local uuids = {}
	for uuid, value in pairs(result) do		
		if value['Count'] <= 8 then			
			table.insert(uuids, uuid)
		end		
	end	
	print(#uuids)
	local main_uuid = uuids[math.random(1, #uuids)]
	print(main_uuid)
	remote:InvokeServer(unpack({
		[1] = "teleport";
		[2] = main_uuid 
	}))
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

local phases = {
	["http://www.roblox.com/asset/?id=9709149431"] = '8', 
	["http://www.roblox.com/asset/?id=9709149052"] = '7',
	["http://www.roblox.com/asset/?id=9709143733"] = '6',
	["http://www.roblox.com/asset/?id=9709150401"] = '5',
	["http://www.roblox.com/asset/?id=9709135895"] = '4',
	["http://www.roblox.com/asset/?id=9709139597"] = '3',
	["http://www.roblox.com/asset/?id=9709150086"] = '2',
	["http://www.roblox.com/asset/?id=9709149680"] = '1',
};


if game:GetService("Lighting"):FindFirstChild('Sky') then
	print('Found moon texture')
	local texture = game:GetService("Lighting").Sky.MoonTextureId
	local phase = phases[texture]
	print(phase)	
	
	label.Text= 'Current phase ' .. tostring(phase) .. '\nwith percent ' .. tostring(phase / 8 * 100) .. '%'
	
	if phase == '8' then	
		label.TextColor3 = Color3.new(0, 1, 0)	
	else 		
		start_hop()
	end	
else
	print('Failed to find moon texture')
	label.Text= 'Failed to find moon'
	start_hop()
end
