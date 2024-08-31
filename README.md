# Zendoom 🌱

**Zendoom** is a tool for mitigating DDoS attacks on servers. It monitors incoming traffic and automatically blocks suspicious IPs.

## Repository Structure

- `scripts/`: Contains the necessary scripts.
  - `zendoom.sh`: The main script for mitigating DDoS attacks.
  - `install.sh`: Script for installing dependencies and setting up the environment.
  - `start.sh`: Script for starting `zendoom.sh` in the background.
- `logs/`: Directory for storing log files.
  - `zendoom.log`: Activity log file.
  - `zendoom_blocked_ips.log`: File for blocked IPs.

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/ginozza/zendoom.git
   cd zendoom
   ```

2. **Run the installation script:**

   ```bash
   sudo bash scripts/install.sh
   ```

   This script will install the necessary dependencies (`iptables` and `net-tools`) and set up the environment for Zendoom.

## Setup

1. **Create the `logs/` directory and log files:**

   Before running the script, create the required directory and log files:

   ```bash
   mkdir logs
   touch logs/zendoom.log
   touch logs/zendoom_blocked_ips.log
   ```

   Ensure that the script has permission to write to these files:

   ```bash
   chmod 644 logs/zendoom.log
   chmod 644 logs/zendoom_blocked_ips.log
   chmod 755 logs
   ```

## Usage

1. **Start the mitigation script:**

   To start the Zendoom script in the background, use the following command:

   ```bash 
   scripts/start.sh
   ```

   This will start `zendoom.sh` in the background, monitoring and mitigating DDoS attacks.

2. **Adjust configurations:**

   - To change the maximum number of allowed connections, the time window, or the ban duration, edit the `zendoom.sh` script directly or use the following commands:

     - **Set maximum connections:**

       ```bash 
       scripts/zendoom.sh set-max <num>
       ```

     - **Set time window:**

       ```bash 
       scripts/zendoom.sh set-window <num>
       ```

     - **Set ban duration:**

       ```bash 
       scripts/zendoom.sh set-ban <num>
       ```

3. **View blocked IPs:**

   To list the currently blocked IPs, use:

   ```bash 
   scripts/zendoom.sh list
   ```

4. **Unblock an IP manually:**

   To unblock a specific IP, use:

   ```bash 
   scripts/zendoom.sh unblock <ip>```

5. **Show logs:**

   To view the activity logs, use:

   ```bash 
   scripts/zendoom.sh logs```

## Considerations

- Ensure that `iptables` and `net-tools` are installed on your system. The `install.sh` script handles this installation.
- Log files are stored in the `logs/` directory. Make sure the script has permissions to write to this directory.
- For persistent deployment, consider adding `scripts/start.sh` to your system's startup scripts to ensure Zendoom starts automatically when the server boots.

## Contributions

Contributions are welcome. Please submit a pull request with your improvements or fixes.

## License

This project is licensed under the [MIT License](LICENSE).
