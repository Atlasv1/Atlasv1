local DiscordLib = loadstring(game:HttpGet "https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt")()
local NotifyLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))()
local Notify = NotifyLibrary.Notify
local win = DiscordLib:Window("hacks-de memoutro")
local serv = win:Server("clan de mamasita xd", "")
local Home = serv:Channel("Home")
Home:Label("Press (V) to Open/Close ggxhub")
Home:Label("mady by creator ggluis")

local function PushAura()
    if _G.PushAura == true then
      if game.Players.LocalPlayer.Backpack:FindFirstChild("Push") then
         game.Players.LocalPlayer.Backpack.Push.Parent = game.Players.LocalPlayer.Character
    end
        while wait() do
            if _G.PushAura == true then
                pcall(
                    function()
                        for i, v in pairs(game.Players:GetPlayers()) do
                            if v.Name == game.Players.LocalPlayer.Name then
                            else
                                local args = {
                                    [1] = game:GetService("Players")[v.Name].Character
                                }

                                game:GetService("Players").LocalPlayer.Character.Push.PushTool:FireServer(unpack(args))
                            end
                        end
                    end
                )
            end
        end
    else 
        _G.PushAura = false
        while wait() do
            if _G.PushAura == true then
                pcall(
                    function()
                        for i, v in pairs(game.Players:GetPlayers()) do
                            if v.Name == game.Players.LocalPlayer.Name then
                            else
                                local args = {
                                    [1] = game:GetService("Players")[v.Name].Character
                                }

                                game:GetService("Players").LocalPlayer.Character.Push.PushTool:FireServer(unpack(args))
                            end
                        end
                    end
                )
            end
        end
    end
end

local player = serv:Channel("Ragdoll Engine")

player:Toggle(
    "Push Aura",
    false,
function(t)
    _G.PushAura = t
    PushAura()
end
)


player:Toggle(
    "Anti Ragdoll",
    false,
function(state)
if state then
if  game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
                local stop = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
                stop.MaxForce = Vector3.new(0,0,0)
            end
            if game.Players.LocalPlayer.Character:FindFirstChild("Falling down") then
                local Fallingdown = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Falling down")
                Fallingdown.Disabled = true
            end
            if game.Players.LocalPlayer.Character:FindFirstChild("Pushed") then
                local Pushed = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Pushed")
                Pushed.Disabled = true
            end
            if game.Players.LocalPlayer.Character:FindFirstChild("RagdollMe") then
                local RagdollMe = game:GetService("Players").LocalPlayer.Character:FindFirstChild("RagdollMe")
                RagdollMe.Disabled = true 
            end
            if game.Players.LocalPlayer.Character:FindFirstChild("Swimming") then
                local Swimming = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Swimming")
                Swimming.Disabled = true
            end
            if game.Players.LocalPlayer.Character:FindFirstChild("KillSript") then
                local KillScript = game:GetService("Players").LocalPlayer.Character:FindFirstChild("KillScript")
                KillScript.Disabled = true
            end
            if game.Players.LocalPlayer.Character:FindFirstChild("StartRagdoll") then
                local StartRagdoll = game:GetService("Players").LocalPlayer.Character:FindFirstChild("StartRagdoll")
                StartRagdoll.Disabled = true
            end
        end
elseif not state then
 if  game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.BodyVelocity:Remove()
            end     
            if game.Players.LocalPlayer.Character:FindFirstChild("Falling down") then
                local Fallingdown = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Falling down")
                Fallingdown.Disabled = false
            end
            if game.Players.LocalPlayer.Character:FindFirstChild("Pushed") then
                local Pushed = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Pushed")
                Pushed.Disabled = false
            end
            if game.Players.LocalPlayer.Character:FindFirstChild("RagdollMe") then
                local RagdollMe = game:GetService("Players").LocalPlayer.Character:FindFirstChild("RagdollMe")
                RagdollMe.Disabled = false 
            end
            if game.Players.LocalPlayer.Character:FindFirstChild("Swimming") then
                local Swimming = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Swimming")
                Swimming.Disabled = false
            end
            if game.Players.LocalPlayer.Character:FindFirstChild("KillSript") then
                local KillScript = game:GetService("Players").LocalPlayer.Character:FindFirstChild("KillScript")
                KillScript.Disabled = false
            end
            if game.Players.LocalPlayer.Character:FindFirstChild("StartRagdoll") then
                local StartRagdoll = game:GetService("Players").LocalPlayer.Character:FindFirstChild("StartRagdoll")
                StartRagdoll.Disabled = false
end
end
end
)


player:Toggle(
    "Fake Lag",
    false,
function(state)
if state then
Uptime = .1
Downtime = .5

        PLR = game.Players.LocalPlayer.Character.HumanoidRootPart
        _G.Toggle = true
        
        while _G.Toggle do
            task.wait()
            PLR.Anchored = true
            wait(Downtime)
            PLR.Anchored = false
            wait(Uptime)
end
elseif not state then
Uptime = .1
Downtime = .5

        PLR = game.Players.LocalPlayer.Character.HumanoidRootPart
        _G.Toggle = false
        
        while _G.Toggle do
            task.wait()
            PLR.Anchored = true
            wait(Downtime)
            PLR.Anchored = false
            wait(Uptime)
end
end
end
)

player:Toggle(
    "No-Clip",
    false,
    function(state)
if state then
_G.noclip = true
local Loop  game:GetService('RunService').Stepped:connect(function()
            if _G.noclip then
                for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        pcall(function()
                        if v.CanCollide ~= not _G.noclip then
                            v.CanCollide = not _G.noclip
                        end
                        end)
                    end
                end
            end
end)
elseif not state then
_G.noclip = false -- toggle to true to enable
local Loop  game:GetService('RunService').Stepped:connect(function()
            if _G.noclip then
                for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        if v.CanCollide ~= not _G.noclip then
                            v.CanCollide = not _G.noclip
                        end
                    end
                end
            end
end)
end
end)


player:Button(
    "Potion Fling",
    function()
    if game.Players.LocalPlayer.Character:FindFirstChild("potion") then
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        local tool = game.Players.LocalPlayer.Character:FindFirstChild("potion")
        humanoid:EquipTool(tool)
        if game.Players.LocalPlayer.Character:FindFirstChild("potion") then
            if game.Players.LocalPlayer.Character.potion:FindFirstChild("Cap") then
                game.Players.LocalPlayer.Character.potion.Cap:Remove()
            end
        end
        if game.Players.LocalPlayer.Character:FindFirstChild("potion") then
            if game.Players.LocalPlayer.Character.potion:FindFirstChild("Script") then 
                game.Players.LocalPlayer.Character.potion.Script:Remove()
            end     
        end
        if game.Players.LocalPlayer.Character:FindFirstChild("potion") then
            if game.Players.LocalPlayer.Character:FindFirstChild("InSide") then
                game.Players.LocalPlayer.Character.potion.InSide:Remove()
                Clipped = true
                function Noclip()
                    Clipped = false
                    function Noclipped()
                        if Clip == false and game:GetService("Players").LocalPlayer.Character ~= nil then
                            for _, child in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                                if child:IsA("BasePart") and child.CanCollide == true then
                                    child.CanCollide = false
                                end
                            end
                        end
                    end
                    Noclipping = game:GetService('RunService').Stepped:connect(Noclipped)
                end


                local tool = game:GetService("Players").LocalPlayer.Character:WaitForChild("potion")

                if tool then
                    tool.Parent = game:GetService("Players").LocalPlayer.Character
                    tool.Handle.Massless = true
                    RestoreCFling = {
                        Grip = tool.GripPos;
                    }
                    tool.GripPos = Vector3.new(5000, 5000, 5000)
                    Noclip()
                    Noclipping:Disconnect()
                    local Player = game:service('Players').LocalPlayer
                    Player.Character['potion'].Parent = Player.Character
                end
            end
            local humanoid = game.Players.LocalPlayer.Character.Humanoid
            if game.Players.LocalPlayer.Character.potion:FindFirstChild("Cap") then
                game.Players.LocalPlayer.Character.potion.Cap:Remove()
            end
            if game.Players.LocalPlayer.Character.potion:FindFirstChild("Script") then 
                game.Players.LocalPlayer.Character.potion.Script:Remove()       
            end
            if game.Players.LocalPlayer.Character.potion:FindFirstChild("InSide") then
                game.Players.LocalPlayer.Character.potion.InSide:Remove()
                Clipped = true
                function Noclip()
                    Clipped = false
                    function Noclipped()
                        if Clip == false and game:GetService("Players").LocalPlayer.Character ~= nil then
                            for _, child in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                                if child:IsA("BasePart") and child.CanCollide == true then
                                    child.CanCollide = false
                                end
                            end
                        end
                    end
                    Noclipping = game:GetService('RunService').Stepped:connect(Noclipped)
                end


                local tool = game:GetService("Players").LocalPlayer.Character:WaitForChild("potion")

                if tool then
                    tool.Parent = game:GetService("Players").LocalPlayer.Character
                    tool.Handle.Massless = true
                    RestoreCFling = {
                        Grip = tool.GripPos;
                    }
                    tool.GripPos = Vector3.new(5000, 5000, 5000)
                    wait()
                    Noclip()
                    wait()
                    Noclipping:Disconnect()
                end
            end
        end
    end
    local humanoid = game.Players.LocalPlayer.Character.Humanoid
    if game.Players.LocalPlayer.Character:FindFirstChild("potion") then
        local tool = game.Players.LocalPlayer.Character.potion 
        humanoid:EquipTool(tool)
    end
    if game.Players.LocalPlayer.Backpack:FindFirstChild("potion") then
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("potion")
        humanoid:EquipTool(tool)
        if game.Players.LocalPlayer.Character:FindFirstChild("potion") then
            if game.Players.LocalPlayer.Character.potion:FindFirstChild("Cap") then
                game.Players.LocalPlayer.Character.potion.Cap:Remove()
            end
        end
        if game.Players.LocalPlayer.Character:FindFirstChild("potion") then
            if game.Players.LocalPlayer.Character.potion:FindFirstChild("Script") then 
                game.Players.LocalPlayer.Character.potion.Script:Remove()
            end     
        end
        if game.Players.LocalPlayer.Character:FindFirstChild("potion") then
            if game.Players.LocalPlayer.Character:FindFirstChild("InSide") then
                game.Players.LocalPlayer.Character.potion.InSide:Remove()
                Clipped = true
                function Noclip()
                    Clipped = false
                    function Noclipped()
                        if Clip == false and game:GetService("Players").LocalPlayer.Character ~= nil then
                            for _, child in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                                if child:IsA("BasePart") and child.CanCollide == true then
                                    child.CanCollide = false
                                end
                            end
                        end
                    end
                    Noclipping = game:GetService('RunService').Stepped:connect(Noclipped)
                end


                local tool = game:GetService("Players").LocalPlayer.Character:WaitForChild("potion")

                if tool then
                    tool.Parent = game:GetService("Players").LocalPlayer.Backpack
                    tool.Handle.Massless = true
                    RestoreCFling = {
                        Grip = tool.GripPos;
                    }
                    tool.GripPos = Vector3.new(5000, 5000, 5000)
                    Noclip()
                    Noclipping:Disconnect()
                    local Player = game:service('Players').LocalPlayer
                    Player.Backpack['potion'].Parent = Player.Character
                end
            end
            local humanoid = game.Players.LocalPlayer.Character.Humanoid
            if game.Players.LocalPlayer.Character.potion:FindFirstChild("Cap") then
                game.Players.LocalPlayer.Character.potion.Cap:Remove()
            end
            if game.Players.LocalPlayer.Character.potion:FindFirstChild("Script") then 
                game.Players.LocalPlayer.Character.potion.Script:Remove()       
            end
            if game.Players.LocalPlayer.Character.potion:FindFirstChild("InSide") then
                game.Players.LocalPlayer.Character.potion.InSide:Remove()
                Clipped = true
                function Noclip()
                    Clipped = false
                    function Noclipped()
                        if Clip == false and game:GetService("Players").LocalPlayer.Character ~= nil then
                            for _, child in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                                if child:IsA("BasePart") and child.CanCollide == true then
                                    child.CanCollide = false
                                end
                            end
                        end
                    end
                    Noclipping = game:GetService('RunService').Stepped:connect(Noclipped)
                end


                local tool = game:GetService("Players").LocalPlayer.Character:WaitForChild("potion")

                if tool then
                    tool.Parent = game:GetService("Players").LocalPlayer.Backpack
                    tool.Handle.Massless = true
                    RestoreCFling = {
                        Grip = tool.GripPos;
                    }
                    tool.GripPos = Vector3.new(5000, 5000, 5000)
                    wait()
                    Noclip()
                    wait()
                    Noclipping:Disconnect()
                end
            end
        end
    end
    local humanoid = game.Players.LocalPlayer.Character.Humanoid
    if game.Players.LocalPlayer.Backpack:FindFirstChild("potion") then
        local tool = game.Players.LocalPlayer.Backpack.potion 
        humanoid:EquipTool(tool)
    end 
	end
)

player:Button(
    "Anti Fling (no fling users)",
    function()
local RunService = game:GetService("RunService")
local players = game:GetService("Players")
local plr = players.LocalPlayer

RunService.Stepped:Connect(function()
    for i, CoPlayer in pairs(players:GetChildren()) do
        if CoPlayer ~= plr and CoPlayer.Character then
            for i,part in pairs(CoPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") or part:IsA("Part") or part.Name == "HumanoidRootPart" then
                    part.CanCollide = false
                elseif part:IsA("Accessory") and part:FindFirstChildOfClass("MeshPart") then
                    part:FindFirstChildOfClass("MeshPart").CanCollide = false
                end
            end
        end
    end
end)
end)

player:Button(
    "headless (no lo ven los demas)",
    function()
    game.Players.LocalPlayer.Character.Head.Transparency = 1
        game.Players.LocalPlayer.Character.Head.face:Remove()
    end
)

player:Button(
    "korblox (no lo ven los demas)",
    function()
    local ply = game.Players.LocalPlayer
		local chr = ply.Character
		chr.RightLowerLeg.MeshId = "902942093"
		chr.RightLowerLeg.Transparency = "1"
		chr.RightUpperLeg.MeshId = "http://www.roblox.com/asset/?id=902942096"
		chr.RightUpperLeg.TextureID = "http://roblox.com/asset/?id=902843398"
		chr.RightFoot.MeshId = "902942089"
		chr.RightFoot.Transparency = "1"
	end
)

player:Button(
	"Trash Talk",
	function()
		function dowait()
			wait(0.172)
		end
		local tbl_main = 
		{
			  "EZZZZZZZZZZ🤣🙏🏻🤣🙏🏻🤣🙏🏻🤣🙏🏻🤣🙏🏻" , 
			  "All"
		}
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(tbl_main))
		dowait()
		local tbl_main = 
		{
			  "GGXHUB" , 
			  "All"
		}
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(tbl_main))
		dowait()
		local tbl_main = 
		{
			  "anda a dormir marginad@." , 
			  "All"
		}
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(tbl_main))
		dowait()
		local tbl_main = 
		{
			  "Clip?" , 
			  "All"
		}
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(tbl_main))
		dowait()
		local tbl_main = 
		{
			  "mongolito. 🤡" , 
			  "All"
		}
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(tbl_main))
	end
)

local TargetT = serv:Channel("Target")


TargetT:Textbox(
    "Target",
    "Type you're target here and press enter!",
    true,
    function(target) -- // this function finds the target!
        for i,v in pairs(game.Players:GetChildren()) do
            if v.Name ~= game.Players.LocalPlayer.Name then
                if string.sub(string.lower(v.Name),1,string.len(target)) == string.lower(target) or string.sub(string.lower(v.DisplayName),1,string.len(target)) == string.lower(target)  then
					NotifyLibrary.Notify({
						Title = "Target Found!",
						Description = "Player: "..v.Name.." / "..v.DisplayName,
						Duration = 2
					})
                    Target = v
                    TargetV = v.Name
                    return
                end
            end
        end
		NotifyLibrary.Notify({
			Title = "ERROR",
			Description = "No target found.",
			Duration = 2
		})
    end
)

player = game.Players.LocalPlayer
        local Loop
        local OldFlingPos = player.Character.HumanoidRootPart.Position
        local loopFunction = function()
            local success,err = pcall(function()
                local FlingEnemy = game.Players:FindFirstChild(TargetV).Character
                if FlingEnemy and player.Character then
                    FlingTorso = FlingEnemy.UpperTorso
                    local dis = 3.85
                    local increase = 6
                    if FlingEnemy.Humanoid.MoveDirection.X < 0 then
                        xchange = -increase
                    elseif FlingEnemy.Humanoid.MoveDirection.X > 0  then
                        xchange = increase
                    else
                        xchange = 0
                    end
                    if FlingEnemy.Humanoid.MoveDirection.Z < 0 then
                        zchange = -increase
                    elseif FlingEnemy.Humanoid.MoveDirection.Z > 0 then
                        zchange = increase
                    else
                        zchange = 0
                    end          
                    if player.Character then
                        player.Character:FindFirstChildWhichIsA('Humanoid'):ChangeState(11)
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(FlingTorso.Position.X + math.random(-dis,dis) + xchange, FlingTorso.Position.Y, FlingTorso.Position.Z + math.random(-dis,dis) + zchange) * CFrame.Angles(math.rad(player.Character.HumanoidRootPart.Orientation.X + 350),math.rad(player.Character.HumanoidRootPart.Orientation.Y + 200),math.rad(player.Character.HumanoidRootPart.Orientation.Z + 240))
                        player.Character.HumanoidRootPart.Velocity = Vector3.new(500000,500000,500000)
                    end
                end
            end)
            if err then
            end
        end;
        local Start = function()    
            OldFlingPos = player.Character.HumanoidRootPart.Position
            Loop = game:GetService("RunService").Heartbeat:Connect(loopFunction);
        end;
        local Pause = function()
            Loop:Disconnect()
            local vectorZero = Vector3.new(0, 0, 0)
            player.Character.PrimaryPart.Velocity = vectorZero
            player.Character.PrimaryPart.RotVelocity = vectorZero
            player.Character.HumanoidRootPart.CFrame = CFrame.new(OldFlingPos) * CFrame.Angles(math.rad(0),math.rad(137.92),math.rad(0))
        end;

TargetT:Toggle("Fling", false, function(bool)
	if bool == true then
		Start()
	elseif bool == false then
		Pause()
	end
end)		

_G.RocketLock = false
game:GetService"RunService".RenderStepped:Connect(function()
	if _G.RocketLock == true then
		if game.Workspace.Ignored:FindFirstChild("Launcher")then
			local lol = game.Workspace.Ignored:FindFirstChild("Launcher")
			if lol:FindFirstChildOfClass("BodyVelocity") then
				wait()
				lol.BodyVelocity:Destroy()
			end

			if lol:FindFirstChild("BodyVelocity") == nil then
				lol.CFrame = CFrame.new(workspace.Players[TargetV].Head.CFrame.X,workspace.Players[TargetV].Head.CFrame.Y+6,workspace.Players[TargetV].Head.CFrame.Z)
			end

		elseif game.Workspace.Ignored:FindFirstChild("Handle")then
			local lol = game.Workspace.Ignored:FindFirstChild("Handle")

			if lol:FindFirstChild("Pin") then
				lol.CFrame = CFrame.new(workspace.Players[TargetV].Head.CFrame.X,workspace.Players[TargetV].Head.CFrame.Y+1,workspace.Players[TargetV].Head.CFrame.Z)
			end
		end
	end
end)

TargetT:Toggle(
	"View",
	false,
	function(viewing)

if viewing == true then
	local TargetPlr = TargetV
	game.Workspace.Camera.CameraSubject = game.Players[TargetPlr].Character.Humanoid
elseif viewing == false then
	game.Workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
end
end
)

TargetT:Toggle(
    "Focus Push",
    false,
function(state)
if state then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local bool = Instance.new("BoolValue",game.InsertService)
            bool.Name = "valor"
            if game.Players.LocalPlayer.Backpack:FindFirstChild("Push") then
                game.Players.LocalPlayer.Backpack.Push.Parent = game.Players.LocalPlayer.Character
            end
    if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Character = game.Players.LocalPlayer.Character.HumanoidRootPart
            while wait() do
                if game.InsertService:FindFirstChild("valor") then
                    Character.CFrame = game.Players:FindFirstChild(TargetV).Character.HumanoidRootPart.CFrame
                    pcall(
                        function()
                            for i, v in pairs(game.Players:GetPlayers()) do
                                if v.Name == game.Players.LocalPlayer.Name then
                                else
                                    local args = {
                                        [1] = game:GetService("Players")[v.Name].Character
                                    }

                                    game:GetService("Players").LocalPlayer.Character.Push.PushTool:FireServer(unpack(args))
                                end
                            end
                        end
                    )
                end
            end
     end
end
elseif not state then
    if game.InsertService:FindFirstChild("valor") then
        game.InsertService.valor:Remove()
    end 
end
end
)

TargetT:Button(
    "Teleport",
    function()
        local TargetPlr = TargetV
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[TargetPlr].Character.HumanoidRootPart.CFrame
    end
)

TargetT:Button(
    "fly",
    function()
    loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-ARCEUS-X-FLY-OFFICIAL-9384"))()
    end)

local Teleports = serv:Channel("Teleports")

Teleports:Button(
    "Minefield",
    function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-62, 23, -153)
	end
)

Teleports:Button(
    "Balloon",
    function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-118, 23, -126)
	end
)

Teleports:Button(
    "Normal Stairs",
    function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6, 203, -504)
	end
)

Teleports:Button(
    "Moving Stairs",
    function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-213, 87, -224)
	end
)

Teleports:Button(
    "Spiral Stairs",
    function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(108, 829, -339)
	end
)

Teleports:Button(
    "Skyscraper",
    function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(139, 1033, -191)
	end
)

Teleports:Button(
    "Cannon 1",
    function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-62, 30, -227)
	end
)

Teleports:Button(
    "Cannon 2",
    function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(51, 30, -227)
	end
)

Teleports:Button(
    "Cannon 3",
    function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-7, 30, -106)
	end
)

Teleports:Button(
    "Pool",
    function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-133, 65, -322)
	end
)

local Misc = serv:Channel("Misc")


Misc:Label("Player")
Misc:Button(
    "Rejoin",
    function()
local ts = game:GetService("TeleportService")
local p = game:GetService("Players").LocalPlayer
ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
end
)

Misc:Button(
    "click tp",
    function()
mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Click Teleport"
tool.Activated:connect(function()
local pos = mouse.Hit+Vector3.new(0,2.5,0)
pos = CFrame.new(pos.X,pos.Y,pos.Z)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
end)
tool.Parent = game.Players.LocalPlayer.Backpack
end)

Misc:Button(
    "spam",
    function()
     local text   = ""
local Event = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
local function say() 
Event:FireServer(text, "All")
end
text = "ggxhub[made by gg.riks]" say()
end)

Misc:Button(
    "chat-spy",
    function()
    --[[
Title = <string> - The title of the notification.
Content = <string> - The content of the notification.
Image = <string> - The icon of the notification.
Time = <number> - The duration of the notfication.
]]
--This script reveals ALL hidden messages in the default chat
--chat "/spy" to toggle!
enabled = true
--if true will check your messages too
spyOnMyself = true
--if true will chat the logs publicly (fun, risky)
public = false
--if true will use /me to stand out
publicItalics = true
--customize private logs
privateProperties = {
    Color = Color3.fromRGB(0,255,255); 
    Font = Enum.Font.SourceSansBold;
    TextSize = 18;
}
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local saymsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
local getmsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
local instance = (_G.chatSpyInstance or 0) + 1
_G.chatSpyInstance = instance
 
local function onChatted(p,msg)
    if _G.chatSpyInstance == instance then
        if p==player and msg:lower():sub(1,4)=="/spy" then
            enabled = not enabled
            wait(0.3)
            privateProperties.Text = "{SPY "..(enabled and "EN" or "DIS").."ABLED}"
            StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
        elseif enabled and (spyOnMyself==true or p~=player) then
            msg = msg:gsub("[\n\r]",''):gsub("\t",' '):gsub("[ ]+",' ')
            local hidden = true
            local conn = getmsg.OnClientEvent:Connect(function(packet,channel)
                if packet.SpeakerUserId==p.UserId and packet.Message==msg:sub(#msg-#packet.Message+1) and (channel=="All" or (channel=="Team" and public==false and Players[packet.FromSpeaker].Team==player.Team)) then
                    hidden = false
                end
            end)
            wait(1)
            conn:Disconnect()
            if hidden and enabled then
                if public then
                    saymsg:FireServer((publicItalics and "/me " or '').."{SPY} [".. p.Name .."]: "..msg,"All")
                else
                    privateProperties.Text = "{ggxhub} [".. p.Name .."]: "..msg
                    StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
                end
            end
        end
    end
end
 
for _,p in ipairs(Players:GetPlayers()) do
    p.Chatted:Connect(function(msg) onChatted(p,msg) end)
end
Players.PlayerAdded:Connect(function(p)
    p.Chatted:Connect(function(msg) onChatted(p,msg) end)
end)
privateProperties.Text = "{SPY "..(enabled and "EN" or "DIS").."ABLED}"
StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
local chatFrame = player.PlayerGui.Chat.Frame
chatFrame.ChatChannelParentFrame.Visible = true
chatFrame.ChatBarParentFrame.Position = chatFrame.ChatChannelParentFrame.Position+UDim2.new(UDim.new(),chatFrame.ChatChannelParentFrame.Size.Y)
    end)

Misc:Button(
    "fe emotes",
    function()
    loadstring(game:HttpGet("https://pastebin.com/raw/eCpipCTH"))()
    end)

Misc:Button(
    "fling ui",
    function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe./main/Fling%20GUI"))()
   end)

Misc:Button(
    "sit chat",
    function()
    Prefix = '.'

local xd = game:GetService('Players')

xd.LocalPlayer.Chatted:Connect(function(Chat)
   local mensajito = string.split(Chat, " ")
   
   if mensajito[1]:lower() == Prefix..'sit' then
        xd.LocalPlayer.Character.Humanoid.Sit = true
   end
   if mensajito[1]:lower() == Prefix..'test' then
       print('testiculo')
   end
end)
end)

Misc:Button(
    "freeze-player",
    function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Atlasv1/Atlasv1/main/freeze.player"))()
    end)

Misc:Button(
    "Fe r6",
    function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Atlasv1/Atlasv1/main/r6%20fe"))()
	end)
