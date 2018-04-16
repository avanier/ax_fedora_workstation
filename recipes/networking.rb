networking_packages = %w[
  NetworkManager-bluetooth
  NetworkManager-config-connectivity-fedora
  NetworkManager-l2tp
  NetworkManager-libnm
  NetworkManager-openconnect
  NetworkManager-openconnect-gnome
  NetworkManager-openvpn
  NetworkManager-openvpn-gnome
  NetworkManager-pptp
  NetworkManager-pptp-gnome
  NetworkManager-vpnc
  NetworkManager-vpnc-gnome
  NetworkManager-wwan
]

package 'networking_packages' do
  package_name networking_packages
end
