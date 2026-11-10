local P=game:GetService("Players")local R=game:GetService("RunService")local U=game:GetService("UserInputService")local lp=P.LocalPlayer local cam=workspace.CurrentCamera local ch,hum,rp local fdOff,afOn,flyOn=false,false,false local fSpd,wSpd,jPwr=80,16,50 local selPlr=nil local conns={} local afConn,folConn,fdConn local FLY,CFloop=false,nil

local sg=Instance.new("ScreenGui")sg.Name="TP"sg.ResetOnSpawn=false sg.Parent=lp:WaitForChild("PlayerGui")
local mb=Instance.new("TextButton")mb.Size=UDim2.new(0,30,0,30)mb.Position=UDim2.new(0,20,0.5,-15)mb.BackgroundColor3=Color3.fromRGB(30,30,30)mb.Text="⚙️"mb.TextSize=14 mb.Font=Enum.Font.GothamBold mb.TextColor3=Color3.fromRGB(255,255,255)mb.Parent=sg Instance.new("UICorner",mb).CornerRadius=UDim.new(0,8)
local pn=Instance.new("Frame")pn.Size=UDim2.new(0,340,0,250)pn.Position=UDim2.new(0.5,-170,0.5,-125)pn.BackgroundColor3=Color3.fromRGB(25,25,25)pn.Visible=false pn.Parent=sg Instance.new("UICorner",pn).CornerRadius=UDim.new(0,10)
local st=Instance.new("UIStroke")st.Color=Color3.fromRGB(60,60,60)st.Thickness=1.2 st.Parent=pn
local ttl=Instance.new("TextLabel")ttl.Size=UDim2.new(1,0,0,25)ttl.BackgroundTransparency=1 ttl.Text="Trolling Panel"ttl.TextColor3=Color3.fromRGB(255,255,255)ttl.TextSize=13 ttl.Font=Enum.Font.GothamBold ttl.Parent=pn
mb.MouseButton1Click:Connect(function()pn.Visible=not pn.Visible end)

local function setupC(c)ch=c hum=c:WaitForChild("Humanoid")rp=c:WaitForChild("HumanoidRootPart")hum.WalkSpeed=wSpd hum.JumpPower=jPwr hum.UseJumpPower=true for _,v in pairs(conns)do v:Disconnect()end table.clear(conns) if fdConn then fdConn:Disconnect()end if fdOff then fdConn=R.Heartbeat:Connect(function()if rp and rp.AssemblyLinearVelocity.Y<-50 then rp.AssemblyLinearVelocity=Vector3.new(rp.AssemblyLinearVelocity.X,0,rp.AssemblyLinearVelocity.Z)end end)end end
local function mkTog(n,x,y,prnt,cb)local b=Instance.new("TextButton")b.Size=UDim2.new(0,150,0,24)b.Position=UDim2.new(0,x,0,y)b.BackgroundColor3=Color3.fromRGB(45,45,45)b.Text=n..": OFF"b.TextColor3=Color3.fromRGB(255,255,255)b.TextSize=10 b.Font=Enum.Font.Gotham b.Parent=prnt Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)local e=false b.MouseButton1Click:Connect(function()e=not e if e then b.Text=n..": ON"b.BackgroundColor3=Color3.fromRGB(0,140,70)else b.Text=n..": OFF"b.BackgroundColor3=Color3.fromRGB(45,45,45)end cb(e)end)end

local function setFD(s)fdOff=s if fdConn then fdConn:Disconnect()end if s then fdConn=R.Heartbeat:Connect(function()if rp and rp.AssemblyLinearVelocity.Y<-50 then rp.AssemblyLinearVelocity=Vector3.new(rp.AssemblyLinearVelocity.X,0,rp.AssemblyLinearVelocity.Z)end end)end end
local function setAF(s)afOn=s if afConn then afConn:Disconnect()end if s then afConn=R.Stepped:Connect(function()for _,pl in pairs(P:GetPlayers())do if pl~=lp and pl.Character then for _,pt in pairs(pl.Character:GetDescendants())do if pt:IsA("BasePart")then pt.CanCollide=false end end end end end)end end

local function startFly()
    if not ch or not ch:FindFirstChild("Head")then return end 
    FLY=true 
    local H=ch.Head 
    H.Anchored=true 
    CFloop=R.Heartbeat:Connect(function(dt)
        if not flyOn then return end 
        local spd=fSpd*10 
        local md=hum.MoveDirection*(spd*dt)
        local hCF=H.CFrame 
        local cCF=cam.CFrame 
        local co=hCF:ToObjectSpace(cCF).Position 
        cCF=cCF*CFrame.new(-co.X,-co.Y,-co.Z+1)
        local cp=cCF.Position 
        local hp=hCF.Position 
        local osv=CFrame.new(cp,Vector3.new(hp.X,cp.Y,hp.Z)):VectorToObjectSpace(md)
        H.CFrame=CFrame.new(hp)*(cCF-cp)*CFrame.new(osv)
    end)
end

local function stopFly()
    FLY=false 
    if CFloop then CFloop:Disconnect()CFloop=nil end 
    if ch and ch:FindFirstChild("Head")then ch.Head.Anchored=false end 
    if hum then hum.PlatformStand=false end 
    for _,pt in pairs(ch:GetDescendants())do 
        if pt:IsA("BasePart")then 
            pt.CanCollide=true 
            if pt.Name~="HumanoidRootPart"then pt.Transparency=0 end 
        end 
    end 
end

local function setFly(s)if FLY==s then return end flyOn=s if s then for _,pt in pairs(ch:GetDescendants())do if pt:IsA("BasePart")then pt.CanCollide=false end end startFly()else stopFly()end end

mkTog("Daño Caída",10,30,pn,setFD)mkTog("Fling Táctil",10,58,pn,function(s)tfOn=s end)mkTog("Anti Fling",10,86,pn,setAF)mkTog("Fly",10,114,pn,setFly)

local function mkCnt(n,x,y,dv)local l=Instance.new("TextLabel")l.Size=UDim2.new(0,150,0,16)l.Position=UDim2.new(0,x,0,y)l.BackgroundTransparency=1 l.Text=n..": "..dv l.TextColor3=Color3.fromRGB(200,200,200)l.TextSize=10 l.Font=Enum.Font.Gotham l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=pn local d=Instance.new("TextButton")d.Size=UDim2.new(0,30,0,20)d.Position=UDim2.new(0,x,0,y+18)d.BackgroundColor3=Color3.fromRGB(60,60,60)d.Text="-"d.TextSize=12 d.TextColor3=Color3.fromRGB(255,255,255)d.Parent=pn Instance.new("UICorner",d).CornerRadius=UDim.new(0,4)local u=Instance.new("TextButton")u.Size=UDim2.new(0,30,0,20)u.Position=UDim2.new(0,x+35,0,y+18)u.BackgroundColor3=Color3.fromRGB(60,60,60)u.Text="+"u.TextSize=12 u.TextColor3=Color3.fromRGB(255,255,255)u.Parent=pn Instance.new("UICorner",u).CornerRadius=UDim.new(0,4)return l,u,d end

local wl,wu,wd=mkCnt("Velocidad",180,30,wSpd)wd.MouseButton1Click:Connect(function()wSpd=math.max(16,wSpd-5)wl.Text="Velocidad: "..wSpd if hum then hum.WalkSpeed=wSpd end end)wu.MouseButton1Click:Connect(function()wSpd=wSpd+5 wl.Text="Velocidad: "..wSpd if hum then hum.WalkSpeed=wSpd end end)
local jl,ju,jd=mkCnt("Salto",180,70,jPwr)jd.MouseButton1Click:Connect(function()jPwr=math.max(50,jPwr-10)jl.Text="Salto: "..jPwr if hum then hum.JumpPower=jPwr end end)ju.MouseButton1Click:Connect(function()jPwr=jPwr+10 jl.Text="Salto: "..jPwr if hum then hum.JumpPower=jPwr end end)
local fl,fu,fd=mkCnt("Velocidad Fly",180,110,fSpd)fd.MouseButton1Click:Connect(function()fSpd=math.max(10,fSpd-10)fl.Text="Velocidad Fly: "..fSpd end)fu.MouseButton1Click:Connect(function()fSpd=fSpd+10 fl.Text="Velocidad Fly: "..fSpd end)

local pll=Instance.new("TextLabel")pll.Size=UDim2.new(0,150,0,16)pll.Position=UDim2.new(0,180,0,150)pll.BackgroundTransparency=1 pll.Text="Jugadores:"pll.TextColor3=Color3.fromRGB(200,200,200)pll.TextSize=10 pll.Font=Enum.Font.GothamBold pll.TextXAlignment=Enum.TextXAlignment.Left pll.Parent=pn
local plf=Instance.new("ScrollingFrame")plf.Size=UDim2.new(0,150,0,50)plf.Position=UDim2.new(0,180,0,168)plf.BackgroundColor3=Color3.fromRGB(35,35,35)plf.BorderSizePixel=0 plf.ScrollBarThickness=4 plf.CanvasSize=UDim2.new(0,0,0,0)plf.AutomaticCanvasSize=Enum.AutomaticSize.Y plf.Parent=pn Instance.new("UICorner",plf).CornerRadius=UDim.new(0,6)
local ul=Instance.new("UIListLayout")ul.Padding=UDim.new(0,3)ul.Parent=plf

local tbtn=Instance.new("TextButton")tbtn.Size=UDim2.new(0,70,0,22)tbtn.Position=UDim2.new(0,180,0,225)tbtn.BackgroundColor3=Color3.fromRGB(0,100,180)tbtn.Text="TP"tbtn.TextColor3=Color3.fromRGB(255,255,255)tbtn.Font=Enum.Font.GothamBold tbtn.TextSize=10 tbtn.Parent=pn Instance.new("UICorner",tbtn).CornerRadius=UDim.new(0,6)

local function updPl()for _,v in pairs(plf:GetChildren())do if v:IsA("TextButton")then v:Destroy()end end for _,pl in pairs(P:GetPlayers())do if pl~=lp then local b=Instance.new("TextButton")b.Size=UDim2.new(1,-4,0,20)b.BackgroundColor3=Color3.fromRGB(50,50,50)b.Text=pl.Name b.TextColor3=Color3.fromRGB(255,255,255)b.Font=Enum.Font.Gotham b.TextSize=9 b.Parent=plf Instance.new("UICorner",b).CornerRadius=UDim.new(0,4)if pl==selPlr then b.BackgroundColor3=Color3.fromRGB(0,140,70)end b.MouseButton1Click:Connect(function()selPlr=pl for _,x in pairs(plf:GetChildren())do if x:IsA("TextButton")then x.BackgroundColor3=Color3.fromRGB(50,50,50)end end b.BackgroundColor3=Color3.fromRGB(0,140,70)end)end end end
updPl()P.PlayerAdded:Connect(updPl)P.PlayerRemoving:Connect(function(pl)if selPlr==pl then selPlr=nil end updPl()end)

tbtn.MouseButton1Click:Connect(function()if selPlr and selPlr.Character then local tr=selPlr.Character:FindFirstChild("HumanoidRootPart")if tr and rp then rp.CFrame=tr.CFrame*CFrame.new(0,0,3.5)end end end)

local function SkidFling(tp)
    local C=lp.Character 
    local H=C and C:FindFirstChildOfClass("Humanoid")
    local RP=H and H.RootPart 
    local TC=tp.Character 
    if not TC then return end
    local TH,TR
    if TC:FindFirstChildOfClass("Humanoid")then TH=TC:FindFirstChildOfClass("Humanoid")end
    if TH and TH.RootPart then TR=TH.RootPart end
    if C and H and RP and TR then
        local BV=Instance.new("BodyVelocity")
        BV.Parent=TR
        BV.Velocity=Vector3.new(math.random(-500,500),500,math.random(-500,500))
        BV.MaxForce=Vector3.new(9e9,9e9,9e9)
        local BAV=Instance.new("BodyAngularVelocity")
        BAV.Parent=TR
        BAV.AngularVelocity=Vector3.new(math.random(-200,200),math.random(-200,200),math.random(-200,200))
        BAV.MaxTorque=Vector3.new(9e9,9e9,9e9)
        H:ChangeState(Enum.HumanoidStateType.GettingUp)
        game:GetService("Debris"):AddItem(BV,0.5)
        game:GetService("Debris"):AddItem(BAV,0.5)
    end
end

local function setupTouchFling()
    if not ch then return end
    for _, part in pairs(ch:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Touched:Connect(function(hit)
                if not tfOn then return end
                local otherChar = hit.Parent
                if otherChar and otherChar:FindFirstChild("Humanoid") and otherChar ~= ch then
                    local otherPlayer = P:GetPlayerFromCharacter(otherChar)
                    if otherPlayer then
                        task.spawn(function()
                            while tfOn do
                                if otherPlayer and otherPlayer.Character then
                                    SkidFling(otherPlayer)
                                end
                                task.wait(0.3)
                            end
                        end)
                    end
                end
            end)
        end
    end
end

if lp.Character then setupC(lp.Character) setupTouchFling() end
lp.CharacterAdded:Connect(function(c)if CFloop then CFloop:Disconnect()CFloop=nil end FLY=false ch=c hum=c:WaitForChild("Humanoid")rp=c:WaitForChild("HumanoidRootPart")setupC(c) setupTouchFling() end)
print("Panel cargado")
