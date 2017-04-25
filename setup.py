from setuptools import setup, Extension

try:
    from Cython.Build import cythonize
    file_ext = 'pyx'
except ImportError:
    file_ext = 'c'

ext = [Extension("cyrandom.cyrandom",
                 sources=["cyrandom/cyrandom." + file_ext,
                          "cyrandom/_mersenne.c",
                          "cyrandom/_seed.c"],
                 language='c')]

if file_ext == 'pyx':
    ext = cythonize(ext)

setup(
    name="cyrandom",
    version='0.3.0',
    description='Fast random number generation.',
    long_description="A fast cython replacement for the standard library's random module.",
    url='https://github.com/Noctem/cyrandom',
    author='David Christenson',
    author_email='mail@noctem.xyz',
    license='MIT',
    classifiers=[
        'Development Status :: 4 - Beta',
        'Intended Audience :: Developers',
        'Programming Language :: C',
        'Programming Language :: Cython',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3 :: Only',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'License :: OSI Approved :: MIT License'
    ],
    keywords='cyrandom random rng cython',
    packages=['cyrandom'],
    package_data={'cyrandom': ['cyrandom.pxd', '__init__.pxd']},
    ext_modules=ext)
