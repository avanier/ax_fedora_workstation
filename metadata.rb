name 'ax_fedora_workstation'
maintainer 'Alexis Vanier'
maintainer_email 'alexis@amonoid.io'
license 'Apache-2.0'
description 'Installs/Configures knc_code_workstation'
long_description 'Installs/Configures ax_fedora_workstation'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

supports 'fedora'

source_url 'https://github.com/avanier/ax_fedora_workstation'
issues_url 'https://github.com/avanier/ax_fedora_workstation/issues'

depends 'chrome', '~> 4.0.2'
depends 'os-hardening', '~> 3.0.0'
depends 'ssh-hardening', '~> 2.3.1'
depends 'firefox', '~> 4.0.0'
