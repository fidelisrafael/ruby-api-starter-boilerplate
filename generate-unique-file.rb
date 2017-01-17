files = [
  'helpers',
  'minimal',
  'auth',
  'complete',
  'full'
]

BASE_DIR = File.expand_path(File.dirname(__FILE__))

dest_file = File.open(File.join(BASE_DIR, 'template.rb'), 'wb')
dest_file.puts <<-CODE
### ATTENTION:
### This file is auto generated by `generate-unique-file.rb`. Please, don't edit this file.
### If you want to edit this code, please refer to files in scripts/ folder

require 'pry'

def source_paths
  [File.expand_path(File.join(File.dirname(__FILE__), 'template_files'))]
end

CODE

files.each do |file|
  content = File.read(File.join(BASE_DIR, "scripts/#{file}.rb"))

  content.gsub!("require_relative 'helpers'", "")
  dest_file.puts content
end


dest_file.puts <<-CODE
module GrappiTemplate

  GRRAPI_FLAG = "--grrapi-template-mode"

  def init_grrapi_template_action!(argv)
    application_types = [
      'minimal',
      'auth',
      'complete',
      'full'
    ]


    default_app_type = 'minimal'
    current_app_type = argv.find {|v| v.match(/\#{GRRAPI_FLAG}=(\\w+)/) }

    application_mode = (current_app_type ? (current_app_type.match(/\#{GRRAPI_FLAG}=(\\w+)/) && $1)  : default_app_type ).downcase

    raise "Invalid application mode \#{application_mode}" unless application_types.member?(application_mode)

    extend GrappiTemplate.const_get(application_mode.capitalize)

    self.send("run_\#{application_mode}_template!")
  end
end

extend GrappiTemplate

init_grrapi_template_action!(ARGV)
CODE

dest_file.close

