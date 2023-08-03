fx_version 'cerulean'
game 'gta5'

lua54 'yes'
author 'kloud'
description 'QBCore Food Delivery Job'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua'
}

client_scripts {
    'client/*.lua',
    'client/framework/*.lua'
}

server_scripts {
    'server/*.lua',
    'server/framework/*.lua',
    'inventory/*.lua',
}

dependencies {
    'rpemotes',
    'ox_lib'
}
