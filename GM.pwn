#pragma warning disable 239, 214, 232
#include <a_samp>
#include <strlib>
#undef MAX_PLAYERS
#define MAX_PLAYERS	500
#include <crashdetect.inc> 
#include <gvar.inc>
#include <a_mysql.inc>
#include <a_actor.inc>
#include <a_zones.inc>
#include <CTime.inc>
#include <progress2.inc>
#include <Pawn.CMD.inc>
#include <mSelection.inc>
#include <TimestampToDate.inc>
#define ENABLE_3D_TRYG_YSI_SUPPORT
#include <3DTryg.inc>
#include <streamer.inc>
#include <EVF2.inc>
#include <YSI\y_timers>
#include <YSI\y_ini>
#include <sscanf2.inc>
#include <yom_buttons.inc>
#include <geoiplite.inc>
#include <garageblock.inc>
#include <timerfix.inc>
#include <compat.inc>
#include <editing>                  //by Pottus
#include <PreviewModelDialog>
#include <fixobject>
#include <easyDialog>
//#include <nex-ac>

#define DCMD_PREFIX '!'
#include <discord-connector.inc>
#include <discord-cmd.inc>

//#include <ui_showbar>
#include <ui_info_tombol>
#include <ui_showbox.inc>
//#include <ui-notifications>

#include <sampvoice>

//-----[ Modular ]-----
#include "DEFINE.pwn"

//new DCC_Channel:g_Discord_Cs;
//====== QUIZ
new quiz,
	answers[256],
	answermade,
	qprs;

//ID GENZO
new Text3D:playerID[MAX_PLAYERS];
//logs player
new Text3D:PlayerDisconnect[MAX_PLAYERS];
//-----[ Discord Connector ]-----
new pemainic;
//CP
new buatbenang[2];
new buatkain[3];
new buatpakaian[3];
//new Kompensasi;
new PenjualanBarang;
new Healing;
//====[TIMER]===
new
    stresstimer[MAX_PLAYERS], ayamjob[MAX_PLAYERS], KeluarKerja[MAX_PLAYERS], TimerKeluar[MAX_PLAYERS];
//=========[ JAM FIVEM ]==========
new JamCall[MAX_PLAYERS];
new DetikCall[MAX_PLAYERS];
new MenitCall[MAX_PLAYERS];
new SV_GSTREAM:OnPhone[MAX_PLAYERS];
//Voice
new ToggleCall[MAX_PLAYERS];
new CallTimer[MAX_PLAYERS];

//new ListedFlat[MAX_PLAYERS][2];

//====[JOB GENZO]===
new penambang;
new lumberjack;
new trucker;
new miner;
new production;
new farmers;
new hauling;
new pizza;
new butcher;
new reflenish;
new pemerassusu;
new tukangkayu;
new penjahitt;
new tukangayams;
new penambangminyak;
new Recycler;
new Sopirbus;

//DAUR ULANG
new mulaikerja;
new ambilbox;
new ambilbox1;
new ambilbox2;
new jualdaurulang;
new daurulangnya1;
new daurulang2;
new daurulang3;
new nyortir1,
	nyortir2,
	nyortir3;

//====[FACTION LIST ONLINE]===
new polisidikota,
	pemerintahdikota,
	medisdikota,
	newsdikota,
	pedagangdikota,
	gojekdikota,
	mekanikdikota;

//BAJU SYSTEM GEN
new cskin[MAX_PLAYERS];
static const PedMan[] =
{
    1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33,
	34, 35, 36, 37, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 68, 72, 73,
	78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
	110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133,
	134, 135, 136, 137, 142, 143, 144, 146, 153, 154, 156, 158, 159, 160, 161, 162, 167, 168, 170,
	171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 188, 189, 190, 200, 202, 203,
	204, 206, 208, 209, 210, 212, 213, 217, 220, 221, 222, 223, 228, 229, 230, 234, 235, 236, 239, 240, 241,
	242, 247, 248, 249, 250, 253, 254, 255, 258, 259, 260, 261, 262, 268, 272, 273, 289, 290, 291, 292, 293,
	294, 296, 297, 299
};
/*static const Kendaraan[] =
{
	481, 509, 510, 462, 586, 581, 461, 521, 463, 468, 400, 412, 419, 426, 436, 466, 467, 474, 475, 480, 603, 421,
	602, 492, 545, 489, 405, 445, 579, 507, 483, 534, 535, 536, 558, 560, 565, 567, 575, 576
};*/
static const PedMale[] =
{
    9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69, 75, 76, 77, 85, 88, 89, 90, 91, 92,
	93, 129, 130, 131, 138, 140, 141, 145, 148, 150, 151, 152, 157, 169, 178, 190, 191, 192, 193, 194, 195, 196,
	197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245,
	246, 251, 256, 257, 263, 298
};

//----------[ New Variable ]-----
enum
{
	DIALOG_BUG,
	//---[ DIALOG PUBLIC ]---
	DIALOG_UNUSED,
	DIALOG_HOLIMARKET,
	DIALOG_DISNAKER,
	DIALOG_SPAWNGEN,
	DIALOG_VRM,
	DIALOG_SHOWKTP,
	DIALOG_SHOWSIM,
	DIALOG_SHOWBPJS,
	DIALOG_SHOWSKCK,
	DIALOG_SHOWSKS,
	DIALOG_GPS_PENJAHIT,
	DIALOG_JOB_AYAM,
	DIALOG_GPS_TUKANGAYAM,
	DIALOG_GPS_MINYAK,
	DIALOG_GPS_REYCYCLER,
	DIALOG_MULAIBOX,
	DIALOG_AYAMFILL,
	DIALOG_BULUAYAM,
	DIALOG_BAHAMAS,
	//GENZO NEW
	DIALOG_PLAYERMENU,
	DIALOG_IKAT,
	DIALOG_LEPASIKAT,
	DIALOG_GELEDAH,
	DIALOG_AIRDROP,
	//GPS JOB
	DIALOG_GPS_LUMBER,
	DIALOG_GPS_TRUCK,
	DIALOG_GPS_MINER,
	DIALOG_GPS_PRODUCT,
	DIALOG_GPS_FARMER,
	DIALOG_GPS_HAULS,
	DIALOG_GPS_PIZZA,
	DIALOG_GPS_BUTCHER,
	DIALOG_GPS_REFLENISH,
	DIALOG_GPS_PEMERAH,
	DIALOG_GPS_TKAYU,
	DIALOG_GPS_PENJAHITS,
	DIALOG_GPS_SIDEJOB,
	//SPRAY GEN
	DIALOG_SPRAYTAG,
	DIALOG_SPRAYTAG_TEXT,
	DIALOG_SPRAYTAG_FONT,
	DIALOG_SPRAYTAG_COLOR,
	DIALOG_SPRAYTAG_SIZE,
	DIALOG_SPRAYTAG_BOLD,
	DIALOG_SPRAYTAG_MODE,
	//JOB PETANI GEN
	DIALOG_GPS_PETANI,
	DIALOG_JOB_PETANI_MENGOLAHBAHAN,
	//UCP
    UCP_LOGIN,
    UCP_PIN,
    UCP_PASSWORD,
   	UCP_CHARACTER,
   	UCP_CHARACTER_CREATE,
   	DIALOG_PASSWORD,
    DIALOG_AGE,
    DIALOG_ORIGIN,
	DIALOG_GENDER,
	DIALOG_FIRST_SPAWN,
	DIALOG_EMAIL,
	DIALOG_STATS,
	DIALOG_SETTINGS,
	DIALOG_ASETTINGS,
	DIALOG_HBEMODE,
	DIALOG_CHANGEAGE,
	DIALOG_DMV,
	//BARU GENZO
	DIALOG_MAKE_CHAR,
	DIALOG_CHARLIST,
	DIALOG_VERIFYCODE,
	DIALOG_LOGIN,
	DIALOG_REGISTER,
	DIALOG_TINGGI,
	DIALOG_BERAT,
	//-----------------------
	DIALOG_GOLDSHOP,
	DIALOG_GOLDNAME,
	//---[ DIALOG BISNIS ]---
	DIALOG_SELL_BISNISS,
	DIALOG_SELL_BISNIS,
	DIALOG_MY_BISNIS,
	BISNIS_MENU,
	BISNIS_INFO,
	BISNIS_NAME,
	BISNIS_VAULT,
	BISNIS_WITHDRAW,
	BISNIS_DEPOSIT,
	BISNIS_BUYPROD,
	BISNIS_EDITPROD,
	BISNIS_PRICESET,
	BISNIS_SONG_URL,
	BISNIS_ACTOR,
	//Bisnis Genzo
	BISNIS_BUYPROD2,
	BISNIS_EDITPROD2,
	BISNIS_PRICESET2,
	DIALOG_SELL_BISNISS2,
	DIALOG_SELL_BISNIS2,
	DIALOG_MY_BISNIS2,
	BISNIS_INFO2,
	BISNIS_MENU2,
	BISNIS_NAME2,
	BISNIS_VAULT2,
	BISNIS_DEPOSIT2,
	BISNIS_WITHDRAW2,
	DIALOG_TRACKBUSINESS,
	//---[ DIALOG HOUSE ]---
	DIALOG_SELL_HOUSES,
	DIALOG_SELL_HOUSE,
	DIALOG_MY_HOUSES,
	HOUSE_INFO,
	HOUSE_STORAGE,
	HOUSE_WEAPONS,
	
	HOUSE_MONEY,
	HOUSE_WITHDRAWMONEY,
	HOUSE_DEPOSITMONEY,

	HOUSE_COMPONENT,
	HOUSE_WITHDRAWCOMPONENT,
	HOUSE_DEPOSITCOMPONENT,

	HOUSE_MATERIAL,
	HOUSE_WITHDRAWMATERIAL,
	HOUSE_DEPOSITMATERIAL,

	HOUSE_MARIJUANA,
	HOUSE_WITHDRAWMARIJUANA,
	HOUSE_DEPOSITMARIJUANA,

	HOUSE_EPHEDRINE,
	HOUSE_WITHDRAWEPHEDRINE,
	HOUSE_DEPOSITEPHEDRINE,

	HOUSE_COCAINE,
	HOUSE_WITHDRAWCOCAINE,
	HOUSE_DEPOSITCOCAINE,

	HOUSE_METH,
	HOUSE_WITHDRAWMETH,
	HOUSE_DEPOSITMETH,
	//--[ VEHICLE STORAGE]--
	VEHICLE_STORAGE,

	VEHICLE_WEAPONS,

	//NEW VSTORAGE
	VEHICLE_WEAPON,
	VEHICLE_OTHER,
	VEHICLE_SEED1,
	VEHICLE_SEED_WITHDRAW1,
	VEHICLE_SEED_DEPOSIT1,
	VEHICLE_MATERIAL1,
	VEHICLE_MATERIAL_WITHDRAW1,
	VEHICLE_MATERIAL_DEPOSIT1,
	VEHICLE_MARIJUANA1,
	VEHICLE_MARIJUANA_WITHDRAW1,
	VEHICLE_MARIJUANA_DEPOSIT1,
	VEHICLE_COMPONENT1,
	VEHICLE_COMPONENT_WITHDRAW1,
	VEHICLE_COMPONENT_DEPOSIT1,
	//
	VEHICLE_MONEY,
	VEHICLE_DEPOSITMONEY,
	VEHICLE_WITHDRAWMONEY,

	VEHICLE_COMPONENT,
	VEHICLE_DEPOSITCOMPONENT,
	VEHICLE_WITHDRAWCOMPONENT,

	VEHICLE_MATERIAL,
	VEHICLE_DEPOSITMATERIAL,
	VEHICLE_WITHDRAWMATERIAL,

	VEHICLE_SEED,
	VEHICLE_DEPOSITSEED,
	VEHICLE_WITHDRAWSEED,

	VEHICLE_MARIJUANA,
	VEHICLE_DEPOSITMARIJUANA,
	VEHICLE_WITHDRAWMARIJUANA,
	//---[ DIALOG PRIVATE VEHICLE ]---
	DIALOG_PVEHMENU,
	DIALOG_PVEHMENULIST,
	DIALOG_GOTOVEH,
	DIALOG_GETVEH,
	DIALOG_DELETEVEH,
	DIALOG_BUYPLATE,
	DIALOG_PVEHLOCKED,

	DIALOG_BUYPVCP_BIKES,
	DIALOG_BUYPVCP_CARS,
	DIALOG_BUYPVCP_UCARS,
	DIALOG_BUYPVCP_JOBCARS,
	DIALOG_BUYPVCP_VIPCARS,
	DIALOG_RENT_JOBCARS,

	DIALOG_BUYPVCP_CONFIRM,
	DIALOG_BUYPVCP_VIPCONFIRM,
	DIALOG_RENT_JOBCARSCONFIRM,
	//---[ DIALOG TOYS ]---
	DIALOG_TOY,
	DIALOG_TOYEDIT,
	DIALOG_TOYPOSISI,
	DIALOG_TOYPOSISIBUY,
	DIALOG_TOYBUY,
	DIALOG_TOYVIP,
	DIALOG_TOYPOSX,
	DIALOG_TOYPOSY,
	DIALOG_TOYPOSZ,
	DIALOG_TOYPOSRX,
	DIALOG_TOYPOSRY,
	DIALOG_TOYPOSRZ,
	//---[ DIALOG PLAYER ]---
	DIALOG_HELP,
	DIALOG_GPS,
	DIALOG_JOB,
	DIALOG_GPS_JOB,
	DIALOG_GPS_PENAMBANG,
	DIALOG_GPS_TUKANGKAYU,
	DIALOG_GPS_MORE,
	DIALOG_GPS_PERSONAL,
	DIALOG_GPS_NEAREST,
	GPS_NEAREST_GARKOT,
	GPS_NEAREST_BISNIS,
	GPS_NEAREST_DEALER,
	GPS_NEAREST_WORKSHOP,
	GPS_NEAREST_GSTATION,
	DIALOG_PAY,
	//---[ DIALOG WEAPONS ]---
	DIALOG_EDITBONE,
	//---[ DIALOG FAMILY ]---
	FAMILY_SAFE,
	FAMILY_STORAGE,
	FAMILY_WEAPONS,
	FAMILY_MARIJUANA,
	FAMILY_WITHDRAWMARIJUANA,
	FAMILY_DEPOSITMARIJUANA,
	FAMILY_COMPONENT,
	FAMILY_WITHDRAWCOMPONENT,
	FAMILY_DEPOSITCOMPONENT,
	FAMILY_MATERIAL,
	FAMILY_WITHDRAWMATERIAL,
	FAMILY_DEPOSITMATERIAL,
	FAMILY_MONEY,
	FAMILY_WITHDRAWMONEY,
	FAMILY_DEPOSITMONEY,
	FAMILY_INFO,
	DIALOG_FMENU,
	//---[ DIALOG FACTION ]---
	DIALOG_LOCKERSAPD,
	DIALOG_WEAPONSAPD,
	DIALOG_LOCKERSAGS,
	DIALOG_WEAPONSAGS,
	DIALOG_LOCKERSAMD,
	DIALOG_WEAPONSAMD,
	DIALOG_LOCKERSANEW,
	DIALOG_WEAPONSANEW,
	DIALOG_LOCKERSACF,
	DIALOG_WEAPONSACF,
	DIALOG_LOCKERVIP,
	//---[ DIALOG JOB ]---
	//MECH
	DIALOG_SERVICE,
	DIALOG_SERVICE_COLOR,
	DIALOG_SERVICE_COLOR2,
	DIALOG_SERVICE_PAINTJOB,
	DIALOG_SERVICE_WHEELS,
	DIALOG_SERVICE_SPOILER,
	DIALOG_SERVICE_HOODS,
	DIALOG_SERVICE_VENTS,
	DIALOG_SERVICE_LIGHTS,
	DIALOG_SERVICE_EXHAUSTS,
	DIALOG_SERVICE_FRONT_BUMPERS,
	DIALOG_SERVICE_REAR_BUMPERS,
	DIALOG_SERVICE_ROOFS,
	DIALOG_SERVICE_SIDE_SKIRTS,
	DIALOG_SERVICE_BULLBARS,
	DIALOG_SERVICE_NEON,
	//Trucker
	DIALOG_LOADBOX,
	DIALOG_RESTOCK,
	DIALOG_RESTOCK1,
	DIALOG_RESTOCK2,
	DIALOG_RESTOCK_FOOD,
	DIALOG_RESTOCK_MARKET,
	DIALOG_RESTOCK_CLOTHES,
	DIALOG_RESTOCK_EQUIPMENT,
	DIALOG_RESTOCK_GUNSHOP,
	DIALOG_RESTOCK_GYM,
	DIALOG_RESTOCK_VENDING,
	
	//Hauling
	HAULING_DELIVERY,
	DIALOG_RESTOCK_DEALER,
	
	//Farmer job
	DIALOG_PLANT,
	DIALOG_EDIT_PRICE,
	DIALOG_EDIT_PRICE1,
	DIALOG_EDIT_PRICE2,
	DIALOG_EDIT_PRICE3,
	DIALOG_EDIT_PRICE4,
	DIALOG_OFFER,
	//----[ Items ]-----
	DIALOG_MATERIAL,
	DIALOG_COMPONENT,
	DIALOG_DRUGS,
	DIALOG_FOOD,
	DIALOG_FOOD_BUY,
	DIALOG_SEED_BUY,
	DIALOG_PRODUCT,
	DIALOG_GASOIL,
	DIALOG_APOTEK,
	DIALOG_BUY_MEDICINE,
	DIALOG_BUY_MEDKIT,
	DIALOG_BUY_BANDAGE,
	DIALOG_BUY_STRESS,
	//Bank
	DIALOG_BANK,
	DIALOG_BANKDEPOSIT,
	DIALOG_BANKWITHDRAW,
	DIALOG_BANKREKENING,
	DIALOG_BANKTRANSFER,
	DIALOG_BANKCONFIRM,
	DIALOG_BANKSUKSES,
	//ATM
	DIALOG_ATM,
	DIALOG_ATMWITHDRAW,
	DIALOG_ATMREKENING,
	DIALOG_ATMTRANSFER,
	DIALOG_ATMCONFIRM,
	DIALOG_ATMSUKSES,
	DIALOG_FIND_ATM,
	DIALOG_VALUETF,
	DIALOG_TRANSFERREK,
	//reports
	DIALOG_REPORTS,
	//ask
	DIALOG_ASKS,
	DIALOG_SALARY,
	DIALOG_PAYCHECK,
	
	//Sidejob
	DIALOG_SWEEPER,
	DIALOG_BUS,
	DIALOG_FORKLIFT,
	DIALOG_LAWN_MOWER,
	DIALOG_TRASHMASTER,
	// HEALTH
	DIALOG_HEALTH,
	// PHONE
	DIALOG_PHONE,
	DIALOG_MBANK,
	DIALOG_APPSTORE,
	// STUCK
	DIALOG_STUCK,
	// WORKSHOP
	WORKSHOP_MENU,
	WORKSHOP_NAME,
	WORKSHOP_INFO,
	WORKSHOP_MONEY,
	WORKSHOP_WITHDRAWMONEY,
	WORKSHOP_DEPOSITMONEY,
	WORKSHOP_COMPONENT,
	WORKSHOP_WITHDRAWCOMPONENT,
	WORKSHOP_DEPOSITCOMPONENT,
	WORKSHOP_SERVICE,
	//RENTAL SYSTEM
	DIALOG_RENTBOAT,
	DIALOG_RENTBOAT_CONFIRM,
	DIALOG_RENTBIKES,
	DIALOG_RENTAL_CONFIRM,
	//DEALER SYSTEM
	DEALER_MENU,
	DEALER_NAME,
	DEALER_VAULT,
	DEALER_WITHDRAW,
	DEALER_DEPOSIT,
	DEALER_EDITPROD,
	DEALER_SETPRICE,
	DIALOG_MY_DEALER,
	DEALER_INFO,
	DIALOG_SELL_DEALER,
	DIALOG_SELL_DEALER2,
	//PRIVATE FARMER
	PFARM_MENU,
	PFARM_PLANT,
	PFARM_SEEDS,
	PFARM_DEPOSIT_SEEDS,
	PFARM_WITHDRAW_SEEDS,
	PFARM_POTATO,
	PFARM_DEPOSIT_POTATO,
	PFARM_WITHDRAW_POTATO,
	PFARM_ORANGE,
	PFARM_DEPOSIT_ORANGE,
	PFARM_WITHDRAW_ORANGE,
	PFARM_WHEAT,
	PFARM_DEPOSIT_WHEAT,
	PFARM_WITHDRAW_WHEAT,
	DIALOG_MY_PFARM,
	//VENDING SYSTEM
	VENDING_MENU,
	VENDING_DRINK_PRICE,
	VENDING_MONEY,
	VENDING_DEPOSITMONEY,
	VENDING_WITHDRAWMONEY,
	VENDING_DEPOSITSPRUNK,
	DIALOG_MY_VENDING,
	DIALOG_PAYTAX,
	DIALOG_PAYTAX_BISNIS,
	DIALOG_PAYTAX_HOUSE,
	DIALOG_PAYTAX_DEALER,
	DIALOG_PAYTAX_VENDING,
	//CONTACT
	DIALOG_ADDCTRESPONSE,
	DIALOG_ADDCT,
	DIALOG_EDITCTRESPONSE,
	DIALOG_EDITCTMENU,
	DIALOG_EDITNAMECT,
	DIALOG_EDITNUMBERCT,
	DIALOG_SENDMSGCT,
	GARKOT_PICKUP,
	//TILANG SAPD
	DIALOG_TICKET,
	DIALOG_CLEARTICKET,
	//CLAIM INSURANCE
	VEHICLE_INSURANCE,
	DIALOG_BOOMBOX,
	DIALOG_BOOMBOX_URL,
	//MDC MENU
	PMDC_MENU,
	EMDC_MENU,
	MDC_VEHICLE,
	MDC_BISNIS,
	MDC_HOUSE,
	MDC_PHONE,
	MDC_VEHICLE_MENU,
	MDC_BISNIS_MENU,
	MDC_HOUSE_MENU,
	MDC_VEHICLE_TRACK,
	MDC_BISNIS_TRACK,
	MDC_HOUSE_TRACK,

	DIALOG_MDC_911,
	DIALOG_MDC_911_MENU,
	DIALOG_MDC_911_LIST,
	DIALOG_MDC_911_DETAILS,
	DIALOG_CALL_911,
	DIALOG_MDC_RETURN,

	DIALOG_INVOICE,
	DIALOG_INVOICE_RETURN,

	DIALOG_EMERGENCY_LIST,

	MYTAX_MENU,
	MYTAX_BISNIS,
	MYTAX_HOUSE,
	MYTAX_DEALER,
	TWITTER_MENU,
	TWITTER_NAME,
	TWITTER_POST,
	DIALOG_WASSAP,
	DIALOG_TOGGLEPHONE,
	DIALOG_PANELPHONE,
	DIALOG_PHONE_SENDSMS,
	DIALOG_SHARELOC,
	DIALOG_PHONE_TEXTSMS,
	DIALOG_PHONE_DIALUMBER,
	//NPC FAMILY
	NPCFAM_EDITPROD,
	NPCFAM_PRICESET,
	NPCFAM_BUYPROD,
	NPCFAM_MENU,
	NPCFAM_MONEY,
	NPCFAM_MONEY_WITHDRAW,
	NPCFAM_MONEY_DEPOSIT,
	NPCFAM_MATERIAL,
	NPCFAM_MATERIAL_WITHDRAW,
	NPCFAM_MATERIAL_DEPOSIT,
	NPCFAM_MARIJUANA,
	NPCFAM_MARIJUANA_WITHDRAW,
	NPCFAM_MARIJUANA_DEPOSIT,
	NPCFAM_COCAINE,
	NPCFAM_COCAINE_WITHDRAW,
	NPCFAM_COCAINE_DEPOSIT,
	NPCFAM_METH,
	NPCFAM_METH_WITHDRAW,
	NPCFAM_METH_DEPOSIT,
	//FACTION VEHICLE
	SVPOINT_SAPD,
    SVPOINT_SAGS,
    SVPOINT_SAMD,
    SVPOINT_SANEWS,
    SVPOINT_SACF,
    SVPOINT_SPAWNVEH,
    //Vehicle Toys
    DIALOG_VTOY,
    DIALOG_VTOYEDIT,
    DIALOG_VTOYPOSX,
    DIALOG_VTOYPOSY,
    DIALOG_VTOYPOSZ,
    DIALOG_VTOYPOSRX,
    DIALOG_VTOYPOSRY,
    DIALOG_VTOYPOSRZ,
    DIALOG_VTOYBUY,
    ADSLOG_LIST,
    //----[ INVENTORY ]--------
	DIALOG_INVENTORY,
	DIALOG_INVACTION,
	DIALOG_GIVEAMOUNT,
	DIALOG_GIVEITEM,
	DIALOG_GIVE,
	DIALOG_TAKE,
	DIALOG_AMOUNT,
	//-----[ JOB CENTER ]------
	DIALOG_JOBCENTER,
	DIALOG_DAFTAR_JOB1,
	DIALOG_DAFTAR_JOB2,
	//----[ CENTER BALKOT ]----
	DIALOG_BALKOT,
	//---[ PLAYER MENU ]-----
	DIALOG_MENU_PLAYER,
	//---[ MENU VEHICLE ]---
	DIALOG_MYVEH,
	DIALOG_MYVEH_INFO,
	DIALOG_VMENU,
	//----[ JOB DAGING ]----
	DIALOG_DAGING,
	//---[ GUDANG SACF ]--
	GUDANG_SACF,
	PDG_GANDUM,
	PDG_GANDUM2,
	PDG_DAGING,
	PDG_DAGING2,
	PDG_SUSU,
	PDG_SUSU2,
	PDG_BIGBURGER,
	PDG_BIGBURGER2,
	PDG_ROTI,
	PDG_ROTI2,
	PDG_STEAK,
	PDG_STEAK2,
	PDG_MILK,
	PDG_MILK2,
	//-----[ BUY BAHAN FARMER ]--
	DIALOG_GANDUM_BUY,
	//---[ JOB PEMERAS SUSU ]--
	DIALOG_MILK_SELL,
	DIALOG_MILK_BUY,
	DIALOG_MILK,
	//--[ SITEM MASAK SACF]---
	DIALOG_COOKING_SACF,
	//--[ IKAN ]
	DIALOG_IKAN,
	DIALOG_IKAN_BUY,
	DIALOG_IKAN_SELL,
	//BILLING
	DIALOG_PAYBILL,
	//--[CREA GUN ]
	DIALOG_BLACKMARKET,
	DIALOG_BLACKMARKET1,
	//--------[ STREAMER OBJECT ]----
	DIALOG_STREAMER_CONFIG,
	//--[ STORAGE VEHICLE ]---
	DIALOG_VSTORAGE,
	DIALOG_VSDEPOSIT,
	DIALOG_VSTAKE,
	DIALOG_VSOPTIONS,
	DIALOG_VSTDURGS,
	DIALOG_VSTSEEDS,
	DIALOG_VSTFOODS,
	DIALOG_VSTITEMS,
	DIALOG_BAGASI,
	//---[ SHOWROOM KENDARAAN]
	DIALOG_BUY_VEHICLE,
	DIALOG_BUYPVCP,
	//Gojek
	DIALOG_GOJEK,
	DIALOG_GOPAY,
	DIALOG_GOTOPUP,
	DIALOG_GOFOOD,
	DIALOG_GOCAR,
	//--[ ROAD BLOCK ]--
	DIALOG_BARRICADE
}

//editing
enum    _:E_EDITING_TYPE {
    NOTHING = 0,
    ROADBLOCK
}

//area index
enum
{
    INVALID_AREA_INDEX = 0,
    BARRICADE_AREA_INDEX,
    FIRE_AREA_INDEX
};

// Countdown
new Count = -1;
new countTimer;
new showCD[MAX_PLAYERS];
new CountText[5][5] =
{
	"~r~1",
	"~g~2",
	"~y~3",
	"~g~4",
	"~b~5"
};

// WBR
//new File[128];

// Server Uptime
new up_days,
	up_hours,
	up_minutes,
	up_seconds,
	WorldTime = 10,
	WorldWeather = 24;

//Model Selection 
new MaleSkins = mS_INVALID_LISTID,
	FemaleSkins = mS_INVALID_LISTID,
	VIPMaleSkins = mS_INVALID_LISTID,
	VIPFemaleSkins = mS_INVALID_LISTID,
	SAPDMale = mS_INVALID_LISTID,
	SAPDFemale = mS_INVALID_LISTID,
	SAPDWar = mS_INVALID_LISTID,
	SAGSMale = mS_INVALID_LISTID,
	SAGSFemale = mS_INVALID_LISTID,
	SAMDMale = mS_INVALID_LISTID,
	SAMDFemale = mS_INVALID_LISTID,
	SANEWMale = mS_INVALID_LISTID,
	SANEWFemale = mS_INVALID_LISTID,
	SACFMale = mS_INVALID_LISTID,
	SACFFemale = mS_INVALID_LISTID,
	toyslist = mS_INVALID_LISTID,
	viptoyslist = mS_INVALID_LISTID,
	vtoyslist = mS_INVALID_LISTID;

// Showroom Vehicles
//new SRV[35],
//	VSRV[20];
	
/*// Button and Doors
new SAGSLobbyBtn[2],
	SAGSLobbyDoor;
new gMyButtons[2],
	gMyDoor;*/
	
/*//Keypad Txd
new SAGSLobbyKey[2],
	SAGSLobbyDoor;
*/

// Duty Timer

new DutyTimer;

// Yom Button
new SAGSLobbyBtn[2],
	SAGSLobbyDoor,
	SAPDLobbyBtn[4],
	SAPDLobbyDoor[4],
	LLFLobbyBtn[2],
	LLFLobbyDoor;

//ROB BANK
new RobBankObject[5],
	Text3D: RobBankText[5],
	RobBankStatus,
	RobBankProgress[MAX_PLAYERS],
	RobBankBar[MAX_PLAYERS];

//TOLL SYSTEM
new tolgate[10];

// MySQL connection handle
new MySQL: g_SQL;

new TogOOC = 1;

// Player data
enum E_PLAYERS
{
	pID,
	pVerifyCode,
	pUCP[22],
	pExtraChar,
	pChar,
	pTempPass[64],
	pName[MAX_PLAYER_NAME],
	pAdminname[MAX_PLAYER_NAME],
	pTwittername[MAX_PLAYER_NAME],
	pIP[16],
	pEmail[40],
	pAdmin,
	pHelper,
	pLevel,
	pLevelUp,
	pVip,
	pVipTime,
	pGold,
	pRegDate[50],
	pLastLogin[50],
	pMoney,
	pRedMoney,
	pGopay,
	PilihSpawn,
	Text3D:pMaskLabel,
	pBankMoney,
	pBankRek,
	pPhone,
	pPhoneCredit,
	pPhoneBook,
	pSMS,
	pCall,
	pCallTime,
	pWT,
	pHours,
	pMinutes,
	pSeconds,
	pPaycheck,
	pSkin,
	pFacSkin,
	pGender,
	pAge[50],
	pTinggi[50],
 	pBerat[50],
	pInDoor,
	pInHouse,
	pInBiz,
	pInDoorFlat,
	//FLAT
	pApartment,
	pEditFurniture,
	pEditFurnFlat,
	pEditStructure,
	pEditFlatStructure,
	pEditHouseStructure,
	pEditStaticStructure,
	pEditFurnHouse,
	//
	Float: pPosX,
	Float: pPosY,
	Float: pPosZ,
	Float: pPosA,
	Float:pPos[4],
	pInt,
	pWorld,
	Float:pHealth,
    Float:pArmour,
	pHunger,
	pBladder,
	pEnergy,
	pHungerTime,
	pEnergyTime,
	pBladderTime,
	pSick,
	pSickTime,
	pHospital,
	pHospitalTime,
	pInjured,
	pOnDuty,
	pOnDutyTime,
	pFaction,
	pFactionRank,
	pFactionLead,
	pTazer,
	pBroadcast,
	pNewsGuest,
	pFamily,
	pFamilyRank,
	pJail,
	pJailTime,
	pArrest,
	pArrestTime,
	pWarn,
	pJob,
	pJob2,
	pJobTime,
	pExitJob,
	pObatStress,
	pMedicine,
	pMedkit,
	pMask,
	pHelmet,
	pTas,
	pKacamata,
	//Makan
	pChicken,
	pSnack,
	pCappucino,
	pStarling,
	pMilxMax,
	pBurgerP,
	pPizzaP,
	//Minum
	pSprunk,
	pVodka,
	pCiu,
	pAmer,
	//
	pProgress,
	pGas,
	pBandage,
	pGPS,
	pGpsIns,
	pTwtIns,
	pAonaIns,
	pMaterial,
	pComponent,
	pFood,
	pSeed,
	pPotato,
	pWheat,
	pRoti,
	pOrange,
	pPrice1,
	pPrice2,
	pPrice3,
	pPrice4,
	pMarijuana,
	pKanabis,
	pPlant,
	pPlantTime,
	pFishTool,
	pContact,
	pWorm,
	pFish,
	pInFish,
	pIDCard,
	pIDCardTime,
	pBPJS,
	pBPJSTime,
	pSKCK,
	pSKS,
	pDriveLic,
	pDriveLicTime,
	pLumberLic,
	pLumberLicTime,
	pTruckLic,
	pTruckLicTime,
    pWeapLic,
    pWeapLicTime,
	pGuns[13],
    pAmmo[13],
	pWeapon,
	pACWarns,
	pACTime,
	//Not Save
	Cache:Cache_ID,
	bool: IsLoggedIn,
	LoginAttempts,
	LoginTimer,
	pSpawned,
	pAdminDuty,
	Text3D:pAdminLabel,
	pFreezeTimer,
	pFreeze,
	pMaskID,
	pMaskOn,
	pSPY,
	pTogPM,
	pTogLog,
	pTogAds,
	pTogWT,
	pTogVip,
	pTogReport,
	pTogAsk,
	pTogAdminchat,
	pTogSpeedcam,
	Text3D:pAdoTag,
	Text3D:pBTag,
	bool:pBActive,
	bool:pAdoActive,
	pFlare,
	bool:pFlareActive,
	pTrackCar,
	pBuyPvModel,
	pTrackHouse,
	pTrackBisnis,
	pFacInvite,
	pFacOffer,
	pFamInvite,
	pFamOffer,
	pCuffed,
	toySelected,
	bool:PurchasedToy,
	pEditingItem,
	pProductModify,
	pCurrSeconds,
	pCurrMinutes,
	pCurrHours,
	pSpec,
	playerSpectated,
	pFriskOffer,
	pDragged,
	pDraggedBy,
	pDragTimer,
	pHBEMode,
	pHelmetOn,
	pSeatBelt,
	pReportTime,
	pAskTime,
	//Player Progress Bar
	PlayerBar:fuelbar,
	PlayerBar:damagebar,
	PlayerBar:hungrybar,
	PlayerBar:energybar,
	PlayerBar:bladdybar,
	PlayerBar:spfuelbar,
	PlayerBar:spdamagebar,
	PlayerBar:sphungrybar,
	PlayerBar:spenergybar,
	PlayerBar:spbladdybar,
	PlayerBar:activitybar,
	pProducting,
	pCooking,
	pArmsDealer,
	pMechanic,
	pActivity,
	pActivityTime,
	//Jobs
	pSideJob,
	pSideJobTime,
	pGetJob,
	pGetJob2,
	pTaxiDuty,
	pTaxiTime,
	pFare,
	pFareTimer,
	pTotalFare,
	Float:pFareOldX,
	Float:pFareOldY,
	Float:pFareOldZ,
	Float:pFareNewX,
	Float:pFareNewY,
	Float:pFareNewZ,
	pMechDuty,
	pMechVeh,
	pMechColor1,
	pMechColor2,
	//ATM
	EditingATMID,
	//lumber job
	EditingTreeID,
	CuttingTreeID,
	bool:CarryingLumber,
	//production
	CarryProduct,
	//Healing
	bool:TempatHealing,
	//trucker
	pMissionBiz,
	pMissionVen,
	Float:pDistanceMission,
	pHauling,
	//Farmer
	pHarvest,
	pHarvestID,
	pOffer,
	//Bank
	pTransferText,
	pTransfer,
	pTransferRek,
	pTransferName[128],
	//Gas Station
	pFill,
	pFillTime,
	pFillPrice,
	//Gate
	gEditID,
	gEdit,
	// WBR
	pHead,
 	pPerut,
 	pLHand,
 	pRHand,
 	pLFoot,
 	pRFoot,
 	pLastStuck,
 	// Inspect Offer
 	pInsOffer,
 	// Suspect
 	pSuspectTimer,
 	pSuspect,
 	//
 	altruq,
	altruqq,
 	// Phone On Off
 	pUsePhone,
 	// Shareloc Offer
 	pLocOffer,
 	// DUTY SYSTEM
 	pDutyHour,
 	// CHECKPOINT
 	pCP,
 	// ROBBERY
 	pRobTime,
 	pRobOffer,
 	pRobLeader,
 	pRobMember,
 	pMemberRob,
 	// Roleplay Booster
 	pBooster,
 	pBoostTime,
 	pWorkshop,
	pWorkshopRank,
	pWsInvite,
	pWsOffer,
	//DEALER
	pGetRENID, //get rental id
	pGetDEID,
	pGetDEIDPRICE,
	//DRIVE SIM
	pGetSIM,
	//PIZZA LOAD
	pPizza,
	pPizzaLoad,
	pPizzaCP,
	pAccent,
	pAccent1,
	pAccent2[80],
    pTogAccent, 
	// JOB MEAT
	pMeatJob,
	pMeatProgres,
	// EDIT MAPPING ID
	EditingMAPOID, //object
	EditingMATEID, //material text
	//VENDING MACHINE
 	pGetVENID,
 	EditingVENID,
  	//SPEEDCAM
 	EditingSPEEDCAM,
 	TimerSpeedcam,
 	 //TRASH
 	EditingTRASHID,
    //REFLENISH
    pRefleBar,
    pRefleHaveBox,
    pRefleATMID,
    pRefleTotalWork,
 	pShakeOffer,
 	pShakeType,
 	//BOMB ROBBANK
 	pBomb,
 	pRepairkit,
 	pRepairTime,
 	//HAULING
 	pHaulingMission,
 	pGetDEIDHAULING,
 	//Private Farmer
 	pGetPFARM,
	pDiceOffer,
	pDiceBet,
	pDiceRigged,
	pLastBet,
	pGetPARKID,
	//CLIPPER AMMO
	pAmmoPistol,
	pAmmoSG,
	pAmmoSMG,
	pAmmoRifle,
	pSpawnList,
	//REHABILITATION
	pTdrug,
	pUseTdrug,
	pUseDrug,
	pRehab,
	pRehabTime,
	pNerfHP,
	//ROB ATM
	pRobAtmBar,
	pRobAtmProgres,
	//inv
	pGiveAmount,
	pSelectItem,
	//========[ Duty Job ]========
	bool:DutyPenambang,
	bool:DutyMinyak,
	bool:DutyPemotong,
	//PENAMBANG
	pBatu,
	pBatuCucian,
	pEmas,
	pBesi,
	pAluminium,
	pBerlian,
	//Penambang
	pTimeTambang1,
	pTimeTambang2,
	pTimeTambang3,
	pTimeTambang4,
	pTimeTambang5,
	pTimeTambang6,
	//ROBBING TIME EXPIRED
	pRobbing,
	pRobbingTime,
	pBusRoute,
	pStarterPack,
	pRedScreen,
	pBoombox,
	pGetBOOMBOXID,
	pTargetMDC[128],
	pCharStory,
	//MINER JOB
	pMinerBar,
	pMinerStatus,
	//DRUG DEALER
	pDrugDealer,
	pMethBar,
	pEphedrine,
	pCocaine,
	pMeth,
	pMuriatic,
	pFightingStyle,
	//NPCFAM
	pGetNPCFAMID,
	//FACTION VEHICLE POINT
	pGetSVPOINTID,
    pSvModelid,
    pVtoySelect,
	pGetVTOYID,
	//Payphone
	pGetPAYPHONEID,
	//Vip Setnumber
	pVipNumber,
	//Weapon Dealer
	pSmuggleMats,
	pWeaponSkill,
	pWeaponOffer,
	pWeaponidOffer,
	pWeaponAmmoOffer,
	pWeaponMatsOffer,
	pWeaponPriceOffer,
	//weapon Dealer
	pGetDamageID,
	//Ucp Account
	pUcpID,
	pUcp[MAX_PLAYER_NAME],
	pPassword[65],
	pSalt[17],
	pUcpRegister,
	pUcpPin,
	pAttemps,
	pWeaponAC,
	//INVEN
	pStorageSelect,
	pListitem,
	pTarget,
	pMaxitem,
	pStorageItem,
	//GUDANG SACF AND SISTEM SACF
	pMasak,
	pdgMenuType,
	pGandum,
	pDaging,
	pInPdg,
	//JOB BUTHER
	pDagingMentah,
	pDagingPotong,
	pDagingKemas,
	//
	pSteak,
	pMilks,
	//KLICK MAP
	pClikmap,
	//JOB PEMERAS SUSU
	pMilkJob,
	bool:pJobmilkduty,
	pMilk,
	pSusu,
	pSusuolah,
	bool:pAmbilsusu,
	//JOB TUKANG KAYU
	pTukangkayu,
	pKayu,
	pKayuPotong,
	pKayuKemas,
	bool:pApplyAnimation,
	bool:pChainsaw,
	//PENAMBANGMINYAK
	pMinyak,
	pEssence,
	//job recyler 
	pDutyBox,
	pDapatBox,
	pBox,
	pKaret,
	pBotol,
	//JOB MINER
	pMinerProgres,
	//JOB DAGINGG
	bool:pJobdagingduty,
	bool:pLoading,
	//ON DUTY ALL FRAKSI
	bool:pOndutysacf, 
	//JOB BUS
	bool:pBuswaiting,
	pBustime,
	//JON SAMPAH
	sampahsaya,
	pSampah,
	pMineral,
	pCig,
	pKuota,
	//PLAYER ID
	Text3D:pLabel,
	//AFK GEN
	Float:pAFKPos[6],
    pAFK,
    pAFKTime,
	//BLACK MARKET TIME
	pCraftingtime,
	//time
	pTimebandage,
	VehicleID,
	pBurger,
	//FISHING
	pItuna,
	pItongkol,
	pIkakap,
	pIkembung,
	pImkarel,
	pItenggiri,
	pIBmarlin,
	pIsailF,
	//JOB PETANI GEN
	pPadi,
	pCabai,
	pTebu,
	pGaramKristal,
	pBeras,
	pSambal,
	pGula,
	pGaram,
	pKarungGoni,
	pBotolBekas,
	pVehiclePetaniPadi,
    pVehiclePetaniCabai,
    pVehiclePetaniTebu,
    pVehiclePetaniGaram,
    //JOB PENJAHIT GEN
    pBulu,
    pBenang,
    pKain,
    pPakaian,
    //JOB AYAM GEN
    pPemotong,
	pPemotongStatus,
    ayamcp,
	timerambilayamhidup,
    timerpotongayam,
    timerpackagingayam,
    timerjualayam,
    AmbilAyam,
    DutyAmbilAyam,
    AyamHidup,
	AyamPotong,
	AyamFillet,
	sedangambilayam,
    sedangpotongayam,
    sedangfilletayam,
    sedangjualayam,
    //spray tag
    pEditing,
    pEditType,
    //SOPIRBUS
    pCheckPoint,
	pBus,
	pBusTime,
	pBusRute,
	pKendaraanKerja,
    //VEST DAN KEVLAR
    pVest,
    pKevlar,
    pFuelMoney,
    pFuelCar,
    //SENJATA GEN
    pGolfClub,
    pKnife,
    pShovel,
    pKatana,
    pColt45,
    pDesertEagle,
    pMicroSMG,
    pTec9,
    pMP5,
    pShotgun,
    pAK47,
    pRifle,
    pSniper,
    pClip,
    pDurability[13],
    pHoldWeapon,
	pUsedMagazine,
	//editing roadblock
	pEditingMode,
	pEditRoadblock,

};

new pData[MAX_PLAYERS][E_PLAYERS];
new g_MysqlRaceCheck[MAX_PLAYERS];
#define PlayerData pData
#define PlayerInfo PlayerData

//----------[ Lumber Object Vehicle Job ]------------
#define MAX_LUMBERS 50
#define LUMBER_LIFETIME 100
#define LUMBER_LIMIT 10

enum    E_LUMBER
{
	// temp
	lumberDroppedBy[MAX_PLAYER_NAME],
	lumberSeconds,
	lumberObjID,
	lumberTimer,
	Text3D: lumberLabel
}
new LumberData[MAX_LUMBERS][E_LUMBER],
	Iterator:Lumbers<MAX_LUMBERS>;

new
	LumberObjects[MAX_VEHICLES][LUMBER_LIMIT];
	
new
	Float: LumberAttachOffsets[LUMBER_LIMIT][4] = {
	    {-0.223, -1.089, -0.230, -90.399},
		{-0.056, -1.091, -0.230, 90.399},
		{0.116, -1.092, -0.230, -90.399},
		{0.293, -1.088, -0.230, 90.399},
		{-0.123, -1.089, -0.099, -90.399},
		{0.043, -1.090, -0.099, 90.399},
		{0.216, -1.092, -0.099, -90.399},
		{-0.033, -1.090, 0.029, -90.399},
		{0.153, -1.089, 0.029, 90.399},
		{0.066, -1.091, 0.150, -90.399}
	};

//------[ Trucker ]--------
new VehProduct[MAX_VEHICLES];
new VehGasOil[MAX_VEHICLES];

//AFK SYSTEM GEN
new afk_check[MAX_PLAYERS];
new afk_tick[MAX_PLAYERS];
new afk_time[MAX_PLAYERS];

//PETANI GEN
new petanipadi;
new petanicabai;
new petanitebu;
new petanigaram;

new PadiIndex[MAX_PLAYERS];
new bool:OnPadi[MAX_PLAYERS];
new objpadi[9][MAX_PLAYERS];

new CabaiIndex[MAX_PLAYERS];
new bool:OnCabai[MAX_PLAYERS];
new objcabai[9][MAX_PLAYERS];

new TebuIndex[MAX_PLAYERS];
new bool:OnTebu[MAX_PLAYERS];
new objtebu[9][MAX_PLAYERS];

new GaramIndex[MAX_PLAYERS];
new bool:OnGaram[MAX_PLAYERS];
new objgaram[9][MAX_PLAYERS];

//-----[ Type Checkpoint ]-----	
enum
{
	CHECKPOINT_NONE = 0,
	CHECKPOINT_DRIVELIC,
	CHECKPOINT_MISC,
	CHECKPOINT_BUS
}

//----------[ VEHICLE STORAGE]------
/*new VehMoney[MAX_VEHICLES];
new VehComponent[MAX_VEHICLES];
new VehSeed[MAX_VEHICLES];
new VehMaterial[MAX_VEHICLES];
new VehMarijuana[MAX_VEHICLES];*/
new VehRefleMoney[MAX_VEHICLES];
new TruckerVehObject[MAX_VEHICLES];

//Mech Genzo
new doorbengkel[2];

//--------[ENUM HAULING JOB]------
new VehHauling[MAX_PLAYERS];
new HaulingType[MAX_PLAYERS];

new LimitSpeed[MAX_PLAYERS];

// Faction Vehicle
#define VEHICLE_RESPAWN 7200

new adminVehicle[MAX_VEHICLES char];

enum
{
	EDIT_NONE,
	EDIT_TREE,
	EDIT_FURNITURE,
	EDIT_GATE,
	EDIT_TAG,
};

//-----[ Storage Limit ]-----	
enum
{
	LIMIT_SNACK,
	LIMIT_SPRUNK,
	LIMIT_MEDICINE,
	LIMIT_MEDKIT,
 	LIMIT_BANDAGE,
 	LIMIT_SEED,
	LIMIT_MATERIAL,
	LIMIT_COMPONENT,
	LIMIT_MARIJUANA
};

//-----[ Modular ]-----
main() 
{
	SetTimer("onlineTimer", 1000, true);
	SetTimer("TDUpdates", 8000, true);
}
#include <textdraw-streamer>
//MODULE
#include "DATA\COLOR.pwn"
#include "BUATAN\AREA.pwn"
#include "BUATAN\SHOWITEMBOX.inc"
//#include "BUATAN\ValriseReality.inc"
#include "DATA\TEXTDRAW.pwn"
#include "BUATAN\NOTIFGEN.inc"
#include "BUATAN\LOADINGPROG.inc"
#include "BUATAN\MATA.inc"
#include "DATA\ANIMS.pwn"
//#include "BUATAN\INVGEN.inc"
#include "BUATAN\INVENTORY.pwn"
#include "BUATAN\DROPITEM.inc"
#include "DATA\WEAPON_ATTH.pwn"
#include "DATA\TOYS.pwn"
#include "DATA\HELMET.pwn"
#include "DATA\SERVER.pwn"
#include "DATA\JOBPRICE.pwn"
#include "DATA\DOOR.pwn"
#include "DATA\FAMILY.pwn"
#include "BUATAN/AllTexture.inc"
#include "DATA\HOUSE.pwn"
//#include "BUATAN/Flat.pwn"
#include "DATA\BISNIS.pwn"
#include "DATA\BISNIS2.inc"
#include "DATA\GAS_STATION.pwn"
#include "DATA\DYNAMIC_LOCKER.pwn"
#include "BUATAN\WORKSHOP.pwn"
//#include "BUATAN\SprayTag.inc"
//#include "BUATAN\spraytag_dof2.pwn"
#include "DATA\NATIVE.pwn"
#include "JOB\JOB_SWEEPER.pwn"
#include "JOB\JOB_BUS.pwn"
#include "JOB\JOB_FORKLIFT.pwn"
#include "DATA\VOUCHER.pwn"
#include "DATA\SALARY.pwn"
#include "DATA\ATM.pwn"
#include "DATA\GATE.pwn"
#include "BUATAN\DEALER.pwn"
#include "BUATAN\RENTAL.pwn"
#include "DATA\PRIVATE_VEHICLE.pwn"
#include "DATA\ACTOR.pwn"
#include "BUATAN\VEHICLE_TOYS.pwn"
#include "DATA\STREAMER.pwn"
#include "DATA\SAPD_BARRICADE.pwn"

//#include "AUDIO.pwn"
//#include "ROBBERY.pwn"

//EVENT
#include "DATA\EVENT.pwn"

//ini adalah buatan
#include "BUATAN\GUDANG_PEDAGANG.pwn"
#include "BUATAN\GET_SIM.pwn"
#include "BUATAN\ACCENT.pwn"
#include "BUATAN\MAPPING.pwn"
#include "BUATAN\VENDING_MACHINE.pwn"
#include "BUATAN\ROB_BANK.pwn"
#include "BUATAN\SPEEDCAM.pwn"
#include "BUATAN\PAJAK.pwn"
#include "BUATAN\BILLS.pwn"
#include "BUATAN\PHONEBOOK.pwn"
#include "BUATAN\GARKOT.pwn"
#include "BUATAN\PAYTOLL.pwn"
#include "BUATAN\BOOMBOX.pwn"
#include "BUATAN\MDC.pwn"
#include "BUATAN\NPC_FAMILY.pwn"
#include "BUATAN\FACTION_VEHICLE.pwn"
#include "BUATAN\911CALL.pwn"
#include "BUATAN\FACTION_CALL.pwn"
#include "BUATAN\PAYPHONE.pwn"
#include "BUATAN\DAMAGE_LOG.pwn"
#include "BUATAN\ADS_LOG.pwn"
#include "BUATAN\ANTI_CHEAT.pwn"
#include "BUATAN\UCP.pwn"
#include "BUATAN\BLACK_MARKET.pwn"
#include "BUATAN\STORAGE_VEHICLE.pwn"
#include "BUATAN\VStorage.inc"
#include "BUATAN\VEH_SHOWROOM.pwn"
#include "BUATAN\FIRE_SYSTEM.pwn"
//#include "JOB\SOPIRBUS.inc"
#include "BUATAN\fuel-fivem.inc"
#include "DATA\TEXTDRAWCLICK.pwn"
#include "BUATAN\AFK.inc"
#include "BUATAN\gunreload.inc"
#include "BUATAN\tags\core.pwn"

//JOBS
#include "JOB\JOB_TAXI.pwn"
#include "JOB\JOB_MECH.pwn"
#include "JOB\JOB_LUMBER.pwn"
#include "JOB\JOB_MINER.pwn"
#include "JOB\JOB_PRODUCTION.pwn"
#include "JOB\JOB_TRUCKER.pwn"
#include "JOB\JOB_FISH.pwn"
#include "JOB\JOB_FARMER.pwn"
#include "JOB\JOB_PIZZA.pwn"
#include "JOB\JOB_LAWN_MOWER.pwn"
#include "JOB\JOB_HAULING.pwn"
#include "JOB\JOB_SMUGGLER.pwn"
#include "JOB\JOB_TRASHMASTER.pwn"
#include "JOB\JOB_REFLENISH.pwn"
#include "JOB\JOB_BUTCHER.pwn"
#include "JOB\JOB_WEAPON_DEALER.pwn"
#include "JOB\JOB_PEMERAS_SUSU.pwn"
#include "JOB\PENAMBANG.inc"
#include "JOB\TukangKayu.inc"
#include "JOB\PetaniGen.inc"
#include "JOB\PenjahitGen.inc"
#include "JOB\TukangAyam.inc"
#include "JOB\PenambangMinyak.inc"
#include "JOB\DaurUlang.inc"
#include "JOB\SOPIRBUS.inc"
#include "BUATAN\PRIVATE_FARM.pwn"
#include "BUATAN\MAPPINGSERVER.inc"
// #include "BUATAN\TahubaruGen.inc"
// #include "BUATAN\SALJU1.inc"

#include "DISCORD\DISCORD.inc"
#include "CMD\ADMIN.pwn"
#include "CMD\FACTION.pwn"
#include "CMD\PLAYER.pwn"

//#include "FACTION\SACF.pwn"

#include "DATA\REPORT.pwn"
#include "DATA\ASK.pwn"

#include "DATA\SAPD_TASER.pwn"
#include "DATA\SAPD_SPIKE.pwn"

#include "DATA\DIALOG.pwn"

#include "BUATAN\callvoice.inc"
#include "BUATAN\voicecallnya.inc"

//#include "BUATAN\gategen.inc"

#include "CMD\ALIAS\ALIAS_ADMIN.pwn"
#include "CMD\ALIAS\ALIAS_PLAYER.pwn"
#include "CMD\ALIAS\ALIAS_BISNIS.pwn"
#include "CMD\ALIAS\ALIAS_HOUSE.pwn"
#include "CMD\ALIAS\ALIAS_PRIVATE_VEHICLE.pwn"

#include "BUATAN\TASK.inc"

#include "DATA\FUNCTION.pwn"

/*forward UpdateFakeOnline();
public UpdateFakeOnline()
{
	FO_SetValue(30 + random(5));
}*/

stock GetMoney(playerid) 
{
    return pData[playerid][pMoney];
}

stock GiveMoney(playerid, amount) 
{
    pData[playerid][pMoney] += amount;
    GivePlayerMoney(playerid, amount);
    return 1;
}

stock FIXES_valstr(dest[], value, bool:pack = false)
{
    // format can't handle cellmin properly
    static const cellmin_value[] = !"-2147483648";

    if (value == cellmin)
        pack && strpack(dest, cellmin_value, 12) || strunpack(dest, cellmin_value, 12);
    else
        format(dest, 12, "%d", value) && pack && strpack(dest, dest, 12);
}
stock number_format(number)
{
	new i, string[15];
	FIXES_valstr(string, number);
	if(strfind(string, "-") != -1) i = strlen(string) - 4;
	else i = strlen(string) - 3;
	while (i >= 1)
 	{
		if(strfind(string, "-") != -1) strins(string, ",", i + 1);
		else strins(string, ",", i);
		i -= 3;
	}
	return string;
}

forward spawntw(playerid, otherid);
public spawntw(playerid, otherid)
{
	for(new i = 0; i < 10; i++)
	{
		TextDrawHideForPlayer(playerid, PDLogsDeath[i]);
		//CancelSelectTextDraw(playerid);
	}

	for(new i = 0; i < 10; i++)
	{
		TextDrawHideForPlayer(playerid, SAMDLogsDeath[i]);
		//CancelSelectTextDraw(playerid);
	}

	for(new a = 0; a < 6; a++)
	{
		PlayerTextDrawHide(playerid, notifshootgen[playerid][a]);
	}
}

//-----[ Discord Status ]-----	
function BotStatus()
{
    new statuz[256];
	format(statuz, sizeof(statuz), "%d/%d Players KONOHA ROLEPLAY", Iter_Count(Player), GetMaxPlayers());
	DCC_SetBotActivity(statuz);
}

stock HideEditTextDraw(playerid) 
{
    for (new i; i < 7; i++) 
    {
        PlayerTextDrawHide(playerid, TDEDIT[playerid][i]);
    }
    PlayerTextDrawHide(playerid, PLUSX[playerid]);
    PlayerTextDrawHide(playerid, MINX[playerid]);
    PlayerTextDrawHide(playerid, PLUSY[playerid]);
    PlayerTextDrawHide(playerid, MINY[playerid]);
    PlayerTextDrawHide(playerid, PLUSZ[playerid]);
    PlayerTextDrawHide(playerid, MINZ[playerid]);
    PlayerTextDrawHide(playerid, PLUSRX[playerid]);
    PlayerTextDrawHide(playerid, MINRX[playerid]);
    PlayerTextDrawHide(playerid, PLUSRY[playerid]);
    PlayerTextDrawHide(playerid, MINRY[playerid]);
    PlayerTextDrawHide(playerid, PLUSRZ[playerid]);
    PlayerTextDrawHide(playerid, MINRZ[playerid]);
    PlayerTextDrawHide(playerid, FINISHEDIT[playerid]);
    CancelSelectTextDraw(playerid);
    return 1;
}
stock ShowEditTextDraw(playerid) 
{
    for (new i; i < 7; i++) 
    {
        PlayerTextDrawShow(playerid, TDEDIT[playerid][i]);
    }
    PlayerTextDrawShow(playerid, PLUSX[playerid]);
    PlayerTextDrawShow(playerid, MINX[playerid]);
    PlayerTextDrawShow(playerid, PLUSY[playerid]);
    PlayerTextDrawShow(playerid, MINY[playerid]);
    PlayerTextDrawShow(playerid, PLUSZ[playerid]);
    PlayerTextDrawShow(playerid, MINZ[playerid]);
    PlayerTextDrawShow(playerid, PLUSRX[playerid]);
    PlayerTextDrawShow(playerid, MINRX[playerid]);
    PlayerTextDrawShow(playerid, PLUSRY[playerid]);
    PlayerTextDrawShow(playerid, MINRY[playerid]);
    PlayerTextDrawShow(playerid, PLUSRZ[playerid]);
    PlayerTextDrawShow(playerid, MINRZ[playerid]);
    PlayerTextDrawShow(playerid, FINISHEDIT[playerid]);
    SelectTextDraw(playerid, COLOR_YELLOW);
    return 1;
}

function HideRadial(playerid)
{
	for(new i = 0; i < 31; i++)
	{
		PlayerTextDrawHide(playerid, RADIALVALRISE[playerid][i]);
	}
}

function HideRadial1(playerid)
{
	for(new i = 0; i < 31; i++)
	{
		PlayerTextDrawHide(playerid, RADIALVALRISE[playerid][i]);
	}
	CancelSelectTextDraw(playerid);
}

stock HidePanelFull(playerid)
{
	for(new i = 0; i < 54; i++)
	{
		PlayerTextDrawHide(playerid, PR_PANELSTD[playerid][i]);
	}

	//

	for(new i = 0; i < 47; i++)
	{
		PlayerTextDrawHide(playerid, PR_DPANEL[playerid][i]);
	}

	//

	for(new i = 0; i < 29; i++)
	{
		PlayerTextDrawHide(playerid, PR_IPANEL[playerid][i]);
	}

	//

	for(new i = 0; i < 50; i++)
	{
		PlayerTextDrawHide(playerid, PR_KPANEL[playerid][i]);
	}
	TextDrawHideForPlayer(playerid, PR_KPANEL1[0]);

	//

	for(new i = 0; i < 28; i++)
	{
		PlayerTextDrawHide(playerid, PR_PPANEL[playerid][i]);
	}
	CancelSelectTextDraw(playerid);
}

stock HidePanelFullNC(playerid)
{
	for(new i = 0; i < 54; i++)
	{
		PlayerTextDrawHide(playerid, PR_PANELSTD[playerid][i]);
	}

	//

	for(new i = 0; i < 47; i++)
	{
		PlayerTextDrawHide(playerid, PR_DPANEL[playerid][i]);
	}

	//

	for(new i = 0; i < 29; i++)
	{
		PlayerTextDrawHide(playerid, PR_IPANEL[playerid][i]);
	}

	//

	for(new i = 0; i < 50; i++)
	{
		PlayerTextDrawHide(playerid, PR_KPANEL[playerid][i]);
	}
	TextDrawHideForPlayer(playerid, PR_KPANEL1[0]);

	//

	for(new i = 0; i < 28; i++)
	{
		PlayerTextDrawHide(playerid, PR_PPANEL[playerid][i]);
	}
	//CancelSelectTextDraw(playerid);
}

stock HidePanelS(playerid)
{
	for(new i = 0; i < 54; i++)
	{
		PlayerTextDrawHide(playerid, PR_PANELSTD[playerid][i]);
	}
}

stock HidePanelK(playerid)
{
	for(new i = 0; i < 50; i++)
	{
		PlayerTextDrawHide(playerid, PR_KPANEL[playerid][i]);
	}
	TextDrawHideForPlayer(playerid, PR_KPANEL1[0]);
}

stock HidePanelI(playerid)
{
	for(new i = 0; i < 29; i++)
	{
		PlayerTextDrawHide(playerid, PR_IPANEL[playerid][i]);
	}
}

stock HidePanelP(playerid)
{
	for(new i = 0; i < 28; i++)
	{
		PlayerTextDrawHide(playerid, PR_PPANEL[playerid][i]);
	}
}

stock HidePanelD(playerid)
{
	for(new i = 0; i < 47; i++)
	{
		PlayerTextDrawHide(playerid, PR_DPANEL[playerid][i]);
	}
}

stock ShowPanelS(playerid)
{
	for(new i = 0; i < 54; i++)
	{
		PlayerTextDrawShow(playerid, PR_PANELSTD[playerid][i]);
	}
}

/*forward SaveLunarSystem(playerid);
public SaveLunarSystem(playerid)
{
	format(File, sizeof(File), "[AkunPlayer]/Stats/%s.ini", pData[playerid][pName]);
	if( dini_Exists( File ) )
	{
		// WBR
        dini_IntSet(File, "Kepala", pData[playerid][pHead]);//
        dini_IntSet(File, "Perut", pData[playerid][pPerut]);
        dini_IntSet(File, "TanganKanan", pData[playerid][pRHand]);
        dini_IntSet(File, "TanganKiri", pData[playerid][pLHand]);
        dini_IntSet(File, "KakiKanan", pData[playerid][pRFoot]);
        dini_IntSet(File, "KakiKiri", pData[playerid][pLFoot]);
        // ASK
        dini_IntSet(File, "AskTime", pData[playerid][pAskTime]);
        // SUSPECT
        dini_IntSet(File, "Suspected", pData[playerid][pSuspect]);
        dini_IntSet(File, "GetLoc Timer", pData[playerid][pSuspectTimer]);
        // PHONE
        dini_IntSet(File, "Phone Status", pData[playerid][pUsePhone]);
        // KURIR
        dini_IntSet(File, "Patch Bomb", pData[playerid][pBomb]);
        // REPAIRKIT
        dini_IntSet(File, "Repairkit", pData[playerid][pRepairkit]);
        // DELAY ROB
        dini_IntSet(File, "Rob Delay", pData[playerid][pRobTime]);
        // Booster System
        dini_IntSet(File, "Boost", pData[playerid][pBooster]);
        dini_IntSet(File, "Boost Time", pData[playerid][pBoostTime]);
        dini_IntSet(File, "Accent ID", pData[playerid][pAccent]);
        dini_IntSet(File, "Clip Pistol", pData[playerid][pAmmoPistol]);
        dini_IntSet(File, "Clip SG", pData[playerid][pAmmoSG]);
        dini_IntSet(File, "Clip SMG", pData[playerid][pAmmoSMG]);
        dini_IntSet(File, "TDrug", pData[playerid][pTdrug]);
        dini_IntSet(File, "Use Drugs", pData[playerid][pUseDrug]);
        dini_IntSet(File, "StarterPack", pData[playerid][pStarterPack]);
        dini_IntSet(File, "Boombox", pData[playerid][pBoombox]);
        dini_IntSet(File, "CharacterStory", pData[playerid][pCharStory]);
        dini_IntSet(File, "Weapon Skill", pData[playerid][pWeaponSkill]);
	}
}*/

/*forward LoadLunarSystem(playerid);
public LoadLunarSystem(playerid)
{
	format( File, sizeof( File ), "[AkunPlayer]/Stats/%s.ini", pData[playerid][pName]);
    if(dini_Exists(File))//Buat load data user(dikarenakan sudah ada datanya)
    {  
    	// WBR
        pData[playerid][pHead] = dini_Int( File,"Kepala");
        pData[playerid][pPerut] = dini_Int( File,"Perut");
        pData[playerid][pRHand] = dini_Int( File,"TanganKanan");
        pData[playerid][pLHand] = dini_Int( File,"TanganKiri");
        pData[playerid][pRFoot] = dini_Int( File,"KakiKanan");
        pData[playerid][pLFoot] = dini_Int( File,"KakiKiri");
        // ASK
        pData[playerid][pAskTime] = dini_Int( File, "AskTime");
        // SUSPECT
        pData[playerid][pSuspect] = dini_Int( File, "Suspected");
        pData[playerid][pSuspectTimer] = dini_Int( File, "GetLoc Timer");
        // PHONE
        pData[playerid][pUsePhone] = dini_Int( File, "Phone Status");
        // BOMB ROB BANK
        pData[playerid][pBomb] = dini_Int( File, "Patch Bomb");
        // REPAIRKIT
        pData[playerid][pRepairkit] = dini_Int( File, "Repairkit");
        // DUTY
        pData[playerid][pDutyHour] = dini_Int(File, "Waktu Duty");
        // DELAY ROB
        pData[playerid][pRobTime] = dini_Int(File, "Rob Delay");
        // RP BOOST
        pData[playerid][pBooster] = dini_Int(File, "Boost");
        pData[playerid][pBoostTime] = dini_Int(File, "Boost Time");
        pData[playerid][pAccent] = dini_Int(File, "Accent ID");
        //CLIPPER AMMO
        pData[playerid][pAmmoPistol] = dini_Int(File, "Clip Pistol");
        pData[playerid][pAmmoSG] = dini_Int(File, "Clip SG");
        pData[playerid][pAmmoSMG] = dini_Int(File, "Clip SMG");
        //REHABILITATION
        pData[playerid][pTdrug] = dini_Int(File, "TDrug");
        pData[playerid][pUseDrug] = dini_Int(File, "Use Drugs");
        pData[playerid][pStarterPack] = dini_Int(File, "StarterPack");
        pData[playerid][pBoombox] = dini_Int(File, "Boombox");
        pData[playerid][pCharStory] = dini_Int(File, "CharacterStory");
        pData[playerid][pWeaponSkill] = dini_Int(File, "Weapon SKill");
    }
    else //Buat user baru(Bikin file buat pemain baru dafar)
    {
    	dini_Create( File );
    	// WBR
        dini_IntSet(File, "Kepala", 100);
        dini_IntSet(File, "Perut", 100);
        dini_IntSet(File, "TanganKanan", 100);
        dini_IntSet(File, "TanganKiri", 100);
        dini_IntSet(File, "KakiKanan", 100);
        dini_IntSet(File, "KakiKiri", 100);
        // ASK
        dini_IntSet(File, "AskTime", 0);
        // Suspect
        dini_IntSet(File, "Suspected", 0);
        dini_IntSet(File, "GetLoc Timer", 0);
        dini_IntSet(File, "Phone Status", 0);
        // BOMB ROB BANK
        dini_IntSet(File, "Patch Bomb", 0);
        // REPAIRKIT
        dini_IntSet(File, "Repairkit", 0);
        // DUTY
        dini_IntSet(File, "Waktu Duty", 0);
        // ROB
        dini_IntSet(File, "Rob Delay", 0);
        // Roleplay Boost
        dini_IntSet(File, "Booost", 0);
        dini_IntSet(File, "Boost Time", 0);
        dini_IntSet(File, "Accent ID", 0);
        // Clipper Ammo
        dini_IntSet(File, "Clip Pistol", 0);
        dini_IntSet(File, "Clip SG", 0);
        dini_IntSet(File, "Clip SMG", 0);
        dini_IntSet(File, "TDrug", 0);
        dini_IntSet(File, "Use Drugs", 0);
        dini_IntSet(File, "StarterPack", 0);
        dini_IntSet(File, "Boombox", 0);
        dini_IntSet(File, "CharacterStory", 0);
        dini_IntSet(File, "Weapon Skill", 0);
        pData[playerid][pHead] = dini_Int( File,"Kepala");
        pData[playerid][pPerut] = dini_Int( File,"Perut");
        pData[playerid][pRHand] = dini_Int( File,"TanganKanan");
        pData[playerid][pLHand] = dini_Int( File,"TanganKiri");
        pData[playerid][pRFoot] = dini_Int( File,"KakiKanan");
        pData[playerid][pLFoot] = dini_Int( File,"KakiKiri");
        pData[playerid][pAskTime] = dini_Int( File, "AskTime");
        pData[playerid][pSuspect] = dini_Int( File, "Suspected");
        pData[playerid][pSuspectTimer] = dini_Int( File, "GetLoc Timer");
        pData[playerid][pUsePhone] = dini_Int( File, "Phone Status");
        pData[playerid][pBomb] = dini_Int( File, "Patch Bomb");
        pData[playerid][pRepairkit] = dini_Int( File, "Repairkit");
        pData[playerid][pDutyHour] = dini_Int(File, "Waktu Duty");
        pData[playerid][pRobTime] = dini_Int(File, "Rob Delay");
        pData[playerid][pBooster] = dini_Int(File, "Boost");
        pData[playerid][pBoostTime] = dini_Int(File, "Boost Time");
        pData[playerid][pAccent] = dini_Int(File, "Accent ID");
        pData[playerid][pAmmoPistol] = dini_Int(File, "Clip Pistol");
        pData[playerid][pAmmoSG] = dini_Int(File, "Clip SG");
        pData[playerid][pAmmoSMG] = dini_Int(File, "Clip SMG");
        pData[playerid][pTdrug] = dini_Int(File, "TDrug");
        pData[playerid][pUseDrug] = dini_Int(File, "Use Drugs");
        pData[playerid][pStarterPack] = dini_Int(File, "StarterPack");
        pData[playerid][pBoombox] = dini_Int(File, "Boombox");
        pData[playerid][pCharStory] = dini_Int(File, "CharacterStory");
        pData[playerid][pWeaponSkill] = dini_Int(File, "Weapon Skill");
    }
    pData[playerid][pMemberRob] = -1;
    pData[playerid][pRobMember] = 0;
    pData[playerid][pRobLeader] = -1;
    return 1;
}*/

function Remove3DTextLabelLogsPLayer(playerid)
{
    DestroyDynamic3DTextLabel(PlayerDisconnect[playerid]);
    return 1;
}

function pilihanspawn(playerid)
{
	// new Dstring[512];
	// format(Dstring, sizeof(Dstring), "Tempat Spawn\tDetail\tLokasi\n\
	// {ffffff}%sBandara\tAnda akan spawn di bandara International\tLos Santos(LS)\n");
	// format(Dstring, sizeof(Dstring), "{ffffff}%sPelabuhan\tAnda akan spawn di Pelabuhan Kumai\tLos Santos(LS)\n", Dstring);
	// format(Dstring, sizeof(Dstring), "{ffffff}%sFaction Headquater (HQ)\tAnda akan spawn di depan bangunan faction\t-\n", Dstring);
	// format(Dstring, sizeof(Dstring), "{ffffff}%sLokasi Terakhir\tAnda akan spawn di tempat terakhir anda logout\t-\n", Dstring);
	// ShowPlayerDialog(playerid, DIALOG_SPAWNGEN, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha {FFFFFF}- Pilihan Spawn", Dstring, "Pilih", "");
    for(new i = 0; i < 13; i++)
	{
		TextDrawShowForPlayer(playerid, TDSpawnBYDAYSAMP[i]);
	}
	TextDrawShowForPlayer(playerid, SpawnBandara);
	TextDrawShowForPlayer(playerid, SpawnKapal);
	TextDrawShowForPlayer(playerid, SpawnHouse);
	TextDrawShowForPlayer(playerid, SpawnFaction);
	TextDrawShowForPlayer(playerid, SpawnLastExit);
	TextDrawShowForPlayer(playerid, TombolSpawn);
	TextDrawHideForPlayer(playerid, TDSpawnBYDAYSAMP[7]);
	TextDrawHideForPlayer(playerid, TDSpawnBYDAYSAMP[2]);
	TextDrawHideForPlayer(playerid, TombolSpawn);
	SelectTextDraw(playerid, COLOR_BLUE);

	return 1;
}
function SetPlayerCameraBehind(playerid)
{
	SetCameraBehindPlayer(playerid);
}

function SetPlayerCameraBehindAyam(playerid)
{
	SetCameraBehindPlayer(playerid);
}

public OnDiscordCommandPerformed(DCC_User:user, DCC_Channel:channel, cmdtext[], success)
{
  	if(success)
  	{
  		new username[DCC_USERNAME_SIZE], channelid[DCC_ID_SIZE];
  		DCC_GetUserName(user, username, sizeof(username));
  		DCC_GetChannelId(channel, channelid, sizeof(channelid));
		printf("[DCMD]: %s success using command '%s' in channel '%s'", username, cmdtext, channelid);
    }
    else
    {
    	new username[DCC_USERNAME_SIZE], channelid[DCC_ID_SIZE];
  		DCC_GetUserName(user, username, sizeof(username));
  		DCC_GetChannelId(channel, channelid, sizeof(channelid));
		printf("[DCMD WARNING]: %s using failed command '%s' in channel '%s'", username, cmdtext, channelid);
    }
    return 1;
}

public OnGameModeInit()
{
	SetTimer("BotStatus", 1000, true);

	//g_Discord_Cs = DCC_FindChannelById("1165268091199037511");
	
	//FO_SetMode(FO_ABSOLUTE);
	//SetTimer("UpdateFakeOnline", 1000, true);

	//mysql_log(ALL);
	new MySQLOpt: option_id = mysql_init_options();

	mysql_set_option(option_id, AUTO_RECONNECT, true);

	g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE, option_id);
	if (g_SQL == MYSQL_INVALID_HANDLE || mysql_errno(g_SQL) != 0)
	{
		print("MySQL connection failed. Server is shutting down.");
		SendRconCommand("exit");
		return 1;
	}
	print("MySQL connection is successful.");

	//Iter_Init(SprayTag);
	mysql_tquery(g_SQL, "SELECT * FROM `server`", "LoadServer");
	mysql_tquery(g_SQL, "SELECT * FROM `doors`", "LoadDoors");
	mysql_tquery(g_SQL, "SELECT * FROM `familys`", "LoadFamilys");
	mysql_tquery(g_SQL, "SELECT * FROM `houses`", "LoadHouses");
	mysql_tquery(g_SQL, "SELECT * FROM `bisnis`", "LoadBisnis");
	mysql_tquery(g_SQL, "SELECT * FROM `bisnis2`", "LoadBisnis2");
	mysql_tquery(g_SQL, "SELECT * FROM `lockers`", "LoadLockers");
	mysql_tquery(g_SQL, "SELECT * FROM `gstations`", "LoadGStations");
	mysql_tquery(g_SQL, "SELECT * FROM `atms`", "LoadATM");
	mysql_tquery(g_SQL, "SELECT * FROM `gates`", "LoadGates");
	mysql_tquery(g_SQL, "SELECT * FROM `vouchers`", "LoadVouchers");
	mysql_tquery(g_SQL, "SELECT * FROM `trees`", "LoadTrees");
	mysql_tquery(g_SQL, "SELECT * FROM `plants`", "LoadPlants");
	mysql_tquery(g_SQL, "SELECT * FROM `workshop`", "LoadWorkshop");
	mysql_tquery(g_SQL, "SELECT * FROM `dealer`", "LoadDealer");
	mysql_tquery(g_SQL, "SELECT * FROM `mappingingame`", "LoadMAPO");
	mysql_tquery(g_SQL, "SELECT * FROM `matext`", "LoadMatext");
	mysql_tquery(g_SQL, "SELECT * FROM `vendingmachine`", "LoadVending");
	mysql_tquery(g_SQL, "SELECT * FROM `speedcam`", "LoadSpeedcam");
	mysql_tquery(g_SQL, "SELECT * FROM `trashmaster`", "LoadTrash");
	mysql_tquery(g_SQL, "SELECT * FROM `actors`", "LoadActor");
	mysql_tquery(g_SQL, "SELECT * FROM `privatefarm`", "LoadPfarm");
	mysql_tquery(g_SQL, "SELECT * FROM `rental`", "LoadRental");
	mysql_tquery(g_SQL, "SELECT * FROM `garkot`", "LoadGarkot");
	mysql_tquery(g_SQL, "SELECT * FROM `sigenal`", "LoadSignal");
	mysql_tquery(g_SQL, "SELECT * FROM `jobprice`", "LoadJobPrice");
	mysql_tquery(g_SQL, "SELECT * FROM `npcfamily`", "LoadNpcfam");
	mysql_tquery(g_SQL, "SELECT * FROM `faction_vehpoint`", "LoadSvpoint");
	mysql_tquery(g_SQL, "SELECT * FROM `payphone`", "LoadPayphone");
	mysql_tquery(g_SQL, "SELECT * FROM `pedagang`", "LoadPedagang");
	mysql_tquery(g_SQL, "SELECT * FROM `911calls`", "Emergency_Load", "");
	mysql_tquery(g_SQL, "SELECT * FROM `bill`", "LoadBill");
	mysql_tquery(g_SQL, "SELECT * FROM `carstorage`", "VehicleInventoryLoaded");
	//mysql_tquery(g_SQL, "SELECT * FROM `tags`", "Tag_Load", "");
	mysql_tquery(g_SQL, "SELECT * FROM `dropped`", "Dropped_Load", "");
	//mysql_tquery(g_SQL, "SELECT * FROM `fire`", "Fire_Load");
	//mysql_tquery(g_SQL, "SELECT * FROM `flat`", "Flat_Load");
  	//mysql_tquery(g_SQL, "SELECT * FROM `flatroom`", "FlatRoom_Load");
  	mysql_tquery(g_SQL, "SELECT * FROM `tags` ORDER BY `tagId` ASC LIMIT "#MAX_DYNAMIC_TAGS";", "Tags_Load", "");
	
	CreateTextDraw();
	CreateGetPizza();
	CreateServerPoint();
	CreateGetSimPoint();
	CreateReflenishPickup();
	CreatePaytollAreaid();
	LoadMaps();
	LoadAreaJob(); 

	//JOB
	CreateJoinProductionPoint();
	CreateJoinMiner();
	CreateJoinDrugDealer();
	CreateJoinWeaponDealer();

	LoadTazerSAPD();
	RefreshTopTen();
	//MappingFlat();
	//SetupPlayerTable();
	
	new gm[32];
	format(gm, sizeof(gm), "%s", TEXT_GAMEMODE);
	SetGameModeText(gm);
	format(gm, sizeof(gm), "weburl %s", TEXT_WEBURL);
	SendRconCommand(gm);
	format(gm, sizeof(gm), "language %s", TEXT_LANGUAGE);
	SendRconCommand(gm);
	SendRconCommand("mapname San Andreas");
	ManualVehicleEngineAndLights();
	EnableStuntBonusForAll(0);
	AllowInteriorWeapons(1);
	DisableInteriorEnterExits();
	LimitPlayerMarkerRadius(15.0);
	//SetNameTagDrawDistance(20.0);
	SetNameTagDrawDistance(1.0);
	ShowNameTags(0);
	//ShowNameTags(1);
	//DisableNameTagLOS();
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	SetWorldTime(WorldTime);
	SetWeather(WorldWeather);
	BlockGarages(.text="NO ENTER");
	//Audio_SetPack("default_pack");
	
	MaleSkins = LoadModelSelectionMenu("maleskin.txt");
	FemaleSkins = LoadModelSelectionMenu("femaleskin.txt");
	VIPMaleSkins = LoadModelSelectionMenu("maleskin.txt");
	VIPFemaleSkins = LoadModelSelectionMenu("femaleskin.txt");
	SAPDMale = LoadModelSelectionMenu("sapdmale.txt");
	SAPDFemale = LoadModelSelectionMenu("sapdfemale.txt");
	SAPDWar = LoadModelSelectionMenu("sapdwar.txt");
	SAGSMale = LoadModelSelectionMenu("sagsmale.txt");
	SAGSFemale = LoadModelSelectionMenu("sagsfemale.txt");
	SAMDMale = LoadModelSelectionMenu("samdmale.txt");
	SAMDFemale = LoadModelSelectionMenu("samdfemale.txt");
	SANEWMale = LoadModelSelectionMenu("sanewmale.txt");
	SANEWFemale = LoadModelSelectionMenu("sanewfemale.txt");
	SACFMale = LoadModelSelectionMenu("sacfmale.txt");
	SACFFemale = LoadModelSelectionMenu("sacffemale.txt");
	toyslist = LoadModelSelectionMenu("toys.txt");
	viptoyslist = LoadModelSelectionMenu("viptoys.txt");
	vtoyslist = LoadModelSelectionMenu("vehicletoys.txt");

    //DAUR ULANG
    mulaikerja = CreateDynamicCP(-920.0016,-468.0568,826.8417, 1.0, -1, -1, -1, 20.0);
	ambilbox = CreateDynamicCP(-887.2399,-479.9101,826.8417, 1.0, -1, -1, -1, 20.0);
	ambilbox1 = CreateDynamicCP(-893.2037,-490.6880,826.8417, 1.0, -1, -1, -1, 20.0);
	ambilbox2 = CreateDynamicCP(-898.6295,-500.8337,826.8417, 1.0, -1, -1, -1, 20.0);
	jualdaurulang = CreateDynamicCP(303.7292,-239.4889,1.5781, 1.0, -1, -1, -1, 20.0);
	daurulangnya1 = CreateDynamicCP(34.4547,1365.0729,9.1719, 1.0, -1, -1, -1, 20.0);
	daurulang2 = CreateDynamicCP(34.9240,1379.4988,9.1719, 1.0, -1, -1, -1, 20.0);
	daurulang3 = CreateDynamicCP(34.9276,1351.1335,9.1719, 1.0, -1, -1, -1, 20.0); //-927.1517,-486.4165,826.8417
	nyortir1 = CreateDynamicCP(-927.1517,-486.4165,826.8417, 1.0, -1, -1, -1, 20.0);
	nyortir2 = CreateDynamicCP(-926.8005,-471.0959,826.8417, 1.0, -1, -1, -1, 20.0);
	nyortir3 = CreateDynamicCP(-926.9293,-500.5975,826.8417, 1.0, -1, -1, -1, 20.0);

	new strings[258];

	format(strings, sizeof(strings), ""LG_E"HERE");
	CreateDynamic3DTextLabel(strings, COLOR_WHITE, -920.0016,-468.0568,826.8417, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	format(strings, sizeof(strings), ""LG_E"HERE");
	CreateDynamic3DTextLabel(strings, COLOR_WHITE, -887.2399,-479.9101,826.8417, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	format(strings, sizeof(strings), ""LG_E"HERE");
	CreateDynamic3DTextLabel(strings, COLOR_WHITE, -893.2037,-490.6880,826.8417, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	format(strings, sizeof(strings), ""LG_E"HERE");
	CreateDynamic3DTextLabel(strings, COLOR_WHITE, -898.6295,-500.8337,826.8417, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	//nyortirss
	format(strings, sizeof(strings), ""LG_E"HERE");
	CreateDynamic3DTextLabel(strings, COLOR_WHITE, -927.1517,-486.4165,826.8417, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	format(strings, sizeof(strings), ""LG_E"HERE");
	CreateDynamic3DTextLabel(strings, COLOR_WHITE, -926.8005,-471.0959,826.8417, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	format(strings, sizeof(strings), ""LG_E"HERE");
	CreateDynamic3DTextLabel(strings, COLOR_WHITE, -926.9293,-500.5975,826.8417, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	format(strings, sizeof(strings), "Tekan "LG_E"Y {ffffff}Untuk Membeli Minuman");
	CreateDynamic3DTextLabel(strings, COLOR_WHITE, 2073.2756,2350.9692,-89.1698, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	//Pedagang
	format(strings, sizeof(strings), "Tekan "LG_E"Y {ffffff}Untuk Memasak");
	CreateDynamic3DTextLabel(strings, COLOR_WHITE, 1200.3564,-890.8854,44.2015, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	format(strings, sizeof(strings), "{FFFFFF}[{00FF00}ALT{FFFFFF}] Untuk Mengakses Loker");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 1806.4253,-2022.3940,13.5735, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	CreateDynamicPickup(1239, 23, -77.4220,-1136.6021,1.0781, -1);
	format(strings, sizeof(strings), "[Veh Insurance]\n{FFFFFF}/sellpv - {FFFF00}sell vehicle\n{FFFFFF}/buyinsu - {FFFF00}buy insurance\n{FFFFFF}/claimpv - {FFFF00}claim insurance\n{FFFFFF}/unrentpv - {FFFF00}unrent you rent vehicle");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, -77.4220,-1136.6021,1.0781, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Veh insurance

	//CreateDynamicPickup(1239, 23, 1530.5677,-2159.5037,13.6593, -1);
	//format(strings, sizeof(strings), "[Veh Insurance]\n{FFFFFF}/sellpv - sell vehicle\n/buyinsu - buy insurance\n/claimpv - claim insurance\n/unrentpv - unrent you rent vehicle");
	//CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 1530.5677,-2159.5037,13.6593, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Veh insurance
	
	CreateDynamicPickup(1239, 23, 1579.78, -1632.09, 13.38, -1);
	format(strings, sizeof(strings), "[PLATE MAKER]\n{FFFFFF}/createplate - create new plate to vehicle");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1579.78, -1632.09, 13.38, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Plate
	
	CreateDynamicPickup(1247, 23, 1529.44, -1683.79, 5.89, -1);
	format(strings, sizeof(strings), "[ARREST POINT]\n{FFFFFF}/arrest - arrest wanted player");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 1529.44, -1683.79, 5.89, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // arrest
	
	CreateDynamicPickup(1240, 23, 1176.40, -1308.37, 13.96, -1);
	format(strings, sizeof(strings), "[Hospital]\n{FFFFFF}/dropinjured");
	CreateDynamic3DTextLabel(strings, COLOR_PINK, 1176.40, -1308.37, 13.96, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // hospital
	
	CreateDynamicPickup(1239, 23, -982.49, 1448.46, 1340.62, -1);
	format(strings, sizeof(strings), "[BANK]\n{FFFFFF}/newrek - create new rekening");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, -982.49, 1448.46, 1340.62, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // bank
	
	CreateDynamicPickup(1239, 23, -983.95, 1448.46, 1340.62, -1);
	format(strings, sizeof(strings), "[BANK]\n"LG_E"ALT {FFFFFF}- access rekening");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, -983.95, 1448.46, 1340.62, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // bank
	
	CreateDynamicPickup(1239, 23, 2360.01, -284.87, 1303.75, -1);
	format(strings, sizeof(strings), "[IKLAN]\n{FFFFFF}/ads - public ads");
	CreateDynamic3DTextLabel(strings, COLOR_ORANGE2, 2360.01, -284.87, 1303.75, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // iklan

	CreateDynamicPickup(1239, 23, 250.3115,118.5369,1003.2188, -1);
	format(strings, sizeof(strings), "[Truck License]\n{FFFFFF}/newtrucklic - create new license");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 250.3115,118.5369,1003.2188, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // truck Lic

	CreateDynamicPickup(1239, 23, 242.1874,118.5328,1003.2188, -1);
	format(strings, sizeof(strings), "[Lumber Jack License]\n{FFFFFF}/newlumberlic - create new license");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 242.1874,118.5328,1003.2188, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Lumber Lic
	
	//MDC POLICE DEPARTEMENT
	CreateDynamicPickup(1239, 23, 234.44, 111.30, 1003.22, -1);
	format(strings, sizeof(strings), "[MDC]\n{FFFFFF}/pmdc - for check mdc information");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 234.44, 111.30, 1003.22, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Police MDC

	//MDC POLICE DEPARTEMENT
	CreateDynamicPickup(1239, 23, 2872.5708,1236.8047,-64.3797, -1, 4);
	format(strings, sizeof(strings), "[MDC]\n{FFFFFF}/emdc - for check mdc information");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 2872.5708,1236.8047,-64.3797, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Repairkit
	
	//MEKANIK CITY
	CreateDynamicPickup(1239, 23, 1786.0319,-2026.6844,13.5820, -1);
	format(strings, sizeof(strings), "[REPAIRKIT MAKER]\n{FFFFFF}/createrkit - for create repairkit");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1786.0319,-2026.6844,13.5820, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Repairkit

	//Modshop
	CreateDynamicPickup(1274, 23, 1790.4084,-2025.6746,13.5735, -1);
	format(strings, sizeof(strings), "[MODSHOP POINT]\n{FFFFFF}/buyvtoys - to buy vehicle toys");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1790.4084,-2025.6746,13.5735, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Modshop

	CreateDynamicPickup(1239, 23, 1143.3352,-1334.4344,13.6113, -1);
	format(strings, sizeof(strings), "[REHABILITATION POINT]\n{FFFFFF}/rehab - to provide a period of rehabilitation");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1143.3352,-1334.4344,13.6113, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Rehabilitation

	//THROW GARBAGE
	CreateDynamicPickup(1239, 23, 2436.29, -2113.88, 13.54, -1);
	format(strings, sizeof(strings), "[GARBAGE DUMP]\n{FFFFFF}/throwgarbage - to take out the trash");
	CreateDynamic3DTextLabel(strings, COLOR_GREEN, 2436.29, -2113.88, 13.54+0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ID Card

	// Jobs - Penjahit
	CreateDynamic3DTextLabel("{FFFFFF}Tekan "LG_E"[ALT] {FFFFFF}untuk membuat benang", -1, 1761.4487, -1763.1624, 15.0254, 10.0);
	CreateDynamic3DTextLabel("{FFFFFF}Tekan "LG_E"[ALT] {FFFFFF}untuk membuat benang", -1, 1756.2449, -1763.2015, 15.0254, 10.0);

	CreateDynamic3DTextLabel("{FFFFFF}Tekan "LG_E"[ALT] {FFFFFF}untuk membuat kain", -1, 1776.4194, -1767.3145, 15.0254, 10.0);
	CreateDynamic3DTextLabel("{FFFFFF}Tekan "LG_E"[ALT] {FFFFFF}untuk membuat kain", -1, 1766.7698, -1767.3145, 15.0254, 10.0);
	CreateDynamic3DTextLabel("{FFFFFF}Tekan "LG_E"[ALT] {FFFFFF}untuk membuat kain", -1, 1757.9785, -1767.3145, 15.0254, 10.0);

	CreateDynamic3DTextLabel("{FFFFFF}Tekan "LG_E"[ALT] {FFFFFF}untuk menjahit pakaian", -1, 1776.3232, -1776.6011, 15.0254, 10.0);
	CreateDynamic3DTextLabel("{FFFFFF}Tekan "LG_E"[ALT] {FFFFFF}untuk menjahit pakaian", -1, 1766.6154, -1776.6011, 15.0254, 10.0);
	CreateDynamic3DTextLabel("{FFFFFF}Tekan "LG_E"[ALT] {FFFFFF}untuk menjahit pakaian", -1, 1757.6498, -1776.6011, 15.0254, 10.0);

	//Kompensasi = CreateDynamicCP(2754.2625,-2404.3352,29.1975, 1.0, -1, -1, -1, 20.0);
	//Disnaker = CreateDynamicCP(2754.2625,-2404.3352,29.1975, 1.0, -1, -1, -1, 20.0);
	PenjualanBarang = CreateDynamicSphere(2357.3823,-1990.5114,13.5469, 2.0, 0, 0);
	Healing = CreateDynamicSphere(337.7135,-1828.9254,5.0171, 30.0, 0, 0);
	
	//Penjahit
	buatbenang[0] = CreateDynamicSphere(1761.4487, -1763.1624, 15.0254, 2.0, 0, 0);
	buatbenang[1] = CreateDynamicSphere(1756.2449, -1763.2015, 15.0254, 2.0, 0, 0);
	buatkain[0] = CreateDynamicSphere(1776.4194, -1767.3145, 15.0254, 2.0, 0, 0);
	buatkain[1] = CreateDynamicSphere(1766.7698, -1767.3145, 15.0254, 2.0, 0, 0);
	buatkain[2] = CreateDynamicSphere(1757.9785, -1767.3145, 15.025, 2.0, 0, 0);
	buatpakaian[0] = CreateDynamicSphere(1776.3232, -1776.6011, 15.0254, 2.0, 0, 0);
	buatpakaian[1] = CreateDynamicSphere(1766.6154, -1776.6011, 15.0254, 2.0, 0, 0);
	buatpakaian[2] = CreateDynamicSphere(1757.6498, -1776.6011, 15.0254, 2.0, 0, 0);

	//Petani gen
	petanipadi = CreateDynamicCP(-74.0760, 57.0568, 3.0800, 3.0, -1, -1, -1, 5.0);
	petanicabai = CreateDynamicCP(-75.3248, 53.7628, 3.1172, 3.0, -1, -1, -1, 5.0);
	petanitebu = CreateDynamicCP(-76.6268, 50.6978, 3.1172, 3.0, -1, -1, -1, 5.0);
	petanigaram = CreateDynamicCP(-77.9245, 47.7253, 3.1172, 3.0, -1, -1, -1, 5.0);

	//tmpobjid = CreateDynamicObjectEx(11313, 1786.853637, -2050.664550, 14.541879, -0.000001, 0.000000, 90.000000, 300.00, 300.00);  
	//tmpobjid = CreateDynamicObjectEx(11313, 1808.145507, -2050.664550, 14.471884, -0.000003, 0.000000, 90.000000, 300.00, 300.00); 

	//door buka tutup
	doorbengkel[0] = CreateDynamicObjectEx(11313, 1786.853637, -2050.664550, 14.541879, -0.000001, 0.000000, 90.000000, 300.00, 300.00);
	doorbengkel[1] = CreateDynamicObjectEx(11313, 1808.145507, -2050.664550, 14.471884, -0.000003, 0.000000, 90.000000, 300.00, 300.00);

	//Rob Bank Object
	RobBankObject[1] = CreateDynamicObject(2634, -990.080994, 1468.404053, 1332.555054, 0.000000, 0.000000, 90.000000);

	SAGSLobbyBtn[0] = CreateButton(1388.987670, -25.291969, 1001.358520, 180.000000);
	SAGSLobbyBtn[1] = CreateButton(1391.275756, -25.481920, 1001.358520, 0.000000);
	SAGSLobbyDoor = CreateDynamicObject(1569, 1389.375000, -25.387500, 999.978210, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	
	SAPDLobbyBtn[0] = CreateButton(252.95264, 107.67332, 1004.00909, 264.79898);
	SAPDLobbyBtn[1] = CreateButton(253.43437, 110.62970, 1003.92737, 91.00000);
	SAPDLobbyDoor[0] = CreateDynamicObject(1569, 253.10965, 107.61060, 1002.21368,   0.00000, 0.00000, 91.00000);
	SAPDLobbyDoor[1] = CreateDynamicObject(1569, 253.12556, 110.49657, 1002.21460,   0.00000, 0.00000, -91.00000);

	SAPDLobbyBtn[2] = CreateButton(239.82739, 116.12640, 1004.00238, 91.00000);
	SAPDLobbyBtn[3] = CreateButton(238.75888, 116.12949, 1003.94086, 185.00000);
	SAPDLobbyDoor[2] = CreateDynamicObject(1569, 239.69435, 116.15908, 1002.21411,   0.00000, 0.00000, 91.00000);
	SAPDLobbyDoor[3] = CreateDynamicObject(1569, 239.64050, 119.08750, 1002.21332,   0.00000, 0.00000, 270.00000);
	
	//Family Button
	LLFLobbyBtn[0] = CreateButton(-2119.90039, 655.96808, 1062.39954, 184.67528);
	LLFLobbyBtn[1] = CreateButton(-2119.18481, 657.88519, 1062.39954, 90.00000);
	LLFLobbyDoor = CreateDynamicObject(1569, -2119.21509, 657.54187, 1060.73560,   0.00000, 0.00000, -90.00000);
	
	//TOL LV
	tolgate[0] = CreateDynamicObject(968, 1807.947021, 821.503417, 10.610667, 0.000000, 89.899971, 0.000000, -1, -1, -1, 200.00, 200.00); //TOLL LV1 23
	tolgate[1] = CreateDynamicObject(968, 1805.447753, 821.524658, 10.560406, 0.000000, -90.299957, -0.000000, -1, -1, -1, 200.00, 200.00); //TOL LV2 25
	tolgate[2] = CreateDynamicObject(968, 1788.649291, 803.113159, 10.900191, 0.000000, 90.299942, -0.099992, -1, -1, -1, 200.00, 200.00); //TOLL LV3 28
	tolgate[3] = CreateDynamicObject(968, 1787.745727, 803.114807, 10.881714, 0.000000, -90.299926, 0.000000, -1, -1, -1, 200.00, 200.00); //TOLL LV4 29

	//TOL FLINT
	tolgate[4] = CreateDynamicObject(968, 41.159236, -1526.555419, 5.092908, 0.000000, 89.999961, 80.200096, -1, -1, -1, 200.00, 200.00); //TOLL FLINT1 92
	tolgate[5] = CreateDynamicObject(968, 65.120658, -1536.429077, 4.809195, 0.000000, -90.199958, 82.400070, -1, -1, -1, 200.00, 200.00); //TOLL FLINT2 91

	//TOL RED BRIDGE
	tolgate[6] = CreateDynamicObject(968, -165.864074, 374.415924, 11.875398, 0.000000, -89.999954, 163.700042, -1, -1, -1, 200.00, 200.00); //TOLL RED BRIDGE1 112
	tolgate[7] = CreateDynamicObject(968, -172.951614, 349.509979, 11.878129, 0.000000, -89.999961, -15.499999, -1, -1, -1, 200.00, 200.00); //TOLL RED BRIDGE2 109

	//TOL GREY BRIDGE
	tolgate[8] = CreateDynamicObject(968, 509.552917, 488.096923, 18.707580, 0.000000, -89.800018, -144.800003, -1, -1, -1, 200.00, 200.00); //TOLL GREY BRIDGE 122
	tolgate[9] = CreateDynamicObject(968, 524.426269, 467.211395, 18.679878, 0.000000, -89.800010, 35.199996, -1, -1, -1, 200.00, 200.00); //TOLL GREY BRIDGE 121

	//Sidejob Vehicle
	AddSweeperVehicle();
	AddBusVehicle();
	AddForVehicle();
	AddTruckerVehicle();
	AddPizzaVehicle();
	AddTaxiVehicle();
	AddDriveSimVehicle();
	AddRumputVehicle();
	AddTrashVehicle();
	AddvehShowroom();

	printf("[Object] Number of Dynamic objects loaded: %d", CountDynamicObjects());

	new DCC_Channel:hidupp, DCC_Embed:logss;
	new yy, m, d, timestamp[200];
	getdate(yy, m , d);
	hidupp = DCC_FindChannelById("1165268029744087061");

	format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d);
	logss = DCC_CreateEmbed("Valrise Reality Roleplay");
	DCC_SetEmbedTitle(logss, "Konoha Roleplay | #OneOnly");
	DCC_SetEmbedTimestamp(logss, timestamp);
	DCC_SetEmbedColor(logss, 0x00ff00);
	DCC_SetEmbedUrl(logss, "https://media.discordapp.net/attachments/1165268082554581033/1165655296102899794/360_F_366360587_4KeY8GHvFbdCZSVVLbE52IVaztoqhb6c.jpg?ex=6547a417&is=65352f17&hm=c30cb540eeeee26e32e99b389d5133a6f5d93759a4196065c927ac0dafb68617&=");
	DCC_SetEmbedThumbnail(logss, "https://media.discordapp.net/attachments/1165268082554581033/1165655296102899794/360_F_366360587_4KeY8GHvFbdCZSVVLbE52IVaztoqhb6c.jpg?ex=6547a417&is=65352f17&hm=c30cb540eeeee26e32e99b389d5133a6f5d93759a4196065c927ac0dafb68617&=");
	DCC_SetEmbedFooter(logss, "Konoha Roleplay | #OneOnly", "");
	new stroi[5000];
	format(stroi, sizeof(stroi), "> Server Valrise Reality telah mengudara, para penduduk yang telah memiliki UCP dipersilakan memasuki Kota Valrise Reality\n> Server update <#1165268021800083477>\n\n> IP server <#1165268025440743444>\nDihimbau semua penduduk untuk membaca:\n<#1165268054926700594>\n\n> Punya saran & kritik? <#1165268045434990663>\n> Mengalami kesulitan? <#1165268053676806214>\n> Mendapatkan bug? <#1165268042368958546>");
	DCC_AddEmbedField(logss, "BMKG VALRISE REALITY", stroi, true);
	DCC_SendChannelEmbedMessage(hidupp, logss);
	return 1;
}

public OnGameModeExit()
{
	new count = 0, count1 = 0;
	foreach(new gsid : GStation)
	{
		if(Iter_Contains(GStation, gsid))
		{
			count++;
			GStation_Save(gsid);
		}
	}
	printf("[Gas Station] Number of Saved: %d", count);
	
	foreach(new pid : Plants)
	{
		if(Iter_Contains(Plants, pid))
		{
			count1++;
			Plant_Save(pid);
		}
	}
	printf("[Farmer Plant] Number of Saved: %d", count1);
	for (new i = 0, j = GetPlayerPoolSize(); i <= j; i++) 
	{
		if (IsPlayerConnected(i))
		{
			OnPlayerDisconnect(i, 1);
		}
	}
	UnloadTazerSAPD();
	//Audio_DestroyTCPServer();
	mysql_close(g_SQL);
	return 1;
}

function SAGSLobbyDoorClose()
{
	MoveDynamicObject(SAGSLobbyDoor, 1389.375000, -25.387500, 999.978210, 3);
	return 1;
}

function SAPDLobbyDoorClose()
{
	MoveDynamicObject(SAPDLobbyDoor[0], 253.10965, 107.61060, 1002.21368, 3);
	MoveDynamicObject(SAPDLobbyDoor[1], 253.12556, 110.49657, 1002.21460, 3);
	MoveDynamicObject(SAPDLobbyDoor[2], 239.69435, 116.15908, 1002.21411, 3);
	MoveDynamicObject(SAPDLobbyDoor[3], 239.64050, 119.08750, 1002.21332, 3);
	return 1;
}

function LLFLobbyDoorClose()
{
	MoveDynamicObject(LLFLobbyDoor, -2119.21509, 657.54187, 1060.73560, 3);
	return 1;
}

public OnPlayerPressButton(playerid, buttonid)
{
	if(buttonid == SAGSLobbyBtn[0] || buttonid == SAGSLobbyBtn[1])
	{
	    if(pData[playerid][pFaction] == 2)
	    {
	        MoveDynamicObject(SAGSLobbyDoor, 1387.9232, -25.3887, 999.9782, 3);
			SetTimer("SAGSLobbyDoorClose", 5000, 0);
	    }
		else
	    {
	        Error(playerid, "Akses ditolak.");
			return 1;
		}
	}
	if(buttonid == SAPDLobbyBtn[0] || buttonid == SAPDLobbyBtn[1])
	{
		if(pData[playerid][pFaction] == 1)
		{
			MoveDynamicObject(SAPDLobbyDoor[0], 253.14204, 106.60210, 1002.21368, 3);
			MoveDynamicObject(SAPDLobbyDoor[1], 253.24377, 111.94370, 1002.21460, 3);
			SetTimer("SAPDLobbyDoorClose", 5000, 0);
		}
		else
	    {
	        Error(playerid, "Akses ditolak.");
			return 1;
		}
	}
	if(buttonid == SAPDLobbyBtn[2] || buttonid == SAPDLobbyBtn[3])
	{
		if(pData[playerid][pFaction] == 1)
		{
			MoveDynamicObject(SAPDLobbyDoor[2], 239.52385, 114.75534, 1002.21411, 3);
			MoveDynamicObject(SAPDLobbyDoor[3], 239.71977, 120.21591, 1002.21332, 3);
			SetTimer("SAPDLobbyDoorClose", 5000, 0);
		}
		else
	    {
	        Error(playerid, "Akses ditolak.");
			return 1;
		}
	}
	if(buttonid == LLFLobbyBtn[0] || buttonid == LLFLobbyBtn[1])
	{
		if(pData[playerid][pFamily] == 0)
		{
			MoveDynamicObject(LLFLobbyDoor, -2119.27148, 656.04028, 1060.73560, 3);
			SetTimer("LLFLobbyDoorClose", 5000, 0);
		}
		else
		{
			Error(playerid, "Akses ditolak.");
			return 1;
		}
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(vehicleid == pData[playerid][pKendaraanKerja])
	{
        KillTimer(KeluarKerja[playerid]);
        TimerKeluar[playerid] = 0;
    }
	if(!ispassenger)
	{
		if(IsSAPDCar(vehicleid))
        {
        	if(pData[playerid][pFaction] != 1)
        	{
	            RemovePlayerFromVehicle(playerid);
	            new Float:slx, Float:sly, Float:slz;
	            GetPlayerPos(playerid, slx, sly, slz);
	            SetPlayerPos(playerid, slx, sly, slz);
	            Error(playerid, "Kamu bukan anggota fraksi SAPD!");
	   		}
        }
		if(IsSAGSCar(vehicleid))
        {
        	if(pData[playerid][pFaction] != 2)
        	{
	            RemovePlayerFromVehicle(playerid);
	            new Float:slx, Float:sly, Float:slz;
	            GetPlayerPos(playerid, slx, sly, slz);
	            SetPlayerPos(playerid, slx, sly, slz);
	            Error(playerid, "Kamu bukan anggota fraksi SAGS!");
	   		}
        }
		if(IsSAMDCar(vehicleid))
        {
        	if(pData[playerid][pFaction] != 3)
        	{
	            RemovePlayerFromVehicle(playerid);
	            new Float:slx, Float:sly, Float:slz;
	            GetPlayerPos(playerid, slx, sly, slz);
	            SetPlayerPos(playerid, slx, sly, slz);
	            Error(playerid, "Kamu bukan anggota fraksi SAMD!");
	   		}
        }
		if(IsSANACar(vehicleid))
        {
        	if(pData[playerid][pFaction] != 4)
        	{
	            RemovePlayerFromVehicle(playerid);
	            new Float:slx, Float:sly, Float:slz;
	            GetPlayerPos(playerid, slx, sly, slz);
	            SetPlayerPos(playerid, slx, sly, slz);
	            Error(playerid, "Kamu bukan anggota fraksi SANA!");
	   		}
        }
		if(IsDRIVESIMCar(vehicleid))
		{
		    if(pData[playerid][pGetSIM] != 1)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Kamu tidak memiliki izin!");
			}
		}
		if(IsShowroomCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 6)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Kamu tidak memiliki izin!");
			}
		}
		if(IsAPizzaVeh(vehicleid))
		{
		    if(pData[playerid][pJob] == 9 || pData[playerid][pJob2] == 9)
			{
				Info(playerid, "Mari memulai pekerjaan pizzamu");
			}
			else
			{
				RemovePlayerFromVehicle(playerid);
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
				Error(playerid, "Kamu bukan pekerja pizza!");
			}
		}
		if(IsATruckerVeh(vehicleid))
		{
		    if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
			{
				//Info(playerid, "Mari memulai pekerjaan trucker");
			}
			else
			{
				RemovePlayerFromVehicle(playerid);
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
				Error(playerid, "Kamu bukan pekerja trucker!");
			}
		}
		if(IsATaxiVeh(vehicleid))
		{
		    if(pData[playerid][pJob] == 1 || pData[playerid][pJob2] == 1)
			{
				//Info(playerid, "Mari memulai pekerjaan trucker");
			}
			else
			{
				RemovePlayerFromVehicle(playerid);
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
				Error(playerid, "Kamu bukan pekerja Taxi!");
			}
		}
		if(GetVehicleModel(vehicleid) == 548 || GetVehicleModel(vehicleid) == 417 || GetVehicleModel(vehicleid) == 487 || GetVehicleModel(vehicleid) == 488 ||
		GetVehicleModel(vehicleid) == 497 || GetVehicleModel(vehicleid) == 563 || GetVehicleModel(vehicleid) == 469)
		{
			if(pData[playerid][pLevel] < 2)
			{
				RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
				Error(playerid, "Anda tidak memiliki izin!");
			}
		}
		/*foreach(new pv : PVehicles)
		{
			if(vehicleid == pvData[pv][cVeh])
			{
				if(IsABike(vehicleid) && pvData[pv][cLocked] == 1)
				{
					RemovePlayerFromVehicle(playerid);
					new Float:slx, Float:sly, Float:slz;
					GetPlayerPos(playerid, slx, sly, slz);
					SetPlayerPos(playerid, slx, sly, slz);
					Error(playerid, "This bike is locked by owner.");
				}
			}
		}*/
	}
	return 1;
}

stock SGetName(playerid)
{
    new name[ 64 ];
    GetPlayerName(playerid, name, sizeof( name ));
    return name;
}
/*public OnVehicleStreamIn(vehicleid, forplayerid)
{
	foreach(new pv : PVehicles)
	{
		if(vehicleid == pvData[pv][cVeh])
		{
			if(IsABike(vehicleid) || GetVehicleModel(vehicleid) == 424)
			{
				if(pvData[pv][cLocked] == 1)
				{
					SetVehicleParamsForPlayer(vehicleid, forplayerid, 0, 1);
				}
			}
		}
	}
	return 1;
}*/

/*
public OnPlayerEnterKeypadArea(playerid, keypadid)
{
    ShowPlayerKeypad(playerid, keypadid);
    return 1;
}

public OnKeypadResponse(playerid, keypadid, bool:response, bool:success, code[])
{
    if(keypadid == SAGSLobbyKey[0])
    {
        if(!response)
        {
            HidePlayerKeypad(playerid, keypadid);
            return 1;
        }
		if(response)
        {
            if(!success)
            {
                Error(playerid, "Wrong Code.");
            }
			if(success)
			{
				Info(playerid, "Welcome.");
				MoveDynamicObject(SAGSLobbyDoor, 1387.9232, -25.3887, 999.9782, 3);
				SetTimer("SAGSLobbyDoorClose", 5000, 0);
			}
		}
	}
    if(keypadid == SAGSLobbyKey[1])
    {
        if(!response)
        {
            HidePlayerKeypad(playerid, keypadid);
            return 1;
        }
        if(response)
        {
            if(!success)
            {
                Error(playerid, "Wrong Code.");
            }
            if(success)
            {
                Info(playerid, "Welcome.");
				MoveDynamicObject(SAGSLobbyDoor, 1387.9232, -25.3887, 999.9782, 3);
				SetTimer("SAGSLobbyDoorClose", 5000, 0);
            }
        }
    }
    return 1;
} */

/*public OnPlayerActivateDoor(playerid, doorid)
{
	if(doorid == SAGSLobbyDoor)
	{
		if(pData[playerid][pFaction] != 2)
		{
			Error(playerid, "You dont have access!");
			return 1; // Cancels the door from being opened
		}
	}
	if(doorid == gMyDoor)
	{
		new bool:gIsDoorLocked = false;
		if(gIsDoorLocked == true)
		{
			SendClientMessage(playerid, -1, "Door is locked, can't open!");
			return 1; // Cancels the door from being opened
		}
	}
	return 1;
}

public OnButtonPress(playerid, buttonid)
{
	if(buttonid == SAGSLobbyBtn[0])
	{
		Info(playerid, "Well done!");
	}
	if(buttonid == SAGSLobbyBtn[1])
	{
		Info(playerid, "Well done!");
	}
}*/

public OnPlayerText(playerid, text[])
{
	if(isnull(text)) return 0;
	printf("[CHAT] %s(%d) : %s", pData[playerid][pName], playerid, text);
	
	if(pData[playerid][pSpawned] == 0 && pData[playerid][IsLoggedIn] == false)
	{
	    Error(playerid, "You must be spawned or logged in to use chat.");
	    return 0;
	}	
	if(ServiceIndex[playerid] != 0)
	{
		ProcessServiceCall(playerid, text);
		return 0;
	}

	// AUTO RP
	if(!strcmp(text, "rpgun", true) || !strcmp(text, "gunrp", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out gun from holster and ready to shoot.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcrash", true) || !strcmp(text, "crashrp", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s terkejut setelah tabrakan lalu mencoba menenangkan diri sejenak.", ReturnName(playerid));
		return 0;
			}
    if(!strcmp(text, "rpshoot", true) || !strcmp(text, "shootrp", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s aim the gun and shooting the target.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfish", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memasang umpan ke kail lalu siap untuk memancing.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfall", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s jatuh dan merasakan sakit.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpmad", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s merasa kesal dan ingin mengeluarkan amarah.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rprob", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s menggeledah tubuh korban yang ada didepan dan siap untuk merampok.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcj", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mencuri kendaraan seseorang lalu membawanya kabur", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpwar", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s berperang dengan sesorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpdie", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s pingsan dan tidak sadarkan diri.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfixmeka", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memperbaiki mesin kendaraan menggunakan alat yang sudah disiapkan", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcheckmeka", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memeriksa seluruh kondisi kendaraan dengan seksama", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfight", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ribut dan memukul seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcry", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sedang bersedih dan menangis.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rprun", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s berlari dan kabur.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfear", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s merasa ketakutan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpdropgun", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s meletakkan senjata yang dipegang ke bawah", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rptakegun", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mengambil senjata yang ada dibawah", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpgivecar", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memberikan surat surat kendaraan beserta kuncinya dengan tangan kanan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpshy", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s merasa malu.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpnusuk", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s menusuk dan membunuh seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpharvest", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memanen tanaman.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rplockhouse", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sedang mengunci rumah.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rplockcar", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sedang mengunci kendaraan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpnodong", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memulai menodong seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpeat", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s makan makanan yang ia beli.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpdrink", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s meminum minuman yang ia beli.", ReturnName(playerid));
		return 0;
	}
	if(text[0] == '!')
	{
		new tmp[512];
		if(text[1] == ' ')
		{
			format(tmp, sizeof(tmp), "%s", text[2]);
		}
		else
		{
			format(tmp, sizeof(tmp), "%s", text[1]);
		}
		if(pData[playerid][pAdminDuty] == 1)
		{
			if(strlen(tmp) > 64)
			{
				SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %.64s ..", ReturnName(playerid), tmp);
				SendNearbyMessage(playerid, 20.0, COLOR_WHITE, ".. %s ))", tmp[64]);
				return 0;
			}
			else
			{
				SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %s ))", ReturnName(playerid), tmp);
				return 0;
			}
		}
		else
		{
			if(strlen(tmp) > 64)
			{
				SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s: (( %.64s ..", ReturnName(playerid), tmp);
				SendNearbyMessage(playerid, 20.0, COLOR_WHITE, ".. %s ))", tmp[64]);
				return 0;
			}
			else
			{
				SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s: (( %s ))", ReturnName(playerid), tmp);
				return 0;
			}
		}
	}
	if(text[0] == '@')
	{
		if(pData[playerid][pSMS] != 0)
		{
			if(pData[playerid][pPhoneCredit] < 1)
			{
				Error(playerid, "Anda tidak memiliki Credit!");
				return 0;
			}
			if(pData[playerid][pInjured] != 0)
			{
				Error(playerid, "Tidak dapat melakukan saat ini.");
				return 0;
			}
			new tmp[512];
			foreach(new ii : Player)
			{
				if(text[1] == ' ')
				{
			 		format(tmp, sizeof(tmp), "%s", text[2]);
				}
				else
				{
				    format(tmp, sizeof(tmp), "%s", text[1]);
				}
				if(pData[ii][pPhone] == pData[playerid][pSMS])
				{
					if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii))
					{
						Error(playerid, "Nomor ini tidak aktif!");
						return 0;
					}
					SendClientMessageEx(playerid, COLOR_YELLOW, "[SMS to %d]"WHITE_E" %s", pData[playerid][pSMS], tmp);
					SendClientMessageEx(ii, COLOR_YELLOW, "[SMS from %d]"WHITE_E" %s", pData[playerid][pPhone], tmp);
					PlayerPlaySound(ii, 6003, 0,0,0);
					pData[ii][pSMS] = pData[playerid][pPhone];
					
					pData[playerid][pPhoneCredit] -= 1;
					return 0;
				}
			}
		}
	}
	if(pData[playerid][pCall] != INVALID_PLAYER_ID)
	{
		// Anti-Caps
		if(GetPVarType(playerid, "Caps"))
			UpperToLower(text);

		new lstr[1024], caller = pData[playerid][pCall];
		if(pData[playerid][pGetPAYPHONEID] != -1)
		{
			SendClientMessageEx(pData[playerid][pCall], COLOR_YELLOW, "[CELLPHONE] "WHITE_E"%s.", text);
			format(lstr, sizeof(lstr), "[PayPhone] %s says: %s", ReturnName(playerid), text);
		}
		else if(pData[caller][pGetPAYPHONEID] != -1)
		{
			SendClientMessageEx(caller, COLOR_YELLOW, "[PAYPHONE] "WHITE_E"%s.", text);
			format(lstr, sizeof(lstr), "[CellPhone] %s says: %s", ReturnName(playerid), text);
		}
		else
		{
			SendClientMessageEx(pData[playerid][pCall], COLOR_YELLOW, "[CELLPHONE] "WHITE_E"%s.", text);
			format(lstr, sizeof(lstr), "[CellPhone] %s says: %s", ReturnName(playerid), text);
		}
		ProxDetector(10, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
		SetPlayerChatBubble(playerid, text, COLOR_WHITE, 10.0, 3000);
		return 0;
	}
	else
	{
		// Anti-Caps
		if(GetPVarType(playerid, "Caps"))
			UpperToLower(text);
		new lstr[1024];
		if(pData[playerid][pAdminDuty] == 0 && pData[playerid][pAccent] == 0)
		{
			//format(lstr, sizeof(lstr), "%s says: %s", ReturnName(playerid), text);
			//ProxDetector(25, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
			//SetPlayerChatBubble(playerid, text, COLOR_WHITE, 10.0, 3000);
		}
		else if(pData[playerid][pAdminDuty] == 1)
		{
			format(lstr, sizeof(lstr), ""RED_E"%s "WHITE_E": (( %s ))", pData[playerid][pAdminname], text);
			ProxDetector(40, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
		}
		else if(pData[playerid][pAccent] > 0)
		{
			//format(lstr, sizeof(lstr), "(%s accent) %s says: %s", GetAccentName(playerid), ReturnName(playerid), text);
			//ProxDetector(25, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		{
			if(pData[playerid][pAdmin] < 1)
			{
				format(lstr, sizeof(lstr), "[OOC ZONE] %s: (( %s ))", ReturnName(playerid), text);
				ProxDetector(40, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
			}
			else if(pData[playerid][pAdmin] > 1 || pData[playerid][pHelper] > 1)
			{
				format(lstr, sizeof(lstr), "[OOC ZONE] %s: %s", pData[playerid][pAdminname], text);
				ProxDetector(40, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
			}
		}
		return 0;
	}
}


public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if (result == -1)
    {
        //Error(playerid, "Unknown Command! Gunakan /help untuk info lanjut.");
        ErrorMsg(playerid, "Unknown Command! Gunakan /help untuk info lanjut.");
        return 0;
    }
	printf("[CMD]: %s(%d) menggunakan CMD '%s' (%s)", pData[playerid][pName], playerid, cmd, params);
	new dc[128];
	format(dc, sizeof(dc),  "```\n[CMD] %s: [%s] [%s]", GetRPName(playerid), cmd);
	SendDiscordMessage(1, dc);
    return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	pemainic++;

	new PlayerIP[16];
	g_MysqlRaceCheck[playerid]++;
	IsAtEvent[playerid] = 0;
	PlayerData[playerid][pHoldWeapon] = 0;
	ResetVariables(playerid);
	RemoveMappingGen(playerid);
	//Load3DTextLabelPom(playerid);
	PlayAudioStreamForPlayer(playerid, "http://ol-uploads.virtualspeech.com/convert_audio/Converted%20by%20VirtualSpeech%20-%20eg70mpastq.mp3");
	CreatePlayerTextDraws(playerid);
	CreateProgress(playerid);
	pData[playerid][pSelectItem] = 0;
    for (new i = 0; i != MAX_INVENTORY; i ++)
	{
	    InventoryData[playerid][i][invExists] = false;
	    InventoryData[playerid][i][invModel] = 0;
	}
	CreateinvenTD(playerid);

	new year, month, day, hour, minute, second;
	getdate(year, month, day);
	gettime(hour, minute, second);

	editing_object[playerid] = INVALID_STREAMER_ID;

	new str[1000];
    format(str, sizeof(str), "(%d)", playerid);
    playerID[playerid] = Create3DTextLabel(str, 0xFFFFFFFF, 0, 0, 0, 10, 0);
    Attach3DTextLabelToPlayer(playerID[playerid], playerid, 0.0, 0.0, 0.1);

	RefreshMapJobDaging(playerid);
	LoadArea(playerid);

    pData[playerid][pMeatProgres] = 0;
    pData[playerid][pPemotongStatus] = 0;
	LimitSpeed[playerid] = 0; //Buat Disable Speedlimit setiap kali player login

	//ICON SAPD
	SetPlayerMapIcon(playerid, 12, 1554.80, -1675.65, 16.19, 30 , 0, MAPICON_LOCAL); 
	//ICON EMS
	SetPlayerMapIcon(playerid, 13, 1172.44, -1323.37, 15.40, 22 , 0, MAPICON_LOCAL); 
	//ICON BANDARA
	SetPlayerMapIcon(playerid, 14, 1954.64, -2309.93, 13.54, 5 , 0, MAPICON_LOCAL);
	//ICON TRUCKER
	SetPlayerMapIcon(playerid, 15, -68.72, -1130.11, 1.07, 51 , 0, MAPICON_LOCAL);
	//ICON BANK
	SetPlayerMapIcon(playerid, 16, 1465.12, -1011.05, 26.84, 52 , 0, MAPICON_LOCAL);
	//ICON DEALER
	SetPlayerMapIcon(playerid, 17, 1285.23, -1308.43, 13.54, 55 , 0, MAPICON_LOCAL); //1285.23, -1308.43, 13.54, 92.37

	GetPlayerName(playerid, pData[playerid][pName], MAX_PLAYER_NAME);

	GetPlayerName(playerid, pData[playerid][pUCP], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
	pData[playerid][pIP] = PlayerIP;
	pData[playerid][pID] = playerid;
	InterpolateCameraPos(playerid, 698.826049, -1404.027099, 16.206615, 2045.292480, -1425.237182, 128.337753, 60000);
	InterpolateCameraLookAt(playerid, 703.825317, -1404.041990, 500000681, 2050.291992, -1425.306762, 128.361190, 50000);
	
	SetTimerEx("SafeLogin", 1000, 0, "i", playerid);

	//SetPlayerPos(playerid, 1094.34, -2037.15, 82.75);
	
	for(new j; j < 96; j++ ) 
	{
		SendClientMessage(playerid, COLOR_WHITE, " ");
	}

	new query[103];
	mysql_format(g_SQL, query, sizeof query, "SELECT * FROM `playerucp` WHERE `ucp` = '%e' LIMIT 1", pData[playerid][pUCP]);
	mysql_pquery(g_SQL, query, "OnPlayerDataLoaded", "dd", playerid, g_MysqlRaceCheck[playerid]);
	SetPlayerColor(playerid, COLOR_WHITE);

	pData[playerid][activitybar] = CreatePlayerProgressBar(playerid, 273.500000, 157.333541, 88.000000, 8.000000, 5930683, 100, 0);

	//HBE textdraw Modern
	pData[playerid][damagebar] = CreatePlayerProgressBar(playerid, 459.000000, 415.749938, 61.000000, 9.000000, 16711935, 1000.0, 0);
	pData[playerid][fuelbar] = CreatePlayerProgressBar(playerid, 459.500000, 432.083221, 61.000000, 9.000000, 16711935, 1000.0, 0);
                
	pData[playerid][hungrybar] = CreatePlayerProgressBar(playerid, 565.500000, 405.833404, 68.000000, 8.000000, 16711935, 100.0, 0);
	pData[playerid][energybar] = CreatePlayerProgressBar(playerid, 565.500000, 420.416717, 68.000000, 8.000000, 16711935, 100.0, 0);
	pData[playerid][bladdybar] = CreatePlayerProgressBar(playerid, 565.500000, 435.000091, 68.000000, 8.000000, 16711935, 100.0, 0);
	
	//HBE textdraw Simple
	pData[playerid][spdamagebar] = CreatePlayerProgressBar(playerid, 565.500000, 383.666717, 51.000000, 7.000000, 16711935, 1000.0, 0);
	pData[playerid][spfuelbar] = CreatePlayerProgressBar(playerid, 566.000000, 398.250061, 51.000000, 7.000000, 16711935, 1000.0, 0);
                
	pData[playerid][sphungrybar] = CreatePlayerProgressBar(playerid, 467.500000, 433.833282, 41.000000, 8.000000, 16711935, 100.0, 0);
	pData[playerid][spenergybar] = CreatePlayerProgressBar(playerid, 531.500000, 433.249938, 41.000000, 8.000000, 16711935, 100.0, 0);
	pData[playerid][spbladdybar] = CreatePlayerProgressBar(playerid, 595.500000, 433.250061, 41.000000, 8.000000, 16711935, 100.0, 0);

    if(pData[playerid][pHead] < 0) return pData[playerid][pHead] = 20;

    if(pData[playerid][pPerut] < 0) return pData[playerid][pPerut] = 20;

    if(pData[playerid][pRFoot] < 0) return pData[playerid][pRFoot] = 20;

    if(pData[playerid][pLFoot] < 0) return pData[playerid][pLFoot] = 20;

    if(pData[playerid][pLHand] < 0) return pData[playerid][pLHand] = 20;
   
    if(pData[playerid][pRHand] < 0) return pData[playerid][pRHand] = 20;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	pemainic--;

    pData[playerid][pMeatProgres] = 0;
    pData[playerid][pPemotongStatus] = 0;
	if(IsPlayerInAnyVehicle(playerid))
	{
        RemovePlayerFromVehicle(playerid);
    }
	//UpdateWeapons(playerid);
	g_MysqlRaceCheck[playerid]++;
	
	SetPlayerName(playerid, pData[playerid][pUCP]);

	Delete3DTextLabel(playerID[playerid]);

	Tags_Reset(playerid);

	if(IsValidVehicle(pData[playerid][pKendaraanKerja]))
   		DestroyVehicle(pData[playerid][pKendaraanKerja]);

	if(pData[playerid][IsLoggedIn] == true)
	{
		if(IsAtEvent[playerid] == 0)
		{
			UpdatePlayerData(playerid);
		}
		else if(IsAtEvent[playerid] == 1)
        {
            SetPlayerPos(playerid, LastposX[playerid], LastposY[playerid], LastposZ[playerid]);
            SetPlayerVirtualWorld(playerid, LastVW[playerid]);
            SetPlayerInterior(playerid, LastInterior[playerid]);
            SetPlayerHealthEx(playerid, 100.0);

            pData[playerid][pInjured] = 0;
            pData[playerid][pHospital] = 0;
            pData[playerid][pSick] = 0;
            IsAtEvent[playerid] = 0;

            pData[playerid][pPosX] = LastposX[playerid];
            pData[playerid][pPosY] = LastposY[playerid];
            pData[playerid][pPosZ] = LastposZ[playerid];
            pData[playerid][pInt] = LastInterior[playerid];
            pData[playerid][pWorld] = LastVW[playerid];

            SetPlayerTeam(playerid, 0);
            SetPlayerColor(playerid, COLOR_WHITE);
            ResetPlayerWeaponsEx(playerid);
            ClearAnimations(playerid);
        }
		RemovePlayerVehicle(playerid);
		Report_Clear(playerid);
		Ask_Clear(playerid);
		FactionCall_Clear(playerid);
		Player_ResetCutting(playerid);
		Player_RemoveLumber(playerid);
		Player_ResetHarvest(playerid);
		Player_ResetBoombox(playerid);
		Player_ResetPayphone(playerid);
		Player_ResetDamageLog(playerid);
		Player_ResetAdsLog(playerid);
		KillTazerTimer(playerid);
		//SaveLunarSystem(playerid);
		//KillTimer(loadingtimer[playerid]);
		Delete3DTextLabel(pData[playerid][pLabel]);
        pData[playerid][pLabel] = Text3D: -1;
		if(pData[playerid][pRobLeader] == 1)
		{
			foreach(new ii : Player) 
			{
				if(pData[ii][pMemberRob] == playerid)
				{
					Servers(ii, "* Pemimpin Perampokan anda telah keluar! [ MISI GAGAL ]");
					pData[ii][pMemberRob] = -1;
					pData[ii][pRobLeader] = -1;
				}
			}
		}
	}

	if(IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
        DestroyDynamic3DTextLabel(pData[playerid][pAdoTag]);

    if(IsValidDynamic3DTextLabel(pData[playerid][pBTag]))
        DestroyDynamic3DTextLabel(pData[playerid][pBTag]);

    if (IsValidVehicle(PlayerData[playerid][pVehiclePetaniPadi]))
        DestroyVehicle(PlayerData[playerid][pVehiclePetaniPadi]);

    if (IsValidVehicle(PlayerData[playerid][pVehiclePetaniCabai]))
        DestroyVehicle(PlayerData[playerid][pVehiclePetaniCabai]);

    if (IsValidVehicle(PlayerData[playerid][pVehiclePetaniTebu]))
        DestroyVehicle(PlayerData[playerid][pVehiclePetaniTebu]);

    if (IsValidVehicle(PlayerData[playerid][pVehiclePetaniGaram]))
        DestroyVehicle(PlayerData[playerid][pVehiclePetaniGaram]);
			
	if(IsValidDynamicObject(pData[playerid][pFlare]))
        DestroyDynamicObject(pData[playerid][pFlare]);
    
    if(pData[playerid][pMaskOn] == 1)
        Delete3DTextLabel(pData[playerid][pMaskLabel]);

    if(pData[playerid][pAdminDuty] == 1)
        DestroyDynamic3DTextLabel(pData[playerid][pAdminLabel]);
    
    pData[playerid][pAdoActive] = false;
	
	/*if(cache_is_valid(pData[playerid][Cache_ID]) && pData[playerid][IsLoggedIn] == false)
	{
		cache_delete(pData[playerid][Cache_ID]);
		pData[playerid][Cache_ID] = MYSQL_INVALID_CACHE;
	}*/

	if(pData[playerid][pJob] == 20)
	{
    	penambang--;
    	DeletePenambangCP(playerid);
	}
	else if(pData[playerid][pJob] == 3)
	{
		lumberjack--;
	}
	else if(pData[playerid][pJob] == 4)
	{
		trucker--;
	}
	else if(pData[playerid][pJob] == 5)
	{
		miner--;
	}
	else if(pData[playerid][pJob] == 6)
	{
		production--;
	}
	else if(pData[playerid][pJob] == 7)
	{
		farmers--;
	}
	else if(pData[playerid][pJob] == 8)
	{
		hauling--;
	}
	else if(pData[playerid][pJob] == 9)
	{
		pizza--;
	}
	else if(pData[playerid][pJob] == 10)
	{
		butcher--;
	}
	else if(pData[playerid][pJob] == 11)
	{
		reflenish--;
	}
	else if(pData[playerid][pJob] == 14)
	{
		pemerassusu--;
		DeleteJobPemerahMap(playerid);
	}
	else if(pData[playerid][pJob] == 21)
	{
		tukangkayu--;
	}
	else if(pData[playerid][pJob] == 23)
	{
		penjahitt--;
	}
	else if(pData[playerid][pJob] == 24)
	{
		tukangayams--;
		DeletePemotongCP(playerid);
	}
	else if(pData[playerid][pJob] == 25)
	{
		penambangminyak--;
		DeleteMinyakCP(playerid);
	}
	else if(pData[playerid][pJob] == 26)
	{
    	Recycler--;
	}
	else if(pData[playerid][pJob] == 27)
	{
    	Sopirbus--;
    	DeleteBusCP(playerid);
	}
	//tukangayams

	//FACTION ONLINE LIST
	if(pData[playerid][pFaction] == 1)
	{
		polisidikota--;
	}
	if(pData[playerid][pFaction] == 2)
	{
		pemerintahdikota--;
	}
	if(pData[playerid][pFaction] == 3)
	{
		medisdikota--;
	}
	if(pData[playerid][pFaction] == 4)
	{
		newsdikota--;
	}
	if(pData[playerid][pFaction] == 5)
	{
		pedagangdikota--;
	}
	if(pData[playerid][pFaction] == 6)
	{
		gojekdikota--;
	}
	if(pData[playerid][pFaction] == 7)	
	{
		mekanikdikota--;
	}

	ToggleCall[playerid] = 0;
	DetikCall[playerid] = 0;
	MenitCall[playerid] = 0;
	JamCall[playerid] = 0;

	if(VehHauling[playerid] != -1)
	{
		if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8)
		{
		    DestroyVehicle(VehHauling[playerid]);
		}
	}
	if(pData[playerid][LoginTimer])
	{
		KillTimer(pData[playerid][LoginTimer]);
		pData[playerid][LoginTimer] = 0;
	}

	pData[playerid][IsLoggedIn] = false;
	
	new Float: px, Float: py, Float: pz;
    new disc[200];
    GetPlayerPos(playerid, px, py, pz);
    switch (reason) 
    {
        case 0 :  
        {
            format(disc, sizeof(disc), "{ff0000}Player Left The Game\n{ffffff}%s telah keluar dari kota. Alasan [Timeout/Crash]", PlayerData[playerid][pName], playerid);
            PlayerDisconnect[playerid] = CreateDynamic3DTextLabel(disc, COLOR_WHITE, px, py, pz, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
            SetTimerEx("Remove3DTextLabelLogsPLayer", 10000, false, "d", playerid);
        }
        case 1 :  
        {
            format(disc, sizeof(disc), "{ff0000}Player Left The Game\n\n{ffffff}%s telah keluar dari kota. Alasan [Exiting]", PlayerData[playerid][pName], playerid);
            PlayerDisconnect[playerid] = CreateDynamic3DTextLabel(disc, COLOR_WHITE, px, py, pz, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
            SetTimerEx("Remove3DTextLabelLogsPLayer", 10000, false, "d", playerid);
        }
        case 2 :  
        {
            format(disc, sizeof(disc), "{ff0000}Player Left The Game\n\n{ffffff}%s telah keluar dari kota. Alasan [Kicked/Banned]", PlayerData[playerid][pName], playerid);
            PlayerDisconnect[playerid] = CreateDynamic3DTextLabel(disc, COLOR_WHITE, px, py, pz, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
            SetTimerEx("Remove3DTextLabelLogsPLayer", 10000, false, "d", playerid);
        }
    }

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	foreach(new ii : Player)
	{
		if(IsPlayerInRangeOfPoint(ii, 40.0, x, y, z))
		{
			switch(reason)
			{
				case 0:
				{
					SendClientMessageEx(ii, COLOR_RED, "* %s "WHITE_E"Has left the server.{7fffd4}(FC/Crash/Timeout)", pData[playerid][pName]);
				}
				case 1:
				{
					SendClientMessageEx(ii, COLOR_RED, "* %s "WHITE_E"Has left the server.{7fffd4}(Disconnected)", pData[playerid][pName]);
				}
				case 2:
				{
					SendClientMessageEx(ii, COLOR_RED, "* %s "WHITE_E"Has left the server.{7fffd4}(Kick/Banned)", pData[playerid][pName]);
				}
			}
		}
	}
	new reasontext[526];
	switch(reason)
	{
	    case 0: reasontext = "Timeout/ Crash";
	    case 1: reasontext = "Quit";
	    case 2: reasontext = "Kicked/ Banned";
	}
	new dc[100];
	format(dc, sizeof(dc),  "```\nNama: %s Telah keluar dari kota Valrise Reality\nUcp: %s\nReason: %s.```", pData[playerid][pName], pData[playerid][pUCP], reasontext);
	SendDiscordMessage(0, dc);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	//SetSpawnInfo(playerid, 0, pData[playerid][pSkin], pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pPosA], 0, 0, 0, 0, 0, 0);
	//SpawnPlayer(playerid);
	StopAudioStreamForPlayer(playerid);
	TextDrawHideForPlayer(playerid, TopTenList);
	SetPlayerInterior(playerid, pData[playerid][pInt]);
	SetPlayerVirtualWorld(playerid, pData[playerid][pWorld]);
	SetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
	SetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 0);
	SetPlayerSpawn(playerid);
	LoadAnims(playerid);
	//Hideproggresbar(playerid);
	
	SetPlayerSkillLevel(playerid, WEAPON_COLT45, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SILENCED, 1);
	SetPlayerSkillLevel(playerid, WEAPON_DEAGLE, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SHOTGUN, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SAWEDOFF, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SHOTGSPA, 1);
	SetPlayerSkillLevel(playerid, WEAPON_UZI, 1);
	SetPlayerSkillLevel(playerid, WEAPON_MP5, 1);
	SetPlayerSkillLevel(playerid, WEAPON_AK47, 1);
	SetPlayerSkillLevel(playerid, WEAPON_M4, 1);
	SetPlayerSkillLevel(playerid, WEAPON_TEC9, 1);
	SetPlayerSkillLevel(playerid, WEAPON_RIFLE, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SNIPER, 1);

	new dc[100];
	format(dc, sizeof(dc),  "```\nNama: %s Telah memasuki kota Valrise Reality\nUcp: %s\nNegara: Indonesian.```", pData[playerid][pName], pData[playerid][pUCP]);
	SendDiscordMessage(0, dc);
	return 1;
}

SetPlayerSpawn(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(pData[playerid][pGender] == 0)
		{
			TogglePlayerControllable(playerid,0);
			SetPlayerHealthEx(playerid, 100.0);
			SetPlayerArmourEx(playerid, 0.0);
			SetPlayerPos(playerid, 2823.21,-2440.34,12.08);
			SetPlayerCameraPos(playerid,1058.544433, -1086.021362, 41);
			SetPlayerCameraLookAt(playerid,1055.534057, -1082.029296, 39.802570);
			SetPlayerVirtualWorld(playerid, 0);
			ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "{00FFE5}Konoha - {ffffff}Tanggal Lahir", "Mohon masukan tanggal lahir sesuai format hh/bb/tttt cth:(23/03/2002)", "Input", "");
		}
		else
		{
			SetPlayerColor(playerid, COLOR_WHITE);
			if(pData[playerid][pHBEMode] == 1) //simple
			{
				for(new i = 0; i < 15; i++)
				{
					TextDrawShowForPlayer(playerid, GenzoHBE[i]);
				}
			}
			if(pData[playerid][pHBEMode] == 2) //simple
			{
				for(new i = 0; i < 32; i++)
				{
					TextDrawShowForPlayer(playerid, HBEAJIX[i]);
				}
			}
			else
			{
				
			}
			for(new i; i < 8; i++)
			{
				TextDrawShowForPlayer(playerid, KonohaFeature[i]);
			}
			SetPlayerSkin(playerid, pData[playerid][pSkin]);
			if(pData[playerid][pOnDuty] >= 1)
			{
				SetPlayerSkin(playerid, pData[playerid][pFacSkin]);
				SetFactionColor(playerid);
			}
			if(pData[playerid][pAdminDuty] > 0)
			{
				SetPlayerColor(playerid, COLOR_RED);
			}
			SetTimerEx("SpawnTimer", 6000, false, "i", playerid);
		}
	}
}

function SpawnTimer(playerid)
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, pData[playerid][pMoney]);
	SetPlayerScore(playerid, pData[playerid][pLevel]);
	SetPlayerHealthEx(playerid, pData[playerid][pHealth]);
	SetPlayerArmourEx(playerid, pData[playerid][pArmour]);
	SetPlayerFightingStyle(playerid, pData[playerid][pFightingStyle]);
	pData[playerid][pSpawned] = 1;
	TogglePlayerControllable(playerid, 1);
	SetCameraBehindPlayer(playerid);
	AttachPlayerToys(playerid);
	SetWeapons(playerid);
	pData[playerid][pApplyAnimation] = false;
	if(pData[playerid][pJail] > 0)
	{
		JailPlayer(playerid); 
	}
	if(pData[playerid][pRehab] > 0)
	{
		RehabPlayer(playerid);
	}
	if(pData[playerid][pArrestTime] > 0)
	{
		SetPlayerArrest(playerid, pData[playerid][pArrest]);
	}
	return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	//Locker Faction Skin
	if(listid == SAPDMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAPDFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAPDWar)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAGSMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAGSFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAMDMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAMDFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SANEWMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SANEWFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
    if(listid == SACFMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SACFFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	///Bisnis buy skin clothes
	if(listid == MaleSkins)
    {
		if(response)
		{
			new bizid = pData[playerid][pInBiz], price;
			price = bData[bizid][bP][0];
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			GivePlayerMoneyEx(playerid, -price);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d seharga %s.", ReturnName(playerid), modelid, 
            	(price));
            bData[bizid][bProd]--;
            bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);
            Bisnis_Save(bizid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
	if(listid == FemaleSkins)
    {
		if(response)
		{
			new bizid = pData[playerid][pInBiz], price;
			price = bData[bizid][bP][0];
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			GivePlayerMoneyEx(playerid, -price);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
            bData[bizid][bProd]--;
            bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);
            Bisnis_Save(bizid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
	if(listid == VIPMaleSkins)
    {
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengganti skin ID %d.", ReturnName(playerid), modelid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
	if(listid == VIPFemaleSkins)
    {
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d.", ReturnName(playerid), modelid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
	if(listid == toyslist)
	{
		if(response)
		{
			new bizid = pData[playerid][pInBiz], price;
			price = bData[bizid][bP][1];
			
			GivePlayerMoneyEx(playerid, -price);
			if(pData[playerid][PurchasedToy] == false) MySQL_CreatePlayerToy(playerid);
			pToys[playerid][pData[playerid][toySelected]][toy_model] = modelid;
			pToys[playerid][pData[playerid][toySelected]][toy_hide] = 0;
			
			new finstring[750];
			strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
			strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");
			ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""WHITE_E"Select Bone", finstring, "Select", "Cancel");
			
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli object ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
            bData[bizid][bProd]--;
            bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);
            Bisnis_Save(bizid);
		}
		else return Servers(playerid, "Canceled buy toys");
	}
	if(listid == viptoyslist)
	{
		if(response)
		{
			if(pData[playerid][PurchasedToy] == false) MySQL_CreatePlayerToy(playerid);
			pToys[playerid][pData[playerid][toySelected]][toy_model] = modelid;
			pToys[playerid][pData[playerid][toySelected]][toy_hide] = 0;

			new finstring[750];
			strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
			strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");
			ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""WHITE_E"Select Bone", finstring, "Select", "Cancel");
			
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil object ID %d dilocker.", ReturnName(playerid), modelid);
		}
		else return Servers(playerid, "Canceled toys");
	}
	if(listid == vtoyslist)
	{
		if(response)
		{
			new vehicleid = GetPlayerVehicleID(playerid), slotid = pData[playerid][pVtoySelect];

			if(pData[playerid][pMoney] < 2500)
				return Error(playerid, "Uang kamu tidak cukup, kamu harus memegang $2.500");

			if(pvData[vehicleid][cToys] == false) MySQL_CreateVehicleToys(vehicleid);
				
			vToys[vehicleid][slotid][vtModelid] = modelid;
			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				vToys[vehicleid][slotid][vtY], 
				vToys[vehicleid][slotid][vtZ], 
				vToys[vehicleid][slotid][vtRX], 
				vToys[vehicleid][slotid][vtRY], 
				vToys[vehicleid][slotid][vtRZ]);

			MySQL_SaveVehicleToys(vehicleid);

			InfoTD_MSG(playerid, 5000, "~g~~h~Object Attached!~n~~w~Adjust the position than click on the save icon!");
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli object ID %d seharga $2.500.", ReturnName(playerid), modelid);
            GivePlayerMoneyEx(playerid, -2500);
		}
		else return Servers(playerid, "Canceled buy vehicle toys");
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerCameraPos(playerid, 1093.79, -2037.99, 83.57);
	SetPlayerCameraLookAt(playerid, 1093.19, -2037.19, 83.51);
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if(pData[playerid][IsLoggedIn] == false)
	{
	    Error(playerid, "You must be spawned or logged in to use chat.");
	    return 0;
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID)
	{
		new reasontext[526];
		switch(reason)
		{
	        case 0: reasontext = "Fist";
	        case 1: reasontext = "Brass Knuckles";
	        case 2: reasontext = "Golf Club";
	        case 3: reasontext = "Nite Stick";
	        case 4: reasontext = "Knife";
	        case 5: reasontext = "Basebal Bat";
	        case 6: reasontext = "Shovel";
	        case 7: reasontext = "Pool Cue";
	        case 8: reasontext = "Katana";
	        case 9: reasontext = "Chain Shaw";
	        case 14: reasontext = "Cane";
	        case 18: reasontext = "Molotov";
	        case 22..24: reasontext = "Pistol";
	        case 25..27: reasontext = "Shotgan";
	        case 28..34: reasontext = "Laras long";
		    case 49: reasontext = "Rammed by Car";
		    case 50: reasontext = "Helicopter blades";
		    case 51: reasontext = "Explosion";
		    case 53: reasontext = "Drowned";
		    case 54: reasontext = "Splat";
		    case 255: reasontext = "Suicide";
		}
		new h, m, s;
		new day, month, year;
	    gettime(h, m, s);
	    getdate(year,month,day);

        new dc[128];
        format(dc, sizeof dc, "```%02d.%02d.%d - %02d:%02d:%02d```\n```\n%s [ID: %d] killed %s [ID: %d] (%s)\n```",day, month, year, h, m, s, pData[killerid][pName], killerid, pData[playerid][pName], playerid, reasontext);
        SendDiscordMessage(9, dc);
	}
    else
	{
		new reasontext[526];
		switch(reason)
		{
	        case 0: reasontext = "Fist";
	        case 1: reasontext = "Brass Knuckles";
	        case 2: reasontext = "Golf Club";
	        case 3: reasontext = "Nite Stick";
	        case 4: reasontext = "Knife";
	        case 5: reasontext = "Basebal Bat";
	        case 6: reasontext = "Shovel";
	        case 7: reasontext = "Pool Cue";
	        case 8: reasontext = "Katana";
	        case 9: reasontext = "Chain Shaw";
	        case 14: reasontext = "Cane";
	        case 18: reasontext = "Molotov";
	        case 22..24: reasontext = "Pistol";
	        case 25..27: reasontext = "Shotgan";
	        case 28..34: reasontext = "Laras long";
		    case 49: reasontext = "Rammed by Car";
		    case 50: reasontext = "Helicopter blades";
		    case 51: reasontext = "Explosion";
		    case 53: reasontext = "Drowned";
		    case 54: reasontext = "Splat";
		    case 255: reasontext = "Suicide";
		}
	    new h, m, s;
	    new day, month, year;
	    gettime(h, m, s);
	    getdate(year,month,day);
	    new name[MAX_PLAYER_NAME + 1];
	    GetPlayerName(playerid, name, sizeof name);

	    new dc[128];
	    format(dc, sizeof dc, "```%02d.%02d.%d - %02d:%02d:%02d```\n```\n%s [ID: %d] death(%s)\n```",day, month, year, h, m, s, name, playerid, reasontext);
	    SendDiscordMessage(9, dc);
	}

	foreach(new ii : Player)
    {
        if(pData[ii][pFaction] == 1)
        {
          	new Float: X, Float: Y, Float: Z;
          	GetPlayerPos(playerid, X, Y, Z);
          	SetPlayerCheckpoint(ii,  X, Y, Z, 3.0);

            for(new ai = 0; ai < 10; ai++)
            {
                TextDrawShowForPlayer(ii, PDLogsDeath[ai]);
            }
        	new pe [120];
        	format(pe, sizeof(pe), "Death : %s Killed : %s Weapon : %s Lokasi : %s", pData[playerid][pName], pData[killerid][pName], ReturnWeaponName(reason), GetLocation(X, Y, Z));//GetName(killerid)
        	TextDrawSetString(PDLogsDeath[9], pe);
        	SetTimerEx("spawntw", 8000, false, "i", ii);
        }
    }

    foreach(new i : Player)
    {
        if(pData[i][pFaction] == 3)
        {
          	new Float: X, Float: Y, Float: Z;
          	GetPlayerPos(playerid, X, Y, Z);
          	//new posisinya = GetPlayerPos(playerid, X, Y, Z);
          	SetPlayerCheckpoint(i, X, Y, Z, 4.0);

            for(new ai = 0; ai < 10; ai++)
            {
                TextDrawShowForPlayer(i, SAMDLogsDeath[ai]);
            }
        	new pe [120];
        	format(pe, sizeof(pe), "Death : %s Lokasi : %s", pData[playerid][pName], GetLocation(X, Y, Z));
        	TextDrawSetString(SAMDLogsDeath[9], pe);
        	SetTimerEx("spawntw", 8000, false, "i", i);
        }
    }

	DeletePVar(playerid, "UsingSprunk");
	SetPVarInt(playerid, "GiveUptime", -1);
	pData[playerid][pSpawned] = 0;
	Player_ResetCutting(playerid);
	Player_RemoveLumber(playerid);
	Player_ResetHarvest(playerid);
	
	pData[playerid][CarryProduct] = 0;
	pData[playerid][pPemotongStatus] = 0;
	
	KillTimer(pData[playerid][pPemotong]);
	KillTimer(pData[playerid][pActivity]);
	KillTimer(pData[playerid][pMechanic]);
	KillTimer(pData[playerid][pProducting]);
	KillTimer(pData[playerid][pMasak]);
	KillTimer(pData[playerid][pMeatJob]);
	KillTimer(pData[playerid][pSampah]);
	KillTimer(pData[playerid][pCooking]);
	KillTimer(pData[playerid][pPizza]);
	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
	PlayerTextDrawHide(playerid, ActiveTD[playerid]);
	pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
	pData[playerid][pActivityTime] = 0;
	
	pData[playerid][pMechDuty] = 0;
	pData[playerid][pTaxiDuty] = 0;
	pData[playerid][pMissionBiz] = -1;
	pData[playerid][pMissionVen] = -1;
	
	pData[playerid][pSideJob] = 0;
	DisablePlayerCheckpoint(playerid);
	DisablePlayerRaceCheckpoint(playerid);
	SetPlayerColor(playerid, COLOR_WHITE);
	RemovePlayerAttachedObject(playerid, 9);
	GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
	foreach(new ii : Player)
    {
        if(pData[ii][pAdmin] > 0)
        {
            SendDeathMessageToPlayer(ii, killerid, playerid, reason);
        }
    }
    if(IsAtEvent[playerid] == 0)
    {
    	new asakit = RandomEx(0, 5);
    	new bsakit = RandomEx(0, 9);
    	new csakit = RandomEx(0, 7);
    	new dsakit = RandomEx(0, 6);
    	pData[playerid][pLFoot] -= dsakit;
    	pData[playerid][pLHand] -= bsakit;
    	pData[playerid][pRFoot] -= csakit;
    	pData[playerid][pRHand] -= dsakit;
    	pData[playerid][pHead] -= asakit;
    }
    if(IsAtEvent[playerid] >= 1)
    {
        LeaveEvent(playerid);
    }
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ,Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	new weaponid = EditingWeapon[playerid];
    if(weaponid)
    {
        if(response == 1)
        {
            new enum_index = weaponid - 22, weaponname[18], string[340];
 
            GetWeaponName(weaponid, weaponname, sizeof(weaponname));
           
            WeaponSettings[playerid][enum_index][Position][0] = fOffsetX;
            WeaponSettings[playerid][enum_index][Position][1] = fOffsetY;
            WeaponSettings[playerid][enum_index][Position][2] = fOffsetZ;
            WeaponSettings[playerid][enum_index][Position][3] = fRotX;
            WeaponSettings[playerid][enum_index][Position][4] = fRotY;
            WeaponSettings[playerid][enum_index][Position][5] = fRotZ;
 
            RemovePlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid));
            SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][enum_index][Bone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, 1.0, 1.0, 1.0);
 
            Servers(playerid, "You have successfully adjusted the position of your %s.", weaponname);
           
            mysql_format(g_SQL, string, sizeof(string), "INSERT INTO weaponsettings (Owner, WeaponID, PosX, PosY, PosZ, RotX, RotY, RotZ) VALUES ('%d', %d, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f) ON DUPLICATE KEY UPDATE PosX = VALUES(PosX), PosY = VALUES(PosY), PosZ = VALUES(PosZ), RotX = VALUES(RotX), RotY = VALUES(RotY), RotZ = VALUES(RotZ)", pData[playerid][pID], weaponid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ);
            mysql_tquery(g_SQL, string);
        }
		else if(response == 0)
		{
			new enum_index = weaponid - 22;
			SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][enum_index][Bone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, 1.0, 1.0, 1.0);
		}
        EditingWeapon[playerid] = 0;
		return 1;
    }
	else
	{
		if(response == 1)
		{
			GameTextForPlayer(playerid, "~g~~h~Toy Position Updated~y~!", 4000, 5);

			pToys[playerid][index][toy_x] = fOffsetX;
			pToys[playerid][index][toy_y] = fOffsetY;
			pToys[playerid][index][toy_z] = fOffsetZ;
			pToys[playerid][index][toy_rx] = fRotX;
			pToys[playerid][index][toy_ry] = fRotY;
			pToys[playerid][index][toy_rz] = fRotZ;
			pToys[playerid][index][toy_sx] = fScaleX;
			pToys[playerid][index][toy_sy] = fScaleY;
			pToys[playerid][index][toy_sz] = fScaleZ;
			
			MySQL_SavePlayerToys(playerid);
		}
		else if(response == 0)
		{
			GameTextForPlayer(playerid, "~r~~h~Selection Cancelled~y~!", 4000, 5);

			SetPlayerAttachedObject(playerid,
				index,
				modelid,
				boneid,
				pToys[playerid][index][toy_x],
				pToys[playerid][index][toy_y],
				pToys[playerid][index][toy_z],
				pToys[playerid][index][toy_rx],
				pToys[playerid][index][toy_ry],
				pToys[playerid][index][toy_rz],
				pToys[playerid][index][toy_sx],
				pToys[playerid][index][toy_sy],
				pToys[playerid][index][toy_sz]);
		}
		SetPVarInt(playerid, "UpdatedToy", 1);
		TogglePlayerControllable(playerid, true);
	}
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == SpawnHouse) // Terminal
	{
		InfoMsg(playerid, "Fitur Ini Dilarang Pemerintah");
	}
	if(clickedid == SpawnBandara) // BANDARA
	{
		pData[playerid][PilihSpawn] = 1;
        InterpolateCameraPos(playerid, 1717.2083,-2250.4700,13.3828, 1676.7021,-2260.7058,13.5363, 3000);
		InterpolateCameraLookAt(playerid, 1717.2083,-2250.4700,13.3828, 1676.7021,-2260.7058,13.5363, 3000);
		TextDrawShowForPlayer(playerid, TDSpawnBYDAYSAMP[7]);
		TextDrawShowForPlayer(playerid, TDSpawnBYDAYSAMP[2]);
		TextDrawShowForPlayer(playerid, TombolSpawn);
	}
	if(clickedid == SpawnKapal) // PELABUHAN
	{
		pData[playerid][PilihSpawn] = 5;
        InterpolateCameraPos(playerid, 2740.1541,-2440.6343,13.6432, 2771.3376,-2437.4644,13.6377, 3000);
		InterpolateCameraLookAt(playerid, 2740.1541,-2440.6343,13.6432, 2771.3376,-2437.4644,13.6377, 3000);
		TextDrawShowForPlayer(playerid, TDSpawnBYDAYSAMP[7]);
		TextDrawShowForPlayer(playerid, TDSpawnBYDAYSAMP[2]);
		TextDrawShowForPlayer(playerid, TombolSpawn);
	}
	if(clickedid == SpawnFaction) // ORGANISASI
	{
		pData[playerid][PilihSpawn] = 4;
        InterpolateCameraPos(playerid, -644.3238,-484.9586,51.7151, -553.3467,-525.7678,44.5802, 3000);
		InterpolateCameraLookAt(playerid, -644.3238,-484.9586,51.7151, -553.3467,-525.7678,44.5802, 3000);
		TextDrawShowForPlayer(playerid, TDSpawnBYDAYSAMP[7]);
		TextDrawShowForPlayer(playerid, TDSpawnBYDAYSAMP[2]);
		TextDrawShowForPlayer(playerid, TombolSpawn);
	}
	if(clickedid == SpawnLastExit) // LOKASI TERAKHIR
	{
		pData[playerid][PilihSpawn] = 3;
		InterpolateCameraPos(playerid, 1058.544433, -1086.021362, 83.586357, 595.605712, -1334.382934, 89.737655, 10000);
		InterpolateCameraLookAt(playerid, 1055.534057, -1082.029296, 83.555107, 590.985107, -1332.492675, 89.460456, 10000);
		TextDrawShowForPlayer(playerid, TDSpawnBYDAYSAMP[7]);
		TextDrawShowForPlayer(playerid, TDSpawnBYDAYSAMP[2]);
		TextDrawShowForPlayer(playerid, TombolSpawn);
	}
	if(clickedid == TombolSpawn) // MENDARAT BANDARA
	{
	    if(pData[playerid][PilihSpawn] == 0) // GAK MILIH
	    return ErrorMsg(playerid, "Anda belum memilih tempat mendarat");
	    
	    if(pData[playerid][PilihSpawn] == 1)
	    {
			pData[playerid][PilihSpawn] = 0;
			SetPlayerPos(playerid, 1685.7356,-2238.5923,13.5469);
			SetPlayerFacingAngle(playerid, 176.7719);			SetCameraBehindPlayer(playerid);
			SetPlayerVirtualWorld(playerid, 0);
   			SetPlayerInterior(playerid, 0);
			SuccesMsg(playerid, "Anda Spawn Di Bandara Konoha");
			TogglePlayerControllable(playerid, 1);
            PlayerData[playerid][pPos][0] =  1685.7356,
			PlayerData[playerid][pPos][1] = -2238.5923,
			PlayerData[playerid][pPos][2] = 13.5469;
			PlayerData[playerid][pPos][3] = 176.7719;
			InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
		}
		else if(pData[playerid][PilihSpawn] == 2)
	    {
	        pData[playerid][PilihSpawn] = 0;
		    SetPlayerPos(playerid, -603.9959,-471.3341,25.6234);
		    SetPlayerFacingAngle(playerid, 85.07);
		    SuccesMsg(playerid, "Anda Spawn Di Terminal Bus Konoha");
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 1);
			SetPlayerVirtualWorld(playerid, 0);
   			SetPlayerInterior(playerid, 0);
   			PlayerData[playerid][pPos][0] = -603.9959,
			PlayerData[playerid][pPos][1] = -471.3341,
			PlayerData[playerid][pPos][2] = 25.6234;
			PlayerData[playerid][pPos][3] = 85.07;
			InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
		}
		else if(pData[playerid][PilihSpawn] == 5)
	    {
	        pData[playerid][PilihSpawn] = 0;
			SetPlayerPos(playerid, 2780.0942,-2392.3618,37.2239);
    		SetPlayerFacingAngle(playerid, 137.2742);
		    SuccesMsg(playerid, "Anda Spawn Di Pelabuhan Konoha");
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 1);
			SetPlayerVirtualWorld(playerid, 0);
   			SetPlayerInterior(playerid, 0);
   			PlayerData[playerid][pPos][0] = 2780.0942,
			PlayerData[playerid][pPos][1] = -2392.3618,
			PlayerData[playerid][pPos][2] = 37.2239;
			PlayerData[playerid][pPos][3] = 137.2742;
			InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
		}
		else if(pData[playerid][PilihSpawn] == 4)
	    {
	        if(pData[playerid][pFaction] == 1)
	        {
		        pData[playerid][PilihSpawn] = 0;
			    SetPlayerPos(playerid, 1130.9117,-2036.8796,69.0078);
			    SetPlayerFacingAngle(playerid, 90.1180);
			    SuccesMsg(playerid, "Anda Spawn Di kantor pemerintahan Konoha");
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
				SetPlayerVirtualWorld(playerid, 0);
	   			SetPlayerInterior(playerid, 0);
	   			PlayerData[playerid][pPos][0] = 1130.9117,
				PlayerData[playerid][pPos][1] = -2036.8796,
				PlayerData[playerid][pPos][2] = 69.0078;
				PlayerData[playerid][pPos][3] = 90.1180;
				InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
			}
			if(pData[playerid][pFaction] == 2)
	        {
		        pData[playerid][PilihSpawn] = 0;
			    SetPlayerPos(playerid, 1146.6381,-2037.2225,69.0078);
			    SetPlayerFacingAngle(playerid, 82.7700);
			    SuccesMsg(playerid, "Anda Spawn Di kantor pemerintahan Konoha");
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
				SetPlayerVirtualWorld(playerid, 0);
	   			SetPlayerInterior(playerid, 0);
	   			PlayerData[playerid][pPos][0] = 1146.6381,
				PlayerData[playerid][pPos][1] = -2037.2225,
				PlayerData[playerid][pPos][2] = 69.0078;
				PlayerData[playerid][pPos][3] = 82.7700;
				InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
			}
			if(pData[playerid][pFaction] == 3)
	        {
		        pData[playerid][PilihSpawn] = 0;
			    SetPlayerPos(playerid, 1177.9443,-1323.3846,14.0957);
			    SetPlayerFacingAngle(playerid, 267.7228);
			    SuccesMsg(playerid, "Anda Spawn Di Rumah Sakit Konoha");
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
				SetPlayerVirtualWorld(playerid, 0);
	   			SetPlayerInterior(playerid, 0);
	   			PlayerData[playerid][pPos][0] = 1177.9443,
				PlayerData[playerid][pPos][1] = -1323.3846,
				PlayerData[playerid][pPos][2] = 14.0957;
				PlayerData[playerid][pPos][3] = 267.7228;
				InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
			}
			if(pData[playerid][pFaction] == 4)
	        {
		        pData[playerid][PilihSpawn] = 0;
			    SetPlayerPos(playerid, 643.0523,-1360.7532,13.5887);
			    SetPlayerFacingAngle(playerid, 93.6608);
			    SuccesMsg(playerid, "Anda Spawn Di kantor berita Konoha");
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
				SetPlayerVirtualWorld(playerid, 0);
	   			SetPlayerInterior(playerid, 0);
	   			PlayerData[playerid][pPos][0] = 643.0523,
				PlayerData[playerid][pPos][1] = -1360.7532,
				PlayerData[playerid][pPos][2] = 13.5887;
				PlayerData[playerid][pPos][3] = 93.6608;
				InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
			}
			if(pData[playerid][pFaction] == 5)
	        {
		        pData[playerid][PilihSpawn] = 0;
			    SetPlayerPos(playerid, 1202.5819,-952.3196,42.9258);
			    SetPlayerFacingAngle(playerid, 8.5301);
			    SuccesMsg(playerid, "Anda Spawn Di Pedagang Konoha");
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
				SetPlayerVirtualWorld(playerid, 0);
	   			SetPlayerInterior(playerid, 0);
	   			PlayerData[playerid][pPos][0] =  1202.5819,
				PlayerData[playerid][pPos][1] = -952.3196,
				PlayerData[playerid][pPos][2] = 42.9258;
				PlayerData[playerid][pPos][3] = 8.5301;
				InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
			}
			if(pData[playerid][pFaction] == 6)
	        {
		        pData[playerid][PilihSpawn] = 0;
			    SetPlayerPos(playerid, 1224.3972,-1816.0796,16.5938);
			    SetPlayerFacingAngle(playerid, 175.1182);
			    SuccesMsg(playerid, "Anda Spawn Di Gojek Konoha");
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
				SetPlayerVirtualWorld(playerid, 0);
	   			SetPlayerInterior(playerid, 0);
	   			PlayerData[playerid][pPos][0] = 1224.3972,
				PlayerData[playerid][pPos][1] = -1816.0796,
				PlayerData[playerid][pPos][2] = 16.5938;
				PlayerData[playerid][pPos][3] = 175.1182;
				InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
			}
			if(pData[playerid][pFaction] == 7)
	        {
		        pData[playerid][PilihSpawn] = 0;
		        //-75.7975,-1573.5862,2.6430,41.9648
			    SetPlayerPos(playerid, 1799.2003,-2066.1726,13.5689);
			    SetPlayerFacingAngle(playerid, 3.9499);
			    SuccesMsg(playerid, "Anda Spawn Di Mekanik");
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
				SetPlayerVirtualWorld(playerid, 0);
	   			SetPlayerInterior(playerid, 0);
	   			PlayerData[playerid][pPos][0] = 1799.2003,
				PlayerData[playerid][pPos][1] = -2066.1726,
				PlayerData[playerid][pPos][2] = 13.5689;
				PlayerData[playerid][pPos][3] = 3.9499;
				InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
			}			
		}

		else if(pData[playerid][PilihSpawn] == 3)
	    {
	        pData[playerid][PilihSpawn] = 0;
		    SetPlayerInterior(playerid, pData[playerid][pInt]);
			SetPlayerVirtualWorld(playerid, pData[playerid][pWorld]);
			SetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
			SetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 0);
			SetPlayerSpawn(playerid);
			LoadAnims(playerid);
			PlayerData[playerid][pPos][0] = pData[playerid][pPosX],
			PlayerData[playerid][pPos][1] = pData[playerid][pPosY],
			PlayerData[playerid][pPos][2] = pData[playerid][pPosZ];
			PlayerData[playerid][pPos][3] = pData[playerid][pPosA];
			InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
		}
		    for(new i = 0; i < 13; i++)
			{
				TextDrawHideForPlayer(playerid, TDSpawnBYDAYSAMP[i]);
				TextDrawHideForPlayer(playerid, SpawnBandara);
				TextDrawHideForPlayer(playerid, SpawnKapal);
				TextDrawHideForPlayer(playerid, SpawnHouse);
				TextDrawHideForPlayer(playerid, SpawnFaction);
				TextDrawHideForPlayer(playerid, SpawnLastExit);
				TextDrawHideForPlayer(playerid, TombolSpawn);
				CancelSelectTextDraw(playerid);
			}
			SetTimerEx("SetPlayerCameraBehind", 2500, false, "i", playerid);
	}	
	if(pData[playerid][pVtoySelect] != -1 && pData[playerid][pGetVTOYID] != -1)
	{
		new vehicleid = pData[playerid][pGetVTOYID], slotid = pData[playerid][pVtoySelect];
		if(clickedid == ModTD[0])
		{
			new Float:posisi = vToys[vehicleid][slotid][vtX]+0.1;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);
			
			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				posisi, 
				vToys[vehicleid][slotid][vtY], 
				vToys[vehicleid][slotid][vtZ], 
				vToys[vehicleid][slotid][vtRX], 
				vToys[vehicleid][slotid][vtRY], 
				vToys[vehicleid][slotid][vtRZ]);

			vToys[vehicleid][slotid][vtX] = posisi;

			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
		}
		else if(clickedid == ModTD[1])
		{
			new Float:posisi = vToys[vehicleid][slotid][vtX]-0.1;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				posisi, 
				vToys[vehicleid][slotid][vtY], 
				vToys[vehicleid][slotid][vtZ], 
				vToys[vehicleid][slotid][vtRX], 
				vToys[vehicleid][slotid][vtRY], 
				vToys[vehicleid][slotid][vtRZ]);

			vToys[vehicleid][slotid][vtX] = posisi;

			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
		}
		else if(clickedid == ModTD[2])
		{
			new Float:posisi = vToys[vehicleid][slotid][vtY]+0.1;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				posisi, 
				vToys[vehicleid][slotid][vtZ], 
				vToys[vehicleid][slotid][vtRX], 
				vToys[vehicleid][slotid][vtRY], 
				vToys[vehicleid][slotid][vtRZ]);

			vToys[vehicleid][slotid][vtY] = posisi;

			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
		}
		else if(clickedid == ModTD[3])
		{
			new Float:posisi = vToys[vehicleid][slotid][vtY]-0.1;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				posisi, 
				vToys[vehicleid][slotid][vtZ], 
				vToys[vehicleid][slotid][vtRX], 
				vToys[vehicleid][slotid][vtRY], 
				vToys[vehicleid][slotid][vtRZ]);

			vToys[vehicleid][slotid][vtY] = posisi;

			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
		}
		else if(clickedid == ModTD[4])
		{
			new Float:posisi = vToys[vehicleid][slotid][vtZ]+0.1;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				vToys[vehicleid][slotid][vtY], 
				posisi, 
				vToys[vehicleid][slotid][vtRX], 
				vToys[vehicleid][slotid][vtRY], 
				vToys[vehicleid][slotid][vtRZ]);

			vToys[vehicleid][slotid][vtZ] = posisi;

			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
		}
		else if(clickedid == ModTD[5])
		{
			new Float:posisi = vToys[vehicleid][slotid][vtZ]-0.1;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				vToys[vehicleid][slotid][vtY], 
				posisi, 
				vToys[vehicleid][slotid][vtRX], 
				vToys[vehicleid][slotid][vtRY], 
				vToys[vehicleid][slotid][vtRZ]);

			vToys[vehicleid][slotid][vtZ] = posisi;

			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
		}

		else if(clickedid == ModTD[6])
		{
			new Float:posisi = vToys[vehicleid][slotid][vtRX]+22.5;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				vToys[vehicleid][slotid][vtY], 
				vToys[vehicleid][slotid][vtZ], 
				posisi, 
				vToys[vehicleid][slotid][vtRY], 
				vToys[vehicleid][slotid][vtRZ]);

			vToys[vehicleid][slotid][vtRX] = posisi;

			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
		}
		else if(clickedid == ModTD[7])
		{
			new Float:posisi = vToys[vehicleid][slotid][vtRX]-22.5;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				vToys[vehicleid][slotid][vtY], 
				vToys[vehicleid][slotid][vtZ], 
				posisi, 
				vToys[vehicleid][slotid][vtRY], 
				vToys[vehicleid][slotid][vtRZ]);

			vToys[vehicleid][slotid][vtRX] = posisi;

			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
		}
		else if(clickedid == ModTD[8])
		{
			new Float:posisi = vToys[vehicleid][slotid][vtRY]+22.5;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				vToys[vehicleid][slotid][vtY], 
				vToys[vehicleid][slotid][vtZ], 
				vToys[vehicleid][slotid][vtRX], 
				posisi, 
				vToys[vehicleid][slotid][vtRZ]);

			vToys[vehicleid][slotid][vtRY] = posisi;

			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
		}
		else if(clickedid == ModTD[9])
		{
			new Float:posisi = vToys[vehicleid][slotid][vtRY]-22.5;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				vToys[vehicleid][slotid][vtY], 
				vToys[vehicleid][slotid][vtZ], 
				vToys[vehicleid][slotid][vtRX], 
				posisi, 
				vToys[vehicleid][slotid][vtRZ]);

			vToys[vehicleid][slotid][vtRY] = posisi;

			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
		}
		else if(clickedid == ModTD[10])
		{
			new Float:posisi = vToys[vehicleid][slotid][vtRZ]+22.5;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				vToys[vehicleid][slotid][vtY], 
				vToys[vehicleid][slotid][vtZ], 
				vToys[vehicleid][slotid][vtRX], 
				vToys[vehicleid][slotid][vtRY], 
				posisi);

			vToys[vehicleid][slotid][vtRZ] = posisi;

			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
		}
		else if(clickedid == ModTD[11])
		{
			new Float:posisi = vToys[vehicleid][slotid][vtRZ]-22.5;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
				vehicleid,
				vToys[vehicleid][slotid][vtX], 
				vToys[vehicleid][slotid][vtY], 
				vToys[vehicleid][slotid][vtZ], 
				vToys[vehicleid][slotid][vtRX], 
				vToys[vehicleid][slotid][vtRY], 
				posisi);

			vToys[vehicleid][slotid][vtRZ] = posisi;

			SetPVarInt(vehicleid, "UpdatedVtoy", 1);
		}
		else if(clickedid == ModTD[18])
		{
			for(new i = 0; i <= 18; i++)
			{
				TextDrawHideForPlayer(playerid, ModTD[i]);
			}

			//Clear Edit Progress
			CancelSelectTextDraw(playerid);
			TogglePlayerControllable(playerid, 1);
			MySQL_SaveVehicleToys(vehicleid);
			
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

			pData[playerid][pGetVTOYID] = -1;
			pData[playerid][pVtoySelect] = -1;

			GameTextForPlayer(playerid, "~g~~h~Vehicle Toy Position Updated~y~!", 4000, 5);
		}
	}
	if(clickedid == HPLOCKSCREEN[19])//Close HP
	{
		for(new i = 0; i < 28; i++)
		{
			TextDrawHideForPlayer(playerid, HPLOCKSCREEN[i]);
		}
		CancelSelectTextDraw(playerid);
		RemovePlayerAttachedObject(playerid, 9);
		callcmd::stopanim(playerid, "");
		//ClearAnimations(playerid);
	}
	if(clickedid == HPLOCKSCREEN[27])//Sidik Jari
	{
		for(new i = 0; i < 28; i++)
		{
			TextDrawHideForPlayer(playerid, HPLOCKSCREEN[i]);
		}
		ShowMenuHP(playerid);
	}
	//Menu Screen
	if(clickedid == HPMENUSCREEN[19])//Close Menu HP
	{
		HideMenuHP(playerid);
		for(new i = 0; i < 28; i++)
		{
			TextDrawShowForPlayer(playerid, HPLOCKSCREEN[i]);
		}
	}
	if(clickedid == HPMENUSCREEN[39])//Gojek
	{
		HideMenuHP(playerid);

		new AtmInfo[560];
	   	format(AtmInfo,1000,"%s", FormatMoney(pData[playerid][pGopay]));
		TextDrawSetString(APKGOJEK[28], AtmInfo);

		for(new i = 0; i < 49; i++)
		{
			TextDrawShowForPlayer(playerid, APKGOJEK[i]);
		}
	}
	if(clickedid == APKGOJEK[19])//Close Gojek
	{
		for(new i = 0; i < 49; i++)
		{
			TextDrawHideForPlayer(playerid, APKGOJEK[i]);
		}
		ShowMenuHP(playerid);
	}
	if(clickedid == APKGOJEK[34]) //Gojek Pay
	{
		ShowPlayerDialog(playerid, DIALOG_GOPAY, DIALOG_STYLE_INPUT, "GoJek App - Pay", "Masukan jumlah uang yang ingin anda bayar", "Input", "Kembali");	
	}
	if(clickedid == APKGOJEK[36]) //Gojek TopUp
	{
		ShowPlayerDialog(playerid, DIALOG_GOTOPUP, DIALOG_STYLE_INPUT, "GoJek App - TopUp", "Masukan jumlah gopay yang ingin anda topup", "Input", "Kembali");
	}
	if(clickedid == APKGOJEK[40]) //Go Ride
	{
	    ShowPlayerDialog(playerid, DIALOG_GOJEK, DIALOG_STYLE_INPUT, "GoJek App - Pesan GoJek", "Hai, kamu akan memesan GoJek. Mau kemana hari ini?", "Pesan", "Kembali");
	}
	if(clickedid == APKGOJEK[43]) // Go Car
	{
	    ShowPlayerDialog(playerid, DIALOG_GOCAR, DIALOG_STYLE_INPUT, "GoJek App - Pesan GoCar", "Hai, kamu akan memesan GoCar. Mau kemana hari ini?", "Pesan", "Kembali");
	}
	if(clickedid == APKGOJEK[46]) // Go Food
	{
		ShowPlayerDialog(playerid, DIALOG_GOFOOD, DIALOG_STYLE_INPUT, "GoJek App - Pesan GoFood", "Hai, kamu akan memesan GoFood. Mau makan apa hari ini?", "Pesan", "Kembali");
	}
	if(clickedid == HPMENUSCREEN[35])//Kontak
	{
		DisplayContact(playerid);
	}
	if(clickedid == HPMENUSCREEN[52])//ADS
	{
		ShowAdsLog(playerid);
	}
	if(clickedid == HPMENUSCREEN[48])//GPS
	{
		ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "{FF0000}Disable GPS{ffffff}\nPublic GPS\nPersonal GPS\nNearest GPS\nJobs Location\nSide Jobs", "Select", "Close");
	}
	if(clickedid == HPMENUSCREEN[56])//Twitter
	{
		new str[128];
		format(str, sizeof(str), "Set Username\nPost Message");
		ShowPlayerDialog(playerid, TWITTER_MENU, DIALOG_STYLE_LIST, "Twitter Application", str, "Select", "No");
	}
	if(clickedid == HPMENUSCREEN[31])//SMS
	{
		ShowPlayerDialog(playerid, DIALOG_WASSAP, DIALOG_STYLE_LIST, "Handphone - Message", "Shareloc\nMessage", "Pilih", "Kembali");
	}
	if(clickedid == HPMENUSCREEN[26])//TLP
	{
		if(pData[playerid][pUsePhone] == 0) 
			return Error(playerid, "Handphone anda mati nyalakan terlebih dahulu di setting");

		ShowPlayerDialog(playerid, DIALOG_PHONE_DIALUMBER, DIALOG_STYLE_INPUT, "Nomor Telpon", "Masukkan Nomor telpon yang ingin anda telpon", "telpon", "Kembali");
	}
	if(clickedid == HPMENUSCREEN[45]) // Settings
	{
		ShowPlayerDialog(playerid, DIALOG_PANELPHONE, DIALOG_STYLE_LIST, "Handphone - Setting", "Tentang Ponsel\nSettings", "Select", "Back");
	}
	if(clickedid == HPMENUSCREEN[61])//BRI
	{
		HideMenuHP(playerid);

		new AtmInfo[560];
	   	format(AtmInfo,1000,"%s", FormatMoney(pData[playerid][pBankMoney]));
		TextDrawSetString(APKBRIMO[31], AtmInfo);
		format(AtmInfo,1000,"%d", pData[playerid][pBankRek]);
		TextDrawSetString(APKBRIMO[33], AtmInfo);

		for(new i = 0; i < 56; i++)
		{
			TextDrawShowForPlayer(playerid, APKBRIMO[i]);
		}
	}
	if(clickedid == APKBRIMO[19])//close bri
	{
		for(new i = 0; i < 56; i++)
		{
			TextDrawHideForPlayer(playerid, APKBRIMO[i]);
		}
		ShowMenuHP(playerid);
	}
	if(clickedid == APKBRIMO[50])//TF
	{
		ShowPlayerDialog(playerid, DIALOG_ATMREKENING, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan jumlah uang:", "Transfer", "Cancel");
	}
	if(clickedid == APKBRIMO[43])//MyTax
	{
		new str[128];
		format(str, sizeof(str), "Business Tax\nHouse Tax\nDealer Tax\nVending Tax");
		ShowPlayerDialog(playerid, MYTAX_MENU, DIALOG_STYLE_LIST, "MyTax", str, "Select", "No");
	}
	if(clickedid == APKBRIMO[43])//Invoice
	{
		new header[1400], count = 0;
	    new bool:status = false;
	    format(header, sizeof(header), "Faction\tFrom\tBill Name\tAmount\n");
	    foreach(new i: tagihan)
	    {
	    	new fac[64];
			if(bilData[i][bilType] == 1)
			{
				fac = "Police";
			}
			else if(bilData[i][bilType] == 2)
			{
				fac = "Goverment";
			}
			else if(bilData[i][bilType] == 3)
			{
				fac = "Medic";
			}
			else if(bilData[i][bilType] == 4)
			{
				fac = "News";
			}
			else if(bilData[i][bilType] == 5)
			{
				fac = "Pedagang";
			}
			else if(bilData[i][bilType] == 6)
			{
				fac = "Gojek";
			}
			else if(bilData[i][bilType] == 7)
			{
				fac = "Mekanik";
			}
	        if(i != -1)
	        {
	            if(bilData[i][bilTarget] == pData[playerid][pID])
	            {
	                format(header, sizeof(header), "%s\t%s\t%s\t%s\t{00ff00}%s\n", header, fac, bilData[i][billoName], bilData[i][bilName], FormatMoney(bilData[i][bilammount]));
	                count++;
	                status = true;
	            }
	        }
	    }
	    if(status)
	    {
	        ShowPlayerDialog(playerid, DIALOG_PAYBILL, DIALOG_STYLE_TABLIST_HEADERS, "My invoice", header, "Pay", "back");
	    }
	    else
	    {
	        Error(playerid, "You have no bills");
	    }
	}
	//ATM
	if(clickedid == ATMValrise[7])//Keluar Atm atau Hide Textdraw ATM
	{
		for(new i = 0; i < 23; i++)
		{
			TextDrawHideForPlayer(playerid, ATMValrise[i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(clickedid == ATMValrise[14])// Deposit
	{
		new mstr[512];
		format(mstr, sizeof(mstr), "{F6F6F6}Kamu punya "LB_E"%s {F6F6F6}di rekening.\n\nMasukan jumlah yang ingin Anda simpan di bawah:", FormatMoney(pData[playerid][pBankMoney]));
		ShowPlayerDialog(playerid, DIALOG_BANKDEPOSIT, DIALOG_STYLE_INPUT, ""LB_E"ATM", mstr, "Deposit", "Cancel");
		//ShowPlayerDialog(playerid, DIALOG_BANKDEPOSIT, DIALOG_STYLE_INPUT, "ATM - Deposit", "Mohon masukan berapa jumlah yang ingin disimpan:", "Simpan", "Batal");
	}
	if(clickedid == ATMValrise[16])// Withdraw
	{
		new id = -1;
		id = GetClosestATM(playerid);
		new str[512];
		format(str, sizeof(str), ""WHITE_E"Atm Stock: "YELLOW_E"%s\n"WHITE_E"Uang Direkening: "GREEN_LIGHT"%s\n\n"WHITE_E"Masukan jumlah uang yang ingin kamu withdraw:", FormatMoney(AtmData[id][atmStock]), FormatMoney(pData[playerid][pBankMoney]));
		ShowPlayerDialog(playerid, DIALOG_ATMWITHDRAW, DIALOG_STYLE_INPUT, "Atm Withdraw", str, "Withdraw", "Cancel");
	}
	if(clickedid == ATMValrise[18])// Transfer
	{
		ShowPlayerDialog(playerid, DIALOG_ATMREKENING, DIALOG_STYLE_INPUT, ""LB_E"ATM", "Masukan jumlah uang:", "Transfer", "Cancel");
	}
	if(clickedid == ATMValrise[20])// Paycheck
	{
		DisplayPaycheck(playerid);
	}
	//BANK
	if(clickedid == TDBANKAJI[16])// Account Home
	{
		new mstr[512];
		format(mstr, sizeof(mstr), ""ORANGE_E"No Rek. "LB_E"%d\n"ORANGE_E"Name Account "LB_E"%s", pData[playerid][pBankRek], pData[playerid][pName]);
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""LB_E"Bank", mstr, "Close", "");
	}
	if(clickedid == TDBANKAJI[18])// Deposit
	{
		new mstr[512];
		format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in bank account.\n\nType in the amount you want to deposit below:", FormatMoney(pData[playerid][pBankMoney]));
		ShowPlayerDialog(playerid, DIALOG_BANKDEPOSIT, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Deposit", "Cancel");
	}
	if(clickedid == TDBANKAJI[20])// Withdraw
	{
		new mstr[512];
		format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.\n\nType in the amount you want to withdraw below:", FormatMoney(pData[playerid][pBankMoney]));
		ShowPlayerDialog(playerid, DIALOG_BANKWITHDRAW, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Withdraw", "Cancel");
	}
	if(clickedid == TDBANKAJI[22])// Transfer
	{
		ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan jumlah uang:", "Transfer", "Cancel");
	}
	if(clickedid == TDBANKAJI[24])// Paycheck
	{
		DisplayPaycheck(playerid);
	}
	if(clickedid == TDBANKAJI[46])// wd 500
	{
	    if(pData[playerid][pBankMoney] < 500) return ErrorMsg(playerid, "Anda tidak memiliki $500 di dalam rekening");
        pData[playerid][pBankMoney] -= 500;
		GivePlayerMoneyEx(playerid, 500);
		SuccesMsg(playerid, "Anda Withdraw $500 dari akun rekening");
		new string[256];
		format(string, 1000, "%s", FormatMoney(pData[playerid][pBankMoney]));
		TextDrawSetString(TDBANKAJI[37], string);
		TextDrawShowForPlayer(playerid, TDBANKAJI[37]);
	}
	if(clickedid == TDBANKAJI[48])// wd 50000
	{
		if(pData[playerid][pBankMoney] < 50000) return ErrorMsg(playerid, "Anda tidak memiliki $50000 di dalam rekening");
        pData[playerid][pBankMoney] -= 50000;
		GivePlayerMoneyEx(playerid, 50000);
		SuccesMsg(playerid, "Anda Withdraw $50000 dari akun rekening");
		new string[256];
		format(string, 1000, "%s", FormatMoney(pData[playerid][pBankMoney]));
		TextDrawSetString(TDBANKAJI[37], string);
		TextDrawShowForPlayer(playerid, TDBANKAJI[37]);
	}
	if(clickedid == TDBANKAJI[50])// wd 500000
	{
		if(pData[playerid][pBankMoney] < 500000) return ErrorMsg(playerid, "Anda tidak memiliki $500000 di dalam rekening");
        pData[playerid][pBankMoney] -= 500000;
		GivePlayerMoneyEx(playerid, 500000);
		SuccesMsg(playerid, "Anda Withdraw $500000 dari akun rekening");
		new string[256];
		format(string, 1000, "%s", FormatMoney(pData[playerid][pBankMoney]));
		TextDrawSetString(TDBANKAJI[37], string);
		TextDrawShowForPlayer(playerid, TDBANKAJI[37]);
	}
	if(clickedid == TDBANKAJI[52])//depo 500
	{
		if(pData[playerid][pMoney] < 500) return ErrorMsg(playerid, "Anda tidak memiliki $500 di dalam kantong");
        pData[playerid][pBankMoney] += 500;
		GivePlayerMoneyEx(playerid, -500);
		SuccesMsg(playerid, "Anda telah deposit $500 ke dalam akun rekening");
		new string[256];
		format(string, 1000, "%s", FormatMoney(pData[playerid][pBankMoney]));
		TextDrawSetString(TDBANKAJI[37], string);
		TextDrawShowForPlayer(playerid, TDBANKAJI[37]);
	}
	if(clickedid == TDBANKAJI[54])//
	{
		if(pData[playerid][pMoney] < 50000) return ErrorMsg(playerid, "Anda tidak memiliki $50000 di dalam kantong");
        pData[playerid][pBankMoney] += 50000;
		GivePlayerMoneyEx(playerid, -50000);
		SuccesMsg(playerid, "Anda telah deposit $50000 ke dalam akun rekening");
		new string[256];
		format(string, 1000, "%s", FormatMoney(pData[playerid][pBankMoney]));
		TextDrawSetString(TDBANKAJI[37], string);
		TextDrawShowForPlayer(playerid, TDBANKAJI[37]);
	}
	if(clickedid == TDBANKAJI[56])//
	{
		if(pData[playerid][pMoney] < 500000) return ErrorMsg(playerid, "Anda tidak memiliki $500000 di dalam kantong");
        pData[playerid][pBankMoney] += 500000;
		GivePlayerMoneyEx(playerid, -500000);
		SuccesMsg(playerid, "Anda telah deposit $500000 ke dalam akun rekening");
		new string[256];
		format(string, 1000, "%s", FormatMoney(pData[playerid][pBankMoney]));
		TextDrawSetString(TDBANKAJI[37], string);
		TextDrawShowForPlayer(playerid, TDBANKAJI[37]);
	}
	//=====[BAJU SYSTEM GEN]===
	if(clickedid == MENUBAJU[1])//exit
	{
	    SetPlayerSkin(playerid, pData[playerid][pSkin]);
        for(new i = 0; i < 8; i++)
		{
			TextDrawHideForPlayer(playerid, MENUBAJU[i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(clickedid == MENUBAJU[3])//baju
	{
		for(new i = 0; i < 8; i++)
		{
			TextDrawHideForPlayer(playerid, MENUBAJU[i]);
		}

	    TextDrawShowForPlayer(playerid, PILIHANBAJU[0]);
		TextDrawShowForPlayer(playerid, PILIHANBAJU[1]);
		TextDrawShowForPlayer(playerid, PILIHANBAJU[2]);
		TextDrawShowForPlayer(playerid, PILIHANBAJU[3]);
		TextDrawShowForPlayer(playerid, PILIHANBAJU[4]);
		TextDrawShowForPlayer(playerid, PILIHANBAJU[5]);
		TextDrawShowForPlayer(playerid, PILIHANBAJU[6]);
		TextDrawShowForPlayer(playerid, PILIHANBAJU[7]);
	}
	if(clickedid == MENUBAJU[5])//aksesoris
	{
	    for(new i = 0; i < 8; i++)
		{
			TextDrawHideForPlayer(playerid, MENUBAJU[i]);
		}
		CancelSelectTextDraw(playerid);
	    new string[248];
		if(pToys[playerid][0][toy_model] == 0)
		{
			strcat(string, ""dot"Slot 1\n");
		}
		else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

		if(pToys[playerid][1][toy_model] == 0)
		{
			strcat(string, ""dot"Slot 2\n");
		}
		else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

		if(pToys[playerid][2][toy_model] == 0)
		{
			strcat(string, ""dot"Slot 3\n");
		}
		else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

		if(pToys[playerid][3][toy_model] == 0)
		{
			strcat(string, ""dot"Slot 4\n");
		}
		else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");
		ShowPlayerDialog(playerid, DIALOG_TOYBUY, DIALOG_STYLE_LIST, "Konoha - Aksesoris", string, "Pilih", "Batal");
	}
	if(clickedid == PILIHANBAJU[0])//kiri
	{
	    cskin[playerid]--;
 		if(pData[playerid][pGender] == 1)
  		{
   			if(cskin[playerid] < 0) cskin[playerid] = sizeof PedMan - 1;
    		SetPlayerSkin(playerid, PedMan[cskin[playerid]]);
		}
		else
		{
			if(cskin[playerid] < 0) cskin[playerid] = sizeof PedMale - 1;
			SetPlayerSkin(playerid, PedMale[cskin[playerid]]);
		}
		return 1;
	}
	if(clickedid == PILIHANBAJU[1])//kanan
	{
	    cskin[playerid]++;
   		if(pData[playerid][pGender] == 1)
    	{
   			if(cskin[playerid] >= sizeof PedMan) cskin[playerid] = 0;
			SetPlayerSkin(playerid, PedMan[cskin[playerid]]);
		}
		else
		{
			if(cskin[playerid] >= sizeof PedMale) cskin[playerid] = 0;
			SetPlayerSkin(playerid, PedMale[cskin[playerid]]);
		}
		return 1;
	}
	if(clickedid == PILIHANBAJU[4])//beli
	{
	    pData[playerid][pSkin] = GetPlayerSkin(playerid);
        GivePlayerMoneyEx(playerid, -100);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s telah membeli baju seharga $100 <", ReturnName(playerid));
        ShowItemBox(playerid, "Uang", "Removed_$100", 1212, 3);
    	for(new i = 0; i < 8; i++)
		{
			TextDrawHideForPlayer(playerid, PILIHANBAJU[i]);
		}
		CancelSelectTextDraw(playerid);
		return 1;
	}
	if(clickedid == PILIHANBAJU[6])//exit
	{
	    SetPlayerSkin(playerid, pData[playerid][pSkin]);
	    for(new i = 0; i < 8; i++)
		{
			TextDrawHideForPlayer(playerid, PILIHANBAJU[i]);
		}
		CancelSelectTextDraw(playerid);
	}
	//Market Textdraw
	if(clickedid == NoMarket[8]) 
	{
	    for(new i = 0; i < 32; i++)
		{
			TextDrawHideForPlayer(playerid, NoMarket[i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(clickedid == NoMarket[1])
	{
	    static bizid = -1, price;
	    
	    if((bizid = pData[playerid][pInBiz]) != -1)
		{
			price = bData2[bizid][bP2][0];
			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Anda tidak memiliki uang!");

            if(price == 0)
				return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

			if(bData2[bizid][bProd2] < 1)
				return ErrorMsg(playerid, "Produk ini habis!");

			if(pData[playerid][pSprunk] > 15) return ErrorMsg(playerid, "Anda tidak bisa membeli lebih dari 15");

			GivePlayerMoneyEx(playerid, -price);
			pData[playerid][pSprunk]++;
			ShowItemBox(playerid, "Water", "Received_1x", 2958, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s membeli water seharga %s.", ReturnName(playerid), FormatMoney(price));
			bData2[bizid][bProd2]--;
			bData2[bizid][bMoney2] += Server_Percent(price);
			Server_AddPercent(price);

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
			mysql_tquery(g_SQL, query);
		}
	}
	if(clickedid == NoMarket[2])
	{
	    static bizid = -1, price;

	    if((bizid = pData[playerid][pInBiz]) != -1)
		{
			price = bData2[bizid][bP2][4];
			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Anda tidak memiliki uang!");

            if(price == 0)
				return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

			if(bData2[bizid][bProd2] < 1)
				return ErrorMsg(playerid, "Produk ini habis!");

            if(pData[playerid][pSnack] > 15) return ErrorMsg(playerid, "Anda tidak bisa membeli lebih dari 15");

			GivePlayerMoneyEx(playerid, -price);
			pData[playerid][pSnack]++;
			ShowItemBox(playerid, "Snack", "Received_1x", 2821, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s membeli Snack seharga %s.", ReturnName(playerid), FormatMoney(price));
			bData2[bizid][bProd2]--;
			bData2[bizid][bMoney2] += Server_Percent(price);
			Server_AddPercent(price);

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
			mysql_tquery(g_SQL, query);
		}
	}
	if(clickedid == NoMarket[4])
	{
	    static bizid = -1, price;

	    if((bizid = pData[playerid][pInBiz]) != -1)
		{
			price = bData2[bizid][bP2][6];
			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Anda tidak memiliki uang!");

            if(price == 0)
				return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

			if(bData2[bizid][bProd2] < 1)
				return ErrorMsg(playerid, "Produk ini habis!");

            if(pData[playerid][pCappucino] > 15) return ErrorMsg(playerid, "Anda tidak bisa membeli lebih dari 15");

			GivePlayerMoneyEx(playerid, -price);
			pData[playerid][pCappucino]++;
			ShowItemBox(playerid, "Cappucino", "Received_1x", 19835, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s membeli Cappucino seharga %s.", ReturnName(playerid), FormatMoney(price));
			bData2[bizid][bProd2]--;
			bData2[bizid][bMoney2] += Server_Percent(price);
			Server_AddPercent(price);

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
			mysql_tquery(g_SQL, query);
		}
	}
	/*if(clickedid == MarketIndoSans[6])
	{
	    static bizid = -1, price;

	    if((bizid = pData[playerid][pInBiz]) != -1)
		{
			price = bData2[bizid][bP2][2];
			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Anda tidak memiliki uang!");

            if(price == 0)
				return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

			if(bData2[bizid][bProd2] < 1)
				return ErrorMsg(playerid, "Produk ini habis!");

            if(pData[playerid][pKebab] > 15) return ErrorMsg(playerid, "Anda tidak bisa membeli lebih dari 15");

			GivePlayerMoneyEx(playerid, -price);
			pData[playerid][pKebab]++;
			ShowItemBox(playerid, "Kebab", "Received_1x", 2769, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s membeli Kebab seharga %s.", ReturnName(playerid), FormatMoney(price));
			bData2[bizid][bProd2]--;
			bData2[bizid][bMoney2] += Server_Percent(price);
			Server_AddPercent(price);

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
			mysql_tquery(g_SQL, query);
		}
	}*/
	if(clickedid == NoMarket[5])
	{
	    static bizid = -1, price;

	    if((bizid = pData[playerid][pInBiz]) != -1)
		{
			price = bData2[bizid][bP2][1];
			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Anda tidak memiliki uang!");

            if(price == 0)
				return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

			if(bData2[bizid][bProd2] < 1)
				return ErrorMsg(playerid, "Produk ini habis!");

            if(pData[playerid][pMilxMax] > 15) return ErrorMsg(playerid, "Anda tidak bisa membeli lebih dari 15");

			GivePlayerMoneyEx(playerid, -price);
			pData[playerid][pMilxMax]++;
			ShowItemBox(playerid, "Milx_Max", "Received_1x", 19570, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s membeli MilxMax seharga %s.", ReturnName(playerid), FormatMoney(price));
			bData2[bizid][bProd2]--;
			bData2[bizid][bMoney2] += Server_Percent(price);
			Server_AddPercent(price);

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
			mysql_tquery(g_SQL, query);
		}
	}
	if(clickedid ==  NoMarket[3])
	{
	    static bizid = -1, price;

	    if((bizid = pData[playerid][pInBiz]) != -1)
		{
			price = bData2[bizid][bP2][5];
			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Anda tidak memiliki uang!");

            if(price == 0)
				return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

			if(bData2[bizid][bProd2] < 1)
				return ErrorMsg(playerid, "Produk ini habis!");

            if(pData[playerid][pStarling] > 15) return ErrorMsg(playerid, "Anda tidak bisa membeli lebih dari 15");

			GivePlayerMoneyEx(playerid, -price);
			pData[playerid][pStarling]++;
			ShowItemBox(playerid, "Starling", "Received_1x", 1455, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s membeli minuman Starling seharga %s.", ReturnName(playerid), FormatMoney(price));
			bData2[bizid][bProd2]--;
			bData2[bizid][bMoney2] += Server_Percent(price);
			Server_AddPercent(price);

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
			mysql_tquery(g_SQL, query);
		}
	}
	if(clickedid == NoMarket[7])
	{
	    static bizid = -1, price;

	    if((bizid = pData[playerid][pInBiz]) != -1)
		{
	 		price = bData2[bizid][bP2][3];
			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Anda tidak memiliki uang!");
				
            if(price == 0)
				return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

			if(bData2[bizid][bProd2] < 1)
				return ErrorMsg(playerid, "Produk ini habis!");

            if(pData[playerid][pRoti] > 15) return ErrorMsg(playerid, "Anda tidak bisa membeli lebih dari 15");

			GivePlayerMoneyEx(playerid, -price);
			pData[playerid][pRoti]++;
			ShowItemBox(playerid, "Roti", "Received_1x", 19883, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s telah membeli Roti seharga %s.", ReturnName(playerid), FormatMoney(price));
			bData2[bizid][bProd2]--;
			bData2[bizid][bMoney2] += Server_Percent(price);
			Server_AddPercent(price);

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET prod='%d', money='%d' WHERE ID='%d'", bData2[bizid][bProd2], bData2[bizid][bMoney2], bizid);
			mysql_tquery(g_SQL, query);
		}
	}
	return 1;
}

CMD:atmaji(playerid)
{
	for(new i = 0; i < 59; i++)
	{
		TextDrawShowForPlayer(playerid, TDBANKAJI[i]);
	}
	SelectTextDraw(playerid, COLOR_LBLUE);
	return 1;
}

function ShowMenuHP(playerid)
{
	for(new i = 0; i < 65; i++)
	{
		TextDrawShowForPlayer(playerid, HPMENUSCREEN[i]);
	}
}

function HideMenuHP(playerid)
{
	for(new i = 0; i < 65; i++)
	{
		TextDrawHideForPlayer(playerid, HPMENUSCREEN[i]);
	}
}

//Genzo improve
public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT: objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(response == EDIT_RESPONSE_FINAL)
	{
		if(IsPlayerEditingTags(playerid))
		{
			if(!IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z))
				return Tags_Menu(playerid), Tags_ObjectSync(playerid, true), Error(playerid, "Posisi "YELLOW_E"object "WHITE_E"melebihi "ORANGE_E"5 meter "WHITE_E"dari posisimu!!");

			SetPVarFloat(playerid, "TagsPosX", x);
			SetPVarFloat(playerid, "TagsPosY", y);
			SetPVarFloat(playerid, "TagsPosZ", z);

			SetPVarFloat(playerid, "TagsPosRX", rx);
			SetPVarFloat(playerid, "TagsPosRY", ry);
			SetPVarFloat(playerid, "TagsPosRZ", rz);

			Tags_Menu(playerid);
			Tags_ObjectSync(playerid);

			Servers(playerid, "Sukses memperbaharui posisi "YELLOW_E"object");
			return 1;
		}
		if(pData[playerid][pVtoySelect] != -1 && pData[playerid][pGetVTOYID] != -1)
		{
			new vehicleid = pData[playerid][pGetVTOYID];
			GameTextForPlayer(playerid, "~g~~h~Toy Position Updated~y~!", 4000, 5);
			new slotid = pData[playerid][pVtoySelect];

			vToys[vehicleid][slotid][vtX] = x;
			vToys[vehicleid][slotid][vtY] = y;
			vToys[vehicleid][slotid][vtZ] = z;

			vToys[vehicleid][slotid][vtRX] = rx;
			vToys[vehicleid][slotid][vtRY] = ry;
			vToys[vehicleid][slotid][vtRZ] = rz;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
			vehicleid,
			vToys[vehicleid][slotid][vtX], 
			vToys[vehicleid][slotid][vtY], 
			vToys[vehicleid][slotid][vtZ], 
			vToys[vehicleid][slotid][vtRX], 
			vToys[vehicleid][slotid][vtRY], 
			vToys[vehicleid][slotid][vtRZ]);

			foreach(new i : PVehicles)
			{
				if(vehicleid == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
				}
			}
			TogglePlayerControllable(playerid, 1);
			return 1;
		}
		if(pData[playerid][EditingATMID] != -1 && Iter_Contains(ATMS, pData[playerid][EditingATMID]))
		{
			new etid = pData[playerid][EditingATMID];
	        AtmData[etid][atmX] = x;
	        AtmData[etid][atmY] = y;
	        AtmData[etid][atmZ] = z;
	        AtmData[etid][atmRX] = rx;
	        AtmData[etid][atmRY] = ry;
	        AtmData[etid][atmRZ] = rz;

	        SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
	        SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_X, AtmData[etid][atmX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_Y, AtmData[etid][atmY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_Z, AtmData[etid][atmZ] + 0.3);

		    Atm_Save(etid);
	        pData[playerid][EditingATMID] = -1;
	        return 1;
		}
		if(pData[playerid][EditingMAPOID] != -1 && Iter_Contains(MAPO, pData[playerid][EditingMAPOID]))
		{
			new mapoid = pData[playerid][EditingMAPOID];
	        MapoData[mapoid][mapoX] = x;
	        MapoData[mapoid][mapoY] = y;
	        MapoData[mapoid][mapoZ] = z;
	        MapoData[mapoid][mapoRX] = rx;
	        MapoData[mapoid][mapoRY] = ry;
	        MapoData[mapoid][mapoRZ] = rz;

	        SetDynamicObjectPos(objectid, MapoData[mapoid][mapoX], MapoData[mapoid][mapoY], MapoData[mapoid][mapoZ]);
	        SetDynamicObjectRot(objectid, MapoData[mapoid][mapoRX], MapoData[mapoid][mapoRY], MapoData[mapoid][mapoRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, MapoData[mapoid][mapoLabel], E_STREAMER_X, MapoData[mapoid][mapoX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, MapoData[mapoid][mapoLabel], E_STREAMER_Y, MapoData[mapoid][mapoY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, MapoData[mapoid][mapoLabel], E_STREAMER_Z, MapoData[mapoid][mapoZ] + 0.3);

		    Mapo_Save(mapoid);
	        pData[playerid][EditingMAPOID] = -1;
	        return 1;
		}
		if(pData[playerid][EditingMATEID] != -1 && Iter_Contains(Matext, pData[playerid][EditingMATEID]))
		{
			new mtid = pData[playerid][EditingMATEID];
	        mtData[mtid][mtX] = x;
	        mtData[mtid][mtY] = y;
	        mtData[mtid][mtZ] = z;
	        mtData[mtid][mtRX] = rx;
	        mtData[mtid][mtRY] = ry;
	        mtData[mtid][mtRZ] = rz;

	        SetDynamicObjectPos(objectid, mtData[mtid][mtX], mtData[mtid][mtY], mtData[mtid][mtZ]);
	        SetDynamicObjectRot(objectid, mtData[mtid][mtRX], mtData[mtid][mtRY], mtData[mtid][mtRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, mtData[mtid][mtLabel], E_STREAMER_X, mtData[mtid][mtX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, mtData[mtid][mtLabel], E_STREAMER_Y, mtData[mtid][mtY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, mtData[mtid][mtLabel], E_STREAMER_Z, mtData[mtid][mtZ] + 1.5);

		    Matext_Save(mtid);
	        pData[playerid][EditingMATEID] = -1;
			return 1;
		}
		if(pData[playerid][EditingVENID] != -1 && Iter_Contains(Vending, pData[playerid][EditingVENID]))
		{
			new venid = pData[playerid][EditingVENID];
	        vmData[venid][venX] = x;
	        vmData[venid][venY] = y;
	        vmData[venid][venZ] = z;
	        vmData[venid][venRX] = rx;
	        vmData[venid][venRY] = ry;
	        vmData[venid][venRZ] = rz;

	        SetDynamicObjectPos(objectid, vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]);
	        SetDynamicObjectRot(objectid, vmData[venid][venRX], vmData[venid][venRY], vmData[venid][venRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, vmData[venid][venLabel], E_STREAMER_X, vmData[venid][venX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, vmData[venid][venLabel], E_STREAMER_Y, vmData[venid][venY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, vmData[venid][venLabel], E_STREAMER_Z, vmData[venid][venZ] + 1.5);

		    Vending_Save(venid);
	        pData[playerid][EditingVENID] = -1;
	        return 1;
		}
		if(pData[playerid][EditingSPEEDCAM] != -1 && Iter_Contains(Speedcam, pData[playerid][EditingSPEEDCAM]))
		{
			new camid = pData[playerid][EditingSPEEDCAM];
	        camData[camid][camX] = x;
	        camData[camid][camY] = y;
	        camData[camid][camZ] = z;
	        camData[camid][camRX] = rx;
	        camData[camid][camRY] = ry;
	        camData[camid][camRZ] = rz;

	        SetDynamicObjectPos(objectid, camData[camid][camX], camData[camid][camY], camData[camid][camZ]);
	        SetDynamicObjectRot(objectid, camData[camid][camRX], camData[camid][camRY], camData[camid][camRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, camData[camid][camLabel], E_STREAMER_X, camData[camid][camX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, camData[camid][camLabel], E_STREAMER_Y, camData[camid][camY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, camData[camid][camLabel], E_STREAMER_Z, camData[camid][camZ] + 3.5);

		    Speedcam_Save(camid);
	        pData[playerid][EditingSPEEDCAM] = -1;
	        return 1;
		}
		if(pData[playerid][pGetPAYPHONEID] != -1 && Iter_Contains(Payphone, pData[playerid][pGetPAYPHONEID]))
		{
			new ppid = pData[playerid][pGetPAYPHONEID];

	        ppData[ppid][ppX] = x;
	        ppData[ppid][ppY] = y;
	        ppData[ppid][ppZ] = z;

	        ppData[ppid][ppRX] = rx;
	        ppData[ppid][ppRY] = ry;
	        ppData[ppid][ppRZ] = rz;

	        SetDynamicObjectPos(objectid, ppData[ppid][ppX], ppData[ppid][ppY], ppData[ppid][ppZ]);
	        SetDynamicObjectRot(objectid, ppData[ppid][ppRX], ppData[ppid][ppRY], ppData[ppid][ppRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ppData[ppid][ppLabel], E_STREAMER_X, ppData[ppid][ppX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ppData[ppid][ppLabel], E_STREAMER_Y, ppData[ppid][ppY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ppData[ppid][ppLabel], E_STREAMER_Z, ppData[ppid][ppZ] + 1.0);

		    Payphone_Save(ppid);
	        pData[playerid][pGetPAYPHONEID] = -1;
	        return 1;
		}
	}
	if(response == EDIT_RESPONSE_CANCEL)
	{
		if(IsPlayerEditingTags(playerid))
		{
			Tags_Menu(playerid);
			Tags_ObjectSync(playerid, true);

			Error(playerid, "Gagal memperbaharui posisi object, object akan berubah keposisi sebelumnya.");
			return 1;
		}
		if(pData[playerid][pVtoySelect] != -1 && pData[playerid][pGetVTOYID] != -1)
		{
			new vehicleid = pData[playerid][pGetVTOYID];
			GameTextForPlayer(playerid, "~r~~h~Selection Cancelled~y~!", 4000, 5);
			new slotid = pData[playerid][pVtoySelect];

			vToys[vehicleid][slotid][vtX] = x;
			vToys[vehicleid][slotid][vtY] = y;
			vToys[vehicleid][slotid][vtZ] = z;

			vToys[vehicleid][slotid][vtRX] = rx;
			vToys[vehicleid][slotid][vtRY] = ry;
			vToys[vehicleid][slotid][vtRZ] = rz;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
			vehicleid,
			vToys[vehicleid][slotid][vtX], 
			vToys[vehicleid][slotid][vtY], 
			vToys[vehicleid][slotid][vtZ], 
			vToys[vehicleid][slotid][vtRX], 
			vToys[vehicleid][slotid][vtRY], 
			vToys[vehicleid][slotid][vtRZ]);

			TogglePlayerControllable(playerid, 1);
			return 1;
		}
		if(pData[playerid][EditingATMID] != -1 && Iter_Contains(ATMS, pData[playerid][EditingATMID]))
		{
			new etid = pData[playerid][EditingATMID];
	        SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
	        SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);
	        pData[playerid][EditingATMID] = -1;
	        return 1;
		}
		if(pData[playerid][EditingMAPOID] != -1 && Iter_Contains(MAPO, pData[playerid][EditingMAPOID]))
		{
			new mapoid = pData[playerid][EditingMAPOID];
	        SetDynamicObjectPos(objectid, MapoData[mapoid][mapoX], MapoData[mapoid][mapoY], MapoData[mapoid][mapoZ]);
	        SetDynamicObjectRot(objectid, MapoData[mapoid][mapoRX], MapoData[mapoid][mapoRY], MapoData[mapoid][mapoRZ]);
	        pData[playerid][EditingMAPOID] = -1;
			return 1;
		}
		if(pData[playerid][EditingMATEID] != -1 && Iter_Contains(Matext, pData[playerid][EditingMATEID]))
		{
			new mtid = pData[playerid][EditingMATEID];
	        SetDynamicObjectPos(objectid, mtData[mtid][mtX], mtData[mtid][mtY], mtData[mtid][mtZ]);
	        SetDynamicObjectRot(objectid, mtData[mtid][mtRX], mtData[mtid][mtRY], mtData[mtid][mtRZ]);
	        pData[playerid][EditingMATEID] = -1;
			return 1;
		}
		if(pData[playerid][EditingVENID] != -1 && Iter_Contains(Vending, pData[playerid][EditingVENID]))
		{
			new venid = pData[playerid][EditingVENID];
	        SetDynamicObjectPos(objectid, vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]);
	        SetDynamicObjectRot(objectid, vmData[venid][venRX], vmData[venid][venRY], vmData[venid][venRZ]);
	        pData[playerid][EditingVENID] = -1;
	        return 1;
		}
		if(pData[playerid][EditingSPEEDCAM] != -1 && Iter_Contains(Speedcam, pData[playerid][EditingSPEEDCAM]))
		{
			new camid = pData[playerid][EditingSPEEDCAM];
	        SetDynamicObjectPos(objectid, camData[camid][camX], camData[camid][camY], camData[camid][camZ]);
	        SetDynamicObjectRot(objectid, camData[camid][camRX], camData[camid][camRY], camData[camid][camRZ]);
	        pData[playerid][EditingSPEEDCAM] = -1;
			return 1;
		}
		if(pData[playerid][pGetPAYPHONEID] != -1 && Iter_Contains(Payphone, pData[playerid][pGetPAYPHONEID]))
		{
			new ppid = pData[playerid][pGetPAYPHONEID];

	        SetDynamicObjectPos(objectid, ppData[ppid][ppX], ppData[ppid][ppY], ppData[ppid][ppZ]);
	        SetDynamicObjectRot(objectid, ppData[ppid][ppRX], ppData[ppid][ppRY], ppData[ppid][ppRZ]);

	        pData[playerid][pGetPAYPHONEID] = -1;
			return 1;
		}
	}
	if(pData[playerid][gEditID] != -1 && Iter_Contains(Gates, pData[playerid][gEditID]))
	{
		new id = pData[playerid][gEditID];
		if(response == EDIT_RESPONSE_UPDATE)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
		}
		else if(response == EDIT_RESPONSE_CANCEL)
		{
			SetDynamicObjectPos(objectid, gPosX[playerid], gPosY[playerid], gPosZ[playerid]);
			SetDynamicObjectRot(objectid, gRotX[playerid], gRotY[playerid], gRotZ[playerid]);
			gPosX[playerid] = 0; gPosY[playerid] = 0; gPosZ[playerid] = 0;
			gRotX[playerid] = 0; gRotY[playerid] = 0; gRotZ[playerid] = 0;
			Servers(playerid, " You have canceled editing gate ID %d.", id);
			Gate_Save(id);
		}
		else if(response == EDIT_RESPONSE_FINAL)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
			if(pData[playerid][gEdit] == 1)
			{
				gData[id][gCX] = x;
				gData[id][gCY] = y;
				gData[id][gCZ] = z;
				gData[id][gCRX] = rx;
				gData[id][gCRY] = ry;
				gData[id][gCRZ] = rz;
				if(IsValidDynamic3DTextLabel(gData[id][gText])) DestroyDynamic3DTextLabel(gData[id][gText]);
				new str[64];
				format(str, sizeof(str), "Gate ID: %d", id);
				gData[id][gText] = CreateDynamic3DTextLabel(str, COLOR_WHITE, gData[id][gCX], gData[id][gCY], gData[id][gCZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
				
				pData[playerid][gEditID] = -1;
				pData[playerid][gEdit] = 0;
				Servers(playerid, " You have finished editing gate ID %d's closing position.", id);
				gData[id][gStatus] = 0;
				Gate_Save(id);
			}
			else if(pData[playerid][gEdit] == 2)
			{
				gData[id][gOX] = x;
				gData[id][gOY] = y;
				gData[id][gOZ] = z;
				gData[id][gORX] = rx;
				gData[id][gORY] = ry;
				gData[id][gORZ] = rz;
				
				pData[playerid][gEditID] = -1;
				pData[playerid][gEdit] = 0;
				Servers(playerid, " You have finished editing gate ID %d's opening position.", id);

				gData[id][gStatus] = 1;
				Gate_Save(id);
			}
		}
	}
	if(pData[playerid][EditingTRASHID] != -1 && Iter_Contains(Trash, pData[playerid][EditingTRASHID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new tid = pData[playerid][EditingTRASHID];
	        tmData[tid][tmX] = x;
	        tmData[tid][tmY] = y;
	        tmData[tid][tmZ] = z;
	        tmData[tid][tmRX] = rx;
	        tmData[tid][tmRY] = ry;
	        tmData[tid][tmRZ] = rz;

	        SetDynamicObjectPos(objectid, tmData[tid][tmX], tmData[tid][tmY], tmData[tid][tmZ]);
	        SetDynamicObjectRot(objectid, tmData[tid][tmRX], tmData[tid][tmRY], tmData[tid][tmRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, tmData[tid][tmLabel], E_STREAMER_X, tmData[tid][tmX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, tmData[tid][tmLabel], E_STREAMER_Y, tmData[tid][tmY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, tmData[tid][tmLabel], E_STREAMER_Z, tmData[tid][tmZ] + 0.3);

		    Trash_Save(tid);
	        pData[playerid][EditingTRASHID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new tid = pData[playerid][EditingTRASHID];
	        SetDynamicObjectPos(objectid, tmData[tid][tmX], tmData[tid][tmY], tmData[tid][tmZ]);
	        SetDynamicObjectRot(objectid, tmData[tid][tmRX], tmData[tid][tmRY], tmData[tid][tmRZ]);
	        pData[playerid][EditingTRASHID] = -1;
	    }
	}		
	return 1;
}

/*public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT: objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(IsPlayerEditingTags(playerid))
	{
		if(response == EDIT_RESPONSE_FINAL)
		{
			if(!IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z))
				return Tags_Menu(playerid), Tags_ObjectSync(playerid, true), Error(playerid, "Posisi "YELLOW_E"object "WHITE_E"melebihi "ORANGE_E"5 meter "WHITE_E"dari posisimu!!");

			SetPVarFloat(playerid, "TagsPosX", x);
			SetPVarFloat(playerid, "TagsPosY", y);
			SetPVarFloat(playerid, "TagsPosZ", z);

			SetPVarFloat(playerid, "TagsPosRX", rx);
			SetPVarFloat(playerid, "TagsPosRY", ry);
			SetPVarFloat(playerid, "TagsPosRZ", rz);

			Tags_Menu(playerid);
			Tags_ObjectSync(playerid);

			Servers(playerid, "Sukses memperbaharui posisi "YELLOW_E"object");
		}
		else if(response == EDIT_RESPONSE_CANCEL)
		{			
			Tags_Menu(playerid);
			Tags_ObjectSync(playerid, true);

			Error(playerid, "Gagal memperbaharui posisi object, object akan berubah keposisi sebelumnya.");
		}
	}
	if(pData[playerid][pVtoySelect] != -1 && pData[playerid][pGetVTOYID] != -1)
	{
		new vehicleid = pData[playerid][pGetVTOYID];
		if(response == EDIT_RESPONSE_FINAL)
		{
			GameTextForPlayer(playerid, "~g~~h~Toy Position Updated~y~!", 4000, 5);
			new slotid = pData[playerid][pVtoySelect];

			vToys[vehicleid][slotid][vtX] = x;
			vToys[vehicleid][slotid][vtY] = y;
			vToys[vehicleid][slotid][vtZ] = z;

			vToys[vehicleid][slotid][vtRX] = rx;
			vToys[vehicleid][slotid][vtRY] = ry;
			vToys[vehicleid][slotid][vtRZ] = rz;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
			vehicleid,
			vToys[vehicleid][slotid][vtX], 
			vToys[vehicleid][slotid][vtY], 
			vToys[vehicleid][slotid][vtZ], 
			vToys[vehicleid][slotid][vtRX], 
			vToys[vehicleid][slotid][vtRY], 
			vToys[vehicleid][slotid][vtRZ]);

			foreach(new i : PVehicles)
			{
				if(vehicleid == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
				}
			}
			TogglePlayerControllable(playerid, 1);
		}
		else if(response == EDIT_RESPONSE_CANCEL)
		{
			GameTextForPlayer(playerid, "~r~~h~Selection Cancelled~y~!", 4000, 5);
			new slotid = pData[playerid][pVtoySelect];

			vToys[vehicleid][slotid][vtX] = x;
			vToys[vehicleid][slotid][vtY] = y;
			vToys[vehicleid][slotid][vtZ] = z;

			vToys[vehicleid][slotid][vtRX] = rx;
			vToys[vehicleid][slotid][vtRY] = ry;
			vToys[vehicleid][slotid][vtRZ] = rz;

			if(IsValidObject(vToys[vehicleid][slotid][vtObj]))
				DestroyObject(vToys[vehicleid][slotid][vtObj]);

			vToys[vehicleid][slotid][vtObj] = CreateObject(vToys[vehicleid][slotid][vtModelid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0);

			AttachObjectToVehicle(vToys[vehicleid][slotid][vtObj], 
			vehicleid,
			vToys[vehicleid][slotid][vtX], 
			vToys[vehicleid][slotid][vtY], 
			vToys[vehicleid][slotid][vtZ], 
			vToys[vehicleid][slotid][vtRX], 
			vToys[vehicleid][slotid][vtRY], 
			vToys[vehicleid][slotid][vtRZ]);

			TogglePlayerControllable(playerid, 1);
		}
	}
	if(pData[playerid][EditingTreeID] != -1 && Iter_Contains(Trees, pData[playerid][EditingTreeID]))
	{
	    if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingTreeID];
	        TreeData[etid][treeX] = x;
	        TreeData[etid][treeY] = y;
	        TreeData[etid][treeZ] = z;
	        TreeData[etid][treeRX] = rx;
	        TreeData[etid][treeRY] = ry;
	        TreeData[etid][treeRZ] = rz;

	        SetDynamicObjectPos(objectid, TreeData[etid][treeX], TreeData[etid][treeY], TreeData[etid][treeZ]);
	        SetDynamicObjectRot(objectid, TreeData[etid][treeRX], TreeData[etid][treeRY], TreeData[etid][treeRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[etid][treeLabel], E_STREAMER_X, TreeData[etid][treeX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[etid][treeLabel], E_STREAMER_Y, TreeData[etid][treeY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[etid][treeLabel], E_STREAMER_Z, TreeData[etid][treeZ] + 1.5);

		    Tree_Save(etid);
	        pData[playerid][EditingTreeID] = -1;
	    }

	    else if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingTreeID];
	        SetDynamicObjectPos(objectid, TreeData[etid][treeX], TreeData[etid][treeY], TreeData[etid][treeZ]);
	        SetDynamicObjectRot(objectid, TreeData[etid][treeRX], TreeData[etid][treeRY], TreeData[etid][treeRZ]);
	        pData[playerid][EditingTreeID] = -1;
	    }
	}
	if(pData[playerid][EditingATMID] != -1 && Iter_Contains(ATMS, pData[playerid][EditingATMID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingATMID];
	        AtmData[etid][atmX] = x;
	        AtmData[etid][atmY] = y;
	        AtmData[etid][atmZ] = z;
	        AtmData[etid][atmRX] = rx;
	        AtmData[etid][atmRY] = ry;
	        AtmData[etid][atmRZ] = rz;

	        SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
	        SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_X, AtmData[etid][atmX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_Y, AtmData[etid][atmY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_Z, AtmData[etid][atmZ] + 0.3);

		    Atm_Save(etid);
	        pData[playerid][EditingATMID] = -1;
	    }

	    else if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingATMID];
	        SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
	        SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);
	        pData[playerid][EditingATMID] = -1;
	    }
	}
	if(pData[playerid][EditingMAPOID] != -1 && Iter_Contains(MAPO, pData[playerid][EditingMAPOID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new mapoid = pData[playerid][EditingMAPOID];
	        MapoData[mapoid][mapoX] = x;
	        MapoData[mapoid][mapoY] = y;
	        MapoData[mapoid][mapoZ] = z;
	        MapoData[mapoid][mapoRX] = rx;
	        MapoData[mapoid][mapoRY] = ry;
	        MapoData[mapoid][mapoRZ] = rz;

	        SetDynamicObjectPos(objectid, MapoData[mapoid][mapoX], MapoData[mapoid][mapoY], MapoData[mapoid][mapoZ]);
	        SetDynamicObjectRot(objectid, MapoData[mapoid][mapoRX], MapoData[mapoid][mapoRY], MapoData[mapoid][mapoRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, MapoData[mapoid][mapoLabel], E_STREAMER_X, MapoData[mapoid][mapoX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, MapoData[mapoid][mapoLabel], E_STREAMER_Y, MapoData[mapoid][mapoY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, MapoData[mapoid][mapoLabel], E_STREAMER_Z, MapoData[mapoid][mapoZ] + 0.3);

		    Mapo_Save(mapoid);
	        pData[playerid][EditingMAPOID] = -1;
	    }

	    else if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new mapoid = pData[playerid][EditingMAPOID];
	        SetDynamicObjectPos(objectid, MapoData[mapoid][mapoX], MapoData[mapoid][mapoY], MapoData[mapoid][mapoZ]);
	        SetDynamicObjectRot(objectid, MapoData[mapoid][mapoRX], MapoData[mapoid][mapoRY], MapoData[mapoid][mapoRZ]);
	        pData[playerid][EditingMAPOID] = -1;
	    }
	}
	if(pData[playerid][EditingMATEID] != -1 && Iter_Contains(Matext, pData[playerid][EditingMATEID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new mtid = pData[playerid][EditingMATEID];
	        mtData[mtid][mtX] = x;
	        mtData[mtid][mtY] = y;
	        mtData[mtid][mtZ] = z;
	        mtData[mtid][mtRX] = rx;
	        mtData[mtid][mtRY] = ry;
	        mtData[mtid][mtRZ] = rz;

	        SetDynamicObjectPos(objectid, mtData[mtid][mtX], mtData[mtid][mtY], mtData[mtid][mtZ]);
	        SetDynamicObjectRot(objectid, mtData[mtid][mtRX], mtData[mtid][mtRY], mtData[mtid][mtRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, mtData[mtid][mtLabel], E_STREAMER_X, mtData[mtid][mtX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, mtData[mtid][mtLabel], E_STREAMER_Y, mtData[mtid][mtY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, mtData[mtid][mtLabel], E_STREAMER_Z, mtData[mtid][mtZ] + 1.5);

		    Matext_Save(mtid);
	        pData[playerid][EditingMATEID] = -1;
	    }

	    else if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new mtid = pData[playerid][EditingMATEID];
	        SetDynamicObjectPos(objectid, mtData[mtid][mtX], mtData[mtid][mtY], mtData[mtid][mtZ]);
	        SetDynamicObjectRot(objectid, mtData[mtid][mtRX], mtData[mtid][mtRY], mtData[mtid][mtRZ]);
	        pData[playerid][EditingMATEID] = -1;
	    }
	}
	if(pData[playerid][EditingVENID] != -1 && Iter_Contains(Vending, pData[playerid][EditingVENID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new venid = pData[playerid][EditingVENID];
	        vmData[venid][venX] = x;
	        vmData[venid][venY] = y;
	        vmData[venid][venZ] = z;
	        vmData[venid][venRX] = rx;
	        vmData[venid][venRY] = ry;
	        vmData[venid][venRZ] = rz;

	        SetDynamicObjectPos(objectid, vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]);
	        SetDynamicObjectRot(objectid, vmData[venid][venRX], vmData[venid][venRY], vmData[venid][venRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, vmData[venid][venLabel], E_STREAMER_X, vmData[venid][venX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, vmData[venid][venLabel], E_STREAMER_Y, vmData[venid][venY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, vmData[venid][venLabel], E_STREAMER_Z, vmData[venid][venZ] + 1.5);

		    Vending_Save(venid);
	        pData[playerid][EditingVENID] = -1;
	    }

	    else if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new venid = pData[playerid][EditingVENID];
	        SetDynamicObjectPos(objectid, vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]);
	        SetDynamicObjectRot(objectid, vmData[venid][venRX], vmData[venid][venRY], vmData[venid][venRZ]);
	        pData[playerid][EditingVENID] = -1;
	    }
	}
	if(pData[playerid][EditingSPEEDCAM] != -1 && Iter_Contains(Speedcam, pData[playerid][EditingSPEEDCAM]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new camid = pData[playerid][EditingSPEEDCAM];
	        camData[camid][camX] = x;
	        camData[camid][camY] = y;
	        camData[camid][camZ] = z;
	        camData[camid][camRX] = rx;
	        camData[camid][camRY] = ry;
	        camData[camid][camRZ] = rz;

	        SetDynamicObjectPos(objectid, camData[camid][camX], camData[camid][camY], camData[camid][camZ]);
	        SetDynamicObjectRot(objectid, camData[camid][camRX], camData[camid][camRY], camData[camid][camRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, camData[camid][camLabel], E_STREAMER_X, camData[camid][camX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, camData[camid][camLabel], E_STREAMER_Y, camData[camid][camY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, camData[camid][camLabel], E_STREAMER_Z, camData[camid][camZ] + 3.5);

		    Speedcam_Save(camid);
	        pData[playerid][EditingSPEEDCAM] = -1;
	    }

	    else if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new camid = pData[playerid][EditingSPEEDCAM];
	        SetDynamicObjectPos(objectid, camData[camid][camX], camData[camid][camY], camData[camid][camZ]);
	        SetDynamicObjectRot(objectid, camData[camid][camRX], camData[camid][camRY], camData[camid][camRZ]);
	        pData[playerid][EditingSPEEDCAM] = -1;
	    }
	}
	if(pData[playerid][EditingTRASHID] != -1 && Iter_Contains(Trash, pData[playerid][EditingTRASHID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new trashid = pData[playerid][EditingTRASHID];
	        tmData[trashid][tmX] = x;
	        tmData[trashid][tmY] = y;
	        tmData[trashid][tmZ] = z;
	        tmData[trashid][tmRX] = rx;
	        tmData[trashid][tmRY] = ry;
	        tmData[trashid][tmRZ] = rz;

	        SetDynamicObjectPos(objectid, tmData[trashid][tmX], tmData[trashid][tmY], tmData[trashid][tmZ]);
	        SetDynamicObjectRot(objectid, tmData[trashid][tmRX], tmData[trashid][tmRY], tmData[trashid][tmRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, tmData[trashid][tmLabel], E_STREAMER_X, tmData[trashid][tmX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, tmData[trashid][tmLabel], E_STREAMER_Y, tmData[trashid][tmY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, tmData[trashid][tmLabel], E_STREAMER_Z, tmData[trashid][tmZ] + 0.5);

		    Trash_Save(trashid);
	        pData[playerid][EditingTRASHID] = -1;
	    }

	    else if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new trashid = pData[playerid][EditingTRASHID];
	        SetDynamicObjectPos(objectid, tmData[trashid][tmX], tmData[trashid][tmY], tmData[trashid][tmZ]);
	        SetDynamicObjectRot(objectid, tmData[trashid][tmRX], tmData[trashid][tmRY], tmData[trashid][tmRZ]);
	        pData[playerid][EditingTRASHID] = -1;
	    }
	}
	if(pData[playerid][EditingSIGNAL] != -1 && Iter_Contains(Signal, pData[playerid][EditingSIGNAL]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new sgid = pData[playerid][EditingSIGNAL];
	        sgData[sgid][sgX] = x;
	        sgData[sgid][sgY] = y;
	        sgData[sgid][sgZ] = z;
	        sgData[sgid][sgRX] = rx;
	        sgData[sgid][sgRY] = ry;
	        sgData[sgid][sgRZ] = rz;

	        SetDynamicObjectPos(objectid, sgData[sgid][sgX], sgData[sgid][sgY], sgData[sgid][sgZ]);
	        SetDynamicObjectRot(objectid, sgData[sgid][sgRX], sgData[sgid][sgRY], sgData[sgid][sgRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, sgData[sgid][sgLabel], E_STREAMER_X, sgData[sgid][sgX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, sgData[sgid][sgLabel], E_STREAMER_Y, sgData[sgid][sgY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, sgData[sgid][sgLabel], E_STREAMER_Z, sgData[sgid][sgZ] + 3.5);

		    Signal_Save(sgid);
	        pData[playerid][EditingSIGNAL] = -1;
	    }

	    else if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new sgid = pData[playerid][EditingSIGNAL];
	        SetDynamicObjectPos(objectid, sgData[sgid][sgX], sgData[sgid][sgY], sgData[sgid][sgZ]);
	        SetDynamicObjectRot(objectid, sgData[sgid][sgRX], sgData[sgid][sgRY], sgData[sgid][sgRZ]);
	        pData[playerid][EditingSIGNAL] = -1;
	    }
	}
	if(pData[playerid][pGetPAYPHONEID] != -1 && Iter_Contains(Payphone, pData[playerid][pGetPAYPHONEID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
		{
			new ppid = pData[playerid][pGetPAYPHONEID];

	        ppData[ppid][ppX] = x;
	        ppData[ppid][ppY] = y;
	        ppData[ppid][ppZ] = z;

	        ppData[ppid][ppRX] = rx;
	        ppData[ppid][ppRY] = ry;
	        ppData[ppid][ppRZ] = rz;

	        SetDynamicObjectPos(objectid, ppData[ppid][ppX], ppData[ppid][ppY], ppData[ppid][ppZ]);
	        SetDynamicObjectRot(objectid, ppData[ppid][ppRX], ppData[ppid][ppRY], ppData[ppid][ppRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ppData[ppid][ppLabel], E_STREAMER_X, ppData[ppid][ppX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ppData[ppid][ppLabel], E_STREAMER_Y, ppData[ppid][ppY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ppData[ppid][ppLabel], E_STREAMER_Z, ppData[ppid][ppZ] + 1.0);

		    Payphone_Save(ppid);
	        pData[playerid][pGetPAYPHONEID] = -1;
		}
		else if(response == EDIT_RESPONSE_CANCEL)
		{
			new ppid = pData[playerid][pGetPAYPHONEID];

	        SetDynamicObjectPos(objectid, ppData[ppid][ppX], ppData[ppid][ppY], ppData[ppid][ppZ]);
	        SetDynamicObjectRot(objectid, ppData[ppid][ppRX], ppData[ppid][ppRY], ppData[ppid][ppRZ]);

	        pData[playerid][pGetPAYPHONEID] = -1;
		}
	}
	if(pData[playerid][gEditID] != -1 && Iter_Contains(Gates, pData[playerid][gEditID]))
	{
		new id = pData[playerid][gEditID];
		if(response == EDIT_RESPONSE_UPDATE)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
		}
		else if(response == EDIT_RESPONSE_CANCEL)
		{
			SetDynamicObjectPos(objectid, gPosX[playerid], gPosY[playerid], gPosZ[playerid]);
			SetDynamicObjectRot(objectid, gRotX[playerid], gRotY[playerid], gRotZ[playerid]);
			gPosX[playerid] = 0; gPosY[playerid] = 0; gPosZ[playerid] = 0;
			gRotX[playerid] = 0; gRotY[playerid] = 0; gRotZ[playerid] = 0;
			Servers(playerid, " You have canceled editing gate ID %d.", id);
			Gate_Save(id);
		}
		else if(response == EDIT_RESPONSE_FINAL)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
			if(pData[playerid][gEdit] == 1)
			{
				gData[id][gCX] = x;
				gData[id][gCY] = y;
				gData[id][gCZ] = z;
				gData[id][gCRX] = rx;
				gData[id][gCRY] = ry;
				gData[id][gCRZ] = rz;
				if(IsValidDynamic3DTextLabel(gData[id][gText])) DestroyDynamic3DTextLabel(gData[id][gText]);
				new str[64];
				format(str, sizeof(str), "Gate ID: %d", id);
				gData[id][gText] = CreateDynamic3DTextLabel(str, COLOR_WHITE, gData[id][gCX], gData[id][gCY], gData[id][gCZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
				
				pData[playerid][gEditID] = -1;
				pData[playerid][gEdit] = 0;
				Servers(playerid, " You have finished editing gate ID %d's closing position.", id);
				gData[id][gStatus] = 0;
				Gate_Save(id);
			}
			else if(pData[playerid][gEdit] == 2)
			{
				gData[id][gOX] = x;
				gData[id][gOY] = y;
				gData[id][gOZ] = z;
				gData[id][gORX] = rx;
				gData[id][gORY] = ry;
				gData[id][gORZ] = rz;
				
				pData[playerid][gEditID] = -1;
				pData[playerid][gEdit] = 0;
				Servers(playerid, " You have finished editing gate ID %d's opening position.", id);

				gData[id][gStatus] = 1;
				Gate_Save(id);
			}
		}
	}
	if(response == EDIT_RESPONSE_CANCEL)
    {
        ResetEditing(playerid);
    }
	return 1;
}*/

function StressBerkurang(playerid)
{
	pData[playerid][pBladder] --;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(areaid == eaData[playerid][balkot])
	{
		Altgenzotd(playerid, "Untuk Menu pemerintah", 5);
	}
	if(areaid == eaData[playerid][centraljob])
	{
		Altgenzotd(playerid, "Mengambil Pekerjaan", 5);
	}
	//JOB AYAM 
	if(areaid == PemotongArea[playerid][AmbilAyamHidup1])
	{
		Altgenzotd(playerid, "Mengambil Ayam", 5);
	}
	if(areaid == PemotongArea[playerid][AmbilAyamHidup2])
	{
		Altgenzotd(playerid, "Mengambil Ayam", 5);
	}
	if(areaid == PemotongArea[playerid][AmbilAyamHidup3])
	{
		Altgenzotd(playerid, "Mengambil Ayam", 5);
	}
	if(areaid == PemotongArea[playerid][AmbilAyamHidup4])
	{
		Altgenzotd(playerid, "Mengambil Ayam", 5);
	}
	if(areaid == PemotongArea[playerid][AmbilAyamHidup5])
	{
		Altgenzotd(playerid, "Mengambil Ayam", 5);
	}
	if(areaid == PemotongArea[playerid][AmbilAyam])
	{
		Altgenzotd(playerid, "Memulai Mengambil Ayam", 5);
	}
	if(areaid == Healing)
	{
	    InfoMsg(playerid, "Anda memasuki Tempat Healing");
        pData[playerid][TempatHealing] = true;
	}
	if(IsPlayerConnected(playerid))
	{
		foreach(new bbid : Boombox)
		{
			if(Iter_Contains(Boombox, bbid))
			{
				if(areaid == bbData[bbid][bbAreaid])
				{
					Info(playerid, "Kamu telah memasuki area boombox (ID: %d)", bbid);
					PlayAudioStreamForPlayer(playerid, bbData[bbid][bbUrl], bbData[bbid][bbPosX], bbData[bbid][bbPosY], bbData[bbid][bbPosZ], 30.0, 1);
				}
			}
		}
		foreach(new bid : Bisnis)
		{
			if(Iter_Contains(Bisnis, bid))
			{
				if(areaid == bData[bid][bAreaid])
				{
					if(strcmp(bData[bid][bUrl], "-"))
					{
						PlayAudioStreamForPlayer(playerid, bData[bid][bUrl], bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ], 30.0, 1);
					}
					else
					{
						StopAudioStreamForPlayer(playerid);
					}
				}
			}
		}
		for(new ptid = 0; ptid < 10; ptid++)
		{
			if(areaid == PaytollAreaid[ptid])
			{
				GameTextForPlayer(playerid, "~w~~h~PAYTOLL AREA~n~~r~~h~ /PAYTOLL ~n~~w~~h~TO OPEN TOLL GATE", 3000, 4);
			}
		}
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		foreach(new id : Trash)
		{
			if(IsPlayerInDynamicArea(playerid, tmData[id][tdArea]))
			{
				if(areaid == tmData[id][tdArea])
				{
					Altgenzotd(playerid, "Untuk membuang sampah", 5);
				}
			}
		}
	}
	if(areaid == PenjualanBarang)
	{
	    Altgenzotd(playerid, "Menjual barang", 5);
	}
	//Penjahit
	if(areaid == buatbenang[0])
	{
	    Altgenzotd(playerid, "Membuat Benang", 5);
	}
	if(areaid == buatbenang[1])
	{
	    Altgenzotd(playerid, "Membuat Benang", 5);
	}
	if(areaid == buatkain[0])
	{
	    Altgenzotd(playerid, "Membuat Kain", 5);
	}
	if(areaid == buatkain[1])
	{
	    Altgenzotd(playerid, "Membuat Kain", 5);
	}
	if(areaid == buatkain[2])
	{
	    Altgenzotd(playerid, "Membuat Kain", 5);
	}
	if(areaid == buatpakaian[0])
	{
	    Altgenzotd(playerid, "Membuat Pakaian", 5);
	}
	if(areaid == buatpakaian[1])
	{
	    Altgenzotd(playerid, "Membuat Pakaian", 5);
	}
	if(areaid == buatpakaian[2])
	{
	    Altgenzotd(playerid, "Membuat Pakaian", 5);
	}
	if (areaid == AreaSendJob[areaTukangkayu][0]) 
	{
		Altgenzotd(playerid, "untuk memotong kayu", 5);
    }
    if (areaid == AreaSendJob[areaTukangkayu][1]) 
    {
        Altgenzotd(playerid, "untuk memotong kayu", 5);
    }
    if (areaid == AreaSendJob[areaTukangkayu][2]) 
    {
        Altgenzotd(playerid, "untuk memotong kayu", 5);
    }
    if (areaid == AreaSendJob[areaTukangkayu][3]) 
    {
        Altgenzotd(playerid, "untuk memotong kayu", 5);
    }

    if (areaid == AreaSendJob[areaTukangkayu][4]) 
    {
        Altgenzotd(playerid, "untuk gergaji kayu", 5);
    }
    if (areaid == AreaSendJob[areaTukangkayu][5]) 
    {
        Altgenzotd(playerid, "untuk gergaji kayu", 5);
    }
    if (areaid == AreaSendJob[areaTukangkayu][6]) 
    {
        Altgenzotd(playerid, "untuk kemas kayu", 5);
    }
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if (areaid == AreaSendJob[areaTukangkayu][4]) 
	{
        HideAltGen(playerid);
    }
    if (areaid == AreaSendJob[areaTukangkayu][5]) 
	{
        HideAltGen(playerid);
    }
    if (areaid == AreaSendJob[areaTukangkayu][6]) 
	{
        HideAltGen(playerid);
    }
	if (areaid == AreaSendJob[areaTukangkayu][0]) 
	{
        HideAltGen(playerid);
    }
    if (areaid == AreaSendJob[areaTukangkayu][1]) 
    {
        HideAltGen(playerid);
    }
    if (areaid == AreaSendJob[areaTukangkayu][2]) 
    {
        HideAltGen(playerid);
    }
    if (areaid == AreaSendJob[areaTukangkayu][3]) 
    {
        HideAltGen(playerid);
    }
	if(areaid == Healing)
	{
	    InfoMsg(playerid, "Anda telah meninggalkan Tempat Healing");
	    pData[playerid][TempatHealing] = false;
	    KillTimer(stresstimer[playerid]);
	}
	if(IsPlayerConnected(playerid))
	{
		foreach(new bbid : Boombox)
		{
			if(Iter_Contains(Boombox, bbid))
			{
				if(areaid == bbData[bbid][bbAreaid])
				{
					StopAudioStreamForPlayer(playerid);
				}
			}
		}
		foreach(new bid : Bisnis)
		{
			if(Iter_Contains(Bisnis, bid))
			{
				if(areaid == bData[bid][bAreaid])
				{
					StopAudioStreamForPlayer(playerid);
				}
			}
		}
		foreach(new ppid : Payphone)
		{
			if(Iter_Contains(Payphone, ppid))
			{
				if(areaid == ppData[ppid][ppAreaid])
				{
					if(pData[playerid][pGetPAYPHONEID] != -1)
					{
						new caller = pData[playerid][pCall];
						if(IsPlayerConnected(caller) && caller != INVALID_PLAYER_ID)
						{
							pData[caller][pCall] = INVALID_PLAYER_ID;
							SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
							SendNearbyMessage(caller, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(caller));
							
							pData[playerid][pCall] = INVALID_PLAYER_ID;
							SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s puts away their payphone.", ReturnName(playerid));
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
							
							Info(playerid, "Kamu terlalu jauh dari jarak payphone, dan panggilan dimatikan");
							
							pData[playerid][pGetPAYPHONEID] = -1;
							ppData[ppid][ppStatus] = 0;

							Payphone_Refresh(ppid);
							Payphone_Save(ppid);
						}
					}
				}
			}
		}
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if(checkpointid == BusArea[playerid][BusCp])
	{
		Altgenzotd(playerid, "Memulai pekerjaan", 5);
	}
	if(checkpointid == BusArea[playerid][BusCpBaru])
	{
		Altgenzotd(playerid, "Memulai pekerjaan", 5);
	}
	if(checkpointid == BusArea[playerid][BusCp3])
	{
		Altgenzotd(playerid, "Memulai pekerjaan", 5);
	}
	//JOB DAUR ULANG
	if(checkpointid == mulaikerja)
	{
		Altgenzotd(playerid, "Untuk Memulai kerja Recycle Rise", 5);
	}
	if(checkpointid == ambilbox)
	{
		Altgenzotd(playerid, "Untuk Mengambil box", 5);
	}
	if(checkpointid == ambilbox1)
	{
		Altgenzotd(playerid, "Untuk Mengambil box", 5);
	}
	if(checkpointid == ambilbox2)
	{
		Altgenzotd(playerid, "Untuk Mengambil box", 5);
	}
	if(checkpointid == nyortir1)
	{
		Altgenzotd(playerid, "Untuk Menyortir box", 5);
	}
	if(checkpointid == nyortir2)
	{
		Altgenzotd(playerid, "Untuk Menyortir box", 5);
	}
	if(checkpointid == nyortir3)
	{
		Altgenzotd(playerid, "Untuk Menyortir box", 5);
	}
	if(checkpointid == daurulangnya1)
	{
		Altgenzotd(playerid, "Untuk Mendaur ulang", 5);
	}
	if(checkpointid == daurulang2)
	{
		Altgenzotd(playerid, "Untuk Mendaur ulang", 5);
	}
	if(checkpointid == daurulang3)
	{
		Altgenzotd(playerid, "Untuk Mendaur ulang", 5);
	}
	if(checkpointid == jualdaurulang)
	{
		Altgenzotd(playerid, "Untuk menjual hasil daur ulang", 5);
	}
	//JOB PENAMBANG MINYAK
	if(checkpointid == MinyakArea[playerid][Nambang])
	{
		Altgenzotd(playerid, "Ambil Minyak", 5);
	}
	if(checkpointid == MinyakArea[playerid][Nambangg])
	{
		Altgenzotd(playerid, "Ambil Minyak", 5);
	}
	if(checkpointid == MinyakArea[playerid][OlahMinyak])
	{
		Altgenzotd(playerid, "Olah Minyak", 5);
	}
	//AYAM JOB
	if(checkpointid == PemotongArea[playerid][PotongAyam])
	{
		Altgenzotd(playerid, "Memotong Ayam", 5);
	}
	if(checkpointid == PemotongArea[playerid][PotongAyam2])
	{
		Altgenzotd(playerid, "Memotong Ayam", 5);
	}
	if(checkpointid == PemotongArea[playerid][PotongAyam3])
	{
		Altgenzotd(playerid, "Memotong Ayam", 5);
	}
	if(checkpointid == PemotongArea[playerid][PackingAyam2])
	{
		Altgenzotd(playerid, "Packing Ayam", 5);
	}
	if(checkpointid == PemotongArea[playerid][PackingAyam])
	{
		Altgenzotd(playerid, "Packing Ayam", 5);
	}
	// Petani
    if (checkpointid == petanipadi) 
    {
    	KeyYGen(playerid, "mengambil tractor", 5);
        //ShowInfo(playerid, "Tekan  ~g~Y ~w~ untuk mengambil tractor padi");
    }
    if (checkpointid == petanicabai) {
    	KeyYGen(playerid, "mengambil tractor", 5);
        //ShowInfo(playerid, "Tekan  ~g~Y ~w~ untuk mengambil tractor cabai");
    }
    if (checkpointid == petanitebu) {
    	KeyYGen(playerid, "mengambil tractor", 5);
        //ShowInfo(playerid, "Tekan  ~g~Y ~w~ untuk mengambil tractor tebu");
    }
    if (checkpointid == petanigaram) {
    	KeyYGen(playerid, "mengambil tractor", 5);
       // ShowInfo(playerid, "Tekan  ~g~Y ~w~ untuk mengambil tractor garam");
    }
	if(checkpointid == PenambangArea[playerid][Nambang])
	{
		Altgenzotd(playerid, "Memulai Menambang", 5);
	}
	if(checkpointid == PenambangArea[playerid][Nambang2])
	{
		Altgenzotd(playerid, "Memulai Menambang", 5);
	}
	if(checkpointid == PenambangArea[playerid][Nambang3])
	{
		Altgenzotd(playerid, "Memulai Menambang", 5);
	}
	if(checkpointid == PenambangArea[playerid][Nambang4])
	{
		Altgenzotd(playerid, "Memulai Menambang", 5);
	}
	if(checkpointid == PenambangArea[playerid][Nambang5])
	{
		Altgenzotd(playerid, "Memulai Menambang", 5);
	}
	if(checkpointid == PenambangArea[playerid][Nambang6])
	{
		Altgenzotd(playerid, "Memulai Menambang", 5);
	}
	if(checkpointid == PenambangArea[playerid][CuciBatu])
	{
		Altgenzotd(playerid, "Mencuci Batu", 5);
	}
	if(checkpointid == PenambangArea[playerid][Peleburan])
	{
		Altgenzotd(playerid, "Meleburkan Batu", 5);
	}
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	switch(pData[playerid][pCheckPoint])
	{
		case CHECKPOINT_BUS:
		{
			if(pData[playerid][pJob] == 27)
			{
				//new vehicleid = GetPlayerVehicleID(playerid);
				//if(GetVehicleModel(vehicleid) == 431)
				if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 431)
				{
					if(pData[playerid][pBus] == 1)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 2;
						SetPlayerRaceCheckpoint(playerid, 2, -479.5997,-605.5638,16.9304, -479.5997,-605.5638,16.9304, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 2)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 3;
						SetPlayerRaceCheckpoint(playerid, 2, -399.7464,-672.5795,16.1623, -399.7464,-672.5795,16.1623, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 3)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 4;
						SetPlayerRaceCheckpoint(playerid, 2, -343.7397,-782.2640,30.4623, -343.7397,-782.2640,30.4623, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 4)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 5;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint5, buspoint5, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 5)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 6;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint6, buspoint6, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 6)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 7;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint7, buspoint7, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 7)
					{
						//TogglePlayerControllable(playerid,0);
				        //pData[playerid][pBusWaiting] = 15;
				        //GameTextForPlayer(playerid, "~w~PLEASE WAIT~n~~y~15 SECOND", 2000, 6);
						pData[playerid][pBuswaiting] = true;
						pData[playerid][pBustime] = 10;
						PlayerPlaySound(playerid, 43000, -115.2943,-1159.4506,1.7561);
						return 1;
					}
					else if(pData[playerid][pBus] == 8)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 9;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint9, buspoint9, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 9)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 10;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint10, buspoint10, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 10)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 11;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint11, buspoint11, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 11)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 12;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint12, buspoint12, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 12)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 13;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint13, buspoint13, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 13)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 14;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint14, buspoint14, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 14)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 15;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint15, buspoint15, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 15)
					{
						pData[playerid][pBuswaiting] = true;
						pData[playerid][pBustime] = 10;
						PlayerPlaySound(playerid, 43000, 1172.1044,-1405.3931,12.8790);
						return 1;
					}
					else if(pData[playerid][pBus] == 16)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 17;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint17, buspoint17, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 17)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 18;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint18, buspoint18, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 18)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 19;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint19, buspoint19, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 19)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 20;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint20, buspoint20, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 20)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 21;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint21, buspoint21, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 21)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 22;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint22, buspoint22, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 22)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 23;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint23, buspoint23, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 23)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 24;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint24, buspoint24, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 24)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 25;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint25, buspoint25, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 25)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 26;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint26, buspoint26, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 26)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 27;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint27, buspoint27, 5.0);
						return 1;
						//pData[playerid][pBuswaiting] = true;
						//pData[playerid][pBustime] = 10;
						//PlayerPlaySound(playerid, 43000, 2763.975097,-2479.834228,13.575368);
					}
					else if(pData[playerid][pBus] == 27)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 28;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint28, buspoint28, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 28)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 29;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint29, buspoint29, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 29)
					{
						pData[playerid][pBuswaiting] = true;
						pData[playerid][pBustime] = 10;
						PlayerPlaySound(playerid, 43000, 1731.8765,-2319.6948,-3.2946);
						return 1;
						//DisablePlayerRaceCheckpoint(playerid);
						//pData[playerid][pBus] = 30;
						//SetPlayerRaceCheckpoint(playerid, 1, buspoint30, buspoint30, 5.0);
					}
					else if(pData[playerid][pBus] == 30)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 31;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint31, buspoint31, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 31)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 32;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint32, buspoint32, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 32)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 33;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint33, buspoint33, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 33)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 34;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint34, buspoint34, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 34)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 35;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint35, buspoint35, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 35)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 36;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint36, buspoint36, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 36)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 37;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint37, buspoint37, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 37)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 38;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint38, buspoint38, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 38)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 39;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint39, buspoint39, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 39)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 40;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint40, buspoint40, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 40)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 41;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint41, buspoint41, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 41)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 42;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint42, buspoint42, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 42)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 43;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint43, buspoint43, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 43)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 44;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint44, buspoint44, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 44)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 45;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint45, buspoint45, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 45)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 46;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint46, buspoint46, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 46)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 47;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint47, buspoint47, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 47)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 48;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint48, buspoint48, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 48)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 49;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint49, buspoint49, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 49)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 50;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint50, buspoint50, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 50)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 51;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint51, buspoint51, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 51)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 52;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint52, buspoint52, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 52)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 53;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint53, buspoint53, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 53)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 54;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint54, buspoint54, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 54)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 55;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint55, buspoint55, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 55)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 56;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint56, buspoint56, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 56)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 57;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint57, buspoint57, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 57)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 58;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint58, buspoint58, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 58)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 59;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint59, buspoint59, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 59)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 60;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint60, buspoint60, 5.0);
						return 1;
					}
					/*else if(pData[playerid][pBus] == 60)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 61;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint61, buspoint61, 5.0);
					}
					else if(pData[playerid][pBus] == 61)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 62;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint62, buspoint62, 5.0);
					}
					else if(pData[playerid][pBus] == 62)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 63;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint63, buspoint63, 5.0);
					}
					else if(pData[playerid][pBus] == 63)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 64;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint64, buspoint64, 5.0);
					}
					else if(pData[playerid][pBus] == 64)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 65;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint65, buspoint65, 5.0);
					}*/
					else if(pData[playerid][pBus] == 60)
					{
						pData[playerid][pBus] = 0;
						pData[playerid][pSideJob] = 0;
						pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
						DisablePlayerRaceCheckpoint(playerid);
					    GivePlayerMoneyEx(playerid, 760);
					    ShowItemBox(playerid, "Uang", "Received_$760", 1212, 4);
						RemovePlayerFromVehicle(playerid);
						if(IsValidVehicle(pData[playerid][pKendaraanKerja]))
   						DestroyVehicle(pData[playerid][pKendaraanKerja]);  //jika player disconnect maka kendaraan akan ilang
						return 1;
					}
					//bus rute baru
					else if(pData[playerid][pBus] == 66)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 67;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus2, cpbus2, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 67)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 68;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus3, cpbus3, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 68)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 69;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus4, cpbus4, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 69)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 70;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus5, cpbus5, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 70)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 71;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus6, cpbus6, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 71)
					{
						pData[playerid][pBuswaiting] = true;
						pData[playerid][pBustime] = 10;
						PlayerPlaySound(playerid, 43000, 2763.975097,-2479.834228,13.575368);
						return 1;
					}
					else if(pData[playerid][pBus] == 72)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 73;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus8, cpbus8, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 73)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 74;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus9, cpbus9, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 74)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 75;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus10, cpbus10, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 75)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 76;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus11, cpbus11, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 76)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 77;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus12, cpbus12, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 77)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 78;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus13, cpbus13, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 78)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 79;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus14, cpbus14, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 79)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 80;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus15, cpbus15, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 80)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 81;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus16, cpbus16, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 81)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 82;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus17, cpbus17, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 82)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 83;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus18, cpbus18, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 83)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 84;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus19, cpbus19, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 84)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 85;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus20, cpbus20, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 85)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 86;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus21, cpbus21, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 86)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 87;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus22, cpbus22, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 87)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 88;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus23, cpbus23, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 88)
					{
						pData[playerid][pBuswaiting] = true;
						pData[playerid][pBustime] = 10;
						PlayerPlaySound(playerid, 43000, 164.0048,1150.3789,14.4663);
						return 1;
					}
					else if(pData[playerid][pBus] == 89)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 90;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus25, cpbus25, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 90)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 91;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus26, cpbus26, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 91)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 92;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus27, cpbus27, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 92)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 93;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus28, cpbus28, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 93)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 94;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus29, cpbus29, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 94)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 95;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus30, cpbus30, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 95)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 96;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus31, cpbus31, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 96)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 97;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus32, cpbus32, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 97)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 98;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus33, cpbus33, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 98)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 99;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus34, cpbus34, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 99)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 100;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus35, cpbus35, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 100)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 101;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus36, cpbus36, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 101)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 102;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus37, cpbus37, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 102)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 103;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus38, cpbus38, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 103)
					{
						pData[playerid][pBuswaiting] = true;
						pData[playerid][pBustime] = 10;
						PlayerPlaySound(playerid, 43000, 526.4655,-109.1321,37.2908);
						return 1;
					}
					else if(pData[playerid][pBus] == 104)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 105;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus40, cpbus40, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 105)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 106;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus41, cpbus41, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 106)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 107;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus42, cpbus42, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 107)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 108;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus43, cpbus43, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 108)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 109;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus44, cpbus44, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 109)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 110;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus45, cpbus45, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 110)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 111;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus46, cpbus46, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 111)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 112;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus47, cpbus47, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 112)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 113;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus48, cpbus48, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 113)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 114;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus49, cpbus49, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 114)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 115;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus50, cpbus50, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 115)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 116;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus51, cpbus51, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 116)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 117;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus52, cpbus52, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 117)
					{
						pData[playerid][pBus] = 0;
						pData[playerid][pSideJob] = 0;
						pData[playerid][pBusTime] = 0;
						pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
						DisablePlayerRaceCheckpoint(playerid);
						GivePlayerMoneyEx(playerid, 900);
					    ShowItemBox(playerid, "Uang", "Received_$900", 1212, 4);
						RemovePlayerFromVehicle(playerid);
						if(IsValidVehicle(pData[playerid][pKendaraanKerja]))
   						DestroyVehicle(pData[playerid][pKendaraanKerja]);  //jika player disconnect maka kendaraan akan ilang
   						return 1;
					}
					//Bus Rute 3
					else if(pData[playerid][pBus] == 120)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 121;
						SetPlayerRaceCheckpoint(playerid, 2, buscp2, buscp2, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 121)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 122;
						SetPlayerRaceCheckpoint(playerid, 2, buscp3, buscp3, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 122)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 123;
						SetPlayerRaceCheckpoint(playerid, 2, buscp4, buscp4, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 123)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 124;
						SetPlayerRaceCheckpoint(playerid, 2, buscp5, buscp5, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 124)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 125;
						SetPlayerRaceCheckpoint(playerid, 2, buscp6, buscp6, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 125)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 126;
						SetPlayerRaceCheckpoint(playerid, 2, buscp7, buscp7, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 126)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 127;
						SetPlayerRaceCheckpoint(playerid, 2, buscp8, buscp8, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 127)
					{
						pData[playerid][pBuswaiting] = true;
						pData[playerid][pBustime] = 10;
						PlayerPlaySound(playerid, 43000, 198.7756,-1503.1976,12.2431);
						return 1;
					}
					else if(pData[playerid][pBus] == 128)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 129;
						SetPlayerRaceCheckpoint(playerid, 2, buscp10, buscp10, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 129)
					{
						pData[playerid][pBuswaiting] = true;
						pData[playerid][pBustime] = 10;
						PlayerPlaySound(playerid, 43000, 623.8340,-1360.3447,12.9780);
						return 1;
					}
					else if(pData[playerid][pBus] == 130)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 131;
						SetPlayerRaceCheckpoint(playerid, 2, buscp12, buscp12, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 131)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 132;
						SetPlayerRaceCheckpoint(playerid, 2, buscp13, buscp13, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 132)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 133;
						SetPlayerRaceCheckpoint(playerid, 2, buscp14, buscp14, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 133)
					{
						pData[playerid][pBuswaiting] = true;
						pData[playerid][pBustime] = 10;
						PlayerPlaySound(playerid, 43000, 1208.1864,-1330.8541,12.9545);
						return 1;
					}
					else if(pData[playerid][pBus] == 134)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 135;
						SetPlayerRaceCheckpoint(playerid, 2, buscp16, buscp16, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 135)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 136;
						SetPlayerRaceCheckpoint(playerid, 2, buscp17, buscp17, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 136)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 137;
						SetPlayerRaceCheckpoint(playerid, 2, buscp18, buscp18, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 137)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 138;
						SetPlayerRaceCheckpoint(playerid, 2, buscp19, buscp19, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 138)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 139;
						SetPlayerRaceCheckpoint(playerid, 2, buscp20, buscp20, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 139)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 140;
						SetPlayerRaceCheckpoint(playerid, 2, buscp21, buscp21, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 140)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 141;
						SetPlayerRaceCheckpoint(playerid, 2, buscp22, buscp22, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 141)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 142;
						SetPlayerRaceCheckpoint(playerid, 2, buscp23, buscp23, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 142)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 143;
						SetPlayerRaceCheckpoint(playerid, 2, buscp24, buscp24, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 143)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 144;
						SetPlayerRaceCheckpoint(playerid, 2, buscp25, buscp25, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 144)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 145;
						SetPlayerRaceCheckpoint(playerid, 2, buscp26, buscp26, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 145)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 146;
						SetPlayerRaceCheckpoint(playerid, 2, buscp27, buscp27, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 146)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 147;
						SetPlayerRaceCheckpoint(playerid, 2, buscp28, buscp28, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 147)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 148;
						SetPlayerRaceCheckpoint(playerid, 2, buscp29, buscp29, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 148)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 149;
						SetPlayerRaceCheckpoint(playerid, 2, buscp30, buscp30, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 149)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 150;
						SetPlayerRaceCheckpoint(playerid, 2, buscp31, buscp31, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 150)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 151;
						SetPlayerRaceCheckpoint(playerid, 2, buscp32, buscp32, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 151)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 152;
						SetPlayerRaceCheckpoint(playerid, 2, buscp33, buscp33, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 152)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 153;
						SetPlayerRaceCheckpoint(playerid, 2, buscp34, buscp34, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 153)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 154;
						SetPlayerRaceCheckpoint(playerid, 2, buscp35, buscp35, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 154)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 155;
						SetPlayerRaceCheckpoint(playerid, 2, buscp36, buscp36, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 155)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 156;
						SetPlayerRaceCheckpoint(playerid, 2, buscp37, buscp37, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 156)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 157;
						SetPlayerRaceCheckpoint(playerid, 2, buscp38, buscp38, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 157)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 158;
						SetPlayerRaceCheckpoint(playerid, 2, buscp39, buscp39, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 158)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 159;
						SetPlayerRaceCheckpoint(playerid, 2, buscp40, buscp40, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 159)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 160;
						SetPlayerRaceCheckpoint(playerid, 2, buscp41, buscp41, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 160)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 161;
						SetPlayerRaceCheckpoint(playerid, 2, buscp42, buscp42, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 161)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 162;
						SetPlayerRaceCheckpoint(playerid, 2, buscp43, buscp43, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 162)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 163;
						SetPlayerRaceCheckpoint(playerid, 2, buscp44, buscp44, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 163)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 164;
						SetPlayerRaceCheckpoint(playerid, 2, buscp45, buscp45, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 164)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 165;
						SetPlayerRaceCheckpoint(playerid, 2, buscp46, buscp46, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 165)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 166;
						SetPlayerRaceCheckpoint(playerid, 2, buscp47, buscp47, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 166)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 167;
						SetPlayerRaceCheckpoint(playerid, 2, buscp48, buscp48, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 167)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 168;
						SetPlayerRaceCheckpoint(playerid, 2, buscp49, buscp49, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 168)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 169;
						SetPlayerRaceCheckpoint(playerid, 2, buscp50, buscp50, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 169)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 170;
						SetPlayerRaceCheckpoint(playerid, 2, buscp51, buscp51, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 170)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 171;
						SetPlayerRaceCheckpoint(playerid, 2, buscp52, buscp52, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 171)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 172;
						SetPlayerRaceCheckpoint(playerid, 2, buscp53, buscp53, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 172)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 173;
						SetPlayerRaceCheckpoint(playerid, 2, buscp54, buscp54, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 173)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 174;
						SetPlayerRaceCheckpoint(playerid, 2, buscp55, buscp55, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 174)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 175;
						SetPlayerRaceCheckpoint(playerid, 2, buscp56, buscp56, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 175)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 176;
						SetPlayerRaceCheckpoint(playerid, 2, buscp57, buscp57, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 176)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 177;
						SetPlayerRaceCheckpoint(playerid, 2, buscp58, buscp58, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 177)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 178;
						SetPlayerRaceCheckpoint(playerid, 2, buscp59, buscp59, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 178)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 179;
						SetPlayerRaceCheckpoint(playerid, 2, buscp60, buscp60, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 179)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 180;
						SetPlayerRaceCheckpoint(playerid, 2, buscp61, buscp61, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 180)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 181;
						SetPlayerRaceCheckpoint(playerid, 2, buscp62, buscp62, 5.0);
						return 1;
					}
					else if(pData[playerid][pBus] == 181)
					{
						pData[playerid][pBus] = 0;
						pData[playerid][pSideJob] = 0;
						pData[playerid][pBusTime] = 0;
						pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
						DisablePlayerRaceCheckpoint(playerid);
						GivePlayerMoneyEx(playerid, 850);
					    ShowItemBox(playerid, "Uang", "Received_$850", 1212, 4);
						RemovePlayerFromVehicle(playerid);
						if(IsValidVehicle(pData[playerid][pKendaraanKerja]))
   						DestroyVehicle(pData[playerid][pKendaraanKerja]);  //jika player disconnect maka kendaraan akan ilang
   						return 1;
					}
				}
			}
		}
		case CHECKPOINT_MISC:
		{
			pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
			DisablePlayerRaceCheckpoint(playerid);
			return 1;
		}
	}
	if(pData[playerid][pTrackCar] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan kendaraan anda!");
		pData[playerid][pTrackCar] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackHouse] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan rumah anda!");
		pData[playerid][pTrackHouse] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackBisnis] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan bisnis anda!");
		pData[playerid][pTrackBisnis] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pMissionBiz] > -1 || pData[playerid][pMissionVen] > -1)
	{
		DisablePlayerRaceCheckpoint(playerid);
		Info(playerid, "Anda telah berhasil sampai di tempat tujuan (/unloadbox).");
	}
	if(pData[playerid][pPizzaCP] > -1)
	{
		DisablePlayerRaceCheckpoint(playerid);
		Info(playerid, "Kamu telah sampai ditujuan, gunakan /droppizza untuk menaruh pizza.");
	}
	DisablePlayerRaceCheckpoint(playerid);
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	pData[playerid][pClikmap] = 0;

	if(vehicleid == pData[playerid][pKendaraanKerja])
    {
        KeluarKerja[playerid] = SetTimerEx("KeluarKendaraanKerja", 1000, true, "i", playerid);
        TimerKeluar[playerid] = 0;
        ShowNotifInfo(playerid, sprintf("Segera masuk kedalam kendaraan dalam %d Detik ", TimerKeluar[playerid]), 10000);
        //ShowNotifInfo(playerid, "Segera masuk kedalam kendaraan dalam 15 detik!", 10000);
        //InfoMsg(playerid, "Segera masuk kedalam kendaraan dalam 15 detik!", 3);
    }

	if (OnPadi[playerid] && vehicleid == PlayerData[playerid][pVehiclePetaniPadi]) {
        DestroyVehicle(PlayerData[playerid][pVehiclePetaniPadi]);
        Info(playerid, "Kamu gagal bekerja sebagai ~y~Petani Padi ~w~karena keluar dari kendaraan!");
        SendClientMessage(playerid, -1, "INFO : Kamu gagal bekerja sebagai {FFFF00} Petani Padi {FFFFFF}karena keluar dari kendaraan!");
        OnPadi[playerid] = false;
        PadiIndex[playerid] = 0;
        DisablePlayerRaceCheckpoint(playerid);
    }
    if (OnCabai[playerid] && vehicleid == PlayerData[playerid][pVehiclePetaniCabai]) {
        DestroyVehicle(PlayerData[playerid][pVehiclePetaniCabai]);
        Info(playerid, "Kamu gagal bekerja sebagai ~y~Petani Cabai ~w~karena keluar dari kendaraan!");
        OnCabai[playerid] = false;
        CabaiIndex[playerid] = 0;
        DisablePlayerRaceCheckpoint(playerid);
    }
    if (OnTebu[playerid] && vehicleid == PlayerData[playerid][pVehiclePetaniTebu]) {
        DestroyVehicle(PlayerData[playerid][pVehiclePetaniTebu]);
        Info(playerid, "Kamu gagal bekerja sebagai ~y~Petani Tebu ~w~karena keluar dari kendaraan!");
        OnTebu[playerid] = false;
        TebuIndex[playerid] = 0;
        DisablePlayerRaceCheckpoint(playerid);
    }
    if (OnGaram[playerid] && vehicleid == PlayerData[playerid][pVehiclePetaniGaram]) {
        DestroyVehicle(PlayerData[playerid][pVehiclePetaniGaram]);
        Info(playerid, "Kamu gagal bekerja sebagai ~y~Petani Garam ~w~karena keluar dari kendaraan!");
        OnGaram[playerid] = false;
        GaramIndex[playerid] = 0;
        DisablePlayerRaceCheckpoint(playerid);
    }
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(pData[playerid][pAdmin] != 0 && pData[playerid][pAdminDuty] != 0)
	{
		new Float:a;
		GetPlayerFacingAngle(playerid, a);
		SetPlayerPosition(playerid, fX, fY, fZ, a, 0);
		SetPlayerVirtualWorld(playerid, 0);
		Info(playerid, "Kamu telah diteleport menuju tempat yang telah ditandai");
	}
	foreach (new i : Player)
	{
		if(pData[i][pClikmap] == pData[playerid][pClikmap] && pData[playerid][pClikmap] != 0 && pData[i][pClikmap] != 0)
		{
			SetPlayerCheckpoint(i, fX, fY, fZ, 3.0);
			Info(i, "Waypoint Sharing, Lihat pada map.");
		}
    }
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    new playerState = GetPlayerState(playerid);
    if(RobBankProgress[playerid] == 1)
    {
    	if(playerState == PLAYER_STATE_ONFOOT || playerState == PLAYER_STATE_DRIVER)
    	{
    		if(IsPlayerInRangeOfPoint(playerid, 3.5, 1458.35, -1024.54, 23.82))
    		{
    			RobBankStatus = 1;
    			RobBankText[1] = CreateDynamic3DTextLabel(""YELLOW_E"[ROBBANK]\n"WHITE_E"/placebomb", COLOR_YELLOW, -990.61, 1468.34, 1332.02, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Placed Bomb
    			DisablePlayerCheckpoint(playerid);
    			Info(playerid, "Kamu sudah sampai didepan Bank of Los Santos, lanjutkan dengan pergi kedalam inside bank");
    		}
    	}
    }
    if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
		if(pData[playerid][pMinerStatus] > 0)
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
			{
				if(IsPlayerInRangeOfPoint(playerid, 4.5, 606.96, 866.46, -40.37))
				{
					DisablePlayerCheckpoint(playerid);
					ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0, 0, 0, 0, 0, 0, 1);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
					RemovePlayerAttachedObject(playerid, 9);
					AddPlayerSalary(playerid, "Job (Miner)", jobminerprice);
					Info(playerid, "Job (Miner) "GREEN_E"%s"WHITE_E" telah ditambakan ke salary anda!", FormatMoney(jobminerprice));
					
					pData[playerid][pMinerStatus] = 0;
					pData[playerid][pMinerProgres] = 0;

					pData[playerid][pJobTime] = 78;
					pData[playerid][pHunger] -= 3;
					pData[playerid][pEnergy] -= 6;
					
					Component += 25;
					Server_Save();
				}
			}
		}
	}
    if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8) //TAKE GAS
    {
    	if(playerState == PLAYER_STATE_DRIVER)
    	{
    		if(HaulingType[playerid] == 1)
    		{
			    if(IsPlayerInRangeOfPoint(playerid, 15.0,  2781.00, -2493.73, 13.75))
			    {
			    	new randgas = Iter_Random(GStation);
			    	AttachTrailerToVehicle(VehHauling[playerid], GetPlayerVehicleID(playerid));
			    	DisablePlayerCheckpoint(playerid);
			    	SetPVarInt(playerid, "RandGAS", randgas);
			    	SetPlayerCheckpoint(playerid, gsData[randgas][gsPosX], gsData[randgas][gsPosY], gsData[randgas][gsPosZ], 4.5);
			    	Info(playerid, "Sukses terpasang! kamu harus membawa trailer sampai tempat tujuan");
			    }
		    }
	    }
	}
    if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8) //TAKE DEALER
    {
    	if(playerState == PLAYER_STATE_DRIVER)
    	{
    		if(HaulingType[playerid] == 2)
    		{
    			if(IsAHaulingVeh(GetPlayerVehicleID(playerid)))
    			{
				    if(IsPlayerInRangeOfPoint(playerid, 15.0, 2781.44, -2455.97, 13.73))
				    {
						new deid = pData[playerid][pGetDEIDHAULING];
						AttachTrailerToVehicle(VehHauling[playerid], GetPlayerVehicleID(playerid));
				    	DisablePlayerCheckpoint(playerid);
				    	SetPlayerCheckpoint(playerid, drData[deid][dVehX], drData[deid][dVehY], drData[deid][dVehZ], 4.5);
						Info(playerid, "Kamu akan mengantar menuju dealer yang berlokasi di %s yang berjarak %0.0fm", GetLocation(drData[deid][dVehX], drData[deid][dVehY], drData[deid][dVehZ]), GetPlayerDistanceFromPoint(playerid, drData[deid][dVehX], drData[deid][dVehY], drData[deid][dVehZ]));
				    }
				}
		    }
	    }
	}
	if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8) //SAMPAI SELESAI ANTAR GAS
	{
		if(playerState == PLAYER_STATE_DRIVER)
		{
			if(HaulingType[playerid] == 1)
			{
				new gsrand = GetPVarInt(playerid, "RandGAS");
				if(IsPlayerInRangeOfPoint(playerid, 4.5, gsData[gsrand][gsPosX], gsData[gsrand][gsPosY], gsData[gsrand][gsPosZ]))
				{
					DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));

					DestroyVehicle(VehHauling[playerid]);

					DisablePlayerCheckpoint(playerid);
					GivePlayerMoneyEx(playerid, haulingprice1);
					Info(playerid, "Kamu berhasil mengantar trailer sampai tempat tujuan, dan mendapatkan uang sejumlah {00FF00}%s", FormatMoney(haulingprice1));

					VehHauling[playerid] = -1;
					HaulingType[playerid] = 0;
					pData[playerid][pJobTime] = 60;
					pData[playerid][pHunger] -= 10;
					pData[playerid][pEnergy] -= 15;
					gsData[gsrand][gsStock] += 5;

					GStation_Save(gsrand);
					GStation_Refresh(gsrand);
				}
			}
		}
	}
	if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8) //SAMPAI SELESAI ANTAR DEALER
	{
		if(playerState == PLAYER_STATE_DRIVER)
		{
			if(HaulingType[playerid] == 2)
			{
				new deid = pData[playerid][pGetDEIDHAULING];
				if(IsPlayerInRangeOfPoint(playerid, 4.5, drData[deid][dVehX], drData[deid][dVehY], drData[deid][dVehZ]))
				{
					DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));

					DestroyVehicle(VehHauling[playerid]);

					DisablePlayerCheckpoint(playerid);
					GivePlayerMoneyEx(playerid, haulingprice2);

					VehHauling[playerid] = -1;
					HaulingType[playerid] = 0;

					pData[playerid][pGetDEIDHAULING] = -1;

					drData[deid][dStock] += 5;
					drData[deid][dMoney] -= 20000;

					pData[playerid][pJobTime] = 60;
					pData[playerid][pHunger] -= 10;
					pData[playerid][pEnergy] -= 15;
					
					Dealer_Save(deid);
					Dealer_Refresh(deid);
					Info(playerid, "Kamu berhasil mengisi "RED_E"5"WHITE_E" stock dealer ini, dan mendapatkan bayar sejumlah {00FF00}%s", FormatMoney(haulingprice2));
				}
			}
		}
	}
	if(pData[playerid][pJob] == 12 || pData[playerid][pJob2] == 12)
	{
		if(pData[playerid][pDrugDealer] == 1)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.5, 2167.21, -1672.69, 15.07))
			{
				pData[playerid][pDrugDealer] = 0;
				pData[playerid][pJobTime] = 30;
				pData[playerid][pHunger] -= 10;
				pData[playerid][pEnergy] -= 15;
				
				DisablePlayerCheckpoint(playerid);
				GivePlayerMoneyEx(playerid, drugdealerprice1);
				pData[playerid][pDrugDealer] = 0;
				
				Marijuana += 20;
				Server_AddMoney(500);
				Info(playerid, "Kamu telah mengantar paket Marijuana sampai tujuan, dan mendapatkan bayaran "GREEN_E"%s"WHITE_E"", FormatMoney(drugdealerprice1));
			}
		}
		if(pData[playerid][pDrugDealer] == 2)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.5, 2167.21, -1672.69, 15.07))
			{
				pData[playerid][pDrugDealer] = 0;
				pData[playerid][pHunger] -= 10;
				pData[playerid][pEnergy] -= 15;

				DisablePlayerCheckpoint(playerid);
				GivePlayerMoneyEx(playerid, drugdealerprice2);
				pData[playerid][pDrugDealer] = 0;
				
				Ephedrine += 20;
				Server_AddMoney(500);
				Info(playerid, "Kamu telah mengantar paket Raw Ephedrine sampai tujuan, dan mendapatkan bayaran "GREEN_E"%s"WHITE_E"", FormatMoney(drugdealerprice2));
			}
		}
		else if(pData[playerid][pDrugDealer] == 3)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.5, 2351.82, -1168.90, 27.98))
			{
				pData[playerid][pDrugDealer] = 0;

				pData[playerid][pJobTime] = 60;
				pData[playerid][pHunger] -= 10;
				pData[playerid][pEnergy] -= 15;

				DisablePlayerCheckpoint(playerid);
				GivePlayerMoneyEx(playerid, drugdealerprice3);

				Cocaine += 20;
				Server_AddMoney(500);
				Info(playerid, "Kamu telah mengantar paket Cocaine sampai tujuan, dan mendapatkan bayaran "GREEN_E"%s"WHITE_E"", FormatMoney(drugdealerprice3));
			}
		}
	}
	if(pData[playerid][pJob] == 13 || pData[playerid][pJob2] == 13)
	{
		if(pData[playerid][pSmuggleMats] == 1)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.5, 2288.09, -1105.65, 37.97))
			{
				DisablePlayerCheckpoint(playerid);

				pData[playerid][pSmuggleMats] = 0;
				pData[playerid][pMaterial] += 15;

				Info(playerid, "Kamu telah mengantar mats kegudang, dan mendapatkan "YELLOW_E"15"WHITE_E" material");
			}
		}
	}
	if(pData[playerid][pJob] == 13 || pData[playerid][pJob2] == 13)
	{
		if(pData[playerid][pSmuggleMats] == 2)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.5, 2173.21, -2264.15, 13.34))
			{
				DisablePlayerCheckpoint(playerid);

				pData[playerid][pSmuggleMats] = 0;
				pData[playerid][pMaterial] += 15;

				Info(playerid, "Kamu telah mengantar mats kegudang, dan mendapatkan "YELLOW_E"15"WHITE_E" material");
			}
		}
	}
	if(pData[playerid][pGetSIM] == 1)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(GetVehicleModel(vehicleid) == 445)
        {
            if (IsPlayerInRangeOfPoint(playerid, 3.0,getsimpoint1))
            {
                SetPlayerCheckpoint(playerid, getsimpoint2, 3.0);
            }
            if (IsPlayerInRangeOfPoint(playerid, 3.0,getsimpoint2))
            {
                SetPlayerCheckpoint(playerid, getsimpoint3, 3.0);
            }
            if (IsPlayerInRangeOfPoint(playerid, 3.0,getsimpoint3))
            {
                SetPlayerCheckpoint(playerid, getsimpoint4, 3.0);
            }
            if (IsPlayerInRangeOfPoint(playerid, 3.0,getsimpoint4))
            {
                SetPlayerCheckpoint(playerid, getsimpoint5, 3.0);
            }
            if (IsPlayerInRangeOfPoint(playerid, 3.0,getsimpoint5))
            {
                SetPlayerCheckpoint(playerid, getsimpoint6, 3.0);
            }
            if (IsPlayerInRangeOfPoint(playerid, 3.0,getsimpoint6))
            {
                SetPlayerCheckpoint(playerid, getsimpoint7, 3.0);
            }
            if (IsPlayerInRangeOfPoint(playerid, 3.0,getsimpoint7))
            {
                SetPlayerCheckpoint(playerid, getsimpoint8, 3.0);
            }
            if (IsPlayerInRangeOfPoint(playerid, 3.0,getsimpoint8))
            {
                SetPlayerCheckpoint(playerid, getsimpoint9, 3.0);
            }
            if (IsPlayerInRangeOfPoint(playerid, 3.0,getsimpoint9))
            {
                SetPlayerCheckpoint(playerid, getsimpoint10, 3.0);
            }
            if (IsPlayerInRangeOfPoint(playerid, 3.0,getsimpoint10))
            {
                SetPlayerCheckpoint(playerid, getsimpoint11, 3.0);
            }
            if (IsPlayerInRangeOfPoint(playerid, 3.0,getsimpoint11))
            {
                SetPlayerCheckpoint(playerid, getsimpoint12, 3.0);
            }
            if (IsPlayerInRangeOfPoint(playerid, 3.0,getsimpoint12))
            {
                new sext[40], mstr[128];
                if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
                format(mstr, sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[playerid][pName], pData[playerid][pAge], sext);
                ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Driving License", mstr, "Tutup", "");
                Info(playerid,"Selamat! kamu berhasil menyelesaikan sekolah tes mengemudi.");
                pData[playerid][pGetSIM] = 0;
                pData[playerid][pDriveLic] = 1;
                pData[playerid][pDriveLicTime] = gettime() + (15 * 86400);
                DisablePlayerCheckpoint(playerid);
                RemovePlayerFromVehicle(playerid);
                SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
            }
        }
    }
	if(pData[playerid][pSideJob] == 1)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 574)
		{
			if (IsPlayerInRangeOfPoint(playerid, 3.0,sweperpoint1))
			{
				SetPlayerCheckpoint(playerid, sweperpoint2, 3.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,sweperpoint2))
			{
				SetPlayerCheckpoint(playerid, sweperpoint3, 3.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,sweperpoint3))
			{
				SetPlayerCheckpoint(playerid, sweperpoint4, 3.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,sweperpoint4))
			{
				SetPlayerCheckpoint(playerid, sweperpoint5, 3.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,sweperpoint5))
			{
				SetPlayerCheckpoint(playerid, sweperpoint6, 3.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,sweperpoint6))
			{
				SetPlayerCheckpoint(playerid, sweperpoint7, 3.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,sweperpoint7))
			{
				SetPlayerCheckpoint(playerid, sweperpoint8, 3.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,sweperpoint8))
			{
				SetPlayerCheckpoint(playerid, sweperpoint9, 3.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,sweperpoint9))
			{
				SetPlayerCheckpoint(playerid, sweperpoint10, 3.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,sweperpoint10))
			{
				pData[playerid][pSideJob] = 0;
				pData[playerid][pSideJobTime] = 180;
				DisablePlayerCheckpoint(playerid);
				AddPlayerSalary(playerid, "Sidejob(Sweeper)", sjsweeper);
				Info(playerid, "Sidejob(Sweeper) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
		}
	}
	if(pData[playerid][pSideJob] == 2)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 431)
		{
			if(pData[playerid][pBusRoute] == 1)
			{
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket1))
				{
					SetPlayerCheckpoint(playerid, buspointmarket2, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket2))
				{
					SetPlayerCheckpoint(playerid, buspointmarket3, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket3))
				{
					SetPlayerCheckpoint(playerid, buspointmarket4, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket4))
				{
					SetPlayerCheckpoint(playerid, buspointmarket5, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket5))
				{
					SetPlayerCheckpoint(playerid, buspointmarket6, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket6))
				{
					SetPlayerCheckpoint(playerid, buspointmarket7, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket7))
				{
					SetPlayerCheckpoint(playerid, buspointmarket8, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket8))
				{
					SetPlayerCheckpoint(playerid, buspointmarket9, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket9))
				{
					pData[playerid][pBuswaiting] = true;
					pData[playerid][pBustime] = 10;
					ShowNotifInfo(playerid, "Mohon Tunggu Selama 10 Detik Untuk Melakukan Perjalanan", 10000);
					PlayerPlaySound(playerid, 43000, 0.0, 0.0, 0.0);
					//SetPlayerCheckpoint(playerid, buspointmarket10, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket10))
				{
					SetPlayerCheckpoint(playerid, buspointmarket11, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket11))
				{
					SetPlayerCheckpoint(playerid, buspointmarket12, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket12))
				{
					SetPlayerCheckpoint(playerid, buspointmarket13, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket13))
				{
					SetPlayerCheckpoint(playerid, buspointmarket14, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket14))
				{
					SetPlayerCheckpoint(playerid, buspointmarket15, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket15))
				{
					SetPlayerCheckpoint(playerid, buspointmarket16, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket16))
				{
					pData[playerid][pBuswaiting] = true;
					pData[playerid][pBustime] = 10;
					ShowNotifInfo(playerid, "Mohon Tunggu Selama 10 Detik Untuk Melakukan Perjalanan", 10000);
					PlayerPlaySound(playerid, 43000, 0.0, 0.0, 0.0);
					//SetPlayerCheckpoint(playerid, buspointmarket17, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket17))
				{
					SetPlayerCheckpoint(playerid, buspointmarket18, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket18))
				{
					SetPlayerCheckpoint(playerid, buspointmarket19, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket19))
				{
					SetPlayerCheckpoint(playerid, buspointmarket20, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket20))
				{
					SetPlayerCheckpoint(playerid, buspointmarket21, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket21))
				{
					SetPlayerCheckpoint(playerid, buspointmarket22, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket22))
				{
					SetPlayerCheckpoint(playerid, buspointmarket23, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket23))
				{
					SetPlayerCheckpoint(playerid, buspointmarket24, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket24))
				{
					pData[playerid][pBuswaiting] = true;
					pData[playerid][pBustime] = 10;
					ShowNotifInfo(playerid, "Mohon Tunggu Selama 10 Detik Untuk Melakukan Perjalanan", 10000);
					PlayerPlaySound(playerid, 43000, 0.0, 0.0, 0.0);
					//SetPlayerCheckpoint(playerid, buspointmarket25, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket25))
				{
					SetPlayerCheckpoint(playerid, buspointmarket26, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket26))
				{
					SetPlayerCheckpoint(playerid, buspointmarket27, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket27))
				{
					SetPlayerCheckpoint(playerid, buspointmarket28, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket28))
				{
					SetPlayerCheckpoint(playerid, buspointmarket29, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket29))
				{
					pData[playerid][pBuswaiting] = true;
					pData[playerid][pBustime] = 10;
					ShowNotifInfo(playerid, "Mohon Tunggu Selama 10 Detik Untuk Melakukan Perjalanan", 10000);
					PlayerPlaySound(playerid, 43000, 0.0, 0.0, 0.0);
					//SetPlayerCheckpoint(playerid, buspointmarket30, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket30))
				{
					SetPlayerCheckpoint(playerid, buspointmarket31, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket31))
				{
					SetPlayerCheckpoint(playerid, buspointmarket32, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket32))
				{
					SetPlayerCheckpoint(playerid, buspointmarket33, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket33))
				{
					//pData[playerid][pBuswaiting] = true;
					//pData[playerid][pBustime] = 10;
					//ShowNotifInfo(playerid, "Mohon Tunggu Selama 10 Detik Untuk Melakukan Perjalanan", 10000);
					//PlayerPlaySound(playerid, 43000, 0.0, 0.0, 0.0);
					SetPlayerCheckpoint(playerid, buspointmarket34, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket34))
				{
					pData[playerid][pBuswaiting] = true;
					pData[playerid][pBustime] = 10;
					ShowNotifInfo(playerid, "Mohon Tunggu Selama 10 Detik Untuk Melakukan Perjalanan", 10000);
					PlayerPlaySound(playerid, 43000, 0.0, 0.0, 0.0);
					//SetPlayerCheckpoint(playerid, buspointmarket35, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket35))
				{
					SetPlayerCheckpoint(playerid, buspointmarket36, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket36))
				{
					SetPlayerCheckpoint(playerid, buspointmarket37, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket37))
				{
					SetPlayerCheckpoint(playerid, buspointmarket38, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket38))
				{
					pData[playerid][pSideJob] = 0;
					pData[playerid][pSideJobTime] = 300;
					pData[playerid][pBusRoute] = 0;
					DisablePlayerCheckpoint(playerid);
					AddPlayerSalary(playerid, "Sidejob(Bus)", sjbus);
					Info(playerid, "Sidejob(Bus) telah masuk ke pending salary anda!");
					RemovePlayerFromVehicle(playerid);
					SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				}
			}
			else if(pData[playerid][pBusRoute] == 2)
			{
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor1))
				{
					SetPlayerCheckpoint(playerid, buspointelcor2, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor2))
				{
					SetPlayerCheckpoint(playerid, buspointelcor3, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor3))
				{
					SetPlayerCheckpoint(playerid, buspointelcor4, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor4))
				{
					SetPlayerCheckpoint(playerid, buspointelcor5, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor5))
				{
					SetPlayerCheckpoint(playerid, buspointelcor6, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor6))
				{
					SetPlayerCheckpoint(playerid, buspointelcor7, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor7))
				{
					pData[playerid][pBuswaiting] = true;
					pData[playerid][pBustime] = 10;
					ShowNotifInfo(playerid, "Mohon Tunggu Selama 10 Detik Untuk Melakukan Perjalanan", 10000);
					PlayerPlaySound(playerid, 43000, 0.0, 0.0, 0.0);
					//SetPlayerCheckpoint(playerid, buspointelcor8, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor8))
				{
					SetPlayerCheckpoint(playerid, buspointelcor9, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor9))
				{
					SetPlayerCheckpoint(playerid, buspointelcor10, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor10))
				{
					pData[playerid][pBuswaiting] = true;
					pData[playerid][pBustime] = 10;
					ShowNotifInfo(playerid, "Mohon Tunggu Selama 10 Detik Untuk Melakukan Perjalanan", 10000);
					PlayerPlaySound(playerid, 43000, 0.0, 0.0, 0.0);
					//SetPlayerCheckpoint(playerid, buspointelcor11, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor11))
				{
					SetPlayerCheckpoint(playerid, buspointelcor12, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor12))
				{
					SetPlayerCheckpoint(playerid, buspointelcor13, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor13))
				{
					SetPlayerCheckpoint(playerid, buspointelcor14, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor14))
				{
					SetPlayerCheckpoint(playerid, buspointelcor15, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor15))
				{
					pData[playerid][pBuswaiting] = true;
					pData[playerid][pBustime] = 10;
					ShowNotifInfo(playerid, "Mohon Tunggu Selama 10 Detik Untuk Melakukan Perjalanan", 10000);
					PlayerPlaySound(playerid, 43000, 0.0, 0.0, 0.0);
					//SetPlayerCheckpoint(playerid, buspointelcor16, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor16))
				{
					SetPlayerCheckpoint(playerid, buspointelcor17, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor17))
				{
					SetPlayerCheckpoint(playerid, buspointelcor18, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor18))
				{
					SetPlayerCheckpoint(playerid, buspointelcor19, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor19))
				{
					SetPlayerCheckpoint(playerid, buspointelcor20, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor20))
				{
					SetPlayerCheckpoint(playerid, buspointelcor21, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor21))
				{
					pData[playerid][pBuswaiting] = true;
					pData[playerid][pBustime] = 10;
					ShowNotifInfo(playerid, "Mohon Tunggu Selama 10 Detik Untuk Melakukan Perjalanan", 10000);
					PlayerPlaySound(playerid, 43000, 0.0, 0.0, 0.0);
					//SetPlayerCheckpoint(playerid, buspointelcor22, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor22))
				{
					SetPlayerCheckpoint(playerid, buspointelcor23, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor23))
				{
					SetPlayerCheckpoint(playerid, buspointelcor24, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor24))
				{
					SetPlayerCheckpoint(playerid, buspointelcor25, 7.0);
				}
				if (IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor25))
				{
					pData[playerid][pSideJob] = 0;
					pData[playerid][pSideJobTime] = 300;
					pData[playerid][pBusRoute] = 0;
					DisablePlayerCheckpoint(playerid);
					AddPlayerSalary(playerid, "Sidejob(Bus)", sjbus);
					Info(playerid, "Sidejob(Bus) telah masuk ke pending salary anda!");
					RemovePlayerFromVehicle(playerid);
					SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				}
			}
		}
	}
	if(pData[playerid][pSideJob] == 3)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 530)
		{
			if (IsPlayerInRangeOfPoint(playerid, 4.0, forpoint1))
			{
				SetPlayerCheckpoint(playerid, 2400.02, -2565.49, 13.21, 4.0);
				TogglePlayerControllable(playerid, 0);
				GameTextForPlayer(playerid, "~w~MEMUAT ~g~BARANG...", 5000, 3);
				SetTimerEx("JobForklift", 3000, false, "i", playerid);
				return 1;
			}
			if (IsPlayerInRangeOfPoint(playerid, 4.0, forpoint2))
			{
				SetPlayerCheckpoint(playerid, 2752.89, -2392.60, 13.64, 4.0);
				TogglePlayerControllable(playerid, 0);
				GameTextForPlayer(playerid, "~w~MELETAKKAN ~g~BARANG...", 5000, 3);
				SetTimerEx("JobForklift", 3000, false, "i", playerid);
				return 1;
			}
			if(IsPlayerInRangeOfPoint(playerid, 4.0, forpoint3))
			{
				pData[playerid][pSideJob] = 0;
				pData[playerid][pSideJobTime] = 180;
				DisablePlayerCheckpoint(playerid);
				AddPlayerSalary(playerid, "Sidejob(Forklift)", sjforklift);
				Info(playerid, "Sidejob(Forklift) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
		}
	}
	if(pData[playerid][pSideJob] == 4)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 572)
		{
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint1))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint2, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint2))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint3, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint3))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint4, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint4))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint5, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint5))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint6, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint6))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint7, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint7))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint8, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint8))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint9, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint9))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint10, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint10))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint11, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint11))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint12, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint12))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint13, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint13))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint14, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint14))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint15, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint15))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint16, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint16))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint17, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint17))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint18, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint18))
			{
				InfoTD_MSG(playerid, 3000, "Rumput terpotong");
				SetPlayerCheckpoint(playerid, rumputpoint19, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0,rumputpoint19))
			{
				pData[playerid][pSideJob] = 0;
				pData[playerid][pSideJobTime] = 180;
				DisablePlayerCheckpoint(playerid);
				AddPlayerSalary(playerid, "Sidejob(Lawn Mower)", sjmower);
				Info(playerid, "Sidejob(Lawn Mower) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
		}
	}
	//DisablePlayerCheckpoint(playerid);
	//Petani Gen
	if (OnPadi[playerid] && GetPlayerVehicleID(playerid) == PlayerData[playerid][pVehiclePetaniPadi])
    {
    	if (IsPlayerInRangeOfPoint(playerid, 5.0, padipoin1))
		{
			SetPlayerCheckpoint(playerid, padipoin2, 5.0);
		}
		if (IsPlayerInRangeOfPoint(playerid, 5.0, padipoin2))
		{
			SetPlayerCheckpoint(playerid, padipoin3, 5.0);
		}
		if (IsPlayerInRangeOfPoint(playerid, 5.0, padipoin3))
		{
			SetPlayerCheckpoint(playerid, padipoin4, 5.0);
		}
		if (IsPlayerInRangeOfPoint(playerid, 5.0, padipoin4))
		{
			SetPlayerCheckpoint(playerid, padipoin5, 5.0);
		}
		if (IsPlayerInRangeOfPoint(playerid, 5.0, padipoin5))
		{
			SetPlayerCheckpoint(playerid, padipoin6, 5.0);
		}
		if (IsPlayerInRangeOfPoint(playerid, 5.0, padipoin6))
		{
			//PadiIndex[playerid] = -1;
            OnPadi[playerid] = false;
            new vid = GetPlayerVehicleID(playerid);
            DestroyVehicle(vid);

           // DisablePlayerRaceCheckpoint(playerid);
            DisablePlayerCheckpoint(playerid);

            new randchance = random(2);
            if (randchance == 0) {
                objpadi[0][playerid] = CreatePlayerObject(playerid, 806, -120.4719, 100.0535, 3.1172, 0, 0, 0, 300.0);
                objpadi[1][playerid] = CreatePlayerObject(playerid, 806, -113.3886, 121.5473, 3.1172, 0, 0, 0, 300.0);
                objpadi[7][playerid] = CreatePlayerObject(playerid, 806, -130.4068, 127.7735, 3.2353, 0, 0, 0, 300.0);
                objpadi[8][playerid] = CreatePlayerObject(playerid, 806, -122.1953, 152.2816, 3.6405, 0, 0, 0, 300.0);
            }
            if (randchance == 1) {
                objpadi[4][playerid] = CreatePlayerObject(playerid, 806, -120.9507, 125.0645, 3.1172, 0, 0, 0, 300.0);
                objpadi[5][playerid] = CreatePlayerObject(playerid, 806, -129.4480, 102.2350, 3.1172, 0, 0, 0, 300.0);
                objpadi[6][playerid] = CreatePlayerObject(playerid, 806, -137.8015, 105.8149, 3.1172, 0, 0, 0, 300.0);
                objpadi[2][playerid] = CreatePlayerObject(playerid, 806, -104.8806, 147.5743, 3.1247, 0, 0, 0, 300.0);
                objpadi[3][playerid] = CreatePlayerObject(playerid, 806, -113.0978, 149.5568, 3.3532, 0, 0, 0, 300.0);
            }
		}
        /*if (PadiIndex[playerid] == 1) 
        {
            PadiIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerCheckpoint(playerid, padipoin2, 7.0);
            SetPlayerRaceCheckpoint(playerid, 0, -104.6067, 149.7482, 3.1986, -111.3958, 153.1665, 3.4523, 5.0);
            PadiIndex[playerid] = 2;
        } else if (PadiIndex[playerid] == 2) {
            PadiIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, -111.3958, 153.1665, 3.4523, -129.5415, 100.5149, 3.1172, 5.0);
            PadiIndex[playerid] = 3;
        } else if (PadiIndex[playerid] == 3) {
            PadiIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, -129.5415, 100.5149, 3.1172, -137.9422, 102.2445, 3.1172, 5.0);
            PadiIndex[playerid] = 4;
        } else if (PadiIndex[playerid] == 4) {
            PadiIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, -137.9422, 102.2445, 3.1172, -120.7388, 152.5986, 3.6093, 5.0);
            PadiIndex[playerid] = 5;
        } else if (PadiIndex[playerid] == 5) {
            PadiIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, -120.3800, 153.9906, 3.6221, -120.3800, 153.9906, 3.6221, 5.0);
            PadiIndex[playerid] = 6;
        } else if (PadiIndex[playerid] == 6) {
            PadiIndex[playerid] = -1;
            OnPadi[playerid] = false;
            new vid = GetPlayerVehicleID(playerid);
            DestroyVehicle(vid);

            DisablePlayerRaceCheckpoint(playerid);

            new randchance = random(2);
            if (randchance == 0) {
                objpadi[0][playerid] = CreatePlayerObject(playerid, 806, -120.4719, 100.0535, 3.1172, 0, 0, 0, 300.0);
                objpadi[1][playerid] = CreatePlayerObject(playerid, 806, -113.3886, 121.5473, 3.1172, 0, 0, 0, 300.0);
                objpadi[7][playerid] = CreatePlayerObject(playerid, 806, -130.4068, 127.7735, 3.2353, 0, 0, 0, 300.0);
                objpadi[8][playerid] = CreatePlayerObject(playerid, 806, -122.1953, 152.2816, 3.6405, 0, 0, 0, 300.0);
            }
            if (randchance == 1) {
                objpadi[4][playerid] = CreatePlayerObject(playerid, 806, -120.9507, 125.0645, 3.1172, 0, 0, 0, 300.0);
                objpadi[5][playerid] = CreatePlayerObject(playerid, 806, -129.4480, 102.2350, 3.1172, 0, 0, 0, 300.0);
                objpadi[6][playerid] = CreatePlayerObject(playerid, 806, -137.8015, 105.8149, 3.1172, 0, 0, 0, 300.0);
                objpadi[2][playerid] = CreatePlayerObject(playerid, 806, -104.8806, 147.5743, 3.1247, 0, 0, 0, 300.0);
                objpadi[3][playerid] = CreatePlayerObject(playerid, 806, -113.0978, 149.5568, 3.3532, 0, 0, 0, 300.0);
            }
        }*/
    }
    if (OnCabai[playerid] && GetPlayerVehicleID(playerid) == PlayerData[playerid][pVehiclePetaniCabai])
    {
        if (CabaiIndex[playerid] == 1) {
            CabaiIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, -153.9180, 109.0367, 3.2596, -145.3852, 161.9973, 5.3994, 5.0);
            CabaiIndex[playerid] = 2;
        } 
        else if (CabaiIndex[playerid] == 2) {
            CabaiIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, -145.3852, 161.9973, 5.3994, -162.3345, 113.7469, 3.3464, 5.0);
            CabaiIndex[playerid] = 3;
        } 
        else if (CabaiIndex[playerid] == 3) {
            CabaiIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, -162.3345, 113.7469, 3.3464, -170.3694, 116.2744, 3.3921, 5.0);
            CabaiIndex[playerid] = 4;
        } 
        else if (CabaiIndex[playerid] == 4) {
            CabaiIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, -170.3694, 116.2744, 3.3921, -163.3328, 139.8901, 4.2464, 5.0);
            CabaiIndex[playerid] = 5;
        } 
        else if (CabaiIndex[playerid] == 5) {
            CabaiIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, -155.1666, 161.6306, 5.7901, -145.3403, 160.3541, 5.2566, 5.0);
            PadiIndex[playerid] = 6;
        } 
        else if (CabaiIndex[playerid] == 6) {
            CabaiIndex[playerid] = -1;
            OnCabai[playerid] = false;
            new vid = GetPlayerVehicleID(playerid);
            DestroyVehicle(vid);

            DisablePlayerRaceCheckpoint(playerid);

            new randchance = random(2);
            if (randchance == 0) 
            {
                objcabai[0][playerid] = CreatePlayerObject(playerid, 870, -153.9180, 109.0367, 2.5, 0, 0, 0, 300.0);
                objcabai[1][playerid] = CreatePlayerObject(playerid, 870, -145.8213, 132.7391, 3.0, 0, 0, 0, 300.0);
                objcabai[7][playerid] = CreatePlayerObject(playerid, 870, -137.7154, 157.5168, 4.0, 0, 0, 0, 300.0);
                objcabai[8][playerid] = CreatePlayerObject(playerid, 870, -145.3852, 161.9973, 4.5, 0, 0, 0, 300.0);
            }
            if (randchance == 1) 
            {
                objcabai[4][playerid] = CreatePlayerObject(playerid, 870, -154.6342, 137.3800, 3.0, 0, 0, 0, 300.0);
                objcabai[5][playerid] = CreatePlayerObject(playerid, 870, -162.3345, 113.7469, 2.5, 0, 0, 0, 300.0);
                objcabai[6][playerid] = CreatePlayerObject(playerid, 870, -170.3694, 116.2744, 2.5, 0, 0, 0, 300.0);
                objcabai[2][playerid] = CreatePlayerObject(playerid, 870, -163.3328, 139.8901, 3.5, 0, 0, 0, 300.0);
                objcabai[3][playerid] = CreatePlayerObject(playerid, 870, -155.1666, 161.6306, 5.0, 0, 0, 0, 300.0);
            }
        }
    }
    if (OnTebu[playerid] && GetPlayerVehicleID(playerid) == PlayerData[playerid][pVehiclePetaniTebu])
    {
        if (TebuIndex[playerid] == 1) 
        {
            TebuIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, -143.5842, 12.2339, 2.6850, -161.5513, -32.5512, 2.6850, 5.0);
            TebuIndex[playerid] = 2;
        } 
        else if (TebuIndex[playerid] == 2) 
        {
            TebuIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, -161.5513, -32.5512, 2.6850, -166.0614, -26.2519, 2.6850, 5.0);
            TebuIndex[playerid] = 3;
        } 
        else if (TebuIndex[playerid] == 3) 
        {
            TebuIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, -166.0614, -26.2519, 2.6850, -151.9609, 11.8928, 3.0830, 5.0);
            TebuIndex[playerid] = 4;
        } 
        else if (TebuIndex[playerid] == 4) 
        {
            TebuIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, -151.9609, 11.8928, 3.0830, -135.4940, 57.3936, 3.1172, 5.0);
            TebuIndex[playerid] = 5;
        } 
        else if (TebuIndex[playerid] == 5) 
        {
            TebuIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, -135.4940, 57.3936, 3.1172, -157.0300, 31.1041, 3.0825, 5.0);
            TebuIndex[playerid] = 6;
        } 
        else if (TebuIndex[playerid] == 6) 
        {
            TebuIndex[playerid] = -1;
            OnTebu[playerid] = false;
            new vid = GetPlayerVehicleID(playerid);
            DestroyVehicle(vid);

            DisablePlayerRaceCheckpoint(playerid);

            new randchance = random(2);
            if (randchance == 0) 
            {
                objtebu[0][playerid] = CreatePlayerObject(playerid, 818, -125.9183, 59.3488, 1.0, 0, 0, 0, 300.0);
                objtebu[1][playerid] = CreatePlayerObject(playerid, 818, -143.5842, 12.2339, 1.0, 0, 0, 0, 300.0);
                objtebu[7][playerid] = CreatePlayerObject(playerid, 818, -153.0560, 29.4733, 1.0, 0, 0, 0, 300.0);
                objtebu[8][playerid] = CreatePlayerObject(playerid, 818, -166.8356, -7.0291, 1.0, 0, 0, 0, 300.0);
            }
            if (randchance == 1) 
            {
                objtebu[4][playerid] = CreatePlayerObject(playerid, 818, -153.3865, 7.6404, 1.0, 0, 0, 0, 300.0);
                objtebu[5][playerid] = CreatePlayerObject(playerid, 818, -134.6685, 56.9448, 1.0, 0, 0, 0, 300.0);
                objtebu[6][playerid] = CreatePlayerObject(playerid, 818, -140.7485, 65.1926, 1.0, 0, 0, 0, 300.0);
                objtebu[2][playerid] = CreatePlayerObject(playerid, 818, -161.5513, -32.5512, 1.0, 0, 0, 0, 300.0);
                objtebu[3][playerid] = CreatePlayerObject(playerid, 818, -166.0614, -26.2519, 1.0, 0, 0, 0, 300.0);
            }
        }
    }
    if (OnGaram[playerid] && GetPlayerVehicleID(playerid) == PlayerData[playerid][pVehiclePetaniGaram])
    {
        if (GaramIndex[playerid] == 1) 
        {
            GaramIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, 163.5747, 140.9785, 2.0322, 197.4598, 146.5734, 2.02370, 5.0);
            GaramIndex[playerid] = 2;
        } 
        else if (GaramIndex[playerid] == 2) {
            GaramIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, 197.4598, 146.5734, 2.0237, 194.9090, 155.4906, 1.2074, 5.0);
            GaramIndex[playerid] = 3;
        } 
        else if (GaramIndex[playerid] == 3) 
        {
            GaramIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, 194.9090, 155.4906, 1.2074, -168.4257, 155.7041, 0.9314, 5.0);
            GaramIndex[playerid] = 4;
        } 
        else if (GaramIndex[playerid] == 4) 
        {
            GaramIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, 168.4257, 155.7041, 0.9314, 154.6527, 149.4088, 1.0648, 5.0);
            GaramIndex[playerid] = 5;
        } else if (GaramIndex[playerid] == 5) 
        {
            GaramIndex[playerid]++;
            DisablePlayerRaceCheckpoint(playerid);
            SetPlayerRaceCheckpoint(playerid, 0, 154.6527, 149.4088, 1.0648, 110.4266, 138.6105, 2.0302, 5.0);
            GaramIndex[playerid] = 6;
        } else if (GaramIndex[playerid] == 6) 
        {
            GaramIndex[playerid] = -1;
            OnGaram[playerid] = false;
            new vid = GetPlayerVehicleID(playerid);
            DestroyVehicle(vid);

            DisablePlayerRaceCheckpoint(playerid);

            new randchance = random(2);
            if (randchance == 0) 
            {
                objgaram[0][playerid] = CreatePlayerObject(playerid, 854, 133.3274, 137.5928, 0.5, 0, 0, 0, 300.0);
                objgaram[1][playerid] = CreatePlayerObject(playerid, 854, 163.5747, 140.9785, 0.5, 0, 0, 0, 300.0);
                objgaram[7][playerid] = CreatePlayerObject(playerid, 854, 140.5071, 143.9965, 0.5, 0, 0, 0, 300.0);
                objgaram[8][playerid] = CreatePlayerObject(playerid, 854, 110.4266, 138.6105, 0.5, 0, 0, 0, 300.0);
            }
            if (randchance == 1) 
            {
                objgaram[4][playerid] = CreatePlayerObject(playerid, 854, 168.4257, 155.7041, 0.5, 0, 0, 0, 300.0);
                objgaram[5][playerid] = CreatePlayerObject(playerid, 854, 154.6527, 149.4088, 0.5, 0, 0, 0, 300.0);
                objgaram[6][playerid] = CreatePlayerObject(playerid, 854, 159.3219, 157.3833, 0.5, 0, 0, 0, 300.0);
                objgaram[2][playerid] = CreatePlayerObject(playerid, 854, 197.4598, 146.5734, 0.5, 0, 0, 0, 300.0);
                objgaram[3][playerid] = CreatePlayerObject(playerid, 854, 194.9090, 155.4906, 0.5, 0, 0, 0, 300.0);
            }
        }
    }
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	if(pData[playerid][pBusRoute] && IsABusVeh(GetPlayerVehicleID(playerid)))
	{
		pData[playerid][pBuswaiting] = false;
		HideNotifBoxinfo(playerid);
	}
	new vehicleid = GetPlayerVehicleID(playerid);
	if(pData[playerid][pBus] && GetVehicleModel(vehicleid) == 431)
	{
		pData[playerid][pBuswaiting] = false;
		InfoTD_Hide(playerid);
		HideNotifBoxinfo(playerid);
	}
	return 1;
}

forward JobForklift(playerid);
public JobForklift(playerid)
{
	TogglePlayerControllable(playerid, 1);
	GameTextForPlayer(playerid, "~w~SELESAI!", 5000, 3);
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_NO))
	{
	    if(pData[playerid][CarryingLumber])
		{
			Player_DropLumber(playerid);
		}
	}
	if((newkeys & KEY_SECONDARY_ATTACK))
    {
		foreach(new did : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
			{
				if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
					return Error(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

				if(dData[did][dLocked])
					return Error(playerid, "This entrance is locked at the moment.");
					
				if(dData[did][dFaction] > 0)
				{
					if(dData[did][dFaction] != pData[playerid][pFaction])
						return Error(playerid, "This door only for faction.");
				}
				if(dData[did][dFamily] > 0)
				{
					if(dData[did][dFamily] != pData[playerid][pFamily])
						return Error(playerid, "This door only for family.");
				}
				
				if(dData[did][dVip] > pData[playerid][pVip])
					return Error(playerid, "Your VIP level not enough to enter this door.");
				
				if(dData[did][dAdmin] > pData[playerid][pAdmin])
					return Error(playerid, "Your admin level not enough to enter this door.");
					
				if(strlen(dData[did][dPass]))
				{
					new params[256];
					if(sscanf(params, "s[256]", params)) return Usage(playerid, "/enter [password]");
					if(strcmp(params, dData[did][dPass])) return Error(playerid, "Invalid door password.");
					
					if(dData[did][dCustom])
					{
						SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					else
					{
						SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					pData[playerid][pInDoor] = did;
					SetPlayerInterior(playerid, dData[did][dIntint]);
					SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, 0);
					TogglePlayerControllable(playerid, 0);
					SetTimerEx("TimerUntogglePlayer", 5000, 0, "d", playerid);
					InfoTD_MSG(playerid, 3000, "Loading Object...");
				}
				else
				{
					if(dData[did][dCustom])
					{
						SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					else
					{
						SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					pData[playerid][pInDoor] = did;
					SetPlayerInterior(playerid, dData[did][dIntint]);
					SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, 0);
					TogglePlayerControllable(playerid, 0);
					SetTimerEx("TimerUntogglePlayer", 5000, 0, "d", playerid);
					InfoTD_MSG(playerid, 3000, "Loading Object...");
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]))
			{
				if(dData[did][dFaction] > 0)
				{
					if(dData[did][dFaction] != pData[playerid][pFaction])
						return Error(playerid, "This door only for faction.");
				}
				
				if(dData[did][dCustom])
				{
					SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
				}
				else
				{
					SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
				}
				pData[playerid][pInDoor] = -1;
				SetPlayerInterior(playerid, dData[did][dExtint]);
				SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
			}
        }
		//Bisnis
		foreach(new bid : Bisnis)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
			{
				if(bData[bid][bIntposX] == 0.0 && bData[bid][bIntposY] == 0.0 && bData[bid][bIntposZ] == 0.0)
					return Error(playerid, "Interior bisnis masih kosong, atau tidak memiliki interior.");

				if(bData[bid][bLocked] >= 2)
					return Error(playerid, "Bisnis ini sedang disegel oleh pemerintah");
				
				if(bData[bid][bLocked])
					return Error(playerid, "This bisnis is locked!");
					
				pData[playerid][pInBiz] = bid;
				SetPlayerPositionEx(playerid, bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ], bData[bid][bIntposA]);
				
				SetPlayerInterior(playerid, bData[bid][bInt]);
				SetPlayerVirtualWorld(playerid, bid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
				SetTimerEx("TimerUntogglePlayer", 3000, 0, "d", playerid);
				InfoTD_MSG(playerid, 3000, "Loading Object...");
			}
        }
		new inbisnisid = pData[playerid][pInBiz];
		if(pData[playerid][pInBiz] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, bData[inbisnisid][bIntposX], bData[inbisnisid][bIntposY], bData[inbisnisid][bIntposZ]))
		{
			pData[playerid][pInBiz] = -1;
			SetPlayerPositionEx(playerid, bData[inbisnisid][bExtposX], bData[inbisnisid][bExtposY], bData[inbisnisid][bExtposZ], bData[inbisnisid][bExtposA]);
			
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Houses
		foreach(new hid : Houses)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
			{
				if(hData[hid][hIntposX] == 0.0 && hData[hid][hIntposY] == 0.0 && hData[hid][hIntposZ] == 0.0)
					return Error(playerid, "Interior house masih kosong, atau tidak memiliki interior.");

				if(hData[hid][hLocked] >= 2)
					return Error(playerid, "Rumah ini sedang disegel oleh pemerintah");

				if(hData[hid][hLocked])
					return Error(playerid, "This house is locked!");
				
				pData[playerid][pInHouse] = hid;
				SetPlayerPositionEx(playerid, hData[hid][hIntposX], hData[hid][hIntposY], hData[hid][hIntposZ], hData[hid][hIntposA]);
				
				SetPlayerInterior(playerid, hData[hid][hInt]);
				SetPlayerVirtualWorld(playerid, hid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
				SetTimerEx("TimerUntogglePlayer", 3000, 0, "d", playerid);
				InfoTD_MSG(playerid, 3000, "Loading Object...");
			}
        }
		new inhouseid = pData[playerid][pInHouse];
		if(pData[playerid][pInHouse] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, hData[inhouseid][hIntposX], hData[inhouseid][hIntposY], hData[inhouseid][hIntposZ]))
		{
			pData[playerid][pInHouse] = -1;
			SetPlayerPositionEx(playerid, hData[inhouseid][hExtposX], hData[inhouseid][hExtposY], hData[inhouseid][hExtposZ], hData[inhouseid][hExtposA]);
			
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Family
		foreach(new fid : FAMILYS)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ]))
			{
				if(fData[fid][fIntposX] == 0.0 && fData[fid][fIntposY] == 0.0 && fData[fid][fIntposZ] == 0.0)
					return Error(playerid, "Interior masih kosong, atau tidak memiliki interior.");

				if(pData[playerid][pFaction] == 0)
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have registered for this door!");
					
				SetPlayerPositionEx(playerid, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ], fData[fid][fIntposA]);

				SetPlayerInterior(playerid, fData[fid][fInt]);
				SetPlayerVirtualWorld(playerid, fid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
				SetTimerEx("TimerUntogglePlayer", 3000, 0, "d", playerid);
				InfoTD_MSG(playerid, 3000, "Loading Object...");
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ]))
			{
				SetPlayerPositionEx(playerid, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ], fData[fid][fExtposA]);

				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
				//pData[playerid][pInBiz] = -1;
			}
        }
	}
	//SAPD Taser/Tazer
	if(newkeys & KEY_FIRE && TaserData[playerid][TaserEnabled] && GetPlayerWeapon(playerid) == 0 && !IsPlayerInAnyVehicle(playerid) && TaserData[playerid][TaserCharged])
	{
  		TaserData[playerid][TaserCharged] = false;

	    new Float: x, Float: y, Float: z, Float: health;
     	GetPlayerPos(playerid, x, y, z);
	    PlayerPlaySound(playerid, 6003, 0.0, 0.0, 0.0);
	    ApplyAnimation(playerid, "KNIFE", "KNIFE_3", 4.1, 0, 1, 1, 0, 0, 1);
		pData[playerid][pActivityTime] = 0;
	    TaserData[playerid][ChargeTimer] = SetTimerEx("ChargeUp", 1000, true, "i", playerid);
		PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Recharge...");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);

	    for(new i, maxp = GetPlayerPoolSize(); i <= maxp; ++i)
		{
	        if(!IsPlayerConnected(i)) continue;
          	if(playerid == i) continue;
          	if(TaserData[i][TaserCountdown] != 0) continue;
          	if(IsPlayerInAnyVehicle(i)) continue;
			if(GetPlayerDistanceFromPoint(i, x, y, z) > 2.0) continue;
			ClearAnimations(i, 1);
			TogglePlayerControllable(i, false);
   			ApplyAnimation(i, "CRACK", "crckdeth2", 4.1, 0, 0, 0, 1, 0, 1);
			PlayerPlaySound(i, 6003, 0.0, 0.0, 0.0);

			GetPlayerHealth(i, health);
			TaserData[i][TaserCountdown] = TASER_BASETIME + floatround((100 - health) / 12);
   			Info(i, "You got tased for %d secounds!", TaserData[i][TaserCountdown]);
			TaserData[i][GetupTimer] = SetTimerEx("TaserGetUp", 1000, true, "i", i);
			break;
	    }
	}
	/*if((newkeys & KEY_YES))
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, 2073.2756,2350.9692,-89.1698))
		{
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");

		    new Dstring[512];
			format(Dstring, sizeof(Dstring), "Nama Minuman\tHarga Minuman\n\
			{ffffff}Vodka\t$60\n");
			format(Dstring, sizeof(Dstring), "{ffffff}%sCiu\t$15\n", Dstring);
			format(Dstring, sizeof(Dstring), "{ffffff}%sAmer\t$35\n", Dstring);
			ShowPlayerDialog(playerid, DIALOG_BAHAMAS, DIALOG_STYLE_TABLIST_HEADERS, "{00FFE5}Bahamas {FFFFFF}- Minuman", Dstring, "Beli", "Batal");
		}
	}*/
	if(newkeys & KEY_YES)
	{
        foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 1) && i != playerid)
		{
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
			ShowPlayerDialog(playerid, DIALOG_PLAYERMENU, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha{FFFFFF} - Player Menu", "Kategori\nIkat -> Untuk Mengikat Tangan Pemain\n{BABABA}Lepas Ikatan -> Untuk melepas ikatan\n{FFFFFF}Geledah {FFFFFf}-> Untuk melihat barang orang", "Pilih", "Tutup");
			//ShowPlayerDialog(playerid, DIALOG_PLAYERMENU, DIALOG_STYLE_TABLIST_HEADERS, "{15D4ED}Konoha{FFFFFF} - Player Menu", "Kategori\tPenjelasan\n{BABABA}Faction Menu\t{BABABA}-> Untuk membuka menu faction", "Pilih", "Tutup");
		}
	}
	//RENTAL
	if(PRESSED( KEY_WALK ) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		foreach(new rnid : Rental)
		{
			if(IsPlayerInRangeOfPoint(playerid, 5.0, rnData[rnid][rExtposX], rnData[rnid][rExtposY], rnData[rnid][rExtposZ]))
			{
				pData[playerid][pGetRENID] = rnid;
				Rental_BuyMenu(playerid, rnid);
			}
		}
	}
	// PEDAGANG
	if(PRESSED( KEY_YES ) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
    	foreach(new pid : Pedagang)
		{
    		if(IsPlayerInRangeOfPoint(playerid, 4.0, pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ]))
			{
				if(pData[playerid][pFaction] != 5)
    				return ErrorMsg(playerid, "You must be part of a Pedagang faction.");
				ShowPedagangMenu(playerid, pid);
			}
		}
    }
	if(newkeys & KEY_YES)
	{
	    if(pData[playerid][pFaction] == 5)
        {
            if(IsPlayerInRangeOfPoint(playerid, 1.5, 1200.3564,-890.8854,44.2015))
			{
				return callcmd::cooking(playerid, "");
			}
		}
	}
	//GUN RELOAD
	if (newkeys & KEY_YES)
	{
	    if (PlayerData[playerid][pUsedMagazine])
	    {
	        new weaponid = PlayerData[playerid][pHoldWeapon];

	        switch (weaponid)
	        {
			    case 22:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

				    pData[playerid][pColt45]--;
			        //Inventory_Remove(playerid, "Colt 45");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 64);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
				case 24:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

				    pData[playerid][pDesertEagle]--;
			        //Inventory_Remove(playerid, "Desert Eagle");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 64);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
				case 25:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

				    pData[playerid][pShotgun]--;
			        //Inventory_Remove(playerid, "Shotgun");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 64);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
				case 28:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

				    pData[playerid][pMicroSMG]--;
			        //Inventory_Remove(playerid, "Micro SMG");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 100);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
				case 29:
       			{
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

				    pData[playerid][pMP5]--;
			        //Inventory_Remove(playerid, "MP5");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 100);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
				case 32:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

				    pData[playerid][pTec9]--;
			        //Inventory_Remove(playerid, "Tec-9");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 100);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
				case 30:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

				    pData[playerid][pAK47]--;
			        //Inventory_Remove(playerid, "AK-47");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 100);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
				case 33:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

				    pData[playerid][pRifle]--;
			       	//Inventory_Remove(playerid, "Rifle");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 100);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
		        case 34:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

				    pData[playerid][pSniper]--;
			        //Inventory_Remove(playerid, "Sniper");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 50);
					SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Memegang senjata dan mengokangnya.");
                    SetPlayerChatBubble(playerid, "> Memegang senjata yang ia miliki dan mengokangnya <", COLOR_GREEN, 30.0, 5000);
				}
			}
			return 1;
	    }
	}
    if (newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if (PlayerData[playerid][pHoldWeapon] > 0)
		{
		    if (PlayerData[playerid][pUsedMagazine])
		    	pData[playerid][pClip]++;
      			//Inventory_Add(playerid, "Clip", 19995);

		    HoldWeapon(playerid, 0);
			SendClientMessageEx(playerid, COLOR_WHITE, "ACTION : {D0AEEB}Menyimpan senjata kedalam inventory dengan bantuan kedua tangan.");
            SetPlayerChatBubble(playerid, "> Menyimpan senjata yang ia miliki kedalam inventory <", COLOR_PURPLE, 30.0, 5000);
		}
		return 1;
	}
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 1376.2773,1576.6027,17.0003))
		{
		    if(pData[playerid][pIDCard] == 0) return ErrorMsg(playerid, "Anda tidak memiliki ID Card!");
			PlayerPlaySound(playerid, 5202, 0,0,0);
			new string[1000];
		    format(string, sizeof(string), "{ffffff}Pekerjaan\t\tSedang Bekerja\n{ffffff}Penambang\t\t{FFFF00}%d Orang\n{ffffff}Lumber Jack\t\t{FFFF00}%d Orang\n{ffffff}Trucker\t\t{FFFF00}%d Orang\n{ffffff}Miner\t\t{FFFF00}%d Orang\n{ffffff}Production\t\t{FFFF00}%d Orang\n{ffffff}Farmer\t\t{FFFF00}%d Orang\n{ffffff}Hauling\t\t{FFFF00}%d Orang\n{ffffff}Pizza\t\t{FFFF00}%d Orang\n{ffffff}Butcher\t\t{FFFF00}%d Orang\n{ffffff}Reflenish\t\t{FFFF00}%d Orang\n{ffffff}Pemerah Susu\t\t{FFFF00}%d Orang\n{ffffff}Tukang Kayu\t\t{FFFF00}%d Orang\n{ffffff}Penjahit\t\t{FFFF00}%d Orang\n{ffffff}Tukang Ayam\t\t{FFFF00}%d Orang\n{ffffff}Penambang Minyak\t\t{FFFF00}%d Orang\n{ffffff}Recycle Rise\t\t{FFFF00}%d Orang\n{ffffff}Sopir Bus Kota\t\t{FFFF00}%d Orang\n"RED_E"Keluar dari pekerjaan",
		 	penambang,
		 	lumberjack,
		 	trucker,
		 	miner,
		 	production,
		 	farmers,
		 	hauling,
		 	pizza,
		 	butcher,
		 	reflenish,
		 	pemerassusu,
		 	tukangkayu,
		 	penjahitt, //Penjahit
		 	tukangayams,
		 	penambangminyak,
		 	Recycler,
		 	Sopirbus
		    );
	    	ShowPlayerDialog(playerid, DIALOG_DISNAKER, DIALOG_STYLE_TABLIST_HEADERS, "{7fffd4}Dinas Tenaga Kerja {15D4ED}Konoha", string, "Pilih", "Batal");
		}
	}
	//JOB BUS KOTA
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 1, -604.5494,-523.3740,25.6222))
		{
            if(pData[playerid][pJob] != 27) return 1;
		    if(pData[playerid][pBusTime] > 0)
		    	return	ErrorMsg(playerid, "Anda harus menunggu.");
		    	
	    	pData[playerid][pKendaraanKerja] = CreateVehicle(431, -604.5494,-523.3740,25.6222,269.9323, 0, 0, 120000, 0);
			PutPlayerInVehicle(playerid, pData[playerid][pKendaraanKerja], 0);
	    	SetVehicleNumberPlate(pData[playerid][pKendaraanKerja], "JOB VEHICLE");
	    	//pData[playerid][pBusRute] = 1;
	    	new tmpobjid;
	    	tmpobjid = CreateDynamicObject(7313,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10837, "airroadsigns_sfse", "ws_airbigsign1", 0);
		    SetDynamicObjectMaterial(tmpobjid, 1, 16646, "a51_alpha", "des_rails1", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "BANDARA - BUS", 80, "Arial", 30, 0, 0xFF555999, 0xFF000000, 1);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.274, 0.464, -0.120, 0.000, 0.000, 89.899);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.330, -2.455, 0.490, 0.000, 0.000, 90.099);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.349, -4.018, 0.490, 0.000, 0.000, 90.999);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "u", 90, "Webdings", 100, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.411, -3.781, 0.550, 0.000, 0.000, 90.799);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Valrise Transit", 90, "Times New Roman", 45, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.427, -3.071, 0.480, 0.000, 0.000, 91.600);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "BUS", 90, "Times New Roman", 65, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.342, -2.997, 0.210, 0.000, 0.000, 91.299);
		    tmpobjid = CreateDynamicObject(7313,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10837, "airroadsigns_sfse", "ws_airbigsign1", 0);
		    SetDynamicObjectMaterial(tmpobjid, 1, 16646, "a51_alpha", "des_rails1", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "BANDARA - BUS", 80, "Arial", 30, 0, 0xFF555999, 0xFF000000, 1);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.322, 0.442, -0.090, 0.000, 0.000, -90.900);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.345, -1.662, 0.490, 0.000, 0.000, -90.000);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.342, -3.243, 0.490, 0.000, 0.000, -90.299);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "u", 90, "Webdings", 100, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.400, -4.109, 0.550, 0.000, 0.000, -91.899);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Valrise Transit", 90, "Times New Roman", 48, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.448, -2.595, 0.440, 0.000, 0.000, -84.799);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "BUS", 90, "Times New Roman", 65, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.397, -3.351, 0.150, 0.000, 0.000, -89.399);
			pData[playerid][pCheckPoint] = CHECKPOINT_BUS;
			pData[playerid][pBusTime] = 360;
			pData[playerid][pBus] = 1;
			SetPlayerRaceCheckpoint(playerid, 2, -557.1394,-515.4979,25.1791, -557.1394,-515.4979,25.1791, 4.0);
			InfoMsg(playerid, "Ikuti Checkpoint!");
			SwitchVehicleEngine(pData[playerid][pKendaraanKerja], true);
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1, -603.7074,-510.1997,25.6245))
		{
            if(pData[playerid][pJob] != 27) return 1;
		    if(pData[playerid][pBusTime] > 0)
		    	return	ErrorMsg(playerid, "Anda harus menunggu.");

	    	pData[playerid][pKendaraanKerja] = CreateVehicle(431, -603.7074,-510.1997,25.6245,269.2456, 0, 0, 120000, 0);
			PutPlayerInVehicle(playerid, pData[playerid][pKendaraanKerja], 0);
	    	SetVehicleNumberPlate(pData[playerid][pKendaraanKerja], "JOB VEHICLE");
	    	SwitchVehicleEngine(pData[playerid][pKendaraanKerja], true);
	    	//pData[playerid][pBusRute] = 2;
	    	new tmpobjid;
	    	tmpobjid = CreateDynamicObject(7313,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10837, "airroadsigns_sfse", "ws_airbigsign1", 0);
		    SetDynamicObjectMaterial(tmpobjid, 1, 16646, "a51_alpha", "des_rails1", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Las Venturas Bus", 80, "Arial", 30, 0, 0xFF555999, 0xFF000000, 1);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.274, 0.464, -0.120, 0.000, 0.000, 89.899);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.330, -2.455, 0.490, 0.000, 0.000, 90.099);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.349, -4.018, 0.490, 0.000, 0.000, 90.999);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "u", 90, "Webdings", 100, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.411, -3.781, 0.550, 0.000, 0.000, 90.799);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Valrise Transit", 90, "Times New Roman", 45, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.427, -3.071, 0.480, 0.000, 0.000, 91.600);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "BUS", 90, "Times New Roman", 65, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.342, -2.997, 0.210, 0.000, 0.000, 91.299);
		    tmpobjid = CreateDynamicObject(7313,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10837, "airroadsigns_sfse", "ws_airbigsign1", 0);
		    SetDynamicObjectMaterial(tmpobjid, 1, 16646, "a51_alpha", "des_rails1", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Las Venturas Bus", 80, "Arial", 30, 0, 0xFF555999, 0xFF000000, 1);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.322, 0.442, -0.090, 0.000, 0.000, -90.900);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.345, -1.662, 0.490, 0.000, 0.000, -90.000);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.342, -3.243, 0.490, 0.000, 0.000, -90.299);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "u", 90, "Webdings", 100, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.400, -4.109, 0.550, 0.000, 0.000, -91.899);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Valrise Transit", 90, "Times New Roman", 48, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.448, -2.595, 0.440, 0.000, 0.000, -84.799);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "BUS", 90, "Times New Roman", 65, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.397, -3.351, 0.150, 0.000, 0.000, -89.399);
			pData[playerid][pBusTime] = 360;
			pData[playerid][pBus] = 66;
			SetPlayerRaceCheckpoint(playerid, 2, cpbus1, cpbus1, 4.0);
			pData[playerid][pCheckPoint] = CHECKPOINT_BUS;
			InfoMsg(playerid, "Ikuti Checkpoint!");
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1, -604.1620,-517.0234,25.6216))
		{
            if(pData[playerid][pJob] != 27) return 1;
		    if(pData[playerid][pBusTime] > 0)
		    	return	ErrorMsg(playerid, "Anda harus menunggu.");

	    	pData[playerid][pKendaraanKerja] = CreateVehicle(431, -604.1620,-517.0234,25.6216,270.0434, 0, 0, 120000, 0);
			PutPlayerInVehicle(playerid, pData[playerid][pKendaraanKerja], 0);
	    	SetVehicleNumberPlate(pData[playerid][pKendaraanKerja], "JOB VEHICLE");
	    	SwitchVehicleEngine(pData[playerid][pKendaraanKerja], true);
	    	//pData[playerid][pBusRute] = 3;
	    	new tmpobjid;
	    	tmpobjid = CreateDynamicObject(7313,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10837, "airroadsigns_sfse", "ws_airbigsign1", 0);
		    SetDynamicObjectMaterial(tmpobjid, 1, 16646, "a51_alpha", "des_rails1", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Pelabuhan Bus", 80, "Arial", 30, 0, 0xFF555999, 0xFF000000, 1);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.274, 0.464, -0.120, 0.000, 0.000, 89.899);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.330, -2.455, 0.490, 0.000, 0.000, 90.099);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.349, -4.018, 0.490, 0.000, 0.000, 90.999);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "u", 90, "Webdings", 100, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.411, -3.781, 0.550, 0.000, 0.000, 90.799);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Valrise Transit", 90, "Times New Roman", 45, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.427, -3.071, 0.480, 0.000, 0.000, 91.600);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "BUS", 90, "Times New Roman", 65, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.342, -2.997, 0.210, 0.000, 0.000, 91.299);
		    tmpobjid = CreateDynamicObject(7313,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10837, "airroadsigns_sfse", "ws_airbigsign1", 0);
		    SetDynamicObjectMaterial(tmpobjid, 1, 16646, "a51_alpha", "des_rails1", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Pelabuhan Bus", 80, "Arial", 30, 0, 0xFF555999, 0xFF000000, 1);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.322, 0.442, -0.090, 0.000, 0.000, -90.900);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.345, -1.662, 0.490, 0.000, 0.000, -90.000);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.342, -3.243, 0.490, 0.000, 0.000, -90.299);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "u", 90, "Webdings", 100, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.400, -4.109, 0.550, 0.000, 0.000, -91.899);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Valrise Transit", 90, "Times New Roman", 48, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.448, -2.595, 0.440, 0.000, 0.000, -84.799);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "BUS", 90, "Times New Roman", 65, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.397, -3.351, 0.150, 0.000, 0.000, -89.399);
			pData[playerid][pBusTime] = 360;
			pData[playerid][pBus] = 120;
			SetPlayerRaceCheckpoint(playerid, 2, buscp1, buscp1, 4.0);
			pData[playerid][pCheckPoint] = CHECKPOINT_BUS;
			InfoMsg(playerid, "Ikuti Checkpoint!");
			return 1;
		}
	}
	//JOB DAUR ULANG
	if(newkeys & KEY_WALK)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3, -887.2399,-479.9101,826.8417))
        {
        	callcmd::ambilbox(playerid, "");
        }
		else  if(IsPlayerInRangeOfPoint(playerid, 3, -893.2037,-490.6880,826.8417))
        {
        	callcmd::ambilbox(playerid, "");
        }
		else  if(IsPlayerInRangeOfPoint(playerid, 3, -898.6295,-500.8337,826.8417))
        {
        	callcmd::ambilbox(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, -927.1517,-486.4165,826.8417))
        {
        	callcmd::penyortiran(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, -926.8005,-471.0959,826.8417))
        {
        	callcmd::penyortiran(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, -926.9293,-500.5975,826.8417))
        {
        	callcmd::penyortiran(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, -920.0016,-468.0568,826.8417))
        {
        	callcmd::mulaikerjabox1(playerid, "");
        }
		else if(IsPlayerInRangeOfPoint(playerid, 3, 34.4547,1365.0729,9.1719))
        {
        	callcmd::Daurulang(playerid, "");
        }
		 else if(IsPlayerInRangeOfPoint(playerid, 3, 34.9240,1379.4988,9.1719))
        {
        	callcmd::Daurulang(playerid, "");
        }
		 else if(IsPlayerInRangeOfPoint(playerid, 3, 34.9276,1351.1335,9.1719))
        {
        	callcmd::Daurulang(playerid, "");
        }
	}
	//JOB KAYU
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, -450.1685,-45.4697,59.6945))
        {
            if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            if (pData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (pData[playerid][pJob] != 21) return ErrorMsg(playerid, "Kamu bukan seorang Tukang Kayu.");
            if(pData[playerid][pKayu] > 50) return ErrorMsg(playerid, "Anda tidak dapat membawa 50 kayu");
            //pData[playerid][pTukangkayu] = 1;
            ApplyAnimation(playerid, "BD_FIRE", "WEAPON_csaw", 4.1, 0, 0, 0, 0, 0, 1);
            ShowProgressbar(playerid, "Memotong Kayu..", 5);
            SetTimerEx("kayu1", 5000, false, "d", playerid);
            SetPlayerChainsaw(playerid, true);
        }
        if(IsPlayerInRangeOfPoint(playerid, 2.0, -449.8972,-51.5766,59.6385))
        {
            if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            if (pData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (pData[playerid][pJob] != 21) return ErrorMsg(playerid, "Kamu bukan seorang Tukang Kayu.");
            if(pData[playerid][pKayu] > 50) return ErrorMsg(playerid, "Anda tidak dapat membawa 50 kayu");
            //pData[playerid][pTukangkayu] = 2;
            ApplyAnimation(playerid, "BD_FIRE", "WEAPON_csaw", 4.1, 0, 0, 0, 0, 0, 1);
            ShowProgressbar(playerid, "Memotong Kayu..", 5);
            SetTimerEx("kayu1", 5000, false, "d", playerid);
            SetPlayerChainsaw(playerid, true);
        }
        if(IsPlayerInRangeOfPoint(playerid, 2.0, -443.2688,-51.1891,59.3676))
        {
            if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            if (pData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (pData[playerid][pJob] != 21) return ErrorMsg(playerid, "Kamu bukan seorang Tukang Kayu.");
            if(pData[playerid][pKayu] > 50) return ErrorMsg(playerid, "Anda tidak dapat membawa 50 kayu");
            //pData[playerid][pTukangkayu] = 3;
            ApplyAnimation(playerid, "BD_FIRE", "WEAPON_csaw", 4.1, 0, 0, 0, 0, 0, 1);
            ShowProgressbar(playerid, "Memotong Kayu..", 5);
            SetTimerEx("kayu1", 5000, false, "d", playerid);
            SetPlayerChainsaw(playerid, true);
        }
        if(IsPlayerInRangeOfPoint(playerid, 2.0, -443.3006,-45.8996,59.4077))
        {
            if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            if (pData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (pData[playerid][pJob] != 21) return ErrorMsg(playerid, "Kamu bukan seorang Tukang Kayu.");
            if(pData[playerid][pKayu] > 50) return ErrorMsg(playerid, "Anda tidak dapat membawa 50 kayu");
            //pData[playerid][pTukangkayu] = 0;
            ApplyAnimation(playerid, "BD_FIRE", "WEAPON_csaw", 4.1, 0, 0, 0, 0, 0, 1);
            ShowProgressbar(playerid, "Memotong Kayu..", 5);
            SetTimerEx("kayu1", 5000, false, "d", playerid);
            SetPlayerChainsaw(playerid, true);
        }

        if(IsPlayerInRangeOfPoint(playerid, 1.5, -435.8718,-73.5172,58.8910))
        {
            if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            if (pData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (pData[playerid][pJob] != 21) return ErrorMsg(playerid, "Kamu bukan seorang Tukang Kayu.");
            if(pData[playerid][pKayu] < 1) return ErrorMsg(playerid, "Kamu tidak memiliki kayu!");
            {
                ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
                ShowProgressbar(playerid, "Gergaji Kayu..", 5);
                SetTimerEx("kayu2", 5000, false, "d", playerid);
                SetPlayerChainsaw(playerid, true);
            }
        }
        if(IsPlayerInRangeOfPoint(playerid, 1.5, -435.6222,-76.1013,58.8612))
        {
            if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            if (pData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (pData[playerid][pJob] != 21) return ErrorMsg(playerid, "Kamu bukan seorang Tukang Kayu.");
            if(pData[playerid][pKayu] < 1) return ErrorMsg(playerid, "Kamu tidak memiliki kayu!");
            {
                ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
                ShowProgressbar(playerid, "Gergaji Kayu..", 5);
                SetTimerEx("kayu2", 5000, false, "d", playerid);
                SetPlayerChainsaw(playerid, true);
            }
        }
        if(IsPlayerInRangeOfPoint(playerid, 5.0, -463.5522,-46.0111,59.9552))
        {
            if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            if (pData[playerid][pJob] <= 0) return Error(playerid, "Kamu harus mengambil pekerjaan terlebih dahulu di disnaker.");
            if (pData[playerid][pJob] != 21) return ErrorMsg(playerid, "Kamu bukan seorang Tukang Kayu.");
            if(pData[playerid][pKayuPotong] < 4) return ErrorMsg(playerid, "Kamu tidak memiliki kayu potongan (Min:4)");
            {
                ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
                ShowProgressbar(playerid, "Mengemas Kayu..", 5);
                SetTimerEx("kayu3", 5000, false, "d", playerid);
            }
        }
	}
	//Vehicle
	/*if((newkeys & KEY_YES ))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			return callcmd::v(playerid, "engine");
		}
	}*/
	if(GetPVarInt(playerid, "UsingSprunk"))
	{
		if(pData[playerid][pEnergy] >= 100 )
		{
  			Info(playerid, " Kamu terlalu banyak minum.");
	   	}
	   	else
	   	{
		    pData[playerid][pEnergy] += 5;
		}
	}
	//RADIAL
	if((newkeys & KEY_NO))
	{
	    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		for(new i = 0; i < 54; i++)
		{
			PlayerTextDrawShow(playerid, PR_PANELSTD[playerid][i]);
		}
		SelectTextDraw(playerid, COLOR_WHITE);
	}
	//VEH PANEL
	/*if((newkeys & KEY_NO))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			return callcmd::vpanel(playerid, "");
		}
 	}*/
 	//Tempat Sampah
    if((newkeys & KEY_WALK))
	{
		if(GetNearbyTrash(playerid) >= 0)
		{
		    for(new i = 0; i < MAX_TRASH; i++)
			{
			    if(IsPlayerInRangeOfPoint(playerid, 2.3, tmData[i][tmX], tmData[i][tmY], tmData[i][tmZ]))
				{
					if(pData[playerid][sampahsaya] < 1) return ErrorMsg(playerid, "Anda tidak mempunyai sampah");
					new total = pData[playerid][sampahsaya];
					pData[playerid][sampahsaya] -= total;
					new str[500];
					format(str, sizeof(str), "Removed_%dx", total);
					ShowItemBox(playerid, "Sampah", str, 1265, total);
				    tmData[i][Sampah] += total;
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "UPDATE trashmaster SET sampah='%d' WHERE id='%d'", tmData[i][Sampah], i);
					mysql_tquery(g_SQL, query);
					ShowProgressbar(playerid, "Membuang sampah..", 1);
					ApplyAnimation(playerid,"GRENADE","WEAPON_throwu",4.0, 1, 0, 0, 0, 0, 1);
					Trash_Save(i);
				}
			}
		}
	}
	if(newkeys & KEY_WALK)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3, 494.4636,1293.1964,10.0437))
        {
        	callcmd::minyaknyabank(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, 498.3599,1296.6460,10.0437))
        {
        	callcmd::minyaknyabank2(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, 498.3147,1301.6930,10.0437))
        {
        	callcmd::minyaknyabank2(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, 569.5151,1218.7412,11.7188))
        {
        	callcmd::saringminyakbank(playerid, "");
        }
	}
	//JOB AYAM
	if(PRESSED(KEY_WALK) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
       if(IsPlayerInRangeOfPoint(playerid, 1.5, -1426.8801,-949.8837,201.0938))
        {
            if(pData[playerid][ayamcp] != 1) return 1;
        	callcmd::ambilayamdentottrtr(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1.5, -1431.3004,-948.3753,201.0938))
        {
            if(pData[playerid][ayamcp] != 2) return 1;
        	callcmd::ambilayamdentottrtr(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1.5, -1433.2196,-954.7111,200.9800))
        {
            if(pData[playerid][ayamcp] != 3) return 1;
        	callcmd::ambilayamdentottrtr(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1.5, -1424.5692,-949.8381,201.0938))
        {
            if(pData[playerid][ayamcp] != 3) return 1;
        	callcmd::ambilayamdentottrtr(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -1120.229736,-1660.261108,76.378242))
        {
        	return callcmd::potongayamdentotkontol(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -1422.421142,-967.581909,200.775970))
        {
            return callcmd::izinayamGen(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -1120.229736,-1660.261108,76.378242))
        {
        	return callcmd::potongayamdentotkontol(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -1107.819091,-1659.510375,76.378242))
        {
        	return callcmd::potongayamdentotkontol(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -1115.366333,-1653.926269,76.388252))
        {
        	return callcmd::ayampackinggen(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -1115.089233,-1657.203491,76.388252))
        {
        	return callcmd::ayampackinggen(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 2395.137695,-1495.538696,23.834865))
        {
        	return callcmd::jualayamgen(playerid, "");
        }
        /*else if(IsPlayerInRangeOfPoint(playerid, 5, 528.9647,-1819.8907,6.6213))
        {
        	return callcmd::menumasak(playerid, "");
        }*/
    }
	//SALES
	if(PRESSED( KEY_WALK ))
    {
  		if(IsPlayerInRangeOfPoint(playerid, 2.0, 2357.3823,-1990.5114,13.5469))
		{
		    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		    if(pData[playerid][pVip] > 0)
		    {
		        PlayerPlaySound(playerid, 5202, 0,0,0);
				new string[1000];
	    		format(string, sizeof(string), "Barang\t\tHarga\nEmas\t\t"LG_E"$40/{ffffff}1 emas\nBesi\t\t"LG_E"$20/{ffffff}1 Besi\nAluminium\t\t"LG_E"$40/{ffffff}1 Aluminium\nBerlian\t\t"LG_E"$280/{ffffff}1 Berlian\nIkan Tuna\t\t"LG_E"$25/{ffffff}1 Tuna\nIkan Tongkol\t\t"LG_E"$25/{ffffff}1 Tongkol\nIkan Kakap\t\t"LG_E"$25/{ffffff}1 Kakap\nIkan Kembung\t\t"LG_E"$25/{ffffff}1 Kembung\nIkan Makarel\t\t"LG_E"$25/{ffffff}1 Makarel\nIkan Tenggiri\t\t"LG_E"$25/{ffffff}1 Tenggiri\nIkan BlueMarlin\t\t"LG_E"$25/{ffffff}1 BlueMarlin\nIkan Sail\t\t"LG_E"$25/{ffffff}1 SailFish\nKayu Kemas\t\t"LG_E"$18/{ffffff}1 Kayu Kemas\nPakaian\t\t"LG_E"$65/{ffffff}1 Pakaian\nBulu\t\t"LG_E"$12/{ffffff}1 Bulu\nAyam Kemas\t\t"LG_E"$40/{ffffff}1 Ayam Kemas\nEssence\t\t"LG_E"$50/{ffffff}1 Kotak\nBotol\t\t"LG_E"$40/{ffffff}1 botol\nKaret\t\t"LG_E"$120/{ffffff}1 karet");
	   			ShowPlayerDialog(playerid, DIALOG_HOLIMARKET, DIALOG_STYLE_TABLIST_HEADERS, ""YELLOW_E"VIP {FFFFFF}Valrise Market - Penjualan", string, "Jual", "Batal");
		    }
		    else
		    {
		        PlayerPlaySound(playerid, 5202, 0,0,0);
				new string[1000];
	    		format(string, sizeof(string), "Barang\t\tHarga\nEmas\t\t"LG_E"$30/{ffffff}1 emas\nBesi\t\t"LG_E"$10/{ffffff}1 Besi\nAluminium\t\t"LG_E"$20/{ffffff}1 Aluminium\nBerlian\t\t"LG_E"$280/{ffffff}1 Berlian\nIkan Tuna\t\t"LG_E"$25/{ffffff}1 Tuna\nIkan Tongkol\t\t"LG_E"$25/{ffffff}1 Tongkol\nIkan Kakap\t\t"LG_E"$25/{ffffff}1 Kakap\nIkan Kembung\t\t"LG_E"$25/{ffffff}1 Kembung\nIkan Makarel\t\t"LG_E"$25/{ffffff}1 Makarel\nIkan Tenggiri\t\t"LG_E"$25/{ffffff}1 Tenggiri\nIkan BlueMarlin\t\t"LG_E"$25/{ffffff}1 BlueMarlin\nIkan Sail\t\t"LG_E"$25/{ffffff}1 SailFish\nKayu Kemas\t\t"LG_E"$18/{ffffff}1 Kayu Kemas\nPakaian\t\t"LG_E"$65/{ffffff}1 Pakaian\nBulu\t\t"LG_E"$12/{ffffff}1 Bulu\nAyam Kemas\t\t"LG_E"$20/{ffffff}1 Ayam Kemas\nEssence\t\t"LG_E"$20/{ffffff}1 Kotak\nBotol\t\t"LG_E"$30/{ffffff}1 botol\nKaret\t\t"LG_E"$60/{ffffff}1 karet");
	   			ShowPlayerDialog(playerid, DIALOG_HOLIMARKET, DIALOG_STYLE_TABLIST_HEADERS, "Valrise Market - Penjualan", string, "Jual", "Batal");
		    }
		}
  	}
	//PENAMBANG
	if(newkeys & KEY_WALK)
	{
		if(IsPlayerInRangeOfPoint(playerid, 1, 698.8157,881.3616,-38.2358))
        {
            if(pData[playerid][pTimeTambang1] > 0) return 1;
        	callcmd::nambangdentotz1(playerid, "");
        	pData[playerid][pTimeTambang1] = 1;
        	SetTimerEx("TungguNambang1", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, 700.6220,888.0744,-36.8952))
        {
        	if(pData[playerid][pTimeTambang2] > 0) return 1;
        	callcmd::nambangdentotz1(playerid, "");
        	pData[playerid][pTimeTambang2] = 1;
        	SetTimerEx("TungguNambang2", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, 701.1542,897.5233,-36.8892))
        {
        	if(pData[playerid][pTimeTambang3] > 0) return 1;
        	callcmd::nambangdentotz1(playerid, "");
        	pData[playerid][pTimeTambang3] = 1;
        	SetTimerEx("TungguNambang3", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, 698.3236,904.3176,-37.7373))
        {
        	if(pData[playerid][pTimeTambang4] > 0) return 1;
        	callcmd::nambangdentotz1(playerid, "");
        	pData[playerid][pTimeTambang4] = 1;
        	SetTimerEx("TungguNambang4", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, 693.0031,911.1717,-38.0931))
        {
        	if(pData[playerid][pTimeTambang5] > 0) return 1;
        	callcmd::nambangdentotz1(playerid, "");
        	pData[playerid][pTimeTambang5] = 1;
        	SetTimerEx("TungguNambang5", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, 689.9236,917.0135,-38.6226))
        {
        	if(pData[playerid][pTimeTambang6] > 0) return 1;
        	callcmd::nambangdentotz1(playerid, "");
        	pData[playerid][pTimeTambang6] = 1;
        	SetTimerEx("TungguNambang6", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, -795.9457,-1928.1815,5.7338))
        {
        	callcmd::cucibatudentotz(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, 2152.539062,-2263.646972,13.300081))
        {
        	callcmd::peleburanbatudentotz(playerid, "");
        }
	}
	if((newkeys & KEY_WALK))
	{
		if(pData[playerid][pInBiz] >= 0 && IsPlayerInRangeOfPoint(playerid, 2.5, bData[pData[playerid][pInBiz]][bPointX], bData[pData[playerid][pInBiz]][bPointY], bData[pData[playerid][pInBiz]][bPointZ]))
		{
			Bisnis_BuyMenu(playerid, pData[playerid][pInBiz]);
		}
	}
	//-----[ Bisnis ]-----
	if((newkeys & KEY_WALK))
	{
	    foreach(new bid : Bisnis2)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, bData2[bid][bExtposX2], bData2[bid][bExtposY2], bData2[bid][bExtposZ2]))
			{
				if(bData2[bid][bLocked2])
					return ErrorMsg(playerid, "Bisnis Ini Sedang Tutup!");

				pData[playerid][pInBiz] = bid;
				Bisnis_BuyMenu2(playerid, pData[playerid][pInBiz]);
			}
		}
	}
	if((newkeys & KEY_NO ))
	{
		foreach(new id : Bisnis2)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, bData2[id][bExtposX2], bData2[id][bExtposY2], bData2[id][bExtposZ2]))
			{
				if(bData2[id][bPrice2] > GetPlayerMoney(playerid)) return ErrorMsg(playerid, "Uang anda tidak cukup, anda tidak dapat membeli bisnis ini!.");
				if(strcmp(bData2[id][bOwner2], "-")) return ErrorMsg(playerid, "Someone already owns this bisnis.");
				if(pData[playerid][pVip] == 1)
				{
				    #if LIMIT_PER_PLAYER > 0
					if(Player_BisnisCount2(playerid) + 1 > 2) return ErrorMsg(playerid, "You can't buy any more bisnis.");
					#endif
				}
				else if(pData[playerid][pVip] == 2)
				{
				    #if LIMIT_PER_PLAYER > 0
					if(Player_BisnisCount2(playerid) + 1 > 3) return ErrorMsg(playerid, "You can't buy any more bisnis.");
					#endif
				}
				else if(pData[playerid][pVip] == 3)
				{
				    #if LIMIT_PER_PLAYER > 0
					if(Player_BisnisCount2(playerid) + 1 > 4) return Error(playerid, "You can't buy any more bisnis.");
					#endif
				}
				else
				{
					#if LIMIT_PER_PLAYER > 0
					if(Player_BisnisCount2(playerid) + 1 > 1) return ErrorMsg(playerid, "You can't buy any more bisnis.");
					#endif
				}
				GivePlayerMoneyEx(playerid, -bData2[id][bPrice2]);
				GetPlayerName(playerid, bData2[id][bOwner2], MAX_PLAYER_NAME);
				bData2[id][bOwnerID] = pData[playerid][pID];
				bData2[id][bVisit2] = gettime();
				new str[522], query[500];
				format(str,sizeof(str),"[BIZ]: %s membeli bisnis id %d seharga %s!", GetRPName(playerid), id, FormatMoney(bData2[id][bPrice2]));
				SuccesMsg(playerid, str);
				LogServer("Property", str);
				mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis2 SET owner='%s', ownerid='%d', visit='%d' WHERE ID='%d'", bData2[id][bOwner2], bData2[id][bOwnerID], bData2[id][bVisit2], id);
				mysql_tquery(g_SQL, query);
				Bisnis_Refresh2(id);
				Bisnis_Save2(id);
			}
		}
	}
	if((newkeys & KEY_WALK))
	{
	    foreach(new bid : ATMS)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, AtmData[bid][atmX], AtmData[bid][atmY], AtmData[bid][atmZ]))
			{
				callcmd::atm(playerid, "");
			}
		}
	}
	if((newkeys & KEY_WALK))
	{
	    foreach(new venid : Vending)
		{
			if(IsPlayerInRangeOfPoint(playerid, 5.0, vmData[venid][venX], vmData[venid][venY], vmData[venid][venZ]))
			{
				if(strcmp(vmData[venid][venOwner], "-")) 
				{
					if(vmData[venid][venDrinkPrice] > pData[playerid][pMoney]) 
						return Error(playerid, "Kamu tidak memiliki uang.");

					if(vmData[venid][venProduct] == 0)
						return Error(playerid, "vending machine ini telah kehabisan stock");

					if(vmData[venid][venDrinkPrice] == 0)
						return Error(playerid, "Harga minuman belum di set");

					if(Vending_BeingEdited(venid))
						return Error(playerid, "Vending ini sedang dalam perbaikan admin!");

					vmData[venid][venProduct] -= 1;
					vmData[venid][venMoney] += vmData[venid][venDrinkPrice];
					GivePlayerMoneyEx(playerid, -vmData[venid][venDrinkPrice]);
					pData[playerid][pEnergy] += 15;
					//Inventory_Add(playerid, "Sprunk", 2958, 1);
					Info(playerid, "Kamu telah berhasil membeli 1 botol minuman di vending machine seharga "GREEN_LIGHT"%s"WHITE_E"", FormatMoney(vmData[venid][venDrinkPrice]));
					SendNearbyMessage(playerid, 3.0, COLOR_PURPLE, "** %s membeli minuman di vending machine dan langsung meminumnya", ReturnName(playerid));
					Vending_Save(venid);
					VendingLabel_Refresh(venid);
				}
				else return Error(playerid, "Vending Machine ini belum memiliki pemilik");
			}
		}
	}
	//Duty Mech
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 1806.4253,-2022.3940,13.5735))
		{
            if(pData[playerid][pFaction] != 7) return ErrorMsg(playerid, "Anda bukan mekanik kota!");
			matadua(playerid);
			PlayerTextDrawSetString(playerid, MATATD[playerid][2], "Duty Mech");
            PlayerTextDrawSetString(playerid, MATATD[playerid][4], "Off Duty");
		}
	}
	//BANK
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, -983.95, 1448.46, 1340.62))
		{
			new string[256];
			format(string, 1000, "%s", pData[playerid][pName]);
			TextDrawSetString(TDBANKAJI[27], string);

			format(string, 1000, "%s", FormatMoney(pData[playerid][pBankMoney]));
			TextDrawSetString(TDBANKAJI[37], string);

            for(new i = 0; i < 59; i++)
			{
				TextDrawShowForPlayer(playerid, TDBANKAJI[i]);
			}
			SelectTextDraw(playerid, COLOR_LBLUE);
			Info(playerid, "Gunakan /hidebank Untuk Menghilangkan Textdraw");
		}
	}
	// STREAMER MASK SYSTEM
	if(PRESSED( KEY_WALK ))
	{
		if(pData[playerid][pMaskOn] == 1)
		{
			for(new i; i<MAX_PLAYERS; i++)
			{
				ShowPlayerNameTagForPlayer(i, playerid, 0);
			}
		}
		else if(pData[playerid][pMaskOn] == 0)
		{
			for(new i; i<MAX_PLAYERS; i++)
			{
				ShowPlayerNameTagForPlayer(i, playerid, 1);
			}
		}
		if(IsPlayerInAnyVehicle(playerid))
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(GetEngineStatus(vehicleid))
			{
				if(GetVehicleSpeed(vehicleid) <= 40)
				{
					new playerState = GetPlayerState(playerid);
					if(playerState == PLAYER_STATE_DRIVER)
					{
						SendClientMessageToAllEx(COLOR_RED, "Anti-Bug User: "GREY2_E"%s have been auto kicked for vehicle engine hack!", pData[playerid][pName]);
						KickEx(playerid);
					}
				}
			}
		}
	}
	if(PRESSED( KEY_FIRE ))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
		{
			foreach(new did : Doors)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
				{
					if(dData[did][dGarage] == 1)
					{
						if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
							return Error(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

						if(dData[did][dLocked])
							return Error(playerid, "This entrance is locked at the moment.");
							
						if(dData[did][dFaction] > 0)
						{
							if(dData[did][dFaction] != pData[playerid][pFaction])
								return Error(playerid, "This door only for faction.");
						}
						if(dData[did][dFamily] > 0)
						{
							if(dData[did][dFamily] != pData[playerid][pFamily])
								return Error(playerid, "This door only for family.");
						}
						
						if(dData[did][dVip] > pData[playerid][pVip])
							return Error(playerid, "Your VIP level not enough to enter this door.");
						
						if(dData[did][dAdmin] > pData[playerid][pAdmin])
							return Error(playerid, "Your admin level not enough to enter this door.");
							
						if(strlen(dData[did][dPass]))
						{
							new params[256];
							if(sscanf(params, "s[256]", params)) return Usage(playerid, "/enter [password]");
							if(strcmp(params, dData[did][dPass])) return Error(playerid, "Invalid door password.");
							
							if(dData[did][dCustom])
							{
								SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							else
							{
								SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							pData[playerid][pInDoor] = did;
							ShowProgressbar(playerid, "Loading Rendering", 5);
							SetPlayerInterior(playerid, dData[did][dIntint]);
							SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
							SetCameraBehindPlayer(playerid);
							SetPlayerWeather(playerid, 0);
							//TogglePlayerControllable(playerid, 0);
							//SetTimerEx("TimerUntogglePlayer", 10000, 0, "d", playerid);
						}
						else
						{
							if(dData[did][dCustom])
							{
								SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							else
							{
								SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							pData[playerid][pInDoor] = did;
							ShowProgressbar(playerid, "Loading Rendering", 5);
							SetPlayerInterior(playerid, dData[did][dIntint]);
							SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
							SetCameraBehindPlayer(playerid);
							SetPlayerWeather(playerid, 0);
							//TogglePlayerControllable(playerid, 0);
							//SetTimerEx("TimerUntogglePlayer", 10000, 0, "d", playerid);
						}
					}
				}
				if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]))
				{
					if(dData[did][dGarage] == 1)
					{
						if(dData[did][dFaction] > 0)
						{
							if(dData[did][dFaction] != pData[playerid][pFaction])
								return Error(playerid, "This door only for faction.");
						}
					
						if(dData[did][dCustom])
						{
							SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
						}
						else
						{
							SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
						}
						pData[playerid][pInDoor] = -1;
						ShowProgressbar(playerid, "Loading Rendering", 5);
						SetPlayerInterior(playerid, dData[did][dExtint]);
						SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, WorldWeather);
					}
				}
			}
		}
	}
	//if(IsKeyJustDown(KEY_CTRL_BACK,newkeys,oldkeys))
	if(PRESSED( KEY_CTRL_BACK ))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pCuffed] == 0)
		{
			ClearAnimations(playerid);
			StopLoopingAnim(playerid);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
    }
	if(IsKeyJustDown(KEY_SECONDARY_ATTACK, newkeys, oldkeys))
	{
		if(GetPVarInt(playerid, "UsingSprunk"))
		{
			DeletePVar(playerid, "UsingSprunk");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
	}
	if(PRESSED( KEY_CROUCH ))
    {
    	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
    	{
    		new Float:x, Float:y, Float:z;
    		GetPlayerPos(playerid, x, y, z);
    		for(new ptid; ptid < 10; ptid++)
    		{
    			if(IsPointInDynamicArea(PaytollAreaid[ptid], x, y, z))
    			{
    				OpenPaytoll(playerid);
    			}
    		}
    	}
    }
    if(PRESSED(KEY_WALK) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
       // if(IsPlayerInRangeOfPoint(playerid, 2.0, 906.96, 256.46, 1289.98))
        //{
        	//return callcmd::jobcenter(playerid, "");
        //}
        if(IsPlayerInRangeOfPoint(playerid, 2.0, 1376.4336,1573.7515,17.0003))
        {
        	ShowPlayerDialog(playerid, DIALOG_BALKOT, DIALOG_STYLE_LIST, "BALKOT CENTER", "Mengambil Id Card\nMenggubah Umur\nJual Rumah\nJual Bisnis\nJual Dealer\nPay Tax", "Select", "Close");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3.5, -382.97, -1426.43, 26.31))
        {
        	return callcmd::menufarmer(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2.5, 313.61, 1147.21, 8.58))
        {
        	return callcmd::menumilk(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3.0, 907.71, -1735.62, -55.57))
        {
        	return callcmd::buyveh(playerid, "");
        }
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_WASTED && pData[playerid][pJail] < 1)
    {	
		if(pData[playerid][pInjured] == 0)
        {
            pData[playerid][pInjured] = 1;
            SetPlayerHealthEx(playerid, 100);

            pData[playerid][pInt] = GetPlayerInterior(playerid);
            pData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);

            GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
            GetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
        }
        else
        {
            pData[playerid][pHospital] = 1;
        }
	}
	//Spec Player
	new vehicleid = GetPlayerVehicleID(playerid);
	if(newstate == PLAYER_STATE_ONFOOT)
	{
		if(pData[playerid][playerSpectated] != 0)
		{
			foreach(new ii : Player)
			{
				if(pData[ii][pSpec] == playerid)
				{
					PlayerSpectatePlayer(ii, playerid);
					Servers(ii, ,"%s(%i) is now on foot.", pData[playerid][pName], playerid);
				}
			}
		}
	}
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
    	pData[playerid][pClikmap] = vehicleid;
		if(pData[playerid][pInjured] == 1)
        {
            //RemoveFromVehicle(playerid);
			RemovePlayerFromVehicle(playerid);
            SetPlayerHealthEx(playerid, 100);
        }
		foreach (new ii : Player) if(pData[ii][pSpec] == playerid) 
		{
            PlayerSpectateVehicle(ii, GetPlayerVehicleID(playerid));
        }
	}
	if(oldstate == PLAYER_STATE_PASSENGER)
	{
		TextDrawHideForPlayer(playerid, TDEditor_TD[11]);
		TextDrawHideForPlayer(playerid, DPvehfare[playerid]);
	}
	if(oldstate == PLAYER_STATE_DRIVER)
    {	
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED)
            return RemovePlayerFromVehicle(playerid);/*RemoveFromVehicle(playerid);*/

		for(new txd; txd < 8; txd++)
		{
			TextDrawHideForPlayer(playerid, GenzoVeh[txd]);
		}

		for(new idx; idx < 10; idx++)
		{
			TextDrawHideForPlayer(playerid, SPEEDOGEN[idx]);
		}
		
		if(pData[playerid][pTaxiDuty] == 1)
		{
			pData[playerid][pTaxiDuty] = 0;
			SetPlayerColor(playerid, COLOR_WHITE);
			Servers(playerid, "You are no longer on taxi duty!");
		}
		if(pData[playerid][pFare] == 1)
		{
			KillTimer(pData[playerid][pFareTimer]);
			Info(playerid, "Anda telah menonaktifkan taxi fare pada total: {00FF00}%s", FormatMoney(pData[playerid][pTotalFare]));
			pData[playerid][pFare] = 0;
			pData[playerid][pTotalFare] = 0;
		}
        
		HidePlayerProgressBar(playerid, pData[playerid][spfuelbar]);
        HidePlayerProgressBar(playerid, pData[playerid][spdamagebar]);
		
        HidePlayerProgressBar(playerid, pData[playerid][fuelbar]);
        HidePlayerProgressBar(playerid, pData[playerid][damagebar]);

        vehicleid = GetNearestVehicleToPlayer(playerid, 4.0, false);

	    if (vehicleid == INVALID_VEHICLE_ID)
	    	return 1;

        switch (GetEngineStatus(GetNearestVehicleToPlayer(playerid)))
	    {
	        case false:
	        {
	            SwitchVehicleEngine(GetNearestVehicleToPlayer(playerid), false);
	        }
	        case true:
	        {
	            SwitchVehicleEngine(GetNearestVehicleToPlayer(playerid), false);
	            
	            SwitchVehicleLight(vehicleid, false);

	            SendNearbyMessage(playerid, 0.0, COLOR_WHITE, "ACTION: {D0AEEB}Mesin mati.");
	            InfoTD_MSG(playerid, 4000, "Engine ~r~OFF");
	        }
	    }
	}
	else if(newstate == PLAYER_STATE_DRIVER)
    {
		/*if(IsSRV(vehicleid))
		{
			new tstr[128], price = GetVehicleCost(GetVehicleModel(vehicleid));
			format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleName(vehicleid), FormatMoney(price));
			ShowPlayerDialog(playerid, DIALOG_BUYPV, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
		}
		else if(IsVSRV(vehicleid))
		{
			new tstr[128], price = GetVipVehicleCost(GetVehicleModel(vehicleid));
			if(pData[playerid][pVip] == 0)
			{
				Error(playerid, "Kendaraan Khusus VIP Player.");
				RemovePlayerFromVehicle(playerid);
				//SetVehicleToRespawn(GetPlayerVehicleID(playerid));
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
			else
			{
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d Coin", GetVehicleName(vehicleid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYVIPPV, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
		}*/
		
		foreach(new pv : PVehicles)
		{
			if(vehicleid == pvData[pv][cVeh])
			{
				if(IsABike(vehicleid) || GetVehicleModel(vehicleid) == 424)
				{
					if(pvData[pv][cLocked] == 1)
					{
						RemovePlayerFromVehicle(playerid);
						//new Float:slx, Float:sly, Float:slz;
						//GetPlayerPos(playerid, slx, sly, slz);
						//SetPlayerPos(playerid, slx, sly, slz);
						Error(playerid, "This bike is locked by owner.");
						return 1;
					}
				}
			}
		}
		
		if(IsASweeperVeh(vehicleid))
		{
			ShowPlayerDialog(playerid, DIALOG_SWEEPER, DIALOG_STYLE_MSGBOX, "Side Job - Sweeper", "Anda akan bekerja sebagai pembersih jalan?", "Start Job", "Close");
		}
		if(IsABusVeh(vehicleid))
		{
			ShowPlayerDialog(playerid, DIALOG_BUS, DIALOG_STYLE_LIST, "Side Job - Bus", "Route Market St\nRoute El Corona St", "Start Job", "Close");
		}
		if(IsAForVeh(vehicleid))
		{
			ShowPlayerDialog(playerid, DIALOG_FORKLIFT, DIALOG_STYLE_MSGBOX, "Side Job - Forklift", "Anda akan bekerja sebagai pemuat barang dengan Forklift?", "Start Job", "Close");
		}
		if(IsARumputVeh(vehicleid))
		{
			ShowPlayerDialog(playerid, DIALOG_LAWN_MOWER, DIALOG_STYLE_MSGBOX, "Side Job - Lawn Mower", "Anda akan bekerja sebagai Lawn Mower?", "Start Job", "Close");
		}
		if(IsATrashVeh(vehicleid))
		{
			if(pData[playerid][pSideJob] != 5)
			{
				ShowPlayerDialog(playerid, DIALOG_TRASHMASTER, DIALOG_STYLE_MSGBOX, "Side Job - Trash Master", "Anda akan bekerja sebagai Trash Master?", "Start Job", "Close");
			}
		}
		if(IsDRIVESIMCar(vehicleid))
        {
            SetPlayerCheckpoint(playerid, getsimpoint1, 3.0);
            Info(playerid, "Ikuti checkpoint yang sudah ditandai.");
        }
		
		if(!IsEngineVehicle(vehicleid))
        {
            SwitchVehicleEngine(vehicleid, true);
        }
        if(GetEngineStatus(vehicleid))
		{
			EngineStatuss(playerid, vehicleid);
		}
  		else
        {
            if(!GetEngineStatus(vehicleid))
            {
                //if(CoreVehicles[vehicleid][vehFuel] < 1.0) ShowPlayerFooter(playerid, "There is no ~r~fuel~w~ in this vehicle.", 3000, 1);
                //else if(ReturnVehicleHealth(vehicleid) <= 300) ShowPlayerFooter(playerid, "This vehicle is ~r~totalled~w~ and needs repairing.", 3000, 1);
                //else ShowPlayerFooter(playerid, "Type ~r~/v engine~w~ to start the engine.");
                vehicleid = GetPlayerVehicleID(playerid);

		        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		            return 1;

                SetTimerEx("EngineStatuss", 1500, false, "dd", playerid, GetPlayerVehicleID(playerid));
	            SendNearbyMessage(playerid, 0.0, COLOR_WHITE, "ACTION: {D0AEEB}Mencoba menyalakan mesin.");
			}
            if(pData[playerid][pDriveLic] <= 0)
			{
                Info(playerid, "Anda tidak memiliki surat izin mengemudi, berhati-hatilah.");
            	Info(playerid, "Untuk membuat SIM silahkan berkonsultasi dengan polisi.");
            }
        }

		/*if(IsEngineVehicle(vehicleid) && pData[playerid][pDriveLic] <= 0)
        {
            Info(playerid, "Anda tidak memiliki surat izin mengemudi, berhati-hatilah.");
            Info(playerid, "Untuk membuat SIM silahkan berkonsultasi dengan polisi.");
        }*/
		if(pData[playerid][pHBEMode] == 1)
		{
			for(new idx; idx < 8; idx++)
			{
				TextDrawShowForPlayer(playerid, GenzoVeh[idx]);
			}
		}
		if(pData[playerid][pHBEMode] == 2)
		{
			for(new idx; idx < 10; idx++)
			{
				TextDrawShowForPlayer(playerid, SPEEDOGEN[idx]);
			}
		}
		else
		{
		
		}
		new Float:health;
        GetVehicleHealth(GetPlayerVehicleID(playerid), health);
        VehicleHealthSecurityData[GetPlayerVehicleID(playerid)] = health;
        VehicleHealthSecurity[GetPlayerVehicleID(playerid)] = true;
		
		if(pData[playerid][playerSpectated] != 0)
  		{
			foreach(new ii : Player)
			{
    			if(pData[ii][pSpec] == playerid)
			    {
        			PlayerSpectateVehicle(ii, vehicleid);
				    Servers(ii, "%s(%i) is now driving a %s(%d).", pData[playerid][pName], playerid, GetVehicleModelName(GetVehicleModel(vehicleid)), vehicleid);
				}
			}
		}
		SetPVarInt(playerid, "LastVehicleID", vehicleid);
	}
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	switch(weaponid){ case 0..18, 39..54: return 1;} //invalid weapons
	if(1 <= weaponid <= 46 && pData[playerid][pGuns][g_aWeaponSlots[weaponid]] == weaponid)
	{
		pData[playerid][pAmmo][g_aWeaponSlots[weaponid]]--;
		if(hittype == 1 && pData[hitid][pGetDamageID] == INVALID_PLAYER_ID)
		{
			pData[hitid][pGetDamageID] = playerid;
		}
		if(pData[playerid][pGuns][g_aWeaponSlots[weaponid]] != 0 && !pData[playerid][pAmmo][g_aWeaponSlots[weaponid]])
		{
			pData[playerid][pGuns][g_aWeaponSlots[weaponid]] = 0;
		}
	}
	if ((22 <= weaponid <= 38) && (GetPlayerWeaponState(playerid) == WEAPONSTATE_LAST_BULLET && GetPlayerAmmo(playerid) == 1) || PlayerData[playerid][pDurability][g_aWeaponSlots[weaponid]] <= 0 && !IsPlayerAttachedObjectSlotUsed(playerid, 4))
 	{
  		switch (weaponid) 
  		{
 	        case 22: pData[playerid][pColt45]++;
 	        case 24: pData[playerid][pDesertEagle]++;
 	        case 25: pData[playerid][pShotgun]++;
 	        case 28: pData[playerid][pMicroSMG]++;
 	        case 29: pData[playerid][pMP5]++;
 	        case 30: pData[playerid][pAK47]++;
 	        case 32: pData[playerid][pTec9]++;
 	        case 33: pData[playerid][pRifle]++;
 	        case 34: pData[playerid][pSniper]++;
		}
 	    ResetWeapon(playerid, weaponid);

 	    HoldWeapon(playerid, weaponid);
 	    InfoMsg(playerid, "~r~Senjata anda kehabisan peluru!~w~, gunakan clip untuk menggunakan senjata kembali");
	}
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
    foreach(new ii : Player)
    {
        if(pData[ii][pFaction] == 1)
        {
          	new Float: X, Float: Y, Float: Z;
          	GetPlayerPos(playerid, X, Y, Z);
          	SetPlayerCheckpoint(ii,  X, Y, Z, 3.0);

          	for(new a = 0; a < 6; a++)
			{
				PlayerTextDrawShow(ii, notifshootgen[ii][a]);
			}
        	new pe [120]; //Telah Terjadi Penembakan Di Daerah
        	format(pe, sizeof(pe), "Telah terjadi penembakan - Lokasi : ~r~%s", GetLocation(X, Y, Z));
        	PlayerTextDrawSetString(ii, notifshootgen[playerid][5], pe);
        	SetTimerEx("spawntw", 8000, false, "i", ii);
        }
    }
    //new weaponname[24], Float:x, Float:y, Float:z;
    //GetWeaponName(weaponid, weaponname, sizeof (weaponname));
	//SendFactionMessage(1, COLOR_RADIO, "** [SAPD Radio] Terjadi penembakan di daerah %s, Menggunakan senjata %s ",  GetLocation(x, y, z), weaponname);
    return 1;
}

stock GivePlayerHealth(playerid,Float:Health)
{
	new Float:health; GetPlayerHealth(playerid,health);
	SetPlayerHealthEx(playerid,health+Health);
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	new Float: vehicleHealth, Float:health, playerVehicleId;
    playerVehicleId = GetPlayerVehicleID(playerid);
    GetPlayerHealth(playerid, health);
    GetVehicleHealth(playerVehicleId, vehicleHealth);
    new panels, doors, lights, tires;
    GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
    UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
    if(pData[playerid][pSeatBelt] == 0 || pData[playerid][pHelmetOn] == 0)
    {
    	if(GetVehicleSpeed(vehicleid) <= 20)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -1);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 50)
    	{
    		new asakit = RandomEx(0, 2);
    		new bsakit = RandomEx(0, 2);
    		new csakit = RandomEx(0, 2);
    		new dsakit = RandomEx(0, 2);
    		pData[playerid][pLFoot] -= dsakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= dsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -2);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 90)
    	{
    		new asakit = RandomEx(0, 3);
    		new bsakit = RandomEx(0, 3);
    		new csakit = RandomEx(0, 3);
    		new dsakit = RandomEx(0, 3);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= csakit;
    		pData[playerid][pRFoot] -= dsakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -5);
    		return 1;
    	}
    	return 1;
    }
    if(pData[playerid][pSeatBelt] == 1 || pData[playerid][pHelmetOn] == 1)
    {
    	if(GetVehicleSpeed(vehicleid) <= 20)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -1);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 50)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		new dsakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= dsakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= dsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -1);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 90)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		new dsakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= csakit;
    		pData[playerid][pRFoot] -= dsakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -3);
    		return 1;
    	}
    }
    return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(IsAtEvent[playerid] == 0)
	{
		new sakit = RandomEx(1, 4);
		new asakit = RandomEx(1, 5);
		new bsakit = RandomEx(1, 7);
		new csakit = RandomEx(1, 4);
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 9)
		{
			pData[playerid][pHead] -= 20;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 3)
		{
			pData[playerid][pPerut] -= sakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 6)
		{
			pData[playerid][pRHand] -= bsakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 5)
		{
			pData[playerid][pLHand] -= asakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 8)
		{
			pData[playerid][pRFoot] -= csakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 7)
		{
			pData[playerid][pLFoot] -= bsakit;
		}

		CreateDamageLog(playerid, Float:amount, weaponid, bodypart);
	}
    return 1;
}

function doorbengkel1(playerid)
{
	MoveDynamicObject(doorbengkel[0], 1786.853637, -2050.664550, 14.541879, 1.0);
	return 1;
}

function doorbengkel2(playerid)
{
	MoveDynamicObject(doorbengkel[1], 1808.145507, -2050.664550, 14.471884, 1.0);
	return 1;
}

public OnPlayerUpdate(playerid)
{
	afk_tick[playerid]++;
	//call
	foreach(new ii : Player)
	{
		if(playerid == pData[ii][pCall])
		{
			new string[256];
			format(string, sizeof(string), "%02d:%02d:%02d", JamCall[ii], MenitCall[ii], DetikCall[ii]);
			PlayerTextDrawSetString(ii, NamaDanJamTelp[ii][1], string);

			format(string, sizeof(string), "%02d:%02d:%02d", JamCall[playerid], MenitCall[playerid], DetikCall[playerid]);
			PlayerTextDrawSetString(playerid, NamaDanJamTelp[playerid][1], string);
		}
	}


	//tmpobjid = CreateDynamicObjectEx(11313, 1786.853637, -2050.664550, 10.591876, -0.000001, 0.000000, 90.000000, 300.00, 300.00); 
	//tmpobjid = CreateDynamicObjectEx(11313, 1808.145507, -2050.664550, 10.581879, -0.000003, 0.000000, 90.000000, 300.00, 300.00); 
	//Door Bengkel
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 1787.2460,-2053.2937,13.5804))
	{
		SetTimerEx("doorbengkel1", 5000, false, "i", playerid);
		MoveDynamicObject(doorbengkel[0], 1786.853637, -2050.664550, 10.591876, 1.0);
	}
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 1808.1914,-2048.2639,13.5820))
	{
		SetTimerEx("doorbengkel2", 5000, false, "i", playerid);
		MoveDynamicObject(doorbengkel[1], 1808.145507, -2050.664550, 10.581879, 1.0);
	}

	//SAPD Tazer/Taser
	UpdateTazer(playerid);
	
	//SAPD Road Spike
	CheckPlayerInSpike(playerid);
	//SPEEDLIMIT
	GetSpeedCam(playerid);
	//speedlimit speed limit
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && LimitSpeed[playerid])
	{
	    new a, b, c;
		GetPlayerKeys(playerid, a, b ,c);
	    if(a == 8 && GetVehicleSpeedLimit(GetPlayerVehicleID(playerid), 0) > LimitSpeed[playerid])
	    {
	        new newspeed = GetVehicleSpeedLimit(GetPlayerVehicleID(playerid), 0) - LimitSpeed[playerid];
	    	ModifyVehicleSpeed(GetPlayerVehicleID(playerid), -newspeed);
	    }
	}
	if(pData[playerid][pLevel] < 3)
	{
		if(GetPlayerWeapon(playerid) > 18 && GetPlayerWeapon(playerid) < 39)
		{
			ResetWeapon(playerid, 22);
			ResetWeapon(playerid, 23);
			ResetWeapon(playerid, 24);
			ResetWeapon(playerid, 25);
			ResetWeapon(playerid, 26);
			ResetWeapon(playerid, 27);
			ResetWeapon(playerid, 28);
			ResetWeapon(playerid, 30);
			ResetWeapon(playerid, 31);
			ResetWeapon(playerid, 32);
			ResetWeapon(playerid, 33);
			ResetWeapon(playerid, 34);
			ResetWeapon(playerid, 35);
			ResetWeapon(playerid, 36);
			ResetWeapon(playerid, 37);
			ResetWeapon(playerid, 38);
		}
		return 1;
	}
	/*if(pData[playerid][pCharStory] < 1)
	{
		if(GetPlayerWeapon(playerid) > 18 && GetPlayerWeapon(playerid) < 39)
		{
			ResetWeapon(playerid, 22);
			ResetWeapon(playerid, 23);
			ResetWeapon(playerid, 24);
			ResetWeapon(playerid, 25);
			ResetWeapon(playerid, 26);
			ResetWeapon(playerid, 27);
			ResetWeapon(playerid, 28);
			ResetWeapon(playerid, 30);
			ResetWeapon(playerid, 31);
			ResetWeapon(playerid, 32);
			ResetWeapon(playerid, 33);
			ResetWeapon(playerid, 34);
			ResetWeapon(playerid, 35);
			ResetWeapon(playerid, 36);
			ResetWeapon(playerid, 37);
			ResetWeapon(playerid, 38);
		}
	}*/
	return 1;
}

task VehicleUpdate[40000]()
{
	for (new i = 1; i != MAX_VEHICLES; i ++) if(IsEngineVehicle(i) && GetEngineStatus(i))
    {
        if(GetVehicleFuel(i) > 0)
        {
			new fuel = GetVehicleFuel(i);
            SetVehicleFuel(i, fuel - 1);

            if(GetVehicleFuel(i) >= 1 && GetVehicleFuel(i) <= 10)
            {
               Info(GetVehicleDriver(i), "Kendaraan ingin habis bensin, Harap pergi ke SPBU ( Gas Station )");
            }
        }
        if(GetVehicleFuel(i) <= 0)
        {
            SetVehicleFuel(i, 0);
            SwitchVehicleEngine(i, false);
        }
    }
	foreach(new ii : PVehicles)
	{
		if(IsValidVehicle(pvData[ii][cVeh]))
		{
			if(pvData[ii][cPlateTime] != 0 && pvData[ii][cPlateTime] <= gettime())
			{
				format(pvData[ii][cPlate], 32, "None");
				SetVehicleNumberPlate(pvData[ii][cVeh], pvData[ii][cPlate]);
				pvData[ii][cPlateTime] = 0;
			}
			if(pvData[ii][cRent] != 0 && pvData[ii][cRent] <= gettime())
			{
				pvData[ii][cRent] = 0;

				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[ii][cID]);
				mysql_tquery(g_SQL, query);

				MySQL_ResetVehicleToys(ii);
				if(IsValidVehicle(pvData[ii][cVeh])) 
					DestroyVehicle(pvData[ii][cVeh]);

				pvData[ii][cVeh] = 0;

				Iter_SafeRemove(PVehicles, ii, ii);
			}
		}
		if(pvData[ii][cClaimTime] != 0 && pvData[ii][cClaimTime] <= gettime())
		{
			pvData[ii][cClaimTime] = 0;
		}
	}
}

public OnVehicleSpawn(vehicleid)
{
	if(adminVehicle{vehicleid})
	{
		if(IsValidVehicle(vehicleid))
			DestroyVehicle(vehicleid);

		adminVehicle{vehicleid} = false;
	}
	if(IsATruckerVeh(vehicleid))
	{
		if(IsValidDynamicObject(TruckerVehObject[vehicleid]))
			DestroyDynamicObject(TruckerVehObject[vehicleid]);

		TruckerVehObject[vehicleid] = 0;
	}
	foreach(new fvid : FactionVeh)
	{
		if(Iter_Contains(FactionVeh, fvid))
		{
			if(vehicleid == fvData[fvid][fvVeh])
			{
                Delete3DTextLabel(fvData[fvid][fvLabel]);
               	fvData[fvid][fvLabel] = Text3D: -1;
               	
				if(IsValidVehicle(fvData[fvid][fvVeh]))
					DestroyVehicle(fvData[fvid][fvVeh]);
				
				fvData[fvid][fvVeh] = 0;
				fvData[fvid][fvFaction] = 0;

				Iter_Remove(FactionVeh, fvid);
			}
		}
	}
	foreach(new ii : PVehicles)
	{
		if(vehicleid == pvData[ii][cVeh])
		{
			/*if(pvData[ii][cClaim] != 0)
			{
				foreach(new pid : Player) if (pvData[ii][cOwner] == pData[pid][pID])
				{
					Info(pid, "Anda masih memiliki claim kendaraan, silahkan ambil di city hall!");
				}
				if(IsValidVehicle(pvData[ii][cVeh]))
					DestroyVehicle(pvData[ii][cVeh]);
					
				return 1;
			}*/
			if(pvData[ii][cInsu] > 0)
    		{
				pvData[ii][cInsu]--;
				pvData[ii][cClaim] = 1;
				pvData[ii][cClaimTime] = gettime() + (1 * 7200);
				foreach(new pid : Player) 
				{
					if(pvData[ii][cOwner] == pData[pid][pID])
	        		{
	            		Info(pid, "Kendaraan anda hancur dan anda masih memiliki insuransi, silahkan ambil di kantor asuransi setelah 2 jam.");
					}
					RemoveVehicleToys(pvData[ii][cVeh]);
					if(IsValidVehicle(pvData[ii][cVeh]))
						DestroyVehicle(pvData[ii][cVeh]);
					
					pvData[ii][cVeh] = 0;
				}
			}
			else
			{
				foreach(new pid : Player)
				{
					if(pvData[ii][cOwner] == pData[pid][pID])
	        		{
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[pid][cID]);
						mysql_tquery(g_SQL, query);
						
						MySQL_ResetVehicleToys(ii);
						if(IsValidVehicle(pvData[ii][cVeh]))
							DestroyVehicle(pvData[ii][cVeh]);

						pvData[ii][cVeh] = 0;
						
	            		Info(pid, "Kendaraan anda hancur dan tidak memiliki insuransi.");
						Iter_SafeRemove(PVehicles, ii, ii);
					}
				}
			}
		}
	}
	return 1;
}

ptask PlayerVehicleUpdate[200](playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsValidVehicle(vehicleid))
	{
		if(!GetEngineStatus(vehicleid) && IsEngineVehicle(vehicleid))
		{	
			SwitchVehicleEngine(vehicleid, false);
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new Float:fHealth;
			GetVehicleHealth(vehicleid, fHealth);
			if(IsValidVehicle(vehicleid) && fHealth <= 350.0)
			{
				SetValidVehicleHealth(vehicleid, 300.0);
				SwitchVehicleEngine(vehicleid, false);
				GameTextForPlayer(playerid, "~r~Totalled!", 2500, 3);
			}
		}
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if(pData[playerid][pHBEMode] == 1)
			{
			    new _string[500];
			    new fFuel;
		    	//static Float:valor;
		    	fFuel = GetVehicleFuel(vehicleid);

				if(fFuel < 0) fFuel = 0;
				else if(fFuel > 3000) fFuel = 3000;
	  			new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);

				format(_string, sizeof(_string), "%.0f", GetVehicleSpeed(vehicleid));
	 			TextDrawSetString(GenzoVeh[4], _string);
	  			format(_string, sizeof(_string), "%d", GetVehicleFuel(vehicleid));
	   			TextDrawSetString(GenzoVeh[5], _string);
	    		format(_string, sizeof(_string), "%s", GetLocation(x, y, z));
	    		TextDrawSetString(GenzoVeh[2], _string);
	    		TextDrawShowForPlayer(playerid, GenzoVeh[2]);
	 			TextDrawShowForPlayer(playerid, GenzoVeh[4]);
		   		TextDrawShowForPlayer(playerid, GenzoVeh[5]);

		   		new Float:rz;
				if(IsPlayerInAnyVehicle(playerid))
				{
					GetVehicleZAngle(GetPlayerVehicleID(playerid), rz);
				}
				else
				{
					GetPlayerFacingAngle(playerid, rz);
				}

				if(rz >= 348.75 || rz < 11.25) TextDrawSetString(GenzoVeh[0], "Utara");
				else if(rz >= 258.75 && rz < 281.25) TextDrawSetString(GenzoVeh[0], "Timur");
			    else if(rz >= 210.0 && rz < 249.0) TextDrawSetString(GenzoVeh[0], "Tenggara");
				else if(rz >= 168.75 && rz < 191.25) TextDrawSetString(GenzoVeh[0], "Selatan");
			    else if(rz >= 110.0 && rz < 159.0)  TextDrawSetString(GenzoVeh[0], "Barat");
				else if(rz >= 78.75 && rz < 101.25) TextDrawSetString(GenzoVeh[0], "Barat");
			    else if(rz >= 20 && rz < 69.0) TextDrawSetString(GenzoVeh[0], "Selatan");
			    else if(rz >= 291.0 && rz < 339) TextDrawSetString(GenzoVeh[0], "Timur");
			    TextDrawShowForPlayer(playerid, GenzoVeh[0]);
			}
			else if(pData[playerid][pHBEMode] == 2)
			{
			    new _string[500];
			    new fFuel;
		    	//static Float:valor;
		    	fFuel = GetVehicleFuel(vehicleid);

				if(fFuel < 0) fFuel = 0;
				else if(fFuel > 3000) fFuel = 3000;
	  			new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);

				format(_string, sizeof(_string), "%.0f", GetVehicleSpeed(vehicleid));
	 			TextDrawSetString(SPEEDOGEN[6], _string);
	  			format(_string, sizeof(_string), "%d", GetVehicleFuel(vehicleid));
	   			TextDrawSetString(SPEEDOGEN[9], _string);
		   		TextDrawShowForPlayer(playerid, SPEEDOGEN[6]);
		   		TextDrawShowForPlayer(playerid, SPEEDOGEN[9]);
			}
			else
			{
			
			}
		}
	}
	return 1;
}

stock GetKecepatanPlayer(playerid)
{
    new Float: x, Float: y, Float: z;
    if(IsPlayerInAnyVehicle(playerid))
    {
        new kendaraansetan = GetPlayerVehicleID(playerid);
        GetVehicleVelocity(kendaraansetan, x, y, z);
    }
    else GetPlayerVelocity(playerid, x, y, z);

    return floatround(floatsqroot(x*x+y*y+z*z)*100);
}

stock GetVehicleSpeedLimit(vehicleid, get3d)//speedlimit speed limit
{
	new Float:x, Float:y, Float:z;
	GetVehicleVelocity(vehicleid, x, y, z);
	return SpeedCheck(x, y, z, 100.0, get3d);
}

stock ModifyVehicleSpeed(vehicleid,mph) //Miles Per Hour
{
	new Float:Vx,Float:Vy,Float:Vz,Float:Speed,Float:multiple;
	GetVehicleVelocity(vehicleid,Vx,Vy,Vz);
	Speed = floatsqroot(Vx*Vx + Vy*Vy + Vz*Vz);
	if(Speed > 0)
	{
		multiple = ((mph + Speed * 100) / (Speed * 100));
		return SetVehicleVelocity(vehicleid,Vx*multiple,Vy*multiple,Vz*multiple);
	}
	return 0;
}

ptask PlayerUpdate[999](playerid)
{
	AFKCheck(playerid);
	//Anti-Cheat Vehicle health hack
	for(new v, j = GetVehiclePoolSize(); v <= j; v++) if(GetVehicleModel(v))
    {
        new Float:health;
        GetVehicleHealth(v, health);
        if( (health > VehicleHealthSecurityData[v]) && VehicleHealthSecurity[v] == false)
        {
			if(GetPlayerVehicleID(playerid) == v)
			{
				new playerState = GetPlayerState(playerid);
				if(playerState == PLAYER_STATE_DRIVER)
				{
					SetValidVehicleHealth(v, VehicleHealthSecurityData[v]);
					SendClientMessageToAllEx(COLOR_RED, "BOT SERVER: %s have been auto kicked for vehicle health hack!", pData[playerid][pName]);
					KickEx(playerid);
				}
			}
        }
        if(VehicleHealthSecurity[v] == true)
        {
            VehicleHealthSecurity[v] = false;
        }
        VehicleHealthSecurityData[v] = health;
    }
	/*//Anti-Money Hack
	if(GetPlayerMoney(playerid) > pData[playerid][pMoney])
	{
		SendAdminMessage(COLOR_RED, "Possible visual money hacks detected on %s(%i). Check on this player. "LG_E"($%d).", pData[playerid][pName], playerid, GetPlayerMoney(playerid));
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, pData[playerid][pMoney]);
	}*/
    //Speed Hack unyu unyu
    new jembutveh = GetPlayerVehicleID(playerid);
    if(GetVehicleSpeed(jembutveh) > 220 || GetKecepatanPlayer(playerid) > 220)
    {
        SendClientMessageToAllEx(COLOR_RED, "BOT SERVER: %s(%d) has been auto kicked for speed hacks!", pData[playerid][pName], playerid);
        KickEx(playerid);
    }
	//Anti Armour Hacks
	/*new Float:A;
	GetPlayerArmour(playerid, A);
	if(A > 98)
	{
		SetPlayerArmourEx(playerid, 0);
		SendClientMessageToAllEx(COLOR_RED, "BOT SERVER: %s(%d) has been auto kicked for armour hacks!", pData[playerid][pName], playerid);
		KickEx(playerid);
	}*/
	//Weapon AC
	if(pData[playerid][pAdmin] < 2)
	{
		if(pData[playerid][pSpawned] == 1)
		{
			if(GetPlayerWeapon(playerid) != pData[playerid][pWeapon])
			{
				pData[playerid][pWeapon] = GetPlayerWeapon(playerid);

				if(pData[playerid][pWeapon] >= 1 && pData[playerid][pWeapon] <= 45 && pData[playerid][pWeapon] != 40 && pData[playerid][pWeapon] != 2 && pData[playerid][pGuns][g_aWeaponSlots[pData[playerid][pWeapon]]] != GetPlayerWeapon(playerid))
				{
					pData[playerid][pACWarns]++;

					if(pData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
					{
						new dc[128];
						SendAnticheat(COLOR_RED, "%s(%d) has possibly used weapon hacks (%s), Please to check /spec this player first!", pData[playerid][pName], playerid, ReturnWeaponName(pData[playerid][pWeapon]));
						SetWeapons(playerid); 
						format(dc, sizeof(dc),  "```\n<!> %s kemungkinan Weapon hacks (%s) ```", ReturnName(playerid), ReturnWeaponName(pData[playerid][pWeapon]));
						SendDiscordMessage(3, dc);					
					}
					else
					{
						new dc[128], PlayerIP[16];
						SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dibanned otomatis oleh %s, Alasan: Weapon hacks", pData[playerid][pName], SERVER_BOT);
						format(dc, sizeof(dc),  "```\n<!> %s telah diban oleh %s\nAlasan: Weapon Hack```", ReturnName(playerid), SERVER_BOT);
						SendDiscordMessage(3, dc);

						GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
						new query[300], tmp[40], ban_time = 0;
						format(tmp, sizeof (tmp), "Weapon Hack (%s)", ReturnWeaponName(pData[playerid][pWeapon]));
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', '%s', '%s', %i, %d)", pData[playerid][pUCP], PlayerIP, SERVER_BOT, tmp, gettime(), ban_time);
						mysql_tquery(g_SQL, query);
						KickEx(playerid);
					}
				}
			}
		}
	}
	/*if(pData[playerid][pSpawned] == 1)
    {
        if(GetPlayerWeapon(playerid) != pData[playerid][pWeapon])
        {
            pData[playerid][pWeapon] = GetPlayerWeapon(playerid);

            if(pData[playerid][pWeapon] >= 1 && pData[playerid][pWeapon] <= 45 && pData[playerid][pWeapon] != 40 && pData[playerid][pWeapon] != 22 && pData[playerid][pWeapon] != 2 && pData[playerid][pGuns][g_aWeaponSlots[pData[playerid][pWeapon]]] != GetPlayerWeapon(playerid))
            {
            	pData[playerid][pWeaponAC]++;
                SendAdminMessage(COLOR_RED, "%s(%d) has possibly used weapon hacks (%s), Please to check /spec this player first!", pData[playerid][pName], playerid, ReturnWeaponName(pData[playerid][pWeapon]));
                SetWeapons(playerid); //Reload old weapons

                if(pData[playerid][pWeaponAC] >= 5)
                {
                	pData[playerid][pWeaponAC] = 0;
                	SendClientMessageToAllEx(COLOR_RED, "BOT SERVER: %s(%d) has been auto kicked for weapon hacks %s!", pData[playerid][pName], playerid, ReturnWeaponName(pData[playerid][pWeapon]));
					
					SetWeapons(playerid);
					KickEx(playerid);
                }
            }
        }
    }*/
	//Weapon Atth
	if(NetStats_GetConnectedTime(playerid) - WeaponTick[playerid] >= 250)
	{
		static weaponid, ammo, objectslot, count, index;
 
		for (new i = 2; i <= 7; i++) //Loop only through the slots that may contain the wearable weapons
		{
			GetPlayerWeaponData(playerid, i, weaponid, ammo);
			index = weaponid - 22;
		   
			if (weaponid && ammo && !WeaponSettings[playerid][index][Hidden] && IsWeaponWearable(weaponid) && EditingWeapon[playerid] != weaponid)
			{
				objectslot = GetWeaponObjectSlot(weaponid);
 
				if (GetPlayerWeapon(playerid) != weaponid)
					SetPlayerAttachedObject(playerid, objectslot, GetWeaponModel(weaponid), WeaponSettings[playerid][index][Bone], WeaponSettings[playerid][index][Position][0], WeaponSettings[playerid][index][Position][1], WeaponSettings[playerid][index][Position][2], WeaponSettings[playerid][index][Position][3], WeaponSettings[playerid][index][Position][4], WeaponSettings[playerid][index][Position][5], 1.0, 1.0, 1.0);
 
				else if (IsPlayerAttachedObjectSlotUsed(playerid, objectslot)) RemovePlayerAttachedObject(playerid, objectslot);
			}
		}
		for (new i = 4; i <= 8; i++) if (IsPlayerAttachedObjectSlotUsed(playerid, i))
		{
			count = 0;
 
			for (new j = 22; j <= 38; j++) if (PlayerHasWeapon(playerid, j) && GetWeaponObjectSlot(j) == i)
				count++;
 
			if(!count) RemovePlayerAttachedObject(playerid, i);
		}
		WeaponTick[playerid] = NetStats_GetConnectedTime(playerid);
	}
	
	//Player Update Online Data
	//GetPlayerHealth(playerid, pData[playerid][pHealth]);
    //GetPlayerArmour(playerid, pData[playerid][pArmour]);
	if(pData[playerid][pSpawned] == 1 && pData[playerid][IsLoggedIn] == true)
    {
	    if(pData[playerid][pInjured] == 0 || pData[playerid][pHospital] == 0 || pData[playerid][pJail] == 0)
		{
			if(pData[playerid][pHunger] <= 5 || pData[playerid][pEnergy] <= 5)
			{
				if(pData[playerid][pNerfHP] != 1)
				{
					pData[playerid][pNerfHP] = 1;
					SetTimerEx("NerfHpEnegyHunger", 300000, 0, "i", playerid);
				}
			}
		}
	}
	if(pData[playerid][AmbilAyam] == 10)
    {
        pData[playerid][AmbilAyam] = 0;
        destroyayam(playerid);
        pData[playerid][DutyAmbilAyam] = 0;
        SetPlayerPos(playerid, -1415.173583,-958.280090,201.093750);
		SetPlayerFacingAngle(playerid, 175.453338);
		SuccesMsg(playerid, "Anda telah menyelesaikan pekerjaan anda");
    }
    // AFK
	new StringF[50];
	if(afk_tick[playerid] > 10000) afk_tick[playerid] = 1, afk_check[playerid] = 0;
	if(afk_check[playerid] < afk_tick[playerid] && GetPlayerState(playerid)) afk_check[playerid] = afk_tick[playerid], afk_time[playerid] = 0;
	if(afk_check[playerid] == afk_tick[playerid] && GetPlayerState(playerid))
	{
		afk_time[playerid]++;
		if(afk_time[playerid] > 2)
		{
			format(StringF,sizeof(StringF), "[Sedang Melamun]");
			SetPlayerChatBubble(playerid, StringF, COLOR_RED, 15.0, 1200);
		}
    }
	if(pData[playerid][TempatHealing])
    {
        stresstimer[playerid] = SetTimerEx("StressBerkurang", 20000, true, "d", playerid);
    }
    if(pData[playerid][pBladder] <= 15)
    {
        pData[playerid][TempatHealing] = false;
        KillTimer(stresstimer[playerid]);
    }
	if(pData[playerid][pJail] <= 0)
	{
		if(pData[playerid][pHunger] > 100)
		{
			pData[playerid][pHunger] = 100;
		}
		if(pData[playerid][pHunger] < 0)
		{
			pData[playerid][pHunger] = 0;
		}
		if(pData[playerid][pBladder] > 100)
		{
			pData[playerid][pBladder] = 100;
		}
		if(pData[playerid][pBladder] < 0)
		{
			pData[playerid][pBladder] = 0;
		}
		if(pData[playerid][pEnergy] > 100)
		{
			pData[playerid][pEnergy] = 100;
		}
		if(pData[playerid][pEnergy] < 0)
		{
			pData[playerid][pEnergy] = 0;
		}
	}
	
	if(pData[playerid][pHBEMode] == 1 && pData[playerid][IsLoggedIn] == true)
	{
		new Float: HealthPlayer[MAX_PLAYERS], Float:ArmorPlayer[MAX_PLAYERS];
	    new Float: Lapar, Float: Haus, Float: Stresss, Float: HealthBar, Float: ArmourBar;
		new Float: healths, Float: armours;

		GetPlayerHealth(playerid, healths);
		GetPlayerArmour(playerid, armours);

		HealthPlayer[playerid] = healths;
		ArmorPlayer[playerid] = armours;
		
		HealthBar = HealthPlayer[playerid] * 36.0/100;
		TextDrawTextSize(GenzoHBE[5], HealthBar, 16.0);
		TextDrawShowForPlayer(playerid, GenzoHBE[5]);

		ArmourBar = ArmorPlayer[playerid] * 36.0/100;
		TextDrawTextSize(GenzoHBE[10], ArmourBar, 16.0);
		TextDrawShowForPlayer(playerid, GenzoHBE[10]);

		Lapar = pData[playerid][pHunger] * -16.0/100;
		TextDrawTextSize(GenzoHBE[6], 14.0, Lapar);
		TextDrawShowForPlayer(playerid, GenzoHBE[6]);

		Haus = pData[playerid][pEnergy] * -16.0/100;
		TextDrawTextSize(GenzoHBE[7], 14.0, Haus);
		TextDrawShowForPlayer(playerid, GenzoHBE[7]);

		Stresss = pData[playerid][pBladder] * -16.0/100;
		TextDrawTextSize(GenzoHBE[8], 14.0, Stresss);
		TextDrawShowForPlayer(playerid, GenzoHBE[8]);
	}
	if(pData[playerid][pHBEMode] == 2 && pData[playerid][IsLoggedIn] == true)
	{
		new Float: HealthPlayer[MAX_PLAYERS], Float:ArmorPlayer[MAX_PLAYERS];
	    new Float: Lapar, Float: Haus, Float: HealthBar, Float: ArmourBar;
		new Float: healths, Float: armours;

		GetPlayerHealth(playerid, healths);
		GetPlayerArmour(playerid, armours);

		HealthPlayer[playerid] = healths;
		ArmorPlayer[playerid] = armours;
		
		//HBEAJIX[4] darah
		//HBEAJIX[1] armor
		//HBEAJIX[7] haus
		//HBEAJIX[10] lapar

		HealthBar = HealthPlayer[playerid] * -15.0/100;
		TextDrawTextSize(HBEAJIX[4], 12.5, HealthBar);
		TextDrawShowForPlayer(playerid, HBEAJIX[4]);

		ArmourBar = ArmorPlayer[playerid] * -15.0/100;
		TextDrawTextSize(HBEAJIX[1], 14.0, ArmourBar);
		TextDrawShowForPlayer(playerid, HBEAJIX[1]);

		Lapar = pData[playerid][pHunger] * -16.0/100;
		TextDrawTextSize(HBEAJIX[10], 12.5, Lapar);
		TextDrawShowForPlayer(playerid, HBEAJIX[10]);

		Haus = pData[playerid][pEnergy] * -15.0/100;
		TextDrawTextSize(HBEAJIX[7], 14.0, Haus);
		TextDrawShowForPlayer(playerid, HBEAJIX[7]);

		//Stresss = pData[playerid][pBladder] * -11.0/100;
		//TextDrawTextSize(HBEAJIX[1], 10.0, Stresss);
		//TextDrawShowForPlayer(playerid, HBEAJIX[1]);
	}
	else
	{
	
	}
	
	if(pData[playerid][pHospital] == 1)
    {
		SetPlayerPosition(playerid, 2840.9377,1198.4575,-64.3797,288.0606, 4);
		
		SetPlayerInterior(playerid, 4);
		SetPlayerVirtualWorld(playerid, playerid + 100);

		TogglePlayerControllable(playerid, 0);
		pData[playerid][pInjured] = 0;
		pData[playerid][pHospitalTime]++;
		new mstr[64];
		format(mstr, sizeof(mstr), "~n~~n~~n~~w~Recovering... %d", 15 - pData[playerid][pHospitalTime]);
		InfoTD_MSG(playerid, 1000, mstr);

		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
        if(pData[playerid][pHospitalTime] >= 15)
        {
            pData[playerid][pHospitalTime] = 0;
            pData[playerid][pHospital] = 0;
			pData[playerid][pHunger] = 50;
			pData[playerid][pEnergy] = 50;
			pData[playerid][pBladder] = 0;
			SetPlayerHealthEx(playerid, 50);
			pData[playerid][pSick] = 0;
			GivePlayerMoneyEx(playerid, -50);
			SetPlayerHealthEx(playerid, 70);

            for (new i; i < 20; i++)
            {
                SendClientMessage(playerid, -1, "");
            }

			SendClientMessage(playerid, COLOR_GREY, "--------------------------------------------------------------------------------------------------------");
            SendClientMessage(playerid, COLOR_WHITE, "Kamu telah keluar dari rumah sakit, kamu membayar $50 kerumah sakit.");
            SendClientMessage(playerid, COLOR_GREY, "--------------------------------------------------------------------------------------------------------");
			
			SetPlayerPosition(playerid, 2840.9377,1198.4575,-64.3797,288.0606, 4);

            TogglePlayerControllable(playerid, 1);
            SetCameraBehindPlayer(playerid);

            SetPlayerVirtualWorld(playerid, 0);
            SetPlayerInterior(playerid, 4);
			ClearAnimations(playerid);
			pData[playerid][pSpawned] = 1;
			SetPVarInt(playerid, "GiveUptime", -1);
		}
    }
	if(pData[playerid][pInjured] == 1 && pData[playerid][pHospital] != 1)
    {
		new mstr[64];
        format(mstr, sizeof(mstr), "/death for spawn to hospital");
		InfoTD_MSG(playerid, 1000, mstr);
		
		if(GetPVarInt(playerid, "GiveUptime") == -1)
		{
			SetPVarInt(playerid, "GiveUptime", gettime());
		}
		
		if(GetPVarInt(playerid,"GiveUptime"))
        {
            if((gettime()-GetPVarInt(playerid, "GiveUptime")) > 100)
            {
                Info(playerid, "Now you can spawn, type '/death' for spawn to hospital.");
                SetPVarInt(playerid, "GiveUptime", 0);
            }
        }
		
        ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, 1, 0, 0, 0, 0, 1);
        SetPlayerHealthEx(playerid, 100);
    }
	if(pData[playerid][pInjured] == 0 && pData[playerid][pGender] != 0) //Pengurangan Data
	{
		if(++ pData[playerid][pHungerTime] >= 150)
        {
            if(pData[playerid][pHunger] > 0)
            {
                pData[playerid][pHunger]--;
            }
            else if(pData[playerid][pHunger] <= 0)
            {
                //SetPlayerHealth(playerid, health - 10);
          		//SetPlayerDrunkLevel(playerid, 8000);
          		pData[playerid][pSick] = 1;
            }
            pData[playerid][pHungerTime] = 0;
        }
        if(++ pData[playerid][pEnergyTime] >= 120)
        {
            if(pData[playerid][pEnergy] > 0)
            {
                pData[playerid][pEnergy]--;
            }
            else if(pData[playerid][pEnergy] <= 0)
            {
                //SetPlayerHealth(playerid, health - 10);
          		//SetPlayerDrunkLevel(playerid, 8000);
          		pData[playerid][pSick] = 1;
            }
            pData[playerid][pEnergyTime] = 0;
        }
        if(pData[playerid][pHunger] <= 1)
        {
			{
				if(pData[playerid][pInjured] == 0)
      			{
	            	pData[playerid][pInjured] = 1;
	          		SetPlayerHealthEx(playerid, 99999);
					Info(playerid, "Sepertinya anda mengalami Kelaparan berat.");
       			}
			}      		
        }
        if(pData[playerid][pEnergy] <= 1)
        {
			{
				if(pData[playerid][pInjured] == 0)
      			{
            		pData[playerid][pInjured] = 1;
          			SetPlayerHealthEx(playerid, 99999);
					Info(playerid, "Sepertinya anda dehidrasi.");
       			}
			}      		
        }
        if(++ pData[playerid][pBladderTime] >= 100)
        {
            if(pData[playerid][pBladder] < 97)
            {
                pData[playerid][pBladder]++;
            }
            else if(pData[playerid][pBladder] >= 80)
            {
          		Info(playerid, "Sepertinya anda stress, segeralah pergi ke Tempat Healing atau konsumsi pil untuk menghilangkan stress.");
          		SetPlayerDrunkLevel(playerid, 2200);
            }
            pData[playerid][pBladderTime] = 0;
        }
		if(pData[playerid][pSick] == 1)
		{
			if(++ pData[playerid][pSickTime] >= 200)
			{
				if(pData[playerid][pSick] >= 1)
				{
					new Float:hp;
					GetPlayerHealth(playerid, hp);
					SetPlayerHealthEx(playerid, hp - 3);
					SetPlayerDrunkLevel(playerid, 8000);
					ApplyAnimation(playerid,"CRACK","crckdeth2",4.1,0,1,1,1,1,1);
					Info(playerid, "Sepertinya anda sakit, segeralah pergi ke dokter/gunakan medicine agar darahmu tidak berkurang.");
					pData[playerid][pSickTime] = 0;
				}
			}
		}
	}
	
	//Jail Player
	if(pData[playerid][pJail] > 0)
	{
		if(pData[playerid][pJailTime] > 0)
		{
			pData[playerid][pJailTime]--;
			new mstr[128];
			format(mstr, sizeof(mstr), "~b~~h~You will be unjail in ~w~%d ~b~~h~seconds.", pData[playerid][pJailTime]);
			InfoTD_MSG(playerid, 1000, mstr);
		}
		else
		{
			pData[playerid][pJail] = 0;
			pData[playerid][pJailTime] = 0;
			//SpawnPlayer(playerid);
			SetPlayerPositionEx(playerid, 1543.26, -1669.16, 13.55, 89.69, 2000);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			SendClientMessageToAllEx(COLOR_RED, "Server: "GREY2_E" %s(%d) have been un-jailed by the server. (times up)", pData[playerid][pName], playerid);
		}
	}
	//Rehab Player
	if(pData[playerid][pRehab] > 0)
	{
		if(pData[playerid][pRehabTime] > 0)
		{
			pData[playerid][pRehabTime]--;
			new mstr[128];
			format(mstr, sizeof(mstr), "~b~~h~You will be released from rehabitation in ~w~%d ~b~~h~seconds.", pData[playerid][pRehabTime]);
			InfoTD_MSG(playerid, 1000, mstr);
		}
		else
		{
			pData[playerid][pUseDrug] = 0;
			pData[playerid][pRehab] = 0;
			pData[playerid][pRehabTime] = 0;
			//SpawnPlayer(playerid);
			SetPlayerPositionEx(playerid, 1179.0981,-1324.1577,14.1527,276.3118, 2000);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			Info(playerid, "You have been released from the rehabilitation period");
		}
	}
	//Arreset Player
	if(pData[playerid][pArrest] > 0)
	{
		if(pData[playerid][pArrestTime] > 0)
		{
			pData[playerid][pArrestTime]--;
			new mstr[128];
			format(mstr, sizeof(mstr), "~b~~h~Kamu akan dikeluarkan dalam  ~w~%d ~b~~h~seconds.", pData[playerid][pArrestTime]);
			InfoTD_MSG(playerid, 1000, mstr);
		}
		else
		{
			pData[playerid][pArrest] = 0;
			pData[playerid][pArrestTime] = 0;
			//SpawnPlayer(playerid);
			SetPlayerPositionEx(playerid, 1543.26, -1669.16, 13.55, 89.69, 2000);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			Info(playerid, "Kamu telah dikeluarkan dari penjara! (times up)");
		}
	}
	//JOB BUS
	if(pData[playerid][pBusRoute] && IsABusVeh(GetPlayerVehicleID(playerid)) && pData[playerid][pBuswaiting])
	{
		if(pData[playerid][pBustime] > 0)
		{
			pData[playerid][pBustime]--;
			ShowNotifInfo(playerid, sprintf("Mohon Tunggu Selama %d Detik Untuk Melakukan Perjalanan", pData[playerid][pBustime]), 10000);
			PlayerPlaySound(playerid, 43000, 0.0, 0.0, 0.0);		
		}
		else
		{
			if(IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket9))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, buspointmarket10, 7.0);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket16))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, buspointmarket17, 7.0);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket24))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, buspointmarket25, 7.0);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket29))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, buspointmarket30, 7.0);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 7.0,buspointmarket34))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, buspointmarket35, 7.0);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor7))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, buspointelcor8, 7.0);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor10))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, buspointelcor11, 7.0);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor15))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, buspointelcor16, 7.0);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 7.0,buspointelcor21))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, buspointelcor22, 7.0);
			}
		}
	}
	return 1;
}

stock SendDiscordMessage(channel, message[])
{
	new DCC_Channel:ChannelId;
	switch(channel)
	{
		//==[ Log Join & Leave ]
		case 0:
		{
			ChannelId = DCC_FindChannelById("1165268071150268437");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Log Command ]
		case 1:
		{
			ChannelId = DCC_FindChannelById("1165268068788883546");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Log Chat IC ]
		case 2:
		{
			ChannelId = DCC_FindChannelById("1162751602512375900");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Warning & Banned ]
		case 3:
		{
			ChannelId = DCC_FindChannelById("1166769468278587532");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Twitter ]
		case 4:
		{
			ChannelId = DCC_FindChannelById("1165268073092219003");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Ucp ]
		case 5:
		{
			ChannelId = DCC_FindChannelById("1165268100195811338");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 6://Korup
		{
			ChannelId = DCC_FindChannelById("1166769468278587532");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 7://Register
		{
			ChannelId = DCC_FindChannelById("1165268100195811338");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 8://Bot Admin
		{
			ChannelId = DCC_FindChannelById("1165268074803507281");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Log Death ]
		case 9:
		{
			ChannelId = DCC_FindChannelById("1168592144445997196");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Log CMD Admin ]
		case 10:
		{
			ChannelId = DCC_FindChannelById("1165268074803507281");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ LOG STATUS SERVER ]==
		case 11:
		{
			ChannelId = DCC_FindChannelById("1165268029744087061");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
	}
	return 1;
}

forward TambahDetikCall(playerid);
public TambahDetikCall(playerid)
{
	DetikCall[playerid] ++;

	if(DetikCall[playerid] == 60)
	{
		DetikCall[playerid] = 0;
		TambahMenitCall(playerid);
	}
}

forward TambahMenitCall(playerid);
public TambahMenitCall(playerid)
{
	MenitCall[playerid] ++;

	if(MenitCall[playerid] == 60)
	{
		MenitCall[playerid] = 0;
		TambahJamCall(playerid);
	}
}

forward TambahJamCall(playerid);
public TambahJamCall(playerid)
{
	JamCall[playerid] ++;

	if(JamCall[playerid] == 24)
	{
		JamCall[playerid] = 0;
	}
}

function OnPlayerBorgol(playerid, userid)
{
	if(pData[playerid][pLevel] < 5) return ErrorMsg(playerid, "Kamu belum cukup ~g~umur");

    if(pData[userid][pCuffed])
			return ErrorMsg(playerid, "Pemain tersebut sudah diikat saat ini.");

	pData[userid][pCuffed] = 1;
	SetPlayerSpecialAction(userid, SPECIAL_ACTION_CUFFED);
	TogglePlayerControllable(userid, 0);

	new mstr[128];
	format(mstr, sizeof(mstr), "kamu sudah ~r~diikat~w~ oleh %s.", ReturnName(playerid));
	InfoMsg(userid, mstr);
	return 1;
}

function OnPlayerUnBorgol(playerid, userid)
{
	if(pData[playerid][pLevel] < 5) return ErrorMsg(playerid, "Kamu belum cukup ~g~umur");

	pData[userid][pCuffed] = 0;
	SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);
	TogglePlayerControllable(userid, 1);

	new mstr[128];
	format(mstr, sizeof(mstr), "ikatan kamu ~r~dilepas~w~ oleh %s.", ReturnName(playerid));
	InfoMsg(userid, mstr);
	return 1;
}

function OnPlayerGeledah(playerid, userid)
{
	if(pData[playerid][pLevel] < 5) return ErrorMsg(playerid, "Kamu belum cukup ~g~umur");

    new str[256], string[256], totalall, quantitybar;
	format(str,1000,"%s", GetName(userid));
	PlayerTextDrawSetString(playerid, INVNAME[userid][2], str);
	BarangMasuk(userid);
	BukaInven[playerid] = 1;
	PlayerPlaySound(playerid, 1039, 0,0,0);
	SelectTextDraw(playerid, COLOR_LBLUE);
	for(new a = 0; a < 6; a++)
	{
		PlayerTextDrawShow(playerid, INVNAME[userid][a]);
	}
	PlayerTextDrawShow(playerid, INVINFO[userid][0]);
	PlayerTextDrawHide(playerid, INVINFO[userid][1]);
	PlayerTextDrawHide(playerid, INVINFO[userid][2]);
	PlayerTextDrawHide(playerid, INVINFO[userid][3]);
	PlayerTextDrawHide(playerid, INVINFO[userid][4]);
	PlayerTextDrawShow(playerid, INVINFO[userid][5]);
	PlayerTextDrawHide(playerid, INVINFO[userid][6]);
	PlayerTextDrawHide(playerid, INVINFO[userid][7]);
	PlayerTextDrawHide(playerid, INVINFO[userid][8]);
	PlayerTextDrawHide(playerid, INVINFO[userid][9]);
	PlayerTextDrawShow(playerid, INVINFO[userid][10]);
	PlayerTextDrawShow(playerid, BARQUANTITY[userid]);
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    PlayerTextDrawShow(playerid, INDEXTD[userid][i]);
		PlayerTextDrawShow(playerid, AMMOUNTTD[userid][i]);
		totalall += InventoryData[userid][i][invTotalQuantity];
		format(str, sizeof(str), "%.1f/850.0", float(totalall));
		PlayerTextDrawSetString(playerid, INVNAME[userid][3], str);
		quantitybar = totalall * 199/850;
	  	PlayerTextDrawTextSize(playerid, BARQUANTITY[userid], quantitybar, 3.0);
	  	PlayerTextDrawShow(playerid, BARQUANTITY[userid]);
		if(InventoryData[userid][i][invExists])
		{
			PlayerTextDrawShow(playerid, NAMETD[userid][i]);
			PlayerTextDrawShow(playerid, GARISBAWAH[userid][i]);
			PlayerTextDrawSetPreviewModel(playerid, MODELTD[userid][i], InventoryData[userid][i][invModel]);
			//sesuakian dengan object item kalian
			if(InventoryData[userid][i][invModel] == 18867)
			{
				PlayerTextDrawSetPreviewRot(playerid, MODELTD[userid][i], -254.000000, 0.000000, 0.000000, 2.779998);
			}
			else if(InventoryData[userid][i][invModel] == 16776)
			{
				PlayerTextDrawSetPreviewRot(playerid, MODELTD[userid][i], 0.000000, 0.000000, -85.000000, 1.000000);
			}
			else if(InventoryData[userid][i][invModel] == 1581)
			{
				PlayerTextDrawSetPreviewRot(playerid, MODELTD[userid][i], 0.000000, 0.000000, -180.000000, 1.000000);
			}
			PlayerTextDrawShow(playerid, MODELTD[userid][i]);
			strunpack(string, InventoryData[userid][i][invItem]);
			format(str, sizeof(str), "%s", string);
			PlayerTextDrawSetString(playerid, NAMETD[userid][i], str);
			format(str, sizeof(str), "%dx", InventoryData[userid][i][invAmount]);
			PlayerTextDrawSetString(playerid, AMMOUNTTD[userid][i], str);
		}
		else
		{
			PlayerTextDrawHide(playerid, AMMOUNTTD[userid][i]);
		}
	}
    new stra[500];
    format(stra, sizeof(stra), "Anda telah digeledah oleh %s", pData[playerid][pName]);
    InfoMsg(userid, stra);
    return 1;
}

ptask PlayerBus[1000](playerid)
{
	//JOB BUS
    new vehicleid = GetPlayerVehicleID(playerid);
	if(pData[playerid][pBus] && GetVehicleModel(vehicleid) == 431 && pData[playerid][pBuswaiting])
	{
		if(pData[playerid][pBustime] > 0)
		{
			pData[playerid][pBustime]--;
			new string[212];
			ShowNotifInfo(playerid, sprintf("Mohon Tunggu Selama %d Detik Untuk Melakukan Perjalanan", pData[playerid][pBustime]), 10000);
			GameTextForPlayer(playerid, string, 2000, 6);
			PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
		}
		else
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, -115.2943,-1159.4506,1.7561))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				pData[playerid][pBus] = 8;
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 2, buspoint8, buspoint8, 5.0);
				PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
				return 1;
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, 1172.1044,-1405.3931,12.8790))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				pData[playerid][pBus] = 16;
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 1, buspoint16, buspoint16, 5.0);
				PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
				return 1;
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, 1731.8765,-2319.6948,-3.2946))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				pData[playerid][pBus] = 30;
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 1, buspoint30, buspoint30, 5.0);
				PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
				return 1;
			} //L
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, -886.3450,-463.4493,23.9646))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				pData[playerid][pBus] = 72;
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 1, cpbus7, cpbus7, 5.0);
				PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
				return 1;
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, 164.0048,1150.3789,14.4663))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				pData[playerid][pBus] = 89;
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 1, cpbus24, cpbus24, 5.0);
				PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
				return 1;
			} // terakhir berenti
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, 526.4655,-109.1321,37.2908))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				pData[playerid][pBus] = 104;
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 1, cpbus39, cpbus39, 5.0);
				PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
				return 1;
			}
			//Bus Rute 3
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, 198.7756,-1503.1976,12.2431))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				pData[playerid][pBus] = 128;
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 1, buscp9, buscp9, 5.0);
				PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
				return 1;
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, 623.8340,-1360.3447,12.9780))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				pData[playerid][pBus] = 130;
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 1, buscp11, buscp11, 5.0);
				PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
				return 1;
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, 1208.1864,-1330.8541,12.9545))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				pData[playerid][pBus] = 134;
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 1, buscp15, buscp15, 5.0);
				PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
				return 1;
			}
		}
		return 1;
	}
	return 1;
}