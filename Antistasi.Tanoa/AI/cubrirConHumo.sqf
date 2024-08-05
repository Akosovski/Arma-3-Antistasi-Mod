private ["_unit","_muzzle","_enemy","_return"];

_unit = _this select 0;
if !([_unit] call A3A_fnc_canFight) exitWith {};
_ayudado = _this select 1;
_return = false;
if (time < (group _unit) getVariable ["smokeUsed",time - 1]) exitWith {_return};

if (vehicle _unit != _unit) exitWith {};

(group _unit) setVariable ["smokeUsed",time + 60];

_muzzle = [_unit] call A3A_fnc_returnMuzzle;
_enemy = if (count _this > 2) then {_this select 2} else {_unit findNearestEnemy _unit};
if (_muzzle !="") then
	{
	if (!isNull _enemy) then
		{
		if (_enemy distance _unit > 75) then
			{
			if ((([objNull, "VIEW"] checkVisibility [eyePos _enemy, eyePos _ayudado]) > 0) or (behaviour _unit == "COMBAT")) then
				{
				_unit stop true;
				_unit disableAI "PATH";
				_unit doWatch getPosATL _enemy;
				_unit lookAt _enemy;
				_unit doTarget _enemy;
				sleep (abs (_unit getRelDir _enemy) / 90);
				_unit disableAI "MOVE";
				_unit setDir ((_unit getDir _enemy) - 10 + random 20);
				//if (_unit != _ayudado) then {sleep 5} else {sleep 1};
				_unit forceWeaponFire [_muzzle,_muzzle];
				sleep 1;
				_unit enableAI "MOVE";
            	_unit enableAI "PATH";
            	_unit doWatch objNull;
				_unit stop false;
				_unit doFollow (leader _unit);
				_return = true;
				};
			};
		};
	}
else
	{
	if (side _unit != buenos) then
		{
		if (fleeing _unit) then {[_unit,_enemy] call A3A_fnc_fuegoSupresor};
		};
	};
_return