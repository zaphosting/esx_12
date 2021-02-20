fx_version 'adamant'

game 'gta5'

description 'ESX Vehicle Migrate'

version '0.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}

dependencies {
	'essentialmode',
	'es_extended',
	'mysql-async'
}
