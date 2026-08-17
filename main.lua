local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "0 Dress Hub",
   LoadingTitle = "0 Dress Hub",
   LoadingSubtitle = "by You",
   Theme = "Amethyst", -- Aplica a cor roxa em toda a UI (fundo, botões, abas)
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- VARIÁVEIS DE CONTROLE
local AutoFarm = false
local WalkSpeedVal = 16

-- LISTA DE CÓDIGOS DO JOGO
local listaCodigos = {
    "DRESS2026",
    "FASHION2026",
    "REWARD100K",
    "STYLEUP"
}

-- TAB 1: AUTOMATIZAÇÃO
local AutoTab = Window:CreateTab("Automação", 4483362458)

AutoTab:CreateToggle({
   Name = "Auto Farm (Coleta de Moedas)",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
      AutoFarm = Value
      task.spawn(function()
         while AutoFarm do
            for _, item in ipairs(workspace:GetChildren()) do
               if item:IsA("BasePart") and (item.Name == "Coin" or item.Name == "Currency") then
                  if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                     game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = item.CFrame
                     task.wait(0.1)
                  end
               end
            end
            task.wait(1)
         end
      end)
   end,
})

AutoTab:CreateButton({
   Name = "Resgatar Todos os Códigos Ativos",
   Callback = function()
      local redeemEvent = game:GetService("ReplicatedStorage"):FindFirstChild("RedeemCode", true) 
          or game:GetService("ReplicatedStorage"):FindFirstChild("ClaimCode", true)

      if redeemEvent then
          for _, code in ipairs(listaCodigos) do
              pcall(function()
                  if redeemEvent:IsA("RemoteFunction") then
                      redeemEvent:InvokeServer(code)
                  elseif redeemEvent:IsA("RemoteEvent") then
                      redeemEvent:FireServer(code)
                  end
              end)
              task.wait(0.5)
          end
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
   end,
})

-- TAB 2: JOGADOR & ESTILO
local PlayerTab = Window:CreateTab("Jogador & Estilo", 4483362458)

PlayerTab:CreateButton({
   Name = "Copiar Estilo Completo (Roupas/Acessórios/Maquiagem)",
   Callback = function()
      local p1 = game.Players.LocalPlayer
      for _, p2 in ipairs(game.Players:GetPlayers()) do
         if p2 ~= p1 and p2.Character and p1.Character then
            local dist = (p1.Character.HumanoidRootPart.Position - p2.Character.HumanoidRootPart.Position).Magnitude
            if dist < 15 then
               for _, item in ipairs(p2.Character:GetChildren()) do
                  if item:IsA("Accessory") or item:IsA("Clothing") or item:IsA("ShirtGraphic") then
                     item:Clone().Parent = p1.Character
                  end
               end
               if p2.Character:FindFirstChild("Head") and p1.Character:FindFirstChild("Head") then
                  local face = p2.Character.Head:FindFirstChildOfClass("Decal")
                  if face then
                     local myFace = p1.Character.Head:FindFirstChildOfClass("Decal")
                     if myFace then myFace.Texture = face.Texture else face:Clone().Parent = p1.Character.Head end
                  end
               end
               break
            end
         end
      end
   end,
})

PlayerTab:CreateSlider({
   Name = "Velocidade (WalkSpeed)",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- TAB 3: VISUAL & CÂMERA
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

VisualTab:CreateButton({
   Name = "Modo Foto (Ocultar Interface)",
   Callback = function()
      for _, gui in ipairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
         if gui:IsA("ScreenGui") and gui.Name ~= "Rayfield" then
            gui.Enabled = not gui.Enabled
         end
      end
   end,
})

VisualTab:CreateButton({
   Name = "Ativar Efeito de Luz Roxa (Fashion)",
   Callback = function()
      local lighting = game:GetService("Lighting")
      lighting.Ambient = Color3.fromRGB(138, 43, 226)
   end,
})

-- TAB 4: TROLL & EFEITOS
local FunTab = Window:CreateTab("Troll & Efeitos", 4483362458)

FunTab:CreateButton({
   Name = "Modo Sem Cabeça (Local)",
   Callback = function()
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("Head") then
         char.Head.Transparency = 1
         if char.Head:FindFirstChildOfClass("Decal") then
            char.Head:FindFirstChildOfClass("Decal").Transparency = 1
         end
      end
   end,
})

FunTab:CreateButton({
   Name = "Modo Manequim",
   Callback = function()
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.PlatformStand = true
      end
   end,
})
