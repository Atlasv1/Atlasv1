local start = start or tick() or os.clock();
--IMPORT [extend]
Debug = true
if (getconnections) then
    local ErrorConnections = getconnections(game:GetService("ScriptContext").Error);
    if (next(ErrorConnections)) then
        getfenv().error = warn
        getgenv().error = warn
    end
end

local table = {}
for i,v in pairs(getfenv().table) do
    table[i] = v
end
local string = {}
for i,v in pairs(getfenv().string) do
    string[i] = v
end

---@param searchString string
---@param rawPos number
---@return boolean
string.startsWith = function(str, searchString, rawPos)
    local pos = rawPos or 1
    return searchString == "" and true or string.sub(str, pos, pos) == searchString
end

---@param str any
---@return string
string.trim = function(str)
    return str:gsub("^%s*(.-)%s*$", "%1");
end

---@return table
table.tbl_concat = function(...)
    local new = {}
    for i, v in next, {...} do
        for i2, v2 in next, v do
            table.insert(new, #new + 1, v2);
        end
    end
    return new
end

---@param tbl table
---@param val any
---@return any
table.indexOf = function(tbl, val)
    if (type(tbl) == 'table') then
        for i, v in next, tbl do
            if (v == val) then
                return i
            end
        end
    end
end

---@param tbl table
---@param ret function
table.forEach = function(tbl, ret)
    for i, v in next, tbl do
        ret(i, v);
    end
end

---@param tbl table
---@param ret function
---@return table
table.filter = function(tbl, ret)
    if (type(tbl) == 'table') then
        local new = {}
        for i, v in next, tbl do
            if (ret(i, v)) then
                table.insert(new, #new + 1, v);
            end
        end
        return new
    end
end

---@param tbl table
---@param ret function
---@return table
table.map = function(tbl, ret)
    if (type(tbl) == 'table') then
        local new = {}
        for i, v in next, tbl do
            table.insert(new, #new + 1, ret(i, v));
        end
        return new
    end
end

---@param tbl table
---@param ret function
table.deepsearch = function(tbl, ret)
    if (type(tbl) == 'table') then
        for i, v in next, tbl do
            if (type(v) == 'table') then
                table.deepsearch(v, ret);
            end
            ret(i, v);
        end
    end
end

---The flat() method creates a new array with all sub-array elements concatenated into it recursively up to the specified depth
---@param tbl table
---@return table
table.flat = function(tbl)
    if (type(tbl) == 'table') then
        local new = {}
        table.deepsearch(tbl, function(i, v)
            if (type(v) ~= 'table') then
                new[#new + 1] = v
            end
        end)
        return new
    end
end

---@param tbl table
---@param ret function
---@return table
table.flatMap = function(tbl, ret)
    if (type(tbl) == 'table') then
        local new = table.flat(table.map(tbl, ret));
        return new
    end
end

---@param tbl any
table.shift = function(tbl)
    if (type(tbl) == 'table') then
        local firstVal = tbl[1]
        tbl = table.pack(table.unpack(tbl, 2, #tbl));
        tbl.n = nil
        return tbl
    end
end

table.keys = function(tbl)
    if (type(tbl) == 'table') then
        local new = {}
        for i, v in next, tbl do
            new[#new + 1] = i	
        end
        return new
    end
end

local touched = {}
firetouchinterest = firetouchinterest or function(part1, part2, toggle)
    if (part1 and part2) then
        if (toggle == 0) then
            touched[1] = part1.CFrame
            part1.CFrame = part2.CFrame
        else
            part1.CFrame = touched[1]
            touched[1] = nil
        end
    end
end

hookfunction = hookfunction or function(func, newfunc)
    if (replaceclosure) then
        replaceclosure(func, newfunc);
        return newfunc
    end

    func = newcclosure and newcclosure(newfunc) or newfunc
    return newfunc
end

getconnections = getconnections or function()
    return {}
end

getrawmetatable = getrawmetatable or function()
    return setmetatable({}, {});
end

getnamecallmethod = getnamecallmethod or function()
    return ""
end

checkcaller = checkcaller or function()
    return false
end

local ProtectedInstances = {}
local SpoofedInstances = {}
local SpoofedProperties = {}
local Methods = {
    "FindFirstChild",
    "FindFirstChildWhichIsA",
    "FindFirstChildOfClass",
    "IsA"
}
local AllowedIndexes = {
    "RootPart",
    "Parent"
}
local AllowedNewIndexes = {
    "Jump"
}
local AntiKick = false
local AntiTeleport = false

local OldMemoryTags = {}
local Stats = game:GetService("Stats");
for i, v in next, Enum.DeveloperMemoryTag:GetEnumItems() do
    OldMemoryTags[v] = Stats:GetMemoryUsageMbForTag(v);
end

local mt = getrawmetatable(game);
local OldMetaMethods = {}
setreadonly(mt, false);
for i, v in next, mt do
    OldMetaMethods[i] = v
end
local __Namecall = OldMetaMethods.__namecall
local __Index = OldMetaMethods.__index
local __NewIndex = OldMetaMethods.__newindex

mt.__namecall = newcclosure(function(self, ...)
    if (checkcaller()) then
        return __Namecall(self, ...);
    end
    
    local Method = getnamecallmethod():gsub("%z", function(x)
        return x
    end):gsub("%z", "");

    local Protected = ProtectedInstances[self]

    if (Protected) then
        if (table.find(Methods, Method)) then
            return Method == "IsA" and false or nil
        end
    end

    if (Method == "GetChildren" or Method == "GetDescendants") then
        return table.filter(__Namecall(self, ...), function(i, v)
            return not table.find(ProtectedInstances, v);
        end)
    end

    if (Method == "GetFocusedTextBox") then
        if (table.find(ProtectedInstances, __Namecall(self, ...))) then
            return nil
        end
    end

    if (AntiKick and string.lower(Method) == "kick") then
        getgenv().F_A.Utils.Notify(nil, "Attempt to kick", ("attempt to kick with message \"%s\""):format(Args[1]));
        return
    end

    if (AntiTeleport and Method == "Teleport" or Method == "TeleportToPlaceInstance") then
        getgenv().F_A.Utils.Notify(nil, "Attempt to teleport", ("attempt to teleport to place \"%s\""):format(Args[1]));
        return
    end

    return __Namecall(self, ...);
end)

mt.__index = newcclosure(function(Instance_, Index)
    if (checkcaller()) then
        return __Index(Instance_, Index);
    end

    Index = type(Index) == 'string' and Index:gsub("%z", function(x)
        return x
    end):gsub("%z", "") or Index
    
    local ProtectedInstance = ProtectedInstances[Instance_]
    local SpoofedInstance = SpoofedInstances[Instance_]
    local SpoofedPropertiesForInstance = SpoofedProperties[Instance_]

    if (SpoofedInstance) then
        if (table.find(AllowedIndexes, Index)) then
            return __Index(Instance_, Index);
        end
        if (Instance_:IsA("Humanoid") and game.PlaceId == 6650331930) then
            for i, v in next, getconnections(Instance_:GetPropertyChangedSignal("WalkSpeed")) do
                v:Disable();
            end
        end
        return __Index(SpoofedInstance, Index);
    end

    if (SpoofedPropertiesForInstance) then
        for i, SpoofedProperty in next, SpoofedPropertiesForInstance do
            if (Index == SpoofedProperty.Property) then
                return SpoofedProperty.Value
            end
        end
    end

    if (ProtectedInstance) then
        if (table.find(Methods, Index)) then
            return function()
                return Index == "IsA" and false or nil
            end
        end
    end

    if (Index == "GetChildren" or Index == "GetDescendants") then
        return function()
            return table.filter(__Index(Instance_, Index)(Instance_), function(i, v)
                return not table.find(ProtectedInstances, v);
            end)
        end
    end

    if (Index == "GetFocusedTextBox") then
        if (table.find(ProtectedInstances, __Index(Instance_, Index)(Instance_))) then
            return function()
                return nil
            end
        end
    end

    return __Index(Instance_, Index);
end)

mt.__newindex = newcclosure(function(Instance_, Index, Value)
    if (checkcaller()) then
        return __NewIndex(Instance_, Index, Value);
    end

    local SpoofedInstance = SpoofedInstances[Instance_]
    local SpoofedPropertiesForInstance = SpoofedProperties[Instance_]

    if (SpoofedInstance) then
        if (table.find(AllowedNewIndexes, Index)) then
            return __NewIndex(Instance_, Index, Value);
        end
        return __NewIndex(SpoofedInstance, Index, SpoofedInstance[Index]);
    end

    if (SpoofedPropertiesForInstance) then
        for i, SpoofedProperty in next, SpoofedPropertiesForInstance do
            if (SpoofedProperty.Property == Index) then
                return Instance_[Index]
            end
        end
    end

    return __NewIndex(Instance_, Index, Value);
end)

setreadonly(mt, true);

local OldKick
OldKick = hookfunction(Instance.new("Player").Kick, newcclosure(function(self, ...)
    if (AntiKick) then
        local Args = {...}
        getgenv().F_A.Utils.Notify(nil, "Attempt to kick", ("attempt to kick with message \"%s\""):format(Args[1]));
        return
    end

    return OldKick(self, ...);
end))

local OldTeleportToPlaceInstance
OldTeleportToPlaceInstance = hookfunction(game:GetService("TeleportService").TeleportToPlaceInstance, newcclosure(function(self, ...)
    if (AntiTeleport) then
        getgenv().F_A.Utils.Notify(nil, "Attempt to teleport", ("attempt to teleport to place \"%s\""):format(Args[1]));
        return
    end
    return OldTeleportToPlaceInstance(self, ...);
end))
local OldTeleport
OldTeleport = hookfunction(game:GetService("TeleportService").Teleport, newcclosure(function(self, ...)
    if (AntiTeleport) then
        getgenv().F_A.Utils.Notify(nil, "Attempt to teleport", ("attempt to teleport to place \"%s\""):format(Args[1]));
        return
    end
    return OldTeleport(self, ...);
end))

local OldGetMemoryUsageMbForTag
OldGetMemoryUsageMbForTag = hookfunction(Stats.GetMemoryUsageMbForTag, newcclosure(function(self, ...)
    if (game.PlaceId == 6650331930) then
        local Args = {...}
        if (Args[1] == Enum.DeveloperMemoryTag.Gui) then
            return Stats:GetMemoryUsageMbForTag(Args[1]) - 1
        end
    end
    return OldGetMemoryUsageMbForTag(self, ...);
end))

for i, v in next, getconnections(game:GetService("UserInputService").TextBoxFocused) do
    v:Disable();
end
for i, v in next, getconnections(game:GetService("UserInputService").TextBoxFocusReleased) do
    v:Disable();
end

local ProtectInstance = function(Instance_, disallow)
    if (not ProtectedInstances[Instance_]) then
        ProtectedInstances[#ProtectedInstances + 1] = Instance_
        if (syn and syn.protect_gui and not disallow) then
            syn.protect_gui(Instance_);
        end
    end
end

local SpoofInstance = function(Instance_, Instance2)
    if (not SpoofedInstances[Instance_]) then
        SpoofedInstances[Instance_] = Instance2 and Instance2 or Instance_:Clone();
    end
end

local SpoofProperty = function(Instance_, Property, Value)
    for i, v in next, getconnections(Instance_:GetPropertyChangedSignal(Property)) do
        v:Disable();
    end
    if (SpoofedProperties[Instance_]) then
        local Properties = table.map(SpoofedProperties[Instance_], function(i, v)
            return v.Property
        end)
        if (not table.find(Properties, Property)) then
            table.insert(SpoofedProperties[Instance_], {
                Property = Property,
                Value = Value and Value or Instance_[Property]
            });
        end
        return
    end
    SpoofedProperties[Instance_] = {{
        Property = Property,
        Value = Value and Value or Instance_[Property]
    }}
end
--END IMPORT [extend]


UndetectedMode = UndetectedMode or false
if (not UndetectedMode and not game:IsLoaded()) then
    print("fates admin: waiting for game to load...");
    game.Loaded:Wait();
end

if (game:IsLoaded() and UndetectedMode and syn) then
    syn.queue_on_teleport("loadstring(game:HttpGet(\"https://raw.githubusercontent.com/fatesc/fates-admin/main/main.lua\"))()");
    return game:GetService("TeleportService").TeleportToPlaceInstance(game:GetService("TeleportService"), game.PlaceId, game.JobId);
end

if (getgenv().F_A and getgenv().F_A.Loaded) then
    return getgenv().F_A.Utils.Notify(nil, "Loaded", "fates admin is already loaded... use 'killscript' to kill", nil);
end

RunService = game:GetService("RunService");
Players = game:GetService("Players");
UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local StarterPlayer = game:GetService("StarterPlayer");
local StarterPack = game:GetService("StarterPack");
local StarterGui = game:GetService("StarterGui");
local TeleportService = game:GetService("TeleportService");
local CoreGui = game:GetService("CoreGui");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local TextService = game:GetService("TextService");
local MarketplaceService = game:GetService("MarketplaceService")
local Chat = game:GetService("Chat");
local SoundService = game:GetService("SoundService");
local Lighting = game:GetService("Lighting");

local Camera = Workspace.Camera

LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer and LocalPlayer:GetMouse();
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass('PlayerGui')

local PluginLibrary = {}

local GetCharacter = function(Plr)
    return Plr and Plr.Character or LocalPlayer.Character
end
PluginLibrary.GetCharacter = GetCharacter

local GetRoot = function(Plr)
    return Plr and GetCharacter(Plr):FindFirstChild("HumanoidRootPart") or GetCharacter():FindFirstChild("HumanoidRootPart");
end
PluginLibrary.GetRoot = GetRoot

local GetHumanoid = function(Plr)
    return Plr and GetCharacter(Plr):FindFirstChildWhichIsA("Humanoid") or GetCharacter():FindFirstChildWhichIsA("Humanoid");
end
PluginLibrary.GetHumanoid = GetHumanoid

local GetMagnitude = function(Plr)
    return Plr and (GetRoot(Plr).Position - GetRoot().Position).magnitude or math.huge
end
PluginLibrary.GetMagnitude = GetMagnitude

local Settings = {
    Prefix = ">",
    CommandBarPrefix = "Semicolon"
}
local PluginSettings = {
    PluginsEnabled = true,
    PluginDebug = false,
    DisabledPlugins = {
        ["PluginName"] = true
    }
}

local WriteConfig = function(Destroy)
    local JSON = HttpService:JSONEncode(Settings);
    local PluginJSON = HttpService:JSONEncode(PluginSettings);
    if (isfolder("fates-admin") and Destroy) then
        delfolder("fates-admin");
        writefile("fates-admin/config.json", JSON);
        writefile("fates/admin/pluings/plugin-conf.json", PluginJSON);
    else
        makefolder("fates-admin");
        makefolder("fates-admin/plugins");
        makefolder("fates-admin/chatlogs");
        writefile("fates-admin/config.json", JSON);
        writefile("fates-admin/plugins/plugin-conf.json", PluginJSON);
    end
end

local GetConfig = function()
    if (isfolder("fates-admin")) then
        return HttpService:JSONDecode(readfile("fates-admin/config.json"));
    else
        WriteConfig();
        return HttpService:JSONDecode(readfile("fates-admin/config.json"));
    end
end

local GetPluginConfig = function()
    if (isfolder("fates-admin") and isfolder("fates-admin/plugins") and isfile("fates-admin/plugins/plugin-conf.json")) then
        return HttpService:JSONDecode(readfile("fates-admin/plugins/plugin-conf.json"));
    else
        WriteConfig();
        return HttpService:JSONDecode(readfile("fates-admin/plugins/plugin-conf.json"));
    end
end

local SetConfig = function(conf)
    if (isfolder("fates-admin") and isfile("fates-admin/config.json")) then
        local NewConfig = GetConfig();
        for i, v in next, conf do
            NewConfig[i] = v
        end
        writefile("fates-admin/config.json", HttpService:JSONEncode(NewConfig));
    else
        WriteConfig();
        local NewConfig = GetConfig();
        for i, v in next, conf do
            NewConfig[i] = v
        end
        writefile("fates-admin/config.json", HttpService:JSONEncode(NewConfig));
    end
end

local Prefix = isfolder and GetConfig().Prefix or "%"
local AdminUsers = AdminUsers or {}
local Exceptions = Exceptions or {}
local Connections = {
    Players = {}
}
local CLI = false
local ChatLogsEnabled = true
local GlobalChatLogsEnabled = false
local HttpLogsEnabled = true

local GetPlayer = function(str, noerror)
    local CurrentPlayers = table.filter(Players:GetPlayers(), function(i, v)
        return not table.find(Exceptions, v);
    end)
    if (not str) then
        return {}
    end
    str = string.trim(str):lower();
    if (str:find(",")) then
        return table.flatMap(str:split(","), function(i, v)
            return GetPlayer(v);
        end)
    end

    local Magnitudes = table.map(CurrentPlayers, function(i, v)
        return {v,(GetRoot(v).CFrame.p - GetRoot().CFrame.p).Magnitude}
    end)

    local PlayerArgs = {
        ["all"] = function()
            return table.filter(CurrentPlayers, function(i, v) -- removed all arg (but not really) due to commands getting messed up and people getting confused
                return v ~= LocalPlayer
            end)
        end,
        ["others"] = function()
            return table.filter(CurrentPlayers, function(i, v)
                return v ~= LocalPlayer
            end)
        end,
        ["nearest"] = function()
            table.sort(Magnitudes, function(a, b)
                return a[2] < b[2]
            end)
            return {Magnitudes[2][1]}
        end,
        ["farthest"] = function()
            table.sort(Magnitudes, function(a, b)
                return a[2] > b[2]
            end)
            return {Magnitudes[2][1]}
        end,
        ["random"] = function()
            return {CurrentPlayers[math.random(2, #CurrentPlayers)]}
        end,
        ["me"] = function()
            return {LocalPlayer}
        end
    }

    if (PlayerArgs[str]) then
        return PlayerArgs[str]();
    end

    local Players = table.filter(CurrentPlayers, function(i, v)
        return (v.Name:lower():sub(1, #str) == str) or (v.DisplayName:lower():sub(1, #str) == str);
    end)
    if (not next(Players) and not noerror) then
        getgenv().F_A.Utils.Notify(LocalPlayer, "Fail", ("Couldn't find player %s"):format(str));
    end
    return Players
end
PluginLibrary.GetPlayer = GetPlayer
local LastCommand = {}


--IMPORT [ui]
Guis = {}
ParentGui = function(Gui, Parent)
    Gui.Name = HttpService:GenerateGUID(false):gsub('-', ''):sub(1, math.random(25, 30))
    ProtectInstance(Gui);
    Gui.Parent = Parent or CoreGui
    Guis[#Guis + 1] = Gui
    return Gui
end
UI = game:GetObjects("rbxassetid://6167929302")[1]:Clone()

local CommandBarPrefix = isfolder and (GetConfig().CommandBarPrefix and Enum.KeyCode[GetConfig().CommandBarPrefix] or Enum.KeyCode.Semicolon) or Enum.KeyCode.Semicolon

local CommandBar = UI.CommandBar
local Commands = UI.Commands
local ChatLogs = UI.ChatLogs
local GlobalChatLogs = UI.ChatLogs:Clone()
local HttpLogs = UI.ChatLogs:Clone();
local Notification = UI.Notification
local Command = UI.Command
local ChatLogMessage = UI.Message
local GlobalChatLogMessage = UI.Message:Clone()
local NotificationBar = UI.NotificationBar
local Stats = UI.Notification:Clone();
local StatsBar = UI.NotificationBar:Clone();

local RobloxChat = PlayerGui and PlayerGui:FindFirstChild("Chat")
if (RobloxChat) then
    local RobloxChatFrame = RobloxChat:WaitForChild("Frame", .1)
    if RobloxChatFrame then
        RobloxChatChannelParentFrame = RobloxChatFrame:WaitForChild("ChatChannelParentFrame", .1)
        RobloxChatBarFrame = RobloxChatFrame:WaitForChild("ChatBarParentFrame", .1)
        if RobloxChatChannelParentFrame then
            RobloxFrameMessageLogDisplay = RobloxChatChannelParentFrame:WaitForChild("Frame_MessageLogDisplay", .1)
            if RobloxFrameMessageLogDisplay then
                RobloxScroller = RobloxFrameMessageLogDisplay:WaitForChild("Scroller", .1)
            end
        end
    end
end

local CommandBarOpen = false
local CommandBarTransparencyClone = CommandBar:Clone()
local ChatLogsTransparencyClone = ChatLogs:Clone()
local GlobalChatLogsTransparencyClone = GlobalChatLogs:Clone()
local HttpLogsTransparencyClone = HttpLogs:Clone()
local CommandsTransparencyClone
local PredictionText = ""

local UIParent = CommandBar.Parent
GlobalChatLogs.Parent = UIParent
GlobalChatLogMessage.Parent = UIParent
GlobalChatLogs.Name = "GlobalChatLogs"
GlobalChatLogMessage.Name = "GlobalChatLogMessage"

HttpLogs.Parent = UIParent
HttpLogs.Name = "HttpLogs"
HttpLogs.Size = UDim2.new(0, 421, 0, 260);
HttpLogs.Search.PlaceholderText = "Search"

local Frame2
if (RobloxChatBarFrame) then
    local Frame1 = RobloxChatBarFrame:WaitForChild('Frame', .1)
    if Frame1 then
        local BoxFrame = Frame1:WaitForChild('BoxFrame', .1)
        if BoxFrame then
            Frame2 = BoxFrame:WaitForChild('Frame', .1)
            if Frame2 then
                local TextLabel = Frame2:WaitForChild('TextLabel', .1)
                ChatBar = Frame2:WaitForChild('ChatBar', .1)
                if TextLabel and ChatBar then
                    PredictionClone = Instance.new('TextLabel');
                    PredictionClone.Font = TextLabel.Font
                    PredictionClone.LineHeight = TextLabel.LineHeight
                    PredictionClone.MaxVisibleGraphemes = TextLabel.MaxVisibleGraphemes
                    PredictionClone.RichText = TextLabel.RichText
                    PredictionClone.Text = ''
                    PredictionClone.TextColor3 = TextLabel.TextColor3
                    PredictionClone.TextScaled = TextLabel.TextScaled
                    PredictionClone.TextSize = TextLabel.TextSize
                    PredictionClone.TextStrokeColor3 = TextLabel.TextStrokeColor3
                    PredictionClone.TextStrokeTransparency = TextLabel.TextStrokeTransparency
                    PredictionClone.TextTransparency = 0.3
                    PredictionClone.TextTruncate = TextLabel.TextTruncate
                    PredictionClone.TextWrapped = TextLabel.TextWrapped
                    PredictionClone.TextXAlignment = TextLabel.TextXAlignment
                    PredictionClone.TextYAlignment = TextLabel.TextYAlignment
                    PredictionClone.Name = "Predict"
                    PredictionClone.Size = UDim2.new(1, 0, 1, 0);
                    PredictionClone.BackgroundTransparency = 1
                end
            end
        end
    end
end

-- position CommandBar
CommandBar.Position = UDim2.new(0.5, -100, 1, 5);
ProtectInstance(CommandBar.Input, true);
ProtectInstance(Commands.Search, true);
--END IMPORT [ui]


--IMPORT [tags]
PlayerTags = {
    ["505156575355565455"] = {
        ["Tag"] = "Developer",
        ["Name"] = "fate",
        ["Rainbow"] = true,
    },
    ["555352544955574849"] = {
        ["Tag"] = "Developer",
        ["Name"] = "misrepresenting",
        ["Rainbow"] = true,
    },
    ["495656525454515248"] = {
        ["Tag"] = "Cool",
        ["Name"] = "David",
        ["Rainbow"] = true,
    },
    ["49565649565652"] = {
        ["Tag"] = "Developer",
        ["Name"] = "Owner",
        ["Rainbow"] = true
    },
    ["495357485451505151"] = {
        ["Tag"] = "Contributor",
        ["Name"] = "Tes",
        ["Colour"] = {134,0,125} -- more accurate colour for tes.
    }
}

--END IMPORT [tags]


--IMPORT [utils]
-- todo: rewrite all of misrepresentings code.

local Utils = {}

Utils.Tween = function(Object, Style, Direction, Time, Goal)
    local TInfo = TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction])
    local Tween = TweenService:Create(Object, TInfo, Goal)

    Tween:Play()

    return Tween
end

Utils.MultColor3 = function(Color, Delta)
    return Color3.new(math.clamp(Color.R * Delta, 0, 1), math.clamp(Color.G * Delta, 0, 1), math.clamp(Color.B * Delta, 0, 1))
end

Utils.Click = function(Object, Goal) -- Utils.Click(Object, "BackgroundColor3")
    local Hover = {
        [Goal] = Utils.MultColor3(Object[Goal], 0.9)
    }

    local Press = {
        [Goal] = Utils.MultColor3(Object[Goal], 1.2)
    }

    local Origin = {
        [Goal] = Object[Goal]
    }

    Connections["ObjectMouseEnter" .. #Connections] = Object.MouseEnter:Connect(function()
        Utils.Tween(Object, "Sine", "Out", .5, Hover)
    end)

    Connections["ObjectMouseLeave" .. #Connections] = Object.MouseLeave:Connect(function()
        Utils.Tween(Object, "Sine", "Out", .5, Origin)
    end)

    Connections["ObjectMouseButton1Down" .. #Connections] = Object.MouseButton1Down:Connect(function()
        Utils.Tween(Object, "Sine", "Out", .3, Press)
    end)

    Connections["ObjectMouseButton1Up" .. #Connections] = Object.MouseButton1Up:Connect(function()
        Utils.Tween(Object, "Sine", "Out", .4, Hover)
    end)
end

Utils.Blink = function(Object, Goal, Color1, Color2) -- Utils.Click(Object, "BackgroundColor3", NormalColor, OtherColor)
    local Normal = {
        [Goal] = Color1
    }

    local Blink = {
        [Goal] = Color2
    }

    local Tween = Utils.Tween(Object, "Sine", "Out", .5, Blink)
    Tween.Completed:Wait()

    local Tween = Utils.Tween(Object, "Sine", "Out", .5, Normal)
    Tween.Completed:Wait()
end

Utils.Hover = function(Object, Goal)
    local Hover = {
        [Goal] = Utils.MultColor3(Object[Goal], 0.9)
    }

    local Origin = {
        [Goal] = Object[Goal]
    }

    Connections["ObjectMouseEnter" .. #Connections] = Object.MouseEnter:Connect(function()
        Utils.Tween(Object, "Sine", "Out", .5, Hover)
    end)

    Connections["ObjectMouseLeave" .. #Connections] = Object.MouseLeave:Connect(function()
        Utils.Tween(Object, "Sine", "Out", .5, Origin)
    end)
end

Utils.Draggable = function(Ui, DragUi)
    local DragSpeed = 0
    local StartPos
    local DragToggle, DragInput, DragStart, DragPos

    if not DragUi then DragUi = Ui end

    local function UpdateInput(Input)
        local Delta = Input.Position - DragStart
        local Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)

        Utils.Tween(Ui, "Linear", "Out", .25, {
            Position = Position
        })
        TweenService:Create(Ui, TweenInfo.new(0.25), {Position = Position}):Play();
    end

    Connections["UIInputBegan" .. #Connections] = Ui.InputBegan:Connect(function(Input)
        if ((Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and UserInputService:GetFocusedTextBox() == nil) then
            DragToggle = true
            DragStart = Input.Position
            StartPos = Ui.Position

            Connections["InputChanged" .. #Connections] = Input.Changed:Connect(function()
                if (Input.UserInputState == Enum.UserInputState.End) then
                    DragToggle = false
                end
            end)
        end
    end)

    Connections["UiInputChanged" .. #Connections] = Ui.InputChanged:Connect(function(Input)
        if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            DragInput = Input
        end
    end)

    Connections["UserInputServiceInputChanged" .. #Connections] = UserInputService.InputChanged:Connect(function(Input)
        if (Input == DragInput and DragToggle) then
            UpdateInput(Input)
        end
    end)
end

Utils.SmoothScroll = function(content, SmoothingFactor) -- by Elttob
    -- get the 'content' scrolling frame, aka the scrolling frame with all the content inside
    -- if smoothing is enabled, disable scrolling
    content.ScrollingEnabled = false

    -- create the 'input' scrolling frame, aka the scrolling frame which receives user input
    -- if smoothing is enabled, enable scrolling
    local input = content:Clone()

    input:ClearAllChildren()
    input.BackgroundTransparency = 1
    input.ScrollBarImageTransparency = 1
    input.ZIndex = content.ZIndex + 1
    input.Name = "_smoothinputframe"
    input.ScrollingEnabled = true
    input.Parent = content.Parent

    -- keep input frame in sync with content frame
    local function syncProperty(prop)
        Connections["content" .. #Connections] = content:GetPropertyChangedSignal(prop):Connect(function()
            if prop == "ZIndex" then
                -- keep the input frame on top!
                input[prop] = content[prop] + 1
            else
                input[prop] = content[prop]
            end
        end)
    end

    syncProperty "CanvasSize"
    syncProperty "Position"
    syncProperty "Rotation"
    syncProperty "ScrollingDirection"
    syncProperty "ScrollBarThickness"
    syncProperty "BorderSizePixel"
    syncProperty "ElasticBehavior"
    syncProperty "SizeConstraint"
    syncProperty "ZIndex"
    syncProperty "BorderColor3"
    syncProperty "Size"
    syncProperty "AnchorPoint"
    syncProperty "Visible"

    -- create a render stepped connection to interpolate the content frame position to the input frame position
    local smoothConnection = RunService.RenderStepped:Connect(function()
        local a = content.CanvasPosition
        local b = input.CanvasPosition
        local c = SmoothingFactor
        local d = (b - a) * c + a

        content.CanvasPosition = d
    end)

    Connections["smoothConnection" .. #Connections] = smoothConnection

    -- destroy everything when the frame is destroyed
    Connections["contentAncestryChanged" .. #Connections] = content.AncestryChanged:Connect(function()
        if content.Parent == nil then
            input:Destroy()
            smoothConnection:Disconnect()
        end
    end)
end

Utils.TweenAllTransToObject = function(Object, Time, BeforeObject) -- max transparency is max object transparency, swutched args bc easier command
    local Descendants = Object:GetDescendants()
    local OldDescentants = BeforeObject:GetDescendants()
    local Tween -- to use to wait

    Tween = Utils.Tween(Object, "Sine", "Out", Time, {
        BackgroundTransparency = BeforeObject.BackgroundTransparency
    })

    for i, v in next, Descendants do
        local IsText = v:IsA("TextBox") or v:IsA("TextLabel") or v:IsA("TextButton")
        local IsImage = v:IsA("ImageLabel") or v:IsA("ImageButton")
        local IsScrollingFrame = v:IsA("ScrollingFrame")

        if (not v:IsA("UIListLayout")) then
            if (IsText) then
                Utils.Tween(v, "Sine", "Out", Time, {
                    TextTransparency = OldDescentants[i].TextTransparency,
                    TextStrokeTransparency = OldDescentants[i].TextStrokeTransparency,
                    BackgroundTransparency = OldDescentants[i].BackgroundTransparency
                })
            elseif (IsImage) then
                Utils.Tween(v, "Sine", "Out", Time, {
                    ImageTransparency = OldDescentants[i].ImageTransparency,
                    BackgroundTransparency = OldDescentants[i].BackgroundTransparency
                })
            elseif (IsScrollingFrame) then
                Utils.Tween(v, "Sine", "Out", Time, {
                    ScrollBarImageTransparency = OldDescentants[i].ScrollBarImageTransparency,
                    BackgroundTransparency = OldDescentants[i].BackgroundTransparency
                })
            else
                Utils.Tween(v, "Sine", "Out", Time, {
                    BackgroundTransparency = OldDescentants[i].BackgroundTransparency
                })
            end
        end
    end

    return Tween
end

Utils.SetAllTrans = function(Object)
    Object.BackgroundTransparency = 1

    for _, v in ipairs(Object:GetDescendants()) do
        local IsText = v:IsA("TextBox") or v:IsA("TextLabel") or v:IsA("TextButton")
        local IsImage = v:IsA("ImageLabel") or v:IsA("ImageButton")
        local IsScrollingFrame = v:IsA("ScrollingFrame")

        if (not v:IsA("UIListLayout")) then
            v.BackgroundTransparency = 1

            if (IsText) then
                v.TextTransparency = 1
            elseif (IsImage) then
                v.ImageTransparency = 1
            elseif (IsScrollingFrame) then
                v.ScrollBarImageTransparency = 1
            end
        end
    end
end

Utils.TweenAllTrans = function(Object, Time)
    local Tween -- to use to wait

    Tween = Utils.Tween(Object, "Sine", "Out", Time, {
        BackgroundTransparency = 1
    })

    for _, v in ipairs(Object:GetDescendants()) do
        local IsText = v:IsA("TextBox") or v:IsA("TextLabel") or v:IsA("TextButton")
        local IsImage = v:IsA("ImageLabel") or v:IsA("ImageButton")
        local IsScrollingFrame = v:IsA("ScrollingFrame")

        if (not v:IsA("UIListLayout")) then
            if (IsText) then
                Utils.Tween(v, "Sine", "Out", Time, {
                    TextTransparency = 1,
                    BackgroundTransparency = 1
                })
            elseif (IsImage) then
                Utils.Tween(v, "Sine", "Out", Time, {
                    ImageTransparency = 1,
                    BackgroundTransparency = 1
                })
            elseif (IsScrollingFrame) then
                Utils.Tween(v, "Sine", "Out", Time, {
                    ScrollBarImageTransparency = 1,
                    BackgroundTransparency = 1
                })
            else
                Utils.Tween(v, "Sine", "Out", Time, {
                    BackgroundTransparency = 1
                })
            end
        end
    end

    return Tween
end

Utils.Notify = function(Caller, Title, Message, Time)
    if (not Caller or Caller == LocalPlayer) then
        local Notification = UI.Notification
        local NotificationBar = UI.NotificationBar

        local Clone = Notification:Clone()

        local function TweenDestroy()
            if (Utils and Clone) then -- fix error when the script is killed and there is still notifications out
                local Tween = Utils.TweenAllTrans(Clone, .25)

                Tween.Completed:Wait()
                Clone:Destroy();
            end
        end

        Clone.Message.Text = Message
        Clone.Title.Text = Title or "Notification"
        Utils.SetAllTrans(Clone)
        Utils.Click(Clone.Close, "TextColor3")
        Clone.Visible = true -- tween

        if (Message:len() >= 35) then
            Clone.AutomaticSize = Enum.AutomaticSize.Y
            Clone.Message.AutomaticSize = Enum.AutomaticSize.Y
            Clone.Message.RichText = true
            Clone.Message.TextScaled = false
            Clone.Message.TextYAlignment = Enum.TextYAlignment.Top
            Clone.DropShadow.AutomaticSize = Enum.AutomaticSize.Y
        end

        Clone.Parent = NotificationBar

        coroutine.wrap(function()
            local Tween = Utils.TweenAllTransToObject(Clone, .5, Notification)

            Tween.Completed:Wait();
            wait(Time or 5);

            if (Clone) then
                TweenDestroy();
            end
        end)()

        Connections["CloneClose" .. #Connections] = Clone.Close.MouseButton1Click:Connect(function()
            TweenDestroy()
        end)

        return Clone
    else
        local ChatRemote = ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
        ChatRemote:FireServer(("/w %s [FA] %s: %s"):format(Caller.Name, Title, Message), "All");
    end
end

Utils.MatchSearch = function(String1, String2) -- Utils.MatchSearch("pog", "poggers") - true; Utils.MatchSearch("poz", "poggers") - false
    return String1 == string.sub(String2, 1, #String1)
end

Utils.StringFind = function(Table, String)
    for _, v in ipairs(Table) do
        if (Utils.MatchSearch(String, v)) then
            return v
        end
    end
end

Utils.GetPlayerArgs = function(Arg)
    Arg = Arg:lower();
    local SpecialCases = {"all", "others", "random", "me", "nearest", "farthest"}
    if (Utils.StringFind(SpecialCases, Arg)) then
        return Utils.StringFind(SpecialCases, Arg);
    end

    local CurrentPlayers = Players:GetPlayers();
    for i, v in next, CurrentPlayers do
        if (v.Name ~= v.DisplayName and Utils.MatchSearch(Arg, v.DisplayName:lower())) then
            return v.DisplayName:lower();
        end
        if (Utils.MatchSearch(Arg, v.Name:lower())) then
            return v.Name:lower();
        end
    end
end

Utils.ToolTip = function(Object, Message)
    local Clone

    Object.MouseEnter:Connect(function()
        if (Object.BackgroundTransparency < 1 and not Clone) then
            local TextSize = TextService:GetTextSize(Message, 12, Enum.Font.Gotham, Vector2.new(200, math.huge)).Y > 24 and true or false

            Clone = UI.ToolTip:Clone()
            Clone.Text = Message
            Clone.TextScaled = TextSize
            Clone.Visible = true
            Clone.Parent = UI
        end
    end)

    Object.MouseLeave:Connect(function()
        if (Clone) then
            Clone:Destroy()
            Clone = nil
        end
    end)

    if (LocalPlayer) then
        LocalPlayer:GetMouse().Move:Connect(function()
            if (Clone) then
                Clone.Position = UDim2.fromOffset(Mouse.X + 10, Mouse.Y + 10)
            end
        end)
    else
        delay(3, function()
            LocalPlayer = Players.LocalPlayer
            Mouse = LocalPlayer:GetMouse()
            Mouse.Move:Connect(function()
                if (Clone) then
                    Clone.Position = UDim2.fromOffset(Mouse.X + 10, Mouse.Y + 10)
                end
            end)
        end)
    end
end

Utils.ClearAllObjects = function(Object)
    for _, v in ipairs(Object:GetChildren()) do
        if (not v:IsA("UIListLayout")) then
            v:Destroy()
        end
    end
end

Utils.Rainbow = function(TextObject)
    local Text = TextObject.Text
    local Frequency = 1 -- determines how quickly it repeats
    local TotalCharacters = 0
    local Strings = {}

    TextObject.RichText = true

    for Character in string.gmatch(Text, ".") do
        if string.match(Character, "%s") then
            table.insert(Strings, Character)
        else
            TotalCharacters = TotalCharacters + 1
            table.insert(Strings, {'<font color="rgb(%i, %i, %i)">' .. Character .. '</font>'})
        end
    end

    pcall(function() -- no idea why this shit is erroring
        local Connection = AddConnection(RunService.Heartbeat:Connect(function()
            local String = ""
            local Counter = TotalCharacters
    
            for _, CharacterTable in ipairs(Strings) do
                local Concat = ""
    
                if (type(CharacterTable) == "table") then
                    Counter = Counter - 1
                    local Color = Color3.fromHSV(-math.atan(math.tan((tick() + Counter/math.pi)/Frequency))/math.pi + 0.5, 1, 1)
    
                    CharacterTable = string.format(CharacterTable[1], math.floor(Color.R * 255), math.floor(Color.G * 255), math.floor(Color.B * 255))
                end
    
                String = String .. CharacterTable
            end
    
            TextObject.Text = String .. " " -- roblox bug w (textobjects in billboardguis wont render richtext without space)
        end));
        delay(150, function()
            Connection:Disconnect();
        end)
    end)
end

Utils.Locate2 = function(Player, Color)
    local Billboard = Instance.new("BillboardGui");
    coroutine.wrap(function()
        if (GetCharacter(Player)) then
            Billboard.Parent = UI
            Billboard.Name = HttpService:GenerateGUID();
            Billboard.AlwaysOnTop = true
            Billboard.Adornee = Player.Character.Head
            Billboard.Size = UDim2.new(0, 200, 0, 50)
            Billboard.StudsOffset = Vector3.new(0, 4, 0);

            local TextLabel = Instance.new("TextLabel", Billboard);
            TextLabel.Name = HttpService:GenerateGUID();
            TextLabel.TextStrokeTransparency = 0.6
            TextLabel.BackgroundTransparency = 1
            TextLabel.TextColor3 = Color3.new(0, 255, 0);
            TextLabel.Size = UDim2.new(0, 200, 0, 50);
            TextLabel.TextScaled = false
            TextLabel.TextSize = 10
            TextLabel.Text = Player.Name

            local ColorLabel = Instance.new("TextLabel", Billboard);
            ColorLabel.Name = HttpService:GenerateGUID();
            ColorLabel.TextStrokeTransparency = 0.6
            ColorLabel.BackgroundTransparency = 1
            ColorLabel.TextColor3 = Color3.new(152, 152, 152);
            ColorLabel.Size = UDim2.new(0, 200, 0, 50);
            ColorLabel.TextScaled = false
            ColorLabel.TextSize = 8

            local EspLoop = RunService.Heartbeat:Connect(function()
                local Humanoid = GetCharacter(Player) and GetHumanoid(Player);
                local HumanoidRootPart = GetCharacter(Player) and GetRoot(Player);
                if (Humanoid and HumanoidRootPart) then
                    local Distance = math.floor((Workspace.CurrentCamera.CFrame.p - HumanoidRootPart.CFrame.p).Magnitude)
                    ColorLabel.Text = ("\n \n \n [%s] [%s/%s]"):format(Distance, math.floor(Humanoid.Health), math.floor(Humanoid.MaxHealth))
                else
                    EspLoop:Disconnect();
                    Billboard:Destroy();
                end
            end)
            AddConnection(EspLoop);
            AddConnection(Players.PlayerRemoving:Connect(function(Plr)
                if (Plr == Player) then
                    Billboard:Destroy();
                end
            end))
        end
    end)()

    return function()
        Billboard:Destroy();
    end
end

Utils.Vector3toVector2 = function(Vector)
    local Tuple = Camera:WorldToViewportPoint(Vector)
    return Vector2.new(Tuple.X, Tuple.Y);
end

local Locating = {}
local Drawings = {}

Utils.Locate = function(Plr, Color, OutlineColor)
    if (not Drawing) then
        return Utils.Locate2(Plr, Color);
    end
    local Head = GetCharacter(Plr) and GetCharacter(Plr).Head
    if (not Head) then
        return
    end

    local Text = Drawing.new("Text");
    Drawings[#Drawings + 1] = Text

    Text.Position = Utils.Vector3toVector2(Head.Position) + Vector2.new(0, -100, 0);
    Text.Color = Color or Color3.fromRGB(255, 255, 255);
    Text.OutlineColor = OutlineColor or Color3.new();
    Text.Text = ("%s\n[%s] [%s/%s]"):format(Plr.Name, math.floor(GetMagnitude(Plr)), math.floor(GetHumanoid(Plr).Health), math.floor(GetHumanoid(Plr).MaxHealth));
    Text.Size = 16
    Text.Transparency = 1
    Text.Center = true
    Text.Outline = true
    Text.Visible = true
    Locating[Text] = Plr
    return function()
        Text:Remove();
        Locating[Text] = nil
    end
end

local UpdatingLocations = false
Utils.UpdateLocations = function(Toggle)
    if (not UpdatingLocations) then
        UpdatingLocations = AddConnection(RunService.Heartbeat:Connect(function()
            for i, v in next, Locating do
                if (GetCharacter(v) and GetCharacter(v).Head) then
                    local Tuple, Viewable = Camera:WorldToViewportPoint(GetCharacter(v).Head.Position);
                    if (Viewable) then
                        i.Visible = true
                        i.Position = Utils.Vector3toVector2(GetCharacter(v).Head.Position) + Vector2.new(0, -100, 0);           
                        i.Text = ("%s\n[%s] [%s/%s]"):format(v.Name, math.floor(GetMagnitude(v)), math.floor(GetHumanoid(v).Health), math.floor(GetHumanoid(v).MaxHealth));    
                        continue
                    end
                end
                i.Visible = false
            end
        end))
    end
end

Utils.CheckTag = function(Plr)
    if (not Plr or not Plr:IsA("Player")) then
        return nil
    end
    local UserId = tostring(Plr.UserId);
    local Tag = PlayerTags[UserId:gsub(".", function(x)
        return x:byte();
    end)]
    return Tag or nil
end

Utils.AddTag = function(Tag)
    if (not Tag) then
        return
    end
    local PlrCharacter = GetCharacter(Tag.Player)
    if (not PlrCharacter) then
        return
    end
    local Billboard = Instance.new("BillboardGui");
    Billboard.Parent = UI
    Billboard.Name = HttpService:GenerateGUID();
    Billboard.AlwaysOnTop = true
    Billboard.Adornee = PlrCharacter.Head or nil
    Billboard.Enabled = PlrCharacter.Head and true or false
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.StudsOffset = Vector3.new(0, 4, 0);

    local TextLabel = Instance.new("TextLabel", Billboard);
    TextLabel.Name = HttpService:GenerateGUID();
    TextLabel.TextStrokeTransparency = 0.6
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = Color3.new(0, 255, 0);
    TextLabel.Size = UDim2.new(0, 200, 0, 50);
    TextLabel.TextScaled = false
    TextLabel.TextSize = 15
    TextLabel.Text = ("%s (%s)"):format(Tag.Name, Tag.Tag);

    if (Tag.Rainbow) then
        Utils.Rainbow(TextLabel)
    end
    if (Tag.Colour) then
        local TColour = Tag.Colour
        TextLabel.TextColor3 = Color3.fromRGB(TColour[1], TColour[2], TColour[3]);
    end

    local Added = Tag.Player.CharacterAdded:Connect(function()
        Billboard.Adornee = Tag.Player.Character:WaitForChild("Head");
    end)

    AddConnection(Added)

    AddConnection(Players.PlayerRemoving:Connect(function(plr)
        if (plr == Tag.Player) then
            Added:Disconnect();
            Billboard:Destroy();
        end
    end))
end

Utils.TextFont = function(Text, RGB)
    RGB = table.concat(RGB, ",")
    local New = {}
    Text:gsub(".", function(x)
        New[#New + 1] = x
    end)
    return table.concat(table.map(New, function(i, letter)
        return ('<font color="rgb(%s)">%s</font>'):format(RGB, letter)
    end)) .. " "
end

local Tracing = {}
Utils.Trace = function(Player, Color)
    if (not Drawing) then
        return
    end
    local Head = GetCharacter(Player) and GetCharacter(Player).Head
    if (not Head) then
        return
    end
    local Camera = Workspace.Camera

    local Tracer = Drawing.new("Line");
    Drawings[#Drawings + 1] = Tracer

    local Tuple = Camera:WorldToViewportPoint(Head.Position);
    Tracer.To = Vector2.new(Tuple.X, Tuple.Y);
    Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y);
    Tracer.Color = Color or Color3.fromRGB(255, 255, 255);
    Tracer.Thickness = .1
    Tracer.Transparency = 1
    Tracer.Visible = true
    Tracing[Player] = Tracer
    return function()
        Tracer:Remove();
        Tracing[Player] = nil
    end
end

local UpdatingTracers = false
Utils.UpdateTracers = function()
    if (not Updating) then
        UpdatingTracers = AddConnection(RunService.Heartbeat:Connect(function()
            for i, Tracer in next, Tracing do
                local Head = GetCharacter(i) and GetCharacter(i).Head
                if (not Head) then
                    continue
                end
                local Tuple, Viewable = Workspace.Camera:WorldToViewportPoint(Head.Position);
                if (Viewable) then
                    Tracer.Visible = true
                    Tracer.To = Vector2.new(Tuple.X, Tuple.Y);
                else
                    Tracer.Visible = false
                end
            end
        end))
    end
end

Utils.DestroyTracers = function()
    for i, Tracer in next, Tracers do
        Tracer:Remove();
    end
    if (UpdatingTracers) then
        UpdatingTracers:Disconnect();
    end
end

Utils.DestroyDrawings = function()
    for i, Drawing in next, Drawings do
        Drawing:Remove();
    end
    if (UpdatingTracers) then
        UpdatingTracers:Disconnect();
    end
    if (UpdatingLocations) then
        UpdatingLocations:Disconnect();
    end
end
--END IMPORT [utils]



-- commands table
local CommandsTable = {}
local RespawnTimes = {}

local HasTool = function(plr)
    plr = plr or LocalPlayer
    local CharChildren, BackpackChildren = GetCharacter(plr):GetChildren(), plr.Backpack:GetChildren()
    local ToolFound = false
    for i, v in next, table.tbl_concat(CharChildren, BackpackChildren) do
        if (v:IsA("Tool")) then
            ToolFound = true
        end
    end

    return ToolFound
end
PluginLibrary.HasTool = HasTool

local isR6 = function(plr)
    plr = plr or LocalPlayer
    local Humanoid = GetHumanoid(plr);
    if (Humanoid) then
        return Humanoid.RigType == Enum.HumanoidRigType.R6
    end
    return false
end
PluginLibrary.isR6 = isR6

local isSat = function(plr)
    plr = plr or LocalPlayer
    local Humanoid = GetHumanoid(plr)
    if (Humanoid) then
        return Humanoid.Sit
    end
end
PluginLibrary.isSat = isSat

local DisableAnimate = function()
    local Animate = GetCharacter().Animate
    Animate = Animate:IsA("LocalScript") and Animate or nil
    if (Animate) then
        SpoofProperty(Animate, "Disabled");
        Animate.Disabled = true
    end
end

local CommandRequirements = {
    [1] = {
        Func = HasTool,
        Message = "You need a tool for this command"
    },
    [2] = {
        Func = isR6,
        Message = "You need to be R6 for this command"
    },
    [3] = {
        Func = function()
            return GetCharacter() ~= nil
        end,
        Message = "You need to be spawned for this command"
    }
}

local AddCommand = function(name, aliases, description, options, func)
    local Cmd = {
        Name = name,
        Aliases = aliases,
        Description = description,
        Options = options,
        Function = function()
            for i, v in next, options do
                if (type(v) == 'function' and v() == false) then
                    Utils.Notify(LocalPlayer, "Fail", ("You are missing something that is needed for this command (%s)"):format(debug.getinfo(v).namewhat));
                    return nil
                elseif (type(v) == 'number' and CommandRequirements[v].Func() == false) then
                    Utils.Notify(LocalPlayer, "Fail", CommandRequirements[v].Message);
                    return nil
                end
            end
            return func
        end,
        ArgsNeeded = (function()
            local sorted = table.filter(options, function(i,v)
                return type(v) == "string"
            end)
            return tonumber(sorted and sorted[1]);
        end)() or 0,
        Args = (function()
            local sorted = table.filter(options, function(i, v)
                return type(v) == "table"
            end)
            return sorted[1] and sorted[1] or {}
        end)(),
        CmdExtra = {}
    }
    local Success, Err = pcall(function()
        CommandsTable[name] = Cmd
        if (type(aliases) == 'table') then
            for i, v in next, aliases do
                CommandsTable[v] = Cmd
            end
        end
    end)
    return Success
end

local LoadCommand = function(name)
    local Command = rawget(CommandsTable, name);
    if (Command) then
        return Command
    end
end

local ReplaceHumanoid = function(Hum)
    local Humanoid = Hum or GetHumanoid();
    local NewHumanoid = Humanoid:Clone();
    NewHumanoid.Parent = Humanoid.Parent
    NewHumanoid.Name = Humanoid.Name
    Workspace.Camera.CameraSubject = NewHumanoid
    Humanoid:Destroy();
    SpoofInstance(NewHumanoid);
    return NewHumanoid
end

local ReplaceCharacter = function()
    local Char = LocalPlayer.Character
    local Model = Instance.new("Model");
    LocalPlayer.Character = Model
    LocalPlayer.Character = Char
    Model:Destroy();
    return Char
end

local CFrameTool = function(tool, pos)
    local RightArm = GetCharacter():FindFirstChild("RightLowerArm") or GetCharacter():FindFirstChild("Right Arm");

    local Arm = RightArm.CFrame * CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0);
    local Frame = Arm:toObjectSpace(pos):Inverse();

    tool.Grip = Frame
end

local Sanitize = function(value)
    if typeof(value) == 'CFrame' then
        local components = {value:components()}
        for i,v in pairs(components) do
            components[i] = math.floor(v * 10000 + .5) / 10000
        end
        return 'CFrame.new('..table.concat(components, ', ')..')'
    end
end

local AddPlayerConnection = function(Player, Connection, Tbl)
    if (Tbl) then
        Tbl[#Tbl + 1] = Connection
    else
        Connections.Players[Player.Name].Connections[#Connections.Players[Player.Name].Connections + 1] = Connection
    end
    return Connection
end

AddConnection = function(Connection, Tbl, TblOnly)
    if (Tbl) then
        Tbl[#Tbl + 1] = Connection
        if (TblOnly) then
            return Connection
        end
    end
    Connections[#Connections + 1] = Connection
    return Connection
end
PluginLibrary.AddConnection = AddConnection

local DisableAllCmdConnections = function(Cmd)
    local Command = LoadCommand(Cmd)
    if (Command and Command.CmdExtra) then
        for i, v in next, table.flat(Command.CmdExtra) do
            if (type(v) == 'userdata' and v.Disconnect) then
                v:Disconnect();
            end
        end
    end
    return Command
end

local Keys = {}

AddConnection(UserInputService.InputBegan:Connect(function(Input, GameProccesed)
    if (GameProccesed) then return end
    local KeyCode = tostring(Input.KeyCode):split(".")[3]
    Keys[KeyCode] = true
end));

AddConnection(UserInputService.InputEnded:Connect(function(Input, GameProccesed)
    if (GameProccesed) then return end
    local KeyCode = tostring(Input.KeyCode):split(".")[3]
    if (Keys[KeyCode]) then
        Keys[KeyCode] = false
    end
end));

--IMPORT [plugin]
local IsSupportedExploit = isfile and isfolder and writefile and readfile
local PluginConf = IsSupportedExploit and GetPluginConfig();
local IsDebug = IsSupportedExploit and PluginConf.PluginDebug

local LoadPlugin = function(Plugin)
    if (not IsSupportedExploit) then
        return 
    end
    if (Plugin and PluginConf.DisabledPlugins[Plugin.Name]) then
        return Utils.Notify(LocalPlayer, "Plugin not loaded.", ("Plugin %s was not loaded as it is on the disabled list."):format(Plugin.Name));
    end
    if (#table.keys(Plugin) < 3) then
        return IsDebug and Utils.Notify(LocalPlayer, "Plugin Fail", "One of your plugins is missing information.") or nil
    end
    if (IsDebug) then
        Utils.Notify(LocalPlayer, "Plugin loading", ("Plugin %s is being loaded."):format(Plugin.Name));
    end

    local Ran, Return = pcall(Plugin.Init);
    if (not Ran and Return and IsDebug) then
        return Utils.Notify(LocalPlayer, "Plugin Fail", ("there is an error in plugin Init %s: %s"):format(Plugin.Name, Return));
    end
    
    for i, command in next, Plugin.Commands or {} do -- adding the "or" because some people might have outdated plugins in the dir
        if (#table.keys(command) < 3) then
            Utils.Notify(LocalPlayer, "Plugin Command Fail", ("Command %s is missing information"):format(command.Name));
            continue
        end
        AddCommand(command.Name, command.Aliases or {}, command.Description .. " - " .. Plugin.Author, command.Requirements or {}, command.Func);

        if (Commands.Frame.List:FindFirstChild(command.Name)) then
            Commands.Frame.List:FindFirstChild(command.Name):Destroy();
        end
        local Clone = Command:Clone();
        Utils.Hover(Clone, "BackgroundColor3");
        Utils.ToolTip(Clone, command.Name .. "\n" .. command.Description .. " - " .. Plugin.Author);
        Clone.CommandText.RichText = true
        Clone.CommandText.Text = ("%s %s %s"):format(command.Name, next(command.Aliases or {}) and ("(%s)"):format(table.concat(command.Aliases, ", ")) or "", Utils.TextFont("[PLUGIN]", {77, 255, 255}));
        Clone.Name = command.Name
        Clone.Visible = true
        Clone.Parent = Commands.Frame.List
        if (IsDebug) then
            Utils.Notify(LocalPlayer, "Plugin Command Loaded", ("Command %s loaded successfully"):format(command.Name));
        end
    end
end

if (IsSupportedExploit) then
    if (not isfolder("fates-admin") and not isfolder("fates-admin/plugins") and not isfolder("fates-admin/plugin-conf.json") or not isfolder("fates-admin/chatlogs")) then
        WriteConfig();
    end
end

local Plugins = IsSupportedExploit and table.map(table.filter(listfiles("fates-admin/plugins"), function(i, v)
    return v:split(".")[#v:split(".")]:lower() == "lua"
end), function(i, v)
    return {v:split("\\")[2], loadfile(v)}
end) or {}

for i, Plugin in next, Plugins do
    LoadPlugin(Plugin[2]());
end

AddCommand("view", {"v"}, "views a user", {3,"1"}, function(Caller, Args)
    local Target = GetPlayer(Args[1]);
    for i, v in next, Target do
        Workspace.Camera.CameraSubject = GetHumanoid(v) or GetHumanoid();
    end
end)

AddCommand("unview", {"unv"}, "unviews a user", {3}, function(Caller, Args)
    Workspace.Camera.CameraSubject = GetHumanoid();
end)

AddCommand("chatspy", {}, "spy chat", {3}, function(Caller, Args, Tbl)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Atlasv1/Atlasv1/main/chat%20spy"))()
end)

AddCommand("sit", {}, "makes you sit", {3}, function(Caller, Args, Tbl)
    SpoofProperty(GetHumanoid(), "Sit", false);
    GetHumanoid().Sit = true
    return "now sitting (obviously)"
end)

AddCommand("headsit", {"hsit"}, "sits on the players head", {"1"}, function(Caller, Args, Tbl)
    local Target = GetPlayer(Args[1]);
    for i, v in next, Target do
        local Humanoid = GetHumanoid();
        SpoofProperty(Humanoid, "Sit");
        Humanoid.Sit = true
        AddConnection(Humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
            Humanoid.Sit = true
        end), Tbl);
        local Root = GetRoot();
        AddConnection(RunService.Heartbeat:Connect(function()
            Root.CFrame = v.Character.Head.CFrame * CFrame.new(0, 0, 1);
        end), Tbl);
    end
end)

AddCommand("unheadsit", {"noheadsit"}, "unheadsits on the target", {3}, function(Caller, Args)
    local Looped = LoadCommand("headsit").CmdExtra
    for i, v in next, Looped do
        v:Disconnect();
    end
    return "headsit disabled"
end)

AddCommand("fling", {}, "flings a Player", {}, function(Caller, Args)
    local Target = GetPlayer(Args[1]);
    local Root = GetRoot()
    SpoofProperty(Root, "Velocity");
    SpoofProperty(Root, "Anchored");
    local OldPos, OldVelocity = Root.CFrame, Root.Velocity

    for i, v in next, Target do
        local TargetRoot = GetRoot(v);
        local TargetPos = TargetRoot.Position
        local Stepped = RunService.Stepped:Connect(function(step)
            step = step - Workspace.DistributedGameTime

            Root.CFrame = (TargetRoot.CFrame - (Vector3.new(0, 1e6, 0) * step)) + (TargetRoot.Velocity * (step * 30))
            Root.Velocity = Vector3.new(0, 1e6, 0)
        end)
        local starttime = tick();
        repeat
            wait();
        until (TargetPos - TargetRoot.Position).magnitude >= 60 or tick() - starttime >= 3.5
        Stepped:Disconnect();
    end
    wait();
    local Stepped = RunService.Stepped:Connect(function()
        Root.Velocity = OldVelocity
        Root.CFrame = OldPos
    end)
    wait(2);
    Root.Anchored = true
    Stepped:Disconnect();
    Root.Anchored = false
    Root.Velocity = OldVelocity
    Root.CFrame = OldPos
end)

AddCommand("age", {}, "ages a player", {"1"}, function(Caller, Args)
    local Target = GetPlayer(Args[1]);
    for i, v in next, Target do
        local AccountAge = v.AccountAge
        local t = os.date("*t", os.time());
        t.day = t.day - tonumber(AccountAge);
        local CreatedAt = os.date("%d/%m/%y", os.time(t));
        Utils.Notify(Caller, "Command", ("%s's age is %s (%s)"):format(v.Name, AccountAge, CreatedAt));
    end
end)

AddCommand("autorejoin", {}, "auto rejoins the game when you get kicked", {}, function(Caller, Args, Tbl)
    local RejoinConnection = CoreGui:FindFirstChild("RobloxPromptGui"):FindFirstChildWhichIsA("Frame").DescendantAdded:Connect(function(Prompt)
        if (Prompt.Name == "ErrorTitle") then
            Prompt:GetPropertyChangedSignal("Text"):Wait();
            if (Prompt.Text == "Disconnected") then
                syn.queue_on_teleport("loadstring(game:HttpGet(\"https://raw.githubusercontent.com/fatesc/fates-admin/main/main.lua\"))()")
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId);
            end
        end
    end)
    AddConnection(RejoinConnection);
    Tbl[#Tbl + 1] = RejoinConnection
    return "auto rejoin enabled (rejoins when you get kicked from the game)"
end)

AddCommand("spin", {}, "spins your character (optional: speed)", {}, function(Caller, Args, Tbl)
    local Speed = Args[1] or 5
    local Spin = Instance.new("BodyAngularVelocity");
    ProtectInstance(Spin);
    Spin.Parent = GetRoot();
    Spin.MaxTorque = Vector3.new(0, math.huge, 0);
    Spin.AngularVelocity = Vector3.new(0, Speed, 0);
    Tbl[#Tbl + 1] = Spin
    return "started spinning"
end)

AddCommand("unspin", {}, "unspins your character", {}, function(Caller, Args)
    local Spinning = LoadCommand("spin").CmdExtra
    for i, v in next, Spinning do
        v:Destroy();
    end
    return "stopped spinning"
end)

AddCommand("goto", {"to"}, "teleports yourself to the other character", {3, "1"}, function(Caller, Args)
    local Target = GetPlayer(Args[1]);
    local Delay = tonumber(Args[2]);
    for i, v in next, Target do
        if (Delay) then
            wait(Delay);
        end
        GetRoot().CFrame = GetRoot(v).CFrame * CFrame.new(-5, 0, 0);
    end
end)

AddCommand("swim", {}, "allows you to use the swim state", {3}, function(Caller, Args, Tbl)
    local Humanoid = GetHumanoid();
    SpoofInstance(Humanoid);
    for i, v in next, Enum.HumanoidStateType:GetEnumItems() do
        Humanoid:SetStateEnabled(v, false);
    end
    Tbl[1] = Humanoid:GetState();
    Humanoid:ChangeState(Enum.HumanoidStateType.Swimming);
    SpoofProperty(Workspace, "Gravity");
    Workspace.Gravity = 0
    coroutine.wrap(function()
        Humanoid.Died:Wait();
        Workspace.Gravity = 198
    end)()
    return "swimming enabled"
end)

AddCommand("unswim", {"noswim"}, "removes swim", {}, function(Caller, Args)
    local Humanoid = GetHumanoid();
    for i, v in next, Enum.HumanoidStateType:GetEnumItems() do
        Humanoid:SetStateEnabled(v, true);
    end
    Humanoid:ChangeState(LoadCommand("swim").CmdExtra[1]);
    Workspace.Gravity = 198
    return "swimming disabled"
end)

AddCommand("antifling", {}, "antifling your character", {3}, function(Caller, Args, Tbl)
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

AddCommand("antirag", {}, "antirag your character", {3}, function(Caller, Args, Tbl)
     plrs = game:GetService("Players")
plr = plrs.LocalPlayer
char = plr.Character
char.HumanoidRootPart.Size = Vector3.new(1000000, char.HumanoidRootPart.Size.Y, 1000000)
char.Pushed:Destroy()
char.RagdollMe:Destroy()
game.Players.LocalPlayer.Character.Humanoid.Died:connect(function()
plrs = game:GetService("Players")
plr = plrs.LocalPlayer
char = plr.Character
char.HumanoidRootPart.Size = Vector3.new(0.98, 1.62, 0.7225, char.HumanoidRootPart.Size.Y, 0.98, 1.62, 0.7225)
end)
end)

AddCommand("rejoin", {"rj"}, "rejoins the game you're currently in", {}, function(Caller)
    if (Caller == LocalPlayer) then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId);
        return "Rejoining..."
    end
end)

AddCommand("serverhop", {"sh"}, "switches servers (optional: min or max)", {{"min", "max"}}, function(Caller, Args)
    if (Caller == LocalPlayer) then
        Utils.Notify(Caller or LocalPlayer, nil, "Looking for servers...");

        local Servers = HttpService:JSONDecode(game:HttpGetAsync(("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId))).data
        if (#Servers >= 1) then
            Servers = table.filter(Servers, function(i,v)
                return v.playing ~= v.maxPlayers and v.id ~= game.JobId
            end)
            local Server
            local Option = Args[1] or ""
            if (Option:lower() == "min") then
                Server = Servers[#Servers]
            elseif (Option:lower() == "max") then
                Server = Servers[1]
            else
                Server = Servers[math.random(1, #Servers)]
            end
            if (syn) then
                syn.queue_on_teleport("loadstring(game:HttpGet(\"https://raw.githubusercontent.com/fatesc/fates-admin/main/main.lua\"))()");
            end
            TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id);
            return ("joining server (%d/%d players)"):format(Server.playing, Server.maxPlayers);
        else
            return "no servers foudn"
        end
    end
end)

AddCommand("whitelist", {"wl"}, "whitelists a user so they can use commands", {"1"}, function(Caller, Args)
    local Target = GetPlayer(Args[1]);
    for i, v in next, Target do
        AdminUsers[#AdminUsers + 1] = v
        Utils.Notify(v, "Whitelisted", ("You (%s) are whitelisted to use commands"):format(v.Name));
    end
end)

AddCommand("whitelisted", {"whitelistedusers"}, "shows all the users whitelisted to use commands", {}, function(Caller)
    return next(AdminUsers) and table.concat(table.map(AdminUsers, function(i,v) return v.Name end), ", ") or "no users whitelisted"
end)

AddCommand("commands", {"cmds"}, "shows you all the commands listed in fates admin", {}, function()
    if (not CommandsLoaded) then
        local CommandsList = Commands.Frame.List
        Utils.SmoothScroll(CommandsList, .14);
        for _, v in next, CommandsTable do
            if (not CommandsList:FindFirstChild(v.Name)) then
                local Clone = Command:Clone()
                Utils.Hover(Clone, "BackgroundColor3");
                Utils.ToolTip(Clone, v.Name .. "\n" .. v.Description);
                Clone.CommandText.Text = v.Name .. (#v.Aliases > 0 and " (" ..table.concat(v.Aliases, ", ") .. ")" or "");
                Clone.Name = v.Name
                Clone.Visible = true
                Clone.Parent = CommandsList
            end
        end
        Commands.Frame.List.CanvasSize = UDim2.fromOffset(0, Commands.Frame.List.UIListLayout.AbsoluteContentSize.Y);
        CommandsTransparencyClone = Commands:Clone();
        Utils.SetAllTrans(Commands)
        CommandsLoaded = true
    end
    Commands.Visible = true
    Utils.TweenAllTransToObject(Commands, .25, CommandsTransparencyClone);
    return "Commands Loaded"
end)

AddCommand("killscript", {}, "kills the script", {}, function(Caller)
    if (Caller == LocalPlayer) then
        table.deepsearch(Connections, function(i,v)
            if (type(v) == 'userdata' and v.Disconnect) then
                v:Disconnect();
            elseif (type(v) == 'boolean') then
                v = false
            end
        end);
        UI:Destroy();
        getgenv().F_A = nil
        setreadonly(mt, false);
        mt = OldMetaMethods
        setreadonly(mt, true);
        for i, v in next, getfenv() do
            getfenv()[i] = nil
        end
    end
end)

AddCommand("setprefix", {}, "changes your prefix", {"1"}, function(Caller, Args)
    local PrefixToSet = Args[1]
    if (PrefixToSet:match("%A")) then
        Prefix = PrefixToSet
        Utils.Notify(Caller, "Command", ("your new prefix is now '%s'"):format(PrefixToSet));
        return "use command saveprefix to save your prefix"
    else
        return "prefix must be a symbol"
    end
end)

AddCommand("setcommandbarprefix", {"setcprefix"}, "sets your command bar prefix to whatever you input", {}, function()
    ChooseNewPrefix = true
    local CloseNotif = Utils.Notify(LocalPlayer, "New Prefix", "Input the new prefix you would like to have", 7);
end)

AddCommand("saveprefix", {}, "saves your prefix", {}, function(Caller, Args)
    if (GetConfig().Prefix == Prefix and Enum.KeyCode[GetConfig().CommandBarPrefix] == CommandBarPrefix) then
        return "nothing to save, prefix is the same"
    else
        SetConfig({["Prefix"]=Prefix,["CommandBarPrefix"]=tostring(CommandBarPrefix):split(".")[3]});
        return "saved prefix"
    end
end)

AddCommand("shiftlock", {}, "enables shiftlock in your game (some games have it off)", {}, function()
    if (LocalPlayer.DevEnableMouseLock) then
        return "shiftlock is already on"
    end
    LocalPlayer.DevEnableMouseLock = true
    return "shiftlock is now on"
end)

local PlrChat = function(i, plr)
    if (not Connections.Players[plr.Name]) then
        Connections.Players[plr.Name] = {}
        Connections.Players[plr.Name].Connections = {}
    end
    Connections.Players[plr.Name].ChatCon = plr.Chatted:Connect(function(raw)

        local message = raw

        if (ChatLogsEnabled) then
            local Tag = Utils.CheckTag(plr);

            local time = os.date("%X");
            local Text = ("%s - [%s]: %s"):format(time, Tag and Tag.Name or plr.Name, raw);
            local Clone = ChatLogMessage:Clone();

            Clone.Text = Text
            Clone.Visible = true
            Clone.TextTransparency = 1
            Clone.Parent = ChatLogs.Frame.List

            if (Tag and Tag.Rainbow) then
                Utils.Rainbow(Clone);
            end
            if (Tag and Tag.Colour) then
                local TColour = Tag.Colour
                Clone.TextColor3 = Color3.fromRGB(TColour[1], TColour[2], TColour[3]);
            end

            Utils.Tween(Clone, "Sine", "Out", .25, {
                TextTransparency = 0
            })

            ChatLogs.Frame.List.CanvasSize = UDim2.fromOffset(0, ChatLogs.Frame.List.UIListLayout.AbsoluteContentSize.Y);
        end

        if (GlobalChatLogsEnabled and plr == LocalPlayer) then
            local Message = {
                username = LocalPlayer.Name,
                userid = LocalPlayer.UserId,
                message = message
            }
            Socket:Send(HttpService:JSONEncode(Message));
        end
        if (string.startsWith(raw, "/e")) then
            raw = raw:sub(4);
        elseif (string.startsWith(raw, Prefix)) then
            raw = raw:sub(#Prefix + 1);
        else
            return
        end

        message = string.trim(raw);

        if (table.find(AdminUsers, plr) or plr == LocalPlayer) then
            local CommandArgs = message:split(" ");
            local Command, LoadedCommand = CommandArgs[1], LoadCommand(CommandArgs[1]);
            local Args = table.shift(CommandArgs);

            if (LoadedCommand) then
                if (LoadedCommand.ArgsNeeded > #Args) then
                    return Utils.Notify(plr, "Error", ("Insuficient Args (you need %d)"):format(LoadedCommand.ArgsNeeded))
                end

                local Success, Err = pcall(function()
                    local Executed = LoadedCommand.Function()(plr, Args, LoadedCommand.CmdExtra);
                    if (Executed) then
                        Utils.Notify(plr, "Command", Executed);
                    end
                    if (#LastCommand == 3) then
                        LastCommand = table.shift(LastCommand);
                    end
                    LastCommand[#LastCommand + 1] = {Command, plr, Args, LoadedCommand.CmdExtra}
                end);
                if (not Success and Debug) then
                    warn(Err);
                end
            else
                Utils.Notify(plr, "Error", ("couldn't find the command %s"):format(Command));
            end
        end
    end)
end

--IMPORT [uimore]
-- make all elements not visible
Notification.Visible = false
Stats.Visible = false
Utils.SetAllTrans(CommandBar)
Utils.SetAllTrans(ChatLogs)
Utils.SetAllTrans(GlobalChatLogs)
Utils.SetAllTrans(HttpLogs);
Commands.Visible = false
ChatLogs.Visible = false
GlobalChatLogs.Visible = false
HttpLogs.Visible = false

-- make the ui draggable
Utils.Draggable(Commands)
Utils.Draggable(ChatLogs)
Utils.Draggable(GlobalChatLogs)
Utils.Draggable(HttpLogs);

-- parent ui
ParentGui(UI);
Connections.UI = {}
-- tweencommand bar on prefix
local Times = #LastCommand
AddConnection(UserInputService.InputBegan:Connect(function(Input, GameProccesed)
    if (Input.KeyCode == CommandBarPrefix and (not GameProccesed)) then
        CommandBarOpen = not CommandBarOpen

        local TransparencyTween = CommandBarOpen and Utils.TweenAllTransToObject or Utils.TweenAllTrans
        local Tween = TransparencyTween(CommandBar, .5, CommandBarTransparencyClone)

        -- tween position
        if (CommandBarOpen) then
            if (not Draggable) then
                Utils.Tween(CommandBar, "Quint", "Out", .5, {
                    Position = UDim2.new(0.5, WideBar and -200 or -100, 1, -110) -- tween -110
                })
            end

            CommandBar.Input:CaptureFocus()
            coroutine.wrap(function()
                wait()
                CommandBar.Input.Text = ""
            end)()
        else
            if (not Draggable) then
                Utils.Tween(CommandBar, "Quint", "Out", .5, {
                    Position = UDim2.new(0.5, WideBar and -200 or -100, 1, 5) -- tween 5
                })
            end
        end
    elseif (not GameProccesed and ChooseNewPrefix) then
        CommandBarPrefix = Input.KeyCode
        Utils.Notify(LocalPlayer, "New Prefix", "Your new prefix is: " .. tostring(Input.KeyCode):split(".")[3]);
        ChooseNewPrefix = false
        if (writefile) then
            Utils.Notify(LocalPlayer, nil, "use command saveprefix to save your prefix");
        end
    elseif (GameProccesed and CommandBarOpen) then
        if (Input.KeyCode == Enum.KeyCode.Up) then
            Times = Times >= 3 and Times or Times + 1
            CommandBar.Input.Text = LastCommand[Times][1] .. " "
            CommandBar.Input.CursorPosition = #CommandBar.Input.Text + 2
        end
        if (Input.KeyCode == Enum.KeyCode.Down) then
            Times = Times <= 1 and 1 or Times - 1
            CommandBar.Input.Text = LastCommand[Times][1] .. " "
            CommandBar.Input.CursorPosition = #CommandBar.Input.Text + 2
        end
    end
end), Connections.UI, true);

Utils.Click(Commands.Close, "TextColor3")
Utils.Click(ChatLogs.Clear, "BackgroundColor3")
Utils.Click(ChatLogs.Save, "BackgroundColor3")
Utils.Click(ChatLogs.Toggle, "BackgroundColor3")
Utils.Click(ChatLogs.Close, "TextColor3")

Utils.Click(GlobalChatLogs.Clear, "BackgroundColor3")
Utils.Click(GlobalChatLogs.Save, "BackgroundColor3")
Utils.Click(GlobalChatLogs.Toggle, "BackgroundColor3")
Utils.Click(GlobalChatLogs.Close, "TextColor3")

Utils.Click(HttpLogs.Clear, "BackgroundColor3")
Utils.Click(HttpLogs.Save, "BackgroundColor3")
Utils.Click(HttpLogs.Toggle, "BackgroundColor3")
Utils.Click(HttpLogs.Close, "TextColor3")

-- close tween commands
AddConnection(Commands.Close.MouseButton1Click:Connect(function()
    local Tween = Utils.TweenAllTrans(Commands, .25)

    Tween.Completed:Wait()
    Commands.Visible = false
end), Connections.UI, true);

-- command search
AddConnection(Commands.Search:GetPropertyChangedSignal("Text"):Connect(function()
    local Text = Commands.Search.Text
    for _, v in next, Commands.Frame.List:GetChildren() do
        if (v:IsA("Frame")) then
            local Command = v.CommandText.Text

            v.Visible = string.find(string.lower(Command), Text, 1, true)
        end
    end

    Commands.Frame.List.CanvasSize = UDim2.fromOffset(0, Commands.Frame.List.UIListLayout.AbsoluteContentSize.Y)
end), Connections.UI, true);

-- close chatlogs
AddConnection(ChatLogs.Close.MouseButton1Click:Connect(function()
    local Tween = Utils.TweenAllTrans(ChatLogs, .25)

    Tween.Completed:Wait()
    ChatLogs.Visible = false
end), Connections.UI, true);
AddConnection(GlobalChatLogs.Close.MouseButton1Click:Connect(function()
    local Tween = Utils.TweenAllTrans(GlobalChatLogs, .25)

    Tween.Completed:Wait()
    GlobalChatLogs.Visible = false
end), Connections.UI, true);
AddConnection(HttpLogs.Close.MouseButton1Click:Connect(function()
    local Tween = Utils.TweenAllTrans(GlobalChatLogs, .25)

    Tween.Completed:Wait()
    GlobalChatLogs.Visible = false
end), Connections.UI, true);

ChatLogs.Toggle.Text = ChatLogsEnabled and "Enabled" or "Disabled"
GlobalChatLogs.Toggle.Text = ChatLogsEnabled and "Enabled" or "Disabled"
HttpLogs.Toggle.Text = HttpLogsEnabled and "Enabled" or "Disabled"


-- enable chat logs
AddConnection(ChatLogs.Toggle.MouseButton1Click:Connect(function()
    ChatLogsEnabled = not ChatLogsEnabled
    ChatLogs.Toggle.Text = ChatLogsEnabled and "Enabled" or "Disabled"
end), Connections.UI, true);
AddConnection(GlobalChatLogs.Toggle.MouseButton1Click:Connect(function()
    GlobalChatLogsEnabled = not GlobalChatLogsEnabled
    GlobalChatLogs.Toggle.Text = GlobalChatLogsEnabled and "Enabled" or "Disabled"
end), Connections.UI, true);
AddConnection(HttpLogs.Toggle.MouseButton1Click:Connect(function()
    HttpLogsEnabled = not HttpLogsEnabled
    HttpLogs.Toggle.Text = HttpLogsEnabled and "Enabled" or "Disabled"
end), Connections.UI, true);

-- clear chat logs
AddConnection(ChatLogs.Clear.MouseButton1Click:Connect(function()
    Utils.ClearAllObjects(ChatLogs.Frame.List)
    ChatLogs.Frame.List.CanvasSize = UDim2.fromOffset(0, 0)
end), Connections.UI, true);
AddConnection(GlobalChatLogs.Clear.MouseButton1Click:Connect(function()
    Utils.ClearAllObjects(GlobalChatLogs.Frame.List)
    GlobalChatLogs.Frame.List.CanvasSize = UDim2.fromOffset(0, 0)
end), Connections.UI, true);
AddConnection(HttpLogs.Clear.MouseButton1Click:Connect(function()
    Utils.ClearAllObjects(HttpLogs.Frame.List)
    HttpLogs.Frame.List.CanvasSize = UDim2.fromOffset(0, 0)
end), Connections.UI, true);

-- chat logs search
AddConnection(ChatLogs.Search:GetPropertyChangedSignal("Text"):Connect(function()
    local Text = ChatLogs.Search.Text

    for _, v in next, ChatLogs.Frame.List:GetChildren() do
        if (not v:IsA("UIListLayout")) then
            local Message = v.Text:split(": ")[2]
            v.Visible = string.find(string.lower(Message), Text, 1, true)
        end
    end

    ChatLogs.Frame.List.CanvasSize = UDim2.fromOffset(0, ChatLogs.Frame.List.UIListLayout.AbsoluteContentSize.Y)
end), Connections.UI, true);

AddConnection(GlobalChatLogs.Search:GetPropertyChangedSignal("Text"):Connect(function()
    local Text = GlobalChatLogs.Search.Text

    for _, v in next, GlobalChatLogs.Frame.List:GetChildren() do
        if (not v:IsA("UIListLayout")) then
            local Message = v.Text

            v.Visible = string.find(string.lower(Message), Text, 1, true)
        end
    end
end), Connections.UI, true);

AddConnection(HttpLogs.Search:GetPropertyChangedSignal("Text"):Connect(function()
    local Text = HttpLogs.Search.Text

    for _, v in next, HttpLogs.Frame.List:GetChildren() do
        if (not v:IsA("UIListLayout")) then
            local Message = v.Text
            v.Visible = string.find(string.lower(Message), Text, 1, true)
        end
    end
end), Connections.UI, true);

AddConnection(ChatLogs.Save.MouseButton1Click:Connect(function()
    local GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
    local String =  ("Fates Admin Chatlogs for %s (%s)\n\n"):format(GameName, os.date());
    local TimeSaved = tostring(os.date("%x")):gsub("/","-") .. " " .. tostring(os.date("%X")):gsub(":","-");
    local Name = ("fates-admin/chatlogs/%s (%s).txt"):format(GameName, TimeSaved);
    for i, v in next, ChatLogs.Frame.List:GetChildren() do
        if (not v:IsA("UIListLayout")) then
            String = ("%s%s\n"):format(String, v.Text);
        end
    end
    writefile(Name, String);
    Utils.Notify(LocalPlayer, "Saved", "Chat logs saved!");
end), Connections.UI, true);

AddConnection(HttpLogs.Save.MouseButton1Click:Connect(function()
    print("saved");
end), Connections.UI, true);

-- auto correct
AddConnection(CommandBar.Input:GetPropertyChangedSignal("Text"):Connect(function() -- make it so that every space a players name will appear
    CommandBar.Input.Text = CommandBar.Input.Text:lower();
    local Text = CommandBar.Input.Text
    local Prediction = CommandBar.Input.Predict
    local PredictionText = Prediction.Text

    local Args = string.split(Text, " ")

    Prediction.Text = ""
    if (Text == "") then
        return
    end

    local FoundCommand = false
    local FoundAlias = false
    CommandArgs = CommandArgs or {}
    if (not CommandsTable[Args[1]]) then
        for _, v in next, CommandsTable do
            local CommandName = v.Name
            local Aliases = v.Aliases
            local FoundAlias
    
            if (Utils.MatchSearch(Args[1], CommandName)) then -- better search
                Prediction.Text = CommandName
                CommandArgs = v.Args or {}
                break
            end
    
            for _, v2 in next, Aliases do
                if (Utils.MatchSearch(Args[1], v2)) then
                    FoundAlias = true
                    Prediction.Text = v2
                    CommandArgs = v2.Args or {}
                    break
                end
    
                if (FoundAlias) then
                    break
                end
            end
        end
    end

    for i, v in next, Args do -- make it get more players after i space out
        if (i > 1 and v ~= "") then
            local Predict = ""
            if (#CommandArgs >= 1) then
                for i2, v2 in next, CommandArgs do
                    if (v2:lower() == "player") then
                        Predict = Utils.GetPlayerArgs(v) or Predict;
                    else
                        Predict = Utils.MatchSearch(v, v2) and v2 or Predict
                    end
                end
            else
                Predict = Utils.GetPlayerArgs(v) or Predict;
            end
            Prediction.Text = string.sub(Text, 1, #Text - #Args[#Args]) .. Predict
            local split = v:split(",");
            if (next(split)) then
                for i2, v2 in next, split do
                    if (i2 > 1 and v2 ~= "") then
                        local PlayerName = Utils.GetPlayerArgs(v2)
                        Prediction.Text = string.sub(Text, 1, #Text - #split[#split]) .. (PlayerName or "")
                    end
                end
            end
        end
    end

    if (string.find(Text, "\t")) then -- remove tab from preditction text also
        CommandBar.Input.Text = PredictionText
        CommandBar.Input.CursorPosition = #CommandBar.Input.Text + 1
    end
end))

if (ChatBar) then
    AddConnection(ChatBar:GetPropertyChangedSignal("Text"):Connect(function() -- todo: add detection for /e
        local Text = string.lower(ChatBar.Text)
        local Prediction = PredictionClone
        local PredictionText = PredictionClone.Text
    
        local Args = string.split(table.concat(table.shift(Text:split(""))), " ");
    
        Prediction.Text = ""
        if (not string.startsWith(Text, Prefix)) then
            return
        end
    
        local FoundCommand = false
        local FoundAlias = false
        CommandArgs = CommandArgs or {}
        if (not rawget(CommandsTable, Args[1])) then
            for _, v in next, CommandsTable do
                local CommandName = v.Name
                local Aliases = v.Aliases
                local FoundAlias
        
                if (Utils.MatchSearch(Args[1], CommandName)) then -- better search
                    Prediction.Text = Prefix .. CommandName
                    FoundCommand = true
                    CommandArgs = v.Args or {}
                    break
                end
        
                for _, v2 in next, Aliases do
                    if (Utils.MatchSearch(Args[1], v2)) then
                        FoundAlias = true
                        Prediction.Text = v2
                        CommandArgs = v.Args or {}
                        break
                    end
        
                    if (FoundAlias) then
                        break
                    end
                end
            end
        end
    
        for i, v in next, Args do -- make it get more players after i space out
            if (i > 1 and v ~= "") then
                local Predict = ""
                if (#CommandArgs >= 1) then
                    for i2, v2 in next, CommandArgs do
                        if (v2:lower() == "player") then
                            Predict = Utils.GetPlayerArgs(v) or Predict;
                        else
                            Predict = Utils.MatchSearch(v, v2) and v2 or Predict
                        end
                    end
                else
                    Predict = Utils.GetPlayerArgs(v) or Predict;
                end
                Prediction.Text = string.sub(Text, 1, #Text - #Args[#Args]) .. Predict
                local split = v:split(",");
                if (next(split)) then
                    for i2, v2 in next, split do
                        if (i2 > 1 and v2 ~= "") then
                            local PlayerName = Utils.GetPlayerArgs(v2)
                            Prediction.Text = string.sub(Text, 1, #Text - #split[#split]) .. (PlayerName or "")
                        end
                    end
                end
            end
        end
    
        if (string.find(Text, "\t")) then -- remove tab from preditction text also
            ChatBar.Text = PredictionText
            ChatBar.CursorPosition = #ChatBar.Text + 2
        end
    end))
end
--END IMPORT [uimore]

WideBar = false
Draggable = false
AddConnection(CommandBar.Input.FocusLost:Connect(function()
    local Text = string.trim(CommandBar.Input.Text);
    local CommandArgs = Text:split(" ");

    CommandBarOpen = false

    if (not Draggable) then
        Utils.TweenAllTrans(CommandBar, .5)
        Utils.Tween(CommandBar, "Quint", "Out", .5, {
            Position = UDim2.new(0.5, WideBar and -200 or -100, 1, 5); -- tween 5
        })
    end

    local Command, LoadedCommand = CommandArgs[1], LoadCommand(CommandArgs[1]);
    local Args = table.shift(CommandArgs);

    if (LoadedCommand and Command ~= "") then
        if (LoadedCommand.ArgsNeeded > #Args) then
            return Utils.Notify(plr, "Error", ("Insuficient Args (you need %d)"):format(LoadedCommand.ArgsNeeded))
        end

        local Success, Err = pcall(function()
            local Executed = LoadedCommand.Function()(LocalPlayer, Args, LoadedCommand.CmdExtra);
            if (Executed) then
                Utils.Notify(plr, "Command", Executed);
            end
            if (#LastCommand == 3) then
                LastCommand = table.shift(LastCommand);
            end
            LastCommand[#LastCommand + 1] = {Command, LocalPlayer, Args, LoadedCommand.CmdExtra}
        end);
        if (not Success and Debug) then
            warn(Err);
        end
    else
        Utils.Notify(plr, "Error", ("couldn't find the command %s"):format(Command));
    end
end), Connections.UI, true);

local CurrentPlayers = Players:GetPlayers();

local PlayerAdded = function(plr)
    RespawnTimes[plr.Name] = tick();
    plr.CharacterAdded:Connect(function()
        RespawnTimes[plr.Name] = tick();
    end)
    local Tag = Utils.CheckTag(plr);
    if (Tag and plr ~= LocalPlayer) then
        Tag.Player = plr
        Utils.Notify(LocalPlayer, "Admin", ("%s (%s) has joined"):format(Tag.Name, Tag.Tag));
        Utils.AddTag(Tag);
    end
end

table.forEach(CurrentPlayers, function(i,v)
    PlrChat(i,v);
    PlayerAdded(v);
end);

AddConnection(Players.PlayerAdded:Connect(function(plr)
    PlrChat(#Connections.Players + 1, plr);
    PlayerAdded(plr);
end))

AddConnection(Players.PlayerRemoving:Connect(function(plr)
    if (Connections.Players[plr.Name]) then
        if (Connections.Players[plr.Name].ChatCon) then
            Connections.Players[plr.Name].ChatCon:Disconnect();
        end
        Connections.Players[plr.Name] = nil
    end
    if (RespawnTimes[plr.Name]) then
        RespawnTimes[plr.Name] = nil
    end
end))

getgenv().F_A = {
    Loaded = true,
    Utils = Utils,
    PluginLibrary = PluginLibrary
}

Utils.Notify(LocalPlayer, "Loaded", ("script loaded in %.3f seconds"):format((tick() or os.clock()) - start));
Utils.Notify(LocalPlayer, "Welcome", "'cmds' to see all of the commands");
Utils.Notify(LocalPlayer,"gg.xlui", "Thank you for using 777 admin ");
