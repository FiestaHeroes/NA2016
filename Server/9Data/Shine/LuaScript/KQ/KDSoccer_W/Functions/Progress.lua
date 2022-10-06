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


	-- 플레이어의 첫 로그인을 기다린다.
	if #Var["Player"] < 1
	then
		if Var["InitialSec"] + WAIT_PLAYER_MAP_LOGIN_SEC_MAX <= cCurrentSecond()
		then
			cEndOfKingdomQuest( Var[ "MapIndex" ] )
			return
		end

		return
	end


	-- 투명한 Door를 소환해 DoorBlock 관려가 필요함.
	local RegenInvisibleDoor = RegenInfo["InvisibleDoor"]
	Var["InvisibleDoor"] = cDoorBuild( Var["MapIndex"], RegenInvisibleDoor["Index"], RegenInvisibleDoor["X"], RegenInvisibleDoor["Y"], RegenInvisibleDoor["Dir"], 1000 )
	if Var["InvisibleDoor"] == nil
	then
		GoToFail( Var, "Invisible door regen fail" )
		return
	end


	cDoorAction( Var["InvisibleDoor"], InvisibleDoor["BlockName"], "open" )

	-- 축구공 소환
	SoccerBall_Regen( Var, RegenInfo["SoccerBall"]["X"], RegenInfo["SoccerBall"]["Y"], RegenInfo["SoccerBall"]["Dir"] )

	cDoorAction( Var["InvisibleDoor"], InvisibleDoor["BlockName"], "close" )



	-- 심판 소환
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


	-- 골키퍼 소환
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


	-- 관중 소환
	for i = 1, #RegenInfo["Spectator"]
	do
		cGroupRegenInstance( Var["MapIndex"], RegenInfo["Spectator"][i] )
	end

	-- 투명 몬스터 소환
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

		local setScriptResult			= cSetAIScript( MainLuaScriptPath, InvisibleMonsterHandle )							--해당 스크립트의 LuaScriptScenario* 를 찾아서, 해당 몬스터에 셋팅해줍니다. 말하자면 몬스터가 AI를 학습하는것이라고 할수있습니다.
		local setEntranceFunctionResult	= cAIScriptFunc( InvisibleMonsterHandle, "Entrance",  "InvisibleMonster_Routine" )	--해당 몬스터의 LuaAi 내 Entrance 문자열에, InvisibleMonster_Routine 루아함수 이름 문자열을 세팅합니다.

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


	-- 다음 단계 설정
	Var["StepFunc"] = StartWait
end


function StartWait( Var )
cExecCheck "StartWait"


	if Var == nil
	then
		ErrorLog( "StartWait : Var nil" )
		return
	end


	-- 스텝 초기화
	local StartWaitInfo = Var["StartWait"]
	if StartWaitInfo == nil
	then
		Var["StartWait"] = {}
		StartWaitInfo	 = Var["StartWait"]

		StartWaitInfo["NextSetpWaitTime"]	= Var["CurSec"] + DelayTime["StartWait"]
		StartWaitInfo["DialogTime"]			= Var["CurSec"] + DelayTime["StartDialogInterval"]
		StartWaitInfo["DialogStep"]			= 1
	end


	-- 다이얼로그 출력
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


	-- 다음 단계 진행
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


	-- 스탭 초기화
	if Var["KQLimitTime"] == 0
	then
		Var["KQLimitTime"] = Var[ "CurSec"] + DelayTime["LimitTime"]


		cScriptMsg( Var["MapIndex"], nil, NoticeInfo["Start"] )
--		cScoreInfo_AllInMap( Var["MapIndex"], KQ_TEAM["MAX"], Var["Team"][ KQ_TEAM["RED"] ], Var["Team"][ KQ_TEAM["BLUE"] ] )
		cWinter_Event_ScoreBoard_AllInMap( Var["MapIndex"], Var["Team"][ KQ_TEAM["RED"] ], Var["Team"][ KQ_TEAM["BLUE"] ] )
		cTimer( Var["MapIndex"], DelayTime["LimitTime"] )
	end


	-- 다음 단계 진행
	if Var["KQLimitTime"] <= Var["CurSec"]
	then
		Var["StepFunc"] = SoccerEnd

		cScriptMsg( Var["MapIndex"], nil, NoticeInfo["End"] )
		cScriptMsg( Var["MapIndex"], Var["Referee"]["Handle"], Referee_Chat["TimeOut"] )
		return
	end


	-- 플레이어 관리자
	if Player_Manager( Var ) == false
	then
		-- 어느 한쪽 팀이 전부 로그아웃되었을 경우
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


-- 경기 종료
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


	-- 레드 팀 우승
	if TeamInfo[ KQ_TEAM["RED"] ] > TeamInfo[ KQ_TEAM["BLUE"] ]
	then
		cScriptMsg( Var["MapIndex"], nil, NoticeInfo["Win"][ KQ_TEAM["RED"] ] )
		TeamReward[ KQ_TEAM["RED"] ]  = SoccerResult["WIN"]
		TeamReward[ KQ_TEAM["BLUE"] ] = SoccerResult["LOSE"]

		WinnerTeam = KQ_TEAM["RED"]

	-- 블루 팀 우승
	elseif TeamInfo[ KQ_TEAM["RED"] ] < TeamInfo[ KQ_TEAM["BLUE"] ]
	then
		cScriptMsg( Var["MapIndex"], nil, NoticeInfo["Win"][ KQ_TEAM["BLUE"] ] )
		TeamReward[ KQ_TEAM["RED"] ]  = SoccerResult["LOSE"]
		TeamReward[ KQ_TEAM["BLUE"] ] = SoccerResult["WIN"]

		WinnerTeam = KQ_TEAM["BLUE"]

	-- 동점
	else
		cScriptMsg( Var["MapIndex"], nil, NoticeInfo["Draw"] )

		TeamReward[ KQ_TEAM["RED"] ]  = SoccerResult["DRAW"]
		TeamReward[ KQ_TEAM["BLUE"] ] = SoccerResult["DRAW"]
	end


	-- 보상 지급
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


	-- 최고 득점자 타이틀
	if WinnerTeam ~= nil
	then

		local TopScore = 0

		-- 가장 높은 점수 찾기
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



	-- 도어 삭제
	cNPCVanish( Var["InvisibleDoor"] )

	-- 축구공 삭제
	if Var["SoccerBall"] ~= nil
	then
		cNPCVanish( Var["SoccerBall"] )
	end

	-- 심판 삭제
	if Var["Referee"] ~= nil
	then
		cNPCVanish( Var["Referee"]["Handle"] )
	end

	-- 골키퍼 삭제
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

	-- 버프박스 삭제
	for i = 1,#RegenInfo["BuffBox"]
	do
		cVanishAll( Var["MapIndex"], RegenInfo["BuffBox"][ i ]["Index"] )
	end

	-- 몬스터 삭제
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



	-- 다음 단계 설정
	Var["StepFunc"] = ReturnToHome

end



-- 귀환
function ReturnToHome( Var )
cExecCheck "ReturnToHome"


	if Var == nil
	then
		ErrorLog( "ReturnToHome : Var nil" )
		return
	end


	-- 스탭 초기화
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
	--변신을 해제시켜줍니다
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

