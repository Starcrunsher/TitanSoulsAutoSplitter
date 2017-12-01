### Version 2.0 of the Titan Souls Autoplitter
Direct download of the .asl file: [here](TitanSoulsAutoSplitter.asl) -> click on "raw" and save that.
- The timer auto-starts when the ingame-timer starts to run (only on a new file)
- There is no auto-reset at the moment
- If you let livespit compare to game time, you can see a "more accurate" ingame time (the real ingame time + the ingame time between the last save and exiting a game) or the exact ingame time with quitless runs (like DEMO - No save+quit (IGT))

#### Differences between old (v1.1) and new (v2.0) split behavior
v1.1 splits at:
- the moment when a titan is killed (pulling the arrow out of the titan)
- if doing risky skips, it can happen that the autosplitter triggers the split only after re-entering the game (in v1.0 it is possible that the autosplitter doesn't split at all)

v2.0 splits at (only at the first of the given possibilities):
- leaving a titan's area after killing it
- re-entering the game after killing a titan (as soon as you select the file) (including risky skips (**needs to be tested**))
- after dying on a titan after killing it (e.g. Onyxia death warp)
- the moment when a titan is killed; you have to check the setting "Split Titan X at Kill?" and "Split at Titan X?" must be checked (should not be used with risky skips, same problem like in v1.1)
- ignores a titan completely if you uncheck "Split at Titan X?" (on default every "Split at Titan X?" is checked)

v2.0 will be activated when the setting "Split after exiting the boss area?" is checked.  
v2.0 will not be activated by default when you add it in the layout editor or activating it in the split settings, so that people that don't know about these changes aren't confused when the autosplitter changes it's behavior.

##### Example: 100% - Normal with given route (no risky skips)

-|v1.1 behavior|v2.0 behavior on default settings <br/>(Every "Should split at Titan X?" is activated)
-----------------|------------|-------------
(1) Sludgeheart | on kill | leaving it's area
(2) Eyecube | on kill | leaving it's area
(3) Brainfreeze | on kill | leaving it's area
(4) Gol-Iath | on kill | leaving it's area
(5) Obello | on kill | leaving it's area
(6) Vinethesis | on kill | leaving it's area
(7) Gol-Hevel | on kill | leaving it's area
(8) Mountain Titan | on kill | re-entering the game
(9) Elhanan | on kill | leaving it's area
(10) Avarice | on kill | re-entering the game
(11) Mol-Qayin | on kill | leaving it's area
(12) Gol-Qayin | on kill | walking over the checkpoint (if it is not activated before) or leaving it's area (a.k.a. entering Rol-Qayin)<br/>to be consistent with the splitting here, you should activate "Kill Titan 12 on Kill?" in the settings
(13) Rol-Qayin | on kill | leaving it's area
(14) Onyxia | on kill | leaving it's area or death warp
(15) Yeti | on kill | leaving it's area
(16) Stratus | on kill | leaving it's area
(17) Gol-Set | on kill | leaving it's area
(18) Soul | on kill | re-entering the game
(19) Truth | doesn't split | doesn't split
