 --[[

    HARD LOCK AIMBOT

    left button mause

    target: head

]]



local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")

local Workspace = game:GetService("Workspace")



local LocalPlayer = Players.LocalPlayer

local Camera = Workspace.CurrentCamera

local Mouse = LocalPlayer:GetMouse()



-- НАЛАШТУВАННЯ

local Settings = {

    AimKey = Enum.UserInputType.MouseButton2, -- Права кнопка миші

    FOV = 200,             -- Радіус зони дії (коло)

    TargetPart = "Head",   -- Куди цілитись (Head / Torso)

    TeamCheck = false      -- false = стріляти по всіх, true = тільки вороги

}



local FOVCircle = Drawing.new("Circle")

FOVCircle.Color = Color3.fromRGB(255, 0, 0) -- Червоне коло

FOVCircle.Thickness = 2

FOVCircle.NumSides = 60

FOVCircle.Radius = Settings.FOV

FOVCircle.Filled = false

FOVCircle.Visible = true



local function GetClosestPlayer()

    local ClosestParams = {Dist = Settings.FOV, Target = nil}

    local MousePos = UserInputService:GetMouseLocation()



    for _, Player in pairs(Players:GetPlayers()) do

        if Player == LocalPlayer then continue end

       

        -- Перевірка чи живий

        if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then

            local Part = Player.Character:FindFirstChild(Settings.TargetPart)

           

            -- Перевірка команд (якщо увімкнено)

            if Settings.TeamCheck and Player.Team == LocalPlayer.Team then continue end



            if Part then

                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Part.Position)

               

                if OnScreen then

                    local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude

                   

                    if Distance < ClosestParams.Dist then

                        ClosestParams.Dist = Distance

                        ClosestParams.Target = Part

                    end

                end

            end

        end

    end

    return ClosestParams.Target

end



-- Основний цикл

RunService.RenderStepped:Connect(function()

    -- Оновлюємо коло 

    FOVCircle.Position = UserInputService:GetMouseLocation()

   

    -- Якщо затиснута ПКМ

    if UserInputService:IsMouseButtonPressed(Settings.AimKey) then

        local Target = GetClosestPlayer()

       

        if Target then

            -- 

            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)

        end

    end

end)
