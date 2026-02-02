# Ansible Package Management

## Current Setup

Packages managed via: `~/.config/ansible/setup-packages.yml`

## Usage

**Install everything (APT + GitHub releases):**

```bash
ansible-playbook -i ~/.config/ansible/inventory ~/.config/ansible/setup-packages.yml --ask-become-pass
```

**Dry run (check what would change):**

```bash
ansible-playbook -i ~/.config/ansible/inventory ~/.config/ansible/setup-packages.yml --check --ask-become-pass
```

## Requirements

**Install Ansible:**

```bash
sudo apt update
sudo apt install ansible
```

## Full Package List

See all currently installed manually:

```bash
apt-mark showmanual | sort
```

## Tips

**Add new machine:**

1. Copy `~/.config/ansible/` to new machine
2. Run playbook
3. Done!
