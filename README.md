# On-Off Ultimat ToggleSwitch Plasmoid 

*In development

This is a plasmoid runs scripts with configurable on/off switches for KDE Plasma 6.


## Captures :

<p align="center">

![Copie d'écran_20240420_122343](https://github.com/xkain/Ultimat-Switchs/assets/93977698/a92bb5fc-fa72-4654-9bf2-816af2c109e2)

![Copie d'écran_20240420_122402](https://github.com/xkain/Ultimat-Switchs/assets/93977698/4b4f2bc8-72b6-4258-a789-38df82f9f8a2)

</br>
   
</p>


## Current and *planned* features

* [X] compactRepresentation and fullRepresentation
   * [x] open fullRepresentation with middle click
   * [x] toggleswitch in compactRepresentation
   * [x] dynamically generated toggleswitch in fullRepresentation
  
</br>

* [x] Label
   * [x] Label for each toggleswitch
   * [x] display the label or not
   * [x] choice label color
   * [x] choice label bolt
   * [x] italic label choice
   * [ ] choice font label
         
</br>

* [x] Script
   * [x] If the script returns exit 0 the toggleswitch will remain in its position
   * [x] If the script returns exit 1 the toggleswitch will return to its initial position
   * [x] choice to run the script at startup

</br>

* [x] Position
   * [x] Toggleswitch in compactRepresentation can control the position of all toggleswitches in fullRepresentation
   * [x] Group toggleswitches create a new column / “normal” toggleswitches are placed below the Group toggleswitches that they depend on.
   * [x] Group toggleswitches can control the position of toggleswitches below it
   * [x] Toggleswitch in compactRepresentation can remember the last position before reboot / can choose default position
   * [ ] Toggleswitch in fullRepresentation can remember the last position after reboot
   * [x] Choose default position of toggleswitches in fullRepresentation at startup

</br>

* [x] Notification
   * [x] Enable or not a notification
   * [x] Choose the title
   * [x] Choose text
   * [x] Choose icon

</br>

* [x] ToolTip
    * [x] Display or not tooltip
    * [x] Choose text
    * [ ] Displays script returns

 </br>

  * [ ] Keyboard shortcut 
  * [ ] translation
  * [ ] Color choice Toggleswitch
  * [ ] Documentation




 *I'm not a developer, I'm trying to learn to carry out this project, any help is welcome. 
