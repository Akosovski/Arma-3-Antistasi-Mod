private ["_veh","_marcador","_posicion","_grupos","_conocidos","_grupo","_lider"];
//deprectaed because of the new infoshare script
_veh = _this select 0;
{_x setSkill ["spotDistance",1]; _x setSkill ["spotTime",0.7]} forEach crew _veh;