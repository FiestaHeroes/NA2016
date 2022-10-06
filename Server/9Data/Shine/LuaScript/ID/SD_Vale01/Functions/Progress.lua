--------------------------------------------------------------------------------
-- DummyProcess
--------------------------------------------------------------------------------
function DummyProcess( Var )
cExecCheck "DummyProcess"

	--DebugLog("��")
	return

end

--------------------------------------------------------------------------------
-- InitDungeon
--------------------------------------------------------------------------------
-- ���� �ʱ�ȭ
function InitDungeon( Var )
cExecCheck "InitDungeon"

	if Var == nil
	then
		return
	end

	-- �ν��Ͻ� ���� ���� ���� �÷��̾��� ù �α����� ��ٸ���.
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

		-- ���ð� ����
		Var["InitDungeon"]["WaitSecDuringInit"] 		= Var["CurSec"] + DelayTime["AfterInit"]
		Var["InitDungeon"]["DialogTime"] 				= Var["InitDungeon"]["WaitSecDuringInit"]
		Var["InitDungeon"]["DialogStep"]				= 1
	end

	-- ��� �� ���ó�� �ܰ��
	if Var["InitDungeon"]["WaitSecDuringInit"] > Var["CurSec"]
	then
		return
	end



	-- ���ó��
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
	-- KingCrabProcess : ŷũ�� ����ó��
	-----------------------------------------------------------------

	if Var["KingCrabProcess"] == nil
	then
		Var["KingCrabProcess"] = {}

		--DebugLog("===KingCrabProcess=========================")
		--DebugLog("ŷũ�� ���μ��� ���̺� ����")


		local RegenInfo 	= RegenInfoTable["KingCrab"]
		local Handle 		= INVALID_HANDLE

		-- �ʿ� �ִ� ��� ������ �ڵ� �޾ƿ´�
		local TargetHandleList 	= { cGetPlayerList(Var["MapIndex"]) }
		local RegenX, RegenY 	= RegenInfo["RegenX"], RegenInfo["RegenY"]

		-- �ʿ� 1�� �̻��� ������ ���� ���, �� �� �Ѹ��� ��ġ�� �����Ѵ�.
		-- �ʿ� ������ ���� ���, RegenInfoTable["KingCrab"]�� ���õ� ��ġ�� �����Ѵ�.
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
			ErrorLog("ŷũ�� ���� ����")
			Var["StepFunc"] 			= ReturnToHome
			--GoToFail( Var )
			return
		else
			--DebugLog("ŷũ�� �ڵ鰪�� : "..Handle)
		end

		-- ���ó��
		local CurMsg = ChatInfo["KingCrabProcess"]["AfterBossRegen"]
		if CurMsg ~= nil
		then
			-- ��? ���� ���� ��鸮�°� ���� �ʾƿ�?
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
		-- KingCrabProcess : ���� �ܰ�� �Ѿ �ð����� üũ
		-----------------------------------------------------------------
		-- ���� �ܰ�� �Ѿ �ð��� �ƴϸ�
		if Var["KingCrabProcess"]["NextStepWaitTime"] ~= nil
		then
			if Var["KingCrabProcess"]["NextStepWaitTime"] > Var["CurSec"]
			then
				--DebugLog("�����ܰ� �Ѿ�� �����...")
				return
			end

			Var["KingCrabProcess"] 	= nil
			Var[Handle]	 			= nil
			Var["StepFunc"] 		= KingSlimeProcess

			--DebugLog("���� ���� ���� : KingSlimeProcess")

			return
		end

		-----------------------------------------------------------------
		-- KingCrabProcess : ŷũ�� �׾����� üũ
		-----------------------------------------------------------------
		if cIsObjectDead( Handle ) == 1
		then
			--DebugLog("ŷũ�� �׾���!")
			if cAIScriptSet( Handle ) == nil
			then
				ErrorLog( "KingCrabProcess : ��ũ��Ʈ �ʱ�ȭ ����" )
			end

			-- ��� ó��
			local CurMsg = ChatInfo["KingCrabProcess"]["AfterBossDead"]
			if CurMsg ~= nil
			then
				-- �ؾȰ��� �ִ� �Ϲ����� ŷũ������ ���� �����Ⱑ �ٸ�����?
				cScriptMessage( Var["MapIndex"], CurMsg["Index"] )
			end

			-- ���� ����
			if RewardItemInfo["KingCrabProcess"] ~= nil
			then
				--DebugLog("KingCrabProcess �������� �����")
				local CurReward 	= RewardItemInfo["KingCrabProcess"]
				local RewardList 	= { cGetPlayerList(Var["MapIndex"]) }

				--DebugLog("RewardList ���� : "..#RewardList )

				-- �ʿ� �ִ� ���� ��, ���� ���� ���� �����鿡�� ������ �����Ѵ�.
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
		-- KingCrabProcess : ŷũ�� ��ų üũ
		-----------------------------------------------------------------
		if Var[Handle]["IsProgressSpecialSkill"] == false
		then

			local CurTime 	= Var["CurSec"]

			local CurMySkill, EndTime = cGetCurrentSkillInfo( Var["KingCrabProcess"]["Handle"] )

			-- ���� ��ų�����Ϳ� �ִ� ��ų ������� �ƴѰ��, üũ�� �ʿ�����Ƿ� ����
			if CurMySkill == nil
			then
				--DebugLog("��ų����߾ƴ�")
				return
			end

			-- �̹� ��ų �� �ð� ��������, �ǹ̾��� endtime ���̹Ƿ� return
			if EndTime == nil
			then
				--DebugLog("�ð� == nil")
				return
			end

			-- �̹� ��ų �� �ð� ��������, �ǹ̾��� endtime ���̹Ƿ� return
			if EndTime < CurTime
			then
				return
			end

			-- EndTime Ȯ���ϱ�,
			-- ���� EndTime�� 0���� ������ ����,
			-- ��ų�� ������ε� ��ai�� attack ���°� �ƴ϶�, �θ�Ŭ�������ϰ� �޾ƿ��⶧��

			--DebugLog("���� ��ų������ϳ���!")
			--[[
			DebugLog("---------------------------")
			DebugLog("KingCrabProcess : 	CurTime : "..CurTime )
			DebugLog("KingCrabProcess : 	CurMySkill : "..CurMySkill)
			DebugLog("KingCrabProcess : 	EndTime : "..EndTime)
			DebugLog("---------------------------")
			--]]

			-----------------------------------------------------------------
			-- �� ��ų�� �������� ���
			-----------------------------------------------------------------
			if CurMySkill == SkillInfo_KingCrab["KC_WhirlWind"]["SkillIndex"]
			then
				--DebugLog("KC_WhirlWind �����")

				Var["KingCrabProcess"]["SkillStartTime"]	= CurTime
				Var["KingCrabProcess"]["SkillWorkTime"]		= EndTime
				Var["KingCrabProcess"]["SkillEndTime"]		= EndTime + SkillInfo_KingCrab["KC_WhirlWind"]["SkillKeepTime"]

				--[[
				DebugLog("����ð��� : "			..Var["CurSec"] )
				DebugLog("��ų ������ �ð��� : "	..Var["KingCrabProcess"]["SkillStartTime"] )
				DebugLog("��ų�� �����ð��� : "		..Var["KingCrabProcess"]["SkillWorkTime"] )
				--]]

				-- ��ũ��Ʈ ����*******************************************
				if cSetAIScript ( MainLuaScriptPath, Handle ) ~= nil
				then
					if cAIScriptFunc( Handle, "Entrance", "KC_WhirlWind" ) == nil
					then
						ErrorLog("��ũ��Ʈ ���� ����")
						return
					end
				end

				-- ��ų ó�� ���̹Ƿ�
				Var[Handle]["IsProgressSpecialSkill"] 		= true

				return
			end

			-----------------------------------------------------------------
			-- �� ��ų�� ��ȯ�� ���
			-----------------------------------------------------------------

			if CurMySkill == SkillInfo_KingCrab["KC_SummonBubble"]["SkillIndex"]
			then
				DebugLog("KC_SummonBubble �����")

				Var["KingCrabProcess"]["SkillStartTime"]	= CurTime
				Var["KingCrabProcess"]["SkillWorkTime"]		= CurTime + SkillInfo_KingCrab["KC_SummonBubble"]["SummonStartDelay"]
				Var["KingCrabProcess"]["SkillEndTime"]		= EndTime

				--[[
				DebugLog("����ð��� : "			..Var["CurSec"] )
				DebugLog("��ų ������ �ð��� : "	..Var["KingCrabProcess"]["SkillStartTime"] )
				DebugLog("��ųó�������ð��� : "	..Var["KingCrabProcess"]["SkillWorkTime"] )
				DebugLog("��ų�� �����ð��� : "		..Var["KingCrabProcess"]["SkillEndTime"] )
				--]]

				-- ��ũ��Ʈ ����*******************************************
				if cSetAIScript ( MainLuaScriptPath, Handle ) ~= nil
				then
					if cAIScriptFunc( Handle, "Entrance", "KC_SummonBubble" ) == nil
					then
						ErrorLog("��ũ��Ʈ ���� ����")
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
	-- KingSlimeProcess : Var["KingSlimeProcess"] ���̺� �ʱ�ȭ�۾�
	-----------------------------------------------------------------
	if Var["KingSlimeProcess"] == nil
	then
		Var["KingSlimeProcess"] = {}

		--DebugLog("===KingSlimeProcess=========================")
		--DebugLog("ŷ������ ���μ��� ���̺� ����")

		local RegenInfo 	= RegenInfoTable["KingSlime"]
		local Handle 		= INVALID_HANDLE

		-- �ʿ� �ִ� ��� ������ �ڵ� �޾ƿ´�
		local TargetHandleList 	= { cGetPlayerList(Var["MapIndex"]) }
		local RegenX, RegenY 	= RegenInfo["RegenX"], RegenInfo["RegenY"]

		-- �ʿ� 1�� �̻��� ������ ���� ���, �� �� �Ѹ��� ��ġ�� �����Ѵ�.
		-- �ʿ� ������ ���� ���, RegenInfoTable["KingCrab"]�� ���õ� ��ġ�� �����Ѵ�.
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
			ErrorLog("ŷ������ ���� ����")
			Var["StepFunc"] 			= ReturnToHome
			--GoToFail( Var )
			return
		else
			DebugLog("ŷ������ �ڵ鰪�� : "..Handle)
		end

		-- �� �������ڸ��� hide�����̻� �ɾ���!
		cSetAbstate( Handle, "StaHide", 1, 10000 )

		Var["KingSlimeProcess"]["Handle"]		= Handle

		Var[Handle]								= {}
		Var[Handle]["IsProgressSpecialSkill"]	= false

		-- ���ó��
		local CurMsg = ChatInfo["KingSlimeProcess"]["AfterBossRegen"]
		if CurMsg ~= nil
		then
			-- ��? �ٴڿ� �� �׸��ڴ� ����?
			cScriptMessage( Var["MapIndex"], CurMsg["Index"] )
		end

		local target = cObjectFind( Handle, 1000, ObjectType["Player"], "so_ObjectType" )		

		if cSkillBlast( Handle, target, SkillInfo_KingSlime["KS_ShowUp"]["SkillIndex"] ) == nil
		then
			ErrorLog("ŷ������ ������ ���ʳ��� ��ų ������")
		end

		return
	end

	-----------------------------------------------------------------
	-- KingSlimeProcess : Var["KingSlimeProcess"] ���̺� �ʱ�ȭ �� �۾�
	-----------------------------------------------------------------
	if Var["KingSlimeProcess"] ~= nil
	then
		local Handle = Var["KingSlimeProcess"]["Handle"]

		-----------------------------------------------------------------
		-- KingSlimeProcess : ���� �ܰ�� �Ѿ �ð����� üũ
		-----------------------------------------------------------------
		-- ���� �ܰ�� �Ѿ �ð��� �ƴϸ�
		if Var["KingSlimeProcess"]["NextStepWaitTime"] ~= nil
		then
			if Var["KingSlimeProcess"]["NextStepWaitTime"] > Var["CurSec"]
			then
				--DebugLog("�����ܰ� �Ѿ�� �����...")
				return
			end

			Var["KingSlimeProcess"] 	= nil
			Var[Handle]	 				= nil
			Var["StepFunc"] 			= MiniDragonProcess

			--DebugLog("���� ���� ���� : MiniDragonProcess")

			return
		end

		-----------------------------------------------------------------
		-- KingSlimeProcess : ŷ������ �׾����� üũ
		-----------------------------------------------------------------

		if cIsObjectDead( Handle ) == 1
		then
			--DebugLog("ŷ������ �׾���!")
			if cAIScriptSet( Handle ) == nil
			then
				ErrorLog( "KingSlimeProcess : ��ũ��Ʈ �ʱ�ȭ ����" )
			end

			-- ��� ó��
			local CurMsg = ChatInfo["KingSlimeProcess"]["AfterBossDead"]
			if CurMsg ~= nil
			then
				-- Ȯ���� ������ �ִ� �ؾȰ� ���͵��ϰ� ���� �޶������. �ٵ� �����ϼ���.
				cScriptMessage( Var["MapIndex"], CurMsg["Index"] )
			end

			-- ���� ����
			if RewardItemInfo["KingSlimeProcess"] ~= nil
			then
				--DebugLog("KingSlimeProcess �������� �����")
				local CurReward 	= RewardItemInfo["KingSlimeProcess"]
				local RewardList 	= { cGetPlayerList(Var["MapIndex"]) }

				--DebugLog("RewardList ���� : "..#RewardList )

				-- �ʿ� �ִ� ���� ��, ���� ���� ���� �����鿡�� ������ �����Ѵ�.
				for i = 1, #RewardList
				do
					if cIsObjectDead( RewardList[i] ) == nil
					then
						cRewardItem( RewardList[i], CurReward["Index"], CurReward["Num"] )
					end
				end

			end

			-- ���� ���ܽð� ����
			Var["KingSlimeProcess"]["NextStepWaitTime"] = Var["CurSec"] + DelayTime["WaitMiniDragonProcess"]

			return
		end

		-----------------------------------------------------------------
		-- KingSlimeProcess : ŷ������ ��ų ó�� üũ
		-----------------------------------------------------------------
		if Var[Handle]["IsProgressSpecialSkill"] == false
		then

			local CurTime 	= Var["CurSec"]

			local CurMySkill, EndTime = cGetCurrentSkillInfo( Handle )

			-- ���� ��ų�����Ϳ� �ִ� ��ų ������� �ƴѰ��, üũ�� �ʿ�����Ƿ� ����
			if CurMySkill == nil
			then
				--DebugLog("��ų����߾ƴ�")
				return
			end

			-- �̹� ��ų �� �ð� ��������, �ǹ̾��� endtime ���̹Ƿ� return
			if EndTime == nil
			then
				--DebugLog("�ð� == nil")
				return
			end

			-- �̹� ��ų �� �ð� ��������, �ǹ̾��� endtime ���̹Ƿ� return
			if EndTime < CurTime
			then
				return
			end

			-- EndTime Ȯ���ϱ�,
			--[[
			DebugLog("���� ��ų������ϳ���!")
			DebugLog("---------------------------")
			DebugLog("CurTime : "..CurTime )
			DebugLog("CurMySkill : "..CurMySkill)
			DebugLog("EndTime : "..EndTime)
			--]]

			-----------------------------------------------------------------
			-- �� ��ų�� ���ʳ����� ���( ������ �ٷ� ���� ��ų )
			-----------------------------------------------------------------
			if CurMySkill == SkillInfo_KingSlime["KS_ShowUp"]["SkillIndex"]
			then
				Var["KingSlimeProcess"]["SkillStartTime"]	= CurTime
				Var["KingSlimeProcess"]["SkillEndTime"]		= EndTime

				--[[
				DebugLog("����ð��� : "			..Var["CurSec"] )
				DebugLog("��ų ������ �ð��� : "	..Var["KingSlimeProcess"]["SkillStartTime"] )
				DebugLog("��ų�� �����ð��� : "		..Var["KingSlimeProcess"]["SkillEndTime"] )
				--]]

				-- ��ũ��Ʈ ����*******************************************
				if cSetAIScript ( MainLuaScriptPath, Handle ) ~= nil
				then
					if cAIScriptFunc( Handle, "Entrance", "KS_ShowUp" ) == nil
					then
						ErrorLog("��ũ��Ʈ ���� ����")
						return
					end
				end

				Var[Handle]["IsProgressSpecialSkill"] = true

				return
			end

			-----------------------------------------------------------------
			-- �� ��ų�� ������ ���
			-----------------------------------------------------------------
			if CurMySkill == SkillInfo_KingSlime["KS_Warp"]["SkillIndex"]
			then
				Var["KingSlimeProcess"]["SkillStartTime"]	= CurTime
				Var["KingSlimeProcess"]["SkillWorkTime"]	= CurTime + SkillInfo_KingSlime["KS_Warp"]["NotTargetStartDelay"]
				Var["KingSlimeProcess"]["SkillEndTime"]		= EndTime

				--[[
				DebugLog("����ð��� : "			..Var["CurSec"] )
				DebugLog("��ų ������ �ð��� : "	..Var["KingSlimeProcess"]["SkillStartTime"] )
				DebugLog("��ų�� �����ð��� : "		..Var["KingSlimeProcess"]["SkillEndTime"] )
				--]]

				-- ��ũ��Ʈ ����*******************************************
				if cSetAIScript ( MainLuaScriptPath, Handle ) ~= nil
				then
					if cAIScriptFunc( Handle, "Entrance", "KS_Warp" ) == nil
					then
						ErrorLog("��ũ��Ʈ ���� ����")
						return
					end
				end

				Var[Handle]["IsProgressSpecialSkill"] = true

				return
			end

			-----------------------------------------------------------------
			-- �� ��ų�� ��ȯ�� ���
			-----------------------------------------------------------------
			if 	CurMySkill == SkillInfo_KingSlime["KS_BombSlimePiece"]["SkillIndex_Lump"] or
				CurMySkill == SkillInfo_KingSlime["KS_BombSlimePiece"]["SkillIndex_Ice"] or
				CurMySkill == SkillInfo_KingSlime["KS_BombSlimePiece"]["SkillIndex_All"]
			then
				--DebugLog("KS_BombSlimePiece ��ȯ �����")

				Var["KingSlimeProcess"]["SkillStartTime"]	= CurTime
				Var["KingSlimeProcess"]["SkillWorkTime"]	= CurTime + SkillInfo_KingSlime["KS_BombSlimePiece"]["SummonStartDelay"]
				Var["KingSlimeProcess"]["SkillEndTime"]		= EndTime

				Var["KingSlimeProcess"]["CurSkillIndex"]	= CurMySkill

				--[[
				DebugLog("���� ����� ��ų�ε��� : "	..Var["KingSlimeProcess"]["CurSkillIndex"] )
				DebugLog("����ð��� : "				..Var["CurSec"] )
				DebugLog("��ų ������ �ð��� : "		..Var["KingSlimeProcess"]["SkillStartTime"] )
				DebugLog("��ųó�������ð��� : "		..Var["KingSlimeProcess"]["SkillWorkTime"] )
				DebugLog("��ų�� �����ð��� : "			..Var["KingSlimeProcess"]["SkillEndTime"] )
				--]]

				-- ��ũ��Ʈ ����*******************************************
				if cSetAIScript ( MainLuaScriptPath, Handle ) ~= nil
				then
					if cAIScriptFunc( Handle, "Entrance", "KS_BombSlimePiece" ) == nil
					then
						ErrorLog("��ũ��Ʈ ���� ����")
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
	-- MiniDragonProcess : �̴ϵ巡�� ����ó��
	-----------------------------------------------------------------

	if Var["MiniDragonProcess"] == nil
	then
		Var["MiniDragonProcess"] = {}

		--DebugLog("===MiniDragonProcess=========================")
		--DebugLog("�̴ϵ巡�� ���μ��� ���̺� ����")

		local RegenInfo 	= RegenInfoTable["MiniDragon"]
		local Handle 		= INVALID_HANDLE


		-- �ʿ� �ִ� ��� ������ �ڵ� �޾ƿ´�
		local TargetHandleList 	= { cGetPlayerList(Var["MapIndex"]) }
		local RegenX, RegenY 	= RegenInfo["RegenX"], RegenInfo["RegenY"]

		-- �ʿ� 1�� �̻��� ������ ���� ���, �� �� �Ѹ��� ��ġ�� �����Ѵ�.
		-- �ʿ� ������ ���� ���, RegenInfoTable["KingCrab"]�� ���õ� ��ġ�� �����Ѵ�.
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
			ErrorLog("�̴ϵ巡�� ���� ����")
			Var["StepFunc"] 			= ReturnToHome
			--GoToFail( Var )
			return
		else
			--DebugLog("�̴ϵ巡�� �ڵ鰪�� : "..Handle)
		end

		-- �� �������ڸ��� hide�����̻� �ɾ���!
		cSetAbstate( Handle, "StaHide", 1, 10000 )

		Var["MiniDragonProcess"]["Handle"]	= Handle

		-- �� ������ �ڵ鰪
		Var[Handle]									= {}
		Var[Handle]["IsProgressSpecialSkill"]		= false

		-- �̴ϵ巡�� ��ó�� �������� ��ų ����Ѵ�.
		local target = cObjectFind( Handle, 1000, ObjectType["Player"], "so_ObjectType" )

		if cSkillBlast( Handle, target, SkillInfo_MiniDragon["MD_ShowUp"]["SkillIndex"] ) == nil
		then
			ErrorLog("�̴ϵ巡��, ������ ���� ��ų ������")
		else
			--DebugLog("�̴ϵ巡��, ������ ���� ��ų ��������")
		end

		return
	end


	if Var["MiniDragonProcess"] ~= nil
	then
		local Handle = Var["MiniDragonProcess"]["Handle"]

		-----------------------------------------------------------------
		-- MiniDragonProcess : ���� �ܰ�� �Ѿ �ð����� üũ
		-----------------------------------------------------------------
		-- ���� �ܰ�� �Ѿ �ð��� �ƴϸ�
		if Var["MiniDragonProcess"]["NextStepWaitTime"] ~= nil
		then
			if Var["MiniDragonProcess"]["NextStepWaitTime"] > Var["CurSec"]
			then
				--DebugLog("�����ܰ� �Ѿ�� �����...")
				return
			end

			-- DebugLog("�̵� ���� �ð�.."..Var["MiniDragonProcess"]["BossDeadTime"])
			-- DebugLog("��ǥ�ð�.."..Var["InitialSec"] + LimitTime["ForBonusStage"])

			if Var["MiniDragonProcess"]["BossDeadTime"] < Var["InitialSec"] + LimitTime["ForBonusStage"]
			then
				Var["StepFunc"] 			= BonusStageProcess
				--DebugLog("�ð��ȿ� ��ġ���� ���ʽ��������� ����")
			else
				Var["StepFunc"] 			= ReturnToHome
				--DebugLog("�ð��ȿ� ����, ������Ȩ")
			end

			Var["MiniDragonProcess"] 	= nil
			Var[Handle]	 				= nil

			return
		end


		-----------------------------------------------------------------
		-- MiniDragonProcess : �̴ϵ巡�� �׾����� üũ
		-----------------------------------------------------------------

		if cIsObjectDead( Handle ) == 1
		then
			--DebugLog("�̴ϵ巡�� �׾���!")
			if cAIScriptSet( Handle ) == nil
			then
				DebugLog( "MiniDragonProcess : ��ũ��Ʈ �ʱ�ȭ ����" )
			end

			-- �̴ϵ巡�� ��ġ�� �ð� ����
			Var["MiniDragonProcess"]["BossDeadTime"]		= Var["CurSec"]

			-- ���� ����
			if RewardItemInfo["MiniDragonProcess"] ~= nil
			then
				--DebugLog("MiniDragonProcess �������� �����")
				local CurReward 	= RewardItemInfo["MiniDragonProcess"]
				local RewardList 	= { cGetPlayerList(Var["MapIndex"]) }

				--DebugLog("RewardList ���� : "..#RewardList )

				-- �ʿ� �ִ� ���� ��, ���� ���� ���� �����鿡�� ������ �����Ѵ�.
				for i = 1, #RewardList
				do
					if cIsObjectDead( RewardList[i] ) == nil
					then
						cRewardItem( RewardList[i], CurReward["Index"], CurReward["Num"] )
					end
				end

			end

			-- ���� ���ܽð� ����
			Var["MiniDragonProcess"]["NextStepWaitTime"] 	= Var["CurSec"] + DelayTime["WaitAfterMiniDragonProcess"]

			return
		end
	end


	-----------------------------------------------------------------
	-- MiniDragonProcess : �̴ϵ巡�� ��ų ó�� üũ
	-----------------------------------------------------------------
	local Handle = Var["MiniDragonProcess"]["Handle"]

	if Var[Handle]["IsProgressSpecialSkill"] == false
	then
		-- DebugLog("---------------------------")
		-- DebugLog("cGetCurrentSkillInfo ȣ��")

		local CurTime 	= Var["CurSec"]

		local CurMySkill, EndTime = cGetCurrentSkillInfo( Handle )

		-- ���� ��ų�����Ϳ� �ִ� ��ų ������� �ƴѰ��, üũ�� �ʿ�����Ƿ� ����
		if CurMySkill == nil
		then
			--DebugLog("��ų����߾ƴ�")
			return
		end

		-- �̹� ��ų �� �ð� ��������, �ǹ̾��� endtime ���̹Ƿ� return
		if EndTime == nil
		then
			--DebugLog("�ð� == nil")
			return
		end

		-- �̹� ��ų �� �ð� ��������, �ǹ̾��� endtime ���̹Ƿ� return
		if EndTime < CurTime
		then

		--[[
			DebugLog("��ų �̹� ��볡")

			DebugLog("---------------------------")
			DebugLog("CurTime : "..CurTime )
			DebugLog("CurMySkill : "..CurMySkill)
			DebugLog("EndTime : "..EndTime)
		--]]
			return
		end

		--DebugLog("���� ��ų������ϳ���!")
		--[[
		DebugLog("---------------------------")
		DebugLog("CurTime : "..CurTime )
		DebugLog("CurMySkill : "..CurMySkill)
		DebugLog("EndTime : "..EndTime)
		--]]


		-----------------------------------------------------------------
		-- �� ��ų�� ���� �� ������ ���
		-----------------------------------------------------------------
		if CurMySkill == SkillInfo_MiniDragon["MD_ShowUp"]["SkillIndex"]
		then
			--DebugLog("�̴ϵ巡��_������ ����")

			Var["MiniDragonProcess"]["SkillStartTime"]	= CurTime
			Var["MiniDragonProcess"]["SkillEndTime"]	= EndTime

			--[[
			DebugLog("����ð��� : "			..Var["CurSec"] )
			DebugLog("��ų ������ �ð��� : "	..Var["MiniDragonProcess"]["SkillStartTime"] )
			DebugLog("��ų �ִ� �� �ð��� : "	..Var["MiniDragonProcess"]["SkillEndTime"] )
			--]]
			-- ��ũ��Ʈ ����*******************************************
			if cSetAIScript ( MainLuaScriptPath, Handle ) ~= nil
			then
				if cAIScriptFunc( Handle, "Entrance", "MD_ShowUp" ) == nil
				then
					ErrorLog("MD_ShowUp ��ũ��Ʈ ���� ����")
					return
				end
			end

			Var[Handle]["IsProgressSpecialSkill"] = true

			return
		end

		-----------------------------------------------------------------
		-- �� ��ų�� ��ȯ�� ���
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
			DebugLog("���� ����� ��ų�ε��� : "		..Var["MiniDragonProcess"]["CurSkillIndex"] )
			DebugLog("����ð��� : "					..Var["CurSec"] )
			DebugLog("��ų ������ �ð��� : "			..Var["MiniDragonProcess"]["SkillStartTime"] )
			DebugLog("��ųó�������ð��� : "			..Var["MiniDragonProcess"]["SkillWorkTime"] )
			DebugLog("��ų�ִϳ� �ð��� : "				..Var["MiniDragonProcess"]["SkillEndTime"] )
			--]]

			-- ��ũ��Ʈ ����*******************************************
			if cSetAIScript ( MainLuaScriptPath, Handle ) ~= nil
			then
				if cAIScriptFunc( Handle, "Entrance", "MD_SummonSoul" ) == nil
				then
					ErrorLog("MD_SummonSoul ��ũ��Ʈ ���� ����")
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
	-- BonusStageProcess : ���ʽ��� ����ó��
	-----------------------------------------------------------------

	if Var["BonusStageProcess"] == nil
	then
		Var["BonusStageProcess"] = {}

		--DebugLog("===BonusStageProcess=========================")
		--DebugLog("BonusStageProcess ���μ��� ���̺� ����")

		local RegenInfo 	= RegenInfoTable["BonusMob"]
		local Handle 		= cMobRegen_XY( Var["MapIndex"], RegenInfo["MobIndex"], RegenInfo["RegenX"], RegenInfo["RegenY"], RegenInfo["Dir"] )

		if Handle == nil
		then
			ErrorLog("���ʽ��� ���� ����")
			--GoToFail( Var )
			Var["StepFunc"] 			= ReturnToHome
			return
		else
			--DebugLog("���ʽ��� �ڵ鰪�� : "..Handle)
		end

		Var["BonusStageProcess"]["Handle"]	= Handle

		-- ���ó��
		local CurMsg = ChatInfo["BonusStageProcess"]["AfterBossRegen"]
		cScriptMessage( Var["MapIndex"], CurMsg["Index"] )

		return
	end

	-----------------------------------------------------------------
	-- BonusStageProcess : ���ʽ��� �׾����� üũ
	-----------------------------------------------------------------
	if Var["BonusStageProcess"] ~= nil
	then
		local Handle = Var["BonusStageProcess"]["Handle"]

		-----------------------------------------------------------------
		-- BonusStageProcess : ���� �ܰ�� �Ѿ �ð����� üũ
		-----------------------------------------------------------------
		-- ���� �ܰ�� �Ѿ �ð��� �ƴϸ�
		if Var["BonusStageProcess"]["NextStepWaitTime"] ~= nil
		then
			if Var["BonusStageProcess"]["NextStepWaitTime"] > Var["CurSec"]
			then
				--DebugLog("�����ܰ� �Ѿ�� �����...")
				return
			end

			Var["BonusStageProcess"] 	= nil
			Var["StepFunc"] 			= ReturnToHome

			--DebugLog("���� ���� ���� : ReturnToHome")

			return
		end


		-----------------------------------------------------------------
		-- BonusStageProcess : ���ʽ��� �׾����� üũ
		-----------------------------------------------------------------
		if cIsObjectDead( Handle ) == 1
		then
			--DebugLog("���ʽ��� �׾���!")

			-- ���� ����
			if RewardItemInfo["BonusStageProcess"] ~= nil
			then
				--DebugLog("BonusStageProcess �������� �����")
				local CurReward 	= RewardItemInfo["BonusStageProcess"]
				local RewardList 	= { cGetPlayerList(Var["MapIndex"]) }

				--DebugLog("RewardList ���� : "..#RewardList )

				for i = 1, #RewardList
				do
					-- ���⼭ �ٽ� ó���� ����ߵǳ�? �����ֵ� ���°� ����,
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
-- ��ȯ
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

		-- ��� ���� ����
		cMobSuicide( Var["MapIndex"] )

		-- �Ա��� �ⱸ����Ʈ ����
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

		-- ���ó��
		local CurMsg = ChatInfo["ReturnToHome"]
		cScriptMessage( Var["MapIndex"], CurMsg["Index"] )
	end

	Var["StepFunc"]				= DummyProcess
	Var["ReturnToHome"] 		= nil
	DebugLog( "End ReturnToHome" )
	return

end


