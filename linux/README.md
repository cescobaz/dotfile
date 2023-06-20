## Driver

Use `modprobe` to enable or disable a driver, e.g.:

```bash
sudo modprobe -r 8821au
sudo modprobe 8821au
```

Sometimes "reloading" the driver will make the device working.

Driver options or blacklist could be stored in any file inside `/etc/modprobe.d/`
