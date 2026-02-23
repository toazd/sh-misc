cpuhotplug can be used to easily set cores to either online or offline which may offer power savings in certain scenarios (requires a kernel configured with CONFIG_HOTPLUG_CPU enabled; most come with it enabled already). For my laptop in low-power mode it shaves ~14.28% off the idle power draw. It is designed to be simple and portable (POSIX sh).

Example usage:
- download/create cpuhotplug
- chmod +x cpuhotplug (make it executible)
- sudo mv cpuhotplug /usr/bin (move it to $PATH)
- cpuhotplug -h (show the help)
- sudo cpuhotplug off all (will set all cores from C1-CMAX to offline; note that C0 cannot be changed)


The other scripts in this repo are probably not useful to most people but feel free to check them out if you're curious.
