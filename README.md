# Wind Turbine Simulation for Gazebo & ROS 2

A simulation environment for a wind turbine using Gazebo and ROS 2 Humble. This project provides a ready-to-launch world and the necessary ROS 2 packages to interact with the model.

---

##  Prerequisites

Before you begin, ensure your system meets the following requirements:

* **Operating System**: **Ubuntu 22.04 LTS** is the officially supported OS.
* **Software**: You must have successfully installed **ROS 2 Humble** and **Gazebo**.

---

## Running the Simulation

To launch the Gazebo world and start the simulation, follow these steps:

1.  **Navigate to the project's root directory:**
    ```bash
    cd wind-turbine-gazebo
    ```

2.  **Source the workspace to set up the environment:**
    (This command loads the project's packages into your current terminal session)
    ```bash
    source ~/wind-turbine-gazebo/install/setup.bash
    ```

3.  **Launch the simulation:**
    ```bash
    ros2 launch wind_turbine wind_launch.py
    ```
