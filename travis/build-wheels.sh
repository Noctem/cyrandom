#!/usr/bin/env bash

set -e -x

# Compile wheels
for PIP in /opt/python/cp3[56789]*/bin/pip; do
	"$PIP" install -U cython
	"$PIP" wheel /io/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for WHL in wheelhouse/*.whl; do
	auditwheel repair "$WHL" -w /io/wheelhouse/
done

# Install packages and test
for PYBIN in /opt/python/cp3[56789]*/bin/; do
	"${PYBIN}/pip" install cyrandom --no-index -f /io/wheelhouse
	"${PYBIN}/python" /io/test_cyrandom.py
done
