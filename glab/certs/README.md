# GitLab TLS Certificates

## `gitlab-kfplc-chain.pem`

Certificate chain for `gitlab.kfplc.com` to fix TLS verification issues.

**Referenced in:** `~/.config/glab-cli/config.yml`
```yaml
hosts:
  gitlab.kfplc.com:
    ca_cert: /Users/szymondzumak/.config/glab-cli/certs/gitlab-kfplc-chain.pem
```

## Updating the Certificate

When GitLab renews its certificate, refresh the chain:

```bash
openssl s_client -showcerts -connect gitlab.kfplc.com:443 < /dev/null 2>/dev/null | \
  openssl x509 -outform PEM > ~/Developer/dotfiles/glab/certs/gitlab-kfplc-chain.pem
```

Then reinstall dotfiles to update the symlink:
```bash
cd ~/Developer/dotfiles && ./install.sh
```

## Installation

The certificate is automatically symlinked by `install.sh` to:
```
~/.config/glab-cli/certs/gitlab-kfplc-chain.pem
```
