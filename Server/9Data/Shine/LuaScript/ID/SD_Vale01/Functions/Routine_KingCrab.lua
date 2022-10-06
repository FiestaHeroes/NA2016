
--------------------------------------------------------------------------------
-- KingCrab :: ������
--------------------------------------------------------------------------------
function KC_WhirlWind( Handle, MapIndex )
cExecCheck "KC_WhirlWind"

	local Var = InstanceField[ MapIndex ]

	if Var["KingCrabProcess"]["SkillWorkTime"] > Var["CurSec"]
	then
		return ReturnAI["END"]
	end

	local SkillInfo = SkillInfo_KingCrab["KC_WhirlWind"]

	--------------------------------------------------------------------------------
	-- �� ������ ó����, �ѹ��� ����� �ϴ� �κ�(�ʱ�ȭ)
	--------------------------------------------------------------------------------
	if Var["KC_WhirlWind"] == nil
	then
		Var["KC_WhirlWind"] ={}
		--DebugLog("KC_WhirlWind ���̺� ����")

		------------------------------------------------------------------------------------------
		-- 1. �ӽ� Ÿ�� ����Ʈ ����
		-- ŷũ���� �����Ÿ� �ȿ� �ִ� �÷��̾� ����Ʈ �޾ƿ�
		Var["KC_WhirlWind"]["TargetList_Temp"]	= { cNearObjectList( Handle, SkillInfo["Target_SearchArea"], ObjectType["Player"] ) }
		--[[
		DebugLog("========================================================")
		DebugLog("TargetList_Temp Ÿ�ٸ���Ʈ")
		for i = 1, #Var["KC_WhirlWind"]["TargetList_Temp"]
		do
			DebugLog("Ÿ�� �ڵ�[ "..i.." ] :"..Var["KC_WhirlWind"]["TargetList_Temp"][i] )
		end

		DebugLog("========================================================")
		--]]

		Var["KC_WhirlWind"]["CurTargetNum"]			= 1
		Var["KC_WhirlWind"]["CurTargetHandle"]		= INVALID_HANDLE
		Var["KC_WhirlWind"]["IsFollowState"] 		= false
		Var["KC_WhirlWind"]["PathListEachTarget"] 	= {}		-- Ÿ�ٺ��� path �����ϴ� ���̺�

		------------------------------------------------------------------------------------------
		-- 2. ���ǿ� �´� �÷��̾��Ʈ �ٽ� ����( �켱���� ���ǿ� �°� )
		Var["KC_WhirlWind"]["TargetList"] = {}



		-- TargetList_Temp ����, ������ �켱���� ������ �ο��Ѵ�.
		for i, v in pairs( Var["KC_WhirlWind"]["TargetList_Temp"] )
		do
			-- �켱���� ���� �ʱ�ȭ
			Var["KC_WhirlWind"]["TargetList"][v] = 0

			------------------------------------------------------------------------------------------
			-- 1 ) ������ ���� üũ.
			local Priority_Class 		= SkillInfo["Target_Priority"]["ChrBaseClass"]
			local charBaseClassNum 		= cGetBaseClass( v )

			--DebugLog("charBaseClassNum : "..charBaseClassNum)

			for i = 1, #Priority_Class
			do
				if Priority_Class[i]["class"] == charBaseClassNum
				then
					Var["KC_WhirlWind"]["TargetList"][v] = Var["KC_WhirlWind"]["TargetList"][v] + Priority_Class[i]["arg"]
					--DebugLog("���������� "..charBaseClassNum..", ���� +"..Priority_Class[i]["arg"].." = "..Var["KC_WhirlWind"]["TargetList"][v] )
					break
				end
			end

			------------------------------------------------------------------------------------------
			-- 2 ) ������ �����̻� üũ.
			local Priority_AbState 		= SkillInfo["Target_Priority"]["ChrAbState"]

			for i = 1, #Priority_AbState
			do
				local strength, resttime = cGetAbstate( v, Priority_AbState[i]["Index"] )
				if strength ~= nil
				then
					Var["KC_WhirlWind"]["TargetList"][v] = Var["KC_WhirlWind"]["TargetList"][v] + Priority_AbState[i]["arg"]
					--DebugLog("�������´� "..Priority_AbState[i]["Index"]..", ���� +"..Priority_AbState[i]["arg"].." = "..Var["KC_WhirlWind"]["TargetList"][v])
				end
			end
		end

		-- ���� ������� Ÿ�ٸ���Ʈ TargetList�� ũ�⸦ ���, ���� ���´�.
		--DebugLog("Ÿ�ٸ���Ʈ ���")
		local TargetListSize = 0
		for i, v in pairs( Var["KC_WhirlWind"]["TargetList"] )
		do
			TargetListSize = TargetListSize + 1
			--DebugLog("TargetList["..i.."] = "..v)
		end

		Var["KC_WhirlWind"]["TargetListSize"] 	= TargetListSize
		Var["KC_WhirlWind"]["CurTargetHandle"] 	= PopMyTarget( Var["KC_WhirlWind"]["TargetList"] )

		--DebugLog("TargetList ũ���.. "..Var["KC_WhirlWind"]["TargetListSize"] )
		--DebugLog("ù Ÿ���� .."..Var["KC_WhirlWind"]["CurTargetHandle"])

		------------------------------------------------------------------------------------------
		-- 3. ŷũ���� �����̻� �ɾ��ش�( �����ͷ� ó���� )
		--		StaSDVale01_Wheel	: ���� �ִϸ��̼� �� �ֺ� ������ ��

		local AbStateList = SkillInfo["AbState_To_KingCrab"]

		-- ��ų�����Ϳ� �����̻� �ɵ��� �����Ǿ�������, keeptime ���� �� ���� ������ ��ų ������ �� �ִ� ��츦 �����, �ٽ� ����
		cSetAbstate( Handle, AbStateList["SpinDamage"]["Index"], 	AbStateList["SpinDamage"]["Strength"], 		AbStateList["SpinDamage"]["KeepTime"], 		Handle )
		cSetAbstate( Handle, AbStateList["NotTargetted"]["Index"], 	AbStateList["NotTargetted"]["Strength"], 	AbStateList["NotTargetted"]["KeepTime"], 	Handle )

		-- �̸� ���� Ÿ�����ϰ��ִ� �÷��̾���� Ÿ���� ����
		local PlayerHandleList = { cGetPlayerList( Var["MapIndex"] ) }
		-- DebugLog( "�ʿ� �ִ� ������ �� : "..#PlayerHandleList )
		for i = 1, #PlayerHandleList
		do
			cTargetChangeNull( PlayerHandleList[i], Handle )
		end
	end

	------------------------------------------------------------------------------------------
	-- 4. Ÿ�ٵ����ϸ���Ʈ[1] = {}�� ����, Ÿ�ٸ���Ʈ[1]�� �ڵ鰪�� �̿��� 5���� ������ǥ���� ��´�.
	--		Ÿ�ٵ����ϸ���Ʈ[1][1]["x"] = 2,
	--		Ÿ�ٵ����ϸ���Ʈ[1][1]["y"] = 2,
	--		.....
	--		Ÿ�ٵ����ϸ���Ʈ[1][5]["x"] = 2,
	--		Ÿ�ٵ����ϸ���Ʈ[1][5]["y"] = 2,

	--		Ÿ�ٵ����ϸ���Ʈ ������ #Ÿ�ٸ���Ʈ ��ŭ ����

	--------------------------------------------------------------------------------
	-- �� Var["KC_WhirlWind"] ���̺� ������ �� ó���� �κ�
	--------------------------------------------------------------------------------

	if Var["KC_WhirlWind"] ~= nil
	then
		local CurTargetNum			= Var["KC_WhirlWind"]["CurTargetNum"]
		local CurTargetHandle 		= Var["KC_WhirlWind"]["CurTargetHandle"]

		--------------------------------------------------------------------------------
		-- �� ������ �ִ� ���ӽð��� üũ�Ѵ�. � �ൿ���̴���, �� �ð��� ������ ������ ������ ��ų�� ���������´�.
		--------------------------------------------------------------------------------
		if Var["KingCrabProcess"]["SkillEndTime"] <= Var["CurSec"]
		then
			--DebugLog("�ð� �ʰ�! �ൿ����!")
			local AbStateList = SkillInfo["AbState_To_KingCrab"]

			-- ������ �����̻� ����
			cResetAbstate( Handle, AbStateList["SpinDamage"]["Index"] )
			cResetAbstate( Handle, AbStateList["NotTargetted"]["Index"] )

			Var["KC_WhirlWind"] 						= nil

			Var[Handle]["IsProgressSpecialSkill"] 		= false

			Var["KingCrabProcess"]["SkillStartTime"]	= 0
			Var["KingCrabProcess"]["SkillWorkTime"]		= 0
			Var["KingCrabProcess"]["SkillEndTime"]		= 0

			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end

		--------------------------------------------------------------------------------
		-- �� Ÿ�ٸ���Ʈ�� ���� ������ ������ �ִ� ���
		--------------------------------------------------------------------------------
		-- ������ Ÿ���� ����������,

		if CurTargetNum <= Var["KC_WhirlWind"]["TargetListSize"]
		then
			-- Ÿ�� �ڵ鰪�� �����Ƿ�, ���� Ÿ������ ����
			if CurTargetHandle == nil or CurTargetHandle == INVALID_HANDLE
			then
				--DebugLog("�ش� Ÿ���� �ڵ鰪 == nil or INVALID_HANDLE, ���� Ÿ������ ����")
				Var["KC_WhirlWind"]["IsFollowState"] 	= false
				Var["KC_WhirlWind"]["CurTargetNum"] 	= Var["KC_WhirlWind"]["CurTargetNum"] + 1
				Var["KC_WhirlWind"]["CurTargetHandle"] 	= PopMyTarget( Var["KC_WhirlWind"]["TargetList"] )

				return ReturnAI["END"]
			end

			-- Ÿ���� �̹� �׾����Ƿ�, ���� Ÿ������ ����
			if cIsObjectDead( CurTargetHandle ) == 1 or cIsObjectAlreadyDead( CurTargetHandle ) == 1
			then
				--DebugLog("Ÿ���� �װų� ����, ���� Ÿ������ ����")
				Var["KC_WhirlWind"]["IsFollowState"] 	= false
				Var["KC_WhirlWind"]["CurTargetNum"] 	= Var["KC_WhirlWind"]["CurTargetNum"] + 1
				Var["KC_WhirlWind"]["CurTargetHandle"] 	= PopMyTarget( Var["KC_WhirlWind"]["TargetList"] )

				return ReturnAI["END"]
			end


			local PathList = Var["KC_WhirlWind"]["PathListEachTarget"]
			--------------------------------------------------------------------------------
			-- �� �ش� Ÿ���� ���� path ����Ʈ�� ������� ���� ������, ����Ʈ�� �����Ѵ�.
			--------------------------------------------------------------------------------
			if PathList[CurTargetHandle] == nil
			then
				-- Ÿ�ٰ��� �Ÿ��� �ʹ� �ָ�, ���� Ÿ������ ����
				local distanceWithTarget = cDistanceSquar( Handle, CurTargetHandle )
				--DebugLog("Ÿ�ٰ��� �Ÿ�["..CurTargetHandle.."] : "..distanceWithTarget)

				if cDistanceSquar( Handle, CurTargetHandle ) > ( SkillInfo["Target_Distance"] * SkillInfo["Target_Distance"] )
				then
					--DebugLog("Ÿ�ٰ��� �Ÿ��� �ʹ� �ִ�.. ���� Ÿ������ ����")
					Var["KC_WhirlWind"]["IsFollowState"] 	= false
					Var["KC_WhirlWind"]["CurTargetNum"] 	= Var["KC_WhirlWind"]["CurTargetNum"] + 1
					Var["KC_WhirlWind"]["CurTargetHandle"] 	= PopMyTarget( Var["KC_WhirlWind"]["TargetList"] )

					return ReturnAI["END"]
				end


				--DebugLog("Ÿ��"..CurTargetHandle.."�� path ��������")

				PathList[CurTargetHandle] 					= {}
				PathList[CurTargetHandle]["CurPathNum"] 	= 1

				-- ù��° path�� ������ �ִ� �ڸ�
				PathList[CurTargetHandle][1] 		= {}
				PathList[CurTargetHandle][1]["x"],
				PathList[CurTargetHandle][1]["y"] 	= cObjectLocate( CurTargetHandle )

				PathList[CurTargetHandle][1]["x"]	= PathList[CurTargetHandle][1]["x"] + 5
				PathList[CurTargetHandle][1]["y"]	= PathList[CurTargetHandle][1]["y"] + 5

				-- 2��° ���ĺ����� path�� ���� ���� ��ǥ ���� ���� ��ǥ ����
				for i = 2, SkillInfo["PathListEachTarget"]["ListNum"]
				do
					local Dir				= cRandomInt( 1, 90 ) * 4
					local LocateX, LocateY	= cGetAroundCoord( CurTargetHandle, Dir, SkillInfo["PathListEachTarget"]["Distance"] )

					PathList[CurTargetHandle][i] 		= {}
					PathList[CurTargetHandle][i]["x"] 	= LocateX
					PathList[CurTargetHandle][i]["y"] 	= LocateY
				end

				--[[
				-- ������. ���� Ÿ���� PathList ���
				for i = 1, SkillInfo["PathListEachTarget"]["ListNum"]
				do
					DebugLog("���� Ÿ�� "..CurTargetHandle.."�� [ "..i.." ][\"x\"]"..PathList[CurTargetHandle][i]["x"])
					DebugLog("���� Ÿ�� "..CurTargetHandle.."�� [ "..i.." ][\"y\"]"..PathList[CurTargetHandle][i]["y"])
				end
				--]]
			end

			--------------------------------------------------------------------------------
			-- �� �ش� Ÿ���� ���� path ����Ʈ�� ������� ������
			--------------------------------------------------------------------------------
			-- ���� Ÿ���� ��������Ʈ�� ������� �ִٸ�, ������ �°� cRunTo�Ѵ�.
			if PathList[CurTargetHandle] ~= nil
			then

				local CurPathNum = PathList[CurTargetHandle]["CurPathNum"]

				-- Ÿ�� ��������Ʈ ���� ������ ���������� �����ִ°��,
				if CurPathNum <= SkillInfo["PathListEachTarget"]["ListNum"]
				then

					-- ���� path�� �����ϰ� �ִ� ���°� �ƴϸ�, Ÿ�� ���� ����
					if Var["KC_WhirlWind"]["IsFollowState"] == false
					then
						-- ������ ��ǥ���� nil�̶��, ���� Ÿ������!
						-- cRunTo ���� ������ ��ǥ�� nil�� ������ ����ó�� �ȵ��ֵ���...�׷��� ��⼭ �̸� �������,
						if PathList[CurTargetHandle][CurPathNum]["x"] == nil or PathList[CurTargetHandle][CurPathNum]["y"] == nil
						then
							--DebugLog("CurTargetHandle�� path�� nil�̶�, ���� Ÿ������ �̵�")
							PathList[CurTargetHandle] = nil
							Var["KC_WhirlWind"]["CurTargetNum"] = Var["KC_WhirlWind"]["CurTargetNum"] + 1
							return ReturnAI["END"]
						end

						if cRunTo( Handle, PathList[CurTargetHandle][CurPathNum]["x"], PathList[CurTargetHandle][CurPathNum]["y"], SkillInfo["SpeedRate"] ) == nil
						then
							--DebugLog("�޷����� ����")
							return ReturnAI["END"]
						end
						Var["KC_WhirlWind"]["IsFollowState"] = true
						--DebugLog("��� path : "..CurPathNum)
					end


					-- ���� path�� �����ϰ� �ִ� ���¸�, �Ÿ��� üũ��
					if Var["KC_WhirlWind"]["IsFollowState"] == true
					then
						local myLocateX, myLocateY = cObjectLocate( Handle )

						--DebugLog("ŷũ�� x : "..myLocateX.."ŷũ�� y : "..myLocateY )
						--DebugLog("��ǥ��ǥ : "..PathList[CurTargetHandle][CurPathNum]["x"]..", "..PathList[CurTargetHandle][CurPathNum]["y"] )

						local dist =  cDistanceSquar( myLocateX, myLocateY, PathList[CurTargetHandle][CurPathNum]["x"], PathList[CurTargetHandle][CurPathNum]["y"] )

						-- �Ÿ��� ����� ��������� �ʾ�����,
						if dist > SkillInfo["PathListEachTarget"]["Distance"]
						then
							--DebugLog("������.."..dist)
							return ReturnAI["END"]
						end

						-- �Ÿ��� ����� �����������, ���� path�� ����
						--DebugLog("�Ÿ��� ����� ���������.. ���� path�� ����")
						PathList[CurTargetHandle]["CurPathNum"] = PathList[CurTargetHandle]["CurPathNum"] + 1
						--DebugLog("���� path : "..PathList[CurTargetHandle]["CurPathNum"] )

						Var["KC_WhirlWind"]["IsFollowState"] = false

						return ReturnAI["END"]
					end
				end

				-- Ÿ�� ��������Ʈ ������ �� ���Ƽ� �������� ����,
				-- ���� Ÿ������ �����Ѵ�.

				PathList[CurTargetHandle] = nil
				Var["KC_WhirlWind"]["CurTargetNum"] 	= Var["KC_WhirlWind"]["CurTargetNum"] + 1
				Var["KC_WhirlWind"]["CurTargetHandle"]	= PopMyTarget( Var["KC_WhirlWind"]["TargetList"] )

				--DebugLog("���� Ÿ���� path�� ��� ������!"..CurTargetHandle)
				--DebugLog("���� Ÿ��num��  : "..Var["KC_WhirlWind"]["CurTargetNum"] )

				return ReturnAI["END"]
			end

		end


		--------------------------------------------------------------------------------
		-- �� Ÿ�ٸ���Ʈ�� �ִ� ������ ��� �����Ϸ��� ���
		--------------------------------------------------------------------------------
		--DebugLog("��� Ÿ�� �����Ϸ�")

		local AbStateList = SkillInfo["AbState_To_KingCrab"]

		-- ������ �����̻� ����
		cResetAbstate( Handle, AbStateList["SpinDamage"]["Index"] )
		cResetAbstate( Handle, AbStateList["NotTargetted"]["Index"] )

		Var["KC_WhirlWind"] 						= nil

		Var[Handle]["IsProgressSpecialSkill"] 		= false

		Var["KingCrabProcess"]["SkillStartTime"]	= 0
		Var["KingCrabProcess"]["SkillWorkTime"]		= 0
		Var["KingCrabProcess"]["SkillEndTime"]		= 0

		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end
end


--------------------------------------------------------------------------------
-- KingCrab :: ��ȯ
--------------------------------------------------------------------------------

function KC_SummonBubble( Handle, MapIndex )
cExecCheck "KC_SummonBubble"

	local Var = InstanceField[ MapIndex ]

	if Var["KingCrabProcess"]["SkillWorkTime"] > Var["CurSec"]
	then
		return ReturnAI["END"]
	end

	local SkillInfo = SkillInfo_KingCrab["KC_SummonBubble"]

	--------------------------------------------------------------------------------
	-- �� KC_SummonBubble ó����, �ѹ��� ����� �ϴ� �κ�(�ʱ�ȭ)
	--------------------------------------------------------------------------------
	if Var["KC_SummonBubble"] == nil
	then
		Var["KC_SummonBubble"] = {}

		local AbStateList = SkillInfo["AbState_To_KingCrab"]

		cSetAbstate( Handle, AbStateList["NotTargetted"]["Index"], AbStateList["NotTargetted"]["Strength"], AbStateList["NotTargetted"]["KeepTime"], Handle )

		-- �̸� ���� Ÿ�����ϰ��ִ� �÷��̾���� Ÿ���� ����
		local PlayerHandleList = { cGetPlayerList( Var["MapIndex"] ) }
		--DebugLog( "�ʿ� �ִ� ������ �� : "..#PlayerHandleList )
		for i = 1, #PlayerHandleList
		do
			cTargetChangeNull( PlayerHandleList[i], Handle )
		end

		-- ���� ��ȯ�� ��ǥ�� x, y�� SummonRegenLocate ���̺� �����Ѵ�
		if Var["KC_SummonBubble"]["SummonRegenLocate"]  == nil
		then
			Var["KC_SummonBubble"]["SummonRegenLocate"] = {}

			local CurKingCrabX, CurKingCrabY = cObjectLocate( Handle )

			for i = 1, SkillInfo["SummonNum"]
			do
				Var["KC_SummonBubble"]["SummonRegenLocate"][i] 		= {}
				Var["KC_SummonBubble"]["SummonRegenLocate"][i]["x"],
				Var["KC_SummonBubble"]["SummonRegenLocate"][i]["y"] = cGetCoord_Circle( CurKingCrabX, CurKingCrabY, SkillInfo["SummonRadius"] )

				--[[
				-- ������, ���� ��ȯ�� ��ǥ ������ ���
				DebugLog("----["..i.."]----")
				DebugLog("SummonRegenLocate X :"..Var["KC_SummonBubble"]["SummonRegenLocate"][i]["x"])
				DebugLog("SummonRegenLocate Y :"..Var["KC_SummonBubble"]["SummonRegenLocate"][i]["y"])
				--]]
			end
		end

		-- ��ȯ�� �ð���, ��ȯ�� �� ���������� �ʱ�ȭ�Ѵ�
		if Var["KC_SummonBubble"]["SummonTime"] == nil
		then
			Var["KC_SummonBubble"]["SummonTime"] 		= Var["CurSec"]
			Var["KC_SummonBubble"]["CurSummonSequence"] = 1

			--DebugLog("SummonTime : "		..Var["CurSec"])
			--DebugLog("CurSummonSequence : "	..Var["KC_SummonBubble"]["CurSummonSequence"])
		end
	end


	--------------------------------------------------------------------------------
	-- �� Var["KC_SummonBubble"] ���̺� ������ �� ó���� �κ�
	--------------------------------------------------------------------------------
	if Var["KC_SummonBubble"] ~= nil
	then
		if Var["KC_SummonBubble"]["SummonTime"] ~= nil
		then

			if Var["KC_SummonBubble"]["SummonTime"] > Var["CurSec"]
			then
				return ReturnAI["END"]
			end

			if Var["KC_SummonBubble"]["CurSummonSequence"] <= SkillInfo["SummonNum"]
			then
				local CurSummonMob = Var["KC_SummonBubble"]["SummonRegenLocate"][Var["KC_SummonBubble"]["CurSummonSequence"]]

				local CurSummonHandle = cMobRegen_XY( MapIndex, SkillInfo["SummonIndex"], CurSummonMob["x"], CurSummonMob["y"] )

				if CurSummonHandle == nil
				then
					-- DebugLog("�� ���� ����"..Var["KC_SummonBubble"]["CurSummonSequence"] )
					-- �������� ������ ��ǥ�� ���� ���, �������� ���������� ������ ����ó���� �����ʴ´�.
					-- �׳� ���� �� �����ϵ��� �Ѿ��.
				end

				if CurSummonHandle ~= nil
				then
					if cSkillBlast( CurSummonHandle, CurSummonHandle, SkillInfo["SummonSkillIndex"] ) == nil
					then
						ErrorLog("�� ��ų������"..Var["KC_SummonBubble"]["CurSummonSequence"] )
					end
				end

				-- ���� �� ������ ���� ���� ����
				Var["KC_SummonBubble"]["CurSummonSequence"] 	= Var["KC_SummonBubble"]["CurSummonSequence"] + 1
				Var["KC_SummonBubble"]["SummonTime"]			= Var["KC_SummonBubble"]["SummonTime"] + SkillInfo["SummonTick"]

				--DebugLog("���� ������ �ð��� : "..Var["KC_SummonBubble"]["SummonTime"])

				return ReturnAI["END"]
			end

			-- �������̺� �� �������ϱ�, �ʱ�ȭ
			Var["KC_SummonBubble"]["SummonTime"] 		= nil
			Var["KC_SummonBubble"]["CurSummonSequence"] = nil
		end

		--------------------------------------------------------------------------------
		-- �� �� ��ȯ �۾��� �������Ƿ�, �� ���� �ö�͵� �Ǵ� �ð����� üũ�Ѵ�
		--------------------------------------------------------------------------------
		if Var["KingCrabProcess"]["SkillEndTime"] > Var["CurSec"]
		then
			--DebugLog("�ö���� �����..")
			return ReturnAI["END"]
		end

		if Var["KingCrabProcess"]["SkillEndTime"] <= Var["CurSec"]
		then
			--DebugLog("���� ������ �ö�� �ð�!")
			local AbStateList = SkillInfo["AbState_To_KingCrab"]

			cResetAbstate( Handle, AbStateList["NotTargetted"]["Index"] )

			Var["KC_SummonBubble"]						= nil

			-- ��ų ó�� �ٳ�������,
			Var[Handle]["IsProgressSpecialSkill"] 		= false

			Var["KingCrabProcess"]["SkillStartTime"]	= 0
			Var["KingCrabProcess"]["SkillWorkTime"]		= 0
			Var["KingCrabProcess"]["SkillEndTime"]		= 0

			cAIScriptSet( Handle )
			return ReturnAI["END"]
		end
	end

	return ReturnAI["END"]

end
