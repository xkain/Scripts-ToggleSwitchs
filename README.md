# On-Off Scripts ToggleSwitchs Plasmoid 

*In development

This is a plasmoid runs scripts with configurable on/off switches for KDE Plasma 6.


## Captures :

<p align="center">

![001](https://github.com/xkain/Scripts-ToggleSwitchs/assets/93977698/f32ab56a-35ca-4cdc-a865-01f43a38b494)



![002](https://github.com/xkain/Scripts-ToggleSwitchs/assets/93977698/8530700b-31c9-46d4-bc1c-632a37b6e09c)



![003](https://github.com/xkain/Scripts-ToggleSwitchs/assets/93977698/b2c4ba46-3fc1-4f8f-bce2-584276ac013a)


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
    * [ ] Displays script output
         * [x] For compactRepresentation
         * [ ] fullRepresentation
 </br>

  * [ ] Keyboard shortcut 
  * [ ] translation
     * [x] French
  * [ ] Color choice Toggleswitch
  * [ ] Documentation




 *Any help is welcome. 
