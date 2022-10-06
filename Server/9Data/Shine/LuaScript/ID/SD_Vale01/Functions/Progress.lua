--------------------------------------------------------------------------------
-- DummyProcess
--------------------------------------------------------------------------------
function DummyProcess( Var )
cExecCheck "DummyProcess"

	--DebugLog("끝")
	return

end

--------------------------------------------------------------------------------
-- InitDungeon
--------------------------------------------------------------------------------
-- 던전 초기화
function InitDungeon( Var )
cExecCheck "InitDungeon"

	if Var == nil
	then
		return
	end

	-- 인스턴스 던전 시작 전에 플레이어의 첫 로그인을 기다린다.
	if Var["bPlayerMapLogin"] == nil
	then
		if Var["InitialSec"] + WAIT_PLAYER_MAP_LOGIN_SEC_MAX <= cCurrentSecond()
		then
			--GoToFail( Var )
			Var["StepFunc"] 			= ReturnToHome
			return
		end

		return
	end

	if Var["InitDungeon"] == nil
	then
		--DebugLog( "Start InitDungeon" )

		Var["InitDungeon"] = {}

		-- 대기시간 설정
		Var["InitDungeon"]["WaitSecDuringInit"] 		= Var["CurSec"] + DelayTime["AfterInit"]
		Var["InitDungeon"]["DialogTime"] 				= Var["InitDungeon"]["WaitSecDuringInit"]
		Var["InitDungeon"]["DialogStep"]				= 1
	end

	-- 대기 후 대사처리 단계로
	if Var["InitDungeon"]["WaitSecDuringInit"] > Var["CurSec"]
	then
		return
	end



	-- 대사처리
	if Var["InitDungeon"]["DialogTime"] ~= nil
	then

		if Var["InitDungeon"]["DialogTime"] > Var["CurSec"]
		then
			return
		else
			local CurMsg 			= ChatInfo["InitDungeon"]
			local DialogStep		= Var["InitDungeon"]["DialogStep"]
			local MaxDialogStep		= #ChatInfo["InitDungeon"]

			if DialogStep <= MaxDialogStep
			then
				cScriptMessage( Var["MapIndex"], CurMsg[DialogStep]["Index"] )
				Var["InitDungeon"]["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
				Var["InitDungeon"]["DialogStep"]	= DialogStep + 1
				return
			end

			if Var["InitDungeon"]["DialogStep"] > MaxDialogStep
			then
				Var["InitDungeon"]["DialogTime"]		= nil
				Var["InitDungeon"]["DialogStep"]		= nil

				Var["InitDungeon"]["NextStepWaitTime"] 	= Var["CurSec"] + DelayTime["WaitKingCrabProcess"]
			end
		end
	end


	if Var["InitDungeon"]["NextStepWaitTime"] ~= nil
	then
		if Var["InitDungeon"]["NextStepWaitTime"] > Var["CurSec"]
		then
			return
		end

		Var["StepFunc"] 	= KingCrabProcess
		Var["InitDungeon"] 	= nil
		--DebugLog( "End InitDungeon" )

		return
	end
end



--------------------------------------------------------------------------------
-- KingCrabProcess
--------------------------------------------------------------------------------
function KingCrabProcess( Var )
cExecCheck "KingCrabProcess"

	if Var == nil
	then
		ErrorLog("KingCrabProcess:: Var == nil" )
		--GoToFail( Var )
		Var["StepFunc"] 			= ReturnToHome
		return
	end

	-----------------------------------------------------------------
	-- KingCrabProcess : 킹크랩 리젠처리
	-----------------------------------------------------------------

	if Var["KingCrabProcess"] == nil
	then
		Var["KingCrabProcess"] = {}

		--DebugLog("===KingCrabProcess=========================")
		--DebugLog("킹크랩 프로세스 테이블 생성")


		local RegenInfo 	= RegenInfoTable["KingCrab"]
		local Handle 		= INVALID_HANDLE

		-- 맵에 있는 모든 유저의 핸들 받아온다
		local TargetHandleList 	= { cGetPlayerList(Var["MapIndex"]) }
		local RegenX, RegenY 	= RegenInfo["RegenX"], RegenInfo["RegenY"]

		-- 맵에 1명 이상의 유저가 있을 경우, 그 중 한명의 위치로 리젠한다.
		-- 맵에 유저가 없을 경우, RegenInfoTable["KingCrab"]에 세팅된 위치로 리젠한다.
		if TargetHandleList ~= nil
		then
			local TargetUser 	= cRandomInt( 1, #TargetHandleList )
			if TargetHandleList[TargetUser] ~= nil
			then
				RegenX, RegenY 		= cObjectLocate( TargetHandleList[TargetUser] )
			end
		end

		Handle = cMobRegen_XY( Var["MapIndex"], RegenInfo["MobIndex"], RegenX + 5, RegenY, RegenInfo["Dir"] )

		if Handle == nil
		then
			ErrorLog("킹크랩 생성 실패")
			Var["StepFunc"] 			= ReturnToHome
			--GoToFail( Var )
			return
		else
			--DebugLog("킹크랩 핸들값은 : "..Handle)
		end

		-- 대사처리
		local CurMsg = ChatInfo["KingCrabProcess"]["AfterBossRegen"]
		if CurMsg ~= nil
		then
			-- 응? 왠지 땅이 흔들리는거 같지 않아요?
			cScriptMessage( Var["MapIndex"], CurMsg["Index"] )
		end

		Var["KingCrabProcess"]["Handle"]		= Handle

		Var[Handle]								= {}
		Var[Handle]["IsProgressSpecialSkill"]	= false

		return
	end

	if Var["KingCrabProcess"] ~= nil
	then
		local Handle = Var["KingCrabProcess"]["Handle"]

		-----------------------------------------------------------------
		-- KingCrabProcess : 다음 단계로 넘어갈 시간인지 체크
		-----------------------------------------------------------------
		-- 다음 단계로 넘어갈 시간이 아니면
		if Var["KingCrabProcess"]["NextStepWaitTime"] ~= nil
		then
			if Var["KingCrabProcess"]["NextStepWaitTime"] > Var["CurSec"]
			then
				--DebugLog("다음단계 넘어가기 대기중...")
				return
			end

			Var["KingCrabProcess"] 	= nil
			Var[Handle]	 			= nil
			Var["StepFunc"] 		= KingSlimeProcess

			--DebugLog("다음 스텝 설정 : KingSlimeProcess")

			return
		end

		-----------------------------------------------------------------
		-- KingCrabProcess : 킹크랩 죽었는지 체크
		-----------------------------------------------------------------
		if cIsObjectDead( Handle ) == 1
		then
			--DebugLog("킹크랩 죽었군!")
			if cAIScriptSet( Handle ) == nil
			then
				ErrorLog( "KingCrabProcess : 스크립트 초기화 실패" )
			end

			-- 대사 처리
			local CurMsg = ChatInfo["KingCrabProcess"]["AfterBossDead"]
			if CurMsg ~= nil
			then
				-- 해안가에 있는 일반적인 킹크랩과는 뭔가 분위기가 다른데요?
				cScriptMessage( Var["MapIndex"], CurMsg["Index"] )
			end

			-- 보상 지급
			if RewardItemInfo["KingCrabProcess"] ~= nil
			then
				--DebugLog("KingCrabProcess 보상지급 대기중")
				local CurReward 	= RewardItemInfo["KingCrabProcess"]
				local RewardList 	= { cGetPlayerList(Var["MapIndex"]) }

				--DebugLog("RewardList 개수 : "..#RewardList )

				-- 맵에 있는 유저 중, 현재 죽지 않은 유저들에게 보상을 지급한다.
				for i = 1, #RewardList
				do
					if cIsObjectDead( RewardList[i] ) == nil
					then
						cRewardItem( RewardList[i], CurReward["Index"], CurReward["Num"] )
					end
				end
			end

			Var["KingCrabProcess"]["NextStepWaitTime"] = Var["CurSec"] + DelayTime["WaitKingSlimeProcess"]

			return
		end


		-----------------------------------------------------------------
		-- KingCrabProcess : 킹크랩 스킬 체크
		-----------------------------------------------------------------
		if Var[Handle]["IsProgressSpecialSkill"] == false
		then

			local CurTime 	= Var["CurSec"]

			local CurMySkill, EndTime = cGetCurrentSkillInfo( Var["KingCrabProcess"]["Handle"] )

			-- 현재 스킬데이터에 있는 스킬 사용중이 아닌경우, 체크할 필요없으므로 종료
			if CurMySkill == nil
			then
				--DebugLog("스킬사용중아님")
				return
			end

			-- 이미 스킬 쓴 시간 지났으면, 의미없는 endtime 값이므로 return
			if EndTime == nil
			then
				--DebugLog("시간 == nil")
				return
			end

			-- 이미 스킬 쓴 시간 지났으면, 의미없는 endtime 값이므로 return
			if EndTime < CurTime
			then
				return
			end

			-- EndTime 확인하기,
			-- 현재 EndTime이 0으로 들어오는 경우는,
			-- 스킬은 사용중인데 몹ai가 attack 상태가 아니라서, 부모클래스리턴값 받아오기때문

			--DebugLog("드디어 스킬을사용하나요!")
			--[[
			DebugLog("---------------------------")
			DebugLog("KingCrabProcess : 	CurTime : "..CurTime )
			DebugLog("KingCrabProcess : 	CurMySkill : "..CurMySkill)
			DebugLog("KingCrabProcess : 	EndTime : "..EndTime)
			DebugLog("---------------------------")
			--]]

			-----------------------------------------------------------------
			-- ★ 스킬이 휠윈드인 경우
			-----------------------------------------------------------------
			if CurMySkill == SkillInfo_KingCrab["KC_WhirlWind"]["SkillIndex"]
			then
				--DebugLog("KC_WhirlWind 사용중")

				Var["KingCrabProcess"]["SkillStartTime"]	= CurTime
				Var["KingCrabProcess"]["SkillWorkTime"]		= EndTime
				Var["KingCrabProcess"]["SkillEndTime"]		= EndTime + SkillInfo_KingCrab["KC_WhirlWind"]["SkillKeepTime"]

				--[[
				DebugLog("현재시간은 : "			..Var["CurSec"] )
				DebugLog("스킬 시작한 시간은 : "	..Var["KingCrabProcess"]["SkillStartTime"] )
				DebugLog("스킬끝 예정시간은 : "		..Var["KingCrabProcess"]["SkillWorkTime"] )
				--]]

				-- 스크립트 부착*******************************************
				if cSetAIScript ( MainLuaScriptPath, Handle ) ~= nil
				then
					if cAIScriptFunc( Handle, "Entrance", "KC_WhirlWind" ) == nil
					then
						ErrorLog("스크립트 부착 실패")
						return
					end
				end

				-- 스킬 처리 중이므로
				Var[Handle]["IsProgressSpecialSkill"] 		= true

				return
			end

			-----------------------------------------------------------------
			-- ★ 스킬이 소환인 경우
			-----------------------------------------------------------------

			if CurMySkill == SkillInfo_KingCrab["KC_SummonBubble"]["SkillIndex"]
			then
				DebugLog("KC_SummonBubble 사용중")

				Var["KingCrabProcess"]["SkillStartTime"]	= CurTime
				Var["KingCrabProcess"]["SkillWorkTime"]		= CurTime + SkillInfo_KingCrab["KC_SummonBubble"]["SummonStartDelay"]
				Var["KingCrabProcess"]["SkillEndTime"]		= EndTime

				--[[
				DebugLog("현재시간은 : "			..Var["CurSec"] )
				DebugLog("스킬 시작한 시간은 : "	..Var["KingCrabProcess"]["SkillStartTime"] )
				DebugLog("스킬처리예정시간은 : "	..Var["KingCrabProcess"]["SkillWorkTime"] )
				DebugLog("스킬끝 예정시간은 : "		..Var["KingCrabProcess"]["SkillEndTime"] )
				--]]

				-- 스크립트 부착*******************************************
				if cSetAIScript ( MainLuaScriptPath, Handle ) ~= nil
				then
					if cAIScriptFunc( Handle, "Entrance", "KC_SummonBubble" ) == nil
					then
						ErrorLog("스크립트 부착 실패")
						return
					end
				end

				Var[Handle]["IsProgressSpecialSkill"] = true
				return
			end
		end
	end
end


--------------------------------------------------------------------------------
-- KingSlimeProcess
--------------------------------------------------------------------------------
function KingSlimeProcess( Var )
cExecCheck "KingSlimeProcess"

	if Var == nil
	then
		ErrorLog("KingSlimeProcess:: Var == nil" )
		--GoToFail( Var )
		Var["StepFunc"] 			= ReturnToHome
		return
	end

	-----------------------------------------------------------------
	-- KingSlimeProcess : Var["KingSlimeProcess"] 테이블 초기화작업
	-----------------------------------------------------------------
	if Var["KingSlimeProcess"] == nil
	then
		Var["KingSlimeProcess"] = {}

		--DebugLog("===KingSlimeProcess=========================")
		--DebugLog("킹슬라임 프로세스 테이블 생성")

		local RegenInfo 	= RegenInfoTable["KingSlime"]
		local Handle 		= INVALID_HANDLE

		-- 맵에 있는 모든 유저의 핸들 받아온다
		local TargetHandleList 	= { cGetPlayerList(Var["MapIndex"]) }
		local RegenX, RegenY 	= RegenInfo["RegenX"], RegenInfo["RegenY"]

		-- 맵에 1명 이상의 유저가 있을 경우, 그 중 한명의 위치로 리젠한다.
		-- 맵에 유저가 없을 경우, RegenInfoTable["KingCrab"]에 세팅된 위치로 리젠한다.
		if TargetHandleList ~= nil
		then
			local TargetUser 	= cRandomInt( 1, #TargetHandleList )
			if TargetHandleList[TargetUser] ~= nil
			then
				RegenX, RegenY 		= cObjectLocate( TargetHandleList[TargetUser] )
			end
		end

		Handle = cMobRegen_XY( Var["MapIndex"], RegenInfo["MobIndex"], RegenX + 5, RegenY, RegenInfo["Dir"] )

		if Handle == nil
		then
			ErrorLog("킹슬라임 생성 실패")
			Var["StepFunc"] 			= ReturnToHome
			--GoToFail( Var )
			return
		else
			DebugLog("킹슬라임 핸들값은 : "..Handle)
		end

		-- 몹 리젠되자마자 hide상태이상 걸어줌!
		cSetAbstate( Handle, "StaHide", 1, 10000 )

		Var["KingSlimeProcess"]["Handle"]		= Handle

		Var[Handle]								= {}
		Var[Handle]["IsProgressSpecialSkill"]	= false

		-- 대사처리
		local CurMsg = ChatInfo["KingSlimeProcess"]["AfterBossRegen"]
		if CurMsg ~= nil
		then
			-- 응? 바닥에 저 그림자는 뭐죠?
			cScriptMessage( Var["MapIndex"], CurMsg["Index"] )
		end

		local target = cObjectFind( Handle, 1000, ObjectType["Player"], "so_ObjectType" )		

		if cSkillBlast( Handle, target, SkillInfo_KingSlime["KS_ShowUp"]["SkillIndex"] ) == nil
		then
			ErrorLog("킹슬라임 리젠후 최초낙하 스킬 사용실패")
		end

		return
	end

	-----------------------------------------------------------------
	-- KingSlimeProcess : Var["KingSlimeProcess"] 테이블 초기화 후 작업
	-----------------------------------------------------------------
	if Var["KingSlimeProcess"] ~= nil
	then
		local Handle = Var["KingSlimeProcess"]["Handle"]

		-----------------------------------------------------------------
		-- KingSlimeProcess : 다음 단계로 넘어갈 시간인지 체크
		-----------------------------------------------------------------
		-- 다음 단계로 넘어갈 시간이 아니면
		if Var["KingSlimeProcess"]["NextStepWaitTime"] ~= nil
		then
			if Var["KingSlimeProcess"]["NextStepWaitTime"] > Var["CurSec"]
			then
				--DebugLog("다음단계 넘어가기 대기중...")
				return
			end

			Var["KingSlimeProcess"] 	= nil
			Var[Handle]	 				= nil
			Var["StepFunc"] 			= MiniDragonProcess

			--DebugLog("다음 스텝 설정 : MiniDragonProcess")

			return
		end

		-----------------------------------------------------------------
		-- KingSlimeProcess : 킹슬라임 죽었는지 체크
		-----------------------------------------------------------------

		if cIsObjectDead( Handle ) == 1
		then
			--DebugLog("킹슬라임 죽었군!")
			if cAIScriptSet( Handle ) == nil
			then
				ErrorLog( "KingSlimeProcess : 스크립트 초기화 실패" )
			end

			-- 대사 처리
			local CurMsg = ChatInfo["KingSlimeProcess"]["AfterBossDead"]
			if CurMsg ~= nil
			then
				-- 확실히 예전에 있던 해안가 몬스터들하고 뭔가 달라졌어요. 다들 조심하세요.
				cScriptMessage( Var["MapIndex"], CurMsg["Index"] )
			end

			-- 보상 지급
			if RewardItemInfo["KingSlimeProcess"] ~= nil
			then
				--DebugLog("KingSlimeProcess 보상지급 대기중")
				local CurReward 	= RewardItemInfo["KingSlimeProcess"]
				local RewardList 	= { cGetPlayerList(Var["MapIndex"]) }

				--DebugLog("RewardList 개수 : "..#RewardList )

				-- 맵에 있는 유저 중, 현재 죽지 않은 유저들에게 보상을 지급한다.
				for i = 1, #RewardList
				do
					if cIsObjectDead( RewardList[i] ) == nil
					then
						cRewardItem( RewardList[i], CurReward["Index"], CurReward["Num"] )
					end
				end

			end

			-- 다음 스텝시간 세팅
			Var["KingSlimeProcess"]["NextStepWaitTime"] = Var["CurSec"] + DelayTime["WaitMiniDragonProcess"]

			return
		end

		-----------------------------------------------------------------
		-- KingSlimeProcess : 킹슬라임 스킬 처리 체크
		-----------------------------------------------------------------
		if Var[Handle]["IsProgressSpecialSkill"] == false
		then

			local CurTime 	= Var["CurSec"]

			local CurMySkill, EndTime = cGetCurrentSkillInfo( Handle )

			-- 현재 스킬데이터에 있는 스킬 사용중이 아닌경우, 체크할 필요없으므로 종료
			if CurMySkill == nil
			then
				--DebugLog("스킬사용중아님")
				return
			end

			-- 이미 스킬 쓴 시간 지났으면, 의미없는 endtime 값이므로 return
			if EndTime == nil
			then
				--DebugLog("시간 == nil")
				return
			end

			-- 이미 스킬 쓴 시간 지났으면, 의미없는 endtime 값이므로 return
			if EndTime < CurTime
			then
				return
			end

			-- EndTime 확인하기,
			--[[
			DebugLog("드디어 스킬을사용하나요!")
			DebugLog("---------------------------")
			DebugLog("CurTime : "..CurTime )
			DebugLog("CurMySkill : "..CurMySkill)
			DebugLog("EndTime : "..EndTime)
			--]]

			-----------------------------------------------------------------
			-- ★ 스킬이 최초낙하인 경우( 리젠후 바로 쓰는 스킬 )
			-----------------------------------------------------------------
			if CurMySkill == SkillInfo_KingSlime["KS_ShowUp"]["SkillIndex"]
			then
				Var["KingSlimeProcess"]["SkillStartTime"]	= CurTime
				Var["KingSlimeProcess"]["SkillEndTime"]		= EndTime

				--[[
				DebugLog("현재시간은 : "			..Var["CurSec"] )
				DebugLog("스킬 시작한 시간은 : "	..Var["KingSlimeProcess"]["SkillStartTime"] )
				DebugLog("스킬끝 예정시간은 : "		..Var["KingSlimeProcess"]["SkillEndTime"] )
				--]]

				-- 스크립트 부착*******************************************
				if cSetAIScript ( MainLuaScriptPath, Handle ) ~= nil
				then
					if cAIScriptFunc( Handle, "Entrance", "KS_ShowUp" ) == nil
					then
						ErrorLog("스크립트 부착 실패")
						return
					end
				end

				Var[Handle]["IsProgressSpecialSkill"] = true

				return
			end

			-----------------------------------------------------------------
			-- ★ 스킬이 강림인 경우
			-----------------------------------------------------------------
			if CurMySkill == SkillInfo_KingSlime["KS_Warp"]["SkillIndex"]
			then
				Var["KingSlimeProcess"]["SkillStartTime"]	= CurTime
				Var["KingSlimeProcess"]["SkillWorkTime"]	= CurTime + SkillInfo_KingSlime["KS_Warp"]["NotTargetStartDelay"]
				Var["KingSlimeProcess"]["SkillEndTime"]		= EndTime

				--[[
				DebugLog("현재시간은 : "			..Var["CurSec"] )
				DebugLog("스킬 시작한 시간은 : "	..Var["KingSlimeProcess"]["SkillStartTime"] )
				DebugLog("스킬끝 예정시간은 : "		..Var["KingSlimeProcess"]["SkillEndTime"] )
				--]]

				-- 스크립트 부착*******************************************
				if cSetAIScript ( MainLuaScriptPath, Handle ) ~= nil
				then
					if cAIScriptFunc( Handle, "Entrance", "KS_Warp" ) == nil
					then
						ErrorLog("스크립트 부착 실패")
						return
					end
				end

				Var[Handle]["IsProgressSpecialSkill"] = true

				return
			end

			-----------------------------------------------------------------
			-- ★ 스킬이 소환인 경우
			-----------------------------------------------------------------
			if 	CurMySkill == SkillInfo_KingSlime["KS_BombSlimePiece"]["SkillIndex_Lump"] or
				CurMySkill == SkillInfo_KingSlime["KS_BombSlimePiece"]["SkillIndex_Ice"] or
				CurMySkill == SkillInfo_KingSlime["KS_BombSlimePiece"]["SkillIndex_All"]
			then
				--DebugLog("KS_BombSlimePiece 소환 사용중")

				Var["KingSlimeProcess"]["SkillStartTime"]	= CurTime
				Var["KingSlimeProcess"]["SkillWorkTime"]	= CurTime + SkillInfo_KingSlime["KS_BombSlimePiece"]["SummonStartDelay"]
				Var["KingSlimeProcess"]["SkillEndTime"]		= EndTime

				Var["KingSlimeProcess"]["CurSkillIndex"]	= CurMySkill

				--[[
				DebugLog("현재 사용한 스킬인덱스 : "	..Var["KingSlimeProcess"]["CurSkillIndex"] )
				DebugLog("현재시간은 : "				..Var["CurSec"] )
				DebugLog("스킬 시작한 시간은 : "		..Var["KingSlimeProcess"]["SkillStartTime"] )
				DebugLog("스킬처리예정시간은 : "		..Var["KingSlimeProcess"]["SkillWorkTime"] )
				DebugLog("스킬끝 예정시간은 : "			..Var["KingSlimeProcess"]["SkillEndTime"] )
				--]]

				-- 스크립트 부착*******************************************
				if cSetAIScript ( MainLuaScriptPath, Handle ) ~= nil
				then
					if cAIScriptFunc( Handle, "Entrance", "KS_BombSlimePiece" ) == nil
					then
						ErrorLog("스크립트 부착 실패")
						return
					end
				end

				Var[Handle]["IsProgressSpecialSkill"] = true
				return
			end

		end
	end
end




















--------------------------------------------------------------------------------
-- MiniDragonProcess
--------------------------------------------------------------------------------
function MiniDragonProcess( Var )
cExecCheck "MiniDragonProcess"

	if Var == nil
	then
		ErrorLog("MiniDragonProcess:: Var == nil" )
		Var["StepFunc"] 			= ReturnToHome
		--GoToFail( Var )
		return
	end

	-----------------------------------------------------------------
	-- MiniDragonProcess : 미니드래곤 리젠처리
	-----------------------------------------------------------------

	if Var["MiniDragonProcess"] == nil
	then
		Var["MiniDragonProcess"] = {}

		--DebugLog("===MiniDragonProcess=========================")
		--DebugLog("미니드래곤 프로세스 테이블 생성")

		local RegenInfo 	= RegenInfoTable["MiniDragon"]
		local Handle 		= INVALID_HANDLE


		-- 맵에 있는 모든 유저의 핸들 받아온다
		local TargetHandleList 	= { cGetPlayerList(Var["MapIndex"]) }
		local RegenX, RegenY 	= RegenInfo["RegenX"], RegenInfo["RegenY"]

		-- 맵에 1명 이상의 유저가 있을 경우, 그 중 한명의 위치로 리젠한다.
		-- 맵에 유저가 없을 경우, RegenInfoTable["KingCrab"]에 세팅된 위치로 리젠한다.
		if TargetHandleList ~= nil
		then
			local TargetUser 	= cRandomInt( 1, #TargetHandleList )
			if TargetHandleList[TargetUser] ~= nil
			then
				RegenX, RegenY 		= cObjectLocate( TargetHandleList[TargetUser] )
			end
		end

		Handle = cMobRegen_XY( Var["MapIndex"], RegenInfo["MobIndex"], RegenX + 5, RegenY, RegenInfo["Dir"] )

		if Handle == nil
		then
			ErrorLog("미니드래곤 생성 실패")
			Var["StepFunc"] 			= ReturnToHome
			--GoToFail( Var )
			return
		else
			--DebugLog("미니드래곤 핸들값은 : "..Handle)
		end

		-- 몹 리젠되자마자 hide상태이상 걸어줌!
		cSetAbstate( Handle, "StaHide", 1, 10000 )

		Var["MiniDragonProcess"]["Handle"]	= Handle

		-- 몹 리젠한 핸들값
		Var[Handle]									= {}
		Var[Handle]["IsProgressSpecialSkill"]		= false

		-- 미니드래곤 근처의 유저에게 스킬 사용한다.
		local target = cObjectFind( Handle, 1000, ObjectType["Player"], "so_ObjectType" )

		if cSkillBlast( Handle, target, SkillInfo_MiniDragon["MD_ShowUp"]["SkillIndex"] ) == nil
		then
			ErrorLog("미니드래곤, 리젠후 착륙 스킬 사용실패")
		else
			--DebugLog("미니드래곤, 리젠후 착륙 스킬 성공했음")
		end

		return
	end


	if Var["MiniDragonProcess"] ~= nil
	then
		local Handle = Var["MiniDragonProcess"]["Handle"]

		-----------------------------------------------------------------
		-- MiniDragonProcess : 다음 단계로 넘어갈 시간인지 체크
		-----------------------------------------------------------------
		-- 다음 단계로 넘어갈 시간이 아니면
		if Var["MiniDragonProcess"]["NextStepWaitTime"] ~= nil
		then
			if Var["MiniDragonProcess"]["NextStepWaitTime"] > Var["CurSec"]
			then
				--DebugLog("다음단계 넘어가기 대기중...")
				return
			end

			-- DebugLog("미드 죽인 시간.."..Var["MiniDragonProcess"]["BossDeadTime"])
			-- DebugLog("목표시간.."..Var["InitialSec"] + LimitTime["ForBonusStage"])

			if Var["MiniDragonProcess"]["BossDeadTime"] < Var["InitialSec"] + LimitTime["ForBonusStage"]
			then
				Var["StepFunc"] 			= BonusStageProcess
				--DebugLog("시간안에 해치워서 보너스스테이지 실행")
			else
				Var["StepFunc"] 			= ReturnToHome
				--DebugLog("시간안에 못함, 리턴투홈")
			end

			Var["MiniDragonProcess"] 	= nil
			Var[Handle]	 				= nil

			return
		end


		-----------------------------------------------------------------
		-- MiniDragonProcess : 미니드래곤 죽었는지 체크
		-----------------------------------------------------------------

		if cIsObjectDead( Handle ) == 1
		then
			--DebugLog("미니드래곤 죽었군!")
			if cAIScriptSet( Handle ) == nil
			then
				DebugLog( "MiniDragonProcess : 스크립트 초기화 실패" )
			end

			-- 미니드래곤 해치운 시간 저장
			Var["MiniDragonProcess"]["BossDeadTime"]		= Var["CurSec"]

			-- 보상 지급
			if RewardItemInfo["MiniDragonProcess"] ~= nil
			then
				--DebugLog("MiniDragonProcess 보상지급 대기중")
				local CurReward 	= RewardItemInfo["MiniDragonProcess"]
				local RewardList 	= { cGetPlayerList(Var["MapIndex"]) }

				--DebugLog("RewardList 개수 : "..#RewardList )

				-- 맵에 있는 유저 중, 현재 죽지 않은 유저들에게 보상을 지급한다.
				for i = 1, #RewardList
				do
					if cIsObjectDead( RewardList[i] ) == nil
					then
						cRewardItem( RewardList[i], CurReward["Index"], CurReward["Num"] )
					end
				end

			end

			-- 다음 스텝시간 세팅
			Var["MiniDragonProcess"]["NextStepWaitTime"] 	= Var["CurSec"] + DelayTime["WaitAfterMiniDragonProcess"]

			return
		end
	end


	-----------------------------------------------------------------
	-- MiniDragonProcess : 미니드래곤 스킬 처리 체크
	-----------------------------------------------------------------
	local Handle = Var["MiniDragonProcess"]["Handle"]

	if Var[Handle]["IsProgressSpecialSkill"] == false
	then
		-- DebugLog("---------------------------")
		-- DebugLog("cGetCurrentSkillInfo 호출")

		local CurTime 	= Var["CurSec"]

		local CurMySkill, EndTime = cGetCurrentSkillInfo( Handle )

		-- 현재 스킬데이터에 있는 스킬 사용중이 아닌경우, 체크할 필요없으므로 종료
		if CurMySkill == nil
		then
			--DebugLog("스킬사용중아님")
			return
		end

		-- 이미 스킬 쓴 시간 지났으면, 의미없는 endtime 값이므로 return
		if EndTime == nil
		then
			--DebugLog("시간 == nil")
			return
		end

		-- 이미 스킬 쓴 시간 지났으면, 의미없는 endtime 값이므로 return
		if EndTime < CurTime
		then

		--[[
			DebugLog("스킬 이미 사용끝")

			DebugLog("---------------------------")
			DebugLog("CurTime : "..CurTime )
			DebugLog("CurMySkill : "..CurMySkill)
			DebugLog("EndTime : "..EndTime)
		--]]
			return
		end

		--DebugLog("드디어 스킬을사용하나요!")
		--[[
		DebugLog("---------------------------")
		DebugLog("CurTime : "..CurTime )
		DebugLog("CurMySkill : "..CurMySkill)
		DebugLog("EndTime : "..EndTime)
		--]]


		-----------------------------------------------------------------
		-- ★ 스킬이 리젠 후 착륙인 경우
		-----------------------------------------------------------------
		if CurMySkill == SkillInfo_MiniDragon["MD_ShowUp"]["SkillIndex"]
		then
			--DebugLog("미니드래곤_리젠후 착륙")

			Var["MiniDragonProcess"]["SkillStartTime"]	= CurTime
			Var["MiniDragonProcess"]["SkillEndTime"]	= EndTime

			--[[
			DebugLog("현재시간은 : "			..Var["CurSec"] )
			DebugLog("스킬 시작한 시간은 : "	..Var["MiniDragonProcess"]["SkillStartTime"] )
			DebugLog("스킬 애니 끝 시간은 : "	..Var["MiniDragonProcess"]["SkillEndTime"] )
			--]]
			-- 스크립트 부착*******************************************
			if cSetAIScript ( MainLuaScriptPath, Handle ) ~= nil
			then
				if cAIScriptFunc( Handle, "Entrance", "MD_ShowUp" ) == nil
				then
					ErrorLog("MD_ShowUp 스크립트 부착 실패")
					return
				end
			end

			Var[Handle]["IsProgressSpecialSkill"] = true

			return
		end

		-----------------------------------------------------------------
		-- ★ 스킬이 소환인 경우
		-----------------------------------------------------------------
		if 	CurMySkill == SkillInfo_MiniDragon["MD_SummonSoul"]["SkillIndex_Fire"] or
			CurMySkill == SkillInfo_MiniDragon["MD_SummonSoul"]["SkillIndex_Ice"] or
			CurMySkill == SkillInfo_MiniDragon["MD_SummonSoul"]["SkillIndex_All"]
		then
			Var["MiniDragonProcess"]["SkillStartTime"]	= CurTime
			Var["MiniDragonProcess"]["SkillWorkTime"]	= CurTime + SkillInfo_MiniDragon["MD_SummonSoul"]["SummonStartDelay"]
			Var["MiniDragonProcess"]["SkillEndTime"]	= EndTime

			Var["MiniDragonProcess"]["CurSkillIndex"]	= CurMySkill

			--[[
			DebugLog("현재 사용한 스킬인덱스 : "		..Var["MiniDragonProcess"]["CurSkillIndex"] )
			DebugLog("현재시간은 : "					..Var["CurSec"] )
			DebugLog("스킬 시작한 시간은 : "			..Var["MiniDragonProcess"]["SkillStartTime"] )
			DebugLog("스킬처리예정시간은 : "			..Var["MiniDragonProcess"]["SkillWorkTime"] )
			DebugLog("스킬애니끝 시간은 : "				..Var["MiniDragonProcess"]["SkillEndTime"] )
			--]]

			-- 스크립트 부착*******************************************
			if cSetAIScript ( MainLuaScriptPath, Handle ) ~= nil
			then
				if cAIScriptFunc( Handle, "Entrance", "MD_SummonSoul" ) == nil
				then
					ErrorLog("MD_SummonSoul 스크립트 부착 실패")
					return
				end
			end

			Var[Handle]["IsProgressSpecialSkill"] = true

			return
		end
	end
	return
end







--------------------------------------------------------------------------------
-- BonusStage
--------------------------------------------------------------------------------
function BonusStageProcess( Var )
cExecCheck "BonusStageProcess"

	--DebugLog("===BonusStageProcess=========================")

	if Var == nil
	then
		ErrorLog("BonusStageProcess:: Var == nil")
		Var["StepFunc"] 			= ReturnToHome
		--GoToFail( Var )
		return
	end

	-----------------------------------------------------------------
	-- BonusStageProcess : 보너스몹 리젠처리
	-----------------------------------------------------------------

	if Var["BonusStageProcess"] == nil
	then
		Var["BonusStageProcess"] = {}

		--DebugLog("===BonusStageProcess=========================")
		--DebugLog("BonusStageProcess 프로세스 테이블 생성")

		local RegenInfo 	= RegenInfoTable["BonusMob"]
		local Handle 		= cMobRegen_XY( Var["MapIndex"], RegenInfo["MobIndex"], RegenInfo["RegenX"], RegenInfo["RegenY"], RegenInfo["Dir"] )

		if Handle == nil
		then
			ErrorLog("보너스몹 생성 실패")
			--GoToFail( Var )
			Var["StepFunc"] 			= ReturnToHome
			return
		else
			--DebugLog("보너스몹 핸들값은 : "..Handle)
		end

		Var["BonusStageProcess"]["Handle"]	= Handle

		-- 대사처리
		local CurMsg = ChatInfo["BonusStageProcess"]["AfterBossRegen"]
		cScriptMessage( Var["MapIndex"], CurMsg["Index"] )

		return
	end

	-----------------------------------------------------------------
	-- BonusStageProcess : 보너스몹 죽었는지 체크
	-----------------------------------------------------------------
	if Var["BonusStageProcess"] ~= nil
	then
		local Handle = Var["BonusStageProcess"]["Handle"]

		-----------------------------------------------------------------
		-- BonusStageProcess : 다음 단계로 넘어갈 시간인지 체크
		-----------------------------------------------------------------
		-- 다음 단계로 넘어갈 시간이 아니면
		if Var["BonusStageProcess"]["NextStepWaitTime"] ~= nil
		then
			if Var["BonusStageProcess"]["NextStepWaitTime"] > Var["CurSec"]
			then
				--DebugLog("다음단계 넘어가기 대기중...")
				return
			end

			Var["BonusStageProcess"] 	= nil
			Var["StepFunc"] 			= ReturnToHome

			--DebugLog("다음 스텝 설정 : ReturnToHome")

			return
		end


		-----------------------------------------------------------------
		-- BonusStageProcess : 보너스몹 죽었는지 체크
		-----------------------------------------------------------------
		if cIsObjectDead( Handle ) == 1
		then
			--DebugLog("보너스몹 죽었군!")

			-- 보상 지급
			if RewardItemInfo["BonusStageProcess"] ~= nil
			then
				--DebugLog("BonusStageProcess 보상지급 대기중")
				local CurReward 	= RewardItemInfo["BonusStageProcess"]
				local RewardList 	= { cGetPlayerList(Var["MapIndex"]) }

				--DebugLog("RewardList 개수 : "..#RewardList )

				for i = 1, #RewardList
				do
					-- 여기서 다시 처리를 해줘야되나? 죽은애들 빼는거 말야,
					cRewardItem( RewardList[i], CurReward["Index"], CurReward["Num"] )
				end
			end

			Var["BonusStageProcess"]["NextStepWaitTime"] = Var["CurSec"] + DelayTime["WaitReturnToHome"]

			return
		end
	end
end





--------------------------------------------------------------------------------
-- ReturnToHome
--------------------------------------------------------------------------------
-- 귀환
function ReturnToHome( Var )
cExecCheck "ReturnToHome"

	if Var == nil
	then
		ErrorLog("ReturnToHome:: Var == nil" )
		--GoToFail( Var )
		return
	end

	if Var["ReturnToHome"] == nil
	then
		DebugLog( "Start ReturnToHome" )

		Var["ReturnToHome"] 						= {}

		-- 모든 몬스터 삭제
		cMobSuicide( Var["MapIndex"] )

		-- 입구쪽 출구게이트 생성
		local RegenExitGate  	= RegenInfoTable["ExitGate"]
		local nExitGateHandle 	= cDoorBuild( Var["MapIndex"], RegenExitGate["MobIndex"], RegenExitGate["RegenX"], RegenExitGate["RegenY"], RegenExitGate["Dir"], RegenExitGate["Scale"] )

		if nExitGateHandle ~= nil
		then
			if cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil
			then
				ErrorLog( "InitDungeon::cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil" )
			end

			if cAIScriptFunc( nExitGateHandle, "NPCClick", "Click_ExitGate" ) == nil
			then
				ErrorLog( "InitDungeon::cAIScriptFunc( nExitGateHandle, \"NPCClick\", \"Click_ExitGate\" ) == nil" )
			end
		end

		-- 대사처리
		local CurMsg = ChatInfo["ReturnToHome"]
		cScriptMessage( Var["MapIndex"], CurMsg["Index"] )
	end

	Var["StepFunc"]				= DummyProcess
	Var["ReturnToHome"] 		= nil
	DebugLog( "End ReturnToHome" )
	return

end


