fx_version 'cerulean'
game 'gta5'

author 'copilot'
description 'Basit inventory stub for Sunucu- (ps-inventory integration to follow)'
version '1.0.0'

shared_script 'shared/config.lua'
server_script 'server/main.lua'
client_script 'client/main.lua'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/script.js',
  'html/style.css'
}
fx_version 'cerulean'
game 'gta5'

author 'Sunucu Geliştirici'
description 'Envanter Sistemi'
version '1.0.0'

client_scripts {
    'client/main.lua',
    'client/inventory.lua'
}

server_scripts {
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}
