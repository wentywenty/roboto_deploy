# roboto_deploy

本仓库包含 RoboParty 机器人平台在运行期间所需的启动部署脚本与系统层面的配置文件。

## 包含组件

- **`start_robot.sh`**: 系统一键启动脚本，负责在后台利用 `screen` 守护运行所有的核心节点（如手柄控制进程、AI 推理进程等）。
- **`rt_fastdds_profile.xml`**: 针对 Fast DDS 定制的专门应对实时要求（Real-time QoS）的配置文件。
- **`linux-router/`**: 包含配置机器人主板作为网络热点/路由等基建网络相关的脚本和工具。

## 安装

在机器人系统上执行：
```bash
sudo apt install roboto-deploy
```
对应的脚本及网络配置将自动部署到 `/opt/roboparty/` 相关的目录系统中。
