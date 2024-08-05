private ["_grupo","_killer","_marcador","_super","_enemy","_lado"];
_grupo = _this select 0;
_killer = _this select 1;
_lado = side _grupo;
if((isNil "_killer") || {(isNull _killer) || {side (group _killer) == _lado}}) exitWith {};
_QRFcall = false;
_enemy = objNull;
{
if ([_x] call A3A_fnc_canFight) then
	{
	_enemy = _x findNearestEnemy _x;
	if (!isNull _enemy) then
		{
		if !(fleeing _x) then
			{
			_QRFcall = true;
			if (([primaryWeapon _x] call BIS_fnc_baseWeapon) in mguns) then
				{
				[_x,_enemy] call A3A_fnc_fuegoSupresor;
				}
			else
				{
				if (sunOrMoon == 1 or haveNV) then
					{
					[_x,_x,_enemy] spawn A3A_fnc_cubrirConHumo;
					};
				};
			}
		else
			{
			if (_x distance _enemy < 100) then
				{
				[_x] spawn A3A_fnc_surrenderAction;
				}
			else
				{
				if (([primaryWeapon _x] call BIS_fnc_baseWeapon) in mguns) then
					{
					[_x,_enemy] call A3A_fnc_fuegoSupresor;
					}
				else
					{
					if (sunOrMoon == 1) then
						{
						[_x,_x,_enemy] spawn A3A_fnc_cubrirConHumo;
						};
					};
				};
			};
		};
	if (random 1 < 0.5) then {if (count units _grupo > 0) then {_x allowFleeing (1 -(_x skill "courage") + (({!([_x] call A3A_fnc_canFight)} count units _grupo)/(count units _grupo)))}};
	};
sleep 1 + (random 1);
} forEach units _grupo;

if (_QRFcall) then
	{
	_lider = leader _grupo;
	if ([_lider] call A3A_fnc_canFight and [_lider] call A3A_fnc_hasRadio) then
		{
		if (_grupo getVariable ["lastQRFCall",0] < time) then
			{
			_grupo setVariable ["lastQRFCall",time + 600];
			if (vehicle _enemy == _enemy) then
				{
				[[getPosASL _enemy,_lado,"Normal",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]
				}
			else
				{
				if (vehicle _enemy isKindOf "Air") then
					{
					[[getPosASL _enemy,_lado,"Air",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]
					}
				else
					{
					[[getPosASL _enemy,_lado,"Tank",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]
					};
				};
			};
		};
	};
