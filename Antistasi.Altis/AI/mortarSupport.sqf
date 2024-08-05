private _morty = _this select 0;
private _mortero = vehicle _morty;
if (_mortero == _morty) exitWith {};
if (!alive _mortero) exitWith
	{
	(group _morty) setVariable ["morteros",objNull];
	};
if !(unitReady _morty) exitWith {};
if (_mortero getVariable ["busy",false]) exitWith {};
private _posicion = _this select 1;
private _rounds = _this select 2;
private _tipoMuni = (getArray (configfile >> "CfgVehicles" >> (typeOf _mortero) >> "Turrets" >> "MainTurret" >> "magazines")) select 0;
if ({(_x select 0) == _tipoMuni} count (magazinesAmmo _mortero) == 0) exitWith
	{
	moveOut _morty;
	(group _morty) setVariable ["morteros",objNull];
	};
private _objetivos = (group _morty) getVariable ["objetivos",[]];
if (_posicion isEqualTo []) then
	{
	if !(_objetivos isEqualTo []) then
		{
		{
		_eny = _x select 4;
		if ((_eny isKindOf "Man") and (_eny distance (_eny findNearestEnemy _eny) > 50)) exitWith {_posicion = getPosASL _eny};
		} forEach _objetivos;
		};
	};
if (_posicion isEqualTo []) exitWith {};
if !(_posicion inRangeOfArtillery [[_mortero], ((getArtilleryAmmo [_mortero]) select 0)]) exitWith {};
_mortero setVariable ["busy",true];
if (_rounds > 1) exitWith {_mortero commandArtilleryFire [_posicion,_tipoMuni,_rounds];sleep 5; _mortero setVariable ["busy",false]};
private _posiciones = [];
{
if (_rounds > 8) exitWith {};
_eny = _x select 4;
if ((_eny distance (_eny findNearestEnemy _eny) > 50) and (_eny distance _posicion < 50) and (_posiciones findIf {_x distance _eny < 10} == -1)) then
	{
	_posiciones pushBack getPosASL _eny;
	_rounds = _rounds +1;
	};
} forEach _objetivos;
{
_mortero commandArtilleryFire [_x,_tipoMuni,1];
sleep 3;
} forEach _posiciones;
_mortero setVariable ["busy",false];

