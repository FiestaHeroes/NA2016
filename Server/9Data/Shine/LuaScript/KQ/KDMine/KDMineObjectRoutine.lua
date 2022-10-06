--[[*****																*****]]--
--[[*****							�� ó�� ��ƾ ����					*****]]--
--[[*****		: ��ȯ�Ǿ� ��� �ʿ���� ���� ������ ������ ó��		*****]]--
--[[*****																*****]]--
function MobRoutine( Handle, MapIndex )

	if InstanceField[MapIndex] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if InstanceField[MapIndex]["WaveRunner"] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[MapIndex]["WaveRunner"][Handle]

	if Var == nil then
		cAIScriptSet( Handle )
		-- �߰� ���� 6. ���Ͱ� ��å�� �ε��� ��, �״� �ִϸ��̼� ó��
		-- cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then
		cAIScriptSet( Handle )
		InstanceField[MapIndex]["WaveRunner"][Handle] = nil
		return ReturnAI["END"]
	end


	BoomMobProcess    ( Var ) -- ������ ó��
	SummonGroupProcess( Var ) -- ��ȯ�� �����ϴ°�� ó��
	EscortGroupProcess( Var ) -- ȣ���� �����ϴ°�� ó��
	EscortMobProcess  ( Var ) -- ȣ���� �̵� ó��
	PathTypeProcess   ( Var ) -- ��ΰ� �����ϴ°�� ó��


	-- ��ź Ÿ���� �̵� ó���� ���� AI ���
	local rtn = ReturnAI["END"]

	if Var["BoomTarget"] ~= nil then
		rtn = ReturnAI["CPP"]
	end

	return rtn

end




-- �̵� ���°� flag
MOVESTATE = {}
MOVESTATE["STOP"] = "STOP"
MOVESTATE["MOVE"] = "MOVE"




--[[																				]]--
--[[						BoomType�� ���� ��ź ó��								]]--
--[[																				]]--
function BoomMobProcess( Var )

	if Var == nil then
		return
	end

	if Var["BoomType"] == nil then
		return
	end


	if Var["BoomProgress"] == nil then

		local BoomProgress = {}

		BoomProgress["PlayerCheckTime"] = cCurrentSecond()

		Var["BoomProgress"] = BoomProgress

	end


	local CurSec = cCurrentSecond()

	-- �÷��̾� �˻� ���̱� ���� 1�ʿ� �ѹ� üũ
	if Var["BoomProgress"]["PlayerCheckTime"] + BOOMTYPE_CHK_DLY > CurSec then
		return
	end

	Var["BoomProgress"]["PlayerCheckTime"] = CurSec


	-- Ÿ���� ���� �ƴ��� üũ
	if Var["BoomTarget"] ~= nil then

		-- Ÿ���� ����� ��� Ÿ�� ����
		if cIsObjectDead( Var["BoomTarget"] ) then

			cAggroReset( Var["Handle"], Var["BoomTarget"] )
			Var["BoomTarget"] = nil

			return

		end


		local dist = cDistanceSquar( Var["Handle"], Var["BoomTarget"] )

		-- �Ÿ��� �־��� ��� Ÿ�� ����
		if dist > Var["BoomType"]["FollowInterval"] * Var["BoomType"]["FollowInterval"] then

			cAggroReset( Var["Handle"], Var["BoomTarget"] )
			Var["BoomTarget"] = nil

			return

		end

		-- �Ÿ� üũ �ؼ� �����̻� �ɾ���
		if dist <= (Var["BoomType"]["ExplosionGap"] * Var["BoomType"]["ExplosionGap"])  then

			if AbstateTypeTable[Var["BoomType"]["AbstateType"]] ~= nil then

				cSetAbstate( Var["BoomTarget"],
								AbstateTypeTable[Var["BoomType"]["AbstateType"]]["Index"],
								1,
								AbstateTypeTable[Var["BoomType"]["AbstateType"]]["KeepTime"],
								Var["Handle"] )

			end

			InstanceField[Var["MapIndex"]]["WaveRunner"][Var["Handle"]] = nil

			-- �߰� ���� 6. ���Ͱ� ��å�� �ε��� ��, �״� �ִϸ��̼� ó��
			cAIScriptSet( Var["Handle"] )
			cNPCVanish( Var["Handle"] )

			-- �� ���� ó�� �����ϱ� ���� nil�� �ʱ�ȭ
			Var = nil

			return

		end

	end


	-- Ÿ���� ã��
	local Target = cFindNearPlayer(	Var["Handle"],
									Var["BoomType"]["FollowInterval"],
									FollowTypeTable[Var["BoomType"]["FollowType"]] )

	if Target ~= nil then

		Var["BoomTarget"] = Target

		cAggroSet( Var["Handle"], Var["BoomTarget"], BOOM_AP )

		local speed
		local speedrate

		speed     = Var["MobSettingType"]["Speed"]
		speedrate = ( Var["BoomType"]["FollowSpeedRate"] / 1000 ) +
					( InstanceField[Var["MapIndex"]]["Balance"]["SpeedRate"] / 1000 )

		cSetNPCParam( Var["Handle"], "RunSpeed", speed * speedrate )

	end

end


--[[																				]]--
--[[						SummonType�� ���� �� ��ȯ ó��							]]--
--[[																				]]--
function SummonGroupProcess( Var )

	if Var == nil then
		return
	end

	if Var["SummonType"] == nil then
		return
	end


	if Var["SummonProgress"] == nil then

		local SummonProgress = {}

		SummonProgress["LastSummonTime"]  = cCurrentSecond()
		SummonProgress["PlayerCheckTime"] = cCurrentSecond()

		Var["SummonProgress"] = SummonProgress

	end


	local CurSec = cCurrentSecond()

	-- ��ȯ�ð� üũ
	if Var["SummonProgress"]["LastSummonTime"] + Var["SummonType"]["CoolTime"] > CurSec then
		return
	end

	-- �÷��̾� �˻� ���̱� ���� 1�ʿ� �ѹ� üũ
	if Var["SummonProgress"]["PlayerCheckTime"] + SUMMTYPE_CHK_DLY > CurSec then
		return
	end

	Var["SummonProgress"]["PlayerCheckTime"] = CurSec

	-- �ֺ� �÷��̾� üũ
	if cFindNearPlayer( Var["Handle"], Var["SummonType"]["CheckRange"], FollowTypeTable["All"] ) == nil then
		return
	end



	local CurSummonGroupType = SummonGroupTypeTable[Var["SummonType"]["SummonGroupType"]]

	for i=1, #CurSummonGroupType do

		local CurSummonMobType  = SummonMobTypeTable[CurSummonGroupType[i]["SummonMobType"]]
		local CurMobSettingData = MobSettingTypeTable[CurSummonMobType["MobSettingType"]]
		local RegenCoord        = {}
		local Dir               = CurSummonGroupType[i]["Dir"]

		if CurSummonGroupType[i]["Rotate"] == true then

			Dir = Dir + cGetDirect( Var["Handle"] )

		end

		RegenCoord["x"], RegenCoord["y"] = cGetAroundCoord( Var["Handle"], Dir, CurSummonGroupType[i]["Dist"] )

		-- ��ȯ�� ���� �� ����
		local RegenMob = {}
		RegenMob["Handle"]      = cMobRegen_XY( Var["MapIndex"],
													CurMobSettingData["Index"],
													RegenCoord["x"],
													RegenCoord["y"], 0 )
		if RegenMob["Handle"] ~= nil then

			RegenMob["MapIndex"]       = Var["MapIndex"]

			RegenMob["MobSettingType"] = MobSettingTypeTable[CurSummonMobType["MobSettingType"]]
			RegenMob["BoomType"]       = BoomTypeTable      [CurSummonMobType["BoomType"]      ]



			local DamageRate = (InstanceField[Var["MapIndex"]]["Balance"]["DamageRate"] + InstanceField[Var["MapIndex"]]["FenceBalance"]["DamageRate"]) / 2000
			local HPRate     = (InstanceField[Var["MapIndex"]]["Balance"]["HPRate"]     + InstanceField[Var["MapIndex"]]["FenceBalance"]["HPRate"])     / 2000
			local SpeedRate  = (InstanceField[Var["MapIndex"]]["Balance"]["SpeedRate"]  + InstanceField[Var["MapIndex"]]["FenceBalance"]["SpeedRate"])  / 2000

			RegenMob["Damage"]         = CurMobSettingData["Demage"]                   * DamageRate

			cSetNPCParam( RegenMob["Handle"], "MaxHP",    CurMobSettingData["HP"]      * HPRate )
			cSetNPCParam( RegenMob["Handle"], "HP",       CurMobSettingData["HP"]      * HPRate )
			cSetNPCParam( RegenMob["Handle"], "RunSpeed", CurMobSettingData["Speed"]   * SpeedRate )
			cSetNPCParam( RegenMob["Handle"], "HPRegen",  CurMobSettingData["HPRegen"] )
			cSetNPCParam( RegenMob["Handle"], "AC",       CurMobSettingData["AC"]      )
			cSetNPCParam( RegenMob["Handle"], "MR",       CurMobSettingData["MR"]      )
			cSetNPCParam( RegenMob["Handle"], "MobEXP",   CurMobSettingData["Exp"]     )
			cSetNPCResist( RegenMob["Handle"],            ResistTypeTable[CurSummonMobType["ResistType"]] )
			cSetNPCIsItemDrop( RegenMob["Handle"],        CurMobSettingData["ItemDrop"] )

			-- ������ �ɸ��� ���� �����̻� Ǯ����
			cResetAbstate( RegenMob["Handle"], ABSTATE_IMT_IDX )

			-- ��ȯ�ȸ� ��źŸ�� �� ��� ���� ����
			if RegenMob["BoomType"] ~= nil then

				cSetAIScript( SCRIPT_MAIN, RegenMob["Handle"] )
				cAIScriptFunc( RegenMob["Handle"], "Entrance", "MobRoutine" )

				InstanceField[Var["MapIndex"]]["WaveRunner"][RegenMob["Handle"]] = RegenMob

			end

		end

	end

	-- ��ȯ�ð� ����
	Var["SummonProgress"]["LastSummonTime"] = CurSec

end



--[[																				]]--
--[[						EscortGroupType�� ���� �� ��ȯ ó��						]]--
--[[																				]]--
function EscortGroupProcess( Var )

	if Var == nil then
		return
	end

	if Var["EscortGroupType"] == nil then
		return
	end



	for i=1, #Var["EscortGroupType"] do

		local CurSummonMobType  = SummonMobTypeTable[Var["EscortGroupType"][i]["SummonMobType"]]
		local CurMobSettingData = MobSettingTypeTable[CurSummonMobType["MobSettingType"]]
		local RegenCoord        = {}
		local Dir               = Var["EscortGroupType"][i]["Dir"]

		if Var["EscortGroupType"][i]["Rotate"] == true then

			Dir = Dir + cGetDirect( Var["Handle"] )

		end

		RegenCoord["x"], RegenCoord["y"] = cGetAroundCoord( Var["Handle"], Dir, Var["EscortGroupType"][i]["Dist"] )

		-- ȣ���� ���� �� ����
		local RegenMob = {}
		RegenMob["Handle"]      = cMobRegen_XY( Var["MapIndex"],
													CurMobSettingData["Index"],
													RegenCoord["x"],
													RegenCoord["y"], 0 )
		if RegenMob["Handle"] ~= nil then

			RegenMob["MapIndex"]    = Var["MapIndex"]

			RegenMob["MobSettingType"] = MobSettingTypeTable[CurSummonMobType["MobSettingType"]]
			RegenMob["BoomType"]       = BoomTypeTable      [CurSummonMobType["BoomType"]      ]
			-- ȣ���� ó�� ��������
			RegenMob["Master"]         = Var["Handle"]
			RegenMob["Rotate"]         = Var["EscortGroupType"][i]["Rotate"]
			RegenMob["Dir"]            = Var["EscortGroupType"][i]["Dir"]
			RegenMob["Dist"]           = Var["EscortGroupType"][i]["Dist"]


			local DamageRate = (InstanceField[Var["MapIndex"]]["Balance"]["DamageRate"] + InstanceField[Var["MapIndex"]]["FenceBalance"]["DamageRate"]) / 2000
			local HPRate     = (InstanceField[Var["MapIndex"]]["Balance"]["HPRate"]     + InstanceField[Var["MapIndex"]]["FenceBalance"]["HPRate"])     / 2000
			local SpeedRate  = (InstanceField[Var["MapIndex"]]["Balance"]["SpeedRate"]  + InstanceField[Var["MapIndex"]]["FenceBalance"]["SpeedRate"])  / 2000

			RegenMob["Damage"]         = CurMobSettingData["Demage"]                   * DamageRate

			cSetNPCParam( RegenMob["Handle"], "MaxHP",    CurMobSettingData["HP"]      * HPRate )
			cSetNPCParam( RegenMob["Handle"], "HP",       CurMobSettingData["HP"]      * HPRate )
			cSetNPCParam( RegenMob["Handle"], "RunSpeed", CurMobSettingData["Speed"]   * SpeedRate )
			cSetNPCParam( RegenMob["Handle"], "HPRegen",  CurMobSettingData["HPRegen"] )
			cSetNPCParam( RegenMob["Handle"], "AC",       CurMobSettingData["AC"]      )
			cSetNPCParam( RegenMob["Handle"], "MR",       CurMobSettingData["MR"]      )
			cSetNPCParam( RegenMob["Handle"], "MobEXP",   CurMobSettingData["Exp"]     )
			cSetNPCResist( RegenMob["Handle"],            ResistTypeTable[CurSummonMobType["ResistType"]] )
			cSetNPCIsItemDrop( RegenMob["Handle"],        CurMobSettingData["ItemDrop"] )

			-- ������ �ɸ��� ���� �����̻� Ǯ����
			cResetAbstate( RegenMob["Handle"], ABSTATE_IMT_IDX )


			cSetAIScript( SCRIPT_MAIN, RegenMob["Handle"] )
			cAIScriptFunc( RegenMob["Handle"], "Entrance", "MobRoutine" )

			-- ��ȯ�ȸ� ���� ����
			InstanceField[Var["MapIndex"]]["WaveRunner"][RegenMob["Handle"]] = RegenMob

		end

	end

	Var["EscortGroupType"] = nil

end



--[[																				]]--
--[[						EscortGroupProcess���� ��ȯ�� �� ó��					]]--
--[[																				]]--
function EscortMobProcess( Var )

	if Var == nil then
		return
	end

	if Var["Master"] == nil then
		return
	end

	-- ��ź Ÿ���ΰ�� Ÿ���� �����Ǹ� �̵�ó�� ����
	if Var["BoomType"] ~= nil then
		if Var["BoomTarget"] ~= nil then
			return
		end
	end


	-- �����Ͱ� �׾��� ��� ó��
	if cIsObjectDead( Var["Master"] ) then

		if Var["BoomType"] ~= nil then

			local ply = cFindNearPlayer( Var["Handle"], Var["BoomType"]["ExplosionGap"], FollowTypeTable["All"] )

			if ply ~= nil then

				local AbstateTypeData = AbstateTypeTable[Var["BoomType"]["AbstateType"]]

				cSetAbstate( ply, AbstateTypeData["Index"], 1, AbstateTypeData["KeepTime"], Var["Handle"] )

			end

		end

		InstanceField[Var["MapIndex"]]["WaveRunner"][Var["Handle"]] = nil

		-- �߰� ���� 6. ���Ͱ� ��å�� �ε��� ��, �״� �ִϸ��̼� ó��
		cAIScriptSet( Var["Handle"] )
		cNPCVanish( Var["Handle"] )


		return

	end


	if Var["EscortProgress"] == nil then

		local EscortProgress = {}

		EscortProgress["CurGoalX"]      = ESCORT_H_G_INIT
		EscortProgress["CurGoalY"]      = ESCORT_H_G_INIT
		EscortProgress["LastCheckTime"] = cCurrentSecond()
		EscortProgress["CurMoveState"]  = MOVESTATE["STOP"]

		Var["EscortProgress"] = EscortProgress

	end



	if Var["EscortProgress"]["CurMoveState"] == MOVESTATE["STOP"] then

		if cWillMovement( Var["Handle"] ) == nil then	-- ������ �� ���� ����
			return
		end

		Var["EscortProgress"]["CurMoveState"] = MOVESTATE["MOVE"]

	else

		if cWillMovement( Var["Handle"] ) == nil then	-- ������ �� ���� ����

			Var["EscortProgress"]["CurGoalX"]     = ESCORT_H_G_INIT
			Var["EscortProgress"]["CurGoalX"]     = ESCORT_H_G_INIT
			Var["EscortProgress"]["CurMoveState"] = MOVESTATE["STOP"]

			return

		end

	end



	local CurSec = cCurrentSecond()

	if Var["EscortProgress"]["LastCheckTime"] + ESCOTYPE_CHK_DLY <= CurSec then

		Var["EscortProgress"]["LastCheckTime"] = CurSec


		local CurAroundCoord = {}
		local CurMasterCoord = {}
		local CurMasterGoal  = {}

		local CalcTempCoord  = {}
		local CalcTempDist   = 0

		local Dir            = Var["Dir"]

		if Var["Rotate"] == true then

			Dir = Dir + cGetDirect( Var["Master"] )

		end



		CurAroundCoord["x"], CurAroundCoord["y"] = cGetAroundCoord( Var["Master"], Dir, Var["Dist"] )


		-- ���� ���� �̵��ϰ� �־���� ��ǥ�� ���� ���� �� ��� ó��
		CalcTempCoord["x"], CalcTempCoord["y"] = cObjectLocate( Var["Handle"] )

		CalcTempDist = cDistanceSquar( CalcTempCoord["x"], CalcTempCoord["y"], CurAroundCoord["x"], CurAroundCoord["y"] )


		if CalcTempDist >= ESCORT_H_GAP then

			cRunTo( Var["Handle"], CurAroundCoord["x"], CurAroundCoord["y"], ESCORT_H_S_RATE )

			Var["EscortProgress"]["CurGoalX"] = ESCORT_H_G_INIT
			Var["EscortProgress"]["CurGoalY"] = ESCORT_H_G_INIT

			return

		end



		CurMasterCoord["x"], CurMasterCoord["y"] = cObjectLocate( Var["Master"] )
		 CurMasterGoal["x"],  CurMasterGoal["y"] = cMove2Where( Var["Master"] )


		-- �Ϲ����� ��� �̵� ó��
		CalcTempCoord["x"] = CurMasterGoal["x"] - CurMasterCoord["x"]
		CalcTempCoord["y"] = CurMasterGoal["y"] - CurMasterCoord["y"]

		CalcTempCoord["x"] = CalcTempCoord["x"] + CurAroundCoord["x"]
		CalcTempCoord["y"] = CalcTempCoord["y"] + CurAroundCoord["y"]

		CalcTempDist = cDistanceSquar( CalcTempCoord["x"], CalcTempCoord["y"], Var["EscortProgress"]["CurGoalX"], Var["EscortProgress"]["CurGoalY"] )

		if CalcTempDist >= ESCORT_M_GAP then

			Var["EscortProgress"]["CurGoalX"] = CalcTempCoord["x"]
			Var["EscortProgress"]["CurGoalY"] = CalcTempCoord["y"]

			cRunTo( Var["Handle"], CalcTempCoord["x"], CalcTempCoord["y"], 1000 )

		end

	end

end



--[[																				]]--
--[[							PathType�� ���� �� �̵� ó��						]]--
--[[																				]]--
function PathTypeProcess( Var )

	if Var == nil then
		return
	end

	if Var["PathType"] == nil then
		return
	end

	-- ��ź Ÿ���ΰ�� Ÿ���� �����Ǹ� �̵�ó�� ����
	if Var["BoomType"] ~= nil then
		if Var["BoomTarget"] ~= nil then
			return
		end
	end


	if Var["PathProgress"] == nil then

		local PathProgress = {}

		PathProgress["GoalCheckTime"] = cCurrentSecond()
		PathProgress["CurPathStep"]   = 1
		PathProgress["CurMoveState"]  = MOVESTATE["STOP"]


		Var["PathProgress"] = PathProgress

	end



	if Var["PathProgress"]["CurPathStep"] > #Var["PathType"] then

		-- ���������� �����Ѱ�� ���� Ŭ���� ��Ų��
		Var["PathType"]		= nil
		Var["PathProgress"]	= nil

		return

	end



	if Var["PathProgress"]["CurMoveState"] == MOVESTATE["STOP"] then

		if cWillMovement( Var["Handle"] ) == nil then	-- ������ �� ���� ����
			return
		end

		-- �̵��ӵ� õ�з��� �ʿ��ϸ� ����
		cRunTo( Var["Handle"],
				Var["PathType"][Var["PathProgress"]["CurPathStep"]]["x"],
				Var["PathType"][Var["PathProgress"]["CurPathStep"]]["y"],
				1000 )
		Var["PathProgress"]["CurMoveState"] = MOVESTATE["MOVE"]

	end


	if Var["PathProgress"]["CurMoveState"] == MOVESTATE["MOVE"] then

		if cWillMovement( Var["Handle"] ) == nil then	-- ������ �� ���� ����

			Var["PathProgress"]["CurMoveState"] = MOVESTATE["STOP"]

			return

		end

	end


	-- ��ǥ�� üũ ����
	local CurSec = cCurrentSecond()

	if Var["PathProgress"]["GoalCheckTime"] + PATHTYPE_CHK_DLY > CurSec then
		return
	end

	Var["PathProgress"]["GoalCheckTime"] = CurSec



	-- ��ǥ�� üũ
	local curr = {}
	local goal = {}

	curr["x"], curr["y"] = cObjectLocate( Var["Handle"] )
	goal["x"]            = Var["PathType"][Var["PathProgress"]["CurPathStep"]]["x"]
			   goal["y"] = Var["PathType"][Var["PathProgress"]["CurPathStep"]]["y"]



	local dx = goal["x"] - curr["x"]
	local dy = goal["y"] - curr["y"]
	local distsquar = dx * dx + dy * dy

	if distsquar < PATHTYPE_GAP then

		Var["PathProgress"]["CurPathStep"]	= Var["PathProgress"]["CurPathStep"] + 1
		Var["PathProgress"]["CurMoveState"]	= MOVESTATE["STOP"]

		return

	end


	-- ���� �̵� ���ߴ� ���� ������ ������ üũ
	curr["x"], curr["y"] = cMove2Where( Var["Handle"] )

	if curr["x"] ~= goal["x"] and curr["y"] ~= goal["y"] then

		cRunTo( Var["Handle"],
				Var["PathType"][Var["PathProgress"]["CurPathStep"]]["x"],
				Var["PathType"][Var["PathProgress"]["CurPathStep"]]["y"],
				1000 )

	end


	return

end



--[[*****																*****]]--
--[[*****						����Ʈ ó�� ��ƾ ����					*****]]--
--[[*****		:														*****]]--
--[[*****																*****]]--
GateMapIndex = {} -- ���Ǿ�Ŭ���ÿ� ���ε����� ���� �ʾ� �����ÿ� ���ε����� ����

function GateRoutine( Handle, MapIndex )

	if InstanceField[MapIndex] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GateMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if InstanceField[MapIndex]["GateList"] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GateMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if InstanceField[MapIndex]["GateList"][Handle] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GateMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then
		cAIScriptSet( Handle )
		InstanceField[MapIndex]["GateList"][Handle] = nil
		GateMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if GateMapIndex[Handle] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		InstanceField[MapIndex]["GateList"][Handle] = nil
		return ReturnAI["END"]
	end

	return ReturnAI["END"]

end



function GateFunc( NPCHandle, PlyHandle, RegistNumber )

	local MapIndex = GateMapIndex[NPCHandle]

	if MapIndex == nil then
		return
	end

	if InstanceField[MapIndex] == nil then
		return
	end

	if InstanceField[MapIndex]["GateList"] == nil then
		return
	end


	local Var = InstanceField[MapIndex]["GateList"][NPCHandle]

	if Var == nil then
		return
	end


	cLinkTo( PlyHandle, MapIndex, Var["GateData"]["GoalX"], Var["GateData"]["GoalY"] )

end



--[[*****																*****]]--
--[[*****					��������Ʈ ó�� ��ƾ ����					*****]]--
--[[*****		:														*****]]--
--[[*****																*****]]--
DefObjMapIndex = {} -- ���Ǿ�Ŭ���ÿ� ���ε����� ���� �ʾ� �����ÿ� ���ε����� ����

function DefObjRoutine( Handle, MapIndex )

	if InstanceField[MapIndex] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DefObjMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if InstanceField[MapIndex]["DefObjList"] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DefObjMapIndex[Handle] = nil
		return ReturnAI["END"]
	end


	local Var = InstanceField[MapIndex]["DefObjList"][Handle]

	if Var == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DefObjMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then
		cAIScriptSet( Handle )
		InstanceField[MapIndex]["DefObjList"][Handle] = nil
		DefObjMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if DefObjMapIndex[Handle] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		InstanceField[MapIndex]["DefObjList"][Handle] = nil
		return ReturnAI["END"]
	end


	DefObjDamage( Var )


	return ReturnAI["END"]

end



function DefObjDamage( Var )

	if Var == nil then
		return
	end

	local MapIndex = DefObjMapIndex[Var["Handle"]]

	if MapIndex == nil then
		return
	end

	if InstanceField[MapIndex]["WaveRunner"] == nil then
		return
	end

	-- hp üũ
	if Var["CurHP"] <= 0 then
		return
	end


	-- üũ ������
	local CurSec = cCurrentSecond()

	if Var["LastCheckTime"] + DEF_TYPE_CHK_DLY > CurSec then
		return
	end

	Var["LastCheckTime"] = CurSec


	local ObjList = { cNearObjectList( Var["Handle"], Var["Data"]["DamageRange"], ObjectType["Mob"] ) }
	local tmpHP   = Var["CurHP"]

	for index, value in pairs( ObjList ) do

		local obj = InstanceField[MapIndex]["WaveRunner"][value]

		if obj ~= nil then

			Var["CurHP"] = Var["CurHP"] - obj["Damage"]

			-- ���̺�� ����
			InstanceField[MapIndex]["WaveRunner"][value] = nil
			cAIScriptSet( value )
			-- �߰� ���� 6. ���Ͱ� ��å�� �ε��� ��, �״� �ִϸ��̼� ó��
			--cNPCVanish( value )
			local CurHP, MaxHP = cObjectHP( value )
			cDamaged( value, CurHP, Var["Handle"] )

			if Var["CurHP"] <= 0 then
				break
			end

		end

	end


	-- hp ��ȭ�� �ִ��� üũ
	if tmpHP == Var["CurHP"] then
		return
	end



	if Var["CurHP"] <= 0 then

		cScriptMessage( MapIndex, AnnounceInfo["KDMine_Fence_Dst"], Var["MMGroup"] ) -- ��å�� �ı���

		-- ü���� ��� �Ҹ�� �ı� ����

		-- ���� ���¿� �ٸ��� ������ �ٲ���
		if Var["CurMM"] ~= MMGroupTypeTable[Var["Data"]["MMGroupType"]]["Destruct"] then

			Var["CurMM"] = MMGroupTypeTable[Var["Data"]["MMGroupType"]]["Destruct"]

			local MapMarkTable = {}
			local mmData = {}

			mmData["Group"]     = MM_G_FENCE + Var["MMGroup"]
			mmData["x"]         = Var["Data"]["x"]
			mmData["y"]         = Var["Data"]["y"]
			mmData["KeepTime"]  = MapMarkTypeTable[Var["CurMM"]]["KeepTime"]
			mmData["IconIndex"] = MapMarkTypeTable[Var["CurMM"]]["IconIndex"]

			MapMarkTable[mmData["Group"]] = mmData

			cMapMark( MapIndex, MapMarkTable )

		end


		-- �ı��Ȱ�� ��Ÿ�� ��
		Var["DestroyTime"] = CurSec

		-- �뷱���� ����
		local FenceBalance = InstanceField[MapIndex]["FenceBalance"]

		if FenceBalance ~= nil then

			local BalanceData = DefBalanceTypeTable[Var["Data"]["DefBalanceType"]]

			if BalanceData ~= nil then

				FenceBalance["DamageRate"] = FenceBalance["DamageRate"] + BalanceData["DamageRate"]
				FenceBalance["SpeedRate"]  = FenceBalance["SpeedRate"]  + BalanceData["SpeedRate"]
				FenceBalance["HPRate"]     = FenceBalance["HPRate"]     + BalanceData["HPRate"]

			end

		end

	else

		-- ������ ���� ����
		cScriptMessage( MapIndex, AnnounceInfo["KDMine_Fence_Atk"], Var["MMGroup"] ) -- ��å�� ���ݹް� ����

		-- ���� ���¿� �ٸ��� ������ �ٲ���
		if Var["CurMM"] ~= MMGroupTypeTable[Var["Data"]["MMGroupType"]]["Damage"] then

			Var["CurMM"] = MMGroupTypeTable[Var["Data"]["MMGroupType"]]["Damage"]

			local MapMarkTable = {}
			local mmData = {}

			mmData["Group"]     = MM_G_FENCE + Var["MMGroup"]
			mmData["x"]         = Var["Data"]["x"]
			mmData["y"]         = Var["Data"]["y"]
			mmData["KeepTime"]  = MapMarkTypeTable[Var["CurMM"]]["KeepTime"]
			mmData["IconIndex"] = MapMarkTypeTable[Var["CurMM"]]["IconIndex"]

			MapMarkTable[mmData["Group"]] = mmData

			cMapMark( MapIndex, MapMarkTable )

		end

	end


	local CurHPRate  = (Var["CurHP"] * 1000) / Var["Data"]["HP"]
	local CurAniData = AniStateTypeTable[Var["Data"]["AniStateType"]]

	for i=1, #CurAniData do

		if CurHPRate <= CurAniData[i]["HPRate"] then

			-- �ִϸ��̼� ��ȭ�� ������ �ٲ���
			if Var["CurAni"] ~= i then

				Var["CurAni"] = i
				cAnimate( Var["Handle"], "start", CurAniData[i]["AniIndex"] )

			end

			break

		end

	end

end



function DefObjClick( NPCHandle, PlyHandle, PlyRegNum )

	local MapIndex = DefObjMapIndex[NPCHandle]

	if MapIndex == nil then
		return
	end

	if InstanceField[MapIndex] == nil then
		return
	end

	if InstanceField[MapIndex]["DefObjList"] == nil then
		return
	end


	local Var = InstanceField[MapIndex]["DefObjList"][NPCHandle]

	if Var == nil then
		return
	end

	if Var["CurHP"] > 0 then
		return
	end

	if Var["DestroyTime"] + Var["Data"]["RepairDlyTime"] > cCurrentSecond() then
		return
	end

	cCastingBar( PlyHandle, NPCHandle, (Var["Data"]["RepairTime"] * 1000), CHAR_CASTING )

end



function DefObjCasting( NPCHandle, PlyHandle, PlyRegNum, Menu )

	local MapIndex = DefObjMapIndex[NPCHandle]

	if MapIndex == nil then
		return
	end

	if InstanceField[MapIndex] == nil then
		return
	end

	if InstanceField[MapIndex]["DefObjList"] == nil then
		return
	end


	local Var = InstanceField[MapIndex]["DefObjList"][NPCHandle]

	if Var == nil then
		return
	end

	if Var["CurHP"] > 0 then
		return
	end


	-- �뷱���� ����
	local FenceBalance = InstanceField[MapIndex]["FenceBalance"]

	if FenceBalance ~= nil then

		local BalanceData = DefBalanceTypeTable[Var["Data"]["DefBalanceType"]]

		if BalanceData ~= nil then

			FenceBalance["DamageRate"] = FenceBalance["DamageRate"] - BalanceData["DamageRate"]
			FenceBalance["SpeedRate"]  = FenceBalance["SpeedRate"]  - BalanceData["SpeedRate"]
			FenceBalance["HPRate"]     = FenceBalance["HPRate"]     - BalanceData["HPRate"]

		end

	end


	Var["CurHP"]  = Var["Data"]["HP"]
	Var["CurAni"] = #AniStateTypeTable[Var["Data"]["AniStateType"]]
	Var["CurMM"]  = MMGroupTypeTable[Var["Data"]["MMGroupType"]]["Normal"]


	local MapMarkTable = {}
	local mmData = {}

	mmData["Group"]     = MM_G_FENCE + Var["MMGroup"]
	mmData["x"]         = Var["Data"]["x"]
	mmData["y"]         = Var["Data"]["y"]
	mmData["KeepTime"]  = MapMarkTypeTable[Var["CurMM"]]["KeepTime"]
	mmData["IconIndex"] = MapMarkTypeTable[Var["CurMM"]]["IconIndex"]

	MapMarkTable[mmData["Group"]] = mmData


	cMapMark( MapIndex, MapMarkTable )

	cScriptMessage( MapIndex, AnnounceInfo["KDMine_Fence_Rep"], Var["MMGroup"] ) -- ��å�� ������

	cAnimate( NPCHandle, "start", AniStateTypeTable[Var["Data"]["AniStateType"]][Var["CurAni"]]["AniIndex"] )

end




--[[*****																*****]]--
--[[*****					���ο�����Ʈ ó�� ��ƾ ����					*****]]--
--[[*****		:														*****]]--
--[[*****																*****]]--
function MainObjRoutine( Handle, MapIndex )

	if InstanceField[MapIndex] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	local Var = InstanceField[MapIndex]["MainObj"]

	if Var == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then
		cAIScriptSet( Handle )
		InstanceField[MapIndex]["MainObj"] = nil
		return ReturnAI["END"]
	end

	MainObjDamage( Var )

end



function MainObjDamage( Var )

	if Var == nil then
		return
	end


	-- üũ ������
	local CurSec = cCurrentSecond()

	if Var["LastCheckTime"] + DEF_TYPE_CHK_DLY > CurSec then
		return
	end

	Var["LastCheckTime"] = CurSec


	local ObjList = { cNearObjectList( Var["Handle"], Var["Data"]["DamageRange"], ObjectType["Mob"] ) }
	local tmpHP   = Var["CurHP"]

	for index, value in pairs( ObjList ) do

		local obj = InstanceField[Var["MapIndex"]]["WaveRunner"][value]

		if obj ~= nil then

			Var["CurHP"] = Var["CurHP"] - obj["Damage"]

			-- ���̺�� ����
			InstanceField[Var["MapIndex"]]["WaveRunner"][value] = nil
			cAIScriptSet( value )
			cNPCVanish( value )

			if Var["CurHP"] <= 0 then
				break
			end

		end

	end


	-- hp ��ȭ�� �ִ��� üũ
	if tmpHP == Var["CurHP"] then
		return
	end


	-- �߰� ���� 1. ���� ������Ʈ�� Ż�ⱸ�� ���Ͱ� �ε��� ��,
	local TotalDmg = (MainDefenceObject["HP"] - Var["CurHP"])


	if Var["CurHP"] <= 0 then

		-- �ı� ����
		-- �߰� ���� 1. ���� ������Ʈ�� Ż�ⱸ�� ���Ͱ� �ε��� ��,
		cScriptMessage( Var["MapIndex"], AnnounceInfo["KDMine_Gate_Dst"], TotalDmg )
--		cScriptMessage( Var["MapIndex"], AnnounceInfo["KDMine_Gate_Dst"] )

	else

		-- ������ ���� ����
		-- �߰� ���� 1. ���� ������Ʈ�� Ż�ⱸ�� ���Ͱ� �ε��� ��,
		cScriptMessage( Var["MapIndex"], AnnounceInfo["KDMine_Gate_Esc"], TotalDmg )
--		cScriptMessage( Var["MapIndex"], AnnounceInfo["KDMine_Gate_Esc"] )



	end

end




--[[*****																*****]]--
--[[*****						���� ó�� ��ƾ ����						*****]]--
--[[*****		:														*****]]--
--[[*****																*****]]--
MineMemory = {}		-- ���� �޸𸮷� ó��
function MineRoutine( Handle, MapIndex )

	local Var = MineMemory[Handle]

	if Var == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then
		cAIScriptSet( Handle )
		MineMemory[Handle] = nil
		return ReturnAI["END"]
	end


	if InstanceField[MapIndex] == nil then
		MineMemory[Handle] = nil
		return ReturnAI["END"]
	end



	local CurSec = cCurrentSecond()


	if Var["BoomFlag"] ~= nil then

		if Var["RegenTime"] + Var["Data"]["HitTime"] < CurSec then

			if InstanceField[MapIndex]["WaveRunner"] ~= nil then

				local ObjList = { cNearObjectList( Var["Handle"], Var["Data"]["Range"], ObjectType["Mob"] ) }

				for index, value in pairs( ObjList ) do

					local obj = InstanceField[MapIndex]["WaveRunner"][value]

					if obj ~= nil and cIsObjectDead( value ) == nil then

						cDamaged( value, Var["Data"]["Damage"], Var["Handle"] )

						local Abstate = AbstateTypeTable[Var["Data"]["AbstateType"]]

						if Abstate ~= nil then

							cSetAbstate( value, Abstate["Index"], 1, Abstate["KeepTime"], Var["Handle"] )

						end

					end

				end

			end

			Var["BoomFlag"] = nil

		end

	end


	if Var["RegenTime"] + Var["Data"]["LifeTime"] < CurSec then

		MineMemory[Handle] = nil

	end

	return ReturnAI["END"]

end
