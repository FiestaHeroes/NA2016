--------------------------------------------------------------------------------
--                        Mara Pirate Progress Func                           --
--------------------------------------------------------------------------------

-- ���� �ʱ�ȭ
function InitDungeon( Var )
	cExecCheck( "InitDungeon" )

	if Var == nil
	then
		return
	end

	-- ŷ�� ����Ʈ ���� ���� �÷��̾��� ù �α����� ��ٸ���.
	if Var["bPlayerMapLogin"] == nil
	then
		if Var["InitialSec"] + WAIT_PLAYER_MAP_LOGIN_SEC_MAX <= cCurrentSecond()
		then
			GoToFail( Var )
			return
		end

		return
	end


	-- 1�ʸ��� üũ
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	if Var["InitDungeon"] == nil
	then
		DebugLog( "Start InitDungeon" )

		Var["InitDungeon"] = {}
		Var["InitDungeon"]["WaitSecDuringInit"] = Var["CurSec"] + DelayTime["AfterInit"]
	end


	-- ���� �ð� �� ���� �ܰ��
	if Var["InitDungeon"]["WaitSecDuringInit"] <= Var["CurSec"]
	then
		GoToNextStep( Var )
		Var["InitDungeon"] = nil
		DebugLog( "End InitDungeon" )
	end

end


-- �������� ������
function SpyLie( Var )
	cExecCheck( "SpyLie" )

	if Var == nil
	then
		return
	end


	-- 1�ʸ��� üũ
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	if Var["SpyLie"] == nil
	then
		DebugLog( "Start SpyLie" )

		-- ���� �׷� ����
		for i = 1, #RegenInfo["Group"]["InitDungeonRegen"]
		do
			cGroupRegenInstance( Var["MapIndex"], RegenInfo["Group"]["InitDungeonRegen"][i] )
		end

		-- ���(������) ����
		local RegenGuard	= RegenInfo["NPC"]["NPC_Guard"]
		local GuardHandle	= cMobRegen_XY( Var["MapIndex"], RegenGuard["Index"], RegenGuard["x"],RegenGuard["y"], RegenGuard["dir"] )

		if GuardHandle ~= nil
		then
			Var["Friend"]["NPC_Guard"] = GuardHandle
		end

		-- ���(������) ä�� ����
		Var["SpyLie"] 					= {}
		Var["SpyLie"]["ChatStepSec"] 	= Var["CurSec"]
		Var["SpyLie"]["ChatStepNo"]		= 1
	end


	-- ���(������) ä��
	if Var["SpyLie"]["ChatStepNo"] <= #NPC_GuardChat["SpyLieChat"]
	then
		if Var["SpyLie"]["ChatStepSec"] <= Var["CurSec"]
		then
			if Var["Friend"]["NPC_Guard"] ~= nil
			then
				cMobChat( Var["Friend"]["NPC_Guard"], NPC_GuardChat["ScriptFileName"], NPC_GuardChat["SpyLieChat"][ Var["SpyLie"]["ChatStepNo"] ]["Index"], true )
			end

			Var["SpyLie"]["ChatStepSec"] 	= Var["SpyLie"]["ChatStepSec"] + DelayTime["BetweenSpyLieChat"]
			Var["SpyLie"]["ChatStepNo"]  	= Var["SpyLie"]["ChatStepNo"] + 1
		end
	else
		if Var["Friend"]["NPC_Guard"] ~= nil
		then
			cNPCVanish( Var["Friend"]["NPC_Guard"] )
		end

		GoToNextStep( Var )
		Var["SpyLie"] = nil
		DebugLog( "End SpyLie" )
	end

end


-- �������� ����
function SpyReport( Var )
	cExecCheck( "SpyReport" )

	if Var == nil
	then
		return
	end


	-- 1�ʸ��� üũ
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	if Var["SpyReport"] == nil
	then
		DebugLog( "Start SpyReport" )

		-- �߰� ����(����, ����) ����
		local VirMaraRegenInfo		= RegenInfo["Mob"]["MiddleBoss"]["VirtualMara"]
		local VirMarloneRegenInfo	= RegenInfo["Mob"]["MiddleBoss"]["VirtualMarlone"]
		local VirMaraHad			= nil
		local VirMarloneHnd			= nil

		VirMaraHad					= cMobRegen_XY( Var["MapIndex"], VirMaraRegenInfo["Index"],	   VirMaraRegenInfo["x"],    VirMaraRegenInfo["y"],    VirMaraRegenInfo["dir"] )
		VirMarloneHnd				= cMobRegen_XY( Var["MapIndex"], VirMarloneRegenInfo["Index"], VirMarloneRegenInfo["x"], VirMarloneRegenInfo["y"], VirMarloneRegenInfo["dir"] )

		if VirMaraHad ~= nil
		then
			cSetAIScript ( MainLuaScriptPath, VirMaraHad )
			cAIScriptFunc( VirMaraHad, "Entrance", "MiddleMaraDead" )

			Var["Enemy"]["VirtualMara"] = VirMaraHad
		end

		if VirMarloneHnd ~= nil
		then
			cSetAIScript ( MainLuaScriptPath, VirMarloneHnd )
			cAIScriptFunc( VirMarloneHnd, "Entrance", "MiddleMarloneDead" )

			Var["Enemy"]["VirtualMarlone"] = VirMarloneHnd
		end

		 -- ���̾� �α�(�������� ����) ����
		Var["SpyReport"] 							= {}
		Var["SpyReport"]["WaitSecDuringSpyReport"]	= Var["CurSec"] + DelayTime["BeforeSpyReportDialog"]
		Var["SpyReport"]["DialogStepSec"] 			= Var["SpyReport"]["WaitSecDuringSpyReport"]
		Var["SpyReport"]["DialogStepNo"] 			= 1

	end


	-- ���� �ð� �� ���̾� �α� ó��
	if Var["SpyReport"]["WaitSecDuringSpyReport"] > Var["CurSec"]
	then
		return
	end


	-- ���̾� �α�(�������� ����) ó��
	if Var["SpyReport"]["DialogStepNo"] <= #MiddleBossChat["SpyReportDialog"]
	then
		if Var["SpyReport"]["DialogStepSec"] <= Var["CurSec"]
		then
			local SpyReportDialog = MiddleBossChat["SpyReportDialog"][ Var["SpyReport"]["DialogStepNo"] ]
			cMobDialog( Var["MapIndex"], SpyReportDialog["FaceCut"], MiddleBossChat["ScriptFileName"], SpyReportDialog["Index"] )

			Var["SpyReport"]["DialogStepSec"]	= Var["SpyReport"]["DialogStepSec"] + DelayTime["BetweenSpyReportDialog"]
			Var["SpyReport"]["DialogStepNo"]	= Var["SpyReport"]["DialogStepNo"] + 1
		end
	else
		-- ŷ�� ����Ʈ ���� ����
		local nLimitSec = cGetKQLimitSecond( Var["MapIndex"] )

		if nLimitSec == nil
		then
			ErrorLog( "InitDungeon::nLimitSec == nil" )
		else
			Var["KQLimitTime"] = Var["CurSec"] + nLimitSec
			cShowKQTimerWithLife( Var["MapIndex"], nLimitSec )
		end

		GoToNextStep( Var )
		Var["SpyReport"] = nil
		return
	end

end


-- �߰� ����(����, ����)
function MiddleBoss( Var )
	cExecCheck( "MiddleBoss" )

	if Var == nil
	then
		return
	end


	--1�ʸ��� üũ
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	if Var["MiddleBoss"] == nil
	then
		DebugLog( "Start MiddleBoss" )

		-- ���� �׷� ����
		for i = 1, #RegenInfo["Group"]["MiddleBossRegen"]
		do
			cGroupRegenInstance( Var["MapIndex"], RegenInfo["Group"]["MiddleBossRegen"][i] )
		end

		Var["MiddleBoss"] = {}

	end


	-- Fail Case : ���� �� Ȥ�� �÷��̾ �ƹ��� ���� ���
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["MiddleBoss"] = nil
		return
	end


	-- Fail Case : Ÿ�� ����
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["MiddleBoss"] = nil
		return
	end


	-- �߰� ����(����, ����)�� �׾����� üũ
	local VirtualMaraDied		= false
	local VirtualMarloneDied	= false

	if Var["Enemy"]["VirtualMara"] == nil
	then
		VirtualMaraDied = true
	else
		if cIsObjectDead( Var["Enemy"]["VirtualMara"] ) == 1
		then
			Var["Enemy"]["VirtualMara"] = nil
			VirtualMaraDied 			= true
		end
	end

	if Var["Enemy"]["VirtualMarlone"] == nil
	then
		VirtualMarloneDied = true
	else
		if cIsObjectDead( Var["Enemy"]["VirtualMarlone"] ) == 1
		then
			Var["Enemy"]["VirtualMarlone"]	= nil
			VirtualMarloneDied 				= true
		end
	end


	-- Success Case : �߰� ����(����, ����) ����
	if VirtualMaraDied == true and VirtualMarloneDied == true
	then
		GoToNextStep( Var )
		Var["MiddleBoss"] = nil
		DebugLog( "End MiddleBoss" )
		return
	end

end


-- �߰� ���� ���� �� ����
function MiddleReport( Var )
	cExecCheck( "MiddleReport" )

	if Var == nil
	then
		return
	end


	-- 1�ʸ��� üũ
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	if Var["MiddleReport"] == nil
	then
		DebugLog( "Start MiddleReport" )

		-- ����(����, ����) ����
		local MaraRegenInfo			= RegenInfo["Mob"]["Boss"]["TrueMara"]
		local MarloneRegenInfo		= RegenInfo["Mob"]["Boss"]["TrueMarlone"]
		local TrueMaraHnd			= cMobRegen_XY( Var["MapIndex"], MaraRegenInfo["Index"], MaraRegenInfo["x"], MaraRegenInfo["y"], MaraRegenInfo["dir"] )
		local TrueMarloneHnd		= cMobRegen_XY( Var["MapIndex"], MarloneRegenInfo["Index"], MarloneRegenInfo["x"], MarloneRegenInfo["y"], MarloneRegenInfo["dir"] )

		if TrueMaraHnd ~= nil
		then
			cSetAIScript ( MainLuaScriptPath, TrueMaraHnd )
			cAIScriptFunc( TrueMaraHnd, "Entrance", "LastMaraDead" )

			Var["Enemy"]["TrueMara"] = TrueMaraHnd
		end

		if TrueMarloneHnd ~= nil
		then
			cSetAIScript ( MainLuaScriptPath, TrueMarloneHnd )
			cAIScriptFunc( TrueMarloneHnd, "Entrance", "LastMarloneDead" )

			Var["Enemy"]["TrueMarlone"] = TrueMarloneHnd
		end


		-- ��¥ ���� ��ȯ : ������ ��¥ ���� ��ȯ
		local VirMaraRegenInfo		= RegenInfo["Mob"]["Boss"]["VirtualMara"]
		local VirMarloneRegenInfo	= RegenInfo["Mob"]["Boss"]["VirtualMarlone"]

		for i = 1, VirMaraRegenInfo["RegenNumber"]
		do

			local VirMaraHnd = cMobRegen_XY( Var["MapIndex"], VirMaraRegenInfo["Index"], VirMaraRegenInfo["x"], VirMaraRegenInfo["y"], VirMaraRegenInfo["dir"] )

			if VirMaraHnd ~= nil
			then
				cSetAIScript ( MainLuaScriptPath, VirMaraHnd )
				cAIScriptFunc( VirMaraHnd, "Entrance", "VirtualMaraDead" )
			end

		end

		for i = 1, VirMarloneRegenInfo["RegenNumber"]
		do

			local VirMarloneHnd = cMobRegen_XY( Var["MapIndex"], VirMarloneRegenInfo["Index"], VirMarloneRegenInfo["x"], VirMarloneRegenInfo["y"], VirMarloneRegenInfo["dir"] )

			if VirMarloneHnd ~= nil
			then
				cSetAIScript ( MainLuaScriptPath, VirMarloneHnd )
				cAIScriptFunc( VirMarloneHnd, "Entrance", "VirtualMarloneDead" )
			end

		end

		-- ��¥ ���� ��ȯ : -
		local TmpMaraRegenInfo		= RegenInfo["Mob"]["Boss"]["TmpMara"]
		local TmpMarloneRegenInfo	= RegenInfo["Mob"]["Boss"]["TmpMarlone"]

		for i = 1, TmpMaraRegenInfo["RegenNumber"]
		do
			cMobRegen_XY( Var["MapIndex"], TmpMaraRegenInfo["Index"], TmpMaraRegenInfo["x"], TmpMaraRegenInfo["y"], TmpMaraRegenInfo["dir"] )
		end

		for i = 1, TmpMarloneRegenInfo["RegenNumber"]
		do
			cMobRegen_XY( Var["MapIndex"], TmpMarloneRegenInfo["Index"], TmpMarloneRegenInfo["x"], TmpMarloneRegenInfo["y"], TmpMarloneRegenInfo["dir"] )
		end


		-- ���̾� �α�(�߰� ����) ����
		Var["MiddleReport"] 					= {}
		Var["MiddleReport"]["DialogStepSec"] 	= Var["CurSec"]
		Var["MiddleReport"]["DialogStepNo"] 	= 1
	end


	-- Fail Case : ���� �� Ȥ�� �÷��̾ �ƹ��� ���� ���
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["MiddleBoss"] = nil
		return
	end


	-- Fail Case : Ÿ�� ����
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["MiddleBoss"] = nil
		return
	end


	-- ���̾� �α�(�߰� ����) ó��
	if Var["MiddleReport"]["DialogStepNo"] <= #MiddleBossChat["MiddleReportDialog"]
	then
		if Var["MiddleReport"]["DialogStepSec"] <= Var["CurSec"]
		then
			local MiddleReportDialog = MiddleBossChat["MiddleReportDialog"][ Var["MiddleReport"]["DialogStepNo"] ]
			cMobDialog( Var["MapIndex"], MiddleReportDialog["FaceCut"], MiddleBossChat["ScriptFileName"], MiddleReportDialog["Index"] )

			Var["MiddleReport"]["DialogStepSec"]	= Var["MiddleReport"]["DialogStepSec"] + DelayTime["BetweenMiddleReportDialog"]
			Var["MiddleReport"]["DialogStepNo"]		= Var["MiddleReport"]["DialogStepNo"] + 1
		end
	else
		GoToNextStep( Var )
		Var["MiddleReport"] = nil
		DebugLog( "End MiddleReport" )
		return
	end

end


-- ������ ����(����, ����)
function LastBoss( Var )
	cExecCheck( "LastBoss" )

	if Var == nil
	then
		return
	end


	-- 1�ʸ��� üũ
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	if Var["LastBoss"] == nil
	then
		DebugLog( "Start LastBoss" )

		Var["LastBoss"] = {}
	end


	-- Fail Case : ���� �� Ȥ�� �÷��̾ �ƹ��� ���� ���
	if cObjectCount( Var["MapIndex"], ObjectType["Player"] ) <= 0
	then
		GoToFail( Var )
		Var["MiddleBoss"] = nil
		return
	end


	-- Fail Case : Ÿ�� ����
	if IsKQTimeOver( Var ) == true
	then
		GoToFail( Var )
		Var["MiddleBoss"] = nil
		return
	end


	-- ������ ����(����, ����)�� �׾����� üũ
	local MaraDied		= false
	local MarloneDied	= false

	if Var["Enemy"]["TrueMara"] == nil
	then
		MaraDied = true
	else
		if cIsObjectDead( Var["Enemy"]["TrueMara"] ) == 1
		then
			MaraDied = true
		end
	end

	if Var["Enemy"]["TrueMarlone"] == nil
	then
		MarloneDied = true
	else
		if cIsObjectDead( Var["Enemy"]["TrueMarlone"] ) == 1
		then
			MarloneDied = true
		end
	end

	-- Success Case : ������ ����(����, ����) ����
	if MaraDied == true and MarloneDied == true
	then
		GoToSuccess( Var )
		Var["LastBoss"]	= nil
		DebugLog( "End LastBoss" )
		return
	end

end


-- ŷ�� ����Ʈ Ŭ����
function QuestSuccess( Var )
	cExecCheck( "QuestSuccess" )

	if Var == nil
	then
		return
	end


	-- 1�ʸ��� üũ
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	if Var["QuestSuccess"] == nil
	then
		-- Success ����
		cVanishTimer( Var["MapIndex"] )
		cQuestResult( Var["MapIndex"], "Success" )

		-- �÷��̾�� Ŭ���� ���� �ֱ�
		cReward( Var["MapIndex"], "KQ" )

		-- Quest Mob Kill ����
		cQuestMobKill_AllInMap( Var["MapIndex"], QuestMobKillInfo["QuestID"], QuestMobKillInfo["MobIndex"], QuestMobKillInfo["MaxKillCount"] )

		Var["QuestSuccess"] = {}
		Var["QuestSuccess"]["SuccessStepSec"] 	= Var["CurSec"]
		Var["QuestSuccess"]["SuccessStepNo"] 	= 1
	end


	GoToNextStep( Var )
	Var["QuestSuccess"] = nil

end


-- ŷ�� ����Ʈ ����
function QuestFailed( Var )
	cExecCheck( "QuestFailed" )

	if Var == nil
	then
		return
	end


	-- 1�ʸ��� üũ
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	if Var["QuestFailed"] == nil
	then
		-- Fail ����
		cVanishTimer( Var["MapIndex"] )
		cQuestResult( Var["MapIndex"], "Fail" )

		-- ���̾� �α�(ŷ�� ����Ʈ ����) ����
		Var["QuestFailed"] 							= {}
		Var["QuestFailed"]["DialogStepSec"] 		= Var["CurSec"]
		Var["QuestFailed"]["DialogStepNo"] 			= 1
	end


	-- ���̾� �α�(ŷ�� ����Ʈ ����) ó��
	if Var["QuestFailed"]["DialogStepNo"] <= #NPC_GuardChat["FailDialog"]
	then
		if Var["QuestFailed"]["DialogStepSec"] <= Var["CurSec"]
		then
			local FailDialog = NPC_GuardChat["FailDialog"][ Var["QuestFailed"]["DialogStepNo"] ]
			cMobDialog( Var["MapIndex"], FailDialog["FaceCut"], NPC_GuardChat["ScriptFileName"], FailDialog["Index"] )

			Var["QuestFailed"]["DialogStepSec"]	= Var["QuestFailed"]["DialogStepSec"] + DelayTime["BetweenKQFailedDialog"]
			Var["QuestFailed"]["DialogStepNo"]	= Var["QuestFailed"]["DialogStepNo"] + 1
		end
	else
		GoToNextStep( Var )
		Var["QuestFailed"] = {}
		return
	end

end


-- ��ȯ
function ReturnToHome( Var )
cExecCheck "ReturnToHome"

	if Var == nil
	then
		return
	end


	-- 1�ʸ��� üũ
	if Var["CurSec"] + 1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	if Var["ReturnToHome"] == nil
	then
		Var["ReturnToHome"] 					= {}
		Var["ReturnToHome"]["ReturnStepSec"] 	= Var["CurSec"]
		Var["ReturnToHome"]["ReturnStepNo"]  	= 1
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
			Var["ReturnToHome"]["ReturnStepSec"] = Var["CurSec"] + DelayTime["BetweenKQReturnNotice"]

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

			GoToNextStep( Var )
			Var["ReturnToHome"] = nil

			if cEndOfKingdomQuest( Var["MapIndex"] ) == nil
			then
				ErrorLog( "ReturnToHome::Function cEndOfKingdomQuest failed" )
			end
		end

		return

	end


end


-- ���� ������ ���� ���� ���� �Լ� ����Ʈ
KQ_StepsList =
{
	{ Function = InitDungeon,  Name = "InitDungeon",  },
	{ Function = SpyLie,       Name = "SpyLie",       },
	{ Function = SpyReport,    Name = "SpyReport",    },
	{ Function = MiddleBoss,   Name = "MiddleBoss",   },
	{ Function = MiddleReport, Name = "MiddleReport", },
	{ Function = LastBoss,     Name = "LastBoss",     },
	{ Function = QuestSuccess, Name = "QuestSuccess", },
	{ Function = QuestFailed,  Name = "QuestFailed",  },
	{ Function = ReturnToHome, Name = "ReturnToHome", },
}

-- ������ ����Ʈ
KQ_StepsIndexList =
{
}

for index, funcValue in pairs ( KQ_StepsList )
do
	KQ_StepsIndexList[ funcValue["Name"] ] = index
end
