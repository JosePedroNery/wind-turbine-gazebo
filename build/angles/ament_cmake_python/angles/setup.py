from setuptools import find_packages
from setuptools import setup

setup(
    name='angles',
    version='1.15.0',
    packages=find_packages(
        include=('angles', 'angles.*')),
)
