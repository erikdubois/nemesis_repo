<p align="center">
  <img src="kiro.jpg" alt="Kiro" width="220" />
</p>

# NEMESIS REPOSITORY

A pacman package repository for Kiro and Arch-based systems. It holds the
extra software you install **after** a clean install — the desktop apps,
themes, and tools (Spotify and friends) that aren't part of the base system.

Learn, have fun and enjoy.

> **Note** — this is *not* the install-time repo. The `kiro_repo` is used by the
> Calamares installer while building the system and disappears after reboot.
> The nemesis repo is the one you opt into and keep, to pull in extras whenever
> you like.

## Add the repository

Add this to your `/etc/pacman.conf` with npacman or the ATT:

```
[nemesis_repo]
SigLevel = Never
Server = https://erikdubois.github.io/$repo/$arch
```

Or download and run the script:

```
curl -sL bit.ly/nemesis-repo | sudo bash
```

## Watch this video

[![Watch the video](https://img.youtube.com/vi/ocKZIzAb7GQ/maxresdefault.jpg)](https://youtu.be/ocKZIzAb7GQ)

# Websites

Information : https://erikdubois.be

# Social Media

Youtube : https://www.youtube.com/erikdubois
