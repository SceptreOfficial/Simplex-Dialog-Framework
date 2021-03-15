#include "script_component.hpp"

disableSerialization;
params [["_index",0,[0]],["_show",true,[true]]];

private _ctrl = (uiNamespace getVariable QGVAR(controls)) # _index;

if (_show) then {
	_ctrl ctrlSetPosition (_ctrl getVariable QGVAR(position));
	_ctrl ctrlCommit 0;
	_ctrl ctrlShow true;

	switch ((_ctrl getVariable QGVAR(parameters)) # 0) do {
		case "SLIDER" : {
			private _ctrlEdit = _ctrl getVariable QGVAR(ctrlEdit);
			_ctrlEdit ctrlSetPosition (_ctrlEdit getVariable QGVAR(position));
			_ctrlEdit ctrlCommit 0;
			_ctrlEdit ctrlShow true;
		};
		case "LISTNBOX" : {
			private _ctrlBG = _ctrl getVariable QGVAR(ctrlBG);
			_ctrlBG ctrlSetPosition (_ctrl getVariable QGVAR(position));
			_ctrlBG ctrlCommit 0;
			_ctrlBG ctrlShow true;
		};
	};
} else {
	_ctrl ctrlShow false;
	_ctrl ctrlSetPosition [0,0,0,0];
	_ctrl ctrlCommit 0;

	switch ((_ctrl getVariable QGVAR(parameters)) # 0) do {
		case "SLIDER" : {
			private _ctrlEdit = _ctrl getVariable QGVAR(ctrlEdit);
			_ctrlEdit ctrlShow false;
			_ctrlEdit ctrlSetPosition [0,0,0,0];
			_ctrlEdit ctrlCommit 0;
		};
		case "LISTNBOX" : {
			private _ctrlBG = _ctrl getVariable QGVAR(ctrlBG);
			_ctrlBG ctrlShow false;
			_ctrlBG ctrlSetPosition [0,0,0,0];
			_ctrlBG ctrlCommit 0;
		};
	};
};
