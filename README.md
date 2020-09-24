# packer-arch-virtualbox-vagrant
Packer buildtools for arch


## Features
* Creates virtualbox image
* Creates and deploys vagrant box
* Packer config generator
* Vagrant provisioning template
* CI pipeline
* Commit hooks

## TODO
* btrfs
* dotfiles entrypoint

## Installation
```bash
git clone git@github.com:jstenmark/arch-virtualbox-vagrant.git
chmod +x entry.sh
```

## Usage
```bash
./entry.sh build
mkdir ../archbox && cd ../archbox
vagrant init $boxname
```

## Dependencies
* packer
* vagrant
* virtualbox
* shellcheck
* shfmt (install script included)

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
