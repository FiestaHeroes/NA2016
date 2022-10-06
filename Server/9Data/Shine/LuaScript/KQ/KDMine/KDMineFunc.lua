function PlayerMapLogin( Field, Player )

	local Var = InstanceField[Field]

	if Var == nil then
		return
	end


	-- �߰� ���� 9. Ŭ���� �� ������� ������ ���� ����
	local BaseClassNum = cGetBaseClass( Player )
	cStaticDamage    ( Player, STATIC_DAMAGE[BaseClassNum] )	-- ������ ����
--	cStaticDamage    ( Player, STATIC_DAMAGE )		-- ������ ����

	cStaticSpeed     ( Player, STATIC_SPEED_RATE )	-- �̵��ӵ� ����
	cStaticMoverSpeed( Player, STATIC_MOVER_SPEED )	-- �����ӵ� ����


	-- ����Ʈ ��ġ ǥ�� ���� �ʸ�ŷ ������
	local MapMarkTable = {}

	for i=1, #GateSettingTable do

		local mmData = {}
		local curMMT = MapMarkTypeTable[GateSettingTable[i]["MapMarkType"]]

		if curMMT ~= nil then

			mmData["Group"]     = MM_G_GATE + i
			mmData["x"]         = GateSettingTable[i]["RegenX"]
			mmData["y"]         = GateSettingTable[i]["RegenY"]
			mmData["KeepTime"]  = curMMT["KeepTime"]
			mmData["IconIndex"] = curMMT["IconIndex"]

			MapMarkTable[mmData["Group"]] = mmData

		end

	end


	-- ��������Ʈ ����
	if Var["DefObjList"] ~= nil then

		for index, value in pairs( Var["DefObjList"] ) do

			if MapMarkTypeTable[value["CurMM"]] ~= nil then

				local mmData = {}

				mmData["Group"]     = MM_G_FENCE + value["MMGroup"]
				mmData["x"]         = value["Data"]["x"]
				mmData["y"]         = value["Data"]["y"]
				mmData["KeepTime"]  = MapMarkTypeTable[value["CurMM"]]["KeepTime"]
				mmData["IconIndex"] = MapMarkTypeTable[value["CurMM"]]["IconIndex"]

				MapMarkTable[mmData["Group"]] = mmData

			end

		end

	end


	-- ���ο�����Ʈ����
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

	cMapMark( Field, MapMarkTable )

end


function PlayerItemUse( Field, Player, ItemID )

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

					RegenMob["MapIndex"]  = Field
					RegenMob["Data"]      = Data

					RegenMob["RegenTime"] = cCurrentSecond()
					RegenMob["BoomFlag"]  = 1

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


function InitKingdomQuestDefence( Var )

	if Var == nil then
		return
	end


	-- ������ ���̺� ���� ���� üũ

	-- [BoomTypeTable]
	for index, value in pairs( BoomTypeTable ) do

		if index ~= "None" then

			if value == nil then
				cDebugLog( "BoomTypeTable Data nil : " .. " Index = " .. index )
				return
			end

			if value["AbstateType"] == nil then
				cDebugLog( "BoomTypeTable AbstateType nil : " .. " Index = " .. index )
				return
			end

			if value["FollowType"] == nil then
				cDebugLog( "BoomTypeTable FollowType nil : " .. " Index = " .. index )
				return
			end

			if FollowTypeTable[value["FollowType"]] == nil then
				cDebugLog( "BoomTypeTable nil Value : " .. "FollowType = " .. value["FollowType"] .. " Index = " .. index )
				return
			end

		end

	end

	-- [SummonMobTypeTable]
	for index, value in pairs( SummonMobTypeTable ) do

		if value == nil then
			cDebugLog( "SummonMobTypeTable Data nil : " .. "Index = " .. index )
			return
		end

		if value["MobSettingType"] == nil then
			cDebugLog( "SummonMobTypeTable MobSettingType nil : " .. "Index = " .. index )
			return
		end

		if value["BoomType"] == nil then
			cDebugLog( "SummonMobTypeTable BoomType nil : " .. "Index = " .. index )
			return
		end

		if value["ResistType"] == nil then
			cDebugLog( "SummonMobTypeTable ResistType nil : " .. "Index = " .. index )
			return
		end


		if MobSettingTypeTable[value["MobSettingType"]] == nil then
			cDebugLog( "SummonMobTypeTable nil Value : " .. "MobSettingType = " .. value["MobSettingType"] .." Index = " .. index )
			return
		end

		if BoomTypeTable[value["BoomType"]] == nil then
			if value["BoomType"] ~= "None" then
				cDebugLog( "SummonMobTypeTable nil Value : " .. "BoomType = " .. value["BoomType"] .." Index = " .. index )
				return
			end
		end

		if ResistTypeTable[value["ResistType"]] == nil then
			cDebugLog( "SummonMobTypeTable nil Value : " .. "ResistType = " .. value["ResistType"] .." Index = " .. index )
			return
		end

	end

	-- [SummonGroupTypeTable]
	for index, value in pairs( SummonGroupTypeTable ) do

		if value == nil then
			cDebugLog( "SummonGroupTypeTable Data nil : " .. " Index = " .. index )
			return
		end

		for i=1, #value do

			if value[i]["SummonMobType"] == nil then
				cDebugLog( "SummonGroupTypeTable Data SummonMobType nil : " .. " Index = " .. index .. " no = " .. i )
				return
			end

			if SummonMobTypeTable[value[i]["SummonMobType"]] == nil then
				cDebugLog( "SummonGroupTypeTable nil Value : " .. " Index = " .. index .. " no = " .. i .. "[" .. value[i]["SummonMobType"] .. "]" )
				return
			end

		end

	end

	-- [SummonTypeTable]
	for index, value in pairs( SummonTypeTable ) do

		if index ~= "None" then

			if value == nil then
				cDebugLog( "SummonTypeTable Data nil : " .. " Index = " .. index )
				return
			end

			if value["SummonGroupType"] == nil then
				cDebugLog( "SummonTypeTable Data SummonGroupType nil : " .. " Index = " .. index )
				return
			end

			if value["CheckRange"] == nil then
				cDebugLog( "SummonTypeTable Data CheckRange nil : " .. " Index = " .. index )
				return
			end

			if value["CoolTime"] == nil then
				cDebugLog( "SummonTypeTable Data CoolTime nil : " .. " Index = " .. index )
				return
			end

			if SummonGroupTypeTable[value["SummonGroupType"]] == nil then
				cDebugLog( "SummonTypeTable nil Value : " .. " Index = " .. index .. " SummonGroupType = " .. i .. "[" .. value["SummonGroupType"] .. "]" )
				return
			end

		end

	end

	-- [EscortGroupTypeTable]
	for index, value in pairs( EscortGroupTypeTable ) do

		if index ~= "None" then

			if value == nil then
				cDebugLog( "EscortGroupTypeTable Data nil : " .. " Index = " .. index )
				return
			end

			for i=1, #value do

				if value[i]["SummonMobType"] == nil then
					cDebugLog( "EscortGroupTypeTable Data SummonMobType nil : " .. " Index = " .. index .. " no = " .. i )
					return
				end

				if SummonMobTypeTable[value[i]["SummonMobType"]] == nil then
					cDebugLog( "EscortGroupTypeTable nil Value : " .. " Index = " .. index .. " no = " .. i .. "[" .. value[i]["SummonMobType"] .. "]" )
					return
				end

			end

		end

	end

	-- [MapMarkTypeTable]
	for index, value in pairs( MapMarkTypeTable ) do

		if index ~= "None" then

			if value == nil then
				cDebugLog( "MapMarkTypeTable Data nil : " .. " Index = " .. index )
				return
			end

			if value["IconIndex"] == nil then
				cDebugLog( "MapMarkTypeTable Data IconIndex nil : " .. " Index = " .. index )
				return
			end

			if value["KeepTime"] == nil then
				cDebugLog( "MapMarkTypeTable Data KeepTime nil : " .. " Index = " .. index )
				return
			end

			if value["Order"] == nil then
				cDebugLog( "MapMarkTypeTable Data Order nil : " .. " Index = " .. index )
				return
			end

		end

	end

	-- [WaveMobTypeTable]
	for index, value in pairs( WaveMobTypeTable ) do

		if value == nil then
			cDebugLog( "WaveMobTypeTable Data nil : " .. "Index = " .. index )
			return
		end

		if value["MobSettingType"] == nil then
			cDebugLog( "WaveMobTypeTable MobSettingType nil : " .. "Index = " .. index )
			return
		end

		if value["BoomType"] == nil then
			cDebugLog( "WaveMobTypeTable BoomType nil : " .. "Index = " .. index )
			return
		end

		if value["ResistType"] == nil then
			cDebugLog( "WaveMobTypeTable ResistType nil : " .. "Index = " .. index )
			return
		end

		if value["SummonType"] == nil then
			cDebugLog( "WaveMobTypeTable SummonType nil : " .. "Index = " .. index )
			return
		end

		if value["EscortGroupType"] == nil then
			cDebugLog( "WaveMobTypeTable EscortGroupType nil : " .. "Index = " .. index )
			return
		end

		if value["MapMarkType"] == nil then
			cDebugLog( "WaveMobTypeTable MapMarkType nil : " .. "Index = " .. index )
			return
		end

		if MobSettingTypeTable[value["MobSettingType"]] == nil then
			cDebugLog( "WaveMobTypeTable nil Value : " .. "MobSettingType = " .. value["MobSettingType"] .." Index = " .. index )
			return
		end

		if BoomTypeTable[value["BoomType"]] == nil then
			if value["BoomType"] ~= "None" then
				cDebugLog( "WaveMobTypeTable nil Value : " .. "BoomType = " .. value["BoomType"] .." Index = " .. index )
				return
			end
		end

		if ResistTypeTable[value["ResistType"]] == nil then
			cDebugLog( "WaveMobTypeTable nil Value : " .. "ResistType = " .. value["ResistType"] .." Index = " .. index )
			return
		end

		if SummonTypeTable[value["SummonType"]] == nil then
			if value["SummonType"] ~= "None" then
				cDebugLog( "WaveMobTypeTable nil Value : " .. "SummonType = " .. value["SummonType"] .." Index = " .. index )
				return
			end
		end

		if EscortGroupTypeTable[value["EscortGroupType"]] == nil then
			if value["EscortGroupType"] ~= "None" then
				cDebugLog( "WaveMobTypeTable nil Value : " .. "EscortGroupType = " .. value["EscortGroupType"] .." Index = " .. index )
				return
			end
		end

		if MapMarkTypeTable[value["MapMarkType"]] == nil then
			if value["MapMarkType"] ~= "None" then
				cDebugLog( "WaveMobTypeTable nil Value : " .. "MapMarkType = " .. value["MapMarkType"] .." Index = " .. index )
				return
			end
		end

	end

	-- [PathTypeTable]
	for index, value in pairs( PathTypeTable ) do

		if value == nil then
			cDebugLog( "PathTypeTable Data nil : " .. "Index = " .. index )
			return
		end

		if #value <= 0 then
			cDebugLog( "PathTypeTable Data nil : " .. "Index = " .. index )
			return
		end

	end

	-- [WaveTable]
	for index, value in pairs( WaveTable ) do

		if value == nil then
			cDebugLog( "WaveTable Data nil : " .. "No = " .. index )
			return
		end

		for i=1, #value do

			if value[i]["WaveMobType"] == nil then
				cDebugLog( "WaveTable Data WaveMobType nil : " .. " Wave = " .. index .. " no = " .. i )
				return
			end

			if value[i]["PathType"] == nil then
				cDebugLog( "WaveTable Data PathType nil : " .. " Wave = " .. index .. " no = " .. i )
				return
			end

			if value[i]["Num"] == nil then
				cDebugLog( "WaveTable Data Num nil : " .. " Wave = " .. index .. " no = " .. i )
				return
			end

			if value[i]["RegenInterval"] == nil then
				cDebugLog( "WaveTable Data RegenInterval nil : " .. " Wave = " .. index .. " no = " .. i )
				return
			end

			if value[i]["WaveStepInterval"] == nil then
				cDebugLog( "WaveTable Data WaveStepInterval nil : " .. " Wave = " .. index .. " no = " .. i )
				return
			end

			if WaveMobTypeTable[value[i]["WaveMobType"]] == nil then
				cDebugLog( "WaveTable nil Value : " .. "WaveMobType = " .. value[i]["WaveMobType"] .. " Wave = " .. index .. " no = " .. i )
				return
			end

			if PathTypeTable[value[i]["PathType"]] == nil then
				cDebugLog( "WaveTable nil Value : " .. "PathType = " .. value[i]["PathType"] .. " Wave = " .. index .. " no = " .. i )
				return
			end
		end

	end


	-- [GateSettingTable]
	for index, value in pairs( GateSettingTable ) do

		if value == nil then
			cDebugLog( "PathTypeTable Data nil : " .. "Index = " .. index )
			return
		end

		if value["Index"] == nil then
			cDebugLog( "GateSettingTable Data Index nil : " .. " index = " .. index )
			return
		end

		if value["RegenX"] == nil then
			cDebugLog( "GateSettingTable Data RegenX nil : " .. " index = " .. index )
			return
		end

		if value["RegenY"] == nil then
			cDebugLog( "GateSettingTable Data RegenY nil : " .. " index = " .. index )
			return
		end

		if value["RegenDir"] == nil then
			cDebugLog( "GateSettingTable Data RegenDir nil : " .. " index = " .. index )
			return
		end

		if value["GoalX"] == nil then
			cDebugLog( "GateSettingTable Data GoalX nil : " .. " index = " .. index )
			return
		end

		if value["GoalY"] == nil then
			cDebugLog( "GateSettingTable Data GoalY nil : " .. " index = " .. index )
			return
		end

		if value["MapMarkType"] == nil then
			cDebugLog( "GateSettingTable Data MapMarkType nil : " .. " index = " .. index )
			return
		end

		if MapMarkTypeTable[value["MapMarkType"]] == nil then
			if value["MapMarkType"] ~= "None" then
				cDebugLog( "GateSettingTable nil Value : " .. "MapMarkType = " .. value["MapMarkType"] .." Index = " .. index )
				return
			end
		end

	end



	-- ����Ʈ ���� �� ��ũ��Ʈ ����

	local GateList = {}

	for i=1, #GateSettingTable do

		local RegenMob = {}

		RegenMob["Handle"] = cMobRegen_XY( Var["MapIndex"],
												GateSettingTable[i]["Index"],
												GateSettingTable[i]["RegenX"],
												GateSettingTable[i]["RegenY"],
												GateSettingTable[i]["RegenDir"] )

		if RegenMob["Handle"] ~= nil then

			RegenMob["GateData"] = GateSettingTable[i]

			-- ������ �ɸ��� ���� �����̻� Ǯ����
			cResetAbstate( RegenMob["Handle"], ABSTATE_IMT_IDX )

			cSetAIScript( SCRIPT_MAIN, RegenMob["Handle"] )
			cAIScriptFunc( RegenMob["Handle"], "Entrance", "GateRoutine" )
			cAIScriptFunc( RegenMob["Handle"], "NPCClick", "GateFunc"    )

			GateList[RegenMob["Handle"]]     = RegenMob
			GateMapIndex[RegenMob["Handle"]] = Var["MapIndex"] -- ����Ʈ�� ���������� ���ε��� ����

		end

	end

	Var["GateList"] = GateList



	-- ��������Ʈ ����

	local DefObjList = {}

	for i=1, #DefenceObjectTable do

		local RegenMob = {}

		RegenMob["Handle"] = cMobRegen_XY( Var["MapIndex"],
												DefenceObjectTable[i]["Index"],
												DefenceObjectTable[i]["x"],
												DefenceObjectTable[i]["y"],
												DefenceObjectTable[i]["dir"] )

		if RegenMob["Handle"] ~= nil then

			RegenMob["Data"]          = DefenceObjectTable[i]
			RegenMob["CurHP"]         = RegenMob["Data"]["HP"]
			RegenMob["CurAni"]        = #AniStateTypeTable[RegenMob["Data"]["AniStateType"]] -- �ִϻ��� ��������
			RegenMob["CurMM"]         = MMGroupTypeTable[RegenMob["Data"]["MMGroupType"]]["Normal"]
			RegenMob["MMGroup"]       = i
			RegenMob["LastCheckTime"] = cCurrentSecond()
			RegenMob["DestroyTime"]   = cCurrentSecond()


			-- ������ �ɸ��� ���� �����̻� Ǯ����
			cResetAbstate( RegenMob["Handle"], ABSTATE_IMT_IDX )

			cSetAIScript( SCRIPT_MAIN, RegenMob["Handle"] )
			cAIScriptFunc( RegenMob["Handle"], "Entrance", "DefObjRoutine" )
			cAIScriptFunc( RegenMob["Handle"], "NPCClick", "DefObjClick"   )
			cAIScriptFunc( RegenMob["Handle"], "NPCMenu",  "DefObjCasting" ) -- ĳ���� �Ϸ��� ó����

			DefObjList[RegenMob["Handle"]]     = RegenMob
			DefObjMapIndex[RegenMob["Handle"]] = Var["MapIndex"]

		end

	end

	Var["DefObjList"] = DefObjList


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
	cNPCRegen( Var["MapIndex"], "MineDigger" )



	Var["StepFunc"] = DummyFunc

end



function InitBalance( Var )

	if Var == nil then
		return
	end

	if Var["MapIndex"] == nil then
		return
	end


	-- ĳ���� ���� �ο��� ���� �뷱�����̺� ���� ����
	local BalanceValue = 0
	local Players      = { cGetPlayerList( Var["MapIndex"] ) }

	for i=1, #Players do

		local class = cGetBaseClass( Players[i] )
		local level = cGetLevel( Players[i] )

		if class ~= nil and level ~= nil then

			if ClassBalanceValue[class] ~= nil then

				-- �뷱���� = ���� * Ŭ����������
				BalanceValue = BalanceValue + ( level * (ClassBalanceValue[class] / 1000) )

			end

		end

	end


	for i=1, #BalanceTable do

		if BalanceValue <= BalanceTable[i]["BalanceValue"] then

			Var["Balance"] = BalanceTable[i]

			break

		end

	end


	-- ���� �غ�� ���̺��� ������ ũ�� ������ ������
	if Var["Balance"] == nil then

		Var["Balance"] = BalanceTable[#BalanceTable]

	end




	-- ��������Ʈ �μ����� ���� ��ȭ�� �뷱���� �ʱ�ȭ

	local FenceBalance = {}
	FenceBalance["DamageRate"] = 1000
	FenceBalance["SpeedRate"]  = 1000
	FenceBalance["HPRate"]     = 1000

	Var["FenceBalance"] = FenceBalance



	Var["StepFunc"] = DummyFunc

end



function WaveProcess( Var )

	if Var == nil then
		return
	end

	if Var["MapIndex"] == nil then
		return
	end


	if Var["InitWave"] == nil then

		Var["InitWave"]         = 1					-- �ƹ����̳� �־��� �ʱ�ȭ üũ��


		Var["WaveStep"]         = 1					-- ū ������ ���̺� ����ܰ�
		Var["WaveInner"]        = 1					-- �� ���̺� �� ����ܰ�
		Var["WaveRegenCount"]   = 0					-- �ϳ��� �ܰ迡�� ��ȯ�� ���� �� �����

		Var["WaveTime"]         = cCurrentSecond()	-- �� ���� ���� üũ��


		local WaveMaxInner  = {}
		local WaveMaxRegen  = {}
		local WaveRunner    = {}

		-- �߰� ���� 2. ���̺� ������ ��, ���� ó�� �ʿ�
		local WaveMaxNo     = 0

		for i=1, #WaveTable do

			WaveMaxInner[i] = #WaveTable[i]
			WaveMaxRegen[i] = {}

			for j=1, #WaveTable[i] do

				WaveMaxRegen[i][j] = WaveTable[i][j]["Num"]

			end

			-- �߰� ���� 2. ���̺� ������ ��, ���� ó�� �ʿ�
			WaveMaxNo = WaveMaxNo + #WaveTable[i]

		end

		Var["WaveMaxStep"]   = #WaveTable		-- ���̺� üũ��
		Var["WaveMaxInner"]  = WaveMaxInner		-- ���̺� üũ��
		Var["WaveMaxRegen"]  = WaveMaxRegen		-- ���̺� üũ��

		Var["WaveRunner"]    = WaveRunner		-- ���̺�� ���� ����

		-- �߰� ���� 2. ���̺� ������ ��, ���� ó�� �ʿ�
		Var["WaveMaxNo"]     = WaveMaxNo		-- ���̺� �� �ܰ�(Inner�� �� ����)
		Var["WaveCurNo"]     = 1				-- ���̺� ���� �ܰ�
	end



	-- ���̺�� �ܰ� üũ. �������� -> ���δܰ� -> ���̺�ܰ�
	if Var["WaveRegenCount"] >= Var["WaveMaxRegen"][Var["WaveStep"]][Var["WaveInner"]] then
		Var["WaveRegenCount"] = 0
		Var["WaveInner"]      = Var["WaveInner"] + 1
		Var["WaveCurNo"]      = Var["WaveCurNo"] + 1
	end

	if Var["WaveInner"] > Var["WaveMaxInner"][Var["WaveStep"]] then
		Var["WaveInner"] = 1
		Var["WaveStep"]  = Var["WaveStep"] + 1
	end

	if Var["WaveStep"] > Var["WaveMaxStep"] then
		Var["InitWave"] = nil
		Var["StepFunc"] = DummyFunc
		return
	end



	local CurWaveData       = WaveTable[Var["WaveStep"]][Var["WaveInner"]]
	local CurMobSettingData = MobSettingTypeTable[WaveMobTypeTable[CurWaveData["WaveMobType"]]["MobSettingType"]]
	local CurWavePathDate   = PathTypeTable[CurWaveData["PathType"]]



	-- ���̺�� ���� �ð� üũ
	local CurTime = cCurrentSecond()
	local DlyTime = CurWaveData["RegenInterval"]

	if Var["WaveRegenCount"] == 0 then
		DlyTime = CurWaveData["WaveStepInterval"]
	end

	if (Var["WaveTime"]) > (CurTime - DlyTime) then
		return
	end


	-- �߰� ���� 2. ���̺� ������ ��, ���� ó�� �ʿ�
	if Var["WaveRegenCount"] == 0 then
		cScriptMessage( Var["MapIndex"], AnnounceInfo["KDMine_Wave_No"], Var["WaveMaxNo"], Var["WaveCurNo"] )
	end


	-- �� ���� �� ����
	local RegenMob = {}
	RegenMob["Handle"]          = cMobRegen_XY( Var["MapIndex"],
												CurMobSettingData["Index"],
												CurWavePathDate[1]["x"],
												CurWavePathDate[1]["y"], 0 )
	if RegenMob["Handle"] ~= nil then

		RegenMob["MapIndex"]        = Var["MapIndex"]

		RegenMob["MobSettingType"]  = MobSettingTypeTable [WaveMobTypeTable[CurWaveData["WaveMobType"]]["MobSettingType" ]]
		RegenMob["BoomType"]        = BoomTypeTable       [WaveMobTypeTable[CurWaveData["WaveMobType"]]["BoomType"       ]]
		RegenMob["SummonType"]      = SummonTypeTable     [WaveMobTypeTable[CurWaveData["WaveMobType"]]["SummonType"     ]]
		RegenMob["EscortGroupType"] = EscortGroupTypeTable[WaveMobTypeTable[CurWaveData["WaveMobType"]]["EscortGroupType"]]
		RegenMob["PathType"]        = PathTypeTable[CurWaveData["PathType"]]
		RegenMob["MapMarkType"]     = MapMarkTypeTable    [WaveMobTypeTable[CurWaveData["WaveMobType"]]["MapMarkType"]]


		local DamageRate = (Var["Balance"]["DamageRate"] + Var["FenceBalance"]["DamageRate"]) / 2000
		local HPRate     = (Var["Balance"]["HPRate"]     + Var["FenceBalance"]["HPRate"]    ) / 2000
		local SpeedRate  = (Var["Balance"]["SpeedRate"]  + Var["FenceBalance"]["SpeedRate"] ) / 2000

		RegenMob["Damage"]          = CurMobSettingData["Demage"]                  * DamageRate

		cSetNPCParam( RegenMob["Handle"], "MaxHP",    CurMobSettingData["HP"]      * HPRate    )
		cSetNPCParam( RegenMob["Handle"], "HP",       CurMobSettingData["HP"]      * HPRate    )
		cSetNPCParam( RegenMob["Handle"], "RunSpeed", CurMobSettingData["Speed"]   * SpeedRate )
		cSetNPCParam( RegenMob["Handle"], "HPRegen",  CurMobSettingData["HPRegen"] )
		cSetNPCParam( RegenMob["Handle"], "AC",       CurMobSettingData["AC"]      )
		cSetNPCParam( RegenMob["Handle"], "MR",       CurMobSettingData["MR"]      )
		cSetNPCParam( RegenMob["Handle"], "MobEXP",   CurMobSettingData["Exp"]     )
		cSetNPCResist( RegenMob["Handle"],            ResistTypeTable[WaveMobTypeTable[CurWaveData["WaveMobType"]]["ResistType"]] )
		cSetNPCIsItemDrop( RegenMob["Handle"],        CurMobSettingData["ItemDrop"] )

		-- ������ �ɸ��� ���� �����̻� Ǯ����
		cResetAbstate( RegenMob["Handle"], ABSTATE_IMT_IDX )

		cSetAIScript( SCRIPT_MAIN, RegenMob["Handle"] )
		cAIScriptFunc( RegenMob["Handle"], "Entrance", "MobRoutine" )

		Var["WaveRunner"][RegenMob["Handle"]] = RegenMob

	end

	-- ����ī��Ʈ ������Ű�� üũ�ð� ����
	Var["WaveRegenCount"]  = Var["WaveRegenCount"] + 1
	Var["WaveTime"]        = cCurrentSecond()

end



function MapMarking( Var )

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

