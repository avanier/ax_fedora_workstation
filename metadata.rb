name 'ax_fedora_workstation'
maintainer 'Alexis Vanier'
maintainer_email 'alexis@amonoid.io'
license 'Apache-2.0'
description 'Installs/Configures knc_code_workstation'
long_description 'Installs/Configures knc_code_workstation'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

supports 'fedora'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/knc_code_workstation/issues'

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/knc_code_workstation'

depends 'ssh-hardening', '~> 2.3.1'
depends 'os-hardening', '~> 3.0.0'
