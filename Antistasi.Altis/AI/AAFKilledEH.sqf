private ["_muerto","_killer","_coste","_enemy","_grupo"];
_muerto = _this select 0;
_killer = _this select 1;
[_muerto,"remove"] remoteExec ["A3A_fnc_flagaction",[buenos,civilian],_muerto];
if (_muerto getVariable ["spawner",false]) then
	{
	_muerto setVariable ["spawner",nil,true]
	};

[_muerto] spawn A3A_fnc_postmortem;
_grupo = group _muerto;
_lado = side (group _muerto);
if ((isNull _killer) || (_killer == _muerto)) then
	{
	if (hayACE) then {_killer = _muerto getVariable ["ace_medical_lastDamageSource", _killer]} else {_killer = _muerto getVariable ["lastInjurer",objNull]};
	};
if (side (group _killer) == buenos) then
	{
	if (isPlayer _killer) then
		{
		[1,_killer] call A3A_fnc_playerScoreAdd;
		if (captive _killer) then
			{
			if (_killer distance _muerto < distanciaSPWN) then
				{
				[_killer,false] remoteExec ["setCaptive",0,_killer];
				_killer setCaptive false;
				};
			};
		_killer addRating 1000;
		}
	else
		{
		if (_killer == vehicle _killer) then
			{
			if (skill _killer < 1) then
				{
				_skill = (skill _killer + 0.05) min 1;
				[_killer,_skill] remoteExec ["setSkill",_killer];
				if !(isMultiplayer) then
					{
					if (group _killer == group theBoss) then {_killer groupChat format ["Now I am more skilled. My current level is %1",_skill*10]};
					};
				};
			};
		};
	if (vehicle _killer isKindOf "StaticMortar") then
		{
		if (isMultiplayer) then
			{
			{
			if ((_x distance _muerto < 300) and (captive _x)) then {[_x,false] remoteExec ["setCaptive",0,_x]; _x setCaptive false};
			} forEach playableUnits;
			}
		else
			{
			if ((player distance _muerto < 300) and (captive player)) then {player setCaptive false};
			};
		};
	if (count weapons _muerto < 1) then
		{
		if (_lado == malos) then
			{
			[0,-2,getPos _muerto] remoteExec ["A3A_fnc_citySupportChange",2];
			[1,0] remoteExec ["A3A_fnc_prestige",2];
			}
		else
			{
			[0,1] remoteExec ["A3A_fnc_prestige",2];
			};
		}
	else
		{
		[-1,1,getPos _muerto] remoteExec ["A3A_fnc_citySupportChange",2];
		if (_lado == malos) then
			{
			[0.1,0] remoteExec ["A3A_fnc_prestige",2];
			}
		else
			{
			[0,0.25] remoteExec ["A3A_fnc_prestige",2];
			};
		};
	}
else
	{
	if (_lado == malos) then
		{
		[-0.25,0,getPos _muerto] remoteExec ["A3A_fnc_citySupportChange",2];
		}
	else
		{
		[0.25,0,getPos _muerto] remoteExec ["A3A_fnc_citySupportChange",2];
		};
	};
_marcador = _muerto getVariable "marcador";
_garrisoned = true;
if (isNil "_marcador") then {_marcador = _muerto getVariable ["origen",""]; _garrisoned = false};
if (_marcador != "") then
	{
	if (lados getVariable [_marcador,sideUnknown] == _lado) then
		{
		[typeOf _muerto,_lado,_marcador,-1] remoteExec ["A3A_fnc_garrisonUpdate",2];
		if (_garrisoned) then {[_marcador,_lado] remoteExec ["A3A_fnc_zoneCheck",2]};
		};
	};
[_grupo,_killer] spawn A3A_fnc_AIreactOnKill;

