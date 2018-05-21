text_editor_packages = %w[
  emacs
]

python_package 'awscli'
python_package 'httpie'

yum_repository 'google-cloud-sdk' do
  baseurl 'https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64'
  gpgkey [
    'https://packages.cloud.google.com/yum/doc/yum-key.gpg',
    'https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg'
  ]
  gpgcheck true
  repo_gpgcheck true
  enabled true
  action :create
end

gcloud_packages = %w[
  kubectl
  google-cloud-sdk
]

# This is sketchy on purpose, sue me.
local_variables.map(&:to_s).each do |v|
  next unless v =~ /_packages$/
  package "install_#{v}" do
    package_name binding.local_variable_get(v)
  end
end
