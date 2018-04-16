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
