function PlayerMapLogin( Field, Player )
cExecCheck( "PlayerMapLogin" )

	local Var = InstanceField[Field]

	if Var == nil then
		return
	end

	-- �̵��ӵ� ����
	--cStaticSpeed     ( Player, STATIC_SPEED_RATE )
	cSetAbstate( Player, ABSTATE_SPEED_UP_INDEX, 1, ABSTATE_SPEED_UP_KEEP )


	-- �ʸ�ŷ ������
	local MapMarkTable = {}

	for i=1, #ObjectTable do

		local mmData = {}
		local curMMT = MapMarkTypeTable[ObjectTable[i]["MapMarkType"]]

		if curMMT ~= nil then

			mmData["Group"]     = MM_G_GATE + i
			mmData["x"]         = ObjectTable[i]["x"]
			mmData["y"]         = ObjectTable[i]["y"]
			mmData["KeepTime"]  = curMMT["KeepTime"]
			mmData["IconIndex"] = curMMT["IconIndex"]

			MapMarkTable[mmData["Group"]] = mmData

		end

	end

	if Var["MainObj"] ~= nil then

		local mmData = {}
		local curMMT = MapMarkTypeTable[Var["MainObj"]["Data"]["MapMarkType"]]

		if curMMT ~= nil then

			mmData["Group"]     = MM_G_MAIN
			mmData["x"]         = Var["MainObj"]["Data"]["x"]
			mmData["y"]         = Var["MainObj"]["Data"]["y"]
			mmData["KeepTime"]  = curMMT["KeepTime"]
			mmData["IconIndex"] = curMMT["IconIndex"]

			MapMarkTable[mmData["Group"]] = mmData

		end

	end

	cMapMark_Obj( Player, MapMarkTable )

end


function PlayerItemUse( Field, Player, ItemID )
cExecCheck( "PlayerItemUse" )

	for index, value in pairs( MineTable ) do

		if value["ItemID"] == ItemID then

			local Data  = MineTable[index]

			local dir   = cGetDirect( Player )
			local coord = {}

			coord["x"], coord["y"] = cGetAroundCoord( Player, dir, Data["Dist"] )

			if coord["x"] ~= nil and coord["y"] ~= nil then

				local RegenMob = {}

				RegenMob["Handle"] = cMobRegen_XY( Field, Data["MobIndex"], coord["x"], coord["y"], dir )

				if RegenMob["Handle"] ~= nil then

					RegenMob["MapIndex"]	= Field
					RegenMob["Data"]		= Data

					RegenMob["RegenTime"]	= cCurrentSecond()
					RegenMob["BoomFlag"]	= 1
					RegenMob["Master"]		= Player

					cSkillBlast( RegenMob["Handle"], RegenMob["Handle"], RegenMob["Data"]["Skill"] )


					cResetAbstate( RegenMob["Handle"], ABSTATE_IMT_IDX )

					cSetAIScript( SCRIPT_MAIN, RegenMob["Handle"] )
					cAIScriptFunc( RegenMob["Handle"], "Entrance", "MineRoutine" )

					MineMemory[RegenMob["Handle"]] = RegenMob  -- ���� ���� ����

				end

			end

		end

	end

end


function MapMarking( Var )
cExecCheck( "MapMarking" )

	if Var == nil then
		return
	end

	if Var["MapIndex"] == nil then
		return
	end


	if Var["InitMapMark"] == nil then

		Var["InitMapMark"]   = 1

		Var["MapMarkTime"]   = cCurrentSecond()

	end


	local CurSec = cCurrentSecond()

	if Var["MapMarkTime"] + MAP_MARK_CHK_DLY > CurSec then	-- �� ��ŷ ���� �ð� üũ
		return
	end

	Var["MapMarkTime"] = CurSec


	-- �ʸ�ŷ ��û�� ������ ���̺� �������
	--{ { Group = 1, x = 100, y = 100, KeepTime = 1000, IconIndex = "chief" }, ... }
	local MapMarkTable = {}

	-- ���̺�� ����
	if Var["WaveRunner"] ~= nil then

		-- ���̺� ���� ��ǥ ������
		local WaveMobCoord = {}

		for index, value in pairs( Var["WaveRunner"] ) do

			if cIsObjectDead( value["Handle"] ) == nil then

				local coord = {}

				coord["x"], coord["y"] = cObjectLocate( value["Handle"] )

				WaveMobCoord[value["Handle"]] = coord

			end

		end


		-- ǥ���� �� ��ġ ���
		local MapMarkCheck = {}

		for i=1, #MapMarkLocateTable do

			for index, value in pairs( WaveMobCoord ) do

				local CurMMT = Var["WaveRunner"][index]["MapMarkType"]

				-- �� ��ŷ üũ �ϸ鼭 üũ���� ���� ��ǥ �̰ų�
				-- üũ�� ���� ������ ���� ���� �� ���� Order�� ������츸 ���
				if	(CurMMT ~= nil and MapMarkCheck[i] == nil) or
					(CurMMT ~= nil and MapMarkCheck[i]["Order"] < CurMMT["Order"]) then

					local dx = MapMarkLocateTable[i]["x"] - value["x"]
					local dy = MapMarkLocateTable[i]["y"] - value["y"]
					local distsquar = dx * dx + dy * dy

					-- �Ÿ� üũ
					if MapMarkLocateTable[i]["Range"] * MapMarkLocateTable[i]["Range"] > distsquar then

						MapMarkCheck[i] = CurMMT

					end

				end

			end

		end


		for i=1, #MapMarkLocateTable do

			-- ������ üũ�� ��ǥ�� ����
			if MapMarkCheck[i] ~= nil then

				local mmData = {}

				mmData["Group"]     = MM_G_WAVEMOB + i
				mmData["x"]         = MapMarkLocateTable[i]["x"]
				mmData["y"]         = MapMarkLocateTable[i]["y"]
				mmData["KeepTime"]  = MapMarkCheck[i]["KeepTime"]
				mmData["IconIndex"] = MapMarkCheck[i]["IconIndex"]

				MapMarkTable[mmData["Group"]] = mmData

			end

		end

	end


	cMapMark( Var["MapIndex"], MapMarkTable )

end


function InitKingdomQuestDefence( Var )
cExecCheck( "InitKingdomQuestDefence" )

	if Var == nil then
		return
	end


	-- ���� ������Ʈ ����
	local MainObj = {}

	MainObj["Handle"] = cMobRegen_XY( Var["MapIndex"],
										MainDefenceObject["Index"],
										MainDefenceObject["x"],
										MainDefenceObject["y"],
										MainDefenceObject["dir"] )

	if MainObj["Handle"] ~= nil then

		MainObj["Data"]          = MainDefenceObject
		MainObj["CurHP"]         = MainObj["Data"]["HP"]
		MainObj["LastCheckTime"] = cCurrentSecond()
		MainObj["MapIndex"]      = Var["MapIndex"]

		-- ������ �ɸ��� ���� �����̻� Ǯ����
		cResetAbstate( MainObj["Handle"], ABSTATE_IMT_IDX )

		cSetAIScript( SCRIPT_MAIN, MainObj["Handle"] )
		cAIScriptFunc( MainObj["Handle"], "Entrance", "MainObjRoutine" )

		Var["MainObj"] = MainObj

	end





	-- �ƹ� ��� ���� ������Ʈ ���� [�κ�]
	for i=1, #ObjectTable do

		cMobRegen_XY( Var["MapIndex"],
						ObjectTable[i]["Index"],
						ObjectTable[i]["x"],
						ObjectTable[i]["y"],
						ObjectTable[i]["dir"] )

	end


	-- ���� NPC ����
	cNPCRegen( Var["MapIndex"], MerchantNPC )



	Var["StepFunc"] = DummyFunc

end


function WaveProcess( Var )
cExecCheck( "WaveProcess" )

	if Var == nil then
		return
	end

	if Var["MapIndex"] == nil then
		return
	end


	-- ���̺� ó�� ���� ���� �ʱ�ȭ
	if Var["InitWave"] == nil then

		Var["InitWave"]		= 1

		Var["WaveStep"]		= 0
		Var["Wave"]			= {}
		Var["WaveRunner"]	= {}
		Var["NextWave"]		= true

		for index, value in pairs( PathTypeTable ) do

			Var["Wave"][index] = {}
			Var["Wave"][index]["Wait"]		= true				-- �ٸ� �׷� �Ϸ� ���
			Var["Wave"][index]["InnerStep"]	= 1					-- �׷� �� �� ���� ����
			Var["Wave"][index]["RegenCnt"]	= 0					-- �� ���� ī��Ʈ
			Var["Wave"][index]["WaveTime"]	= cCurrentSecond()	-- �� ���� ���� üũ

		end

	end


	if Var["NextWave"] == true then

		for index, value in pairs( PathTypeTable ) do

			Var["Wave"][index]["Wait"] = false

		end

		Var["WaveStep"]		= Var["WaveStep"] + 1


		if Var["WaveStep"] > #WaveTable then

			Var["InitWave"] = nil
			Var["StepFunc"] = DummyFunc

			return

		else

			Var["WaveDialog"]	= DialogInfo[WaveTable[Var["WaveStep"]]["Dialog"]]
			Var["WaveAnnounce"]	= WaveTable[Var["WaveStep"]]["Announce"]

		end

	end


	-- ���̺� �� ����
	Var["NextWave"] = true

	for index, value in pairs( PathTypeTable ) do

		if WaveTable[Var["WaveStep"]][index] == nil then

			Var["Wave"][index]["Wait"] = true

		end

		if Var["Wave"][index]["Wait"] == false then

			Var["NextWave"] = false

			if Var["Wave"][index]["RegenCnt"] >= WaveTable[Var["WaveStep"]][index][Var["Wave"][index]["InnerStep"]]["Num"] then

				Var["Wave"][index]["RegenCnt"]	= 0
				Var["Wave"][index]["InnerStep"]	= Var["Wave"][index]["InnerStep"] + 1

			end

			if Var["Wave"][index]["InnerStep"] > #WaveTable[Var["WaveStep"]][index] then

				Var["Wave"][index]["InnerStep"] = 1
				Var["Wave"][index]["Wait"]		= true

			else

				local CurWaveData       = WaveTable[Var["WaveStep"]][index][Var["Wave"][index]["InnerStep"]]
				local CurMobSettingData = MobSettingTypeTable[WaveMobTypeTable[CurWaveData["WaveMobType"]]["MobSettingType"]]

				local CurTime = cCurrentSecond()
				local DlyTime = CurWaveData["RegenInterval"]

				if Var["Wave"][index]["RegenCnt"] == 0 then
					DlyTime = CurWaveData["WaveStepInterval"]
				end

				if Var["Wave"][index]["WaveTime"] > (CurTime - DlyTime) then
					return
				end


				local RegenMob = {}
				RegenMob["Handle"]	= cMobRegen_XY( Var["MapIndex"], CurMobSettingData["Index"], value[1]["x"], value[1]["y"], 0 )

				if RegenMob["Handle"] ~= nil then

					RegenMob["MapIndex"]		= Var["MapIndex"]

					RegenMob["PathType"]		= value
					RegenMob["MobChatType"]		= MobChatTypeTable[WaveMobTypeTable[CurWaveData["WaveMobType"]]["MobChatType"]]
					if RegenMob["MobChatType"] ~= nil then

						RegenMob["MobChatTime"]		= CurTime + cRandomInt( RegenMob["MobChatType"]["NormalChatTime"]["Min"], RegenMob["MobChatType"]["NormalChatTime"]["Max"] )

					end
					RegenMob["MapMarkType"]		= MapMarkTypeTable[WaveMobTypeTable[CurWaveData["WaveMobType"]]["MapMarkType"]]
					RegenMob["Damage"]			= CurMobSettingData["Demage"]

					cSetNPCParam( RegenMob["Handle"], "MaxHP",		CurMobSettingData["HP"]		)
					cSetNPCParam( RegenMob["Handle"], "HP",			CurMobSettingData["HP"]		)
					cSetNPCParam( RegenMob["Handle"], "RunSpeed",	CurMobSettingData["Speed"]	)
					cSetNPCParam( RegenMob["Handle"], "HPRegen",	CurMobSettingData["HPRegen"])
					cSetNPCParam( RegenMob["Handle"], "AC",			CurMobSettingData["AC"]		)
					cSetNPCParam( RegenMob["Handle"], "MR",			CurMobSettingData["MR"]		)
					cSetNPCParam( RegenMob["Handle"], "MobEXP",		CurMobSettingData["Exp"]	)
					cSetNPCResist( RegenMob["Handle"],				ResistTypeTable[WaveMobTypeTable[CurWaveData["WaveMobType"]]["ResistType"]] )
					cSetNPCIsItemDrop( RegenMob["Handle"],			CurMobSettingData["ItemDrop"] )

					cResetAbstate( RegenMob["Handle"], ABSTATE_IMT_IDX )

					cSetAIScript( SCRIPT_MAIN, RegenMob["Handle"] )
					cAIScriptFunc( RegenMob["Handle"], "Entrance", "MobRoutine" )

					Var["WaveRunner"][RegenMob["Handle"]] = RegenMob

				end

				Var["Wave"][index]["RegenCnt"] = Var["Wave"][index]["RegenCnt"] + 1
				Var["Wave"][index]["WaveTime"] = cCurrentSecond()

			end

		end

	end


	-- ���̾� �α� �� ����
	if WarN_Dialog( Var, Var["WaveDialog"] ) == nil then
		Var["WaveDialog"] = nil
	end

	if Var["WaveAnnounce"] ~= nil then
		cScriptMessage( Var["MapIndex"], AnnounceInfo[Var["WaveAnnounce"]] )
		Var["WaveAnnounce"] = nil
	end

end


function WarN_Dialog( Var, Dialog )
cExecCheck( "WarN_Dialog" )

	if Var == nil or Dialog == nil then
		return nil
	end


	local CurSec = cCurrentSecond()

	if Var["Dialog"] == nil then

		Var["Dialog"]     = Dialog
		Var["DialogStep"] = 1
		Var["DialogTime"] = CurSec

	end


	if Var["DialogStep"] <= #Var["Dialog"] then

		if Var["DialogTime"] + Var["Dialog"][Var["DialogStep"]]["Delay"] > CurSec then
			return Var["DialogStep"]
		end

		cMobDialog_FileName( Var["MapIndex"],
								Var["Dialog"][Var["DialogStep"]]["Facecut"],
								Var["Dialog"][Var["DialogStep"]]["FileName"],
								Var["Dialog"][Var["DialogStep"]]["Index"] )

		Var["DialogTime"] = CurSec
		Var["DialogStep"] = Var["DialogStep"] + 1

		return Var["DialogStep"]

	end

	Var["Dialog"]     = nil
	Var["DialogStep"] = nil
	Var["DialogTime"] = nil


	return nil

end


function WarN_Notice( Var, Notice )
cExecCheck( "WarN_Notice" )

	if Var == nil or Notice == nil then
		return nil
	end


	local CurSec = cCurrentSecond()

	if Var["Notice"] == nil then

		Var["Notice"]     = Notice
		Var["NoticeStep"] = 1
		Var["NoticeTime"] = CurSec

	end

	if Var["NoticeStep"] <= #Var["Notice"] then

		if Var["Noticed"] == nil then

			cNotice( Var["MapIndex"], Var["Notice"][Var["NoticeStep"]]["FileName"], Var["Notice"][Var["NoticeStep"]]["Index"] )
			Var["Noticed"] = 1

		end


		if Var["NoticeTime"] + Var["Notice"][Var["NoticeStep"]]["WaitTime"] > CurSec then
			return Var["NoticeStep"]
		end

		Var["NoticeTime"] = CurSec
		Var["NoticeStep"] = Var["NoticeStep"] + 1
		Var["Noticed"]    = nil

		return Var["NoticeStep"]

	end

	Var["Notice"]     = nil
	Var["NoticeStep"] = nil
	Var["NoticeTime"] = nil
	Var["Noticed"]    = nil


	return nil

end

