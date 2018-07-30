include_recipe 'chrome'
include_recipe 'firefox'

package 'snapd'

# not_if snap list | awk '{print $1}' | grep -vE '^Name'

snap_applications = %w[
  signal-desktop
]

snap_applications.each do |app|
  execute "install_snap_application_#{app}" do
    command "snap install #{app}"
    live_stream true
    not_if { Mixlib::ShellOut.new('snap list |  awk "{print $1}" | grep -vE "^Name"').run_command.stdout.include?(app) }
  end
end

security_packages = %w[
  usbguard
  usbguard-tools
  usbguard-applet-qt
  policycoreutils-python-utils
  gnupg2
  pgpdump
  kgpg
]

email_packages = %w[
  thunderbird
  thunderbird-enigmail
]

utility_packages = %w[
  feh
  xautolock
  xscreensaver
  xscreensaver-base
]

sound_packages = %w[
  pulseaudio-equalizer
  pavucontrol
  pasystray
  soxr
]

# package "https://downloads.slack-edge.com/linux_releases/slack-#{node['ax_workstation']['slack']['version']}.rpm"

# This is sketchy on purpose, sue me.
local_variables.map(&:to_s).each do |v|
  next unless v =~ /_packages$/
  package "install_#{v}" do
    package_name binding.local_variable_get(v)
  end
end

include_recipe 'vscode'
