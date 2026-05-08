# roboto_deploy

This repository contains deployment and runtime configurations for the RoboParty robots.

## Features

- **`start_robot.sh`**: The main entry point script intended for launching the system nodes (e.g. inference, joystick) within background `screen` sessions.
- **`rt_fastdds_profile.xml`**: Real-time QoS profile configuration for Fast DDS.
- **`linux-router/`**: Tools and configurations for network infrastructure and routing on the robot.

## Installation

```bash
sudo apt install roboto-deploy
```
Scripts and configs will be placed into the appropriate directories under `/opt/roboparty/`.
