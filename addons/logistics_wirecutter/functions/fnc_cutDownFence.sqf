/*
 * Author: gpgpgpgp, edited by commy2, PabstMirror
 * Starts cutting down a fence
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Fence <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, berlinWall] call ace_logistics_wirecutter_fnc_cutDownFence
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit", "_fenceObject"];
TRACE_2("params",_unit,_fenceObject);

private ["_timeToCut", "_progressCheck", "_onCompletion", "_onFail"];

if (_unit != ACE_player) exitWith {};

_timeToCut = if ([_unit] call EFUNC(common,isEngineer)) then {7.5} else {11};

if (!underwater _unit) then {
    [_unit, "AinvPknlMstpSnonWnonDr_medic5", 0] call EFUNC(common,doAnimation);
};

_onCompletion = {
    TRACE_1("_onCompletion",_this);
    (_this select 0) params ["_fenceObject", "", "_unit"];
    _fenceObject setdamage 1;
    if (!underwater _unit) then {
        [_unit, "AmovPknlMstpSrasWrflDnon", 1] call EFUNC(common,doAnimation);
    };
};

_onFail = {
    TRACE_1("_onFail", _this);
    (_this select 0) params ["", "", "_unit"];
    if (!underwater _unit) then {
        [_unit, "AmovPknlMstpSrasWrflDnon", 1] call EFUNC(common,doAnimation);
    };
};

_progressCheck = {
    params ["_args", "_passedTime"];
    _args params ["_fenceObject", "_lastSoundEffectTime", "_unit"];

    if (_passedTime > (_lastSoundEffectTime + SOUND_CLIP_TIME_SPACEING)) then {
        playSound3D [QUOTE(PATHTO_R(sound\wirecut.ogg)), objNull, false, (getPosASL _unit), 3, 1, 10];
        _args set [1, _passedTime];
    };

    ((!isNull _fenceObject) && {(damage _fenceObject) < 1} && {("ACE_wirecutter" in (items _unit))})
};

[_timeToCut, [_fenceObject,0,_unit], _onCompletion, _onFail, localize LSTRING(CuttingFence), _progressCheck, ["isNotSwimming"]] call EFUNC(common,progressBar);
