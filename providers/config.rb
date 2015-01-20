use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :create do
  templates = new_resource.templates.map { |v| Mash.from_hash(v) }

  # Create entries in configs-template dir but only if it's well formed
  templates.each_with_index do |v, i|
    fail "Missing source for #{i} entry at '#{new_resource.name}" if v[:source].nil?
    fail "Missing destination for #{i} entry at '#{new_resource.name}" if v[:destination].nil?
  end

  template ::File.join(node['consul_template']['config_dir'], new_resource.name) do
    cookbook 'consul-template'
    source 'config-template.json.erb'
    mode node['consul_template']['template_mode']
    variables(:templates => templates)
    not_if { templates.empty? }
  end
end
