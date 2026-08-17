-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local FashionIconID = 4483362458 

local Window = Rayfield:CreateWindow({
   Name = "0 Dress Hub 🛍️",
   LoadingTitle = "Carregando 0 Dress Hub...",
   LoadingSubtitle = "Edição Performance & Moda",
   Theme = "Amethyst",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
   Image = FashionIconID
})

local Tab = Window:CreateTab("Segredos", FashionIconID)

local AutoFarmEnabled = false
local AntiAFKEnabled = false
local RGBEnabled = false
local PhotoModeEnabled = false

-- Funções Auxiliares
local function GetPlayerByName(name)
    if not name or name == "" then return nil end
    name = string.lower(name)
    for _, p in ipairs(game.Players:GetPlayers()) do
        if string.find(string.lower(p.Name), name) or string.find(string.lower(p.DisplayName), name) then
            return p
        end
    end
    return nil
end

-- SEÇÃO 1: AUTO FARM E ANTIAFK
Tab:CreateSection("Auto Farm e Anti-AFK")

Tab:CreateToggle({
   Name = "▶️ Auto Farm (Pegar Todo Money)",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
       AutoFarmEnabled = Value
       task.spawn(function()
           while AutoFarmEnabled do
               task.wait(0.5)
               local lp = game.Players.LocalPlayer
               local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
               
               if hrp then
                   for _, v in ipairs(workspace:GetDescendants()) do
                       if not AutoFarmEnabled then break end
                       if v:IsA("BasePart") then
                           local name = string.lower(v.Name)
                           if (string.find(name, "coin") or string.find(name, "moeda") or string.find(name, "money") or string.find(name, "cash")) then
                               hrp.CFrame = v.CFrame
                               task.wait(0.2)
                           end
                       end
                   end
               end
           end
       end)
   end,
})

Tab:CreateToggle({
   Name = "🛡️ Anti-AFK (Não cair do jogo)",
   CurrentValue = false,
   Flag = "AntiAFKToggle",
   Callback = function(Value)
       AntiAFKEnabled = Value
       if AntiAFKEnabled then
           task.spawn(function()
               while AntiAFKEnabled do
                   task.wait(60)
                   local VirtualUser = game:GetService("VirtualUser")
                   VirtualUser:CaptureController()
                   VirtualUser:ClickButton2(Vector2.new(0, 0))
               end
           end)
       end
   end,
})

-- SEÇÃO 2: MOVIMENTAÇÃO & VANTAGENS
Tab:CreateSection("⚡ Velocidade & Movimentação")

Tab:CreateSlider({
   Name = "🏃 Velocidade (WalkSpeed)",
   Range = {16, 120},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
       local char = game.Players.LocalPlayer.Character
       if char and char:FindFirstChildOfClass("Humanoid") then
           char:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
       end
   end,
})

-- SEÇÃO 3: TELEPORTES RÁPIDOS
Tab:CreateSection("📍 Teleportes Rápidos")

local function TeleportTo(cframe)
    local char = game.Players.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = cframe
    end
end

Tab:CreateButton({
   Name = "💄 Teleporte: Área de Make / Cabelo",
   Callback = function()
       -- Mude as coordenadas para o local exato no mapa
       TeleportTo(CFrame.new(0, 5, 0))
   end,
})

Tab:CreateButton({
   Name = "👗 Teleporte: Área de Roupas / Salão",
   Callback = function()
       -- Mude as coordenadas para o local exato no mapa
       TeleportTo(CFrame.new(50, 5, 0))
   end,
})

Tab:CreateButton({
   Name = "👠 Teleporte: Passarela / Runway",
   Callback = function()
       -- Mude as coordenadas para o local exato no mapa
       TeleportTo(CFrame.new(0, 5, 50))
   end,
})

-- SEÇÃO 4: FUNÇÃO TROLAGEM
Tab:CreateSection("Função Trolagem 😜")

Tab:CreateButton({
   Name = "👻 Modo Sem Cabeça",
   Callback = function()
       local char = game.Players.LocalPlayer.Character
       if char and char:FindFirstChild("Head") then
           char.Head.Transparency = 1
           for _, v in ipairs(char.Head:GetChildren()) do
               if v:IsA("Decal") then v.Transparency = 1 end
           end
       end
   end,
})

Tab:CreateButton({
   Name = "🧍 Modo Manequim",
   Callback = function()
       local char = game.Players.LocalPlayer.Character
       if char then
           for _, part in ipairs(char:GetChildren()) do
               if part:IsA("BasePart") then
                   part.Material = Enum.Material.SmoothPlastic
                   part.Color = Color3.fromRGB(200, 200, 200)
               elseif part:IsA("Clothing") or part:IsA("ShirtGraphic") or part:IsA("Accessory") then
                   part:Destroy()
               end
           end
       end
   end,
})

Tab:CreateToggle({
   Name = "🌈 RGB no Personagem",
   CurrentValue = false,
   Flag = "RgbToggle",
   Callback = function(Value)
       RGBEnabled = Value
       task.spawn(function()
           while RGBEnabled do
               local color = Color3.fromHSV((tick() % 5) / 5, 1, 1)
               local char = game.Players.LocalPlayer.Character
               if char then
                   for _, part in ipairs(char:GetChildren()) do
                       if part:IsA("BasePart") then part.Color = color end
                   end
               end
               task.wait(0.05)
           end
       end)
   end,
})

-- SEÇÃO 5: OPÇÕES DE CÂMERA
Tab:CreateSection("🎥 Opções de Câmera")

Tab:CreateToggle({
   Name = "📸 Modo Foto (Esconder Interface)",
   CurrentValue = false,
   Flag = "PhotoModeToggle",
   Callback = function(Value)
       PhotoModeEnabled = Value
       local CoreGui = game:GetService("StarterGui")
       local PlayerGui = game.Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
       
       pcall(function()
           CoreGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, not PhotoModeEnabled)
       end)
       
       if PlayerGui then
           for _, gui in ipairs(PlayerGui:GetChildren()) do
               if gui:IsA("ScreenGui") and gui.Name ~= "Rayfield" then
                   gui.Enabled = not PhotoModeEnabled
               end
           end
       end
   end,
})

Tab:CreateSlider({
   Name = "🔍 Ajuste de FOV (Zoom/Visão)",
   Range = {30, 120},
   Increment = 1,
   Suffix = " FOV",
   CurrentValue = 70,
   Flag = "FovSlider",
   Callback = function(Value)
       workspace.CurrentCamera.FieldOfView = Value
   end,
})

-- SEÇÃO 6: COPIAR ESTILO COMPLETO
Tab:CreateSection("Copiar Estilo")

local TargetNickMake = ""
Tab:CreateInput({
   Name = "Nick (Copiar Make)",
   PlaceholderText = "Parte do Nick...",
   RemoveTextOnFocusLost = false,
   Callback = function(Text) TargetNickMake = Text end,
})

Tab:CreateButton({
   Name = "🪞 Copiar Make",
   Callback = function()
       local targetPlayer = GetPlayerByName(TargetNickMake)
       local localChar = game.Players.LocalPlayer.Character
       if targetPlayer and targetPlayer.Character and localChar then
           local targetHead = targetPlayer.Character:FindFirstChild("Head")
           local localHead = localChar:FindFirstChild("Head")
           if targetHead and localHead then
               for _, d in ipairs(localHead:GetChildren()) do if d:IsA("Decal") then d:Destroy() end end
               for _, d in ipairs(targetHead:GetChildren()) do if d:IsA("Decal") then d:Clone().Parent = localHead end end
               Rayfield:Notify({Title = "Sucesso", Content = "Maquiagem copiada!", Duration = 2, Image = FashionIconID})
           end
       else
           Rayfield:Notify({Title = "Erro", Content = "Jogador não encontrado!", Duration = 2, Image = FashionIconID})
       end
   end,
})

local TargetNickOutfit = ""
Tab:CreateInput({
   Name = "Nick (Copiar Roupa, Cabelo e Acessórios)",
   PlaceholderText = "Parte do Nick...",
   RemoveTextOnFocusLost = false,
   Callback = function(Text) TargetNickOutfit = Text end,
})

Tab:CreateButton({
   Name = "👗 Copiar Look Completo (Roupa + Acessórios)",
   Callback = function()
       local targetPlayer = GetPlayerByName(TargetNickOutfit)
       local localChar = game.Players.LocalPlayer.Character
       if targetPlayer and targetPlayer.Character and localChar then
           -- Limpa roupas e acessórios atuais
           for _, item in ipairs(localChar:GetChildren()) do
               if item:IsA("Clothing") or item:IsA("ShirtGraphic") or item:IsA("Accessory") then
                   item:Destroy()
               end
           end
           -- Copia roupas e acessórios do jogador alvo
           for _, item in ipairs(targetPlayer.Character:GetChildren()) do
               if item:IsA("Clothing") or item:IsA("ShirtGraphic") or item:IsA("Accessory") then
                   item:Clone().Parent = localChar
               end
           end
           Rayfield:Notify({Title = "Sucesso", Content = "Look completo copiado!", Duration = 2, Image = FashionIconID})
       else
           Rayfield:Notify({Title = "Erro", Content = "Jogador não encontrado!", Duration = 2, Image = FashionIconID})
       end
   end,
})

