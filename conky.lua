local io = { open = io.open, popen = io.popen }
local string = { find = string.find, gmatch = string.gmatch, gsub = string.gsub }
local table = { insert = table.insert, concat = table.concat }
local tonumber = tonumber

function conky_hc_tag_status ()
	local f = io.popen ("herbstclient tag_status")
	local tagstring = f:read ()
	f:close ()

	string.gsub (tagstring, "\t", "_")
	string.gsub (tagstring, "(\x3A)", "${color3}") -- occupied tag
	string.gsub (tagstring, "\x23", "${color3}") -- focused tag
	string.gsub (tagstring, "(\x21)", "${color4}") -- urgent tag
	string.gsub (tagstring, "(\x2E)", "${color}") -- empty, unfocused tag, and others
	string.gsub (tagstring, "([\x2D\x2B\x25])", "${color}")

	
	--tagstring = table.concat (tags, " ")
	return tagstring

end

function conky_cpu_colour ()
	cpu = tonumber (conky_parse ("$cpu"))

	if (cpu == nil) then
		return "${color4}N${color}"
	end

	if (cpu > 50) then
		return "${color4}" .. cpu .. "%${color}"
	else
		return "${color2}" .. cpu .. "%${color}"
	end
end

function conky_hilight_from_file (arg)
	local f = io.open (arg)
	local value = tonumber (f:read ("*n"))
	f:close ()
	
	if (value == nil) then
		return "${color4}N${color}"
	end

	if (value < 0) then
		return "${color4}" .. value .. "${color}"
	elseif (value > 0) then
		return "${color3}" .. value .. "${color}"
	else
		return value
	end
end

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
