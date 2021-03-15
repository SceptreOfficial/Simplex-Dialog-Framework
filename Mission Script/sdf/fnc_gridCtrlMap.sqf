#include "script_component.hpp"

params [["_initType",0,[0]]];
_valueData params [["_init",[]]];

private _ctrl = _display ctrlCreate ["RscMapControl",-1];

// Map controls don't work right in control groups (engine complexity/BI laziness)
// We just need to set the position statically with relative x/y coords
_position = [_position # 0 + _posX,_position # 1 + _posY,_position # 2,_position # 3];
_ctrl ctrlSetPosition _position;
_ctrl ctrlCommit 0;

private _offset = getPos player vectorDiff (_ctrl ctrlMapScreenToWorld [_position # 0 + (_position # 2 / 2),_position # 1 + (_position # 3 / 2)]);

_ctrl ctrlMapAnimAdd [0,(ctrlMapScale _ctrl) * 2,getPos player vectorAdd (_offset vectorMultiply 2)];
ctrlMapAnimCommit _ctrl;

switch _initType do {
	case 0 : {
		_init params [["_type","mil_destroy"],["_text",""],["_color","Default"],["_angle",0],["_size",[0.8,0.8]]];
		deleteMarkerLocal QGVAR(mapMarker);
		_marker = createMarkerLocal [QGVAR(mapMarker),[-9999,-9999]];
		_marker setMarkerShapeLocal "ICON";
		_marker setMarkerTypeLocal _type;
		_marker setMarkerTextLocal _text;
		_marker setMarkerColorLocal _color;
		_marker setMarkerDirLocal _angle;
		_marker setMarkerSizeLocal _size;
	};
	case 1 : {
		_init params [["_brush","Solid"],["_color","Default"]];
		deleteMarkerLocal QGVAR(mapMarker);
		_marker = createMarkerLocal [QGVAR(mapMarker),[-9999,-9999]];
		_marker setMarkerShapeLocal "RECTANGLE";
		_marker setMarkerTypeLocal _brush;
		_marker setMarkerColorLocal _color;
	};
	case 2 : {
		_init params [["_brush","Solid"],["_color","Default"]];
		deleteMarkerLocal QGVAR(mapMarker);
		_marker = createMarkerLocal [QGVAR(mapMarker),[-9999,-9999]];
		_marker setMarkerShapeLocal "ELLIPSE";
		_marker setMarkerTypeLocal _brush;
		_marker setMarkerColorLocal _color;
	};
	case 3 : {
		if (_init isEqualType {}) then {_ctrl call _init};
	};
};

_ctrl setVariable [QGVAR(parameters),[_type,_description,_init]];
_ctrl setVariable [QGVAR(position),_position];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];

switch (_initType) do {
	case 0 : {_ctrl setVariable [QGVAR(value),[0,0,0]]};
	case 1 : {_ctrl setVariable [QGVAR(value),[[0,0,0],0,0,0,true]]};
	case 2 : {_ctrl setVariable [QGVAR(value),[[0,0,0],0,0,0,false]]};
	case 3 : {_ctrl setVariable [QGVAR(value),[]]};
};


_ctrl setVariable [QGVAR(initType),_initType];

_controls pushBack _ctrl;

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
		};
		case 2 : {
			_ctrl setVariable [QGVAR(down),true];
		};
		case 3 : {
			[[_pos,_shiftKey,_ctrlKey,_altKey],uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
		};
	};
}] call CBA_fnc_addBISEventHandler;

[_ctrl,"MouseMoving",{
	params ["_ctrl"];

	switch (_ctrl getVariable QGVAR(initType)) do {
		case 1 : {
			if !(_ctrl getVariable [QGVAR(down),false]) exitWith {};

			private _start = _ctrl getVariable QGVAR(start);
			private _current = _ctrl ctrlMapScreenToWorld getMousePosition;
			private _center = [(_start # 0 + _current # 0) / 2,(_start # 1 + _current # 1) / 2];
			private _width = abs (_current # 0 - _center # 0);
			private _height = abs (_current # 1 - _center # 1);

			QGVAR(mapMarker) setMarkerSizeLocal [_width,_height];
			QGVAR(mapMarker) setMarkerPosLocal _center;

			_ctrl setVariable [QGVAR(value),[_center,_width,_height,0,true]];

			[[_center,_width,_height,0,true],uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
		};
		case 2 : {
			if !(_ctrl getVariable [QGVAR(down),false]) exitWith {
				_ctrl setVariable [QGVAR(start),_ctrl ctrlMapScreenToWorld getMousePosition];
			};

			private _start = _ctrl getVariable QGVAR(start);
			private _current = _ctrl ctrlMapScreenToWorld getMousePosition;
			private _width = abs (_current # 0 - _start # 0);
			private _height = abs (_current # 1 - _start # 1);

			QGVAR(mapMarker) setMarkerSizeLocal [_width,_height];
			QGVAR(mapMarker) setMarkerPosLocal _start;

			_ctrl setVariable [QGVAR(value),[_start,_width,_height,0,false]];

			[[_center,_width,_height,0,false],uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
		};
	};
}] call CBA_fnc_addBISEventHandler;

[_ctrl,"MouseButtonUp",{
	params ["_ctrl","_button","_xPos","_yPos","_shiftKey","_ctrlKey","_altKey"];

	if (_button != 0) exitWith {};

	switch (_ctrl getVariable QGVAR(initType)) do {
		case 1 : {_ctrl setVariable [QGVAR(down),false]};
		case 2 : {_ctrl setVariable [QGVAR(down),false]};
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
