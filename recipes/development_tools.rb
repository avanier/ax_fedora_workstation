node.default['go']['version'] = '1.10.2'

include_recipe 'golang'

node.default['go']['packages'] = %w[
  github.com/wallix/awless
  github.com/adeven/go-wrk
  github.com/justwatchcom/gopass
]

include_recipe 'golang::packages'
