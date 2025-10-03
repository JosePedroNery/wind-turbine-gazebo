#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
import time

class DroneTeleop(Node):
    def __init__(self):
        super().__init__('drone_teleop')
        self.pub = self.create_publisher(Twist, '/cmd_vel', 10)
        self.start_time = time.time()
        self.timer = self.create_timer(0.1, self.send_cmd)

    def send_cmd(self):
        t = time.time() - self.start_time
        msg = Twist()

        if t < 2.0:
            msg.linear.z = 2.0  # sobe
        elif t < 5.0:
            msg.linear.z = 0.0  # paira
        else:
            msg.linear.z = -1.0  # desce

        self.pub.publish(msg)

def main(args=None):
    rclpy.init(args=args)
    node = DroneTeleop()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
