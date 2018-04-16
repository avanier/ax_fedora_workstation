# execute 'disable_vbox_additions_garbage' do
#   command '/usr/sbin/systemctl disable vbox'
#   live_stream true
#   not_if { `plymouth-set-default-theme`.include?("details") }
# end
