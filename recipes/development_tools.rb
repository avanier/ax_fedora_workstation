node.default['go']['version'] = node['ax_workstation']['go']['version']

include_recipe 'golang'

node.default['go']['packages'] = %w[
  github.com/wallix/awless
  github.com/adeven/go-wrk
  github.com/justwatchcom/gopass
]

include_recipe 'golang::packages'
