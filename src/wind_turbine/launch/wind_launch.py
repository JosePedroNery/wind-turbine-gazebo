#!/usr/bin/env python3
import os
import launch
import launch_ros.actions
from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription, DeclareLaunchArgument
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory

def generate_launch_description():
    # Diretório do pacote 'cleitinho'
    pkg_cleitinho = get_package_share_directory("wind_turbine")

    # Caminho para o arquivo do mundo (SDF)
    world_path = os.path.join(pkg_cleitinho, "worlds", "wind_world.sdf")

    # Inicia o Gazebo com o mundo especificado usando o launch do ros_gz_sim
    gazebo = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(
            os.path.join(get_package_share_directory("ros_gz_sim"), "launch", "gz_sim.launch.py")
        ),
        launch_arguments={"gz_args": f"-r {world_path}"}.items(),
    )

    # Ponte entre o ROS 2 e o Gazebo (ros_gz_bridge)
    ros_ign_bridge = Node(
        package="ros_gz_bridge",
        executable="parameter_bridge",
        arguments=[
            # Ponte para os comandos de velocidade
            "/cmd_vel@geometry_msgs/msg/Twist@ignition.msgs.Twist",
            
            # Ponte para os dados do Lidar
            "/lidar@sensor_msgs/msg/LaserScan@ignition.msgs.LaserScan",

            # Ponte para os dados do GPS (caso queira usar depois)
            "/navsat@sensor_msgs/msg/NavSatFix@ignition.msgs.NavSat",

            # Ponte para os dados do IMU (caso queira usar depois)
            "/imu@sensor_msgs/msg/Imu@ignition.msgs.IMU",

            # Ponte para câmera
            "/camera@sensor_msgs/msg/Image[ignition.msgs.Image",

            # Ponte para os dados de odometria
            "/odom@nav_msgs/msg/Odometry@ignition.msgs.Odometry",

        ],
        output="screen"
    )



    return LaunchDescription([
        gazebo,
        ros_ign_bridge,
       
    ])
