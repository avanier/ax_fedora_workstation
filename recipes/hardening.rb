node.default['os-hardening']['desktop']['enable'] = true
node.default['os-hardening']['security']['packages']['clean'] = false
node.default['os-hardening']['security']['packages']['list'] = []
node.default['os-hardening']['security']['selinux_mode'] = 'enforcing'
node.default['os-hardening']['network']['forwarding'] = true

include_recipe 'os-hardening'
include_recipe 'ssh-hardening'
