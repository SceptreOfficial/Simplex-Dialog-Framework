#include "script_component.hpp"

GVAR(PFHID) call CBA_fnc_removePerFrameHandler;

disableSerialization;
params [["_onClose",{},[{}]],["_cacheValues",false,[false]]];

private _values = if (_cacheValues) then {
	(uiNamespace getVariable QGVAR(controls)) apply {
		private _value = _x getVariable QGVAR(value);
		private _params = _x getVariable QGVAR(parameters);

		switch (_params # 0) do {
			case "CHECKBOX";
			case "EDITBOX" : {
				GVAR(cache) setVariable [[uiNamespace getVariable QGVAR(title),_params # 1,_params # 0] joinString "~",_value];
			};
			case "SLIDER" : {
				GVAR(cache) setVariable [[uiNamespace getVariable QGVAR(title),_params # 1,_params # 0,_params # 2 # 0] joinString "~",_value];
			};
			case "COMBOBOX";
			case "LISTNBOX" : {
				GVAR(cache) setVariable [[uiNamespace getVariable QGVAR(title),_params # 1,_params # 0,_params # 2 # 0] joinString "~",_x getVariable QGVAR(selection)];
			};
		};

		_value
	};
} else {
	(uiNamespace getVariable QGVAR(controls)) apply {_x getVariable QGVAR(value)}
};

[{isNull (uiNamespace getVariable QGVAR(parent))},{
	params ["_values","_arguments","_code"];
	[_values,_arguments] call _code;
},[_values,uiNamespace getVariable QGVAR(arguments),_onClose]] call CBA_fnc_waitUntilAndExecute;

if (uiNamespace getVariable QGVAR(parent) isEqualType displayNull) then {
	closeDialog 0;
} else {
	(findDisplay IDD_RSCDISPLAYCURATOR) displayRemoveEventHandler ["KeyDown",GVAR(keyDownEHID)];
	[{ctrlDelete _this},uiNamespace getVariable QGVAR(parent)] call CBA_fnc_execNextFrame;
};
