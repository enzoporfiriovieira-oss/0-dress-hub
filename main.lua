local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "💜 0 Dress Hub 💜",
   LoadingTitle = "💜 0 Dress Hub 💜",
   LoadingSubtitle = "by You ✨",
   Theme = "Amethyst",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- VARIÁVEIS DE CONTROLE
local AutoFarmSmart = false
local DesiredSpeed = 16
local SpeedConnection = nil
local TargetNickMake = ""
local TargetNickCompleto = ""
local TargetNickCor = ""
local SpotlightLight = nil
local CameraLocking = false
local CameraConnection = nil
local PanoramicCam = false
local PanoramicConnection = nil
local AutoVotarAtivo = false

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
local AutoTab = Window:CreateTab("⚡ Automação", 4483362458)

AutoTab:CreateToggle({
   Name = "⚡ Auto Farm Inteligente (Coleta por Distância)",
   CurrentValue = false,
   Flag = "SmartFarmToggle",
   Callback = function(Value)
      AutoFarmSmart = Value
      if AutoFarmSmart then
         task.spawn(function()
            while AutoFarmSmart do
               local char = game.Players.LocalPlayer.Character
               local root = char and char:FindFirstChild("HumanoidRootPart")
               local hum = char and char:FindFirstChildOfClass("Humanoid")
               
               if root and hum then
                  local closestItem = nil
                  local shortestDistance = math.huge

                  for _, item in ipairs(workspace:GetDescendants()) do
                     if item:IsA("BasePart") or item:IsA("Model") then
                        local lowerName = item.Name:lower()
                        if lowerName:find("coin") or lowerName:find("currency") or lowerName:find("money") or lowerName:find("gem") then
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
                     task.wait(0.2)
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
      local VirtualUser = game:GetService("VirtualUser")
      game:GetService("Players").LocalPlayer.Idled:Connect(function()
         VirtualUser:CaptureController()
         VirtualUser:ClickButton2(Vector2.new())
      end)
      Rayfield:Notify({ Title = "💜 0 Dress Hub 💜", Content = "Anti-AFK Ativado com sucesso! 🛡️", Duration = 3 })
   end,
})

-- TAB 2: JOGADOR & ESTILO
local PlayerTab = Window:CreateTab("👗 Jogador & Estilo", 4483362458)

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
            Rayfield:Notify({ Title = "💜 0 Dress Hub 💜", Content = "Make copiada de " .. targetPlayer.DisplayName .. "! 💄", Duration = 3 })
         end
      else
         Rayfield:Notify({ Title = "❌ Erro", Content = "Jogador não encontrado!", Duration = 3 })
      end
   end,
})

PlayerTab:CreateInput({
   Name = "👑 Nick do Jogador (Look Completo)",
   PlaceholderText = "Digite o Nick aqui...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      TargetNickCompleto = Text
   end,
})

PlayerTab:CreateButton({
   Name = "✨ Copiar Tudo (Roupas, Acessórios, Sapatos & Cabelos)",
   Callback = function()
      local targetPlayer = GetPlayerByPartialName(TargetNickCompleto)
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
         
         Rayfield:Notify({ Title = "💜 0 Dress Hub 💜", Content = "Look completo copiado de " .. targetPlayer.DisplayName .. "! 👑", Duration = 3 })
      else
         Rayfield:Notify({ Title = "❌ Erro", Content = "Jogador não encontrado!", Duration = 3 })
      end
   end,
})

PlayerTab:CreateInput({
   Name = "🎨 Nick do Jogador (Cor de Pele)",
   PlaceholderText = "Digite o Nick aqui...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      TargetNickCor = Text
   end,
})

PlayerTab:CreateButton({
   Name = "🎨 Copiar Cor de Pele",
   Callback = function()
      local targetPlayer = GetPlayerByPartialName(TargetNickCor)
      local myChar = game.Players.LocalPlayer.Character

      if targetPlayer and targetPlayer.Character and myChar then
         local targetHumDesc = targetPlayer.Character:FindFirstChildOfClass("Humanoid") and targetPlayer.Character:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("HumanoidDescription")
         local myHum = myChar:FindFirstChildOfClass("Humanoid")
         local myHumDesc = myHum and myHum:FindFirstChildOfClass("HumanoidDescription")

         if targetHumDesc and myHumDesc then
            myHumDesc.HeadColor = targetHumDesc.HeadColor
            myHumDesc.LeftArmColor = targetHumDesc.LeftArmColor
            myHumDesc.RightArmColor = targetHumDesc.RightArmColor
            myHumDesc.LeftLegColor = targetHumDesc.LeftLegColor
            myHumDesc.RightLegColor = targetHumDesc.RightLegColor
            myHumDesc.TorsoColor = targetHumDesc.TorsoColor
            Rayfield:Notify({ Title = "💜 0 Dress Hub 💜", Content = "Cor de pele copiada com sucesso! 🎨", Duration = 3 })
         else
            local targetHead = targetPlayer.Character:FindFirstChild("Head")
            local myHead = myChar:FindFirstChild("Head")
            if targetHead and myHead then
               myHead.Color = targetHead.Color
               Rayfield:Notify({ Title = "💜 0 Dress Hub 💜", Content = "Cor da cabeça copiada! 🎨", Duration = 3 })
            else
               Rayfield:Notify({ Title = "❌ Erro", Content = "Não foi possível copiar a cor de pele.", Duration = 3 })
            end
         end
      else
         Rayfield:Notify({ Title = "❌ Erro", Content = "Jogador não encontrado!", Duration = 3 })
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

-- TAB 2.5: DESFILE & VOTAÇÃO
local DesfileTab = Window:CreateTab("🌟 Desfile & Votação", 4483362458)

DesfileTab:CreateToggle({
   Name = "⭐ Auto Votar (5 Estrelas)",
   CurrentValue = false,
   Flag = "AutoVoteToggle",
   Callback = function(Value)
      AutoVotarAtivo = Value
      if AutoVotarAtivo then
         task.spawn(function()
            while AutoVotarAtivo do
               local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
               if playerGui then
                  for _, btn in ipairs(playerGui:GetDescendants()) do
                     if btn:IsA("TextButton") and (btn.Text == "5" or btn.Text == "⭐⭐⭐⭐⭐" or btn.Text:find("5")) then
                        if btn.Visible then
                           btn.MouseButton1Click:Fire()
                        end
                     end
                  end
               end
               task.wait(0.5)
            end
         end)
         Rayfield:Notify({ Title = "💜 0 Dress Hub 💜", Content = "Auto Votar Ativado! ⭐", Duration = 3 })
      else
         Rayfield:Notify({ Title = "💜 0 Dress Hub 💜", Content = "Auto Votar Desativado.", Duration = 2 })
      end
   end,
})

-- TAB 3: VISUAL & CÂMERA
local VisualTab = Window:CreateTab("📷 Visual & Câmera", 4483362458)

VisualTab:CreateSlider({
   Name = "🔍 Ajuste de Campo de Visão (FOV)",
   Range = {70, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = 70,
   Flag = "FOVSlider",
   Callback = function(Value)
      workspace.CurrentCamera.FieldOfView = Value
   end,
})

VisualTab:CreateToggle({
   Name = "🌐 Visão Panorâmica (360° Cam)",
   CurrentValue = false,
   Flag = "PanoramicToggle",
   Callback = function(Value)
      PanoramicCam = Value
      local camera = workspace.CurrentCamera
      local angle = 0

      if PanoramicCam then
         PanoramicConnection = game:GetService("RunService").RenderStepped:Connect(function(dt)
            local char = game.Players.LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root and PanoramicCam then
               angle = angle + (dt * 30)
               local rad = math.rad(angle)
               local offset = Vector3.new(math.sin(rad) * 10, 3, math.cos(rad) * 10)
               camera.CameraType = Enum.CameraType.Scriptable
               camera.CFrame = CFrame.new(root.Position + offset, root.Position)
            end
         end)
      else
         if PanoramicConnection then
            PanoramicConnection:Disconnect()
            PanoramicConnection = nil
         end
         camera.CameraType = Enum.CameraType.Custom
      end
   end,
})

VisualTab:CreateToggle({
   Name = "🪞 Efeito Espelho (Luz de Camarim)",
   CurrentValue = false,
   Flag = "SpotlightToggle",
   Callback = function(Value)
      local char = game.Players.LocalPlayer.Character
      local head = char and char:FindFirstChild("Head")

      if Value then
         if head and not SpotlightLight then
            SpotlightLight = Instance.new("PointLight")
            SpotlightLight.Name = "DressCamarimLight"
            SpotlightLight.Color = Color3.fromRGB(220, 180, 255)
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

VisualTab:CreateToggle({
   Name = "🎯 Fixar Câmera no Rosto (Foco Make)",
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
   Name = "📸 Modo Foto (Ocultar Interface)",
   Callback = function()
      for _, gui in ipairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
         if gui:IsA("ScreenGui") and gui.Name ~= "Rayfield" and not gui.Name:find("Rayfield") then
            gui.Enabled = not gui.Enabled
         end
      end
   end,
})

VisualTab:CreateButton({
   Name = "💜 Efeito Luz Roxa (Fashion)",
   Callback = function()
      game:GetService("Lighting").Ambient = Color3.fromRGB(138, 43, 226)
   end,
})

VisualTab:CreateButton({
   Name = "💡 Remover Iluminação (Fullbright)",
   Callback = function()
      local lighting = game:GetService("Lighting")
      lighting.Brightness = 2
      lighting.ClockTime = 14
      lighting.FogEnd = 100000
      lighting.GlobalShadows = false
   end,
})

-- TAB 4: TROLL & EFEITOS
local FunTab = Window:CreateTab("🎭 Troll & Efeitos", 4483362458)

FunTab:CreateButton({
   Name = "👻 Modo Sem Cabeça (Local)",
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
   Name = "🧍 Modo Manequim",
   Callback = function()
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChildOfClass("Humanoid") then
         local hum = char:FindFirstChildOfClass("Humanoid")
         hum.PlatformStand = not hum.PlatformStand
      end
   end,
})

-- TAB 5: SERVIDOR
local ServerTab = Window:CreateTab("🌐 Servidor", 4483362458)

ServerTab:CreateButton({
   Name = "🔄 Trocar de Servidor (Server Hop)",
   Callback = function()
      local TeleportService = game:GetService("TeleportService")
      local HttpService = game:GetService("HttpService")
      local servers = {}
      
      Rayfield:Notify({ Title = "💜 0 Dress Hub 💜", Content = "Procurando outro servidor...", Duration = 3 })
      
      local success, result = pcall(function()
         return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
      end)
      
      if success and result and result.data then
         for _, s in ipairs(result.data) do
            if type(s) == "table" and s.maxPlayers and s.playing and s.id and s.playing < s.maxPlayers and s.id ~= game.JobId then
               table.insert(servers, s.id)
            end
         end
         
         if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
         else
            Rayfield:Notify({ Title = "❌ Erro", Content = "Nenhum servidor encontrado!", Duration = 3 })
         end
      else
         Rayfield:Notify({ Title = "❌ Erro", Content = "Falha ao buscar servidores.", Duration = 3 })
      end
   end,
})

ServerTab:CreateButton({
   Name = "🔁 Reentrar no Servidor (Rejoin)",
   Callback = function()
      game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
   end,
})

-- TAB 6: CONFIGURAÇÕES DA UI & PERFORMANCE
local ConfigTab = Window:CreateTab("⚙️ Configurações", 4483362458)

ConfigTab:CreateButton({
   Name = "🚀 Ativar Modo FPS Boost (Anti-Lag)",
   Callback = function()
      local lighting = game:GetService("Lighting")
      lighting.GlobalShadows = false
      lighting.FogEnd = 9e9

      for _, v in ipairs(workspace:GetDescendants()) do
         if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
         elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
         elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
            v.Enabled = false
         end
      end
      Rayfield:Notify({ Title = "💜 0 Dress Hub 💜", Content = "FPS Boost ativado com sucesso! 🚀", Duration = 3 })
   end,
})

ConfigTab:CreateButton({
   Name = "❌ Fechar Interface (Unload Script)",
   Callback = function()
      Rayfield:Destroy()
   end,
})
