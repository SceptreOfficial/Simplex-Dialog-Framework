#define PREFIX 
#define COMPONENT sdf

#include "\x\cba\addons\main\script_macros_common.hpp"

// Modify relevant macros for no prefix (mission-side only)
#undef FUNC
#undef GVAR
#define FUNC(var1) TRIPLES(COMPONENT,fnc,var1)
#define GVAR(var1) DOUBLES(COMPONENT,var1)

#include "\a3\ui_f\hpp\definedikcodes.inc"
#include "\a3\ui_f_curator\ui\defineresincldesign.inc"

// Preferences
#define PROFILE_COLORS_R profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]
#define PROFILE_COLORS_G profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]
#define PROFILE_COLORS_B profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]

// Macros
#define GRID_W(N) (pixelW * pixelGridNoUIScale * N)
#define GRID_H(N) (pixelH * pixelGridNoUIScale * N)
#define GD_W(N) GRID_W(N * 1.5)
#define GD_H(N) GRID_H(N * 1.5)
#define COLOR_DISABLED 1,1,1,0.35
#define SPACING_W GRID_W(0.15)
#define SPACING_H GRID_H(0.15)
#define BUFFER_W GRID_W(0.2)
#define BUFFER_H GRID_H(0.2)
#define MIN_H GRID_H(1.3)
#define MAX_H GRID_H(25)
#define CONTENT_W GRID_W(30)
#define ITEM_H GRID_H(1.3)
#define DESCRIPTION_W GRID_W(12)
#define TITLE_H ITEM_H
#define MENU_BUTTON_W GRID_W(6)
#define MENU_BUTTON_H ITEM_H
#define CONTROL_X (DESCRIPTION_W + SPACING_W)
#define CONTROL_W (CONTENT_W - DESCRIPTION_W - SPACING_W)
#define CHECKBOX_W GRID_W(1.3)
#define CHECKBOX_H GRID_H(1.3)
#define EDITBOX_W CONTROL_W
#define EDITBOX_H ITEM_H
#define SLIDER_EDIT_W GRID_W(3)
#define SLIDER_W (CONTROL_W - SPACING_W - SLIDER_EDIT_W)
#define SLIDER_H ITEM_H
#define COMBOBOX_W CONTROL_W
#define COMBOBOX_H ITEM_H
#define LISTNBOX_W (DESCRIPTION_W + SPACING_W + CONTROL_W)
#define LISTNBOX_H ITEM_H
#define BUTTON_W (DESCRIPTION_W + SPACING_W + CONTROL_W)
#define BUTTON2_W (((DESCRIPTION_W + SPACING_W + CONTROL_W) / 2) - (SPACING_W / 2))
#define BUTTON_H ITEM_H
#define CARGOBOX_W (((DESCRIPTION_W + SPACING_W + CONTROL_W) * 0.475) - SPACING_W)
#define CARGOBOX_H ITEM_H
#define CARGOBOX_BUTTON_W ((DESCRIPTION_W + SPACING_W + CONTROL_W) * 0.05)
#define CARGOBOX_BUTTON_H (ITEM_H * 0.7)
#define TREE_W (DESCRIPTION_W + SPACING_W + CONTROL_W)
#define TREE_H ITEM_H
#define CREATE_DESCRIPTION \
	private _ctrlDescription = _display ctrlCreate [QGVAR(Text),-1,_ctrlGroup]; \
	_ctrlDescription ctrlSetPosition [0,_posY,DESCRIPTION_W,ITEM_H]; \
	_ctrlDescription ctrlCommit 0; \
	_ctrlDescription ctrlSetText _descriptionText; \
	_ctrlDescription ctrlSetTooltip _descriptionTooltip
