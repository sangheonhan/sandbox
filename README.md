# Sandbox Environment Docker Image

## Overview
This project provides a Docker image based on Ubuntu 24.04, equipped with essential development tools (such as curl, wget, vim, zsh, etc.) and a custom script to automatically configure the user environment within the container. It addresses file system permission issues and furnishes a ready-to-use development setting.

## Features
- Based on Ubuntu 24.04
- Includes a variety of development tools and language support
- Custom `entrypoint.sh` script for user environment setup
- Automated Docker image build and management via Makefile
- Locale settings for multilingual support

## Prerequisites
- Docker
- Docker Compose (optional, for managing multi-container Docker applications)
- Docker Buildx (if multi-architecture build support is required)

## Installation

### Environment Setup
Set the Docker image version in the `.env` file.
```env
VERSION=24.04
```

**Note:** To change the Ubuntu version, you must update the `VERSION` in the `.env` file and also adjust the `FROM` directive in the Dockerfile accordingly.

### Building the Image
Use the Makefile to build the Docker image.
```bash
make build
```

### Running the Container
To start the container, execute:
```bash
make start
```

## Usage

### Accessing the Container
To access the container, use:
```bash
make shell
```

### Stopping the Container
To stop the container, use:
```bash
make stop
```

## Customization
The `entrypoint.sh` script configures the user environment upon container startup. You can modify this script to apply additional settings as required.

## Contributing
Contributions are welcome! Please submit pull requests for any enhancements. Open an issue before submitting a pull request to discuss potential changes.

## License
This project is distributed under the GNU General Public License v3.0 (GPL-3.0), offering strong copyleft conditions that mandate derivative work to be distributed under the same license terms.
