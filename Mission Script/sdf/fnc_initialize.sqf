#include "script_component.hpp"

params ["_format","_control"];

if (_format isEqualTo 0) then {
	_control params [
		["_type","",[""]],
		["_description","",["",[]]],
		["_valueData",[],[true,"",[],{}]],
		["_forceDefault",true,[true]],
		["_onValueChanged",{},[{}]],
		["_enableCondition",{true},[{},true]]
	];

	_type = toUpper _type;

	_description params [["_descriptionText","",[""]],["_descriptionTooltip","",[""]]];
	_description = [_descriptionText,_descriptionTooltip];

	if (_enableCondition isEqualType true) then {
		_enableCondition = [{false},{true}] select _enableCondition;
	};

	switch _type do {
		case "CHECKBOX" : FUNC(listCtrlCheckbox);
		case "EDITBOX" : {false call FUNC(listCtrlEditbox)};
		case "SLIDER" : FUNC(listCtrlSlider);
		case "COMBOBOX" : FUNC(listCtrlCombobox);
		case "LISTNBOX" : FUNC(listCtrlListNBox);
		case "BUTTON";
		case "BUTTON1" : FUNC(listCtrlButton);
		case "BUTTON2" : FUNC(listCtrlButton2);
		case "TREE" : FUNC(listCtrlTree);
		case "CARGOBOX";
		case "CARGOBOX1" : FUNC(listCtrlCargobox);
		case "CARGOBOX2" : FUNC(listCtrlCargobox2);
	};
} else {
	_control params [
		["_position",[0,0,1,1],[[]],4],
		["_type","",[""]],
		["_description","",["",[]]],
		["_valueData",[],[true,"",[],{}]],
		["_forceDefault",true,[true]],
		["_onValueChanged",{},[{}]],
		["_enableCondition",{true},[{},true]]
	];

	_type = toUpper _type;

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

	if (_format isEqualTo 1) then {
		switch _type do {
			case "TEXT" : {false call FUNC(gridCtrlText)};
			case "STRUCTUREDTEXT" : {true call FUNC(gridCtrlText)};
			case "CHECKBOX" : FUNC(gridCtrlCheckbox);
			case "EDITBOX" : {false call FUNC(gridCtrlEditbox)};
			case "EDITBOXMULTI" : {true call FUNC(gridCtrlEditbox)};
			case "SLIDER" : FUNC(gridCtrlSlider);
			case "COMBOBOX" : FUNC(gridCtrlCombobox);
			case "LISTNBOX" : FUNC(gridCtrlListNBox);
			case "BUTTON";
			case "BUTTON1" : {true call FUNC(gridCtrlButton)};
			case "BUTTON2" : {false call FUNC(gridCtrlButton)};
			case "TREE" : FUNC(gridCtrlTree);
			case "MAP";
			case "MAP1" : {0 call FUNC(gridCtrlMap)};
			case "MAP2" : {1 call FUNC(gridCtrlMap)};
			case "MAP3" : {2 call FUNC(gridCtrlMap)};
			case "GROUP" : FUNC(gridCtrlGroup);
		};
	} else {
		switch _type do {
			case "TEXT" : {false call FUNC(gridCtrlText)};
			case "STRUCTUREDTEXT" : {true call FUNC(gridCtrlText)};
			case "CHECKBOX" : FUNC(gridCtrlCheckbox);
			case "EDITBOX" : {false call FUNC(gridCtrlEditbox)};
			case "EDITBOXMULTI" : {true call FUNC(gridCtrlEditbox)};
			case "SLIDER" : FUNC(gridCtrlSlider);
			case "COMBOBOX" : FUNC(gridCtrlCombobox);
			case "LISTNBOX" : FUNC(gridCtrlListNBox);
			case "BUTTON";
			case "BUTTON1" : {true call FUNC(gridCtrlButton)};
			case "BUTTON2" : {false call FUNC(gridCtrlButton)};
			case "TREE" : FUNC(gridCtrlTree);
		};
	};
};
