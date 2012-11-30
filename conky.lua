local io = { open = io.open, popen = io.popen, read = io.read }
local string = { find = string.find, gmatch = string.gmatch, gsub = string.gsub }
local table = { insert = table.insert, concat = table.concat }
local tonumber = tonumber

function conky_hc_tag_status ()
	local f = io.popen ("herbstclient tag_status")
	local tagstring = f:read ()
	f:close ()

	tagstring = tagstring:gsub ("\t", "${color}   ")
	tagstring = tagstring:gsub (":", "${color5}") --occupied/blue
	tagstring = tagstring:gsub ("#", "${color3}") --focused/bright blue
	tagstring = tagstring:gsub ("!", "${color4}") --urgent/red
	tagstring = tagstring:gsub ("%.", "")

	return tagstring
end

-- depends on the ohsnap.icons font
function conky_mpd_status ()
	local mpdstat = conky_parse ("$mpd_status")
	if (mpdstat == "Stopped") then
		return "${color5}å${color} "
	elseif (mpdstat == "Playing") then
		return "${color5}ê${color} "
	elseif (mpdstat == "Paused") then
		return "${color5}ç${color} "
	else
		return "${color5}ê${color} "
	end
end

function conky_cpu_colour ()
	local cpu = tonumber (conky_parse ("$cpu"))

	if (cpu == nil) then
		return "${color4}N${color}"
	end

	if (cpu > 50) then
		return "${color4}" .. cpu .. "%${color}"
	else
		return "${color2}" .. cpu .. "%${color}"
	end
end

function conky_parse_volume ()
	local f = io.open ("/home/ian/.local/share/volume")
	local value = tonumber (f:read ("*n"))
	f:close ()

	if (value == nil) then
		return "${color4}NA${color}"
	end

	if (value == 0) then
		return "ë ${color2}0%${color}"
	elseif (value < 50) then
		return "ì ${color2}" .. value .. "%${color}"
	else
		return "í ${color2}" .. value .. "%${color}"
	end
end

function conky_hilight_from_file (arg)
	local f = io.open (arg)
	local value = tonumber (f:read ("*n"))
	f:close ()
	
	if (value == nil) then
		return "${color4}0${color}"
	end

	if (value < 0) then
		return "${color4}" .. value .. "${color}"
	elseif (value > 0) then
		return "${color3}" .. value .. "${color}"
	else
		return value
	end
end

-- depends on the ohsnap.icons font
function conky_dropbox_status ()
	local f = io.popen ("dropbox status")
	local status = f:read ()
	f:close ()

	if (string.find (status, "Uploading")) then
		return "${color3}Û${color}"
	elseif (string.find (status, "Downloading")) then
		return "${color3}Ú${color}"
	else
		return "Ñ"
	end
end

