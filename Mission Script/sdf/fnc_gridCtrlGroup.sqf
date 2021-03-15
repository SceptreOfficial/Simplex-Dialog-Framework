#include "script_component.hpp"

_position = [GD_W(_ctrlX),GD_H(_ctrlY),GD_W(_ctrlW) min safeZoneW,GD_H(_ctrlH) min safeZoneH];
private _ctrlGroup = _display ctrlCreate [QGVAR(ControlsGroup),-1,_ctrlGroup];
_ctrlGroup ctrlSetPosition _position;
_ctrlGroup ctrlCommit 0;

_ctrlGroup setVariable [QGVAR(parameters),[_type,"",""]];
_ctrlGroup setVariable [QGVAR(position),_position];
_ctrlGroup setVariable [QGVAR(onValueChanged),{}];
_ctrlGroup setVariable [QGVAR(enableCondition),{true}];
_ctrlGroup setVariable [QGVAR(value),[]];
_ctrlGroup setVariable [QGVAR(ctrlDescription),_ctrlGroup];
_ctrlGroup setVariable [QGVAR(controlCount),count _valueData];

_controls pushBack _ctrlGroup;

{
	_x params [
		["_position",[0,0,1,1],[[]],4],
		["_type","",[""]],
		["_description","",["",[]]],
		["_valueData",[],[true,"",[],{}]],
		["_forceDefault",true,[true]],
		["_onValueChanged",{},[{}]],
		["_enableCondition",{true},[{},true]]
	];

	_position params ["_ctrlX","_ctrlY","_ctrlW","_ctrlH"];
	_position = [
		GD_W(_ctrlX) + (BUFFER_W / 2),
		GD_H(_ctrlY) + (BUFFER_H / 2),
		(GD_W(_ctrlW) min safeZoneW) - BUFFER_W,
		(GD_H(_ctrlH) min safeZoneH) - BUFFER_H
	];

	_description params [["_descriptionText","",[""]],["_descriptionTooltip","",[""]]];
	_description = [_descriptionText,_descriptionTooltip];

	if (_enableCondition isEqualType true) then {
		_enableCondition = [{false},{true}] select _enableCondition;
	};

	switch (toUpper _type) do {
		case "TEXT" : {false call FUNC(gridCtrlText)};
		case "STRUCTUREDTEXT" : {true call FUNC(gridCtrlText)};
		case "CHECKBOX" : FUNC(gridCtrlCheckbox);
		case "EDITBOX" : FUNC(gridCtrlEditbox);
		case "SLIDER" : FUNC(gridCtrlSlider);
		case "COMBOBOX" : FUNC(gridCtrlCombobox);
		case "LISTNBOX" : FUNC(gridCtrlListNBox);
		case "BUTTON";
		case "BUTTON1" : {true call FUNC(gridCtrlButton)};
		case "BUTTON2" : {false call FUNC(gridCtrlButton)};
		case "TREE" : FUNC(gridCtrlTree);
	};
} forEach _valueData;
