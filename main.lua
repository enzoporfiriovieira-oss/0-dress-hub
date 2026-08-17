local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "💜 0 Dress Hub 💜",
   LoadingTitle = "💜 0 Dress Hub 💜",
   LoadingSubtitle = "by You ✨",
   Theme = "Amethyst",
   Icon = "rbxassetid://7072722055", -- ÍCONE CHIQUE NO TOPO DA JANELA
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- VARIÁVEIS DE CONTROLE
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AutoFarmSmart = false
local DesiredSpeed = 16
local SpeedConnection = nil

local TargetNickMake = ""
local TargetNickLook = ""

local SpotlightLight = nil
local CameraLocking = false
local CameraConnection = nil
local PanoramicCam = false
local PanoramicConnection = nil

-- FUNÇÃO AUXILIAR: BUSCAR JOGADOR POR NICK PARCIAL
local function GetPlayerByPartialName(name)
   if not name or name == "" then return nil end
   name = name:lower()
   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer then
         if player.Name:lower():find(name) or player.DisplayName:lower():find(name) then
            return player
         end
      end
   end
   return nil
end

-- FUNÇÃO VELOCIDADE
local function ApplySpeed(speed)
    DesiredSpeed = speed
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
            if SpeedConnection then SpeedConnection:Disconnect() end
            SpeedConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if humanoid.WalkSpeed ~= DesiredSpeed then
                    humanoid.WalkSpeed = DesiredSpeed
                end
            end)
        end
    end
end

-- RESET E REAPLICAÇÃO AO RENASCER
LocalPlayer.CharacterAdded:Connect(function(char)
    if SpeedConnection then SpeedConnection:Disconnect() end
    SpeedConnection = nil
    SpotlightLight = nil
    Camera.CameraType = Enum.CameraType.Custom

    task.wait(0.5)
    ApplySpeed(DesiredSpeed)
end)

-- TAB 1: AUTOMATIZAÇÃO
local AutoTab = Window:CreateTab("⚡ Automação", "rbxassetid://7072722055")

AutoTab:CreateToggle({
   Name = "⚡ Auto Farm Inteligente (Coleta por Distância)",
   CurrentValue = false,
   Flag = "SmartFarmToggle",
   Callback = function(Value)
      AutoFarmSmart = Value
      if AutoFarmSmart then
         task.spawn(function()
            while AutoFarmSmart do
               local char = LocalPlayer.Character
               local root = char and char:FindFirstChild("HumanoidRootPart")
               local hum = char and char:FindFirstChildOfClass("Humanoid")
               
               if root and hum then
                  local closestItem = nil
                  local shortestDistance = math.huge

                  for _, item in ipairs(workspace:GetDescendants()) do
                     if item:IsA("BasePart") or item:IsA("Model") then
                        local lowerName = item.Name:lower()
                        if lowerName:find("coin") or lowerName:find("currency") or lowerName:find("money") or lowerName:find("gem") or lowerName:find("diamond") then
                           local itemPos = item:IsA("Model") and item:GetPivot().Position or item.Position
                           local dist = (root.Position - itemPos).Magnitude
                           if dist < shortestDistance then
                              shortestDistance = dist
                              closestItem = item
                           end
                        end
                     end
                  end

                  if closestItem and closestItem.Parent then
                     local targetPos = closestItem:IsA("Model") and closestItem:GetPivot().Position or closestItem.Position
                     hum:MoveTo(targetPos)
                  end
               end
               task.wait(0.3)
            end
         end)
      end
   end,
})

AutoTab:CreateButton({
   Name = "🛡️ Ativar Anti-AFK",
   Callback = function()
      LocalPlayer.Idled:Connect(function()
         VirtualUser:CaptureController()
         VirtualUser:ClickButton2(Vector2.new())
      end)
      Rayfield:Notify({ Title = "💜 0 Dress Hub 💜", Content = "Anti-AFK Ativado com sucesso! 🛡️", Duration = 3 })
   end,
})

-- TAB 2: JOGADOR & ESTILO
local PlayerTab = Window:CreateTab("👗 Jogador & Estilo", "rbxassetid://7072721759")

PlayerTab:CreateInput({
   Name = "💄 Nick do Jogador (Make)",
   PlaceholderText = "Digite o Nick aqui...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      TargetNickMake = Text
   end,
})

PlayerTab:CreateButton({
   Name = "✨ Copiar Make",
   Callback = function()
      local targetPlayer = GetPlayerByPartialName(TargetNickMake)
      local myChar = LocalPlayer.Character

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
            Rayfield:Notify({ Title = "💜 0 Dress Hub 💜", Content = "Make copiada de " .. targetPlayer.DisplayName .. "! 💄", Duration = 3 })
         end
      else
         Rayfield:Notify({ Title = "❌ Erro", Content = "Jogador não encontrado!", Duration = 3 })
      end
   end,
})

PlayerTab:CreateInput({
   Name = "👗 Nick do Jogador (Look Completo)",
   PlaceholderText = "Digite o Nick aqui...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      TargetNickLook = Text
   end,
})

PlayerTab:CreateButton({
   Name = "✨ Copiar Look (Roupa, Cabelo, Salto, etc.)",
   Callback = function()
      local targetPlayer = GetPlayerByPartialName(TargetNickLook)
      local myChar = LocalPlayer.Character

      if targetPlayer and targetPlayer.Character and myChar then
         for _, item in ipairs(myChar:GetChildren()) do
            if item:IsA("Clothing") 
            or item:IsA("ShirtGraphic") 
            or item:IsA("Accessory") 
            or item:IsA("BodyColors") 
            or item:IsA("CharacterMesh")
            or item.Name == "Animate" then
               item:Destroy()
            end
         end

         for _, item in ipairs(targetPlayer.Character:GetChildren()) do
            if item:IsA("Clothing") 
            or item:IsA("ShirtGraphic") 
            or item:IsA("Accessory") 
            or item:IsA("BodyColors") 
            or item:IsA("CharacterMesh") then
               item:Clone().Parent = myChar
            elseif item.Name == "Animate" and item:IsA("LocalScript") then
               local animClone = item:Clone()
               animClone.Parent = myChar
            end
         end

         Rayfield:Notify({ Title = "💜 0 Dress Hub 💜", Content = "Look completo copiado de " .. targetPlayer.DisplayName .. "! ✨", Duration = 3 })
      else
         Rayfield:Notify({ Title = "❌ Erro", Content = "Jogador não encontrado!", Duration = 3 })
      end
   end,
})

PlayerTab:CreateButton({
   Name = "🗑️ Remover Acessórios e Cabelos",
   Callback = function()
      local char = LocalPlayer.Character
      if char then
         for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Accessory") then
               item:Destroy()
            end
         end
         Rayfield:Notify({ Title = "💜 0 Dress Hub 💜", Content = "Acessórios e cabelos removidos! 🗑️", Duration = 3 })
      end
   end,
})

PlayerTab:CreateSlider({
   Name = "👟 Velocidade de Correr (WalkSpeed)",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      ApplySpeed(Value)
   end,
})

-- TAB 3: VISUAL & CÂMERA
local VisualTab = Window:CreateTab("📷 Visual & Câmera", "rbxassetid://7072722232")

VisualTab:CreateSlider({
   Name = "🔍 Ajuste de Campo de Visão (FOV)",
   Range = {70, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = 70,
   Flag = "FOVSlider",
   Callback = function(Value)
      Camera.FieldOfView = Value
   end,
})

VisualTab:CreateToggle({
   Name = "🌐 Visão Panorâmica (360° Cam)",
   CurrentValue = false,
   Flag = "PanoramicToggle",
   Callback = function(Value)
      PanoramicCam = Value
      local angle = 0

      if PanoramicCam then
         if PanoramicConnection then PanoramicConnection:Disconnect() end
         PanoramicConnection = RunService.RenderStepped:Connect(function(dt)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root and PanoramicCam then
               angle = angle + (dt * 30)
               local rad = math.rad(angle)
               local offset = Vector3.new(math.sin(rad) * 10, 3, math.cos(rad) * 10)
               Camera.CameraType = Enum.CameraType.Scriptable
               Camera.CFrame = CFrame.new(root.Position + offset, root.Position)
            end
         end)
      else
         if PanoramicConnection then
            PanoramicConnection:Disconnect()
            PanoramicConnection = nil
         end
         Camera.CameraType = Enum.CameraType.Custom
      end
   end,
})

VisualTab:CreateToggle({
   Name = "🪞 Efeito Espelho (Luz de Camarim)",
   CurrentValue = false,
   Flag = "SpotlightToggle",
   Callback = function(Value)
      local char = LocalPlayer.Character
      local head = char and char:FindFirstChild("Head")

      if Value then
         if head then
            if not head:FindFirstChild("DressCamarimLight") then
               SpotlightLight = Instance.new("PointLight")
               SpotlightLight.Name = "DressCamarimLight"
               SpotlightLight.Color = Color3.fromRGB(220, 180, 255)
               SpotlightLight.Range = 25
               SpotlightLight.Brightness = 3
               SpotlightLight.Parent = head
            end
         end
      else
         if head and head:FindFirstChild("DressCamarimLight") then
            head.DressCamarimLight:Destroy()
         end
      end
   end,
})

VisualTab:CreateToggle({
   Name = "🎯 Fixar Câmera no Rosto (Foco Make)",
   CurrentValue = false,
   Flag = "CamLockToggle",
   Callback = function(Value)
      CameraLocking = Value

      if CameraLocking then
         if CameraConnection then CameraConnection:Disconnect() end
         CameraConnection = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            local head = char and char:FindFirstChild("Head")
            if head and CameraLocking then
               Camera.CameraType = Enum.CameraType.Scriptable
               Camera.CFrame = head.CFrame * CFrame.new(0, 0, -3.5) * CFrame.Angles(0, math.rad(180), 0)
            end
         end)
      else
         if CameraConnection then
            CameraConnection:Disconnect()
            CameraConnection = nil
         end
         Camera.CameraType = Enum.CameraType.Custom
      end
   end,
})

VisualTab:CreateButton({
   Name = "📸 Modo Foto (Ocultar Interface)",
   Callback = function()
      for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
         if gui:IsA("ScreenGui") and not gui.Name:lower():find("rayfield") then
            gui.Enabled = not gui.Enabled
         end
      end
   end,
})

VisualTab:CreateButton({
   Name = "💜 Efeito Luz Roxa (Fashion)",
   Callback = function()
      Lighting.Ambient = Color3.fromRGB(138, 43, 226)
   end,
})

VisualTab:CreateButton({
   Name = "💡 Remover Iluminação (Fullbright)",
   Callback = function()
      Lighting.Brightness = 2
      Lighting.ClockTime = 14
      Lighting.FogEnd = 100000
      Lighting.GlobalShadows = false
   end,
})

-- TAB 4: TROLL & EFEITOS
local FunTab = Window:CreateTab("🎭 Troll & Efeitos", "rbxassetid://7072721867")

FunTab:CreateButton({
   Name = "👻 Modo Sem Cabeça (Local)",
   Callback = function()
      local char = LocalPlayer.Character
      if char and char:FindFirstChild("Head") then
         char.Head.Transparency = 1
         for _, item in ipairs(char.Head:GetChildren()) do
            if item:IsA("Decal") or item:IsA("Texture") then
               item.Transparency = 1
            end
         end
      end
   end,
})

FunTab:CreateButton({
   Name = "🧍 Modo Manequim",
   Callback = function()
      local char = LocalPlayer.Character
      if char and char:FindFirstChildOfClass("Humanoid") then
         local hum = char:FindFirstChildOfClass("Humanoid")
         hum.PlatformStand = not hum.PlatformStand
      end
   end,
})

-- TAB 5: CONFIGURAÇÕES DA UI & PERFORMANCE
local ConfigTab = Window:CreateTab("⚙️ Configurações", "rbxassetid://7072721953")

ConfigTab:CreateButton({
   Name = "🚀 Ativar Modo FPS Boost (Anti-Lag)",
   Callback = function()
      Lighting.GlobalShadows = false
      Lighting.FogEnd = 9e9

      local char = LocalPlayer.Character

      for _, v in ipairs(workspace:GetDescendants()) do
         if not (char and v:IsDescendantOf(char)) then
            if v:IsA("BasePart") then
               v.Material = Enum.Material.SmoothPlastic
               v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
               v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
               v.Enabled = false
            end
         end
      end
      Rayfield:Notify({ Title = "💜 0 Dress Hub 💜", Content = "FPS Boost ativado com sucesso! 🚀", Duration = 3 })
   end,
})

ConfigTab:CreateButton({
   Name = "🔄 Reentrar no Servidor (Rejoin)",
   Callback = function()
      TeleportService:Teleport(game.PlaceId, LocalPlayer)
   end,
})

ConfigTab:CreateButton({
   Name = "❌ Fechar Interface (Unload Script)",
   Callback = function()
      if SpeedConnection then SpeedConnection:Disconnect() end
      if PanoramicConnection then PanoramicConnection:Disconnect() end
      if CameraConnection then CameraConnection:Disconnect() end
      Camera.CameraType = Enum.CameraType.Custom
      Rayfield:Destroy()
   end,
})
