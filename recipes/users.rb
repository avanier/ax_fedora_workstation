require 'base64'

bag_path = node['ax_workstation']['bag_path']

data_bag(bag_path).each do |some_user|
  user_data = data_bag_item(bag_path, some_user)

  user_shell = File.join('/bin/', user_data['shell'])
  user_home = user_data['home'] || File.join('/home', some_user)

  user some_user do
    home user_home
    shell File.exist?(user_shell) ? user_shell : '/bin/bash'
    password user_data['password'] || nil
  end

  directory user_home do
    owner some_user
    group some_user
    mode '0755'
    action :create
  end

  %w[
    .config
    .ssh
  ].each do |dir|
    directory File.join(user_home, dir) do
      owner some_user
      group some_user
      mode '0755'
      action :create
    end
  end

  # key management
  if user_data['keys']

    user_data['keys'].each do |k, v|

      if v.key?('private')
        file File.join(user_home, '.ssh', k) do
          content Base64.decode64(v['private'])
          mode '0600'
          owner some_user
          group some_user
          sensitive true
        end
      end

      file File.join(user_home, '.ssh', k + '.pub') do
        content Base64.decode64(v['public'])
        mode '0644'
        owner some_user
        group some_user
      end
    end

    authorized_keys = []

    user_data['keys'].select { |_k, v| v['authorized'] == true }.each_value do |v|
      authorized_keys.push(Base64.decode64(v['public'].strip))
    end

    file File.join(user_home, '.ssh/authorized_keys') do
      content authorized_keys.join
      mode '0644'
      owner some_user
      group some_user
      only_if { authorized_keys.any? }
    end
  end

  # sources management
  code_dir = File.join(user_home, user_data['code_dir'] || 'src')

  directory code_dir do
    owner some_user
    group some_user
    mode '0755'
    action :create
  end

  directory File.join(code_dir, '.chef_managed') do
    owner some_user
    group some_user
    mode '0700'
    action :create
  end

  if user_data['repositories'] # rubocop:disable Style/Next
    user_data['repositories'].each do |k, v|
      git File.join(code_dir, '.chef_managed', k) do
        repository v['repo']
        revision v['rev'] || 'HEAD'
        checkout_branch v['branch'] || 'master'
        enable_submodules true # just in case you're one of _those people_
        retries 3
        user some_user
        group some_user
        action :sync
      end

      execute "stow_#{k}" do
        command "/usr/bin/find . -maxdepth 1 -type d ! -name .git ! -name . | sed 's/\.\\///' | xargs -I \{\} /usr/bin/stow --restow --verbose 1 --target='#{user_home}' \{\}"
        cwd File.join(code_dir, '.chef_managed', k)
        live_stream true
        only_if { v['stowable'] == true }
      end
    end
  end
end
