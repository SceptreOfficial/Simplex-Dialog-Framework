#include "script_component.hpp"

disableSerialization;
params [["_index",0,[0]],["_valueData",[],[true,"",[]]],["_forceDefault",true,[true]]];

private _ctrl = (uiNamespace getVariable QGVAR(controls)) # _index;
private _params = _ctrl getVariable QGVAR(parameters);
_params params ["_type","_description"];

switch (_type) do {
	case "CHECKBOX" : {
		_valueData params [["_bool",true,[true]]];

		if (!_forceDefault) then {
			_bool = GVAR(cache) getVariable [[uiNamespace getVariable QGVAR(title),_description,_type] joinString "~",_bool];
		};

		_params set [2,_bool];
		_ctrl setVariable [QGVAR(parameters),_params];
		
		_ctrl cbSetChecked _bool;
		_ctrl setVariable [QGVAR(value),_bool];
	};

	case "EDITBOX" : {
		_valueData params [["_string","",[""]]];

		if (!_forceDefault) then {
			_string = GVAR(cache) getVariable [[uiNamespace getVariable QGVAR(title),_description,_type] joinString "~",_string];
		};

		_params set [2,_string];
		_ctrl setVariable [QGVAR(parameters),_params];

		_ctrl ctrlSetText _string;
		_ctrl setVariable [QGVAR(value),_string];
	};

	case "SLIDER" : {
		_valueData params [["_sliderData",[0,1,1],[[]]],["_sliderPos",0,[0]]];
		_sliderData params [["_min",0,[0]],["_max",1,[0]],["_decimals",1,[0]]];

		if (!_forceDefault) then {
			_sliderPos = GVAR(cache) getVariable [[uiNamespace getVariable QGVAR(title),_description,_type,_sliderData] joinString "~",_sliderPos];
		};

		_params set [2,[[_min,_max,_decimals],_sliderPos]];
		_ctrl setVariable [QGVAR(parameters),_params];

		private _sliderPosStr = _sliderPos toFixed _decimals;
		_ctrl sliderSetRange [_min,_max];
		_ctrl sliderSetPosition parseNumber _sliderPosStr;

		private _ctrlEdit = _ctrl getVariable QGVAR(ctrlEdit);
		_ctrlEdit ctrlSetText _sliderPosStr;

		_ctrl setVariable [QGVAR(value),sliderPosition _ctrl];
	};

	case "COMBOBOX" : {
		_valueData params [["_items",[],[[]]],["_selection",0,[0]],["_returnData",[],[[]]]];

		if (!_forceDefault) then {
			_selection = GVAR(cache) getVariable [[uiNamespace getVariable QGVAR(title),_description,_type,_items] joinString "~",_selection];
		};

		_params set [2,[_items,_selection]];
		_ctrl setVariable [QGVAR(parameters),_params];
		_ctrl setVariable [QGVAR(returnData),_returnData];

		lbClear _ctrl;

		{
			_x params [["_text",""],["_tooltip","",[""]],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];

			if !(_text isEqualType "") then {_text = str _text};

			private _index = _ctrl lbAdd _text;
			_ctrl lbSetTooltip [_index,_tooltip];
			_ctrl lbSetPicture [_index,_icon];
			_ctrl lbSetColor [_index,_RGBA];
		} forEach _items;

		_ctrl lbSetCurSel _selection;
	};

	case "LISTNBOX" : {
		private _paramsArray = if (GVAR(cache) == GVAR(gridCache)) then {
			[["_rows",[],[[]]],["_selection",0,[0]],["_returnData",[],[[]]],["_doubleClick",{},[{}]]]
		} else {
			[["_rows",[],[[]]],["_selection",0,[0]],["_height",1,[0]],["_returnData",[],[[]]],["_doubleClick",{},[{}]]]
		};

		_valueData params _paramsArray;

		if (!_forceDefault) then {
			_selection = GVAR(cache) getVariable [[uiNamespace getVariable QGVAR(title),_description,_type,_rows] joinString "~",_selection];
		};

		_params set [2,[_rows,_selection,_height]];
		_ctrl setVariable [QGVAR(parameters),_params];
		_ctrl setVariable [QGVAR(returnData),_returnData];

		lnbClear _ctrl;

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

		_ctrl lnbSetCurSelRow _selection;
	};

	case "CARGOBOX" : {
		_valueData params [["_items",[],[[]]],["_height",4,[0]],["_countLimit",-1,[0]],["_weightLimit",-1,[0]],["_method",0,[0]]];

		_params set [2,[_items,_height,_countLimit,_weightLimit,_method]];
		_ctrl setVariable [QGVAR(parameters),_params];

		lbClear _ctrl;
		
		if (_method isEqualTo 0) then {
			lbClear (_ctrl getVariable QGVAR(ctrlCargo));
		};

		{
			_x params [["_item","",["",[]]],["_data","",[""]],["_weight",0,[0]]];
			_item params [["_text","",[""]],["_tooltip","",[""]],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];

			private _index = _ctrl lbAdd _text;
			_ctrl lbSetTooltip [_index,_tooltip];
			_ctrl lbSetPicture [_index,_icon];
			_ctrl lbSetColor [_index,_RGBA];
			_ctrl lbSetData [_index,_data];
			_ctrl lbSetValue [_index,_weight];
		} forEach _items;

		_ctrl lbSetCurSel 0;

		if (_method isEqualTo 0) then {
			_ctrl setVariable [QGVAR(value),[]];
		};
	};

	case "CARGOBOX2" : {
		_valueData params [["_tree",[],[[]]],["_height",4,[0]],["_countLimit",-1,[0]],["_weightLimit",-1,[0]],["_method",0,[0]],["_minInputLevel",0,[0]]];

		_params set [2,[_items,_height,_countLimit,_weightLimit,_method,_minInputLevel]];
		_ctrl setVariable [QGVAR(parameters),_params];

		tvClear _ctrl;
		
		if (_method isEqualTo 0) then {
			lbClear (_ctrl getVariable QGVAR(ctrlCargo));
		};

		private _fnc_recursive = {
			params ["_parentPath","_entry"];
			_entry params [["_item","",["",[]]],["_data","",[""]],["_weight",0,[0]],["_children",[],[[]]]];
			_item params [["_text","",[""]],["_tooltip","",[""]],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];

			private _path = _parentPath + [_ctrl tvAdd [_parentPath,_text]];
			_ctrl tvSetData [_path,_data];
			_ctrl tvSetValue [_path,_weight];
			_ctrl tvSetPicture [_path,_icon];
			_ctrl tvSetTooltip [_path,_tooltip];
			_ctrl tvSetPictureColor [_path,_RGBA];

			{[_path,_x] call _fnc_recursive} forEach _children;
		};

		{[[],_x] call _fnc_recursive} forEach _tree;

		if (_method isEqualTo 0) then {
			_ctrl setVariable [QGVAR(value),[]];
		};
	};

	case "TREE" : {
		private _paramsArray = if (GVAR(cache) == GVAR(gridCache)) then {
			[["_tree",[],[[]]],["_returnPath",false,[false]]]
		} else {
			[["_tree",[],[[]]],["_height",4,[0]],["_returnPath",false,[false]]]
		};

		_valueData params _paramsArray;

		_params set [2,[_tree,_height,_returnPath]];
		_ctrl setVariable [QGVAR(parameters),_params];

		tvClear _ctrl;

		private _fnc_recursive = {
			params ["_parentPath","_entry"];
			_entry params [["_item","",["",[]]],["_data","",[""]],["_children",[],[[]]]];
			_item params [["_text","",[""]],["_tooltip","",[""]],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];

			private _path = _parentPath + [_ctrl tvAdd [_parentPath,_text]];
			_ctrl tvSetData [_path,_data];
			_ctrl tvSetPicture [_path,_icon];
			_ctrl tvSetTooltip [_path,_tooltip];
			_ctrl tvSetPictureColor [_path,_RGBA];

			{[_path,_x] call _fnc_recursive} forEach _children;
		};

		{[[],_x] call _fnc_recursive} forEach _tree;

		_ctrl tvSetCurSel [0];

		_ctrl setVariable [QGVAR(value),[_ctrl tvData tvCurSel _ctrl,tvCurSel _ctrl] select _returnPath];
	};

	case "BUTTON" : {
		_valueData params [["_code",{},[{},""]]];

		_params set [2,_code];
		_ctrl setVariable [QGVAR(parameters),_params];
		_ctrl setVariable [QGVAR(value),_code];
	};

	case "BUTTON2" : {
		if (GVAR(cache) == GVAR(gridCache)) then {
			_valueData params [["_code",{},[{},""]]];

			_params set [2,_code];
			_ctrl setVariable [QGVAR(parameters),_params];
			_ctrl setVariable [QGVAR(value),_code];
		} else {
			_valueData params ["",["_code1",{},[{},""]],"",["_code2",{},[{},""]]];

			if (_code1 isEqualType "") then {_code1 = compile _code1};
			if (_code2 isEqualType "") then {_code2 = compile _code2};

			_ctrl setVariable [QGVAR(value),_code1];
			(_ctrl getVariable QGVAR(button2)) setVariable [QGVAR(value),_code2];
		};
	};
};
