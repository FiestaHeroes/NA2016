--------------------------------------------------------------------------------
--                           Arena Progress Func                              --
--------------------------------------------------------------------------------

function InitSoccer( Var )
cExecCheck "InitSoccer"


	if Var == nil
	then
		ErrorLog( "InitSoccer : Var nil" )
		return
	end


	-- �÷��̾��� ù �α����� ��ٸ���.
	if #Var["Player"] < 1
	then
		if Var["InitialSec"] + WAIT_PLAYER_MAP_LOGIN_SEC_MAX <= cCurrentSecond()
		then
			cEndOfKingdomQuest( Var[ "MapIndex" ] )
			return
		end

		return
	end


	-- ������ Door�� ��ȯ�� DoorBlock ������ �ʿ���.
	local RegenInvisibleDoor = RegenInfo["InvisibleDoor"]
	Var["InvisibleDoor"] = cDoorBuild( Var["MapIndex"], RegenInvisibleDoor["Index"], RegenInvisibleDoor["X"], RegenInvisibleDoor["Y"], RegenInvisibleDoor["Dir"], 1000 )
	if Var["InvisibleDoor"] == nil
	then
		GoToFail( Var, "Invisible door regen fail" )
		return
	end


	cDoorAction( Var["InvisibleDoor"], InvisibleDoor["BlockName"], "open" )

	-- �౸�� ��ȯ
	SoccerBall_Regen( Var, RegenInfo["SoccerBall"]["X"], RegenInfo["SoccerBall"]["Y"], RegenInfo["SoccerBall"]["Dir"] )

	cDoorAction( Var["InvisibleDoor"], InvisibleDoor["BlockName"], "close" )



	-- ���� ��ȯ
	local RegenReferee	= RegenInfo["Referee"]
	local RefereeHandle

	RefereeHandle = cMobRegen_XY( Var["MapIndex"], RegenReferee["Index"], RegenReferee["X"], RegenReferee["Y"], RegenReferee["Dir"] )
	if RefereeHandle == nil
	then
		GoToFail( Var, "Referee regen fail" )
		return
	end

	Var["Referee"]["Handle"]			= RefereeHandle
	Var["Referee"]["FollowCheckTime"]	= 0
	Var["Referee"]["RoutineCheckTime"]	= 0

	cSetAIScript ( MainLuaScriptPath, RefereeHandle )
	cAIScriptFunc( RefereeHandle, "Entrance",  "Referee_Routine" )


	-- ��Ű�� ��ȯ
	for i = 1, #RegenInfo["GoalKeeper"]
	do
		local RegenKeeper = RegenInfo["GoalKeeper"][ i ]
		local KeeperHandle

		KeeperHandle = cMobRegen_XY( Var["MapIndex"], RegenKeeper["Index"], RegenKeeper["X"], RegenKeeper["Y"], RegenKeeper["Dir"] )
		if KeeperHandle == nil
		then
			GoToFail( Var, "Goalkeeper regen fail" )
			return
		end

		Var["Keeper"][ i ]	= {}
		Var["Keeper"][ i ]["Handle"]			= KeeperHandle
		Var["Keeper"][ i ]["TeamType"]			= RegenKeeper["TeamType"]
		Var["Keeper"][ i ]["RoutineCheckTime"]	= 0
		Var["Keeper"][ i ]["MoveStep"]			= 1
		Var["Keeper"][ i ]["MoveBack"]			= false

		cSetAIScript ( MainLuaScriptPath, KeeperHandle )
		cAIScriptFunc( KeeperHandle, "Entrance",  "Keeper_Routine" )
	end


	-- ���� ��ȯ
	for i = 1, #RegenInfo["Spectator"]
	do
		cGroupRegenInstance( Var["MapIndex"], RegenInfo["Spectator"][i] )
	end

	-- ���� ���� ��ȯ
	for i = 1, #RegenInfo[ "InvisibleMonster" ]
	do
		local RegenInvisibleMonster = RegenInfo[ "InvisibleMonster" ][ i ]
		local InvisibleMonsterHandle

		InvisibleMonsterHandle = cMobRegen_XY( Var["MapIndex"], RegenInvisibleMonster[ "Index" ], RegenInvisibleMonster[ "X" ], RegenInvisibleMonster[ "Y" ], RegenInvisibleMonster[ "Dir" ] )
		if InvisibleMonsterHandle == nil
		then
			GoToFail( Var, "InvisibleMonster regen fail" )
			return
		end

		local setScriptResult			= cSetAIScript( MainLuaScriptPath, InvisibleMonsterHandle )							--�ش� ��ũ��Ʈ�� LuaScriptScenario* �� ã�Ƽ�, �ش� ���Ϳ� �������ݴϴ�. �����ڸ� ���Ͱ� AI�� �н��ϴ°��̶�� �Ҽ��ֽ��ϴ�.
		local setEntranceFunctionResult	= cAIScriptFunc( InvisibleMonsterHandle, "Entrance",  "InvisibleMonster_Routine" )	--�ش� ������ LuaAi �� Entrance ���ڿ���, InvisibleMonster_Routine ����Լ� �̸� ���ڿ��� �����մϴ�.

		if	setScriptResult == nil				or
			setScriptResult == 0				or
			setEntranceFunctionResult == nil	or
			setEntranceFunctionResult == 0
		then
			GoToFail( Var, "InvisibleMonster setAI fail" )
			return
		end

		Var[ "InvisibleMonster" ][ i ]							= {}
		Var[ "InvisibleMonster" ][ i ][ "Handle" ]				= InvisibleMonsterHandle
		Var[ "InvisibleMonster" ][ i ][ "MonsterNumber" ]		= RegenInvisibleMonster[ "MonsterNumber" ]
		Var[ "InvisibleMonster" ][ i ][ "RoutineCheckTime" ]	= 0
		Var[ "InvisibleMonster" ][ i ][ "MoveStep" ]			= 1
		Var[ "InvisibleMonster" ][ i ][ "MoveBack" ]			= false
	end


	-- ���� �ܰ� ����
	Var["StepFunc"] = StartWait
end


function StartWait( Var )
cExecCheck "StartWait"


	if Var == nil
	then
		ErrorLog( "StartWait : Var nil" )
		return
	end


	-- ���� �ʱ�ȭ
	local StartWaitInfo = Var["StartWait"]
	if StartWaitInfo == nil
	then
		Var["StartWait"] = {}
		StartWaitInfo	 = Var["StartWait"]

		StartWaitInfo["NextSetpWaitTime"]	= Var["CurSec"] + DelayTime["StartWait"]
		StartWaitInfo["DialogTime"]			= Var["CurSec"] + DelayTime["StartDialogInterval"]
		StartWaitInfo["DialogStep"]			= 1
	end


	-- ���̾�α� ���
	if StartWaitInfo["DialogTime"] ~= nil
	then
		if StartWaitInfo["DialogTime"] <= Var["CurSec"]
		then
			local DialogStep	= StartWaitInfo["DialogStep"]
			local MaxDialogStep	= #Referee_Chat["StartDialog"]

			if DialogStep <= MaxDialogStep
			then
				cScriptMsg( Var["MapIndex"], nil, Referee_Chat["StartDialog"][ DialogStep ] )

				StartWaitInfo["DialogTime"]	= Var["CurSec"] + DelayTime["StartDialogInterval"]
				StartWaitInfo["DialogStep"]	= DialogStep + 1
			end

			if StartWaitInfo["DialogStep"] > MaxDialogStep
			then
				StartWaitInfo["DialogTime"]	= nil
				StartWaitInfo["DialogStep"]	= nil
			end
		end
	end


	-- ���� �ܰ� ����
	if StartWaitInfo["NextSetpWaitTime"] <= Var["CurSec"]
	then
		Var["StepFunc"]		= SoccerProcess
		Var["StartWait"]	= nil
		StartWaitInfo		= nil
	end

end


function SoccerProcess( Var )
cExecCheck "SoccerProcess"


	if Var == nil
	then
		ErrorLog( "SoccerProcess : Var nil" )
		return
	end


	-- ���� �ʱ�ȭ
	if Var["KQLimitTime"] == 0
	then
		Var["KQLimitTime"] = Var[ "CurSec"] + DelayTime["LimitTime"]


		cScriptMsg( Var["MapIndex"], nil, NoticeInfo["Start"] )
--		cScoreInfo_AllInMap( Var["MapIndex"], KQ_TEAM["MAX"], Var["Team"][ KQ_TEAM["RED"] ], Var["Team"][ KQ_TEAM["BLUE"] ] )
		cWinter_Event_ScoreBoard_AllInMap( Var["MapIndex"], Var["Team"][ KQ_TEAM["RED"] ], Var["Team"][ KQ_TEAM["BLUE"] ] )
		cTimer( Var["MapIndex"], DelayTime["LimitTime"] )
	end


	-- ���� �ܰ� ����
	if Var["KQLimitTime"] <= Var["CurSec"]
	then
		Var["StepFunc"] = SoccerEnd

		cScriptMsg( Var["MapIndex"], nil, NoticeInfo["End"] )
		cScriptMsg( Var["MapIndex"], Var["Referee"]["Handle"], Referee_Chat["TimeOut"] )
		return
	end


	-- �÷��̾� ������
	if Player_Manager( Var ) == false
	then
		-- ��� ���� ���� ���� �α׾ƿ��Ǿ��� ���
		Var["Team"][ KQ_TEAM["RED"] ] 	= 0
		Var["Team"][ KQ_TEAM["BLUE"] ] 	= 0


		Var["StepFunc"] = SoccerEnd

		cScriptMsg( Var["MapIndex"], nil, NoticeInfo["End"] )
		cScriptMsg( Var["MapIndex"], Var["Referee"]["Handle"], Referee_Chat["TimeOut"] )
		return
	end


	BuffBox_Manager( Var )
	SoccerBall_Manager( Var )
end


-- ��� ����
function SoccerEnd( Var )
cExecCheck "SoccerEnd"


	if Var == nil
	then
		ErrorLog( "SoccerEnd : Var nil" )
		return
	end


	local TeamInfo = Var["Team"]
	if TeamInfo == nil
	then
		ErrorLog( "SoccerEnd : Var[\"Team\"] nil" )
		return
	end


	local PlayerList = Var["Player"]
	if PlayerList == nil
	then
		ErrorLog( "SoccerEnd : PlayerList nil" )
		return
	end


	Var["KQLimitTime"] = 0


	cTimer( Var["MapIndex"], 0 )


	local TeamReward 	= {}
	local WinnerTeam	= nil


	-- ���� �� ���
	if TeamInfo[ KQ_TEAM["RED"] ] > TeamInfo[ KQ_TEAM["BLUE"] ]
	then
		cScriptMsg( Var["MapIndex"], nil, NoticeInfo["Win"][ KQ_TEAM["RED"] ] )
		TeamReward[ KQ_TEAM["RED"] ]  = SoccerResult["WIN"]
		TeamReward[ KQ_TEAM["BLUE"] ] = SoccerResult["LOSE"]

		WinnerTeam = KQ_TEAM["RED"]

	-- ��� �� ���
	elseif TeamInfo[ KQ_TEAM["RED"] ] < TeamInfo[ KQ_TEAM["BLUE"] ]
	then
		cScriptMsg( Var["MapIndex"], nil, NoticeInfo["Win"][ KQ_TEAM["BLUE"] ] )
		TeamReward[ KQ_TEAM["RED"] ]  = SoccerResult["LOSE"]
		TeamReward[ KQ_TEAM["BLUE"] ] = SoccerResult["WIN"]

		WinnerTeam = KQ_TEAM["BLUE"]

	-- ����
	else
		cScriptMsg( Var["MapIndex"], nil, NoticeInfo["Draw"] )

		TeamReward[ KQ_TEAM["RED"] ]  = SoccerResult["DRAW"]
		TeamReward[ KQ_TEAM["BLUE"] ] = SoccerResult["DRAW"]
	end


	-- ���� ����
	for i = 1, #PlayerList
	do
		local PlayerInfo = PlayerList[ i ]
		local RewardInfo = TeamReward[ PlayerInfo["TeamType"] ]

		if 	PlayerInfo["IsInMap"] == true and
			RewardInfo 			  ~= nil
		then
			cEffectMsg( PlayerInfo["Handle"], RewardInfo["EffectMsg"] )
			cKQRewardIndex( PlayerInfo["Handle"], RewardInfo["RewardIndex"] )

			cCharTitleAddValue( PlayerInfo["Handle"], SoccerResult["SoccerPlayerTitle"], 1 )
		end
	end


	-- �ְ� ������ Ÿ��Ʋ
	if WinnerTeam ~= nil
	then

		local TopScore = 0

		-- ���� ���� ���� ã��
		for i = 1, #PlayerList
		do
			local PlayerInfo = PlayerList[ i ]

			if 	PlayerInfo["IsInMap"] == true
			then
				if TopScore < PlayerInfo["Goal"]
				then
					TopScore = PlayerInfo["Goal"]
				end
			end
		end


		if TopScore ~= 0
		then

			for i = 1, #PlayerList
			do
				local PlayerInfo = PlayerList[ i ]

				if 	PlayerInfo["IsInMap"] == true
				then
					if TopScore == PlayerInfo["Goal"]
					then
						cCharTitleAddValue( PlayerInfo["Handle"], SoccerResult["SoccerTopScorerTitle"], 1 )
					end
				end
			end
		end
	end



	-- ���� ����
	cNPCVanish( Var["InvisibleDoor"] )

	-- �౸�� ����
	if Var["SoccerBall"] ~= nil
	then
		cNPCVanish( Var["SoccerBall"] )
	end

	-- ���� ����
	if Var["Referee"] ~= nil
	then
		cNPCVanish( Var["Referee"]["Handle"] )
	end

	-- ��Ű�� ����
	if Var["Keeper"] ~= nil
	then
		for i = 1, #Var["Keeper"]
		do
			if Var["Keeper"][ i ]["Handle"] ~= nil
			then
				cNPCVanish( Var["Keeper"][ i ]["Handle"] )
			end
		end
	end

	-- �����ڽ� ����
	for i = 1,#RegenInfo["BuffBox"]
	do
		cVanishAll( Var["MapIndex"], RegenInfo["BuffBox"][ i ]["Index"] )
	end

	-- ���� ����
	if Var[ "InvisibleMonster" ] ~= nil
	then
		for i = 1, #Var[ "InvisibleMonster" ]
		do
			if Var[ "InvisibleMonster" ][ i ][ "Handle" ] ~= nil
			then
				cNPCVanish( Var[ "InvisibleMonster" ][ i ][ "Handle" ] )
			end
		end
	end



	-- ���� �ܰ� ����
	Var["StepFunc"] = ReturnToHome

end



-- ��ȯ
function ReturnToHome( Var )
cExecCheck "ReturnToHome"


	if Var == nil
	then
		ErrorLog( "ReturnToHome : Var nil" )
		return
	end


	-- ���� �ʱ�ȭ
	if Var["ReturnToHome"] == nil
	then
		DebugLog( "Start ReturnToHome" )
		Var["ReturnToHome"] = {}
		Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"]
		Var["ReturnToHome"]["ReturnStepNo"]  = 1
	end


	-- Return : return notice substep
	if Var["ReturnToHome"]["ReturnStepNo"] <= #NoticeInfo["KQReturn"]
	then
		if Var["ReturnToHome"]["ReturnStepSec"] <= Var["CurSec"]
		then
			-- Notice of Escape
			if NoticeInfo["KQReturn"][ Var["ReturnToHome"]["ReturnStepNo"] ]["Index"] ~= nil
			then
				cNotice( Var["MapIndex"], NoticeInfo["KQReturn"]["ScriptFileName"], NoticeInfo["KQReturn"][ Var["ReturnToHome"]["ReturnStepNo"] ]["Index"] )
			end

			-- Go To Next Notice
			Var["ReturnToHome"]["ReturnStepNo"]  = Var["ReturnToHome"]["ReturnStepNo"] + 1
			Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"] + DelayTime["GapKQReturnNotice"]
		end

		return
	end

--[[
	--������ ���������ݴϴ�
	local PlayerList = Var[ "Player" ]
	if PlayerList ~= nil
	then
		for i = 1, #PlayerList
		do
			local TargetPlayerInfo	= PlayerList[ i ]
			if 	TargetPlayerInfo ~= nil	--and TargetPlayerInfo[ "IsInMap" ] == true
			then
				cResetAbstate( TargetPlayerInfo[ "Handle" ], LoginSetAbstate[ TargetPlayerInfo[ "TeamType" ] ] )
			end
		end
	end
--]]

	-- Return : linkto substep
	if Var["ReturnToHome"]["ReturnStepNo"] > #NoticeInfo["KQReturn"]
	then
		if Var["ReturnToHome"]["ReturnStepSec"] <= Var["CurSec"]
		then
			--Finish_KQ
			cLinkToAll( Var["MapIndex"], LinkInfo["ReturnMap"]["MapIndex"], LinkInfo["ReturnMap"]["x"], LinkInfo["ReturnMap"]["y"] )
			cVanishAll();

			Var["ReturnToHome"] = nil
			if cEndOfKingdomQuest( Var["MapIndex"] ) == nil
			then
				ErrorLog( "ReturnToHome::Function cEndOfKingdomQuest failed" )
			end
		end

		return
	end

end

