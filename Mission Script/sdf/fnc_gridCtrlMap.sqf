#include "script_component.hpp"

params [["_initType",0,[0]]];

private _ctrl = _display ctrlCreate ["RscMapControl",-1];

// Map controls don't work right in control groups (engine complexity/BI laziness)
// We just need to set the position statically with relative x/y coords
_position = [_position # 0 + _posX,_position # 1 + _posY,_position # 2,_position # 3];
_ctrl ctrlSetPosition _position;
_ctrl ctrlCommit 0;

private _target = getPos player;
private _value = switch _initType do {
	case 0 : {
		_valueData params [["_position",[0,0,0],[[]]],["_type","mil_destroy"],["_text",""],["_color","Default"],["_angle",0],["_size",[0.8,0.8]]];
		deleteMarkerLocal QGVAR(mapMarker);
		
		private _marker = if (_position isEqualTo [0,0,0]) then {
			createMarkerLocal [QGVAR(mapMarker),[-9999,-9999]]
		} else {
			_target = _position;
			createMarkerLocal [QGVAR(mapMarker),_position]
		};

		_marker setMarkerShapeLocal "ICON";
		_marker setMarkerTypeLocal _type;
		_marker setMarkerTextLocal _text;
		_marker setMarkerColorLocal _color;
		_marker setMarkerDirLocal _angle;
		_marker setMarkerSizeLocal _size;
		_position
	};
	case 1 : {
		_valueData params [["_area",[[0,0,0],0,0,0,true],[[]]],["_brush","Solid"],["_color","Default"]];
		deleteMarkerLocal QGVAR(mapMarker);
		
		private _marker = if ((_area # 0) isEqualTo [0,0,0]) then {
			createMarkerLocal [QGVAR(mapMarker),[-9999,-9999]]
		} else {
			_target = _area # 0;
			createMarkerLocal [QGVAR(mapMarker),_target]
		};

		_marker setMarkerShapeLocal (["ELLIPSE","RECTANGLE"] select (_area # 4));
		_marker setMarkerSizeLocal [_area # 1,_area # 2];
		_marker setMarkerDirLocal (_area # 3);
		_marker setMarkerTypeLocal _brush;
		_marker setMarkerColorLocal _color;
		_area
	};
	case 2 : {
		if (_valueData isEqualType {}) then {
			_ctrl call _valueData
		} else {
			_valueData
		};
	};
};

private _offset = getPos player vectorDiff (_ctrl ctrlMapScreenToWorld [_position # 0 + (_position # 2 / 2),_position # 1 + (_position # 3 / 2)]);
_ctrl ctrlMapAnimAdd [0,(ctrlMapScale _ctrl) * 2,_target vectorAdd (_offset vectorMultiply 2)];
ctrlMapAnimCommit _ctrl;

_ctrl setVariable [QGVAR(parameters),[_type,_description,_valueData]];
_ctrl setVariable [QGVAR(position),_position];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(value),_value];
_ctrl setVariable [QGVAR(initType),_initType];

_controls pushBack _ctrl;

[_ctrl,"MouseButtonDblClick",{
	params ["_ctrl","_button","_xPos","_yPos","_shiftKey","_ctrlKey","_altKey"];

	if (_button != 0 || _ctrl getVariable QGVAR(initType) != 1) exitWith {};

	private _value = _ctrl getVariable QGVAR(value);
	_value set [4,!(_value # 4)];
	_mapCtrl setVariable [QGVAR(Svalue),_value];

	QGVAR(mapMarker) setMarkerShapeLocal (["ELLIPSE","RECTANGLE"] select (_value # 4));
}] call CBA_fnc_addBISEventHandler;

[_ctrl,"MouseButtonDown",{
	params ["_ctrl","_button","_xPos","_yPos","_shiftKey","_ctrlKey","_altKey"];

	if (_button != 0) exitWith {};

	private _pos = _ctrl ctrlMapScreenToWorld [_xPos,_yPos];

	switch (_ctrl getVariable QGVAR(initType)) do {
		case 0 : {
			QGVAR(mapMarker) setMarkerPosLocal _pos;
			_ctrl setVariable [QGVAR(value),_pos];
			[_pos,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
		};
		case 1 : {
			_ctrl setVariable [QGVAR(start),_pos];
			_ctrl setVariable [QGVAR(down),true];
			_ctrl setVariable [QGVAR(shiftDown),_shiftKey];
			_ctrl setVariable [QGVAR(ctrlDown),_ctrlKey];
			_ctrl setVariable [QGVAR(altDown),_altKey];
		};
		case 2 : {
			[[_pos,_shiftKey,_ctrlKey,_altKey],uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
		};
	};
}] call CBA_fnc_addBISEventHandler;

[_ctrl,"MouseMoving",{
	params ["_ctrl"];

	if (!(_ctrl getVariable [QGVAR(down),false]) || _ctrl getVariable QGVAR(initType) != 1) exitWith {};

	private _start = _ctrl getVariable QGVAR(start);
	private _current = _ctrl ctrlMapScreenToWorld getMousePosition;
	private _value = _ctrl getVariable QGVAR(value);
	private _isRectangle = _value # 4;

	QGVAR(mapMarker) setMarkerShapeLocal (["ELLIPSE","RECTANGLE"] select _isRectangle);

	// Rotation
	if (_ctrl getVariable [QGVAR(shiftDown),false]) exitWith {
		private _dir = (_value # 0) getDir _current;
		QGVAR(mapMarker) setMarkerDirLocal _dir;

		_value set [3,_dir];
		_ctrl setVariable [QGVAR(value),_value];

		[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
	};

	// Center creation
	if (_ctrl getVariable [QGVAR(ctrlDown),false]) exitWith {
		private _width = abs (_current # 0 - _start # 0);
		private _height = abs (_current # 1 - _start # 1);

		QGVAR(mapMarker) setMarkerSizeLocal [_width,_height];
		QGVAR(mapMarker) setMarkerPosLocal _start;
		QGVAR(mapMarker) setMarkerDir 0;

		_ctrl setVariable [QGVAR(value),[_start,_width,_height,0,_isRectangle]];

		[[_center,_width,_height,0,_isRectangle],uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
	};

	// Movement
	if (_ctrl getVariable [QGVAR(altDown),false]) exitWith {
		private _center = (_value # 0) vectorAdd (_start vectorDiff _current);
		QGVAR(mapMarker) setMarkerPosLocal _current;

		_value set [0,_current];
		_ctrl setVariable [QGVAR(value),_value];

		[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
	};

	// Drag creation
	private _center = [(_start # 0 + _current # 0) / 2,(_start # 1 + _current # 1) / 2];
	private _width = abs (_current # 0 - _center # 0);
	private _height = abs (_current # 1 - _center # 1);

	QGVAR(mapMarker) setMarkerSizeLocal [_width,_height];
	QGVAR(mapMarker) setMarkerPosLocal _center;
	QGVAR(mapMarker) setMarkerDir 0;

	_ctrl setVariable [QGVAR(value),[_center,_width,_height,0,_isRectangle]];

	[[_center,_width,_height,0,_isRectangle],uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
}] call CBA_fnc_addBISEventHandler;

[_ctrl,"MouseButtonUp",{
	params ["_ctrl","_button","_xPos","_yPos","_shiftKey","_ctrlKey","_altKey"];

	if (_button != 0) exitWith {};

	if (_ctrl getVariable QGVAR(initType) == 1) then {
		_ctrl setVariable [QGVAR(down),false];
	};
}] call CBA_fnc_addBISEventHandler;

// Deleting temp marker when control deletion
[_ctrl,"Destroy",{deleteMarkerLocal QGVAR(mapMarker)}] call CBA_fnc_addBISEventHandler;

// Handle focus between map and control group since map isn't inside group
[_display,"MouseMoving",{
	_thisArgs params ["_position","_ctrl","_ctrlGroup"];
	_position params ["_mapX","_mapY","_mapW","_mapH"];

	if (getMousePosition inArea [[_mapX + (_mapW / 2),_mapY + (_mapH / 2)],_mapW / 2,_mapH / 2,0,true]) then {
		if (_ctrl getVariable [QGVAR(notFocused),true]) then {
			ctrlSetFocus _ctrl;
			_ctrlGroup setVariable [QGVAR(notFocused),true];
			_ctrl setVariable [QGVAR(notFocused),false];
		};
	} else {
		if (_ctrlGroup getVariable [QGVAR(notFocused),true]) then {
			ctrlSetFocus _ctrlGroup;
			_ctrlGroup setVariable [QGVAR(notFocused),false];
			_ctrl setVariable [QGVAR(notFocused),true];
		};
	};
},[_position,_ctrl,_ctrlGroup]] call CBA_fnc_addBISEventHandler;
