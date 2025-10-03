import os
from setuptools import setup

package_name = 'wind_turbine'

setup(
    name=package_name,
    version='0.0.0',
    packages=[package_name],
    data_files=[
        ('share/' + package_name, ['package.xml']),
        (os.path.join('share', package_name, 'launch'), ['launch/wind_launch.py']),
        (os.path.join('share', package_name, 'worlds'), ['worlds/wind_world.sdf']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='Seu Nome',
    maintainer_email='seu@email.com',
    description='Simulação de turbina eólica para o TCC',
    license='Apache License 2.0',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'teleop_cmd_vel = teleop_cmd_vel:main',
        ],
    },
)
