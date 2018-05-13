execute 'install-base-x' do
  command '/usr/bin/dnf group install -y base-x'
  live_stream true
  not_if { ::File.exist?('/usr/bin/Xorg') }
end

wm_packages = %w[
  google-roboto-fonts
  mplus-fonts-common
  mplus-1c-fonts
  mplus-1m-fonts
  mplus-1p-fonts
  mplus-2c-fonts
  mplus-2m-fonts
  mplus-2p-fonts
  mplus-1mn-fonts
  terminus-fonts
  terminus-fonts-console
  lightdm
  gdm
]

package 'more_wm_packages' do
  package_name wm_packages
end

openbox_packages = %w[
  openbox
  openbox-libs
  obmenu
]

i3wm_packages = %w[
  i3
  i3-doc
  i3-ipc
  i3status
]

sxlock_deps = %w[
  pam-devel
  libXrandr-devel
]

rofi_deps = %w[
  cairo-devel
  check-devel
  flex
  librsvg2-devel
  libxcb-devel
  libxkbcommon-devel
  libxkbcommon-x11-devel
  pango-devel
  startup-notification-devel
  xcb-util-wm-devel
  xcb-util-xrm-devel
]

# This is sketchy on purpose, sue me.
local_variables.map(&:to_s).each do |v|
  next unless v =~ /_(deps|packages)$/
  package "install_#{v}" do
    package_name binding.local_variable_get(v)
  end
end

# Get crackin' on compiled dependencies
directory node['ax_workstation']['deps_folder'] do
  recursive true
end

# Install sxlock, the screen locker
git 'sxlock' do
  repository 'https://github.com/lahwaacz/sxlock'
  reference node['ax_workstation']['sxlock']['reference']
  destination File.join(node['ax_workstation']['deps_folder'], 'sxlock')
  notifies :run, 'execute[compile_sxlock]', :immediately
end

execute 'compile_sxlock' do
  command 'make'
  cwd File.join(node['ax_workstation']['deps_folder'], 'sxlock')
  notifies :run, 'execute[install_sxlock]', :immediately
  action :nothing
end

execute 'install_sxlock' do
  command 'make install'
  cwd File.join(node['ax_workstation']['deps_folder'], 'sxlock')
  action :nothing
end

# Install rofi
git 'rofi' do
  repository 'https://github.com/DaveDavenport/rofi'
  reference node['ax_workstation']['rofi']['reference']
  enable_submodules true
  destination File.join(node['ax_workstation']['deps_folder'], 'rofi')
  notifies :run, 'execute[configure_rofi]', :immediately
end

execute 'configure_rofi' do
  command 'autoreconf -i && ./configure'
  cwd File.join(node['ax_workstation']['deps_folder'], 'rofi')
  notifies :run, 'execute[compile_rofi]', :immediately
  action :nothing
end


execute 'compile_rofi' do
  command 'make'
  cwd File.join(node['ax_workstation']['deps_folder'], 'rofi')
  notifies :run, 'execute[install_rofi]', :immediately
  action :nothing
end

execute 'install_rofi' do
  command 'make install'
  cwd File.join(node['ax_workstation']['deps_folder'], 'rofi')
  action :nothing
end

# Set graphical target
execute 'enable_gdm' do
  command '/usr/bin/systemctl enable gdm'
  live_stream true
  not_if { File.exist?('/etc/systemd/system/display-manager.service') }
end

execute 'set_graphical_target' do
  command '/usr/bin/systemctl set-default graphical.target'
  live_stream true
  not_if { File.readlink('/etc/systemd/system/default.target') == '/usr/lib/systemd/system/graphical.target' }
end
