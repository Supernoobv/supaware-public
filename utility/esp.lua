assert(Drawing, "missing dependency: 'Drawing'");

getgenv().SUPAESPLOADED = true
getgenv().BOX_COLOR = Color3.new(1, 1, 1)
getgenv().BOX_OUTLINE_COLOR = Color3.new(1, 1, 1)
getgenv().NAME_COLOR = Color3.new(1, 1, 1)
getgenv().DISTANCE_COLOR = Color3.new(1, 1, 1)


local commontrinkets = {}
local gems = {}
local artifacts = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local espPlayerCache = {}
local espObjectCache = {}

local camera = workspace.CurrentCamera
local getCFrame = workspace.GetModelCFrame
local wtvp = camera.WorldToViewportPoint

local Player = Players.LocalPlayer

local trinketesp = false
local gemesp = false
local scrollesp = false
local artifactesp = false

local trinketesptoggled = false
local playerresp = false
local esp = {}

local function drawPlayerEsp(player)
    local esp = {}

    esp.boxOutline = Drawing.new("Square")
    esp.boxOutline.Color = getgenv().BOX_OUTLINE_COLOR
    esp.boxOutline.Thickness = 3
    esp.boxOutline.Filled = false

    esp.box = Drawing.new("Square")
    esp.box.Color = getgenv().BOX_COLOR
    esp.box.Thickness = 1
    esp.box.Filled = false

    esp.name = Drawing.new("Text")
    esp.name.Color = getgenv().NAME_COLOR
    esp.name.Font = 1
    esp.name.Outline = true;
    esp.name.Center = true;
    esp.name.Size = 13;

    esp.distance = Drawing.new("Text");
    esp.distance.Color = getgenv().DISTANCE_COLOR;
    esp.distance.Font = 1
    esp.distance.Outline = true;
    esp.distance.Center = true;
    esp.distance.Size = 13;

    esp.HealthBarOutline = Drawing.new("Square")
    esp.HealthBarOutline.Thickness = 3
    esp.HealthBarOutline.Filled = false
    esp.HealthBarOutline.Color = getgenv().BOX_OUTLINE_COLOR

    esp.HealthBar = Drawing.new("Square")
    esp.HealthBar.Thickness = 3
    esp.HealthBar.Filled = false

    espPlayerCache[player] = esp
end


local function getObjectInfo(object)
    local color = Color3.fromRGB(255, 255, 255)
    local name = ""

    if getgenv().ROGUELINEAGE then
        local meshids = {
            ["rbxassetid://5196577540"] = { "Old Amulet", Color3.fromRGB(200, 200, 200) },
            ["rbxassetid://5196782997"] = { "Old Ring", Color3.fromRGB(200, 200, 200) },
            ["rbxassetid://5196776695"] = { "Ring", Color3.fromRGB(200, 200, 200) },
            ["rbxassetid://5204003946"] = { "Goblet", Color3.fromRGB(200, 200, 200) },
            ["rbxassetid://5204453430"] = { "Scroll", Color3.fromRGB(255, 170, 80) },
            ["rbxassetid://923469333"] = { "Candy", Color3.fromRGB(255, 170, 80) },
            ["rbxassetid://2520762076"] = { "Howler Friend", Color3.fromRGB(255, 255, 255) },
            ["rbxassetid://5196551436"] = { "Amulet", Color3.fromRGB(200, 200, 200) },
        }

        if object:IsA("UnionOperation") and (object.MeshSize - Vector3.new(0.281, 2.611, 1.5)).Magnitude <= 0.2 then
            color = Color3.fromRGB(100, 0, 255)
            name = "Lannis Amulet/WKA"
        elseif object:IsA("UnionOperation") and (object.MeshSize - Vector3.new(0.956, 0.955, 0.933)).Magnitude <= 0.2 then
            color = Color3.fromRGB(30, 30, 30)
            name = "Nightstone"
        elseif object:IsA("MeshPart") and meshids[object.MeshId] then
            color = meshids[object.MeshId][2]
            name = meshids[object.MeshId][1]
        elseif object:FindFirstChildOfClass("SpecialMesh") then
            local mesh = object:FindFirstChildOfClass("SpecialMesh")

            local id = mesh.MeshId

            if id == "rbxassetid://%202877143560%20" and object.BrickColor == BrickColor.new("Cadet blue") then
                color = object.Color
                name = "Diamond"
            elseif id == "rbxassetid://%202877143560%20" and object.BrickColor == BrickColor.new("Forest green") then
                color = object.Color
                name = "Emerald"
            elseif id == "rbxassetid://%202877143560%20" and object.BrickColor == BrickColor.new("Institutiional white") then
                color = object.Color
                name = "Opal"
            elseif id == "rbxassetid://%202877143560%20" and object.BrickColor == BrickColor.new("Lapis") then
                color = object.Color
                name = "Sapphire"
            elseif id == "rbxassetid://%202877143560%20" and object.BrickColor == BrickColor.new("Hot pink") then
                color = object.Color
                name = "Rift Gem"
            end
        elseif object:FindFirstChildOfClass("Attachment") and object.Attachment:FindFirstChildOfClass("ParticleEmitter") then
            local particle = object.Attachment:FindFirstChildOfClass("ParticleEmitter")

            if particle.Texture == "rbxassetid://1536547385" then
                color = Color3.fromRGB(0, 50, 255)
                name = "PD/MA/Azael Horn"
            end
        elseif object:FindFirstChild("OrbParticle") then
            if object.BrickColor == BrickColor.new("Mulberry") then
                color = Color3.fromRGB(151, 0, 52)
                name = "???" 
            elseif object.BrickColor == BrickColor.new("Persimmon") then
                color = Color3.fromRGB(0, 255, 255)
                name = "Ice Essence"
            end
        end
    end

    return color, name
end

local function drawObjectEsp(object)
    local esp = {}

    local color, name = getObjectInfo(object)

    esp.boxOutline = Drawing.new("Square")
    esp.boxOutline.Color = color
    esp.boxOutline.Thickness = 3
    esp.boxOutline.Filled = false

    esp.box = Drawing.new("Square")
    esp.box.Color = color
    esp.box.Thickness = 1
    esp.box.Filled = false

    esp.name = Drawing.new("Text")
    esp.name.Color = color
    esp.name.Font = 1
    esp.name.Outline = true;
    esp.name.Center = true;
    esp.name.Size = 13;

    esp.distance = Drawing.new("Text");
    esp.distance.Color = color
    esp.distance.Font = 1
    esp.distance.Outline = true;
    esp.distance.Center = true;
    esp.distance.Size = 13;

    espObjectCache[object] = esp
end


local function removePlayerEsp(player)
    for _, drawing in next, espPlayerCache[player] do
        drawing:Remove();
    end
    espPlayerCache[player] = nil;
end

local function removeObjectEsp(object)
    for _, drawing in next, espObjectCache[object] do
        drawing:Remove();
    end
    espObjectCache[object] = nil;
end


local function updateEsp()
    for player, esp in pairs(espPlayerCache) do
        local character = player and player.Character;


        if character and getgenv().playerEsp then
            local position, visible = wtvp(camera, character.HumanoidRootPart.Position);

            if position.Z >= getgenv().maxPlayerRadius then
                esp.box.Visible = false;
                esp.boxOutline.Visible = false;
                esp.name.Visible = false;
                esp.distance.Visible = false;
                continue
            end
            
            if visible then
                local hum = character:FindFirstChildOfClass("Humanoid")
                local health = hum.Health
                local maxhealth = hum.MaxHealth

                local scaleFactor = 1 / (position.Z * math.tan(math.rad(camera.FieldOfView * 0.5)) * 2) * 100;
                local width, height = math.floor(35 * scaleFactor), math.floor(50 * scaleFactor);
                local x, y = math.floor(position.X), math.floor(position.Y);

                esp.box.Size = Vector2.new(width, height);
                esp.box.Position = Vector2.new(math.floor(x - width * 0.5), math.floor(y - height * 0.5));
                esp.boxOutline.Color = getgenv().BOX_OUTLINE_COLOR

                esp.boxOutline.Size = esp.box.Size;
                esp.boxOutline.Position = esp.box.Position;

                esp.name.Text = getgenv().healthEsp and player.Name .. " | (" .. math.floor(health) .. "/" .. maxhealth .. ")" or
                player.Name
                esp.name.Position = Vector2.new(x, math.floor(y - height * 0.5 - esp.name.TextBounds.Y));

                esp.distance.Text = "(" .. math.floor(position.Z) .. ")";
                esp.distance.Position = Vector2.new(x, math.floor(y + height * 0.5));

                esp.box.Visible = getgenv().boxEsp;
                esp.boxOutline.Visible = getgenv().boxEsp;
                esp.name.Visible = true
                esp.distance.Visible = getgenv().distanceEsp


            else
                esp.box.Visible = false;
                esp.boxOutline.Visible = false;
                esp.name.Visible = false;
                esp.distance.Visible = false;
            end

            esp.distance.Color = getgenv().DISTANCE_COLOR;
            esp.name.Color = getgenv().NAME_COLOR
            esp.boxOutline.Color = getgenv().BOX_OUTLINE_COLOR
            esp.box.Color = getgenv().BOX_COLOR

            esp.name.Size = getgenv().NAME_SIZE
            esp.distance.Size = getgenv().DISTANCE_SIZE;


        else
            esp.box.Visible = false;
            esp.boxOutline.Visible = false;
            esp.name.Visible = false;
            esp.distance.Visible = false;
        end
    end
end

local function updateObjectEsp()
    for object, esp in pairs(espObjectCache) do
        local cframe = object:IsA("BasePart") and object.CFrame or object:IsA("Model") and getCFrame(object);
        local position, visible = wtvp(camera, cframe.Position);

        local color, name = getObjectInfo(object)

        if getgenv().ROGUELINEAGE and getgenv().objectEsp then
            local shouldrender = true
            if #commontrinkets > 0 and table.find(commontrinkets, name) and not trinketesp then
                shouldrender = false
            elseif #gems > 0 and table.find(gems, name) and not gemesp then
                shouldrender = false
            elseif #artifacts > 0 and table.find(artifacts, name) and not artifactesp then
                shouldrender = false
            end

            if name == "Scroll" and not scrollesp then
                shouldrender = false
            end

            if not shouldrender then
                esp.box.Visible = false;
                esp.boxOutline.Visible = false;
                esp.name.Visible = false;
                esp.distance.Visible = false;

                continue
            end
        end

        if name == "" then continue end

        if getgenv().objectEsp and position.Z <= getgenv().maxObjectRadius and visible then
            local scaleFactor = 1 / (position.Z * math.tan(math.rad(camera.FieldOfView * 0.5)) * 2) * 100;
            local width, height = math.floor(15 * scaleFactor), math.floor(15 * scaleFactor);
            local x, y = math.floor(position.X), math.floor(position.Y);

            esp.box.Size = Vector2.new(width, height);
            esp.box.Position = Vector2.new(math.floor(x - width * 0.5), math.floor(y - height * 0.5));

            esp.boxOutline.Size = esp.box.Size;
            esp.boxOutline.Position = esp.box.Position;

            esp.name.Text = name;
            esp.name.Position = Vector2.new(x, math.floor(y - height * 0.5 - esp.name.TextBounds.Y));

            esp.distance.Text = "(" .. math.floor(position.Z) .. ")";
            esp.distance.Position = Vector2.new(x, math.floor(y + height * 0.5));

            esp.box.Visible = getgenv().boxEsp;
            esp.boxOutline.Visible = getgenv().boxEsp;
            esp.name.Visible = getgenv().objectEsp;
            esp.distance.Visible = getgenv().distanceEsp;

            esp.name.Size = getgenv().NAME_SIZE
            esp.distance.Size = getgenv().DISTANCE_SIZE;
        else
            esp.box.Visible = false;
            esp.boxOutline.Visible = false;
            esp.name.Visible = false;
            esp.distance.Visible = false;
        end
    end
end

local LastRefresh = tick()

Players.PlayerAdded:Connect(drawPlayerEsp);
Players.PlayerRemoving:Connect(removePlayerEsp);

local esprefresh

local trinketrefresh

for idx, player in ipairs(Players:GetPlayers()) do
    if idx ~= 1 then drawPlayerEsp(player); end
end

if getgenv().ROGUELINEAGE then
    local trinkets = workspace:FindFirstChild("Trinkets")

    for _, v in pairs(trinkets:GetChildren()) do
        drawObjectEsp(v)
    end

    trinkets.ChildAdded:Connect(drawObjectEsp)

    trinkets.ChildRemoved:Connect(removeObjectEsp)

    commontrinkets = {"Amulet", "Goblet", "Old Amulet", "Old Ring", "Ring", "???", "Candy"}
    gems = {"Emerald", "Opal", "Ruby", "Sapphire", "Diamond"}
    artifacts = {"PD/MA/Azael Horn", "Howler Friend", "Rift Gem", "Ice Essence", "Nightstone", "Lannis Amulet/WKA"}
end

function esp.Toggle(property, bool)
    if getgenv().ROGUELINEAGE then
        if property == "Common" then
            trinketesp = bool
        elseif property == "Gems" then
            gemesp = bool
        elseif property == "Scrolls" then
            scrollesp = bool
        elseif property == "Artifacts" then
            artifactesp = bool
        elseif property == "TrinketEsp" then 
            trinketesptoggled = bool
            task.wait(.1)
            if bool then
                trinketrefresh = RunService.Heartbeat:Connect(function()
                    if (tick() - LastRefresh) > (getgenv().TRINKET_REFRESHRATE) then
                        updateObjectEsp(object)
                    end
                end)
            else 
                trinketrefresh:Disconnect()
                trinketrefresh = nil
            end
        end
    end
    if property == "playerEsp" then
        playerresp = bool
        task.wait(.1)
        if bool then
            esprefresh = RunService.RenderStepped:Connect(updateEsp);
        else 
            esprefresh:Disconnect()
            esprefresh = nil
        end
    end
end

return esp

