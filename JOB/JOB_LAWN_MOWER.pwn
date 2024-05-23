//======== PEMOTONG RUMPUT ===========
#define rumputpoint1 2042.72, -1235.55, 22.62
#define rumputpoint2 2035.11, -1194.66, 22.05
#define rumputpoint3 1991.54, -1163.09, 20.40
#define rumputpoint4 1939.73, -1162.16, 20.84
#define rumputpoint5 1911.13, -1176.61, 22.68
#define rumputpoint6 1921.98, -1206.99, 19.51
#define rumputpoint7 1911.06, -1223.52, 17.36
#define rumputpoint8 1893.78, -1207.13, 18.66
#define rumputpoint9 1939.89, -1179.61, 19.73
#define rumputpoint10 2007.53, -1180.57, 19.86
#define rumputpoint11 2013.93, -1213.90, 20.08
#define rumputpoint12 2016.85, -1238.84, 22.14
#define rumputpoint13 1995.15, -1241.47, 20.47
#define rumputpoint14 1998.52, -1226.51, 20.19
#define rumputpoint15 2037.85, -1179.11, 22.49
#define rumputpoint16 2046.97, -1172.56, 22.83
#define rumputpoint17 2052.72, -1197.52, 23.22
#define rumputpoint18 2052.34, -1219.99, 23.23
#define rumputpoint19 2050.38, -1239.72, 23.11

new RumputVeh[4];

AddRumputVehicle()
{
	RumputVeh[0] = AddStaticVehicleEx(572, 2039.13, -1249.12, 23.35+0.5, 359.51, 3, 0, VEHICLE_RESPAWN); // veh mower 1
	RumputVeh[1] = AddStaticVehicleEx(572, 2042.35, -1249.14, 23.35+0.5, 359.69, 3, 0, VEHICLE_RESPAWN); // veh mower 2
	RumputVeh[2] = AddStaticVehicleEx(572, 2045.79, -1248.99, 23.34+0.5, 0.36, 3, 0, VEHICLE_RESPAWN); // veh mower 3
	RumputVeh[3] = AddStaticVehicleEx(572, 2049.63, -1248.93, 23.33+0.5, 0.27, 3, 0, VEHICLE_RESPAWN); // veh mower 4
}
IsARumputVeh(carid)
{
	for(new v = 0; v < sizeof(RumputVeh); v++) {
	    if(carid == RumputVeh[v]) return 1;
	}
	return 0;
}