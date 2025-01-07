<div align="center">

# asdf-gettext [![Build](https://github.com/eniayomi/asdf-gettext/actions/workflows/build.yml/badge.svg)](https://github.com/eniayomi/asdf-gettext/actions/workflows/build.yml) [![Lint](https://github.com/eniayomi/asdf-gettext/actions/workflows/lint.yml/badge.svg)](https://github.com/eniayomi/asdf-gettext/actions/workflows/lint.yml)

[gettext](https://github.com/eniayomi/gettext) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add gettext
# or
asdf plugin add gettext https://github.com/eniayomi/asdf-gettext.git
```

gettext:

```shell
# Show all installable versions
asdf list-all gettext

# Install specific version
asdf install gettext latest

# Set a version globally (on your ~/.tool-versions file)
asdf global gettext latest

# Now gettext commands are available
gettext --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/eniayomi/asdf-gettext/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Oluwapelumi Oluwaseyi](https://github.com/eniayomi/)
