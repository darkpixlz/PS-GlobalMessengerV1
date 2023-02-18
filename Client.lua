function Countdown(start, owner)
	for i = start, 0, -1 do
		print(i)
		task.wait(1)
		script.Parent.Details.Text = "Sent by <b>"..owner.."</b> • "..tostring(i).." remaining • PreloadService Announce v1"
	end
end

local neon = require(script.Parent:WaitForChild("neon"))
neon:BindFrame(script.Parent, {
	Transparency = 0.98;
	BrickColor = BrickColor.new("Institutional white");
})
task.wait(2)
game.ReplicatedStorage.PreloadServicePlugins.GlobalAnnouncements.RecieveAnnouncement.OnClientEvent:Connect(function(Message, Owner)
	script.Parent.Content.Text = Message
	script.Parent:TweenPosition(UDim2.new(.118,0,.022,0), Enum.EasingDirection.In, Enum.EasingStyle.Quint, 2, true)
	Countdown(15, Owner)
	script.Parent:TweenPosition(UDim2.new(.118,0,-.3,0), Enum.EasingDirection.In, Enum.EasingStyle.Quint, 2, true)
end)

--neon:UnbindFrame(script.Parent)
