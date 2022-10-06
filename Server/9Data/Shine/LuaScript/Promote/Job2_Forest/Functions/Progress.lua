--------------------------------------------------------------------------------
--                  Promote Job2_Forest Progress Func                         --
--------------------------------------------------------------------------------

------------------------------------------------------
-- InitDungeon : 초기화함수( 도어, 룰렛, 주사위, npc 리젠 )
------------------------------------------------------

function InitDungeon( Var )
cExecCheck "InitDungeon"

	--DebugLog( "==========================InitDungeon_Start==========================" )

	if Var == nil
	then
		ErrorLog("InitDungeon::Var == nil")
		return
	end

	-- 플레이어의 첫 로그인을 기다린다.
	if Var["PlayerHandle"] == INVALID_HANDEL
	then
		if Var["InitialSec"] + WAIT_PLAYER_MAP_LOGIN_SEC_MAX <= cCurrentSecond()
		then
			ErrorLog("플레이어 맵에 로그인 안함")
			Var["StepFunc"] 	= QuestFailed
			return
		end
		return
	end

	local InitDungeonInfo = Var["InitDungeon"]
	if InitDungeonInfo == nil
	then
		Var["InitDungeon"] 		= {}
		InitDungeonInfo			= Var["InitDungeon"]

		-- NPC Regen
		local ElderinHandle 		= RegenInfo["NPC"]["Elderin"]
		local RoumenHandle 			= RegenInfo["NPC"]["Roumen"]

		if ElderinHandle ~= nil and RoumenHandle ~= nil
		then
			Var["Elderin"] 	= cMobRegen_XY( Var["MapIndex"], ElderinHandle["MobIndex"], ElderinHandle["X"], ElderinHandle["Y"], ElderinHandle["Dir"] )
			Var["Roumen"] 	= cMobRegen_XY( Var["MapIndex"], RoumenHandle["MobIndex"], 	RoumenHandle["X"], 	RoumenHandle["Y"], 	RoumenHandle["Dir"] )
		end

		if Var["Elderin"] == nil or Var["Roumen"] == nil
		then
			GoToFail( Var, "InitDungeon:: NPC Regen Fail" )
			return
		end
	end

	Var["StepFunc"] 			= FindHero
	Var["InitDungeon"]			= nil
end


------------------------------------------------------
-- FindHero : 5분안에 npc(엘더린, 루멘) 찾아내기
------------------------------------------------------

function FindHero( Var )
cExecCheck "FindHero"

	--DebugLog("==========================FindHero_Start==========================")

	if Var == nil
	then
		ErrorLog( "FindHero : Var nil" )
		return
	end

	local FindHeroInfo = Var["FindHero"]
	if FindHeroInfo == nil
	then
		Var["FindHero"] 				= {}
		FindHeroInfo					= Var["FindHero"]

		cNotice( Var["MapIndex"], NoticeInfo["ScriptFileName"], NoticeInfo["MissionObj"]["Index"] )

		-- 타이머 설정
		if Var["FindHeroLimitTime"] == 0
		then
			Var["FindHeroLimitTime"] 		= Var["CurSec"] + DelayTime["FindHeroLimitTime"]
			cTimer( Var["MapIndex"], DelayTime["FindHeroLimitTime"] )
		end
	end

	if Var["FindHeroLimitTime"] ~= 0
	then

		if Var["FindHeroLimitTime"] < Var["CurSec"]
		then
			Var["StepFunc"] 			= QuestFailed
			Var["FindHero"] 			= nil
			return
		end

		-- 해당 영역안에 플레이어 아직 안들어왔으면 return / 들어오면 BossBattle함수 실행
		if cGetAreaObject( Var["MapIndex"], AreaInfo["FindNPC"], Var["PlayerHandle"] ) == nil
		then
			return
		else
			--타이머 삭제
			Var["FindHeroLimitTime"] 	= nil
			cTimer( Var["MapIndex"], 0 )

			Var["StepFunc"] 			= FirstMeeting
			Var["FindHero"] 			= nil
		end
	end

end


------------------------------------------------------
-- FirstMeeting : 첫번째 대화
------------------------------------------------------

function FirstMeeting( Var )
cExecCheck "FirstMeeting"

	--DebugLog("==========================FirstMeeting_Start==========================")

	if Var == nil
	then
		ErrorLog( "FirstMeeting : Var nil" )
		return
	end

	if IsFail( Var ) == true
	then
		Var["StepFunc"]  =  QuestFailed
		return
	end

	local FirstMeetingInfo = Var["FirstMeeting"]
	if FirstMeetingInfo == nil
	then
		Var["FirstMeeting"] 					= {}
		FirstMeetingInfo						= Var["FirstMeeting"]

		FirstMeetingInfo["NextStepWaitTime"]	= Var["CurSec"] + ( DelayTime["GapDialog"] * #ChatInfo["FirstMeeting"] ) + DelayTime["WaitSeconds"]
		FirstMeetingInfo["DialogTime"] 			= Var["CurSec"] + DelayTime["GapDialog"]
		FirstMeetingInfo["DialogStep"] 			= 1
	end

	-- 대사 처리
	if FirstMeetingInfo["DialogTime"] ~= nil
	then
		if FirstMeetingInfo["DialogTime"] > Var["CurSec"]
		then
			return
		else
			local CurMsg 			= ChatInfo["FirstMeeting"]
			local DialogStep		= FirstMeetingInfo["DialogStep"]
			local MaxDialogStep		= #ChatInfo["FirstMeeting"]

			if DialogStep <= MaxDialogStep
			then
				cMobDialog( Var["MapIndex"], CurMsg[DialogStep]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurMsg[DialogStep]["MsgIndex"] )
				FirstMeetingInfo["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
				FirstMeetingInfo["DialogStep"]	= DialogStep + 1
			end

			if FirstMeetingInfo["DialogStep"] > MaxDialogStep
			then
				FirstMeetingInfo["DialogTime"]	= nil
				FirstMeetingInfo["DialogStep"]	= nil
			end
		end
	end

	if FirstMeetingInfo["NextStepWaitTime"] > Var["CurSec"]
	then
		return
	else
		-- 타이머 설정
		if Var["LimitTime"] == 0
		then
			Var["LimitTime"] 		= Var["CurSec"] + DelayTime["LimitTime"]
			cTimer( Var["MapIndex"], DelayTime["LimitTime"] )
		end

		Var["StepFunc"] 		= BattleFirst
		Var["FirstMeeting"]		= nil
	end
end


------------------------------------------------------
-- BattleFirst : 첫번째 전투
------------------------------------------------------

function BattleFirst( Var )
cExecCheck "BattleFirst"

	--DebugLog("==========================BattleFirst_Start==========================")

	if Var == nil
	then
		ErrorLog( "BattleFirst : Var nil" )
		return
	end

	if IsFail( Var ) == true
	then
		Var["StepFunc"]  =  QuestFailed
		return
	end

	local BattleFirstInfo = Var["BattleFirst"]
	if BattleFirstInfo == nil
	then
		Var["BattleFirst"]		= {}
		BattleFirstInfo			= Var["BattleFirst"]

		BattleFirstInfo["NextStepWaitTime"] = Var["CurSec"] + DelayTime["WaitDialogSecond"]

		-- 몹 그룹 리젠
		local CurRegenMob = RegenInfo["MobInfo"]["BattleFirst"]
		for i = 1, #CurRegenMob
		do
			if cGroupRegenInstance( Var["MapIndex"], CurRegenMob[i] ) == nil
			then
				ErrorLog("BattleFirst : 몹그룹 리젠실패 _ "..CurRegenMob[i])
			end
		end
	end

	-- 다음단계 진행할 시간인지 체크
	if BattleFirstInfo["NextStepWaitTime"] > Var["CurSec"]
	then
		return
	else
		Var["StepFunc"] 		= DialogSecond
	end
end


------------------------------------------------------
-- DialogSecond : 두번째 대화
------------------------------------------------------

function DialogSecond( Var )
cExecCheck "DialogSecond"

	--DebugLog("==========================DialogSecond_Start==========================")

	if Var == nil
	then
		ErrorLog( "DialogSecond : Var nil" )
		return
	end

	if IsFail( Var ) == true
	then
		Var["StepFunc"]  =  QuestFailed
		return
	end

	local DialogSecondInfo = Var["DialogSecond"]
	if DialogSecondInfo == nil
	then
		Var["DialogSecond"] 					= {}
		DialogSecondInfo						= Var["DialogSecond"]

		DialogSecondInfo["NextStepWaitTime"]	= Var["CurSec"] + ( DelayTime["GapDialog"] * #ChatInfo["DialogSecond"] ) + DelayTime["WaitSeconds"]
		DialogSecondInfo["DialogTime"] 			= Var["CurSec"] + DelayTime["GapDialog"]
		DialogSecondInfo["DialogStep"] 			= 1
	end

	-- 대사 처리
	if DialogSecondInfo["DialogTime"] ~= nil
	then
		if DialogSecondInfo["DialogTime"] > Var["CurSec"]
		then
			return
		else
			local CurMsg 			= ChatInfo["DialogSecond"]
			local DialogStep		= DialogSecondInfo["DialogStep"]
			local MaxDialogStep		= #ChatInfo["DialogSecond"]

			if DialogStep <= MaxDialogStep
			then
				cMobDialog( Var["MapIndex"], CurMsg[DialogStep]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurMsg[DialogStep]["MsgIndex"] )
				DialogSecondInfo["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
				DialogSecondInfo["DialogStep"]	= DialogStep + 1
			end

			if DialogSecondInfo["DialogStep"] > MaxDialogStep
			then
				DialogSecondInfo["DialogTime"]	= nil
				DialogSecondInfo["DialogStep"]	= nil
			end
		end
	end

	if DialogSecondInfo["NextStepWaitTime"] > Var["CurSec"]
	then
		return
	else
		Var["StepFunc"] 		= BattleSecond
		Var["DialogSecond"]		= nil
	end
end


------------------------------------------------------
-- BattleSecond : 두번째 전투
------------------------------------------------------

function BattleSecond( Var )
cExecCheck "BattleSecond"

	--DebugLog("==========================BattleSecond_Start==========================")

	if Var == nil
	then
		ErrorLog( "BattleSecond : Var nil" )
		return
	end

	if IsFail( Var ) == true
	then
		Var["StepFunc"]  =  QuestFailed
		return
	end

	local BattleSecondInfo = Var["BattleSecond"]
	if BattleSecondInfo == nil
	then
		Var["BattleSecond"] 					= {}
		BattleSecondInfo						= Var["BattleSecond"]

		BattleSecondInfo["NextStepWaitTime"] = Var["CurSec"] + DelayTime["WaitDialogThird"]

		-- 몹 그룹 리젠
		local CurRegenMob = RegenInfo["MobInfo"]["BattleSecond"]
		for i = 1, #CurRegenMob
		do
			if cGroupRegenInstance( Var["MapIndex"], CurRegenMob[i] ) == nil
			then
				ErrorLog("BattleSecond : 몹그룹 리젠실패 _ "..CurRegenMob[i])
			end
		end
	end

	-- 다음단계 진행할 시간인지 체크
	if BattleSecondInfo["NextStepWaitTime"] > Var["CurSec"]
	then
		return
	else
		Var["StepFunc"] 		= DialogThird
		Var["BattleSecond"]		= nil
	end
end



------------------------------------------------------
-- DialogThird : 세번째 대화
------------------------------------------------------

function DialogThird( Var )
cExecCheck "DialogThird"

	--DebugLog("==========================DialogThird_Start==========================")

	if Var == nil
	then
		ErrorLog( "DialogThird : Var nil" )
		return
	end

	if IsFail( Var ) == true
	then
		Var["StepFunc"]  =  QuestFailed
		return
	end

	local DialogThirdInfo = Var["DialogThird"]
	if DialogThirdInfo == nil
	then
		Var["DialogThird"] 						= {}
		DialogThirdInfo							= Var["DialogThird"]

		DialogThirdInfo["NextStepWaitTime"]		= Var["CurSec"] + ( DelayTime["GapDialog"] * #ChatInfo["DialogThird"] ) + DelayTime["WaitSeconds"]
		DialogThirdInfo["DialogTime"] 			= Var["CurSec"] + DelayTime["GapDialog"]
		DialogThirdInfo["DialogStep"] 			= 1
	end

	-- 대사 처리
	if DialogThirdInfo["DialogTime"] ~= nil
	then
		if DialogThirdInfo["DialogTime"] > Var["CurSec"]
		then
			return
		else
			local CurMsg 			= ChatInfo["DialogThird"]
			local DialogStep		= DialogThirdInfo["DialogStep"]
			local MaxDialogStep		= #ChatInfo["DialogThird"]

			if DialogStep <= MaxDialogStep
			then
				cMobDialog( Var["MapIndex"], CurMsg[DialogStep]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurMsg[DialogStep]["MsgIndex"] )
				DialogThirdInfo["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
				DialogThirdInfo["DialogStep"]	= DialogStep + 1
			end

			if DialogThirdInfo["DialogStep"] > MaxDialogStep
			then
				DialogThirdInfo["DialogTime"]	= nil
				DialogThirdInfo["DialogStep"]	= nil
			end
		end
	end

	if DialogThirdInfo["NextStepWaitTime"] > Var["CurSec"]
	then
		return
	else
		Var["StepFunc"] 		= BattleThird
		Var["DialogThird"]		= nil
	end
end


------------------------------------------------------
-- BattleThird : 세번째 전투
------------------------------------------------------

function BattleThird( Var )
cExecCheck "BattleThird"

	--DebugLog("==========================BattleThird_Start==========================")

	if Var == nil
	then
		ErrorLog( "BattleThird : Var nil" )
		return
	end

	if IsFail( Var ) == true
	then
		Var["StepFunc"]  =  QuestFailed
		return
	end

	local BattleThirdInfo = Var["BattleThird"]
	if BattleThirdInfo == nil
	then
		Var["BattleThird"] 					= {}
		BattleThirdInfo						= Var["BattleThird"]

		BattleThirdInfo["NextStepWaitTime"] = Var["CurSec"] + DelayTime["WaitDialogFourth"]

		-- 몹 그룹 리젠
		local CurRegenMob = RegenInfo["MobInfo"]["BattleThird"]
		for i = 1, #CurRegenMob
		do
			if cGroupRegenInstance( Var["MapIndex"], CurRegenMob[i] ) == nil
			then
				ErrorLog("BattleThird : 몹그룹 리젠실패 _ "..CurRegenMob[i])
			end
		end
	end

	-- 다음단계 진행할 시간인지 체크
	if BattleThirdInfo["NextStepWaitTime"] > Var["CurSec"]
	then
		return
	else
		Var["StepFunc"] 		= DialogFourth
		Var["BattleThird"]		= nil
	end
end


------------------------------------------------------
-- DialogFourth : 네번째 대화
------------------------------------------------------

function DialogFourth( Var )
cExecCheck "DialogFourth"

	--DebugLog("==========================DialogFourth_Start==========================")

	if Var == nil
	then
		ErrorLog( "DialogFourth : Var nil" )
		return
	end

	if IsFail( Var ) == true
	then
		Var["StepFunc"]  =  QuestFailed
		return
	end

	local DialogFourthInfo = Var["DialogFourth"]
	if DialogFourthInfo == nil
	then
		Var["DialogFourth"] 						= {}
		DialogFourthInfo							= Var["DialogFourth"]

		DialogFourthInfo["NextStepWaitTime"]		= Var["CurSec"] + ( DelayTime["GapDialog"] * #ChatInfo["DialogFourth"] ) + DelayTime["WaitSeconds"]
		DialogFourthInfo["DialogTime"] 				= Var["CurSec"] + DelayTime["GapDialog"]
		DialogFourthInfo["DialogStep"] 				= 1
	end

	-- 대사 처리
	if DialogFourthInfo["DialogTime"] ~= nil
	then
		if DialogFourthInfo["DialogTime"] > Var["CurSec"]
		then
			return
		else
			local CurMsg 			= ChatInfo["DialogFourth"]
			local DialogStep		= DialogFourthInfo["DialogStep"]
			local MaxDialogStep		= #ChatInfo["DialogFourth"]

			if DialogStep <= MaxDialogStep
			then
				cMobDialog( Var["MapIndex"], CurMsg[DialogStep]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurMsg[DialogStep]["MsgIndex"] )
				DialogFourthInfo["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
				DialogFourthInfo["DialogStep"]	= DialogStep + 1
			end

			if DialogFourthInfo["DialogStep"] > MaxDialogStep
			then
				DialogFourthInfo["DialogTime"]	= nil
				DialogFourthInfo["DialogStep"]	= nil
			end
		end
	end

	if DialogFourthInfo["NextStepWaitTime"] > Var["CurSec"]
	then
		return
	else
		Var["StepFunc"] 		= BattleFourth
		Var["DialogFourth"]		= nil
	end
end


------------------------------------------------------
-- BattleFourth : 네번째 전투
------------------------------------------------------

function BattleFourth( Var )
cExecCheck "BattleFourth"

	--DebugLog("==========================BattleFourth_Start==========================")

	if Var == nil
	then
		ErrorLog( "BattleFourth : Var nil" )
		return
	end

	if IsFail( Var ) == true
	then
		Var["StepFunc"]  =  QuestFailed
		return
	end

	local BattleFourthInfo = Var["BattleFourth"]
	if BattleFourthInfo == nil
	then
		Var["BattleFourth"] 					= {}
		BattleFourthInfo						= Var["BattleFourth"]

		-- 몹 그룹 리젠
		local CurRegenMob = RegenInfo["MobInfo"]["BattleFourth"]
		for i = 1, #CurRegenMob
		do
			if cGroupRegenInstance( Var["MapIndex"], CurRegenMob[i] ) == nil
			then
				ErrorLog("BattleFourth : 몹그룹 리젠실패 _ "..CurRegenMob[i])
			end
		end
	end

	-- 제한 시간 지났는지 체크
	if Var["LimitTime"] > Var["CurSec"]
	then
		return
	else
		Var["StepFunc"] 		= QuestSuccess
		Var["BattleFourth"]		= nil
	end
end


------------------------------------------------------
-- QuestSuccess : 퀘스트 성공시 + 대사 및 보상 지급
------------------------------------------------------

function QuestSuccess( Var )
cExecCheck "QuestSuccess"

	--DebugLog("==========================QuestSuccess_Start==========================")

	if Var == nil
	then
		ErrorLog( "QuestSuccess : Var nil" )
		return
	end

	local QuestSuccessInfo = Var["QuestSuccess"]
	if QuestSuccessInfo == nil
	then
		Var["QuestSuccess"] 					= {}
		QuestSuccessInfo						= Var["QuestSuccess"]

		QuestSuccessInfo["NextStepWaitTime"]	= Var["CurSec"] + ( DelayTime["GapDialog"] * #ChatInfo["QuestSuccess"] ) + DelayTime["WaitSeconds"]
		QuestSuccessInfo["DialogTime"] 			= Var["CurSec"] + DelayTime["GapDialog"]
		QuestSuccessInfo["DialogStep"] 			= 1

		-- 맵에 있는 job2_ElfKnight, Job2_LIzardK를 제거
		VanishMob( Var )

		-- 보상 아이템
		cRewardItem_CharInven( Var["PlayerHandle"], RewardItem["Index"], 1 )

		-- 성공 이펙트
		cEffectMsg( Var["PlayerHandle"], EFFECT_MSG_TYPE["EMT_SUCCESS"] )

		--타이머 삭제
		Var["LimitTime"] 	= "NoLimit"
		cTimer( Var["MapIndex"], 0 )
	end

	-- 대사 처리
	if QuestSuccessInfo["DialogTime"] ~= nil
	then
		if QuestSuccessInfo["DialogTime"] > Var["CurSec"]
		then
			return
		else
			local CurMsg 			= ChatInfo["QuestSuccess"]
			local DialogStep		= QuestSuccessInfo["DialogStep"]
			local MaxDialogStep		= #ChatInfo["QuestSuccess"]

			if DialogStep <= MaxDialogStep
			then
				cMobDialog( Var["MapIndex"], CurMsg[DialogStep]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurMsg[DialogStep]["MsgIndex"] )
				QuestSuccessInfo["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
				QuestSuccessInfo["DialogStep"]	= DialogStep + 1
			end

			if QuestSuccessInfo["DialogStep"] > MaxDialogStep
			then
				QuestSuccessInfo["DialogTime"]	= nil
				QuestSuccessInfo["DialogStep"]	= nil
			end
		end
	end

	if QuestSuccessInfo["NextStepWaitTime"] > Var["CurSec"]
	then
		return
	else
		Var["StepFunc"] 		= ReturnToHome
		Var["QuestSuccess"]		= nil
	end

end


------------------------------------------------------
-- QuestFailed : 퀘스트 실패시
------------------------------------------------------

function QuestFailed( Var )
cExecCheck "QuestFailed"

	--DebugLog("==========================QuestFailed_Start==========================")

	if Var == nil
	then
		ErrorLog( "QuestFailed : Var nil" )
		return
	end

	local QuestFailedInfo = Var["QuestFailed"]
	if QuestFailedInfo == nil
	then
		Var["QuestFailed"] 						= {}
		QuestFailedInfo							= Var["QuestFailed"]

		QuestFailedInfo["NextStepWaitTime"]		= Var["CurSec"] + DelayTime["WaitSeconds"]

		-- 맵에 있는 job2_ElfKnight, Job2_LIzardK를 제거
		VanishMob( Var )

		-- 실패 이펙트
		cEffectMsg( Var["PlayerHandle"], EFFECT_MSG_TYPE["EMT_FAIL"] )

		--타이머 삭제
		Var["LimitTime"] 	= "NoLimit"
		cTimer( Var["MapIndex"], 0 )
	end

	if QuestFailedInfo["NextStepWaitTime"] > Var["CurSec"]
	then
		return
	else
		Var["StepFunc"] 	= ReturnToHome
		Var["QuestFailed"]	= nil
	end

end


------------------------------------------------------
-- ReturnToHome : 귀환
------------------------------------------------------

function ReturnToHome( Var )
cExecCheck "ReturnToHome"

	--DebugLog("==========================ReturnToHome_Start==========================")

	if Var == nil
	then
		ErrorLog( "ReturnToHome : Var nil" )
		return
	end

	local ReturnToHomeInfo = Var["ReturnToHome"]
	if ReturnToHomeInfo == nil
	then
		Var["ReturnToHome"] 	= {}
		ReturnToHomeInfo		= Var["ReturnToHome"]

		ReturnToHomeInfo["ReturnStepSec"] 			= Var["CurSec"]
		ReturnToHomeInfo["ReturnStepNo"] 			= 1
		ReturnToHomeInfo["WaitSecReturnToHome"] 	= Var["CurSec"] + DelayTime["WaitReturnToHome"]
	end

	if ReturnToHomeInfo["WaitSecReturnToHome"] > Var["CurSec"]
	then
		return
	end

	-- Return : return notice substep
	if ReturnToHomeInfo["ReturnStepNo"] <= #NoticeInfo["IDReturn"]
	then
		if ReturnToHomeInfo["ReturnStepSec"] < Var["CurSec"]
		then
			-- Notice of Escape
			if NoticeInfo["IDReturn"][ ReturnToHomeInfo["ReturnStepNo"] ]["Index"] ~= nil
			then
				cNotice( Var["MapIndex"], NoticeInfo["ScriptFileName"], NoticeInfo["IDReturn"][ ReturnToHomeInfo["ReturnStepNo"] ]["Index"] )
			end

			-- Go To Next Notice
			ReturnToHomeInfo["ReturnStepNo"]  = Var["ReturnToHome"]["ReturnStepNo"] + 1
			ReturnToHomeInfo["ReturnStepSec"] = Var["CurSec"] + DelayTime["GapReturnNotice"]
		end
		return
	end

	-- Return : linkto substep
	if ReturnToHomeInfo["ReturnStepNo"] > #NoticeInfo["IDReturn"]
	then
		if ReturnToHomeInfo["ReturnStepSec"] <= Var["CurSec"]
		then
			cLinkToAll( Var["MapIndex"], LinkInfo["ReturnMap"]["MapIndex"], LinkInfo["ReturnMap"]["X"], LinkInfo["ReturnMap"]["Y"] )

			cVanishAll( Var["MapIndex"] )
			cMobSuicide( Var["MapIndex"] )

			Var["StepFunc"] 		= DummyFunc
			Var["ReturnToHome"] 	= nil

			-- 2014.12.23 추가작업
			cDropFilm( Var["MapIndex"], MainLuaScriptPath )

		end
		return
	end
end
