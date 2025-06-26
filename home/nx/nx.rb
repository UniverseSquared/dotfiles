require 'find'
require 'pathname'

def substitute_templates(contents, project_name)
  contents.gsub(/%%(.+?)%%/) {
    case $1
    in 'project-name'
      project_name
    end
  }
end

def create_project_from_template(template_name, project_name)
  template_path = $templates[template_name]["path"]
  project_path = "#{Dir.pwd}/#{project_name}"

  Dir.mkdir(project_path) unless Dir.exist? project_path

  Find.find(template_path) { |file|
    filepath = Pathname(file)
    next unless filepath.file?

    destination = "#{project_path}#{file.delete_prefix(template_path)}"
    destination = substitute_templates(destination, project_name)

    destination = Pathname(destination)
    Dir.mkdir(destination.parent) unless Dir.exist? destination.parent

    contents = File.read(filepath)
    contents = substitute_templates(contents, project_name)
    File.write(destination, contents)
  }
end

def rebuild_and_switch
  begin
    system(
      "nixos-rebuild switch --flake /home/dawson/dotfiles --sudo --log-format internal-json |& nom --json"
    )
  rescue Interrupt
    # exit gracefully on ctrl+c
  end
end

if ARGV[0] == "new" then
  template_name = ARGV[1]
  project_name = ARGV[2]

  if template_name.include? '#' or template_name.include? ':' then
    system("nix flake new -t #{template_name} #{project_name}")
  else
    create_project_from_template(template_name, project_name)
  end
elsif ARGV[0] == "switch" then
  rebuild_and_switch
else
  puts "unknown command '#{ARGV[0]}'"
end
