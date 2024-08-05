if !(hasInterface) exitWith {};
if (iconShown) exitWith {};
iconShown = true;
addMissionEventHandler ["Draw3D",
	{
	_heridos = (((units group player) - [player])) select {(_x getVariable ["INCAPACITATED",false]) and (alive _x)};
    if !(_heridos isEqualTo []) then
    	{
        {
        if (_x distance player < 50) then
        	{
	        _pos = getPosATL _x;
	        _pos set [2,(_pos select 2) + 0.75];
	        _icon = if ([_x] call A3A_fnc_fatalWound) then {"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa"} else {"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa"};
		    drawIcon3D [_icon, [0.5,0,0,1], _pos, 1.25, 1.25, 0];
			};
		} forEach _heridos;
		}
	else
		{
		removeMissionEventHandler ["Draw3D",_thisEventHandler];
		iconShown = false;
		};
	}];