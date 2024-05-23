#define MAX_DYNAMIC_TAGS			500
#define TAGS_TEXT_LENGTH			65
#define TAGS_FONT_LENGTH			24

#define TAGS_DEFAULT_SIZE			50
#define TAGS_DEFAULT_MAX_SIZE		200


#define IsPlayerEditingTags(%0)		editing_tags[%0]
#define SetPlayerEditingTags(%0,%1)	editing_tags[%0]=%1


enum E_TAGS_DATA
{
	tagID,
	tagPlayerID,
	tagPlayerName[MAX_PLAYER_NAME],

	Float:tagPosition[3],
	Float:tagRotation[3],

	tagText[TAGS_TEXT_LENGTH],
	tagFont[TAGS_FONT_LENGTH],

	tagSize,
	tagColor,
	tagBold,
	tagExpired,

	tagObjectID
};

new 
	bool:editing_tags[MAX_PLAYERS] = {false, ...},
	editing_object[MAX_PLAYERS] = {INVALID_STREAMER_ID, ...};

new Iterator:Tags<MAX_DYNAMIC_TAGS>,
	TagsData[MAX_DYNAMIC_TAGS][E_TAGS_DATA];

new color_string[3256], object_font[200];

new const FontNames[][] = 
{
    "Arial",
    "Calibri",
    "Comic Sans MS",
    "Georgia",
    "Times New Roman",
    "Consolas",
    "Constantia",
    "Corbel",
    "Courier New",
    "Impact",
    "Lucida Console",
    "Palatino Linotype",
    "Tahoma",
    "Trebuchet MS",
    "Verdana",
    "Custom Font"
};

#include "./BUATAN/tags/impl.pwn"
#include "./BUATAN/tags/func.pwn"
#include "./BUATAN/tags/cmd.pwn"