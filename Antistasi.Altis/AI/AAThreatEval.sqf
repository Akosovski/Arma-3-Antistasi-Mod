params ["_origen","_destino","_ladoOrigen","_alreadyEval"];
private _sideEny = [buenos];
private _AAUnits = if !(unlockedAA isEqualTo []) then {sdkMil} else {[]};
//private _AAVehs = [staticAABuenos];
if (gameMode == 1) then
	{
	if (_ladoOrigen == malos) then
		{
		_sideEny pushBack muyMalos;
		_AAUnits pushBack CSATAA;
		//_AAVehs = _AAVehs + [vehCSATAA,staticAAmuyMalos];
		}
	else
		{
		_sideEny pushBack malos;
		_AAUnits pushBack NATOAA;
		//_AAVehs = _AAVehs + [vehNATOAA,staticAAMalos];
		}
	};
//if ((_AAUnits isEqualTo []) and (_AAVehs isEqualTo [])) exitWith {[0,_alreadyEval]};
private _enyMarkers = marcadores - controles - (ciudades select {lados getVariable [_x,sideUnknown] != buenos}) - _alreadyEval;
_enyMarkers = _enyMarkers select {lados getVariable [_x,sideUnknown] in _sideEny};
if (_enyMarkers isEqualTo []) exitWith {[0,_alreadyEval]};
private _posOrigen = getMarkerPos _origen;
private _posDestino = if !(_destino isEqualType []) then {getMarkerPos _destino} else {_destino};
private _dir = _posOrigen getDir _posDestino;
private _dist = (_posOrigen distance2D _posDestino) max distanciaSPWN;
private _rounds = ceil (_dist / distanciaSPWN);
private _posRef = _posOrigen;
private _tmpEnyMarkers = [];
private _result = 0;
for "_i" from 1 to _rounds do
	{
	_posRef = _posRef getPos [distanciaSPWN,_dir];
	_tmpEnyMarkers = _enyMarkers select {getMarkerPos _x distance2D _posRef < distanciaSPWN};
	{
	private _marcador = _x;
	_alreadyEval pushBackUnique _marcador;
	_enyMarkers = _enyMarkers - [_marcador];
	if (spawner getVariable [_marcador,0] == 2) then
		{
		_result = _result + ({_x in _AAUnits} count (garrison getVariable [_marcador,[]]));
		if (lados getVariable [_marcador,sideUnknown] != buenos) then
			{
			if (_marcador in aeropuertos) then {_result = _result + 15};
			}
		else
			{
			_result = _result + 5*({((_x isKindOf "StaticWeapon") and !(_x isKindOf "StaticMortar")) and (_x inArea _marcador) and (canFire _x)} count vehicles);
			};
		}
	else
		{
		_result = _result + ({((typeOf _x) in _AAUnits) and (_x inArea _marcador) and ([_x] call A3A_fnc_canFight)} count allUnits);
		_result = _result + 5*({((_x isKindOf "StaticWeapon") and !(_x isKindOf "StaticMortar")) and (_x inArea _marcador) and (canFire _x)} count vehicles);
		};
	} forEach _tmpEnyMarkers;
	};
[_result,_alreadyEval]