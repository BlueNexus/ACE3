/*
 * Author: SilentSpike
 * Maintains the spectatable unit list and updates the unit tree accordingly
 * Also updates current camera unit when status changes
 *
 * Arguments:
 * 0: Parameters <ANY>
 * 1: PFH handle <NUMBER>
 *
 * Return Value:
 * None <NIL>
 *
 * Example:
 * [ace_spectator_fnc_handleUnits, 10] call CBA_fnc_addPerFrameHandler;
 *
 * Public: No
 */

#include "script_component.hpp"

params ["_display"];

// Kill PFH when display is closed
if (isNull _display) exitWith { [_this select 1] call CBA_fnc_removePerFrameHandler; };

// Remove all dead and null units from the list
[] call FUNC(updateUnits);

// Camera shouldn't stay on unit that isn't in the list
if !(GVAR(camUnit) in GVAR(unitList)) then {
    [0,objNull] call FUNC(updateCamera);
};

private ["_ctrl","_curSelData","_cachedGrps","_grp","_node","_side","_index"];

// Fetch tree
_ctrl = _display displayCtrl IDC_UNIT;

// Cache current selection
_curSelData = _ctrl tvData (tvCurSel _ctrl);

// Clear the tree
tvClear _ctrl;

// Update the tree from the unit list
_cachedGrps = [];
{
    _grp = group _x;
    _node = 0;
    // If group already exists, find existing node
    if !(_grp in _cachedGrps) then {
        _side = [west,east,resistance,civilian,sideLogic] find (side _grp);
        _node = _ctrl tvCount [];

        _ctrl tvAdd [[], groupID _grp];
        _ctrl tvSetValue [[_node], _side];

        _cachedGrps pushBack _grp;
    } else {
        _node = _cachedGrps find _grp;
    };

    _index = _ctrl tvCount [_node];

    _ctrl tvAdd [[_node], name _x];
    _ctrl tvSetData [[_node,_index], netID _x];

    // Preserve the previous selection
    if (_curSelData == (_ctrl tvData [_node,_index])) then {
        _ctrl tvSetCurSel [_node,_index];
    };

    _ctrl tvSort [[_node],false];
    _ctrl tvExpand [_node];
} forEach GVAR(unitList);

// Sort group nodes by side
_ctrl tvSortByValue [[],false];
