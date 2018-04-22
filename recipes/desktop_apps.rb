include_recipe 'chrome'
include_recipe 'firefox'

security_packages = %w[
  gnupg2
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

# This is sketchy on purpose, sue me.
local_variables.map(&:to_s).each do |v|
  next unless v =~ /_packages$/
  package "install_#{v}" do
    package_name binding.local_variable_get(v)
  end
end

include_recipe 'vscode'
