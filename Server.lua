-- DarkPixlz 2023

script.Announcement.Parent = game.StarterGui
local function LocalTime()
	local Date = os.date("*t")
	local DayTxt = os.date("%A")
	local Month = os.date("%B")
	local DayDate = os.date("%d")
	local Hour = string.format("%0.2i", ((Date.hour % 12 == 0) and 12) or (Date.hour % 12))
	local Minute = string.format("%0.2i", Date.min)
	local Second = string.format("%0.2i", Date.sec)
	local Meridiem = (Date.hour < 12 and "AM" or "PM")

	return tostring(DayTxt..", "..Month.." "..DayDate.." "..Hour ..":".. Minute ..":".. Second .." ".. Meridiem)
end

local function Time()
	local Date = os.date("*t")
	local Hour = string.format("%0.2i", ((Date.hour % 12 == 0) and 12) or (Date.hour % 12))
	local Minute = string.format("%0.2i", Date.min)
	local Second = string.format("%0.2i", Date.sec)
	local Meridiem = (Date.hour < 12 and "AM" or "PM")

	return tostring(Hour ..":".. Minute ..":".. Second .." ".. Meridiem)
end
--[[
	local DayTxt = os.date("%A")
	local Month = os.date("%B")
	local DayDate = os.date("%d")
	]]
local function Date()
	local DayTxt = os.date("%A")
	local Month = os.date("%B")
	local DayDate = os.date("%d")
	local Year = os.date("%Y")

	return tostring(DayTxt..", "..Month.." "..DayDate.." "..Year)
end
local function SendWebhook(Type,Title,Body, FieldName,FieldValue)
	local HttpService = game:GetService("HttpService")
	if Type == "test" then

	elseif Type == "PlayerFireMessage" then
		local url =  require(script.Configuration).AnnouncedWebhookURLs[math.random(1, #require(script.Configuration).AnnouncedWebhookURLs)]

		local data = 
			{
				--["username"] = GameName.." logging",
				--["avatar_url"] = "https://cdn.discordapp.com/avatars/1032431346385178655/e6bde5fcfd3b994456fa578b8956ff0c.png?size=4096",
				["embeds"] = {{
					["title"]= Title,
					["description"] = Body,
					["type"]= "rich",
					["color"]= tonumber(0x006DFF),
					["fields"]={
						{
							["name"]=FieldName,
							["value"]=FieldValue,
							["inline"]=true
						},
						{
							["name"]="Report Data", 
							["value"]="Sent at "..LocalTime(),
							["inline"]=true
						},
					}
				}
				}
			}
		HttpService:PostAsync(url,HttpService:JSONEncode(data))
	else
		warn("Invalid Type value.")
	end
end
local MS = game:GetService("MessagingService")
local API = require(game.ReplicatedStorage:WaitForChild("PreloadService"):WaitForChild("PluginsAPI"))
API.PluginEventsFolder("GlobalAnnouncements")
local Event = API.NewRemoteEvent("RecieveAnnouncement", "GlobalAnnouncements", nil)

local Connection = MS:SubscribeAsync("ServerWideMessage", function(Table)
	Table = Table["Data"]
	local Name, Message = Table[1], Table[2]
	print(Table)
	print("SERVER MESSAGE RECIEVED FROM "..Name..": "..Message)
	Event:FireAllClients(Message,Name)
end)


--require(script.Configuration).AnnouncedWebhookURLs[math.random(1, #require(script.Configuration).AnnouncedWebhookURLs)]
API.NewRemoteEvent("SendAnnouncement", "GlobalAnnouncements", function(Player, Message)
	local IsAdmin = false
	for i, v in ipairs(require(script.Parent.Parent.Parent.Admins).Groups) do
		for _i, _v in ipairs(game:GetService("GroupService"):GetGroupsAsync(game.Players:GetUserIdFromNameAsync(Player.Name))) do
			--print(v)
			--print(v["GroupName"])
			if _v["Id"] == v then
				print("Is admin")
				IsAdmin = true
			end
		end
	end
	if not IsAdmin then
		-- User is not an admin, ban instead, but do a bit of trolling
		--game.ReplicatedStorage.Event:FireClient(Player, Message,Player.Name)
		SendWebhook("PlayerFireMessage",
			Player.Name.." ATTEMPTED SERVER WIDE MESSAGE",
			"ATTENTION REQUIRED URGENTLY. PLAYER WAS BANNED.",
			"Attempted message: "..Message.."\nPlayer data:\nPlayer Name: "..Player.Name.."\nPlayer Display Name: "..Player.DisplayName.."\nPlayer Account Age: "..Player.AccountAge.."\nPlayer User ID: "..Player.UserId)
		Player:Kick("Exploiting")
		--Ban player
		API.BanPlayer()
		return
	end
	--Only actually firing it now
	print(Player.Name..","..Message)
	MS:PublishAsync("ServerWideMessage",{Player.Name,Message})
end)

-- build button

API.Build(function()
	local Result = API.NewButton("", "Announce", script.Announce, "F", {}, "Announce things to all servers. BETA.")
end, require(script.Configuration))
