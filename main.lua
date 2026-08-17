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

-- FUNÇÃO CORRIGIDA PARA VELOCIDADE (SEM BUG)
local function ApplySpeed(speed)
    DesiredSpeed = speed
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speed
        if not SpeedConnection then
            SpeedConnection = char.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if char.Humanoid.WalkSpeed ~= DesiredSpeed then
                    char.Humanoid.WalkSpeed = DesiredSpeed
                end
            end)
        end
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
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

-- GAME PASS GRÁTIS: +MATERIAL
PlayerTab:CreateButton({
   Name = "🔓 Game Pass Grátis: +Material",
   Callback = function()
      pcall(function()
         local pData = game.Players.LocalPlayer:FindFirstChild("Data") or game.Players.LocalPlayer:FindFirstChild("leaderstats")
         if pData and pData:FindFirstChild("HasMaterialGamepass") then
            pData.HasMaterialGamepass.Value = true
         end
         -- Libera os botões de material bloqueados na UI do jogo
         for _, gui in ipairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
            if gui:IsA("GuiObject") and (gui.Name:lower():find("material") or gui.Name:lower():find("mat")) then
               gui.Visible = true
            end
         end
      end)
      Rayfield:Notify({ Title = "0 Dress Hub", Content = "Game Pass +Material ativada!", Duration = 3 })
   end,
})

-- GAME PASS GRÁTIS: +ITENS
PlayerTab:CreateButton({
   Name = "🔓 Game Pass Grátis: +Itens",
   Callback = function()
      pcall(function()
         local pData = game.Players.LocalPlayer:FindFirstChild("Data") or game.Players.LocalPlayer:FindFirstChild("leaderstats")
         if pData and pData:FindFirstChild("HasItemsGamepass") then
            pData.HasItemsGamepass.Value = true
         end
         -- Libera abas de itens VIP / gamepass na UI do jogo
         for _, gui in ipairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
            if gui:IsA("GuiObject") and (gui.Name:lower():find("vip") or gui.Name:lower():find("item")) then
               gui.Visible = true
            end
         end
      end)
      Rayfield:Notify({ Title = "0 Dress Hub", Content = "Game Pass +Itens ativada!", Duration = 3 })
   end,
})

-- CÓPIA MAKE (CAIXA DE TEXTO + BOTÃO SETA)
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
      local targetPlayer = game.Players:FindFirstChild(TargetNickMake)
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
            Rayfield:Notify({ Title = "0 Dress Hub", Content = "Make copiada de " .. targetPlayer.Name, Duration = 3 })
         end
      else
         Rayfield:Notify({ Title = "Erro", Content = "Jogador não encontrado!", Duration = 3 })
      end
   end,
})

-- CÓPIA ROUPA (CAIXA DE TEXTO + BOTÃO SETA)
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
      local targetPlayer = game.Players:FindFirstChild(TargetNickRoupa)
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
         Rayfield:Notify({ Title = "0 Dress Hub", Content = "Roupa copiada de " .. targetPlayer.Name, Duration = 3 })
      else
         Rayfield:Notify({ Title = "Erro", Content = "Jogador não encontrado!", Duration = 3 })
      end
   end,
})

-- CORRER (CORRIGIDO)
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
