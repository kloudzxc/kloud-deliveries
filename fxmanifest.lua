fx_version 'cerulean'
game 'gta5'

lua54 'yes'
author 'kloud'
description '[QB/ESX] Food Delivery Job'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua'
}

client_scripts {
    'client/*.lua',
    'client/framework/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
    'server/framework/*.lua',
    'inventory/*.lua',
}

dependencies {
    'oxmysql',
    'ox_lib'
}
