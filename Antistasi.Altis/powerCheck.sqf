private ["_marcador","_result","_posicion"];
if (antenas isEqualTo []) exitWith {sideUnknown};
_marcador = _this select 0;
_posicion = if (_marcador isEqualType "") then {getMarkerPos _marcador} else {_marcador};
_ant1 = [antenas,_posicion] call BIS_fnc_nearestPosition;
_ant2 = [antenasMuertas, _posicion] call BIS_fnc_nearestPosition;

if (_ant1 distance _posicion > _ant2 distance _posicion) exitWith {sideUnknown};

_puesto = [garrAntenas,_ant1] call BIS_fnc_NearestPosition;
/*
if (lados getVariable [_marcador,sideUnknown] == buenos) then
	{
	if (lados getVariable [_puesto,sideUnknown] == buenos) then {_result = true};
	}
else
	{
	if (lados getVariable [_puesto,sideUnknown] == malos) then {_result = true};
	};*/
private _lado = lados getVariable [_puesto,sideUnknown];
//_result
_lado