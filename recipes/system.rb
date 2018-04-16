system_packages = %w[
  akmods
  dkms
]

package 'system_packages' do
  package_name system_packages
end

execute 'enable_verbose_plymouth' do
  command '/usr/sbin/plymouth-set-default-theme details -R'
  live_stream true
  not_if { `plymouth-set-default-theme`.include?('details') }
end

execute 'remove_grub_quiet' do
  command "/usr/bin/sed --silent --in-place 's/.quiet//' /etc/default/grub"
  live_stream true
  notifies :run, 'execute[rebuild_grub2_bios]', :delayed
  notifies :run, 'execute[rebuild_grub2_efi]', :delayed
  only_if { File.read('/etc/default/grub').include?('quiet') }
end

execute 'rebuild_grub2_bios' do
  command '/usr/sbin/grub2-mkconfig -o /boot/grub2/grub.cfg'
  live_stream true
  action :nothing
end

execute 'rebuild_grub2_efi' do
  command '/usr/sbin/grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg'
  live_stream true
  action :nothing
end
