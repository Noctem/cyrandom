from setuptools import setup, Extension
from Cython.Build import cythonize

ext = Extension("cyrandom",
                sources=["cyrandom.pyx",
                         "_mersenne.c",
                         "_seed.c"])

setup(
    name="cyrandom",
    ext_modules = cythonize([ext],
                            compiler_directives={'language_level': 3})
)
