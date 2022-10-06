--[[																	]]--
--[[						��Ÿ�� �Ƶ����� 							]]--
--[[							2����									]]--
--[[																	]]--

function Zone2_Setting( Var )
cExecCheck "Zone2_Setting"

	if Var == nil then
		return
	end


	-- ����ǵ� ��ȯ
	Var.Zone_2_Darkstone_1	= cMobRegen_XY( Var.MapIndex, RegenInfo.DStone2.Index,  RegenInfo.DStone2.x,  RegenInfo.DStone2.y,  RegenInfo.DStone2.dir  )
	Var.Zone_2_Darkstone_2	= cMobRegen_XY( Var.MapIndex, RegenInfo.DStone3.Index,  RegenInfo.DStone3.x,  RegenInfo.DStone3.y,  RegenInfo.DStone3.dir  )
	Var.Zone_2_Darkstone_3	= cMobRegen_XY( Var.MapIndex, RegenInfo.DStone4.Index,  RegenInfo.DStone4.x,  RegenInfo.DStone4.y,  RegenInfo.DStone4.dir  )

	-- ���� ���ҽ� ȸ�� �ϴ� ���� ������ �ٽ� �߰�
	cSetAIScript( "ID/AdlFH/AdlFH", Var.Zone_2_Darkstone_1 )
	cSetAIScript( "ID/AdlFH/AdlFH", Var.Zone_2_Darkstone_2 )
	cSetAIScript( "ID/AdlFH/AdlFH", Var.Zone_2_Darkstone_3 )

	-- 2���� �� �׷� ����
	for i=1, #RegenInfo.Zone2_Regen_Group do

		cGroupRegenInstance( Var.MapIndex, RegenInfo.Zone2_Regen_Group[i] )

	end

	-- ������ ��ȯ, �����̻�
	for i=1, #RegenInfo.Zone2_Regen_Franger do

		local franger = cMobRegen_XY( Var.MapIndex,
									RegenInfo.Zone2_Regen_Franger[i].Index,
									RegenInfo.Zone2_Regen_Franger[i].x,
									RegenInfo.Zone2_Regen_Franger[i].y,
									RegenInfo.Zone2_Regen_Franger[i].dir )

		cSetAbstate( franger, "StaHideWC", 1, 20000000 )

	end


	Var.StepFunc = Dummy

	return
end



function Zone2_ChatEvent_1( Var )
cExecCheck "Zone2_ChatEvent_1"

	if Var == nil then
		return
	end


	local CurSec = cCurrentSecond()

	if Var.Zone2_ChatEvent_1_Step == nil then

	-- �����ȿ� ������Ʈ ù��°�� �ִ����� üũ
		local Object = cGetAreaObjectList( Var.MapIndex, AreaIndex.Zone2_2, ObjectType.Player )

		if Object == nil then
			return
		end


		Var.Dialog					= nil
		Var.DialogStep				= nil

		Var.Zone2_ChatEvent_1_Step	= 1
		Var.Zone2_EventPlayTime		= CurSec

		return
	end

	-- NPC ��ȭ
	if Var.Zone2_ChatEvent_1_Step == 1 then

		if Var.Zone2_EventPlayTime > CurSec then
			return
		end

		if Var.Dialog == nil then
			Var.Dialog		= DialogInfo.Zone2_Event1
			Var.DialogStep	= 1
		end

		if Var.DialogStep <= #Var.Dialog then

			cMobDialog( Var.MapIndex,
						Var.Dialog[Var.DialogStep].Portrait,
						Var.Dialog[Var.DialogStep].FileName,
						Var.Dialog[Var.DialogStep].Index )

			Var.Zone2_EventPlayTime	= CurSec + Var.Dialog[Var.DialogStep].Delay

			Var.DialogStep = Var.DialogStep + 1

			return
		end


		Var.Dialog					= nil
		Var.DialogStep				= nil

		Var.Zone2_ChatEvent_1_Step	= 2
		Var.Zone2_EventPlayTime		= CurSec

		return
	end


	Var.Zone2_ChatEvent_1_Step	= nil
	Var.Zone2_EventPlayTime		= nil

	Var.StepFunc				= Zone2_ChatEvent_2

	return
end



function Zone2_ChatEvent_2( Var )
cExecCheck "Zone2_ChatEvent_2"

	if Var == nil then
		return
	end


	local CurSec = cCurrentSecond()

	if Var.Zone2_ChatEvent_2_Step == nil then

	-- �����ȿ� ������Ʈ ù��°�� �ִ����� üũ
		local Object = cGetAreaObjectList( Var.MapIndex, AreaIndex.Zone2_3, ObjectType.Player )

		if Object == nil then
			return
		end

		Var.Dialog					= nil
		Var.DialogStep				= nil

		Var.Zone2_ChatEvent_2_Step	= 1
		Var.Zone2_EventPlayTime		= CurSec

		return
	end


	-- ��ȭ ���
	if Var.Zone2_ChatEvent_2_Step == 1 then

		if Var.Zone2_EventPlayTime > CurSec then
			return
		end

		if Var.Dialog == nil then

			local lou = cGetAreaObject( Var.MapIndex, AreaIndex.Zone2_1, Var.LoussierHandle )

			if lou ~= nil then
				Var.Dialog = DialogInfo.Zone2_Event2_alive
			else
				Var.Dialog = DialogInfo.Zone2_Event2_Dead
			end

			Var.DialogStep = 1

		end


		if Var.DialogStep <= #Var.Dialog then

			cMobDialog( Var.MapIndex,
						Var.Dialog[Var.DialogStep].Portrait,
						Var.Dialog[Var.DialogStep].FileName,
						Var.Dialog[Var.DialogStep].Index )

			Var.Zone2_EventPlayTime	= CurSec + Var.Dialog[Var.DialogStep].Delay

			Var.DialogStep = Var.DialogStep + 1

			return
		end


		Var.Dialog					= nil
		Var.DialogStep				= nil

		Var.Zone2_ChatEvent_2_Step	= 2
		Var.Zone2_EventPlayTime		= CurSec + 2

		return
	end


	-- ���� ���
	if Var.Zone2_ChatEvent_2_Step == 2 then

		if Var.Zone2_EventPlayTime > CurSec then
			return
		end

		cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Mission_02_002 )

		Var.Zone2_ChatEvent_2_Step	= 3
		Var.Zone2_EventPlayTime		= CurSec

		return
	end



	Var.Zone2_ChatEvent_2_Step	= nil
	Var.Zone2_EventPlayTime		= nil

	Var.StepFunc				= Dummy

	return
end


function Zone2_ChatEvent_3( Var )
cExecCheck "Zone2_ChatEvent_3"

	if Var == nil then
		return
	end

	local CurSec = cCurrentSecond()


	if Var.Zone2_ChatEvent_3_Step == nil then

		local lou = cGetAreaObject( Var.MapIndex, AreaIndex.Zone2_3, Var.LoussierHandle )

		if lou ~= nil then
			Var.Dialog		= DialogInfo.Zone2_Event3_alive_1
			Var.DialogStep	= 1

			Var.Zone2_ChatEvent_3_Step	= 2

			Var.Loussier_Stop  = 1 -- ��ÿ� ���� ����

		else
			Var.Dialog		= DialogInfo.Zone2_Event3_Dead
			Var.DialogStep	= 1

			Var.Zone2_ChatEvent_3_Step	= 1
		end

		Var.Zone2_EventPlayTime		= CurSec + 1

		return
	end


	-- ��ÿ� ������ ��ȭ
	if Var.Zone2_ChatEvent_3_Step == 1 then

		if Var.Zone2_EventPlayTime > CurSec then
			return
		end

		if Var.DialogStep <= #Var.Dialog then

			cMobDialog( Var.MapIndex,
						Var.Dialog[Var.DialogStep].Portrait,
						Var.Dialog[Var.DialogStep].FileName,
						Var.Dialog[Var.DialogStep].Index )

			Var.Zone2_EventPlayTime	= CurSec + Var.Dialog[Var.DialogStep].Delay

			Var.DialogStep = Var.DialogStep + 1

			return
		end

		Var.Dialog					= nil
		Var.DialogStep				= nil

		Var.Zone2_ChatEvent_3_Step	= 99			-- �ٷ� 3�������� �Ѿ�� ��
		Var.Zone2_EventPlayTime		= CurSec

		return
	end


	-- ��ÿ� ������
	if Var.Zone2_ChatEvent_3_Step == 2 then

		if Var.Zone2_EventPlayTime > CurSec then
			return
		end


		if Var.DialogStep <= #Var.Dialog then

			cMobDialog( Var.MapIndex,
						Var.Dialog[Var.DialogStep].Portrait,
						Var.Dialog[Var.DialogStep].FileName,
						Var.Dialog[Var.DialogStep].Index )

			Var.Zone2_EventPlayTime	= CurSec + Var.Dialog[Var.DialogStep].Delay

			Var.DialogStep = Var.DialogStep + 1

			return
		end

		Var.Dialog					= nil
		Var.DialogStep				= nil

		Var.Zone2_ChatEvent_3_Step	= 3
		Var.Zone2_EventPlayTime		= CurSec

		return
	end


	if Var.Zone2_ChatEvent_3_Step == 3 then

		if Var.Zone2_EventPlayTime > CurSec then
			return
		end

		local lou = cGetAreaObject( Var.MapIndex, AreaIndex.Zone2_3, Var.LoussierHandle )

		if lou == nil then
			Var.Zone2_ChatEvent_3_Step	= 99
			return
		end


		cNPCVanish( Var.LoussierHandle )

		Var.Zone2_ChatEvent_3_Step	= 4
		Var.Zone2_EventPlayTime		= CurSec

		return
	end


	if Var.Zone2_ChatEvent_3_Step == 4 then

		if Var.Zone2_EventPlayTime > CurSec then
			return
		end

		if	Var.SalareDeadLocX == nil or
			Var.SalareDeadLocY == nil or
			Var.SalareDeadDir == nil then

			Var.Zone2_ChatEvent_3_Step	= 99
			return
		end


		local louNewX, louNewY = cGetAroundCoord( Var.Salare, Var.SalareDeadDir, 100 )

		if louNewX == nil or louNewY == nil then
			Var.Zone2_ChatEvent_3_Step	= 99
			return
		end

		Var.LoussierHandle = cMobRegen_XY( Var.MapIndex, RegenInfo.Loussier.Index,
																		louNewX,
																		louNewY,
																		Var.SalareDeadDir )

		cSetAIScript( "ID/AdlFH/AdlFH", Var.LoussierHandle )

		if Var.LoussierHandle == nil then
			Var.Zone2_ChatEvent_3_Step	= 99
			return
		end


		Var.Dialog		= DialogInfo.Zone2_Event3_alive_2
		Var.DialogStep	= 1


		Var.Zone2_ChatEvent_3_Step	= 5
		Var.Zone2_EventPlayTime		= CurSec + 2

		return
	end


	if Var.Zone2_ChatEvent_3_Step == 5 then

		if Var.Zone2_EventPlayTime > CurSec then
			return
		end

		cSkillBlast( Var.LoussierHandle, Var.Salare, "AdlF_Loussier_Skill02_N" )

		Var.Zone2_ChatEvent_3_Step	= 6
		Var.Zone2_EventPlayTime		= CurSec

		return
	end




	if Var.Zone2_ChatEvent_3_Step == 6 then

		if Var.Zone2_EventPlayTime > CurSec then
			return
		end


		if Var.DialogStep <= #Var.Dialog then

			cMobDialog( Var.MapIndex,
						Var.Dialog[Var.DialogStep].Portrait,
						Var.Dialog[Var.DialogStep].FileName,
						Var.Dialog[Var.DialogStep].Index )

			Var.Zone2_EventPlayTime	= CurSec + Var.Dialog[Var.DialogStep].Delay

			Var.DialogStep = Var.DialogStep + 1

			return
		end

		Var.Dialog					= nil
		Var.DialogStep				= nil

		Var.Zone2_ChatEvent_3_Step	= 7
		Var.Zone2_EventPlayTime		= CurSec + 3.5

		return
	end


	if Var.Zone2_ChatEvent_3_Step == 7 then

		if Var.Zone2_EventPlayTime > CurSec then
			return
		end

		if	Var.SalareDeadLocX == nil or
			Var.SalareDeadLocY == nil or
			Var.SalareDeadDir == nil then

			Var.Zone2_ChatEvent_3_Step	= 99
			return
		end


		local salNewX, salNewY = cGetAroundCoord( Var.Salare, Var.SalareDeadDir+180, 100 )

		if salNewX == nil or salNewY == nil then
			Var.Zone2_ChatEvent_3_Step	= 99
			return
		end

		cNPCVanish( Var.Salare )

		Var.Salare = cMobRegen_XY( Var.MapIndex, RegenInfo.SalareMan.Index,
																salNewX,
																salNewY,
																Var.SalareDeadDir )


		if Var.Salare == nil then
			Var.Zone2_ChatEvent_3_Step	= 99
			return
		end


		Var.Dialog		= DialogInfo.Zone2_Event3_alive_3
		Var.DialogStep	= 1


		Var.Zone2_ChatEvent_3_Step	= 8
		Var.Zone2_EventPlayTime		= CurSec + 3

		return
	end


	if Var.Zone2_ChatEvent_3_Step == 8 then

		if Var.Zone2_EventPlayTime > CurSec then
			return
		end

		if Var.DialogStep <= #Var.Dialog then

			cMobDialog( Var.MapIndex,
						Var.Dialog[Var.DialogStep].Portrait,
						Var.Dialog[Var.DialogStep].FileName,
						Var.Dialog[Var.DialogStep].Index )

			Var.Zone2_EventPlayTime	= CurSec + Var.Dialog[Var.DialogStep].Delay

			Var.DialogStep = Var.DialogStep + 1

			return
		end


		Var.Dialog					= nil
		Var.DialogStep				= nil

		Var.Zone2_ChatEvent_3_Step	= 9
		Var.Zone2_EventPlayTime		= CurSec

		return
	end


	if Var.Zone2_ChatEvent_3_Step == 9 then

		if Var.Zone2_EventPlayTime > CurSec then
			return
		end

		Var.Loussier_Stop  = nil -- ��ÿ� ���� ���� ����

		Var.Zone2_ChatEvent_3_Step	= 10
		Var.Zone2_EventPlayTime		= CurSec

		return
	end

	-- ���� ���� �� ���� ���
	cDoorAction( Var.Door2, RegenInfo.Door2.Block, "open" )

	cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Msg_02_002 )



	Var.Dialog					= nil
	Var.DialogStep				= nil

	Var.Zone2_ChatEvent_2_Step	= nil
	Var.Zone2_EventPlayTime		= nil

	Var.StepFunc				= Dummy

end

