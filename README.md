# Buro home

## Install

### Complete installation

```bash
cd ~/xhome
./macosx_install.sh
```

### Step by step installation

Install software
```bash
cd ~/xhome
./macosx_brew.sh
```

Install home links
```bash
cd ~/xhome
./macosx_install_links.sh
```

## Notes

`.npmrc` contains `ignore-scripts=true`, that is a security config that does not allow npm deps to run arbitrary scripts.
```bash
# check configurations
npm config list -l

# set config
npm config set ignore-scripts true
```

