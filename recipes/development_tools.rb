rofi_build_deps = %w[
  pango-devel
  cairo-devel
  glib2
]

# This is sketchy on purpose, sue me.
local_variables.map(&:to_s).each do |v|
  next unless v =~ /_deps$/
  package "install_#{v}" do
    package_name binding.local_variable_get(v)
  end
end

yum_repository 'vscode' do
  description 'Visual Studio Code'
  baseurl 'https://packages.microsoft.com/yumrepos/vscode'
  gpgkey 'https://packages.microsoft.com/keys/microsoft.asc'
  action :create
end

package 'code'
