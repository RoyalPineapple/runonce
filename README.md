# RunOnce
Systemd scripts to run once upon next boot


## To install 
run `sudo setup.sh` which will:
- create a user writable directory at `/etc/local/runonce.d`
- install an executable script `runonce.sh` in `/etc/local/bin/`
- create and enable a systemd service installed at `/etc/systemd/system/runonce.service`
- install a helper `reboot-defer` command in `/usr/local/bin`

## Usage
Defer a script to run after next startup with the `reboot-defer` command

>`reboot-defer foo.sh`


You can also add a deferred script by placing it in `/etc/local/runonce.d/`

>`cp test.sh /etc/local/runonce.d`
