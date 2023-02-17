fx_version 'cerulean'
game 'gta5'

client_scripts {
	'@vrp/lib/utils.lua',
	"master-client/*.lua",
	"config/config.lua"
}

server_scripts {
	'@vrp/lib/utils.lua',
	"master-server/*.lua",
	"config/config.lua"
}