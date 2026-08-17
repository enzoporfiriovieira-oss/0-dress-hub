local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "0 Dress Hub",
   LoadingTitle = "0 Dress Hub",
   LoadingSubtitle = "by You",
   Theme = "Amethyst",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- VARIÁVEIS DE CONTROLE
local AutoFarm = false
local DesiredSpeed = 16
local SpeedConnection = nil
local TargetNickMake = ""
local TargetNickRoupa = ""
local SpotlightLight = nil
local CameraLocking = false
local CameraConnection = nil

-- FUNÇÃO AUXILIAR: BUSCAR JOGADOR POR NICK PARCIAL
local function GetPlayerByPartialName(name)
   if name == "" then return nil end
   name = name:lower()
   for _, player in ipairs(game.Players:GetPlayers()) do
      if player.Name:lower():find(name) or player.DisplayName:lower():find(name) then
         return player
      end
   end
   return nil
end

-- FUNÇÃO VELOCIDADE
local function ApplySpeed(speed)
    DesiredSpeed = speed
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        humanoid.WalkSpeed = speed
        
        if SpeedConnection then SpeedConnection:Disconnect() end
        SpeedConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if humanoid.WalkSpeed ~= DesiredSpeed then
                humanoid.WalkSpeed = DesiredSpeed
            end
        end)
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    if SpeedConnection then SpeedConnection:Disconnect() end
    SpeedConnection = nil
    task.wait(0.5)
    ApplySpeed(DesiredSpeed)
end)

-- TAB 1: AUTOMATIZAÇÃO
local AutoTab = Window:CreateTab("Automação", 4483362458)

AutoTab:CreateToggle({
   Name = "Auto Farm (Coleta de Moedas)",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
      AutoFarm = Value
      if AutoFarm then
         task.spawn(function()
            while AutoFarm do
               local char = game.Players.LocalPlayer.Character
               local root = char and char:FindFirstChild("HumanoidRootPart")
               
               if root then
                  local itemsToCollect = {}
                  for _, item in ipairs(workspace:GetDescendants()) do
                     if item:IsA("BasePart") or item:IsA("Model") then
                        local lowerName = item.Name:lower()
                        if lowerName:find("coin") or lowerName:find("currency") or lowerName:find("money") or lowerName:find("gem") then
                           table.insert(itemsToCollect, item)
                        end
                     end
                  end

                  for _, item in ipairs(itemsToCollect) do
                     if not AutoFarm then break end
                     if item and item.Parent then
                        local targetCFrame = item:IsA("Model") and item:GetPivot() or item.CFrame
                        if targetCFrame and root then
                           root.CFrame = targetCFrame
                           task.wait(0.15)
                        end
                     end
                  end
               end
               task.wait(0.5)
            end
         end)
      end
   end,
})

AutoTab:CreateButton({
   Name = "Ativar Anti-AFK",
   Callback = function()
      local VirtualUser = game:GetService("VirtualUser")
      game:GetService("Players").LocalPlayer.Idled:Connect(function()
         VirtualUser:CaptureController()
         VirtualUser:ClickButton2(Vector2.new())
      end)
      Rayfield:Notify({ Title = "0 Dress Hub", Content = "Anti-AFK Ativado!", Duration = 3 })
   end,
})

-- TAB 2: JOGADOR & ESTILO
local PlayerTab = Window:CreateTab("Jogador & Estilo", 4483362458)

PlayerTab:CreateInput({
   Name = "Nick do Jogador (Make)",
   PlaceholderText = "Digite o Nick aqui...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      TargetNickMake = Text
   end,
})

PlayerTab:CreateButton({
   Name = "➡️ Copiar Make",
   Callback = function()
      local targetPlayer = GetPlayerByPartialName(TargetNickMake)
      local myChar = game.Players.LocalPlayer.Character

      if targetPlayer and targetPlayer.Character and myChar then
         local targetHead = targetPlayer.Character:FindFirstChild("Head")
         local myHead = myChar:FindFirstChild("Head")

         if targetHead and myHead then
            for _, item in ipairs(myHead:GetChildren()) do
               if item:IsA("Decal") or item:IsA("Texture") then
                  item:Destroy()
               end
            end
            for _, item in ipairs(targetHead:GetChildren()) do
               if item:IsA("Decal") or item:IsA("Texture") then
                  item:Clone().Parent = myHead
               end
            end
            Rayfield:Notify({ Title = "0 Dress Hub", Content = "Make copiada de " .. targetPlayer.DisplayName, Duration = 3 })
         end
      else
         Rayfield:Notify({ Title = "Erro", Content = "Jogador não encontrado!", Duration = 3 })
      end
   end,
})

PlayerTab:CreateInput({
   Name = "Nick do Jogador (Roupa)",
   PlaceholderText = "Digite o Nick aqui...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      TargetNickRoupa = Text
   end,
})

PlayerTab:CreateButton({
   Name = "➡️ Copiar Roupa",
   Callback = function()
      local targetPlayer = GetPlayerByPartialName(TargetNickRoupa)
      local myChar = game.Players.LocalPlayer.Character

      if targetPlayer and targetPlayer.Character and myChar then
         for _, item in ipairs(myChar:GetChildren()) do
            if item:IsA("Clothing") or item:IsA("ShirtGraphic") or item:IsA("Accessory") then
               item:Destroy()
            end
         end
         for _, item in ipairs(targetPlayer.Character:GetChildren()) do
            if item:IsA("Clothing") or item:IsA("ShirtGraphic") or item:IsA("Accessory") then
               item:Clone().Parent = myChar
            end
         end
         Rayfield:Notify({ Title = "0 Dress Hub", Content = "Roupa copiada de " .. targetPlayer.DisplayName, Duration = 3 })
      else
         Rayfield:Notify({ Title = "Erro", Content = "Jogador não encontrado!", Duration = 3 })
      end
   end,
})

PlayerTab:CreateSlider({
   Name = "Velocidade de Correr (WalkSpeed)",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      ApplySpeed(Value)
   end,
})

-- TAB 3: DESBLOQUEIOS VIP (LOCAL)
local VipTab = Window:CreateTab("VIP & Desbloqueios", 4483362458)

VipTab:CreateButton({
   Name = "Desbloquear Salas/Itens VIP (Local)",
   Callback = function()
      for _, obj in ipairs(workspace:GetDescendants()) do
         if obj:IsA("BasePart") and (obj.Name:lower():find("vip") or obj.Name:lower():find("door")) then
            obj.CanCollide = false
            obj.Transparency = 0.5
         end
      end
      Rayfield:Notify({ Title = "0 Dress Hub", Content = "Barreiras VIP desativadas localmente!", Duration = 3 })
   end,
})

-- TAB 4: TELEPORTES
local TeleportTab = Window:CreateTab("Teleportes", 4483362458)

local function TeleportTo(cframe)
   local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
   if root then
      root.CFrame = cframe
   end
end

TeleportTab:CreateButton({
   Name = "TP: Passarela (Runway)",
   Callback = function()
      local runway = workspace:FindFirstChild("Runway", true) or workspace:FindFirstChild("Stage", true)
      if runway then
         TeleportTo(runway:GetPivot())
      else
         Rayfield:Notify({ Title = "Erro", Content = "Passarela não encontrada!", Duration = 3 })
      end
   end,
})

TeleportTab:CreateButton({
   Name = "TP: Área VIP",
   Callback = function()
      local vipArea = workspace:FindFirstChild("VIP", true) or workspace:FindFirstChild("VipRoom", true)
      if vipArea then
         TeleportTo(vipArea:GetPivot())
      else
         Rayfield:Notify({ Title = "Erro", Content = "Área VIP não encontrada!", Duration = 3 })
      end
   end,
})

TeleportTab:CreateButton({
   Name = "TP: Salão Principal",
   Callback = function()
      local lobby = workspace:FindFirstChild("Lobby", true) or workspace:FindFirstChild("SpawnLocation", true)
      if lobby then
         TeleportTo(lobby:GetPivot())
      end
   end,
})

-- TAB 5: VISUAL & CÂMERA
local VisualTab = Window:CreateTab("Visual & Câmera", 4483362458)

VisualTab:CreateSlider({
   Name = "Ajuste de Campo de Visão (FOV)",
   Range = {70, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = 70,
   Flag = "FOVSlider",
   Callback = function(Value)
      workspace.CurrentCamera.FieldOfView = Value
   end,
})

-- ADIÇÃO 1: EFEITO ESPELHO / HOLOFOTE DE CAMERIM
VisualTab:CreateToggle({
   Name = "Efeito Espelho (Luz de Camarim)",
   CurrentValue = false,
   Flag = "SpotlightToggle",
   Callback = function(Value)
      local char = game.Players.LocalPlayer.Character
      local head = char and char:FindFirstChild("Head")

      if Value then
         if head and not SpotlightLight then
            SpotlightLight = Instance.new("PointLight")
            SpotlightLight.Name = "DressCamarimLight"
            SpotlightLight.Color = Color3.fromRGB(255, 240, 220)
            SpotlightLight.Range = 25
            SpotlightLight.Brightness = 3
            SpotlightLight.Parent = head
         end
      else
         if SpotlightLight then
            SpotlightLight:Destroy()
            SpotlightLight = nil
         end
      end
   end,
})

-- ADIÇÃO 2: FIXADOR DE CÂMERA NO ROSTO
VisualTab:CreateToggle({
   Name = "Fixar Câmera no Rosto (Foco Make)",
   CurrentValue = false,
   Flag = "CamLockToggle",
   Callback = function(Value)
      CameraLocking = Value
      local camera = workspace.CurrentCamera
      local RunService = game:GetService("RunService")

      if CameraLocking then
         CameraConnection = RunService.RenderStepped:Connect(function()
            local char = game.Players.LocalPlayer.Character
            local head = char and char:FindFirstChild("Head")
            if head and CameraLocking then
               camera.CameraType = Enum.CameraType.Scriptable
               camera.CFrame = head.CFrame * CFrame.new(0, 0, -3.5) * CFrame.Angles(0, math.rad(180), 0)
            end
         end)
      else
         if CameraConnection then
            CameraConnection:Disconnect()
            CameraConnection = nil
         end
         camera.CameraType = Enum.CameraType.Custom
      end
   end,
})

VisualTab:CreateButton({
   Name = "Modo Foto (Ocultar Interface)",
   Callback = function()
      for _, gui in ipairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
         if gui:IsA("ScreenGui") and gui.Name ~= "Rayfield" and not gui.Name:find("Rayfield") then
            gui.Enabled = not gui.Enabled
         end
      end
   end,
})

VisualTab:CreateButton({
   Name = "Efeito Luz Roxa (Fashion)",
   Callback = function()
      game:GetService("Lighting").Ambient = Color3.fromRGB(138, 43, 226)
   end,
})

VisualTab:CreateButton({
   Name = "Remover Iluminação (Fullbright)",
   Callback = function()
      local lighting = game:GetService("Lighting")
      lighting.Brightness = 2
      lighting.ClockTime = 14
      lighting.FogEnd = 100000
      lighting.GlobalShadows = false
   end,
})

-- TAB 6: TROLL & EFEITOS
local FunTab = Window:CreateTab("Troll & Efeitos", 4483362458)

FunTab:CreateButton({
   Name = "Modo Sem Cabeça (Local)",
   Callback = function()
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("Head") then
         char.Head.Transparency = 1
         for _, item in ipairs(char.Head:GetChildren()) do
            if item:IsA("Decal") then
               item.Transparency = 1
            end
         end
      end
   end,
})

FunTab:CreateButton({
   Name = "Modo Manequim",
   Callback = function()
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChildOfClass("Humanoid") then
         local hum = char:FindFirstChildOfClass("Humanoid")
         hum.PlatformStand = not hum.PlatformStand
      end
   end,
})

-- TAB 7: CONFIGURAÇÕES DA UI
local ConfigTab = Window:CreateTab("Configurações", 4483362458)

ConfigTab:CreateButton({
   Name = "Reentrar no Servidor (Rejoin)",
   Callback = function()
      game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
   end,
})

ConfigTab:CreateButton({
   Name = "Fechar Interface (Unload Script)",
   Callback = function()
      Rayfield:Destroy()
   end,
})
