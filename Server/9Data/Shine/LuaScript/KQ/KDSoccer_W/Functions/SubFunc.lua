--------------------------------------------------------------------------------
--                      Giant Honeying Sub Functions                          --
--------------------------------------------------------------------------------


function DummyFunc( Var )
cExecCheck "DummyFunc"
end



----------------------------------------------------------------------
-- Player
----------------------------------------------------------------------
function Player_Insert( Var, CharNo, Handle, TeamType )
cExecCheck "Player_Insert"


	if Var == nil
	then
		ErrorLog( "Player_Insert : Var nil" )
		return
	end

	local PlayerList = Var["Player"]
	if PlayerList == nil
	then
		ErrorLog( "Player_Insert : PlayerList nil" )
		return
	end

	if CharNo == nil
	then
		ErrorLog( "Player_Insert : ErrorLog nil" )
		return
	end

	if Handle == nil
	then
		ErrorLog( "Player_Insert : Handle nil" )
		return
	end

	if TeamType == nil
	then
		ErrorLog( "Player_Insert : TeamType nil" )
		return
	end


	local InsertIndex = #PlayerList + 1

	PlayerList[ InsertIndex ] = {}
	PlayerList[ InsertIndex ]["CharNo"]		= CharNo
	PlayerList[ InsertIndex ]["CharID"]		= cGetPlayerName( Handle )
	PlayerList[ InsertIndex ]["Handle"]		= Handle
	PlayerList[ InsertIndex ]["TeamType"]	= TeamType
	PlayerList[ InsertIndex ]["Goal"]		= 0
	PlayerList[ InsertIndex ]["IsInMap"]	= true

end


function Player_Get( Var, CharNo )
cExecCheck "Player_Get"


	if Var == nil
	then
		ErrorLog( "Player_Get : Var nil" )
		return
	end

	local PlayerList = Var["Player"]
	if PlayerList == nil
	then
		ErrorLog( "Player_Get : PlayerList nil" )
		return
	end


	for i = 1, #PlayerList
	do
		if PlayerList[ i ]["CharNo"] == CharNo
		then
			return PlayerList[ i ]
		end
	end

end


function Player_Manager( Var )
cExecCheck "Player_Manager"


	if Var == nil
	then
		ErrorLog( "Player_Insert : Var nil" )
		return false
	end

	local PlayerList = Var["Player"]
	if PlayerList == nil
	then
		ErrorLog( "Player_Insert : PlayerList nil" )
		return false
	end



	-- 플레이어 접속 확인
	local TeamMemberCnt = {}

	for i = 1, #PlayerList
	do
		local PlayerInfo = PlayerList[ i ]

		-- 플레이어가 맵에 있는지 확인
		if PlayerInfo["IsInMap"] == true
		then
			if cIsInMap( PlayerInfo["Handle"], Var["MapIndex"] ) == nil
			then
				PlayerInfo["IsInMap"] = false
			end
		end

		-- 접속하고 있는 유저 수 확인
		if PlayerInfo["IsInMap"] == true
		then
			if TeamMemberCnt[ PlayerInfo["TeamType"] ] == nil
			then
				TeamMemberCnt[ PlayerInfo["TeamType"] ] = 1
			else
				TeamMemberCnt[ PlayerInfo["TeamType"] ] = TeamMemberCnt[ PlayerInfo["TeamType"] ] + 1
			end
		end
	end


	if 	TeamMemberCnt[ KQ_TEAM["RED"] ]  == nil or
		TeamMemberCnt[ KQ_TEAM["BLUE"] ] == nil
	then
		return false
	end


	-- 플레이어 관련 작업
	for i = 1, #PlayerList
	do
		local PlayerInfo	= PlayerList[ i ]
		local SpeedUpBuff	= PlayerInfo["SpeedUpBuff"]
		local InvincibleBuff= PlayerInfo["InvincibleBuff"]


		if PlayerInfo["IsInMap"] == true
		then
			-- 이동속도 버프가 걸려 있으면
			if SpeedUpBuff ~= nil
			then
				if SpeedUpBuff["KeepTime"] <= Var["CurSec"]
				then
					cResetAbstate( PlayerInfo["Handle"], SpeedUpBox["AbsIndex"] )
					cStaticWalkSpeed( PlayerInfo["Handle"], true, (Player_WalkSpeed * StaticMoveSpeedRate) )
					cStaticRunSpeed(  PlayerInfo["Handle"], true, (Player_RunSpeed  * StaticMoveSpeedRate) )

					SpeedUpBuff					= nil
					PlayerInfo["SpeedUpBuff"]	= nil
				end
			end


			-- 넉백 버프가 걸려있으면
			if InvincibleBuff ~= nil
			then
				-- 일정 시간마다, 주위 다른 팀에게 넉백 처리
				if InvincibleBuff["TickTime"] <= Var["CurSec"]
				then
					local OpposingTeam 	= OpposingTeamInfo[ PlayerInfo["TeamType"] ]
					local TargetAbsInfo 	= InvincibleBox["TargetAbs"]

					if OpposingTeam ~= nil
					then
						for j = 1, #PlayerList
						do
							local TargetPlayerInfo = PlayerList[ j ]

							if	PlayerInfo["IsInMap"] == true and TargetPlayerInfo["TeamType"] == OpposingTeam
							then
								if cDistanceSquar( PlayerInfo["Handle"], TargetPlayerInfo["Handle"] ) <= (InvincibleBox["Dist"] * InvincibleBox["Dist"])
								then
									cSetAbstate( TargetPlayerInfo["Handle"], TargetAbsInfo["Index"], TargetAbsInfo["Str"], (TargetAbsInfo["KeepTime"] * 1000), PlayerInfo["Handle"] )
								end
							end
						end
					end

					InvincibleBuff["TickTime"] = Var["CurSec"] + InvincibleBox["TickTime"]
				end


				if InvincibleBuff["KeepTime"] <= Var["CurSec"]
				then
					cResetAbstate( PlayerInfo["Handle"], InvincibleBox["AbsIndex"] )

					InvincibleBuff					= nil
					PlayerInfo["InvincibleBuff"]	= nil
				end
			end
		end
	end


	return true

end



----------------------------------------------------------------------
-- SoccerBall Function
----------------------------------------------------------------------
function SoccerBall_Regen( Var, X, Y, Dir )


	if Var == nil
	then
		return
	end

	if X == nil
	then
		return
	end

	if Y == nil
	then
		return
	end

	if Dir == nil
	then
		return
	end

	if Var["SoccerBall"] ~= nil
	then
		cNPCVanish( Var["SoccerBall"] )
	end


	-- 축구공 소환
	local RegenBall		= RegenInfo["SoccerBall"]
	local BallHandle

	BallHandle = cMobRegen_XY( Var["MapIndex"], RegenBall["Index"], X, Y, Dir )
	if BallHandle == nil
	then
		GoToFail( Var, "Soccerball regen fail" )
		return
	end

	Var["SoccerBall"] = BallHandle

	cSetAIScript ( MainLuaScriptPath, BallHandle )
	cAIScriptFunc( BallHandle, "Entrance",  "DummyRoutineFunc" )
	cAIScriptFunc( BallHandle, "NPCAction", "SoccerBall_NPCAction" )

end


function SoccerBall_Kick( Var, BallHandle, TeamType, KickerHandle, KickerCharNo, IsPlayer )
cExecCheck "SoccerBall_Kick"


	if Var == nil
	then
		ErrorLog( "SoccerBall_Kick : Var nil" )
		return
	end

	if Var["Kicker"] == nil
	then
		ErrorLog( "SoccerBall_Kick : Var[\"Kicker\"] nil" )
		return
	end

	if BallHandle == nil
	then
		ErrorLog( "SoccerBall_Kick : BallHandle nil" )
		return
	end

	if TeamType == nil
	then
		ErrorLog( "SoccerBall_Kick : TeamType nil" )
		return
	end

	if KickerHandle == nil
	then
		ErrorLog( "SoccerBall_Kick : KickerHandle nil" )
		return
	end


	-- Ball, Kicker 의 위치
	local KickX, KickY = cObjectLocate( KickerHandle )
	local BallX, BallY = cObjectLocate( BallHandle )
	if KickX == nil or KickY == nil or BallX == nil or BallY == nil
	then
		return
	end

	-- kicker 의 달리기속도
	local KickerRunSpeed = cGetRunSpeed( KickerHandle )
	if KickerRunSpeed == nil
	then
		return
	end


	-- 이동할 위치 계산
	local _x = BallX - KickX
	local _y = BallY - KickY
	local Dist		= math.sqrt( ((_x * _x) + (_y * _y)) )
	local MoveDist	= SoccerBall["MoveDist"] + ( KickerRunSpeed / 10 )


	if Dist == 0
	then
		Dist = 1
	end


	_x = (_x / Dist) * MoveDist
	_y = (_y / Dist) * MoveDist


	-- 수정이 필요할 듯, 일정 확률로 좌,우 0 ~ 50도 회전 시켜서 이동
	if cRandom(0, SoccerBall["MissRateMax"]) <= KickerRunSpeed
	then
		local Angle = cRandom( SoccerBall["MoveAngle"]["Min"], SoccerBall["MoveAngle"]["Max"] )

		if cRandom(0, 100) < 50
		then
			_x, _y = cLocationRotate( _x, _y, Angle );
		else
			_x, _y = cLocationRotate( _x, _y, (180 - Angle) );
		end
	end


	_x = BallX + _x
	_y = BallY + _y


	-- Ball 이동속도 설정, 이동
	cRunToUntilBlock( BallHandle, _x, _y, SoccerBall["MoveSpeedRate"] )


	-- Kicker 정보 설정
	if IsPlayer == true and KickerCharNo ~= nil
	then
		Var["Kicker"]["CharNo"]		= KickerCharNo
		Var["Kicker"]["IsPlayer"]	= true
	else
		Var["Kicker"]["NPCHandle"]	= KickerHandle
		Var["Kicker"]["IsPlayer"]	= false
	end

	Var["Kicker"]["TeamType"] = TeamType

end


function SoccerBall_Manager( Var )
cExecCheck( "SoccerBall_Manager" )


	if Var == nil
	then
		ErrorLog( "SoccerBall_Manager : Var nil" )
		return
	end

	if Var["MapIndex"] == nil
	then
		ErrorLog( "SoccerBall_Manager : Var nil" )
		return
	end

	if Var["CurSec"] == nil
	then
		ErrorLog( "SoccerBall_Manager : CurSec nil" )
		return
	end

	if Var["Kicker"] == nil
	then
		ErrorLog( "SoccerBall_Manager : Var[\"Kicker\"] nil" )
		return
	end

	local TeamInfo = Var["Team"]
	if TeamInfo == nil
	then
		ErrorLog( "SoccerBall_Manager : TeamInfo nil" )
		return
	end

	local PlayerList = Var["Player"]
	if PlayerList == nil
	then
		ErrorLog( "SoccerBall_Manager : PlayerList nil" )
		return
	end


	local SoccerBallManagerInfo = Var["SoccerBallManager"]
	if Var["SoccerBallManager"] == nil
	then
		Var["SoccerBallManager"]	= {}
		SoccerBallManagerInfo		= Var["SoccerBallManager"]

		SoccerBallManagerInfo["Step"]		= SoccerBallManagerStep["KickOff"]
		SoccerBallManagerInfo["WaitTime"]	= 0
		SoccerBallManagerInfo["TeamType"]	= KQ_TEAM["MAX"]
		SoccerBallManagerInfo["BallLoc_X"]	= 0
		SoccerBallManagerInfo["BallLoc_Y"]	= 0
		SoccerBallManagerInfo["NextStep"]	= SoccerBallManagerStep["AreaCheck"]
	end



	--------------------------------------------------------------------------
	-- 1. 대기
	if SoccerBallManagerInfo["Step"] == SoccerBallManagerStep["Wait"]
	then

		if SoccerBallManagerInfo["WaitTime"] <= Var["CurSec"]
		then
			SoccerBallManagerInfo["Step"]		= SoccerBallManagerInfo["NextStep"]
			SoccerBallManagerInfo["WaitTime"]	= 0
			SoccerBallManagerInfo["NextStep"]	= SoccerBallManagerStep["Wait"]
		end


	--------------------------------------------------------------------------
	-- 2. 킥 오프
	elseif SoccerBallManagerInfo["Step"] == SoccerBallManagerStep["KickOff"]
	then

		cScriptMsg( Var["MapIndex"], Var["Referee"]["Handle"], Referee_Chat["KickOff"] )
		cEffectMsg_AllInMap( Var["MapIndex"], EFFECT_MSG_TYPE["EMT_SOCCER_KICK_OFF"] )
		cDoorAction( Var["InvisibleDoor"], InvisibleDoor["BlockName"], "open" )

		SoccerBallManagerInfo["Step"]		= SoccerBallManagerStep["AreaCheck"]
		SoccerBallManagerInfo["WaitTime"]	= 0
		SoccerBallManagerInfo["TeamType"]	= KQ_TEAM["MAX"]
		SoccerBallManagerInfo["BallLoc_X"]	= 0
		SoccerBallManagerInfo["BallLoc_Y"]	= 0
		SoccerBallManagerInfo["NextStep"]	= SoccerBallManagerStep["Wait"]


	--------------------------------------------------------------------------
	-- 3. 공이 있는 위치 확인
	elseif SoccerBallManagerInfo["Step"] == SoccerBallManagerStep["AreaCheck"]
	then
		if Var["SoccerBall"] == nil
		then
			return
		end

		-- 필드에 공이 존재하면, 확인할 것이 없다
		if cIsInArea( Var["SoccerBall"], Var["MapIndex"], AreaInfo["TouchLine"]["AreaName"] ) == true
		then
			return
		end


		local GoalInInfo = AreaInfo["GoalIn"]
		local KickerInfo = Var["Kicker"]


		-- 골인 영역 확인
		for i = 1, #GoalInInfo
		do
			if cIsInArea( Var["SoccerBall"], Var["MapIndex"], GoalInInfo[ i ]["AreaName"] ) == true
			then
				local GoalLineTeam = GoalInInfo[ i ]["Team"]
				local OpposingTeam = OpposingTeamInfo[ GoalLineTeam ]


				-- 메시지 처리
				if KickerInfo["IsPlayer"] == false or KickerInfo["TeamType"] == GoalLineTeam
				then
					cScriptMsg( Var["MapIndex"], nil, NoticeInfo["NPCGoal"][ OpposingTeam ] )

					if Var["Referee"]["Handle"] == KickerInfo["NPCHandle"]
					then
						cScriptMsg( Var["MapIndex"], Var["Referee"]["Handle"], Referee_Chat["NPCGoal"][ OpposingTeam ] )
					end
				else

					local KickPlayerInfo = Player_Get( Var, KickerInfo["CharNo"] )
					if KickPlayerInfo ~= nil
					then
						cScriptMsg( Var["MapIndex"], nil, NoticeInfo["PlayerGoal"][ OpposingTeam ], KickPlayerInfo["CharID"] )
						cScriptMsg( Var["MapIndex"], Var["Referee"]["Handle"], Referee_Chat["PlayerGoal"][ OpposingTeam ], KickPlayerInfo["CharID"] )

						KickPlayerInfo["Goal"] = KickPlayerInfo["Goal"] + 1
					end
				end


				-- 점수 처리
				TeamInfo[ OpposingTeam ] = TeamInfo[ OpposingTeam ] + 1
--				cScoreInfo_AllInMap( Var["MapIndex"], KQ_TEAM["MAX"], TeamInfo[ KQ_TEAM["RED"] ], TeamInfo[ KQ_TEAM["BLUE"] ] )
				cWinter_Event_ScoreBoard_AllInMap( Var["MapIndex"], TeamInfo[ KQ_TEAM["RED"] ], TeamInfo[ KQ_TEAM["BLUE"] ] )


				-- 골 연출
				cAnimate( Var["SoccerBall"], "start", SoccerBall["GoalAni"] )


				SoccerBallManagerInfo["Step"]		= SoccerBallManagerStep["Wait"]
				SoccerBallManagerInfo["WaitTime"]	= Var["CurSec"] + DelayTime["GoalInWait"]
				SoccerBallManagerInfo["TeamType"]	= OpposingTeam
				SoccerBallManagerInfo["BallLoc_X"]	= 0
				SoccerBallManagerInfo["BallLoc_Y"]	= 0
				SoccerBallManagerInfo["NextStep"]	= SoccerBallManagerStep["GoalEvent_Start"]
				return
			end
		end


		-- 라인 아웃
		if KickerInfo["IsPlayer"] == true
		then
			local OpposingTeam = OpposingTeamInfo[ KickerInfo["TeamType"] ]

			cScriptMsg( Var["MapIndex"], Var["Referee"]["Handle"], Referee_Chat["PlayerLineOut"][ OpposingTeam ] )
		else
			cScriptMsg( Var["MapIndex"], Var["Referee"]["Handle"], Referee_Chat["NPCLineOut"] )
		end


		SoccerBallManagerInfo["Step"]		= SoccerBallManagerStep["Wait"]
		SoccerBallManagerInfo["WaitTime"]	= Var["CurSec"] + DelayTime["LineOutWait__DelBall"]
		SoccerBallManagerInfo["TeamType"]	= KickerInfo["TeamType"];
		SoccerBallManagerInfo["BallLoc_X"], SoccerBallManagerInfo["BallLoc_Y"] = cObjectLocate( Var["SoccerBall"] )
		SoccerBallManagerInfo["NextStep"]	= SoccerBallManagerStep["LineOut_DelBall"]

	--------------------------------------------------------------------------
	-- 4. 라인 아웃 이벤트 - 공삭제
	elseif SoccerBallManagerInfo["Step"] == SoccerBallManagerStep["LineOut_DelBall"]
	then
		if Var["SoccerBall"] == nil
		then
			return
		end

		cNPCVanish( Var["SoccerBall"] )
		Var["SoccerBall"] = nil

		SoccerBallManagerInfo["Step"]		= SoccerBallManagerStep["Wait"]
		SoccerBallManagerInfo["WaitTime"]	= Var["CurSec"] + DelayTime["LineOutWait"]
		SoccerBallManagerInfo["NextStep"]	= SoccerBallManagerStep["LineOut"]

	--------------------------------------------------------------------------
	-- 5. 라인 아웃 이벤트
	elseif SoccerBallManagerInfo["Step"] == SoccerBallManagerStep["LineOut"]
	then

		local Regen_X, Regen_Y

		-- 팀 별로 상황에 맞게 처리
		local OpposingTeam = OpposingTeamInfo[ SoccerBallManagerInfo["TeamType"] ]

		if OpposingTeam ~= nil
		then
			local LastDist


			for i = 1, #PlayerList
			do
				local PlayerInfo = PlayerList[ i ]

				if	PlayerInfo["IsInMap"]  == true and																	-- 접속 중인 플레이어
					PlayerInfo["TeamType"] == OpposingTeam and															-- 팀
				    cIsInArea( PlayerInfo["Handle"], Var["MapIndex"], AreaInfo["TouchLine"]["AreaName"] ) == true and	-- 위치 확인
					cIsInArea( PlayerInfo["Handle"], Var["MapIndex"], AreaInfo["PenaltyBox"][1] ) == false and			-- 위치 확인
					cIsInArea( PlayerInfo["Handle"], Var["MapIndex"], AreaInfo["PenaltyBox"][2] ) == false				-- 위치 확인
				then

					local PlayX, PlayY	= cObjectLocate( PlayerInfo["Handle"] )

					if PlayX ~= nil and PlayY ~= nil
					then

						local Dist = cDistanceSquar( PlayX, PlayY, SoccerBallManagerInfo["BallLoc_X"], SoccerBallManagerInfo["BallLoc_Y"] )
						if Dist <= (AreaInfo["TouchLine"]["Dist"] * AreaInfo["TouchLine"]["Dist"])
						then
							if LastDist == nil
							then
								LastDist	 = Dist
								Regen_X		 = PlayX
								Regen_Y		 = PlayY
							elseif Dist < LastDist
							then
								LastDist	 = Dist
								Regen_X		 = PlayX
								Regen_Y		 = PlayY
							end
						end
					end
				end
			end
		end

		if Regen_X == nil or Regen_Y == nil
		then
			Regen_X = RegenInfo["SoccerBall"]["X"];
			Regen_Y = RegenInfo["SoccerBall"]["Y"];
		end

		--cCastTeleport( Var["SoccerBall"], "SpecificCoord", Regen_X, Regen_Y )
		SoccerBall_Regen( Var, Regen_X, Regen_Y, 0 )

		SoccerBallManagerInfo["Step"]		= SoccerBallManagerStep["AreaCheck"]
		SoccerBallManagerInfo["WaitTime"]	= 0
		SoccerBallManagerInfo["TeamType"]	= KQ_TEAM["MAX"]
		SoccerBallManagerInfo["BallLoc_X"]	= 0
		SoccerBallManagerInfo["BallLoc_Y"]	= 0
		SoccerBallManagerInfo["NextStep"]	= SoccerBallManagerStep["Wait"]

	--------------------------------------------------------------------------
	-- 6. 골 이벤트 - 시작
	elseif SoccerBallManagerInfo["Step"] == SoccerBallManagerStep["GoalEvent_Start"]
	then
		if Var["SoccerBall"] == nil
		then
			return
		end


		local GoalInInfo = AreaInfo["GoalIn"]

		-- 골 연출
		cAnimate(  Var["SoccerBall"], "stop" )
		--cCameraMove( Var["MapIndex"], GoalInInfo["CameraMove"]["X"], GoalInInfo["CameraMove"]["Y"], GoalInInfo["CameraMove"]["AngleXZ"], GoalInInfo["CameraMove"]["AngleY"], GoalInInfo["CameraMove"]["Dist"], 1 )
		cEffectMsg_AllInMap( Var["MapIndex"], EFFECT_MSG_TYPE["EMT_SOCCER_GOAL"] )

		for j = 1, #PlayerList
		do
			local PlayerInfo = PlayerList[ j ]
			if PlayerInfo["IsInMap"] == true
			then

				cSetAbstate( PlayerInfo["Handle"], GoalInInfo["CameraMove"]["Stun"], 1, (DelayTime["GoalEventWait"] * 1000) )

				if PlayerInfo["TeamType"] == SoccerBallManagerInfo["TeamType"]
				then
					cEmotion( PlayerInfo["Handle"], GoalInInfo["Emotion"]["Score"] )
				else
					cEmotion( PlayerInfo["Handle"], GoalInInfo["Emotion"]["LoseAScore"] )
				end
			end
		end


		-- 필드 중앙에 공 소환
		cCastTeleport( Var["Referee"]["Handle"], "SpecificCoord", RegenInfo["Referee"]["X"], RegenInfo["Referee"]["Y"] )
		--cCastTeleport( Var["SoccerBall"], "SpecificCoord", RegenInfo["SoccerBall"]["X"], RegenInfo["SoccerBall"]["Y"] )
		SoccerBall_Regen( Var, RegenInfo["SoccerBall"]["X"], RegenInfo["SoccerBall"]["Y"], 0 )
		cDoorAction( Var["InvisibleDoor"], InvisibleDoor["BlockName"], "close" )


		SoccerBallManagerInfo["Step"]		= SoccerBallManagerStep["Wait"]
		SoccerBallManagerInfo["WaitTime"]	= Var["CurSec"] + DelayTime["GoalEventWait"]
		SoccerBallManagerInfo["NextStep"]	= SoccerBallManagerStep["GoalEvent_End"]

	--------------------------------------------------------------------------
	-- 7. 골 이벤트 - 끝
	elseif SoccerBallManagerInfo["Step"] == SoccerBallManagerStep["GoalEvent_End"]
	then
		--cCameraMove( Var["MapIndex"], 0, 0, 0, 0, 0, 0 )

		for i = 1, #PlayerList
		do
			local PlayerInfo	= PlayerList[ i ]
			local RegenLocInfo	= TeamRegenLocation[ PlayerInfo["TeamType"] ]

			if PlayerInfo["IsInMap"] == true and RegenLocInfo ~= nil
			then
				if PlayerInfo["TeamType"] == SoccerBallManagerInfo["TeamType"]
				then
					cCastTeleport( PlayerInfo["Handle"], "SpecificCoord", RegenLocInfo[ 2 ]["X"], RegenLocInfo[ 2 ]["Y"] )
				else
					cCastTeleport( PlayerInfo["Handle"], "SpecificCoord", RegenLocInfo[ 1 ]["X"], RegenLocInfo[ 1 ]["Y"] )
				end
			end
		end


		SoccerBallManagerInfo["Step"]		= SoccerBallManagerStep["KickOff"]
		SoccerBallManagerInfo["WaitTime"]	= 0
		SoccerBallManagerInfo["TeamType"]	= KQ_TEAM["MAX"]
		SoccerBallManagerInfo["BallLoc_X"]	= 0
		SoccerBallManagerInfo["BallLoc_Y"]	= 0
		SoccerBallManagerInfo["NextStep"]	= SoccerBallManagerStep["Wait"]
	end

end



----------------------------------------------------------------------
-- BuffBox Function
----------------------------------------------------------------------
function BuffBox_Manager( Var )
cExecCheck( "BuffBox_Manager" )


	if Var == nil
	then
		ErrorLog( "BuffBox_Manager : Var nil" )
		return
	end

	if Var["BuffBox"] == nil
	then
		ErrorLog( "BuffBox_Manager : Var[\"BuffBox\"] nil" )
		return
	end


	local RegenBuffBox = RegenInfo["BuffBox"]


	for i = 1, RegenBuffBox["RegenNum"]
	do
		if Var["BuffBox"][ i ] == nil
		then
			Var["BuffBox"][ i ] = Var["CurSec"] + cRandom( RegenBuffBox["RegenInterval"]["Min"], RegenBuffBox["RegenInterval"]["Max"] )

		elseif Var["BuffBox"][ i ] <= Var["CurSec"]
		then
			local MobSelect     = cRandom( 1, #RegenBuffBox )
			local BoxHandle

			BoxHandle = cMobRegen_Rectangle( Var["MapIndex"], RegenBuffBox[ MobSelect ]["Index"], RegenBuffBox["Location"]["X"], RegenBuffBox["Location"]["Y"], RegenBuffBox["Location"]["Width"], RegenBuffBox["Location"]["Height"], RegenBuffBox["Location"]["Rotate"] )
			if BoxHandle ~= nil
			then
				cSetAIScript ( MainLuaScriptPath, BoxHandle )
				cAIScriptFunc( BoxHandle, "Entrance",  "DummyRoutineFunc" )
				cAIScriptFunc( BoxHandle, "NPCAction", RegenBuffBox[ MobSelect ]["NPCAction"] )
			end

			Var["BuffBox"][ i ] = Var["CurSec"] + cRandom( RegenBuffBox["RegenInterval"]["Min"], RegenBuffBox["RegenInterval"]["Max"] )
		end

		-- 다음 소환 시간 설정

	end

end



----------------------------------------------------------------------
-- Log Functions
----------------------------------------------------------------------
function GoToFail( Var, Msg )
cExecCheck( "GoToFail" )


	if Var == nil
	then
		ErrorLog( "BuffBox_KnockBack : Var nil" );
		return
	end


	ErrorLog( Msg )


	-- 모든 객체 삭제
	if Var["InvisibleDoor"]  ~= nil
	then
		cNPCVanish( Var["InvisibleDoor"] )
	end

	if Var["SoccerBall"] ~= nil
	then
		cNPCVanish( Var["SoccerBall"] )
	end

	if Var["Referee"] ~= nil
	then
		cNPCVanish( Var["Referee"]["Handle"] )
	end

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

	for i = 1, #RegenInfo["BuffBox"]
	do
		cVanishAll( Var["MapIndex"], RegenInfo["BuffBox"][ i ]["Index"] )
	end

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


	Var["StepFunc"] = ReturnToHome
end





----------------------------------------------------------------------
-- Log Functions
----------------------------------------------------------------------
function DebugLog( String )

	if String == nil
	then
		cAssertLog( "DebugLog::String == nil" )
		return
	end

	cAssertLog( "Debug - "..String )

end


function ErrorLog( String )

	if String == nil
	then
		cAssertLog( "ErrorLog::String == nil" )
		return
	end

	cAssertLog( "Error - "..String )

end
