# devbox

An isolated Linux machine in OrbStack

```fish
cd ~/projects/tjoskar/dotfiles
orb create --isolated --memory 24G --cpus 8 --disk 200G \
  -c devbox/cloud-init.yaml ubuntu:24.04 devbox
```
