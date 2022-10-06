--------------------------------------------------------------------------------
--                             Routine                                 --
--------------------------------------------------------------------------------



function DummyRoutineFunc( )
cExecCheck "DummyRoutineFunc"
end



----------------------------------------------------------------------
-- MapLogin Function
----------------------------------------------------------------------
function PlayerMapLogin( MapIndex, Handle )
cExecCheck "PlayerMapLogin"


	local CurSec	= cCurrentSecond()
	local TeamType = cGetKQTeamType( Handle )
	local CharNo	= cGetCharNo( Handle )


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "PlayerMapLogin : Var nil" )
		return
	end

	if CurSec == nil
	then
		ErrorLog( "PlayerMapLogin : CurSec nil" )
		return
	end

	if TeamType == nil
	then
		ErrorLog( "PlayerMapLogin : TeamType nil" )
		return
	end

	if TeamType ~= KQ_TEAM["RED"] and TeamType ~= KQ_TEAM["BLUE"]
	then
		ErrorLog( "PlayerMapLogin : Invalid TeamType "..TeamType )
		return
	end

	if CharNo == nil
	then
		ErrorLog( "PlayerMapLogin : CharNo nil" )
		return
	end

	if Var["Team"] == nil
	then
		ErrorLog( "PlayerMapLogin : Var[\"Team\"] nil" )
		return
	end


	-- 접속시 삭제 시켜줄 상태이상
	for i = 1, #LoginResetAbstate
	do
		cResetAbstate( Handle, LoginResetAbstate[ i ] )
	end


	-- 플레이어 정보 추가, 갱신
	local PlayerInfo = Player_Get( Var, CharNo )
	if PlayerInfo == nil
	then

		-- 신규 플레이어 정보 추가
		Player_Insert( Var, CharNo, Handle, TeamType )

	else

		-- 기존 플레이어 정보 갱신
		PlayerInfo["Handle"] 	= Handle
		PlayerInfo["IsInMap"] 	= true

	end


--[[
	-- 팀 유니폼 착용
	for i = 1, #TeamUniform[ TeamType ]
	do
		cViewSlotEquip( Handle, TeamUniform[ TeamType ][ i ] )
	end
--]]

	--변신용 팀 버프를 걸어줌.(number핸들, string상태이상인덱스, number강도, number지속시간밀리초)     리턴:nil[실패]  1[성공]
	cSetAbstate( Handle, LoginSetAbstate[ TeamType ], LoginSetAbstate[ "AbstateStrength" ], LoginSetAbstate[ "AbstateDuration" ] )


	-- 이동 속도 고정
	cStaticWalkSpeed( Handle, true, (Player_WalkSpeed * StaticMoveSpeedRate) )
	cStaticRunSpeed(  Handle, true, (Player_RunSpeed  * StaticMoveSpeedRate) )


	-- 게임이 진행 중이 아니면 함수 종료
	if Var["KQLimitTime"] <= 0
	then
		return
	end

--[[
	-- 점수, 타이머 정보 전송
	cScoreInfo( Handle, KQ_TEAM["MAX"], Var["Team"][ KQ_TEAM["RED"] ], Var["Team"][ KQ_TEAM["BLUE"] ] )
	cTimer_Obj( Handle, (Var["KQLimitTime"] - CurSec) )
--]]

---[[
	-- 점수, 타이머 정보 전송. 물풍선 전쟁에서 사용했던 점수판을 이용함. ( 맵인덱스, 레드팀 점수, 블루팀 점수 )
	cWinter_Event_ScoreBoard_AllInMap( Var["MapIndex"], Var["Team"][ KQ_TEAM["RED"] ], Var["Team"][ KQ_TEAM["BLUE"] ] )
	cTimer_Obj( Handle, (Var["KQLimitTime"] - CurSec) )
--]]

end



----------------------------------------------------------------------
-- Referee Function
----------------------------------------------------------------------
function Referee_Routine( Handle, MapIndex )
cExecCheck( "Referee_Routine" )


	local CurSec = cCurrentSecond()


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Referee_Routine : Var nil" )

		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["SoccerBall"] == nil
	then
		return ReturnAI["END"]
	end

	local RefereeInfo = Var["Referee"]
	if RefereeInfo == nil
	then
		ErrorLog( "Referee_Routine : RefereeInfo nil" )

		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if RefereeInfo["Handle"] ~= Handle
	then
		ErrorLog( "Referee_Routine : Not match handle" )

		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 체크 시간 확인
	if RefereeInfo["RoutineCheckTime"] > CurSec
	then
		return ReturnAI["END"]
	end


	RefereeInfo["RoutineCheckTime"] = CurSec + 0.1


	local Dist = cDistanceSquar( Handle, Var["SoccerBall"] )


	-- 따라가기
	if Dist > (Referee["FollowDist"] * Referee["FollowDist"])
	then
		if RefereeInfo["FollowCheckTime"] <= CurSec
		then
			cFollow( Handle, Var["SoccerBall"], Referee["StopDist"], 2000 )

			RefereeInfo["FollowCheckTime"] = CurSec + 1
		end

	-- 공 차기
	elseif Dist <= (Referee["KickDist"] * Referee["KickDist"])
	then
		SoccerBall_Kick( Var, Var["SoccerBall"], KQ_TEAM["MAX"], Handle, nil, false )
	end


	return ReturnAI["END"]

end



----------------------------------------------------------------------
-- Keeper Function
----------------------------------------------------------------------
function Keeper_Routine( Handle, MapIndex )
cExecCheck( "Keeper_Routine" )


	local CurSec = cCurrentSecond()


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Keeper_Routine : Var nil" )

		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Keeper"] == nil
	then
		ErrorLog( "Keeper_Routine : Var[\"Keeper\"] nil" )

		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local KeeperInfo
	for i = 1, #Var["Keeper"]
	do
		if Var["Keeper"][ i ]["Handle"] == Handle
		then
			KeeperInfo = Var["Keeper"][ i ]
			break
		end
	end

	if KeeperInfo == nil
	then
		ErrorLog( "Keeper_Routine : KeeperInfo nil" )

		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 체크 시간 확인
	if KeeperInfo["RoutineCheckTime"] > CurSec
	then
		return ReturnAI["END"]
	end


	KeeperInfo["RoutineCheckTime"] = CurSec + 0.1


	if Var["SoccerBall"] ~= nil
	then
		-- 공 차기
		local Dist = cDistanceSquar( Handle, Var["SoccerBall"] )
		if Dist <= (GoalKeeper["KickDist"] * GoalKeeper["KickDist"])
		then
			SoccerBall_Kick( Var, Var["SoccerBall"], KQ_TEAM["MAX"], Handle, nil, false )
		end
	end

	-- 로밍
	local MoveStep			= KeeperInfo["MoveStep"]
	local MoveInfo			= GoalKeeper[ KeeperInfo["TeamType"] ]
	local MaxMovePattern	= #MoveInfo

	local KeeperX, KeeperY	= cObjectLocate( Handle )
	if KeeperX == nil or KeeperY == nil
	then
		return
	end

	local LocDist = cDistanceSquar( MoveInfo[ MoveStep ]["X"], MoveInfo[ MoveStep ]["Y"], KeeperX, KeeperY )
	if LocDist == nil
	then
		return
	end


	if LocDist < (GoalKeeper["LocCheckDist"] * GoalKeeper["LocCheckDist"])
	then
		-- 이동 단계 계산
		if KeeperInfo["MoveBack"] == false
		then
			MoveStep = MoveStep + 1

			if MoveStep > MaxMovePattern
			then
				MoveStep 				= MaxMovePattern - 1
				KeeperInfo["MoveBack"]	= true
			end
		else
			MoveStep = MoveStep - 1

			if MoveStep < 1
			then
				MoveStep 				= 2
				KeeperInfo["MoveBack"]	= false
			end
		end

		cRunTo( Handle, MoveInfo[ MoveStep ]["X"], MoveInfo[ MoveStep ]["Y"], 1000 )

		KeeperInfo["MoveStep"] = MoveStep
	else
		if cGetMoveState( Handle ) == 0
		then
			cRunTo( Handle, MoveInfo[ MoveStep ]["X"], MoveInfo[ MoveStep ]["Y"], 1000 )
		end
	end

	return ReturnAI["END"]

end



----------------------------------------------------------------------
-- SoccerBall Function
----------------------------------------------------------------------
function SoccerBall_NPCAction( MapIndex, NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "SoccerBall_NPCAction" )


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "SoccerBall_NPCAction : Var nil" )

		cNPCVanish( Handle )
		return
	end

	if Var["SoccerBall"] ~= NPCHandle
	then
		ErrorLog( "SoccerBall_NPCAction : Not match handle" )

		cNPCVanish( Handle )
		return
	end


	local PlayerInfo = Player_Get( Var, PlyCharNo )
	if PlayerInfo == nil
	then
		return
	end


	SoccerBall_Kick( Var, Var["SoccerBall"], PlayerInfo["TeamType"], PlyHandle, PlyCharNo, true )
end



----------------------------------------------------------------------
-- KDSoccer_SpeedUp Function
----------------------------------------------------------------------
function SpeedUp_NPCAction( MapIndex, NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "SpeedUp_NPCAction" )


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "SpeedUp_NPCAction : Var nil" )

		cNPCVanish( Handle )
		return
	end


	local PlayerInfo = Player_Get( Var, PlyCharNo )
	if PlayerInfo == nil
	then
		return
	end


	if PlayerInfo["SpeedUpBuff"] == nil
	then
		PlayerInfo["SpeedUpBuff"] = {}

		cStaticWalkSpeed( PlyHandle, true, (Player_WalkSpeed * (StaticMoveSpeedRate + SpeedUpBox["MoveSpeed"])) )
		cStaticRunSpeed(  PlyHandle, true, (Player_RunSpeed  * (StaticMoveSpeedRate + SpeedUpBox["MoveSpeed"])) )
	else
		cResetAbstate( PlyHandle, SpeedUpBox["AbsIndex"] )
	end

	PlayerInfo["SpeedUpBuff"]["KeepTime"] = cCurrentSecond() + SpeedUpBox["KeepTime"]

	cSetAbstate( PlyHandle, SpeedUpBox["AbsIndex"], SpeedUpBox["AbsStr"], SpeedUpBox["KeepTime"] * 1000 )

end



----------------------------------------------------------------------
-- KDSoccer_Invincible Function
----------------------------------------------------------------------
function Invincible_NPCAction( MapIndex, NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "Invincible_NPCAction" )


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "Invincible_NPCAction : Var nil" )

		cNPCVanish( Handle )
		return
	end


	local PlayerInfo = Player_Get( Var, PlyCharNo )
	if PlayerInfo == nil
	then
		return
	end


	local CuSec = cCurrentSecond()


	if PlayerInfo["InvincibleBuff"] == nil
	then
		PlayerInfo["InvincibleBuff"] = {}
	else
		cResetAbstate( PlyHandle, InvincibleBox["AbsIndex"] )
	end

	PlayerInfo["InvincibleBuff"]["KeepTime"] = CuSec + InvincibleBox["KeepTime"]
	PlayerInfo["InvincibleBuff"]["TickTime"] = CuSec + InvincibleBox["TickTime"]

	cSetAbstate( PlyHandle, InvincibleBox["AbsIndex"], InvincibleBox["AbsStr"], InvincibleBox["KeepTime"] * 1000 )

end



----------------------------------------------------------------------
-- InvisibleMonster Function
----------------------------------------------------------------------
function InvisibleMonster_Routine( Handle, MapIndex )
cExecCheck( "InvisibleMonster_Routine" )


	local Var = InstanceField[ MapIndex ]
	if Var == nil
	then
		ErrorLog( "InvisibleMonster_Routine : Var nil" )

		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var[ "InvisibleMonster" ] == nil
	then
		ErrorLog( "InvisibleMonster_Routine : Var[\"InvisibleMonster\"] nil" )

		cNPCVanish( Handle )
		return ReturnAI["END"]
	end



	local InvisibleMonsterInfo = nil
	for i = 1, #Var[ "InvisibleMonster" ]
	do
		if Var[ "InvisibleMonster" ][ i ][ "Handle" ] == Handle
		then
			InvisibleMonsterInfo = Var[ "InvisibleMonster" ][ i ]
			break
		end
	end

	if InvisibleMonsterInfo == nil
	then
		ErrorLog( "InvisibleMonster_Routine : InvisibleMonsterInfo nil" )

		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local CurSec = cCurrentSecond()

	-- 체크 시간 확인
	if InvisibleMonsterInfo[ "RoutineCheckTime" ] > CurSec
	then
		return ReturnAI["END"]
	end


	InvisibleMonsterInfo[ "RoutineCheckTime" ] = CurSec + 0.1



	-- 주변 유저 캐릭터 거리가 충분히 가깝다면 해당 유저를 넉백처리.
	local PlayerList = Var[ "Player" ]
	if PlayerList ~= nil
	then
		for i = 1, #PlayerList
		do
			local TargetPlayerInfo	= PlayerList[ i ]
			local distanceToUser	= cDistanceSquar( TargetPlayerInfo[ "Handle" ], InvisibleMonsterInfo[ "Handle" ] )

			if distanceToUser <= InvisibleMonster[ "Dist" ]
			then
				cSetAbstate(	TargetPlayerInfo[ "Handle" ],
								InvisibleMonster[ "TargetAbs" ][ "Index" ],
								InvisibleMonster[ "TargetAbs" ][ "Str" ],
								InvisibleMonster[ "TargetAbs" ][ "KeepTime" ],
								InvisibleMonster[ "Handle" ]	)
			end
		end
	end


	-- 로밍
	local MoveStep			= InvisibleMonsterInfo[ "MoveStep" ]
	local MoveInfo			= InvisibleMonster[ InvisibleMonsterInfo[ "MonsterNumber" ] ]
	local MaxMovePattern	= #MoveInfo

	local InvisibleMonsterX, InvisibleMonsterY	= cObjectLocate( Handle )
	if InvisibleMonsterX == nil or InvisibleMonsterY == nil
	then
		ErrorLog( "InvisibleMonster_Routine : check cObjectLocate result" )
		return
	end

	local LocDist = cDistanceSquar( MoveInfo[ MoveStep ]["X"], MoveInfo[ MoveStep ]["Y"], InvisibleMonsterX, InvisibleMonsterY )
	if LocDist == nil
	then
		ErrorLog( "InvisibleMonster_Routine : check cDistanceSquar result LocDist" )
		return
	end


	if LocDist < ( InvisibleMonster[ "LocCheckDist" ] * InvisibleMonster[ "LocCheckDist" ] )
	then
		-- 이동 단계 계산
		if InvisibleMonsterInfo[ "MoveBack" ] == false
		then
			MoveStep = MoveStep + 1

			if MoveStep > MaxMovePattern
			then
				MoveStep = MaxMovePattern - 1
				InvisibleMonsterInfo[ "MoveBack" ]	= true
			end
		else
			MoveStep = MoveStep - 1

			if MoveStep < 1
			then
				MoveStep 				= 2
				InvisibleMonsterInfo[ "MoveBack" ]	= false
			end
		end

		--cRunTo(number핸들, numberX, numberY[, number속도천분율])
		cRunTo( Handle, MoveInfo[ MoveStep ]["X"], MoveInfo[ MoveStep ]["Y"], 1000 )

		InvisibleMonsterInfo[ "MoveStep" ] = MoveStep
	else
		if cGetMoveState( Handle ) == 0
		then
			cRunTo( Handle, MoveInfo[ MoveStep ]["X"], MoveInfo[ MoveStep ]["Y"], 1000 )
		end
	end


	return ReturnAI["END"]

end


