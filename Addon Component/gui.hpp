#include "script_component.hpp"
#define LIST_DIALOG_CONTROLS \
	class Background : GVAR(Text) { \
		idc = 1; \
	}; \
	class Title : GVAR(Text) { \
		idc = 2; \
		colorBackground[] = { \
			"profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]", \
			"profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]", \
			"profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]", \
			1 \
		}; \
		font = "PuristaMedium"; \
	}; \
	class ControlsGroup : GVAR(ControlsGroup) { \
		idc = 3; \
	}; \
	class Cancel : GVAR(ButtonSimple) { \
		idc = 4; \
		onButtonClick = QUOTE([ARR_2(uiNamespace getVariable QQGVAR(onCancel),false)] call FUNC(close)); \
		text = "$STR_SDF_CANCEL"; \
		font = "PuristaMedium"; \
	}; \
	class Confirm : GVAR(ButtonSimple) { \
		idc = 5; \
		onButtonClick = QUOTE([ARR_2(uiNamespace getVariable QQGVAR(onConfirm),true)] call FUNC(close)); \
		text = "$STR_SDF_CONFIRM"; \
		font = "PuristaMedium"; \
	}

class RscText;
class RscCheckbox;
class RscEdit;
class RscXSliderH;
class RscCombo;
class RscListNBox;
class RscButton;
class RscButtonMenu;
class RscListBox;
class RscTree;
class RscControlsGroup;
class Scrollbar;

class GVAR(Text) : RscText {
	idc = -1;
	deletable = 1;
	x = 0;
	y = 0;
	w = 0;
	h = 0;
	colorBackground[] = {0,0,0,0.67};
	colorDisabled[] = {COLOR_DISABLED};
	sizeEx = GRID_H(1);
	shadow = 0;
};

class GVAR(StructuredText) : GVAR(Text) {
	type = 13;
	size = GRID_H(1);
};

class GVAR(Checkbox) : RscCheckbox {
	idc = -1;
	deletable = 1;
	x = 0;
	y = 0;
	w = CHECKBOX_W;
	h = CHECKBOX_H;
	color[] = {1,1,1,1};
	colorDisabled[] = {COLOR_DISABLED};
};

class GVAR(Editbox) : RscEdit {
	idc = -1;
	deletable = 1;
	x = 0;
	y = 0;
	w = EDITBOX_W;
	h = EDITBOX_H;
	sizeEx = GRID_H(1);
	colorText[] = {1,1,1,1};
	colorBackground[] = {0,0,0,1};
	colorDisabled[] = {COLOR_DISABLED};
};

class GVAR(Slider) : RscXSliderH {
	idc = -1;
	deletable = 1;
	x = 0;
	y = 0;
	w = SLIDER_W;
	h = SLIDER_H;
	colorDisable[] = {COLOR_DISABLED};
	colorDisabled[] = {COLOR_DISABLED};
	colorBackground[] = {0,0,0,1};
	color[] = {1,1,1,1};
};

class GVAR(SliderEdit) : GVAR(Editbox) {
	w = SLIDER_EDIT_W;
};

class GVAR(Combobox) : RscCombo {
	idc = -1;
	deletable = 1;
	x = 0;
	y = 0;
	w = COMBOBOX_W;
	h = COMBOBOX_H;
	colorDisabled[] = {COLOR_DISABLED};
	sizeEx = GRID_H(1);
	wholeHeight = 0.3;
};

class GVAR(ListNBox) : RscListNBox {
	idc = -1;
	deletable = 1;
	x = 0;
	y = 0;
	w = LISTNBOX_W;
	h = LISTNBOX_H;
	columns[] = {0,0.2,0.4,0.6,0.8};
	rowHeight = GRID_H(1);
	colorDisabled[] = {COLOR_DISABLED};
	sizeEx = GRID_H(1);
	disableOverflow = 0;
	class ListScrollBar : ScrollBar {
		color[] = {1,1,1,1};
    };
};

class GVAR(ButtonSimple) : RscButton {
	idc = -1;
	deletable = 1;
	x = 0;
	y = 0;
	w = BUTTON_W;
	h = BUTTON_H;
	color[] = {1,1,1,1};
	colorBackground[] = {0,0,0,1};
	colorBackgroundActive[] = {0.8,0.8,0.8,1};
	colorBackgroundFocused[] = {1,1,1,1};
	colorBackgroundDisabled[] = {0,0,0,1};
	colorDisabled[] = {COLOR_DISABLED};
	colorFocused[] = {0,0,0,1};
	sizeEx = GRID_H(1);
	style = 2;
	shadow = 0;
};

class GVAR(Button) : RscButtonMenu {
	idc = -1;
	deletable = 1;
	x = 0;
	y = 0;
	w = BUTTON_W;
	h = BUTTON_H;
	colorBackground[] = {0,0,0,1};
	colorBackgroundDisabled[] = {0,0,0,1};
	colorDisabled[] = {COLOR_DISABLED};
	sizeEx = GRID_H(1);
	style = 2;
	shadow = 0;
	class HitZone {
		left = 0;
		top = 0;
		right = 0;
		bottom = 0;
	};
	class TextPos {
		left = GRID_W(0.165);
		top = GRID_H(0.125);
		right = 0;
		bottom = 0;
	};
	class ShortcutPos {
		left = 0;
		top = 0;
		w = 0;
		h = 0;
	};
	class Attributes {};
};

class GVAR(Listbox) : RscListBox {
	idc = -1;
	deletable = 1;
	x = 0;
	y = 0;
	w = LISTNBOX_W;
	h = LISTNBOX_H;
	rowHeight = GRID_H(1);
	colorDisabled[] = {COLOR_DISABLED};
	sizeEx = GRID_H(1);
};

class GVAR(Tree) : RscTree {
	idc = -1;
	moving = 0;
	style = 0;
	x = 0;
	y = 0;
	w = TREE_W;
	h = TREE_W;
	sizeEx = GRID_H(0.76);
	colorBackground[] = {0,0,0,0.9};
	colorDisabled[] = {COLOR_DISABLED};
	idcSearch = -1;
	colorBorder[] = {0.7,0.7,0.7,1};
	colorSearch[] =	{1,1,1,0};
	rowHeight = GRID_H(0.76);
	borderSize = 1;
};

class GVAR(ControlsGroup) : RscControlsGroup {
	idc = -1;
	deletable = 1;
	x = 0;
	y = 0;
	w = 1;
	h = 1;
	class VScrollbar : Scrollbar {
		color[] = {1,1,1,1};
		width = BUFFER_W * 2;
	};
	class HScrollbar : Scrollbar {
		color[] = {1,1,1,1};
		height = BUFFER_H * 2;
	};
};

class GVAR(ControlsGroupNoScrollbars) : GVAR(ControlsGroup) {
	class VScrollbar : Scrollbar {
		color[] = {1,1,1,1};
		width = 0;
	};
	class HScrollbar : Scrollbar {
		color[] = {1,1,1,1};
		height = 0;
	};
};

class GVAR(Dialog_Zeus) : GVAR(ControlsGroupNoScrollbars) {
	x = safeZoneXAbs;
	y = safeZoneY;
	w = safeZoneWAbs;
	h = safeZoneH;
	onLoad = QUOTE(with uiNamespace do {GVAR(parent) = _this select 0});

	class Controls {
		class Container : GVAR(ControlsGroupNoScrollbars) {
			x = 0;
			y = 0;
			w = safeZoneWAbs;
			h = safeZoneH;

			class Controls {
				LIST_DIALOG_CONTROLS;
			};
		};
	};
};

class GVAR(Dialog) {
	idd = -1;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = QUOTE(with uiNamespace do {GVAR(parent) = _this select 0});

	class Controls {
		LIST_DIALOG_CONTROLS;
	};
};

class GVAR(GridDialog) {
	idd = -1;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = QUOTE(with uiNamespace do {GVAR(parent) = _this select 0});

	class Controls {
		class Background : GVAR(Text) {
			idc = 1;
		};
		class ControlsGroup : GVAR(ControlsGroup) {
			idc = 2;
		};
	};
};
