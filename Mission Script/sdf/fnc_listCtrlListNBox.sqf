#include "script_component.hpp"

_valueData params [["_rows",[],[[]]],["_selection",0,[0]],["_height",1,[0]],["_returnData",[],[[]]],["_doubleClick",{},[{}]]];
_height = ITEM_H * ((round _height) max 1);

private _ctrlDescription = _display ctrlCreate [QGVAR(Text),-1,_ctrlGroup];
_ctrlDescription ctrlSetPosition [0,_posY,LISTNBOX_W,ITEM_H];
_ctrlDescription ctrlCommit 0;
_ctrlDescription ctrlSetText _descriptionText;
_ctrlDescription ctrlSetTooltip _descriptionTooltip;

if (!_forceDefault) then {
	_selection = GVAR(cache) getVariable [[_title,_description,_type,_rows] joinString "~",_selection];
};

if (_returnData isNotEqualTo [] && count _rows isNotEqualTo count _returnData) exitWith {
	systemChat "SDF ERROR: ListNBox row count != return data count";
};

private _ctrlBG = _display ctrlCreate [QGVAR(Text),-1,_ctrlGroup];
_ctrlBG ctrlSetPosition [0,_posY + ITEM_H + SPACING_H,LISTNBOX_W,_height];
_ctrlBG ctrlSetBackgroundColor [0,0,0,0.9];
_ctrlBG ctrlCommit 0;

private _ctrl = _display ctrlCreate [QGVAR(ListNBox),-1,_ctrlGroup];
_ctrl ctrlSetPosition [0,_posY + ITEM_H + SPACING_H,LISTNBOX_W,_height];
_ctrl ctrlCommit 0;

{
	if !(_x isEqualType []) then {_x = [_x]};

	private _columns = _x apply {
		_x params [["_text",""],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];
		if !(_text isEqualType "") then {_text = str _text};
		[_text,_icon,_RGBA]
	};

	private _index = _ctrl lnbAddRow (_columns apply {_x # 0});

	{
		_ctrl lnbSetPicture [[_index,_forEachIndex],_x # 1];
		_ctrl lnbSetColor [[_index,_forEachIndex],_x # 2];
	} forEach _columns;
} forEach _rows;

_ctrl setVariable [QGVAR(parameters),[_type,_description,[_rows,_selection,_height]]];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(ctrlBG),_ctrlBG];
_ctrl setVariable [QGVAR(returnData),_returnData];
_ctrl setVariable [QGVAR(selection),_selection];

if (_returnData isEqualTo []) then {
	_ctrl setVariable [QGVAR(value),_selection];
} else {
	_ctrl setVariable [QGVAR(value),_returnData # _selection];
};

_ctrl lnbSetCurSelRow _selection;
_controls pushBack _ctrl;

[_ctrl,"LBSelChanged",{
	params ["_ctrl","_selection"];

	private _returnData = _ctrl getVariable QGVAR(returnData);
	private _value = if (_returnData isEqualTo []) then {_selection} else {_returnData # _selection};

	_ctrl setVariable [QGVAR(selection),_selection];
	_ctrl setVariable [QGVAR(value),_value];
	
	[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
}] call CBA_fnc_addBISEventHandler;

[_ctrl,"LBDblClick",{
	params ["_ctrl"];
	[_ctrl getVariable QGVAR(value),uiNamespace getVariable QGVAR(arguments),_ctrl] call _thisArgs;
},_doubleClick] call CBA_fnc_addBISEventHandler;

[_ctrl,"KeyDown",{
	params ["_ctrl","_key"];
	if !(_key in [DIK_RETURN,DIK_NUMPADENTER]) exitWith {};
	[_ctrl getVariable QGVAR(value),uiNamespace getVariable QGVAR(arguments),_ctrl] call _thisArgs;
},_doubleClick] call CBA_fnc_addBISEventHandler;

_posY = _posY + ITEM_H + SPACING_H + _height + SPACING_H;
