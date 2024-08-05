private _unit = _this select 0;
private _grupo = group _unit;
private _lado = side _grupo;
private _posicion = position (leader _grupo);
private _result = false;
private _sitios = if (_lado == buenos) then {(puestos + puertos + aeropuertos + controles + ["Synd_HQ"]) select {(lados getVariable [_x,SideUnknown] == _lado) and ((getMarkerPos _x) distance2D _posicion < 3000)}} else {(puestos + puertos + aeropuertos) select {(lados getVariable [_x,SideUnknown] == _lado) and ((getMarkerPos _x) distance2D _posicion < 3000)}};
if (_sitios isEqualTo []) exitWith {_result};
if ((_sitios findIf {_unit inArea _x}) != -1) exitWith {true};
if ((_sitios findIf {([_x] call A3A_fnc_powerCheck == _lado)}) == -1) exitWith {_result};
if (hayIFA) then
	{
	if (hayTFAR or hayACRE) then
		{
		_result = true;
		}
	else
		{
		{if ((typeOf _x in (SDKGL+["LIB_FSJ_radioman","LIB_DAK_radioman","LIB_GER_radioman","LIB_SOV_operator"])) and ([_x] call A3A_fnc_canFight)) exitWith {_result = true}} forEach (units _grupo);
		};
	}
else
	{
	if (haveRadio or hayTFAR or hayACRE) then
		{
		_result = true;
		}
	else
		{
		{if ("ItemRadio" in assignedItems _x) exitWith {_result = true}} forEach (units _grupo);
		};
	};
_result