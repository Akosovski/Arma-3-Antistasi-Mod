if (!isServer and hasInterface) exitWith{};

private _marcador = _this select 0;
private _posicion = getMarkerPos _marcador;
private _tam = [_marcador] call A3A_fnc_sizeMarker;

private _tiempolim = 60;
if (hayIFA) then {_tiempolim = _tiempolim * 2};
private _fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
private _fechalimnum = dateToNumber _fechalim;

private _nombredest = [_marcador] call A3A_fnc_localizar;

[[buenos,civilian],"AS",[format ["Government presence in %1 is bothering our operations. Elliminate them all. Take no prisoners, so we will send a clear message. Do this before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Clean City",_marcador],_posicion,false,0,true,"Kill",true] call BIS_fnc_taskCreate;
while {!("AS" call BIS_fnc_taskCompleted)} do
	{
	sleep 5;
	if (spawner getVariable _marcador != 2) then
		{
		sleep 10;
		_soldados = (units malos) select {(alive _x) and !(_x getVariable ["surrendered",false]) and (_x inArea _marcador)};
		if (count _soldados == 0) then {["AS",[format ["Government presence in %1 is bothering our operations. Elliminate them all. Take no prisoners, so we will send a clear message. Do this before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Clean City",_marcador],_posicion,"SUCCEEDED"] call A3A_fnc_taskUpdate};
		}
	else
		{
		_soldados = [];
		};
	if (dateToNumber date > _fechalimnum) then {["AS",[format ["Government presence in %1 is bothering our operations. Elliminate them all. Take no prisoners, so we will send a clear message. Do this before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Clean City",_marcador],_posicion,"FAILED"] call A3A_fnc_taskUpdate};
	};
_nul = [1200,"AS"] spawn A3A_fnc_borrarTask;

if (dateToNumber date > _fechalimnum) exitWith
	{
	[-10,theBoss] call A3A_fnc_playerScoreAdd;
	};
[2,0] remoteExec ["A3A_fnc_prestige",2];
[0,300] remoteExec ["A3A_fnc_resourcesFIA",2];
{
if (!isPlayer _x) then
	{
	_skill = skill _x;
	_skill = _skill + 0.1;
	_x setSkill _skill;
	}
else
	{
	[10,_x] call A3A_fnc_playerScoreAdd;
	};
} forEach ([_tam,0,_posicion,buenos] call A3A_fnc_distanceUnits);
[5,theBoss] call A3A_fnc_playerScoreAdd;