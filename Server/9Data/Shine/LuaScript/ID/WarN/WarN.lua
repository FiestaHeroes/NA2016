require( "common" )
require( "ID/WarN/WarNData" )
require( "ID/WarN/WarNFunc" )
require( "ID/WarN/WarNRoutine" )


function Main( Field )
cExecCheck( "Main" )

	local Var = InstanceField[Field]

	if Var == nil then

		InstanceField[Field] = {}

		Var				= InstanceField[Field]
		Var["MapIndex"]	= Field

		Var["StepControl"] = StepControl
		Var["StepFunc"]    = DummyFunc

		cSetFieldScript( Var["MapIndex"], SCRIPT_MAIN )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )

	end


	Var["StepControl"]( Var )
	Var["StepFunc"]( Var )

end


function DummyFunc( Var )
cExecCheck( "DummyFunc" )
end


function StepControl( Var )
cExecCheck( "StepControl" )

	if Var == nil then
		return
	end


	MapMarking( Var ) -- �ʸ�ŷ ó��


	local CurSec = cCurrentSecond()


	-- �ʱ�ȭ, �⺻ �� ���� ����
	if Var["Step"] == nil then

		Var["Step"]     = 1
		Var["StepFunc"] = InitInstanceDungeon	-- �ʱ�ȭ ������ �� �Լ����� Ȯ��

		return

	end


	-- ���̸� ������� ����.
	-- ElementClearEvent -> CenterSetting -> NormalClearEvent -> ElementSetting
	-- �Լ� �ݺ�
	if Var["Step"] == 1 then

		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = ElementClearEvent

		return

	end


	-- ���� Ŭ���� üũ
	-- ���̸��� ����� �����濡�� �����ؼ� �̵� ó��
	if Var["Step"] == 2 then

		local OreNum = 0

		-- ���� ������ Ŭ���� ���� �Ǵ�
		for index, value in pairs( Var["OreList"] ) do

			OreNum = OreNum + 1

		end

		if OreNum < Var["RoomNum"] then

			return

		end

		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = ClearDungeon

		return

	end


	-- ���̸��� ���� �Ÿ� üũ
	if Var["Step"] == 3 then

		if Var["Airi"] == nil then
			Var["Step"] = 99
			return
		end

		if Var["BossOre"] == nil then
			Var["Step"] = 99
			return
		end


		local CurDistSqr = cDistanceSquar( Var["Airi"], Var["BossOre"] )
		local ChkDist    = WARN_END_EVENT["Flw_Gap"] + WARN_END_EVENT["EventDist"]

		if CurDistSqr < ChkDist * ChkDist then

			Var["Step"]     = Var["Step"] + 1
			Var["StepFunc"] = DummyFunc

		end

		return

	end


	-- ��ȭ 1��
	if Var["Step"] == 4 then

		if WarN_Dialog( Var, DialogInfo["WarN_Clear_1"] ) ~= nil then
			return
		end

		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = DummyFunc

		return

	end


	-- ���̸� ���� ������ �ѹ� �� �̵�
	if Var["Step"] == 5 then

		if Var["Airi"] == nil then
			Var["Step"] = 99
			return
		end

		if Var["BossOre"] == nil then
			Var["Step"] = 99
			return
		end

		cFollow( Var["Airi"], Var["BossOre"], WARN_END_EVENT["Flw_Airi"], WARN_END_EVENT["Flw_Airi"] + WARN_END_EVENT["Flw_Gap"] )

		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = DummyFunc

		return

	end


	-- ���̸��� ���� �Ÿ� üũ
	if Var["Step"] == 6 then

		if Var["Airi"] == nil then
			Var["Step"] = 99
			return
		end

		if Var["BossOre"] == nil then
			Var["Step"] = 99
			return
		end


		local CurDistSqr = cDistanceSquar( Var["Airi"], Var["BossOre"] )
		local ChkDist    = WARN_END_EVENT["Flw_Airi"] + WARN_END_EVENT["EventDist"]

		if CurDistSqr < ChkDist * ChkDist then

			Var["Step"]     = Var["Step"] + 1
			Var["StepFunc"] = DummyFunc

		end

		return

	end


	-- ���̸� ���� �ִϸ��̼�
	if Var["Step"] == 7 then

		if Var["Airi"] == nil then
			Var["Step"] = 99
			return
		end

		-- ���̸� �̵��� ���� �������� �ִϸ��̼��� �ٽ� �ٲ� ���ɼ��� �����ؼ� �����ð����� ���
		if Var["StepWait"] == nil then

			Var["StepWait"] = CurSec

		end

		if Var["StepWait"] + WARN_END_EVENT["WaitAiriMove"] > CurSec then

			return

		end


		cAnimate( Var["Airi"], "start", AiriData["ResearchAniIndex"] )


		Var["StepWait"] = nil
		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = DummyFunc

		return

	end


	-- ��ȭ 2��
	if Var["Step"] == 8 then

		if WarN_Dialog( Var, DialogInfo["WarN_Clear_2"] ) ~= nil then
			return
		end


		-- �ⱸ ����Ʈ ����
		if Var["BossOre"] == nil then
			Var["Step"] = 99
			return
		end

		if Var["OreList"][Var["BossOre"]] == nil then
			Var["Step"] = 99
			return
		end


		local CurRoomNum  = Var["RoomOrder"][#Var["RoomOrder"]]
		local CenterCoord = RoomCoordDataTable[Var["RoomData"][CurRoomNum]["Data"]["RoomCoordData"]]["CenterCoord"]
		local RegenCoord  = {}

		RegenCoord["x"], RegenCoord["y"] = cGetAroundCoord( Var["BossOre"], CenterCoord["dir"], WARN_END_EVENT["GateDist"] )


		local ExitGate = {}

		ExitGate["Handle"] = cMobRegen_XY( Var["MapIndex"], GateData["Index"],
															RegenCoord["x"],
															RegenCoord["y"],
															CenterCoord["dir"] )

		if ExitGate["Handle"] ~= nil then

			ExitGate["Data"] = GateData["LinkTo"]

			cSetAIScript( SCRIPT_MAIN, ExitGate["Handle"] )
			cAIScriptFunc( ExitGate["Handle"], "Entrance", "GateRoutine" )
			cAIScriptFunc( ExitGate["Handle"], "NPCClick", "GateClick"   )

			Var["ExitGateList"][ExitGate["Handle"]] = ExitGate
			GateMapIndex[ExitGate["Handle"]]        = Var["MapIndex"] -- ���ε��� ����

		end


		Var["Step"]     = 99
		Var["StepFunc"] = DummyFunc

		return

	end


	if 	Var["Step"] == 99 then

		if WarN_Notice( Var, NoticeInfo["KQReturn"] ) ~= nil then
			return
		end

		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = DummyFunc

	end


	if Var["Step"] == 100 then

		cLinkToAll( Var["MapIndex"], GateData["LinkTo"]["Field"], GateData["LinkTo"]["x"], GateData["LinkTo"]["y"] )

		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = DummyFunc

		return

	end

end
