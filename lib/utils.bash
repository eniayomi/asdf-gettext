#!/usr/bin/env bash

set -euo pipefail

# GNU gettext is hosted on GNU's FTP server
MIRROR_URL="https://ftp.gnu.org/gnu/gettext"
TOOL_NAME="gettext"
TOOL_TEST="gettext --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

# Check if command exists
has_command() {
  command -v "$1" >/dev/null 2>&1
}

# Check macOS and Homebrew
check_mac_brew() {
  if [[ "$(uname)" == "Darwin" ]]; then
    if ! has_command brew; then
      fail "Homebrew is required to install gettext on macOS. Install from https://brew.sh"
    fi
  fi
}

curl_opts=(-fsSL)

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_all_versions() {
	# Fetch the directory listing from GNU mirror and extract version numbers
	curl "${curl_opts[@]}" "$MIRROR_URL/" | \
		grep -o 'gettext-[0-9][0-9.]*\.tar\.gz' | \
		sed 's/gettext-\([0-9][0-9.]*\)\.tar\.gz/\1/' | \
		sort_versions | uniq
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	# On macOS, we don't need to download the source
	if [[ "$(uname)" == "Darwin" ]]; then
		touch "$filename"  # Create empty file to satisfy asdf
		return 0
	fi

	url="$MIRROR_URL/gettext-${version}.tar.gz"
	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	# Check for Homebrew on macOS
	check_mac_brew

	if [[ "$(uname)" == "Darwin" ]]; then
		echo "Installing gettext via Homebrew on macOS..."
		brew install gettext

		# Create the install directory
		mkdir -p "$install_path"

		# Link Homebrew's gettext binaries to asdf's bin directory
		local brew_prefix
		brew_prefix=$(brew --prefix)
		local brew_gettext_bin="$brew_prefix/opt/gettext/bin"

		# Link all executables from Homebrew's gettext to asdf's bin directory
		for bin in "$brew_gettext_bin"/*; do
			if [[ -x "$bin" ]]; then
				ln -sf "$bin" "$install_path/$(basename "$bin")"
			fi
		done

		echo "$TOOL_NAME $version installation was successful!"
		return 0
	fi

	# For non-macOS systems, proceed with source installation
	(
		mkdir -p "$install_path"
		cd "$ASDF_DOWNLOAD_PATH"
		
		# Extract source
		tar xzf "gettext-${version}.tar.gz"
		cd "gettext-${version}"
		
		# Configure and build
		./configure --prefix="$install_path/.." || fail "Could not configure gettext build"
		make || fail "Could not build gettext"
		make install || fail "Could not install gettext"

		# Verify installation
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
