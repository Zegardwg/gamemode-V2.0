// Server Define
#define TEXT_GAMEMODE   "KKRP v2.0.4"
#define TEXT_WEBURL     "Comingsoon"
#define TEXT_LANGUAGE   "Indonesia"
#define SERVER_BOT      "KONOHA:RP"
#define SERVER_NAME     "Konoha Roleplay"

// MySQL configuration
#define     MYSQL_HOST          "204.10.192.68"//
#define     MYSQL_USER          "u220_03FpxPh6pv"
#define     MYSQL_PASSWORD      "sV08yo@^Aekh7qZgev@608Jw"
#define     MYSQL_DATABASE      "s220_konoha_samp"

//wep
/*#define		MYSQL_HOST 	        "139.162.1.223"//
#define		MYSQL_USER 			"u40_Frk6Ny6O1y"
#define		MYSQL_PASSWORD 		"f7aDXlbV2gHBBnI1si!6yJD^"
#define		MYSQL_DATABASE 		"s40_valrise"*/


// how many seconds until it kicks the player for taking too long to login
#define		SECONDS_TO_LOGIN  60

// default spawn point: Las Venturas (The High Roller)
#define 	DEFAULT_POS_X 		1094.34
#define 	DEFAULT_POS_Y 		-2037.15
#define 	DEFAULT_POS_Z 		82.75
#define 	DEFAULT_POS_A 		0.07

//Android Client Check
#define IsPlayerAndroid(%0)                 GetPVarInt(%0, "NotAndroid") == 0

//
#define forex(%0,%1) for(new %0 = 0; %0 < %1; %0++)

// Message
#define function%0(%1) forward %0(%1); public %0(%1)
#define SendCustomMessage(%0,%1,%2)     SendClientMessageEx(%0, COLOR_ARWIN, %1": "WHITE_E""%2)
#define Servers(%1,%2) SendClientMessageEx(%1, COLOR_WHITE, ""GREY_E"<Server>: "WHITE_E""%2)
#define Info(%1,%2) SendClientMessageEx(%1, COLOR_WHITEP, ""YELLOW_E"<!>: "WHITE_E""%2)
#define Vehicle(%1,%2) SendClientMessageEx(%1, COLOR_WHITEP, ""LB_E"<Vehicle>: "WHITE_E""%2)
#define Usage(%1,%2) SendClientMessage(%1, COLOR_GREY, "<Usage>: "WHITE_E""%2)
#define Names(%1,%2) SendClientMessage(%1, COLOR_GREY, "<Names>: "WHITE_E""%2)
#define Error(%1,%2) SendClientMessageEx(%1, COLOR_GREY3, ""RED_E"<404>: "WHITE_E""%2)
#define Gps(%1,%2) SendClientMessageEx(%1, COLOR_GREY3, ""COLOR_GPS"[GPS]: "WHITE_E""%2)
#define PermissionError(%0) SendClientMessage(%0, COLOR_RED, "<404>: "WHITE_E"You are not allowed to use this commands!")
#define SpeedCheck(%0,%1,%2,%3,%4) floatround(floatsqroot(%4?(%0*%0+%1*%1+%2*%2):(%0*%0+%1*%1) ) *%3*1.6)
#define SendSyntaxMessage(%0,%1) \
        SendClientMessageEx(%0, COLOR_GREY, "<Usage>: "WHITE_E""%1)

#define HOLDING(%0)                     ((newkeys & (%0)) == (%0))

//#define SendCustomMessage(%0,%1,%2)     SendClientMessageEx(%0, COLOR_LBLUE, %1": "WHITE""%2)

#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

//Converter
#define minplus(%1) \
        (((%1) < 0) ? (-(%1)) : ((%1)))

// AntiCaps
#define UpperToLower(%1) for( new ToLowerChar; ToLowerChar < strlen( %1 ); ToLowerChar ++ ) if ( %1[ ToLowerChar ]> 64 && %1[ ToLowerChar ] < 91 ) %1[ ToLowerChar ] += 32

// Banneds
const BAN_MASK = (-1 << (32 - (/*this is the CIDR ip detection range [def: 26]*/26)));

new g_player_listitem[MAX_PLAYERS][96];
#define GetPlayerListitemValue(%0,%1) 		g_player_listitem[%0][%1]
#define SetPlayerListitemValue(%0,%1,%2) 	g_player_listitem[%0][%1] = %2

RGBAToARGB(rgba)
    return rgba >>> 8 | rgba << 24;

//---------[ Define Faction ]-----
#define SAPD	1		//locker 1573.26, -1652.93, -40.59
#define	SAGS	2		// 1464.10, -1790.31, 2349.68
#define SAMD	3		// -1100.25, 1980.02, -58.91
#define SANEW	4		// 256.14, 1776.99, 701.08
#define SACF    5               // 256.14, 1776.99, 701.08
//---------[ JOB ]---------//
#define BOX_INDEX            9 // Index Box Barang

#define MAX_MATERIALS              	 		(16)

#define FLAT_HIGH_INTERIOR (32)
#define FLAT_MEDIUM_INTERIOR (33)
#define FLAT_LOW_INTERIOR (34)

//Gate
#define MAX_GATES 500
    
//mdc
#define MAX_EMERGENCY				300
#define MDC_ERROR               (21001)
#define MDC_ERROR               (21001)
#define MDC_SELECT              (21000)
#define MDC_OPEN                (45400)
