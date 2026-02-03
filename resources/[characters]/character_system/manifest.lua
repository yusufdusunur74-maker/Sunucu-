fx_version 'cerulean'
game 'gta5'

author 'Sunucu Geliştirici'
description 'Çoklu karakter ve karakter oluşturma sistemi'
version '0.1.0'

shared_script 'shared/config.lua'

server_scripts {
  'server/main.lua'
}

client_scripts {
  'client/main.lua'
}

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/style.css',
  'html/script.js'
}
