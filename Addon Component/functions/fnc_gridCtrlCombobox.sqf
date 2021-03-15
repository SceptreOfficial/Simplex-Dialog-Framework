#include "script_component.hpp"

_valueData params [["_items",[],[[]]],["_selection",0,[0]],["_returnData",[],[[]]]];

if (!_forceDefault) then {
	_selection = GVAR(cache) getVariable [["",_description,_type,_items] joinString "~",_selection];
};

if (_returnData isNotEqualTo [] && count _items isNotEqualTo count _returnData) exitWith {
	systemChat "SDF ERROR: Combobox item count != return data count";
};

private _ctrl = _display ctrlCreate [QGVAR(Combobox),-1,_ctrlGroup];
_ctrl ctrlSetPosition _position;
_ctrl ctrlCommit 0;

{
	_x params [["_text",""],["_tooltip","",[""]],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];

	if !(_text isEqualType "") then {_text = str _text};

	private _index = _ctrl lbAdd _text;
	_ctrl lbSetTooltip [_index,_tooltip];
	_ctrl lbSetPicture [_index,_icon];
	_ctrl lbSetColor [_index,_RGBA];
} forEach _items;

_ctrl setVariable [QGVAR(parameters),[_type,_description,[_items,_selection]]];
_ctrl setVariable [QGVAR(position),_position];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(returnData),_returnData];
_ctrl setVariable [QGVAR(selection),_selection];

if (_returnData isEqualTo []) then {
	_ctrl setVariable [QGVAR(value),_selection];
} else {
	_ctrl setVariable [QGVAR(value),_returnData # _selection];
};

_ctrl lbSetCurSel _selection;
_controls pushBack _ctrl;

[_ctrl,"LBSelChanged",{
	params ["_ctrl","_selection"];

	private _returnData = _ctrl getVariable QGVAR(returnData);
	private _value = if (_returnData isEqualTo []) then {_selection} else {_returnData # _selection};

	_ctrl setVariable [QGVAR(selection),_selection];
	_ctrl setVariable [QGVAR(value),_value];

	[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
}] call CBA_fnc_addBISEventHandler;
