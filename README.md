# Cyberdeck - Version 1

This repo holds the progress and results of my first attempt at creating a cyberdeck

### Goals
Create a small laptop that is able to support writing code.

On top of creating a dev laptop I want it to support the following
- Reduced mouse use
	- Model dev environment
	- Scroll based windows management
	- Support touch screen for the limited scenarios where a pointer is needed
- Learn NixOS
	- Create a OS config
	- Learn how to switch key elements of a linux environment cleanly
- Improve shell skills
- Discover TUI counterparts to existing tools
- Develop a collection of TUI apps to fill in the gaps

### Limitations

As this is my first attempt I wish to keep it simple, so the following elements will be omitted from this version

Not included 
- Complex / hand built power system
- integrated micro controllers
- Custom screens
- Custom sensors
- MC comms bus

To keep it simple
- Computer will be constructed using largely off the shelf components that just need to be connected together via standard connectors

## Parts


Shopping list
- A screen that is roughly the same dimensions as the keyboard ideally wide screen resolution to support displaying multiple elements at the same time.
- A passively cooled x86 single board computer. Passively cooled to improve battery life, hopefully throttling will not be a issue. x86 to improve software compatibility 

- Screen - Waveshare10.4HP-CAPQLED 
- Computer - MeLE PCG02 Pro Fanless Stick PC 8GB
- Keyboard - Logitech Pebble K380s
- Power - Two TUXINSUN 20000mAh 22.5W Powerbanks

# Todo

## Software

- [x] Install NixOS
- [ ] Setup config
- [ ] Commit config
- [ ] Select and install window manager
- [ ] Setup dev environment - Helix?

## Case modelling tasks

- [ ] Screen front panel
- [ ] Screen back panel
- [ ] Hinge
- [ ] Keyboard back panel
- [ ] Keyboard front panel
- [ ] Wiring
- [ ] Style

### Screen front panel

- [x] Main panel
- [x] Screen control buttons
- [x] Back panel mount holes
- [x] Add extra back panel mounts
- [x] Screen controls mount
- [x] Construction method
- [x] Screen inset 
- [x] port windows
- [x] hinge mount
- [ ] Speaker mounts - next to screen control panel? -- later
- [ ] Screen control icons

### Screen back panel
- [x] Main panel
- [ ] Construction method
- [x] Front panel mount holes
- [ ] Screen mount holes
- [ ] Computer mount holes

### Hinge
- [ ] Screen attachment
- [ ] Keyboard attachment
- [ ] Linkage

### Keyboard back panel

- [ ] Main panel
- [ ] Keyboard inset
- [ ] Front panel connection
- [ ] Battery compartments
- [ ] Hinge mounts

### Keyboard front panel
- [ ] Back panel connection
- [ ] Keyboard brace

### Wiring

- [ ] Screen top panel A
- [ ] Screen top panel B
- [ ] Screen bottom panel A
- [ ] Screen bottom panel B
- [ ] Keyboard panel A
- [ ] Keyboard panel B
