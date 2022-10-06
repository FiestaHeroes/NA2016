--[[*****																*****]]--
--[[*****						���� ó�� ��ƾ ����						*****]]--
--[[*****		:														*****]]--
--[[*****																*****]]--
MineMemory = {}		-- ���� �޸𸮷� ó��
function MineRoutine( Handle, MapIndex )
cExecCheck( "MineRoutine" )

	local Var = MineMemory[Handle]

	if Var == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Master"] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		MineMemory[Handle] = nil
		return ReturnAI["END"]
	end

	if cPlayerExist( Var["Master"] ) == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Var["Handle"] )
		MineMemory[Handle] = nil
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

						cDamaged( value, Var["Data"]["Damage"], Var["Master"] )

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


--[[*****																*****]]--
--[[*****					���ο�����Ʈ ó�� ��ƾ ����					*****]]--
--[[*****		:														*****]]--
--[[*****																*****]]--
function MainObjRoutine( Handle, MapIndex )
cExecCheck( "MainObjRoutine" )

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

	if InstanceField[Var["MapIndex"]]["WaveRunner"] == nil then

		return ReturnAI["END"]

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
		return ReturnAI["END"]
	end


	if Var["CurHP"] >= 0 then

		local hprate = 0
		hprate = (Var["CurHP"] / MainDefenceObject["HP"]) * 100
		hprate = math.floor( hprate )
		cScriptMessage( Var["MapIndex"], AnnounceInfo["KDEgg_EggHp"], hprate )

	end

	return ReturnAI["END"]

end


--[[*****																*****]]--
--[[*****							�� ó�� ��ƾ ����					*****]]--
--[[*****		: 														*****]]--
--[[*****																*****]]--
function MobRoutine( Handle, MapIndex )
cExecCheck( "MobRoutine" )

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
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then

		if Var["MobChatType"] ~= nil then

			if Var["MobChatType"]["DieChatRate"] ~= nil and Var["MobChatType"]["Die"] ~= nil then

				if cRandomInt( 1, 100 ) < Var["MobChatType"]["DieChatRate"] then

					local MobChatNum = cRandomInt( 1, #Var["MobChatType"]["Die"] )

					cMobChat( Var["Handle"], Var["MobChatType"]["Die"][MobChatNum]["FileName"], Var["MobChatType"]["Die"][MobChatNum]["Index"] )

				end

			end

		end

		cAIScriptSet( Handle )
		InstanceField[MapIndex]["WaveRunner"][Handle] = nil
		return ReturnAI["END"]
	end


	MobChatProcess	( Var )
	PathTypeProcess	( Var ) -- ��ΰ� �����ϴ°�� ó��


	return ReturnAI["END"]

end




-- �̵� ���°� flag
MOVESTATE = {}
MOVESTATE["STOP"] = "STOP"
MOVESTATE["MOVE"] = "MOVE"



--[[																				]]--
--[[							PathType�� ���� �� �̵� ó��						]]--
--[[																				]]--
function PathTypeProcess( Var )
cExecCheck( "PathTypeProcess" )

	if Var == nil then
		return
	end

	if Var["PathType"] == nil then
		return
	end


	if Var["PathProgress"] == nil then

		local PathProgress = {}

		PathProgress["GoalCheckTime"] = cCurrentSecond()
		PathProgress["CurPathStep"]   = 1
		PathProgress["CurMoveState"]  = MOVESTATE["STOP"]


		Var["PathProgress"] = PathProgress

	end



	if Var["PathProgress"]["CurPathStep"] > #Var["PathType"] then

		Var["PathType"]		= nil
		Var["PathProgress"]	= nil

		return

	end



	if Var["PathProgress"]["CurMoveState"] == MOVESTATE["STOP"] then

		if cWillMovement( Var["Handle"] ) == nil then
			return
		end

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


	curr["x"], curr["y"] = cMove2Where( Var["Handle"] )

	if curr["x"] ~= goal["x"] and curr["y"] ~= goal["y"] then

		cRunTo( Var["Handle"],
				Var["PathType"][Var["PathProgress"]["CurPathStep"]]["x"],
				Var["PathType"][Var["PathProgress"]["CurPathStep"]]["y"],
				1000 )

	end


	return

end


--[[																				]]--
--[[							MobChatType�� ���� ��ê ó��						]]--
--[[																				]]--
function MobChatProcess( Var )
cExecCheck( "MobChatProcess" )

	if Var == nil then
		return
	end

	if Var["MobChatType"] == nil then
		return
	end

	if Var["MobChatTime"] == nil then

		return

	end


	local CurSec = cCurrentSecond()


	if Var["MobChatTime"] <= CurSec then

		local MobChatNum = cRandomInt( 1, #Var["MobChatType"]["Normal"] )

		cMobChat( Var["Handle"], Var["MobChatType"]["Normal"][MobChatNum]["FileName"], Var["MobChatType"]["Normal"][MobChatNum]["Index"] )

		Var["MobChatTime"] = nil

	end

end
