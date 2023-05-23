# Darkstack overlay 

Darkstack packaging for Gentoo.

## Usage

### Manual way

Create the `/etc/portage/repos.conf/darkstack.conf` file as follows:

```
[darkstack]
priority = 50
location = <repo-location>/darkstack-overlay
sync-type = git
sync-uri = https://github.com/darkstack/darkstack-overlay.git
auto-sync = Yes
```

Change `repo-location` to a path of your choosing and then run `emerge --sync darkstack`, Portage should now find and update the repository.

### Eselect way

On terminal:

```bash
sudo eselect repository add darkstack git https://github.com/darkstack/darkstack-overlay.git
```

### Layman way

On terminal:

```bash
sudo layman -o https://github.com/darkstack/darkstack-overlay.git -f -a darkstack
```

And then run `emerge --sync darkstack`, Portage should now find and update the repository.

## Contributing

Plz do not. 

