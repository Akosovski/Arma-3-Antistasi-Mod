if (!isServer) exitWith{};

//debugperf = false;

private ["_tiempo","_marcadores","_marcador","_posicionMRK","_cuenta"];

waitUntil {!isNil "theBoss"};

_tiempo = 1/(count marcadores);
_cuenta = 0;
_greenfor = [];
_blufor = [];
_opfor = [];

while {true} do {
//sleep 0.01;
/*
if (time - _tiempo >= 0.5) then
	{
	sleep 0.1;
	_cuenta = _cuenta + 0.1
	}
else
	{
	sleep 0.5 - (time - _tiempo);
	_cuenta = _cuenta + (0.5 - (time-_tiempo));
	};
//if (debugperf) then {hint format ["Tiempo transcurrido: %1 para %2 marcadores", time - _tiempo, count marcadores]};
_tiempo = time;
*/
//sleep 1;
_cuenta = _cuenta + 1;
if (_cuenta > 5) then
	{
	_cuenta = 0;
	//_spawners = allUnits select {_x getVariable ["spawner",false]};
	_greenfor = (units buenos) select {_x getVariable ["spawner",false]};
	_blufor = (units malos) select {_x getVariable ["spawner",false]};
	_opfor = (units muyMalos) select {_x getVariable ["spawner",false]};
	/*
	{
	_lado = side (group _x);
	if (_lado == malos) then
		{
		_blufor pushBack _x;
		}
	else
		{
		if (_lado == muyMalos) then
			{
			_opfor pushBack _x;
			}
		else
			{
			_greenfor pushBack _x;
			};
		};
	} forEach _spawners;
	*/
	};

{
sleep _tiempo;
_marcador = _x;

_posicionMRK = getMarkerPos (_marcador);

if (lados getVariable [_marcador,sideUnknown] == malos) then
	{
	if (spawner getVariable _marcador != 0) then
		{
		if (spawner getVariable _marcador == 2) then
			{
			if (({if (_x distance2D _posicionMRK < distanciaSPWN) exitWith {1}} count _greenfor > 0) or ({if ((_x distance2D _posicionMRK < distanciaSPWN2)) exitWith {1}} count _opfor > 0) or ({if ((isPlayer _x) and (_x distance2D _posicionMRK < distanciaSPWN2)) exitWith {1}} count _blufor > 0) or (_marcador in forcedSpawn)) then
				{
				spawner setVariable [_marcador,0,true];
				if (_marcador in ciudades) then
					{
					if (({if (_x distance2D _posicionMRK < distanciaSPWN) exitWith {1}} count _greenfor > 0) or ({if ((isPlayer _x) and (_x distance2D _posicionMRK < distanciaSPWN2)) exitWith {1}} count _blufor > 0) or (_marcador in forcedSpawn)) then {[[_marcador],"A3A_fnc_createAIciudades"] call A3A_fnc_scheduler};
					if (not(_marcador in destroyedCities)) then
						{
						if (({if ((isPlayer _x) and (_x distance2D _posicionMRK < distanciaSPWN)) exitWith {1};false} count allUnits > 0) or (_marcador in forcedSpawn)) then {[[_marcador],"A3A_fnc_createCIV"] call A3A_fnc_scheduler};
						};
					}
				else
					{
					if (_marcador in controles) then {[[_marcador],"A3A_fnc_createAIcontroles"] call A3A_fnc_scheduler} else {
					if (_marcador in aeropuertos) then {[[_marcador],"A3A_fnc_createAIaerop"] call A3A_fnc_scheduler} else {
					if (((_marcador in recursos) or (_marcador in fabricas))) then {[[_marcador],"A3A_fnc_createAIrecursos"] call A3A_fnc_scheduler} else {
					if ((_marcador in puestos) or (_marcador in puertos)) then {[[_marcador],"A3A_fnc_createAIpuestos"] call A3A_fnc_scheduler};};};};
					};
				};
			}
		else
			{
			if (({if (_x distance2D _posicionMRK < distanciaSPWN) exitWith {1}} count _greenfor > 0) or ({if ((_x distance2D _posicionMRK < distanciaSPWN2)) exitWith {1}} count _opfor > 0) or ({if ((isPlayer _x) and (_x distance2D _posicionMRK < distanciaSPWN2)) exitWith {1}} count _blufor > 0) or (_marcador in forcedSpawn)) then
				{
				spawner setVariable [_marcador,0,true];
				if (isMUltiplayer) then
					{
					{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulationGlobal true}}} forEach allUnits;
					}
				else
					{
					{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulation true}}} forEach allUnits;
					};
				}
			else
				{
				if (({if (_x distance2D _posicionMRK < distanciaSPWN1) exitWith {1}} count _greenfor == 0) and ({if ((_x distance2D _posicionMRK < distanciaSPWN)) exitWith {1}} count _opfor == 0) and ({if ((isPlayer _x) and (_x distance2D _posicionMRK < distanciaSPWN)) exitWith {1}} count _blufor == 0) and (not(_marcador in forcedSpawn))) then
					{
					spawner setVariable [_marcador,2,true];
					};
				};
			};
		}
	else
		{
		if (({if (_x distance2D _posicionMRK < distanciaSPWN) exitWith {1}} count _greenfor == 0) and ({if ((_x distance2D _posicionMRK < distanciaSPWN2)) exitWith {1}} count _opfor == 0) and ({if ((isPlayer _x) and (_x distance2D _posicionMRK < distanciaSPWN2)) exitWith {1}} count _blufor == 0) and (not(_marcador in forcedSpawn))) then
			{
			spawner setVariable [_marcador,1,true];
			if (isMUltiplayer) then
					{
					{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulationGlobal false}}} forEach allUnits;
					}
				else
					{
					{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulation false}}} forEach allUnits;
					};
			};
		};
	}
else
	{
	if (lados getVariable [_marcador,sideUnknown] == buenos) then
		{
		if (spawner getVariable _marcador != 0) then
			{
			if (spawner getVariable _marcador == 2) then
				{
				if (({if (_x distance2D _posicionMRK < distanciaSPWN) exitWith {1}} count _blufor > 0) or ({if (_x distance2D _posicionMRK < distanciaSPWN) exitWith {1}} count _opfor > 0) or ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _posicionMRK < distanciaSPWN2)) exitWith {1}} count _greenfor > 0) or (_marcador in forcedSpawn)) then
					{
					spawner setVariable [_marcador,0,true];
					if (_marcador in ciudades) then
						{
						//[_marcador] remoteExec ["A3A_fnc_createAIciudades",HCGarrisons];
						if (not(_marcador in destroyedCities)) then
							{
							if (({if ((isPlayer _x) and (_x distance2D _posicionMRK < distanciaSPWN)) exitWith {1};false} count allUnits > 0) or (_marcador in forcedSpawn)) then {[[_marcador],"A3A_fnc_createCIV"] call A3A_fnc_scheduler};
							};
						};
					if (_marcador in puestosFIA) then {[[_marcador],"A3A_fnc_createFIApuestos2"] call A3A_fnc_scheduler} else {if (not(_marcador in controles)) then {[[_marcador],"A3A_fnc_createSDKGarrisons"] call A3A_fnc_scheduler}};
					};
				}
			else
				{
				if (({if (_x distance2D _posicionMRK < distanciaSPWN) exitWith {1}} count _blufor > 0) or ({if (_x distance2D _posicionMRK < distanciaSPWN) exitWith {1}} count _opfor > 0) or ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _posicionMRK < distanciaSPWN2) or (_marcador in forcedSpawn)) exitWith {1}} count _greenfor > 0)) then
					{
					spawner setVariable [_marcador,0,true];
					if (isMUltiplayer) then
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulationGlobal true}}} forEach allUnits;
						}
					else
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulation true}}} forEach allUnits;
						};
					}
				else
					{
					if (({if (_x distance2D _posicionMRK < distanciaSPWN1) exitWith {1}} count _blufor == 0) and ({if (_x distance2D _posicionMRK < distanciaSPWN1) exitWith {1}} count _opfor == 0) and ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _posicionMRK < distanciaSPWN)) exitWith {1}} count _greenfor == 0) and (not(_marcador in forcedSpawn))) then
						{
						spawner setVariable [_marcador,2,true];
						};
					};
				};
			}
		else
			{
			if (({if (_x distance2D _posicionMRK < distanciaSPWN) exitWith {1}} count _blufor == 0) and ({if (_x distance2D _posicionMRK < distanciaSPWN) exitWith {1}} count _opfor == 0) and ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _posicionMRK < distanciaSPWN2)) exitWith {1}} count _greenfor == 0) and (not(_marcador in forcedSpawn))) then
				{
				spawner setVariable [_marcador,1,true];
				if (isMUltiplayer) then
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulationGlobal false}}} forEach allUnits;
						}
					else
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulation false}}} forEach allUnits;
						};
				};
			};
		}
	else
		{
		if (spawner getVariable _marcador != 0) then
			{
			if (spawner getVariable _marcador == 2) then
				{
				if (({if (_x distance2D _posicionMRK < distanciaSPWN) exitWith {1}} count _greenfor > 0) or ({if ((_x distance2D _posicionMRK < distanciaSPWN2) and (isPlayer _x)) exitWith {1}} count _opfor > 0) or ({if (_x distance2D _posicionMRK < distanciaSPWN2) exitWith {1}} count _blufor > 0) or (_marcador in forcedSpawn)) then
					{
					spawner setVariable [_marcador,0,true];
					if (_marcador in controles) then {[[_marcador],"A3A_fnc_createAIcontroles"] call A3A_fnc_scheduler} else {
					if (_marcador in aeropuertos) then {[[_marcador],"A3A_fnc_createAIaerop"] call A3A_fnc_scheduler} else {
					if (((_marcador in recursos) or (_marcador in fabricas))) then {[[_marcador],"A3A_fnc_createAIrecursos"] call A3A_fnc_scheduler} else {
					if ((_marcador in puestos) or (_marcador in puertos)) then {[[_marcador],"A3A_fnc_createAIpuestos"] call A3A_fnc_scheduler};};};};
					};
				}
			else
				{
				if (({if (_x distance2D _posicionMRK < distanciaSPWN) exitWith {1}} count _greenfor > 0) or ({if ((_x distance2D _posicionMRK < distanciaSPWN2) and (isPlayer _x)) exitWith {1}} count _opfor > 0) or ({if (_x distance2D _posicionMRK < distanciaSPWN2) exitWith {1}} count _blufor > 0) or (_marcador in forcedSpawn)) then
					{
					spawner setVariable [_marcador,0,true];
					if (isMUltiplayer) then
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulationGlobal true}}} forEach allUnits;
						}
					else
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulation true}}} forEach allUnits;
						};
					}
				else
					{
					if (({if (_x distance2D _posicionMRK < distanciaSPWN1) exitWith {1}} count _greenfor == 0) and ({if ((_x distance2D _posicionMRK < distanciaSPWN2) and (isPlayer _x)) exitWith {1}} count _opfor == 0) and ({if ((_x distance2D _posicionMRK < distanciaSPWN)) exitWith {1}} count _blufor == 0) and (not(_marcador in forcedSpawn))) then
						{
						spawner setVariable [_marcador,2,true];
						};
					};
				};
			}
		else
			{
			if (({if (_x distance2D _posicionMRK < distanciaSPWN) exitWith {1}} count _greenfor == 0) and ({if ((_x distance2D _posicionMRK < distanciaSPWN2) and (isPlayer _x)) exitWith {1}} count _opfor == 0) and ({if (_x distance2D _posicionMRK < distanciaSPWN2) exitWith {1}} count _blufor == 0) and (not(_marcador in forcedSpawn))) then
				{
				spawner setVariable [_marcador,1,true];
				if (isMUltiplayer) then
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulationGlobal false}}} forEach allUnits;
						}
					else
						{
						{if (_x getVariable ["marcador",""] == _marcador) then {if (vehicle _x == _x) then {_x enableSimulation false}}} forEach allUnits;
						};
				};
			};
		};
	};
} forEach marcadores;

};