#!/usr/bin/env bash

set -e

macbuild() {
	pip3 install -U twine setuptools wheel
	rm -rf dist build
	if [[ "$1" = "sdist" && "$SOURCE" = TRUE ]]; then
		python3 setup.py sdist bdist_wheel
		twine upload --skip-existing dist/*.whl dist/*.tar.*
	else
		python3 setup.py bdist_wheel
		twine upload --skip-existing dist/*.whl
	fi
}

if [[ "$DOCKER_IMAGE" ]]; then
	pip3 install -U twine
	twine upload --skip-existing wheelhouse/*.whl
	echo "Successfully uploaded Linux wheels."
else
	macbuild sdist
	echo "Successfully uploaded Python 3.6 wheel and source."

	cd travis
	brew uninstall python3
	brew install python35.rb
	cd ..
	echo "Successfully installed Python 3.5."

	macbuild
	echo "Successfully uploaded Python 3.5 wheel."
fi
