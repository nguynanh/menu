fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'nguyen'
description 'Item Spawner '
version '2.0.0'

ui_page 'web/index.html'

shared_scripts {
	'@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua',
}

server_scripts {
	'server/*.lua',
}

files {
	'web/*'
}

-- Đảm bảo script của bạn được load sau qb-core
ensure 'qb-core'