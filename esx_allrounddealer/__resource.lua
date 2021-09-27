resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'esx_allrounddealer'

version '1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/ger.lua',
	'locales/br.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/ger.lua',
	'locales/br.lua',
	'config.lua',
	'client/npc.lua',
	'client/main.lua',

}

dependencies {
	'es_extended'
}
