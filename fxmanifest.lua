fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'

author 'Bytesizd'
description 'A blindfold script for RedM and VorpCore Framework'

shared_scripts {
    'config.lua',
    'debug_init.lua'
}

server_scripts {
    'server/server.lua',
    'server/database.lua'
}

client_script {
    'client/client.lua',
    'client/utils.lua'
}

ui_page 'ui/index.html'

files {
    'ui/**/*'
}

version '1.1.0'
