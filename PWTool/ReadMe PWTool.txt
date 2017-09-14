______________

12/1/2013
______________

The CEP (or perhaps other mods) come with the PWTool and its
other two executables. When you want to make your own mod with
server-side-scripts (SSS) enabled, just use these files!
You usually don't need to call mod_conf.exe and PWKiller.exe
seperately, because the most important functions can be accessed
via PWTool.exe. However, it still needs those other two files
in order to work correctly! If you call PWTool.exe from another
file, make sure you set the run path to this folder! Note also,
that "Start", "SDK" and "Dedicated" will all enable and disable
server-side-scripts! If you want to start a dedicated server
without SSS (just for Boosterpack and no mod!!), just copy the
Paraworld-Shortcut and add "-dedicated".

Commands for PWTool.exe:

[None]
Displays a window with some options.

/?
Displays help in console

SSSOn
Calls mod_conf.exe with SSSOn and the appdata folder

SSSOff
Calls mod_conf.exe with SSSOff and the appdata folder

Kill
Kills all PW-processes.

Wait [Command line]
Starts a hidden process which will check and do sth when all
PW-processes have been terminated. If Command line is specified,
it will execute it, if not, it will simply kill PWKiller and
call SSSOff
Examples:
PWTool.exe Wait
PWTool.exe Wait "../Data/Mod/important.exe"

Restore
Restores the settings file from the backup (if there is any).

Create
Creates a backup of the settings file.

Start mod
Starts a given mod with SSS enabled. Very simple, should be used
by all mods. Does the following:
- SSSOn
- "../bin/Paraworld.exe -enable mod" in "../bin/"
- PWKiller.exe
- PWTool.exe Wait
If mod is not specified, CEP will be used.
Examples:
PWTool.exe Start
PWTool.exe Start CEP

Dedicated mod
Starts a dedicated server with the given mod with SSS enabled. Very simple, should be used
by all mods. Does the following:
- SSSOn
- "../bin/Paraworld.exe -dedicated -enable mod" in "../bin/"
- PWKiller.exe
- PWTool.exe Wait
If mod is not specified, CEP will be used.
Examples:
PWTool.exe Dedicated
PWTool.exe Dedicated CEP

SDK mod
Starts the SDK for a given mod with SSS enabled. Very simple,
should be used by all mods. Does the following:
- SSSOn
- "../bin/PWClient.exe -leveled -enable mod" in "../bin/"
- PWKiller.exe
- PWTool.exe Wait
If mod is not specified, CEP will be used.
Examples:
PWTool.exe SDK
PWTool.exe SDK CEP



- AyCe
