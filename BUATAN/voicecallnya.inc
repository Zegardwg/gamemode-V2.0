CMD:angkattelp(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	if(pData[playerid][pCall] != INVALID_PLAYER_ID)
		return Error(playerid, "Anda sudah sedang menelpon seseorang!");
		
	if(pData[playerid][pInjured] != 0)
		return Error(playerid, "You cant do that in this time.");
		
	foreach(new ii : Player)
	{
		if(playerid == pData[ii][pCall])
		{
			pData[ii][pPhoneCredit]--;
			
			pData[playerid][pCall] = ii;
			//SendClientMessageEx(ii, COLOR_YELLOW, "[CELLPHONE] "WHITE_E"phone is connected, type '/hu' to stop!");
   			for(new i = 0; i < 29; i++)
			{
				TextDrawHideForPlayer(ii, TelponNotif[i]);
			}
			PlayerTextDrawHide(ii, NamaDanFuncall[ii][0]);
			PlayerTextDrawHide(ii, NamaDanFuncall[ii][1]);
			PlayerTextDrawHide(ii, BatalTelpon[ii]);
			PlayerTextDrawHide(ii, RijekTelpon[ii]);
			PlayerTextDrawHide(ii, AngkatTelpon[ii]);
			
			for(new i = 0; i < 23; i++)
			{
				TextDrawShowForPlayer(ii, PlayerTelpon[i]);
			}

			new tstr[256];
			format(tstr, sizeof(tstr), "%s", pData[playerid][pName]);
			PlayerTextDrawSetString(ii, NamaDanJamTelp[ii][0], tstr);
			PlayerTextDrawShow(ii, NamaDanJamTelp[ii][0]);
			PlayerTextDrawShow(ii, NamaDanJamTelp[ii][1]);
			PlayerTextDrawShow(ii, AkhiriTelpon[ii]);
			CancelSelectTextDraw(ii);
			//SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE] "WHITE_E"phone is connected, type '/hu' to stop!");
			for(new i = 0; i < 29; i++)
			{
				TextDrawHideForPlayer(playerid, TelponNotif[i]);
			}
			PlayerTextDrawHide(playerid, NamaDanFuncall[playerid][0]);
			PlayerTextDrawHide(playerid, NamaDanFuncall[playerid][1]);
			PlayerTextDrawHide(playerid, BatalTelpon[playerid]);
			PlayerTextDrawHide(playerid, RijekTelpon[playerid]);
			PlayerTextDrawHide(playerid, AngkatTelpon[playerid]);
			
			for(new i = 0; i < 23; i++)
			{
				TextDrawShowForPlayer(playerid, PlayerTelpon[i]);
			}
			format(tstr, sizeof(tstr), "%s", pData[ii][pName]);
			PlayerTextDrawSetString(playerid, NamaDanJamTelp[playerid][0], tstr);
			PlayerTextDrawShow(playerid, NamaDanJamTelp[playerid][0]);
			PlayerTextDrawShow(playerid, NamaDanJamTelp[playerid][1]);
			PlayerTextDrawShow(playerid, AkhiriTelpon[playerid]);
			CancelSelectTextDraw(playerid);
			ToggleCall[playerid] = 1;
			ToggleCall[ii] = 1;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s answers their cellphone.", ReturnName(playerid));
			
			DetikCall[playerid] = 0;
			MenitCall[playerid] = 0;
			JamCall[playerid] = 0;
			
			DetikCall[ii] = 0;
			MenitCall[ii] = 0;
			JamCall[ii] = 0;
			
			KillTimer(CallTimer[playerid]);
			KillTimer(CallTimer[ii]);
			
			CallTimer[playerid] = SetTimerEx("TambahDetikCall", 1000, true, "i", playerid);
			CallTimer[ii] = SetTimerEx("TambahDetikCall", 1000, true, "i", ii);
			
   			new targetid = pData[playerid][pCall];

			OnPhone[targetid] = SvCreateGStream(0xFFA200FF, "InPhone");

		    if (OnPhone[targetid])
			{
		        SvAttachListenerToStream(OnPhone[targetid], targetid);
		        SvAttachListenerToStream(OnPhone[targetid], playerid);
		    }
		    if (OnPhone[targetid] && pData[playerid][pCall] != INVALID_PLAYER_ID)
			{
		        SvAttachSpeakerToStream(OnPhone[targetid], playerid);
		    }

		    if(OnPhone[targetid] && pData[targetid][pCall] != INVALID_PLAYER_ID)
			{
		        SvAttachSpeakerToStream(OnPhone[targetid], targetid);
		    }
		}
	}
	return 1;
}

CMD:offhu(playerid, params[])
{
 	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	for(new i = 0; i < 29; i++)
	{
		TextDrawHideForPlayer(playerid, TelponNotif[i]);
	}
	PlayerTextDrawHide(playerid, NamaDanFuncall[playerid][0]);
	PlayerTextDrawHide(playerid, NamaDanFuncall[playerid][1]);
	PlayerTextDrawHide(playerid, BatalTelpon[playerid]);
	PlayerTextDrawHide(playerid, RijekTelpon[playerid]);
	PlayerTextDrawHide(playerid, AngkatTelpon[playerid]);
	CancelSelectTextDraw(playerid);
	ToggleCall[playerid] = 0;
	DetikCall[playerid] = 0;
	MenitCall[playerid] = 0;
	JamCall[playerid] = 0;
	pData[playerid][pCall] = INVALID_PLAYER_ID;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	return 1;
}

CMD:ofhu(playerid, params[])
{
 	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    foreach(new ii : Player)
	{
		if(playerid == pData[ii][pCall])
		{
			pData[playerid][pCall] = ii;
			for(new i = 0; i < 29; i++)
			{
				TextDrawHideForPlayer(ii, TelponNotif[i]);
			}
			PlayerTextDrawHide(ii, NamaDanFuncall[ii][0]);
			PlayerTextDrawHide(ii, NamaDanFuncall[ii][1]);
			PlayerTextDrawHide(ii, BatalTelpon[ii]);
			PlayerTextDrawHide(ii, RijekTelpon[ii]);
			PlayerTextDrawHide(ii, AngkatTelpon[ii]);
			pData[ii][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(ii, SPECIAL_ACTION_STOPUSECELLPHONE);
			//SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE] "WHITE_E"phone is connected, type '/hu' to stop!");
			for(new i = 0; i < 29; i++)
			{
				TextDrawHideForPlayer(playerid, TelponNotif[i]);
			}
			PlayerTextDrawHide(playerid, NamaDanFuncall[playerid][0]);
			PlayerTextDrawHide(playerid, NamaDanFuncall[playerid][1]);
			PlayerTextDrawHide(playerid, BatalTelpon[playerid]);
			PlayerTextDrawHide(playerid, RijekTelpon[playerid]);
			PlayerTextDrawHide(playerid, AngkatTelpon[playerid]);
			CancelSelectTextDraw(playerid);
			CancelSelectTextDraw(ii);
			ToggleCall[ii] = 0;
			ToggleCall[playerid] = 0;
			DetikCall[playerid] = 0;
			MenitCall[playerid] = 0;
			JamCall[playerid] = 0;
			DetikCall[ii] = 0;
			MenitCall[ii] = 0;
			JamCall[ii] = 0;
			pData[playerid][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
		}
	}
	return 1;
}

CMD:endcall(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	new caller = pData[playerid][pCall];
	if(IsPlayerConnected(caller) && caller != INVALID_PLAYER_ID)
	{
		pData[caller][pCall] = INVALID_PLAYER_ID;
		SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
		//SendNearbyMessage(caller, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(caller));
		for(new i = 0; i < 23; i++)
		{
			TextDrawHideForPlayer(caller, PlayerTelpon[i]);
		}
		PlayerTextDrawHide(caller, NamaDanJamTelp[caller][0]);
		PlayerTextDrawHide(caller, NamaDanJamTelp[caller][1]);
		PlayerTextDrawHide(caller, AkhiriTelpon[caller]);
		CancelSelectTextDraw(caller);
		ToggleCall[caller] = 0;
		DetikCall[caller] = 0;
		MenitCall[caller] = 0;
		JamCall[caller] = 0;
		
		//SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(playerid));
  		for(new i = 0; i < 23; i++)
		{
			TextDrawHideForPlayer(playerid, PlayerTelpon[i]);
		}
		PlayerTextDrawHide(playerid, NamaDanJamTelp[playerid][0]);
		PlayerTextDrawHide(playerid, NamaDanJamTelp[playerid][1]);
		PlayerTextDrawHide(playerid, AkhiriTelpon[playerid]);
		CancelSelectTextDraw(playerid);
		ToggleCall[playerid] = 0;
		DetikCall[playerid] = 0;
		MenitCall[playerid] = 0;
		JamCall[playerid] = 0;
		pData[playerid][pCall] = INVALID_PLAYER_ID;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);

  		if (OnPhone[caller] && pData[caller][pCall] != INVALID_PLAYER_ID)
	 	{
            SvDetachSpeakerFromStream(OnPhone[caller], caller);
        }

        if(OnPhone[caller] && pData[playerid][pCall] != INVALID_PLAYER_ID)
		{
            SvDetachSpeakerFromStream(OnPhone[caller], playerid);
        }

        if(OnPhone[caller])
		{
            SvDetachListenerFromStream(OnPhone[caller], caller);
            SvDetachListenerFromStream(OnPhone[caller], playerid);
            SvDeleteStream(OnPhone[caller]);
            OnPhone[caller] = SV_NULL;
        }

		if (OnPhone[playerid] && pData[caller][pCall] != INVALID_PLAYER_ID)
		{
            SvDetachSpeakerFromStream(OnPhone[playerid], caller);
        }

        if(OnPhone[playerid] && pData[playerid][pCall] != INVALID_PLAYER_ID)
		{
            SvDetachSpeakerFromStream(OnPhone[playerid], playerid);
        }

        if(OnPhone[playerid])
		{
            SvDetachListenerFromStream(OnPhone[playerid], caller);
            SvDetachListenerFromStream(OnPhone[playerid], playerid);
            SvDeleteStream(OnPhone[playerid]);
            OnPhone[playerid] = SV_NULL;
        }
	}
	return 1;
}