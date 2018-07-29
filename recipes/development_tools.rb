node.default['go']['version'] = node['ax_workstation']['go']['version']

execute 'install-development-tools' do
  command '/usr/bin/dnf group install -y "Development Tools"'
  live_stream true
  not_if { ::File.exist?('/usr/bin/Xorg') }
end

development_packages = %w[
  autoconf
  automake
]

libvirt_packages = %w[
  libguestfs-tools-c
  libvirt
  libvirt-devel
  libxml2-devel
  libxslt-devel
  qemu
]

# This is sketchy on purpose, sue me.
local_variables.map(&:to_s).each do |v|
  next unless v =~ /_packages$/
  package "install_#{v}" do
    package_name binding.local_variable_get(v)
  end
end

include_recipe 'golang'

node.default['go']['packages'] = %w[
  github.com/wallix/awless
  github.com/adeven/go-wrk
  github.com/gopasspw/gopass
]

include_recipe 'golang::packages'
