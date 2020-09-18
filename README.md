# arch-virtualbox-vagrant

Packer template for arch with virtualbox + vagrant provisioning

## Installation

```bash
git clone git@github.com:jstenmark/arch-virtualbox-vagrant.git && cd arch-virtualbox-vagrant
chmod +x build.sh
```

## Usage

```bash
./build.sh
mkdir ../archbox && cd ../archbox
vagrant init $boxname
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
