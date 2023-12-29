# runonce
Systems scripts to run once upon boot


## To install 

run `sudo setup.sh` which will:
- create a user writable directory at `/etc/local/runonce.d`
- install an executable `runonce.sh` in `/etc/local/bin/`
- create and enable a systemd service installed at `/etc/systemd/system/runonce.service`

## Usage

Defer a script to run after next startup by placing it in `/etc/local/runonce.d/`

### Example
`cp test.sh /etc/local/runonce.d; sudo reboot`

