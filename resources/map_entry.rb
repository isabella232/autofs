resource_name :map_entry
default_action :create

property :fstype, String, default: 'nfs4'
property :key, String, name_property: true
property :location, String
property :map, String, required: true
property :mount_point, String, default: lazy { '/' + map.match(/(?:\.)(.*)/).captures.first }
property :options, String

action :create do # rubocop:disable Metrics/BlockLength
  file new_resource.map

  automaster_entry new_resource.mount_point do
    map new_resource.map
  end

  opts = if !new_resource.options
           new_resource.fstype
         else
           [new_resource.fstype, new_resource.options].join(',')
         end

  service 'autofs' do
    action :nothing
  end

  replace_or_add new_resource.key do
    line "#{new_resource.key} -fstype=#{opts} #{new_resource.location}"
    path new_resource.map
    pattern "#{Regexp.escape(new_resource.key)}\s.*"
    notifies :reload, 'service[autofs]'
  end

  case new_resource.fstype
  when 'nfs4'
    include_recipe 'chef-sugar'
    debian? ? (package 'nfs-common') : (package 'nfs-utils')
  else
    log 'NFS type not set or supported' do
      message 'NFS type not set or supported'
      level :debug
    end
  end
end
