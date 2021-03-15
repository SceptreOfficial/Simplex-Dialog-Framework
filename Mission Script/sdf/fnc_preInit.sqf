#include "script_component.hpp"

// Make profile background colors easy to access
GVAR(profileRGBA) = [
	profilenamespace getvariable ['GUI_BCG_RGB_R',0.77],
	profilenamespace getvariable ['GUI_BCG_RGB_G',0.51],
	profilenamespace getvariable ['GUI_BCG_RGB_B',0.08],
	profilenamespace getvariable ['GUI_BCG_RGB_A',1]
];
