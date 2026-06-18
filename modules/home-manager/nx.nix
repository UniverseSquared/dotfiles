{ self, ... }:

{
  home.packages = [ self.packages.x86_64-linux.nx ];
}
