--------------------------------------------------------------------------------
--                             Routine                                 --
--------------------------------------------------------------------------------



function DummyRoutineFunc()
cExecCheck "DummyRoutineFunc"

	return ReturnAI["END"]
end


----------------------------------------------------------------------
-- MapLogin Function
----------------------------------------------------------------------
function PlayerMapLogin( MapIndex, Handle )
cExecCheck "PlayerMapLogin"


	local CurSec	= cCurrentSecond()
	local TeamType	= cGetKQTeamType( Handle )
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


	-- 팀 유니폼 착용
	for i = 1, #TeamUniform[ TeamType ]
	do
		cViewSlotEquip( Handle, TeamUniform[ TeamType ][ i ] )
		cSetAbstate( Handle, TeamAbstate[ TeamType ]["Index"], TeamAbstate[ TeamType ]["Str"], TeamAbstate[ TeamType ]["KeepTime"], Handle )
	end


	-- 이동 속도 고정
	cStaticWalkSpeed( Handle, true, 33 )
	cStaticRunSpeed( Handle, true, 127 )


	-- 라운드 진행 중이 아니면 함수 종료
	if Var["RoundEndTime"] <= 0
	then
		return
	end

	-- 점수, 타이머 정보 전송
	local RedTeamInfo	= Var["Team"][ KQ_TEAM["RED"] ]
	local BlueTeamInfo	= Var["Team"][ KQ_TEAM["BLUE"] ]


	-- 라운드 진행 중, 플레이어 정보가 있으면
	if PlayerInfo ~= nil
	then
		if PlayerInfo["IsOut"] == false
		then
			Var["Team"][ TeamType ]["Score"] = Var["Team"][ TeamType ]["Score"] + 1
		end
	end


	-- 점수, 시간 정보 알림
	cScoreBoard( Handle, true, Var["Round"], RedTeamInfo["RoundResultCount"]["Win"], RedTeamInfo["Score"], BlueTeamInfo["RoundResultCount"]["Win"], BlueTeamInfo["Score"] )
	cTimer_Obj( Handle, (Var["RoundEndTime"] - CurSec) )

end


----------------------------------------------------------------------
-- ServantSummon Function
----------------------------------------------------------------------
function ServantSummon( MapIndex, ServantHandle, ServantIndex, MasterHandle )
cExecCheck "ServantSummon"


	if ServantIndex == WaterBalloon["MobIndex"]
	then

		cSetAIScript ( MainLuaScriptPath, ServantHandle )
		cAIScriptFunc( ServantHandle, "Entrance",  "WaterBallon_Entrance" )
		cAIScriptFunc( ServantHandle, "NPCAction", "WaterBallon_NPCAction" )

	elseif ServantIndex == WaterCannon["MobIndex"]
	then

		cSetAIScript ( MainLuaScriptPath, ServantHandle )
		cAIScriptFunc( ServantHandle, "Entrance",  "WaterCannon_Entrance" )

	end

end


----------------------------------------------------------------------
-- WaterBallon_Explosion Function
----------------------------------------------------------------------
function WaterBallon_Explosion( Var, NPCHandle )
cExecCheck "WaterBallon_Explosion"


	local CurSec = cCurrentSecond()
	local TeamType	= cGetKQTeamType( NPCHandle )


	if Var == nil
	then
		ErrorLog( "WaterBallon_Explosion : Var nil" )
		return
	end

	if NPCHandle == nil
	then
		ErrorLog( "WaterBallon_Explosion : Var nil" )
		return
	end

	if CurSec == nil
	then
		ErrorLog( "WaterBallon_Explosion : CurSec nil" )
		return
	end

	if TeamType == nil
	then
		ErrorLog( "WaterBallon_Explosion : TeamType nil" )
		return
	end

	if TeamType ~= KQ_TEAM["RED"] and TeamType ~= KQ_TEAM["BLUE"]
	then
		ErrorLog( "WaterBallon_Explosion : Invalid TeamType "..TeamType )
		return
	end


	-- 라운드 시작 전이면 아무 처리도 하지 않는다
	if Var["RoundEndTime"] > 0
	then

		-- 플레이어 리스트에서 적의 거리를 확인
		local PlayerList = Var["Player"]
		if PlayerList == nil
		then
			ErrorLog( "WaterBallon_Explosion : PlayerList nil" )
			return
		end


		for i = 1, #PlayerList
		do
			local PlayerInfo = PlayerList[ i ]


			-- 대상 조건 확인
			if PlayerInfo["IsInMap"]  == true and																	-- 맵에 존재하는지
			   PlayerInfo["TeamType"] == OpposingTeamInfo[ TeamType ] and											-- 적 팀인지
			   PlayerInfo["PrisonLinkToWaitTime"] == 0 and															-- 감옥에 들어갈 예정인지
			   PlayerInfo["IsOut"] == false and																		-- 감옥에 밖에 있는지
			   cDistanceSquar( NPCHandle, PlayerInfo["Handle"] ) <= (WaterBalloon["Dist"] * WaterBalloon["Dist"])	-- 범위 안에 존재하는지
			then

				local Player_x, Player_y = cObjectLocate( PlayerInfo["Handle"] )

				if Player_x ~= nil and Player_y ~= nil
				then

					if cFindAttackBlockLocate( NPCHandle, Player_x, Player_y ) == true	-- 어택 블럭 확인
					then

						PlayerInfo["BalloonHandle"]			= NPCHandle
						PlayerInfo["BalloonAbstateTime"]	= CurSec + WaterBalloon["SetAbstateWait"]
						PlayerInfo["PrisonLinkToWaitTime"]	= CurSec + WaterBalloon["LinktoWait"]
					end
				end
			end
		end

	end


	cSkillBlast( NPCHandle, NPCHandle, WaterBalloon["SkillIndex"] )
	cVanishReserv( NPCHandle, 3 )

end


----------------------------------------------------------------------
-- WaterBallon_Entrance Function
----------------------------------------------------------------------
function WaterBallon_Entrance( Handle, MapIndex )
cExecCheck "WaterBallon_Entrance"


	-- 죽었으면 스크립트 해제
	if cIsObjectDead( Handle ) ~= nil
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- 죽음 대기면 스크립트 해제
	if cIsObjectAlreadyDead( Handle ) == true
	then
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end


	-- 이동이 멈추었으면 폭발
	if cGetMoveState( Handle ) ~= 0
	then
		return ReturnAI["CPP"]
	end


	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		ErrorLog( "WaterCannon_Entrance : Var nil" )
		return ReturnAI["END"]
	end


	WaterBallon_Explosion( Var, Handle )


	return ReturnAI["END"]
end


----------------------------------------------------------------------
-- WaterBallon_NPCAction Function
----------------------------------------------------------------------
function WaterBallon_NPCAction( MapIndex, NPCHandle, PlyHandle, PlyCharNo )
cExecCheck "WaterBallon_NPCAction"


	local TeamType		= cGetKQTeamType( NPCHandle )
	local Var			= InstanceField[ MapIndex ]
	local MasterHandle	= cGetMaster( NPCHandle )

	if Var == nil
	then
		ErrorLog( "WaterBallon_NPCAction : Var nil" )
		return
	end

	if TeamType == nil
	then
		ErrorLog( "WaterBallon_NPCAction : TeamType nil" )
		return
	end

	if TeamType ~= KQ_TEAM["RED"] and TeamType ~= KQ_TEAM["BLUE"]
	then
		ErrorLog( "WaterBallon_NPCAction : Invalid TeamType "..TeamType )
		return
	end

	-- 소환수 마스터 확인
	if MasterHandle == PlyHandle
	then
		return
	end


	-- NPC이동 정지
	cMoveStop( NPCHandle )

	-- 폭발
	WaterBallon_Explosion( Var, NPCHandle )

end


----------------------------------------------------------------------
-- WaterCannon_Entrance Function
----------------------------------------------------------------------
function WaterCannon_Entrance( Handle, MapIndex )
cExecCheck "WaterCannon_Entrance"

	local CurSec	= cCurrentSecond()
	local TeamType	= cGetKQTeamType( Handle )
	local Var		= InstanceField[ MapIndex ]


	if Var == nil
	then
		ErrorLog( "WaterCannon_Entrance : Var nil" )
		return
	end

	-- 라운드 시작 전이면 아무 처리도 하지 않는다.
	if Var["RoundEndTime"] <= 0
	then
		return
	end


	if CurSec == nil
	then
		ErrorLog( "WaterCannon_Entrance : CurSec nil" )
		return
	end

	if TeamType == nil
	then
		ErrorLog( "WaterCannon_Entrance : TeamType nil" )
		return
	end

	if TeamType ~= KQ_TEAM["RED"] and TeamType ~= KQ_TEAM["BLUE"]
	then
		ErrorLog( "WaterCannon_Entrance : Invalid TeamType "..TeamType )
		return
	end


	-- 플레이어 리스트에서 적의 거리를 확인
	local PlayerList = Var["Player"]
	if PlayerList == nil
	then
		ErrorLog( "WaterCannon_Entrance : PlayerList nil" )
		return false
	end

	for i = 1, #PlayerList
	do
		local PlayerInfo = PlayerList[ i ]

		-- 대상 조건 확인
		if PlayerInfo["IsInMap"]  == true and																-- 맵에 존재하는지
		   PlayerInfo["TeamType"] == OpposingTeamInfo[ TeamType ] and										-- 적 팀인지
		   PlayerInfo["PrisonLinkToWaitTime"] == 0 and														-- 감옥에 들어갈 예정인지
		   PlayerInfo["IsOut"] == false and																	-- 감옥에 밖에 있는지
		   cDistanceSquar( Handle, PlayerInfo["Handle"] ) <= (WaterCannon["Dist"] * WaterCannon["Dist"])	-- 범위 안에 있는지
		then

			local Player_x, Player_y = cObjectLocate( PlayerInfo["Handle"] )

			if Player_x ~= nil and Player_y ~= nil
			then

				if cFindAttackBlockLocate( Handle, Player_x, Player_y ) == true	-- 어택 블럭 확인
				then

					cSetAbstate( PlayerInfo["Handle"], WaterCannon["Abstate"]["Index"], 1, WaterCannon["Abstate"]["KeepTime"], Handle )
					PlayerInfo["PrisonLinkToWaitTime"] = CurSec + WaterCannon["LinktoWait"]
				end
			end
		end
	end


	cNPCVanish( Handle )


	return ReturnAI["END"]
end
