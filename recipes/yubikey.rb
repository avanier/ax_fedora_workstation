yubikey_packages = %w[
  libu2f-host
  libu2f-host-devel
  libu2f-server
  libu2f-server-devel
  libyubikey
  libyubikey-devel
  pam_yubico
  pam-u2f
  pamu2fcfg
  python3-yubikey-manager
  u2f-hidraw-policy
  u2f-host
  u2f-server
  ykclient
  ykpers
  yubico-piv-tool-devel
  yubikey-personalization-gui
  yubioath-desktop
]

# This is sketchy on purpose, sue me.
local_variables.map(&:to_s).each do |v|
  next unless v =~ /_(deps|packages)$/
  package "install_#{v}" do
    package_name binding.local_variable_get(v)
  end
end
