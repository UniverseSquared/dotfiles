#! @ruby@/bin/ruby

require 'find'
require 'pathname'

$nom = '@nix-output-monitor@/bin/nom'
$nvd = '@nvd@/bin/nvd'

$templates = @templates@

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

def list_system_profiles
  Dir.children('/nix/var/nix/profiles')
    .filter { |e| e.start_with?('system-') && e.end_with?('-link') }
    .map { |e| e.delete_prefix('system-').delete_suffix('-link') }
    .map { |generation| generation.to_i }
    .sort
end

def deploy_to_deck(deck_ip)
  generation_store_path = `nix build --no-link --print-out-paths \
    /home/dawson/dotfiles#homeConfigurations.deck@waso.activationPackage`.strip

  # `remote-program=...` is a workaround for https://github.com/NixOS/nix/issues/1078
  `nix copy --verbose --to "ssh://deck@#{deck_ip}?remote-program=/home/deck/.nix-profile/bin/nix-store" \
    #{generation_store_path}`

  # `source .bash_profile` is a workaround for the same issue as above
  `ssh deck@#{deck_ip} -- 'source .bash_profile; #{generation_store_path}/activate'`
end

def rebuild_and_switch
  begin
    system(
      "nixos-rebuild switch --flake /home/dawson/dotfiles --sudo --log-format internal-json \
        |& #{$nom} --json"
    )

    profiles = list_system_profiles
    previous_generation = profiles[profiles.length - 2]
    previous_generation_path = "/nix/var/nix/profiles/system-#{previous_generation}-link"

    system("#{$nvd} diff #{previous_generation_path} /run/current-system")
  rescue Interrupt
    # exit gracefully on ctrl+c
  end
end

def switch
  deck_switch = ARGV.index '--deck'

  if deck_switch != nil then
    deploy_to_deck(ARGV[deck_switch + 1])
  else
    rebuild_and_switch
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
  switch
else
  puts "unknown command '#{ARGV[0]}'"
end
