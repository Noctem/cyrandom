#!/usr/bin/env bash

set -e -x

# Compile wheels
for PYBIN in /opt/python/cp3*/bin; do
	"${PYBIN}/pip" install -U cython
	"${PYBIN}/pip" wheel /io/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
	auditwheel repair "$whl" -w /io/wheelhouse/
done

# Install packages and test
for PYBIN in /opt/python/cp3*/bin/; do
	"${PYBIN}/pip" install cyrandom --no-index -f /io/wheelhouse
	"${PYBIN}/python" /io/test_cyrandom.py
done
