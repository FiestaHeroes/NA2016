--------------------------------------------------------------------------------
--                           Arena Progress Func                              --
--------------------------------------------------------------------------------

-- 아레나 초기화
function InitArena( Var )
cExecCheck "InitArena"


	if Var == nil
	then

		return

	end


	local Regen_ArenaGate		= RegenInfo[ "NPC" ][ "ArenaGate" ]
	local Regen_ArenaStone		= RegenInfo[ "NPC" ][ "ArenaStone" ]
	local Regen_ArenaCrystal	= RegenInfo[ "Monster" ][ "ArenaCrystal" ]
	local Regen_ArenaWarrior	= RegenInfo[ "Monster" ][ "AncientArenaWarrior" ]
	local Regen_Handle			= nil


	-- 순간 이동 게이트 생성
	Var[ "ArenaGate" ][ "Count" ] = #Regen_ArenaGate
	for i = 1, Var[ "ArenaGate" ][ "Count" ]
	do

		Regen_Handle = cMobRegen_XY( Var[ "MapIndex" ], Regen_ArenaGate[ i ][ "Index" ], Regen_ArenaGate[ i ][ "X" ], Regen_ArenaGate[ i ][ "Y" ], Regen_ArenaGate[ i ][ "Dir" ] )

		if Regen_Handle ~= nil
		then

			cSetAIScript ( MainLuaScriptPath, Regen_Handle )
			cAIScriptFunc( Regen_Handle, "Entrance", "DummyRoutineFunc" )
			cAIScriptFunc( Regen_Handle, "NPCClick", "ArenaGate_Click" )

			Var[ "ArenaGate" ][ i ] = Regen_Handle
		end
	end


	-- 크리스탈 수호석 생성
	Var[ "ArenaStone" ][ "Count" ] = #Regen_ArenaStone
	for i = 1, Var[ "ArenaStone" ][ "Count" ]
	do

		Regen_Handle = cMobRegen_XY( Var[ "MapIndex" ], Regen_ArenaStone[ i ][ "Index" ], Regen_ArenaStone[ i ][ "X" ], Regen_ArenaStone[ i ][ "Y" ], Regen_ArenaStone[ i ][ "Dir" ] )

		if Regen_Handle ~= nil
		then

			cSetAIScript ( MainLuaScriptPath, Regen_Handle )
			cAIScriptFunc( Regen_Handle, "Entrance", "ArenaStone_Entrance" )

			Var[ "ArenaStone" ][ i ] 								= Regen_Handle
			Var[ "ArenaStone" ][ "SkillUseTime" ][ Regen_Handle ]	= Var[ "CurSec" ] + ArenaStone[ "IntervalTime" ]

		end

	end


	-- 크리스탈 생성
	Regen_Handle = cMobRegen_XY( Var[ "MapIndex" ], Regen_ArenaCrystal[ "Index" ], Regen_ArenaCrystal[ "X" ], Regen_ArenaCrystal[ "Y" ], Regen_ArenaCrystal[ "Dir" ] )
	if Regen_Handle ~= nil
	then

		cSetAbstate( Regen_Handle, ArenaCrystal[ "RegenAbsatate" ][ "Index" ], ArenaCrystal[ "RegenAbsatate" ][ "Str" ], ArenaCrystal[ "RegenAbsatate" ][ "KeepTime" ] )
		cSetAIScript ( MainLuaScriptPath, Regen_Handle )
		cAIScriptFunc( Regen_Handle, "Entrance", "ArenaCrystal_Entrance" )

		Var[ "ArenaCrystal" ][ "Handle" ]		= Regen_Handle
		Var[ "ArenaCrystal" ][ "VanishTime" ]	= nil
		Var[ "ArenaCrystal" ][ "SkillUseTime" ]	= Var[ "CurSec" ] + ArenaCrystal[ "Routine" ][ "BlastTime" ]
	end


	-- 고대 아레나 용사 생성
	Var[ "AncientArenaWarrior" ][ "Count" ] = #Regen_ArenaWarrior
	for i = 1, Var[ "AncientArenaWarrior" ][ "Count" ]
	do

		Var[ "AncientArenaWarrior" ][ i ] 					= {}
		Var[ "AncientArenaWarrior" ][ i ][ "Handle" ]		= cMobRegen_XY( Var[ "MapIndex" ], Regen_ArenaWarrior[ i ][ "Index" ], Regen_ArenaWarrior[ i ][ "X" ], Regen_ArenaWarrior[ i ][ "Y" ], Regen_ArenaWarrior[ i ][ "Dir" ] )
		Var[ "AncientArenaWarrior" ][ i ][ "RegenTime" ]	= nil
	end


	-- 다음 단계 설정
	Var["StepFunc"]	= StartWait

	DebugLog( "End InitArena" )

end


-- 아레나 시작 대기
function StartWait( Var )
cExecCheck "StartWait"


	if Var == nil
	then

		return

	end


	-- 킹덤 퀘스트 시작 전에 플레이어의 첫 로그인을 기다린다.
	if #Var[ "Player" ] < 1
	then

		if Var["InitialSec"] + WAIT_PLAYER_MAP_LOGIN_SEC_MAX <= cCurrentSecond()
		then

			cEndOfKingdomQuest( Var[ "MapIndex" ] )
			return

		end

		return

	end



	-- 스텝 초기화
	if Var[ "StartWait" ] == nil
	then

		DebugLog( "Start StartWait" )

		-- 대기 시간, 다이얼로그 정보 설정
		Var[ "StartWait" ] = {}
		Var[ "StartWait" ][ "WaitTime" ] 	= Var[ "CurSec" ] + DelayTime[ "StartWait" ]
		Var[ "StartWait" ][ "EffectTime" ] 	= Var[ "CurSec" ] + DelayTime[ "BeforeStartEffect" ]
		Var[ "StartWait" ][ "DialogTime" ] 	= Var[ "CurSec" ] + DelayTime[ "BeforeStartDialog" ]
		Var[ "StartWait" ][ "DialogStep" ]	= 1

	end


	-- 시작 이펙트 메시지 출력
	if Var[ "StartWait" ][ "EffectTime" ] ~= nil
	then

		if Var[ "StartWait" ][ "EffectTime" ] <= Var[ "CurSec" ]
		then

			cStartMsg_AllInMap( Var[ "MapIndex" ] )

			Var[ "StartWait" ][ "EffectTime" ] = nil

		end

	end


	-- 다이얼로그 출력
	if Var[ "StartWait" ][ "DialogTime" ] ~= nil
	then

		if Var[ "StartWait" ][ "DialogTime" ] <= Var[ "CurSec" ]
		then

			local DialogStep	= Var[ "StartWait" ][ "DialogStep" ]
			local MaxDialogStep	= #NPCDialogInfo[ "StartWait" ]


			if DialogStep <= MaxDialogStep
			then

				cMobDialog( Var[ "MapIndex" ], NPCDialogInfo[ "StartWait" ][ DialogStep ][ "FaceCut" ], NPCDialogInfo[ "ScriptFileName" ], NPCDialogInfo[ "StartWait" ][ DialogStep ][ "Index" ] )

				Var[ "StartWait" ][ "DialogTime" ]	= Var[ "CurSec" ] + DelayTime[ "BetweenStartDialog" ]
				Var[ "StartWait" ][ "DialogStep" ]	= DialogStep + 1

			end

			if Var[ "StartWait" ][ "DialogStep" ] > MaxDialogStep
			then

				Var[ "StartWait" ][ "DialogTime" ]	= nil
				Var[ "StartWait" ][ "DialogStep" ]	= nil

			end

		end

	end


	-- 다음 단계 진행
	if Var[ "StartWait" ][ "WaitTime" ] <= Var[ "CurSec" ]
	then

		Var["StepFunc"]		= ArenaProcess
		Var[ "StartWait" ] 	= nil

		DebugLog( "End StartWait" )
	end

end


-- 아레나 진행
function ArenaProcess( Var )
cExecCheck "ArenaProcess"


	if Var == nil
	then

		return

	end


	-- 스텝 초기화
	if Var[ "ArenaProcess" ] == nil
	then

		-- 아레나 진행 설정
		Var[ "KQLimitTime" ] = Var[ "CurSec" ] + DelayTime[ "ArenaKeepTime" ]

		cTimer( Var[ "MapIndex" ], DelayTime[ "ArenaKeepTime" ] )
		cScoreInfo_AllInMap( Var[ "MapIndex" ], #TeamNumberList, Var["Team"][ RED_TEAM ][ "Score" ], Var["Team"][ BLUE_TEAM ][ "Score" ] )


		Var[ "ArenaProcess" ] 					= {}
		Var[ "ArenaProcess" ][ "ProcessTime" ]	= Var[ "CurSec" ] + DelayTime[ "ArenaProcessIntervalTime" ]


		-- 깃발 소환
		for i = 1, #TeamNumberList
		do

			local TeamNumber	= TeamNumberList[ i ]
			local Regen_Flag	= RegenInfo[ "NPC" ][ "ArenaFlag" ][ TeamNumber ]

			Var[ "ArenaFlag" ][ TeamNumber ][ "PlayerHandle" ]	= nil
			Var[ "ArenaFlag" ][ TeamNumber ][ "Handle" ]		= nil

			Regen_Handle = cMobRegen_XY( Var[ "MapIndex" ], Regen_Flag[ "Index" ], Regen_Flag[ "X" ], Regen_Flag[ "Y" ], Regen_Flag[ "Dir" ] )

			if Regen_Handle ~= nil
			then

				cSetAIScript ( MainLuaScriptPath, Regen_Handle )
				cAIScriptFunc( Regen_Handle, "Entrance", "ArenaFlag_Entrance" )

				Var[ "ArenaFlag" ][ TeamNumber ][ "Handle" ] 					= Regen_Handle
				Var[ "ArenaFlag" ][ TeamNumber ][ "PlayerHandle" ]				= nil
				Var[ "ArenaFlag" ][ TeamNumber ][ "PlayerTeam" ]				= nil
				Var[ "ArenaFlag" ][ TeamNumber ][ "Drop_LifeTime" ]				= nil
				Var[ "ArenaFlag" ][ TeamNumber ][ "X" ]							= Regen_Flag[ "X" ]
				Var[ "ArenaFlag" ][ TeamNumber ][ "Y" ]							= Regen_Flag[ "Y" ]
				Var[ "ArenaFlag" ][ TeamNumber ][ "GoalConditionNoticeTime" ] 	= nil
				Var[ "ArenaFlag" ][ TeamNumber ][ "Penalty"]					= nil
			end
		end
	end


	ArenaFlag_Manager( Var )


	if Var[ "ArenaProcess" ][ "ProcessTime" ] <= Var[ "CurSec" ]
	then

		ArenaFlagMarking_Manager( Var )
		ArenaMonster_Manager( Var )
		Player_Manager( Var )
	end


	if Var[ "KQLimitTime" ] <= Var[ "CurSec" ]
	then

		------------------------------------------------------------
		-- 모든 오브젝트 삭제
		------------------------------------------------------------
		-- 깃발 삭제
		for i = 1, #TeamNumberList
		do
			cNPCVanish( Var[ "ArenaFlag" ][ TeamNumberList[ i ] ][ "Handle" ] )
		end

		-- 순간 이동 게이트 삭제
		for i = 1, Var[ "ArenaGate" ][ "Count" ]
		do
			cNPCVanish( Var[ "ArenaGate" ][ i ] )
		end

		-- 크리스탈 수호석 삭제
		for i = 1, Var[ "ArenaStone" ][ "Count" ]
		do
			cNPCVanish( Var[ "ArenaStone" ][ i ] )
		end

		-- 크리스탈 삭제
		cNPCVanish( Var[ "ArenaCrystal" ][ "Handle" ] )

		-- 고대 아레나 용사 삭제
		for i = 1, Var[ "AncientArenaWarrior" ][ "Count" ]
		do
			cNPCVanish( Var[ "AncientArenaWarrior" ][ i ] )
		end

		------------------------------------------------------------
		-- 결과 처리
		------------------------------------------------------------
		cTimer( Var[ "MapIndex" ], 0 )

		local Result = {}

		if Var[ "Team" ][ RED_TEAM ][ "Score" ] == Var[ "Team" ][ BLUE_TEAM ][ "Score" ]
		then

			Result[ RED_TEAM ]	= ArenaResult[ "DRAW" ]
			Result[ BLUE_TEAM ]	= ArenaResult[ "DRAW" ]
		elseif Var[ "Team" ][ RED_TEAM ][ "Score" ] < Var[ "Team" ][ BLUE_TEAM ][ "Score" ]
		then

			Result[ RED_TEAM ]	= ArenaResult[ "LOSE" ]
			Result[ BLUE_TEAM ]	= ArenaResult[ "WIN" ]
		else

			Result[ RED_TEAM ]	= ArenaResult[ "WIN" ]
			Result[ BLUE_TEAM ]	= ArenaResult[ "LOSE" ]
		end

		for i = 1, #Var[ "Player" ]
		do

			local TeamNo = Var[ "Player" ][ i ][ "TeamNumber" ]

			if Result[ TeamNo ] ~= nil
			then

				if Result[ TeamNo ][ "EffectMsg" ] ~= nil
				then
					cEffectMsg( Var[ "Player" ][ i ][ "Handle" ], Result[ TeamNo ][ "EffectMsg" ] )
				end

				if Result[ TeamNo ][ "RewardIndex" ] ~= nil
				then
					cKQRewardIndex( Var[ "Player" ][ i ][ "Handle" ], Result[ TeamNo ][ "RewardIndex" ] )
				end

				if Result[ TeamNo ][ "RewardAbs" ] ~= nil
				then
					cSetAbstate( Var[ "Player" ][ i ][ "Handle" ], Result[ TeamNo ][ "RewardAbs" ][ "Index" ], Result[ TeamNo ][ "RewardAbs" ][ "Str" ], Result[ TeamNo ][ "RewardAbs" ][ "KeepTime" ] )
				end

				cViewSlotUnEquipAll( Var[ "Player" ][ i ][ "Handle" ] )
			end
		end


		-- 팀 별 처리
		for i = 1, #TeamNumberList
		do
			-- 팀 관련 데이터
			local TeamNumber   = TeamNumberList[i]
			local FlagData     = ArenaFlag[ TeamNumber ]
			local PenaltyData  = ArenaFlag["Penalty"]
			local PlayerHandle = Var["ArenaFlag"][TeamNumber]["PlayerHandle"]


			-- 주자 확인, 처리
			if PlayerHandle ~= nil
			then
				-- 화살표 삭제
				cDelDirectionalArrow( PlayerHandle )

				-- 깃발 상태이상 제거
				cResetAbstate( PlayerHandle, FlagData["Abstate"]["Index"] )

				-- 패널티 제거
				for PenaltyIndex = 1, #PenaltyData["Abstate"]
				do
					cResetAbstate( PlayerHandle, PenaltyData["Abstate"][PenaltyIndex][ "Index" ] )
				end
			end
		end

		cSetTeamBattle( Var[ "MapIndex" ], false )

		Var["StepFunc"]			= ReturnToHome
		Var[ "ArenaProcess" ] 	= nil
		Var[ "KQLimitTime" ] 	= 0

		DebugLog( "End ArenaProcess" )
	end

end


-- 귀환
function ReturnToHome( Var )
cExecCheck "ReturnToHome"

	if Var == nil
	then
		return
	end


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
				cNotice( Var["MapIndex"], NoticeInfo["ScriptFileName"], NoticeInfo["KQReturn"][ Var["ReturnToHome"]["ReturnStepNo"] ]["Index"] )
			end

			-- Go To Next Notice
			Var["ReturnToHome"]["ReturnStepNo"]  = Var["ReturnToHome"]["ReturnStepNo"] + 1
			Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"] + DelayTime["GapKQReturnNotice"]

		end

		return

	end


	-- Return : linkto substep
	if Var["ReturnToHome"]["ReturnStepNo"] > #NoticeInfo["KQReturn"]
	then

		if Var["ReturnToHome"]["ReturnStepSec"] <= Var["CurSec"]
		then
			--Finish_KQ
			cLinkToAll( Var["MapIndex"], LinkInfo["ReturnMap"]["MapIndex"], LinkInfo["ReturnMap"]["x"], LinkInfo["ReturnMap"]["y"] )

			Var["ReturnToHome"] = nil
			if cEndOfKingdomQuest( Var["MapIndex"] ) == nil
			then
				ErrorLog( "ReturnToHome::Function cEndOfKingdomQuest failed" )
			end

			DebugLog( "End ReturnToHome" )
		end

		return

	end

end

