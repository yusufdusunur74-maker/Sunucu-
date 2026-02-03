fx_version 'cerulean'
game 'gta5'

author 'Sunucu Geliştirici'
description 'Banka Yönetim Sistemi'
version '1.0.0'

client_scripts {
    'client/main.lua',
    'client/ui.lua'
}

server_scripts {
    'server/main.lua'
}

shared_scripts {
    'shared/config.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}
