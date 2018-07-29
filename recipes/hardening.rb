node.default['os-hardening']['desktop']['enable'] = true
node.default['os-hardening']['network']['forwarding'] = true
node.default['os-hardening']['security']['init']['single'] = true
node.default['os-hardening']['security']['kernel']['disable_filesystems'] = [ 'cramfs', 'freevxfs', 'jffs2', 'hfs', 'squashfs', 'udf' ]
node.default['os-hardening']['security']['packages']['clean'] = false
node.default['os-hardening']['security']['packages']['list'] = []
node.default['os-hardening']['security']['selinux_mode'] = 'enforcing'

include_recipe 'os-hardening'
include_recipe 'ssh-hardening'

# This hack is evil, it dynamically replace the wrapped cookbook's template
# Check some documentation below
# https://coderanger.net/rewind/
# https://www.sethvargo.com/changing-chef-resources-at-runtime/
edit_resource!(:template, '/etc/pam.d/system-auth-ac') do
  source 'rhel_system_auth.erb'
  cookbook 'ax_fedora_workstation'
end
