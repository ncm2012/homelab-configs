# Pi Homelab Configuration Management

This repository contains configuration backups for my Raspberry Pi homelab setup.

## Current Projects

### Pi-hole + Cloudflare DNS-over-HTTPS
- **Location**: `pihole-cloudflare/`
- **Description**: Pi-hole ad blocker with Cloudflare DoH for privacy
- **Status**: Active on Pi
- **Last Backup**: 2025-08-12 20:43:58

## Repository Structure

```
/home/configs/
├── pihole-cloudflare/
│   ├── pihole/          # Pi-hole configuration backup
│   └── cloudflare/      # Cloudflared YAML backup
├── projects/            # Future project configurations
├── .gitignore          # Security exclusions
├── update-configs.sh   # Automated backup script
└── README.md           # This file
```

## Important Notes

- **This is a BACKUP repository** - configurations are copied, not moved
- Original configs remain in their active locations on the Pi
- Containers continue running during backup process
- Always test changes before committing to main branch

## Quick Start

### Backup Current Configurations
```bash
cd /home/configs
./update-configs.sh
```

### Add New Project
```bash
cd /home/configs/projects
mkdir new-project-name
cd new-project-name
# Set up your project here
```

### View Changes
```bash
git status
git log --oneline
```

## Workflow for Configuration Changes

1. **Stop containers** (required for config changes)
2. **Make changes** to active configurations
3. **Start containers** and test thoroughly
4. **Run backup script** to version control working configs
5. **Commit and push** changes

## Safety Features

- Files are **copied safely** without affecting running containers
- Sensitive files excluded via `.gitignore`
- Container-aware backup process
- Branch-based testing workflow available

## Repository Information

- **Local Path**: `/home/configs`
- **GitHub**: *[Repository URL will be shown by backup script]*
- **Created**: *[Date of setup]*
- **Last Updated**: *[Updated automatically]*

---

*Automated homelab configuration management for Raspberry Pi*
