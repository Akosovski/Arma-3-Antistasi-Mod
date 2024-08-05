private _unit = _this select 0;
private _jugador = _this select 1;

private _grupo = group _unit;
_jugador globalChat "Ok boys let's get back to base!";

{
[_x,"remove"] remoteExec ["A3A_fnc_flagaction",[buenos,civilian],_x];
_x setVariable ["spawner",true,true];
_x forceSpeed -1;
} forEach units _grupo;
_grupo setVariable ["attackDrill",false];
sleep 3;
_unit globalChat "Thanks mate, we will follow you";
units _grupo join _jugador;
deleteGroup _grupo;


