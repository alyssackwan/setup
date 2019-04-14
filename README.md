If this OS instance is one to SSH into:

```bash
useradd -m -s /bin/bash me
passwd me
usermod -aG sudo
mkdir -p "${HOME}/.ssh"
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCl4EQ26OQ+BYQeOfDe2Whjh2pIcLhPv75jYkNdMY8c/ZAVDrW6fiChPaL8PCmkH+H60zrbIvR8VXUNfrZhDmKExBrBPvCBMPeVxVqGW86xr+OkeAEFWgFbNxJzBJhQZ7JXzzB4Bag2uNP3Vwp0P8fbrqfC7oDnszePoqp5d5ptjQyuzMofSj3yCYcZvz0GpuNxVliv6Pi0ciBWmWPRzx6bU3PepZtQVqwSbCgMC6tNKKuWOjvnI3I0aeDbKVPfKL2kqPKARks00VCvmx+cooo3DEBj4LczHhSsQP/wj6Wh0lm22jmAnO6oVhDnbBtq33f7lFMb+uxjMSjKS+ovIQirC+zUyzSKjWc8xdg4AyX8WrlCSNAEgqqjY8/jd6FUuCUI92Cl2+Clz9QfygawHda/e6jqbbu9BDbwDJQW+R07U0bxjV3k+AvkqsH39GEeuCHop/8kktfwYW6o7iQfjrHvFwG+VKwON1SX/G2+0vuLqcLy+cyqQBVUPA9JGj8wqm0JLuPTi2f41aVbgOdkuyp6gAtvLlHKFyOq6kwiegSi1zNx7ZGfPby1v144sedN/+ZgCf9cQU31IpGsDlNlJGT+fHvc/kwJVHJJBQbHsdrB0fGtSkPVNe8O1jWp5vrdsLHYwBbifGrbO0GfnQv95+uv45KzU8NBbwrvIegLkKHQhQ== me@alyssackwan.name' > "${HOME}/.ssh/authorized_keys"
chmod 600 "${HOME}/.ssh/authorized_keys"
```

For all OS instances:

```bash
pushd "${HOME}" && eval "$(curl -L https://raw.githubusercontent.com/jennykwan/setup/master/init.sh)" && popd
```
