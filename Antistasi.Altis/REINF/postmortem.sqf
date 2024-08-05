_muerto = _this select 0;
if (time < (_muerto getVariable ["postmortem",0])) exitWith {deleteVehicle _muerto};
sleep cleantime;
deleteVehicle _muerto;
_grupo = group _muerto;
if (!isNull _grupo) then
	{
	if ({alive _x} count units _grupo == 0) then {deleteGroup _grupo};
	};