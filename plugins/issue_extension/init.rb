require 'redmine'

require_dependency 'issue_extension/hooks'

Redmine::Plugin.register :issue_extension do
  name 'Issue Extension plugin'
  author 'Loriowar'
  description 'Small extension for temporary removing issues'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end

Rails.configuration.to_prepare do
  %w(issues_controller issue issues_helper).each do |resource|
    plugin_name = 'issue_extension'
    resource_patch = [plugin_name, [resource, 'patch'].join('_')].join('/')
    resource_constant, resource_patch_constant = [resource, resource_patch].map(&:camelize).map(&:constantize)

    resource_constant.send(:include, resource_patch_constant) unless resource_constant.included_modules.include? resource_patch_constant
  end
end
