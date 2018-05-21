bag_path = node['ax_workstation']['bag_path']

groups = []

data_bag(bag_path).each do |u|
  user_data = data_bag_item(bag_path, u)
  next unless user_data.key?('groups')
  user_data['groups'].each do |g|
    groups.push(g)
  end
end

groups.uniq.each do |g|
  users = []

  data_bag(bag_path).each do |u|
    user_data = data_bag_item(bag_path, u)
    next unless user_data.key?('groups')
    next unless user_data['groups'].include?(g)
    users.push(u)
  end

  group g do
    members users
  end
end

sudo_groups = node.deep_fetch('ax_workstation', 'sudo_groups') || []

sudo_groups.each do |gr|
  sudo gr do
    group gr
    nopasswd true
  end
end
