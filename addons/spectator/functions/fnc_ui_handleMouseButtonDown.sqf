/*
 * Author: Nelson Duarte, AACO, SilentSpike
 * Function used to handle mouse down event
 *
 * Expected behaviour:
 * Left clicking a unit focuses the camera on that unit (in any camera mode)
 * Left clicking empty space removes the current camera focus in free camera
 * Right clicking removes the camera lock, but retains the focus in free camera
 * Right clicking and dragging orbits around the unit in follow camera
 *
 * Public: No
 */

#include "script_component.hpp"

params ["", "_button"];

// Left click
if (_button == 0) exitWith {
    if (isNull GVAR(cursorObject)) then {
        if (GVAR(camMode) == MODE_FREE && { !isNull GVAR(camTarget) }) then {
            playSound "ReadoutHideClick1";
            [objNull] call FUNC(setFocus);
        };
    } else {
        playSound "ReadoutClick";

        // Focus will be at screen center
        [GVAR(cursorObject)] call FUNC(setFocus);
        setMousePosition [0.5, 0.5];
    };
};

// Right click
if (_button == 1) then {
    if (GVAR(camMode) == MODE_FREE && { !isNull GVAR(camTarget) } && { !isNull (attachedTo GVAR(camDummy)) }) then {
        [] call FUNC(cam_resetTarget);
    };
    GVAR(holdingRMB) = true;
};