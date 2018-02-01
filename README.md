# hide.sh

hide.sh is a bash program to easily hide value of environment variables in log file.

## Usage

### Installing

Install hide.sh in a directory and run it !

```
# Get hide.sh
chmod +x hide.sh
./hide.sh -v
```

### Hide a variable

To easily hide a variable in a file.

```
./hide.sh -m P4ssw0rd tests/output.xml
```

## Running the tests

You should have as prerequisites a Python environment and pip installed. Tests are runned with [Robot Framework](http://robotframework.org/).

```
# Installation of Robot Framework
pip install -r tests/requirements.txt
# Run Tests
robot tests/
```

### And coding style

Code is reviewed with [ShellCheck](https://github.com/koalaman/shellcheck).

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/jfx/hide.sh/tags).

## Authors

* **FX Soubirou** - *Initial work* - [Github repositories](https://github.com/jfx)

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version. See the [LICENSE](LICENSE) file for details.
