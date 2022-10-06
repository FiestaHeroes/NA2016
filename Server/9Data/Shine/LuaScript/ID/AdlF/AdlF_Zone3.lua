--[[																	]]--
--[[						��Ÿ�� �Ƶ����� 							]]--
--[[							3����									]]--
--[[																	]]--

function Zone3_Setting( Var )
cExecCheck "Zone3_Setting"

	if Var == nil then
		return
	end


	local CurSec = cCurrentSecond()


	if Var.Zone3_Setting_Step == nil then

		-- ����۵������� �� ��ȯ������ ����
		Var.Magic_stoneA		= cMobRegen_XY( Var.MapIndex, RegenInfo.MStoneA.Index,  RegenInfo.MStoneA.x,  RegenInfo.MStoneA.y,  RegenInfo.MStoneA.dir  )
		Var.Magic_stoneB		= cMobRegen_XY( Var.MapIndex, RegenInfo.MStoneB.Index,  RegenInfo.MStoneB.x,  RegenInfo.MStoneB.y,  RegenInfo.MStoneB.dir  )
		Var.Magic_stoneC		= cMobRegen_XY( Var.MapIndex, RegenInfo.MStoneC.Index,  RegenInfo.MStoneC.x,  RegenInfo.MStoneC.y,  RegenInfo.MStoneC.dir  )
		Var.SummonStone			= cMobRegen_XY( Var.MapIndex, RegenInfo.SStone.Index,   RegenInfo.SStone.x,   RegenInfo.SStone.y,   RegenInfo.SStone.dir   )


		-- ����۵������� ��ũ��Ʈ ����
		if cSetAIScript( "ID/AdlF/AdlF", Var.Magic_stoneA ) == nil then
			cDebugLog( "Default_Setting : Fail cSetAIScript Magic_stoneA" )
			return
		end
		if cSetAIScript( "ID/AdlF/AdlF", Var.Magic_stoneB ) == nil then
			cDebugLog( "Default_Setting : Fail cSetAIScript Magic_stoneB" )
			return
		end
		if cSetAIScript( "ID/AdlF/AdlF", Var.Magic_stoneC ) == nil then
			cDebugLog( "Default_Setting : Fail cSetAIScript Magic_stoneC" )
			return
		end


		-- 3���� �� ��ȯ
		for i=1, #RegenInfo.Zone3_Regen_Group do

			cGroupRegenInstance( Var.MapIndex, RegenInfo.Zone3_Regen_Group[i] )

		end


		Var.Dialog		= DialogInfo.Zone3_ChatEvent
		Var.DialogStep	= 1

		Var.Zone3_Setting_Step		= 1
		Var.Zone3_Setting_Step_Delay= CurSec

	end


	if Var.Zone3_Setting_Step == 1 then

		if Var.Zone3_Setting_Step_Delay > CurSec then
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

		Var.Zone3_Setting_Step		= 2
		Var.Zone3_Setting_Step_Delay= CurSec

		return
	end


	if Var.LoussierHandle == nil then
		cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Mission_03_001, 0 )
	else
		cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Mission_03_002 )
	end

	Var.Zone3_Setting_Step_Delay= nil
	Var.Zone3_Setting_Step		= nil

	Var.StepFunc				= Dummy

	return
end



function Zone3_WaveEvent( Var )
cExecCheck "Zone3_WaveEvent"

	if Var == nil then
		return
	end


	local CurSec = cCurrentSecond()


	if Var.Zone3_Event_Step == nil then

		Var.CurWave				= 1
		Var.ReMoveTo			= CurSec

		Var.Zone3_Event_Step	= 1
		Var.Zone3_EventPlayTime	= CurSec + 1

		Var.Loussier_Stop		= 1 -- ��ÿ� ���� ����

		cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Msg_03_001 )

		return
	end


	if Var.Zone3_Event_Step == 1 then

		if Var.Zone3_EventPlayTime > CurSec then
			return
		end

		Var.Zone3_Event_Step	= 2
		Var.Zone3_EventPlayTime	= CurSec + WaveEvent.WaveTime[Var.CurWave]

		cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Mission_03_003 )

		return
	end


	-- ���� ����, �� �̵�
	if Var.Zone3_Event_Step == 2 then

		-- ������ �̵����°� Ǯ������ �ٽ� �̵��ϱ� ����
		if Var.ReMoveTo < CurSec then

			local mob = { cGetAreaObjectList( Var.MapIndex, AreaIndex.Zone3_3, ObjectType.Mob ) }

			for i=1, #mob do

				if	mob[i] ~= Var.Magic_stoneA	and
					mob[i] ~= Var.Magic_stoneB	and
					mob[i] ~= Var.Magic_stoneC	and
					mob[i] ~= Var.SummonStone	and
					mob[i] ~= Var.LoussierHandle then

					cFollow( mob[i], Var.SummonStone, 1, 9999999 )

				end

			end

			Var.ReMoveTo = CurSec + 1		-- 1�� ����

		end

		if Var.Zone3_EventPlayTime > CurSec then
			return
		end


		-- ���̺�� ��ȯ
		if Var.CurWave <= #WaveEvent.MobInfo then

			local Wave = WaveEvent.MobInfo[Var.CurWave]

			for i=1, #Wave do

				local obj = cMobRegen_XY( Var.MapIndex, Wave[i].MobIndex,  Wave[i].x,  Wave[i].y,  Wave[i].dir  )

				cSetAIScript( "ID/AdlF/AdlF", obj )

				-- ���̺� ���� �ɷ�ġ ����, ������ ��� �Ƚ�Ŵ
				cSetNPCParam ( obj, "MaxHP",    Wave[i].HP )
				cSetNPCParam ( obj, "HP",       Wave[i].HP )
				cSetNPCParam ( obj, "RunSpeed", Wave[i].RunSpeed )
				cSetNPCParam ( obj, "AC",       Wave[i].AC )
				cSetNPCParam ( obj, "MR",       Wave[i].MR )
				cSetNPCParam ( obj, "MobEXP",   Wave[i].MobEXP )
				cSetNPCIsItemDrop( obj, 0)

				cFollow( obj, Var.SummonStone, 1, 9999999 )

			end


			-- Ÿ�̸� �ȶ� ����� ����
			cTimer( Var.MapIndex, (Var.Zone3_WaveTimer - CurSec) )


			-- ������ ���̺� �ݺ�
			if Var.CurWave < #WaveEvent.MobInfo then
				Var.CurWave			= Var.CurWave + 1
			end


			Var.Zone3_EventPlayTime	= CurSec + WaveEvent.WaveTime[Var.CurWave]

			return
		end


		Var.Zone3_Event_Step	= 3
		Var.Zone3_EventPlayTime	= CurSec

		return
	end


	-- �������� ���� ����

	Var.CurWave				= nil
	Var.ReMoveTo			= nil

	Var.Zone3_Event_Step	= nil
	Var.Zone3_EventPlayTime	= nil
	Var.StepFunc			= Dummy

	return
end


function Zone3_WaveEvent_Reset( Var )
cExecCheck "Zone3_WaveEvent_Reset"

	if Var == nil then
		return
	end


	local CurSec = cCurrentSecond()

	-- �������̴� ���� �ʱ�ȭ
	if Var.Zone3_Reset_Step == nil then

		Var.CurWave				= nil
		Var.ReMoveTo			= nil

		Var.Zone3_Event_Step	= nil
		Var.Zone3_EventPlayTime	= nil

		Var.SummonStone_Active	= nil
		Var.SummonStone_HP		= nil

		Var.Loussier_Stop  		= nil -- ��ÿ� ���� ���� ����

		cTimer( Var.MapIndex, 0 )  -- Ÿ�̸� ����

		Var.Zone3_Reset_Step		= 1
		Var.Zone3_Reset_Step_Delay	= CurSec
	end


	if Var.Zone3_Reset_Step == 1 then

		local curHP, maxHP = cObjectHP( Var.SummonStone )

		if maxHP ~= nil then
			cDamaged( Var.SummonStone, maxHP, Var.Magic_stoneA )
		end

		Var.Zone3_Reset_Step		= 2
		Var.Zone3_Reset_Step_Delay	= CurSec + 1

		return
	end

	if Var.Zone3_Reset_Step == 2 then

		if Var.Zone3_Reset_Step_Delay > CurSec then
			return
		end

		-- �÷��̾� ų
		local PlyList = { cGetAreaObjectList( Var.MapIndex, AreaIndex.Zone3_3, ObjectType.Player ) }

		for i=1, #PlyList do
			local curHP, maxHP = cObjectHP( PlyList[i] )

			if maxHP ~= nil then
				cDamaged( PlyList[i], maxHP, Var.Magic_stoneA ) -- ����� �ִ� ��� ����
			end
		end

		-- �� ų
		local MobList = { cGetAreaObjectList( Var.MapIndex, AreaIndex.Zone3_3, ObjectType.Mob ) }

		for i=1, #MobList do

			if	MobList[i] ~= Var.Magic_stoneA and
				MobList[i] ~= Var.Magic_stoneB and
				MobList[i] ~= Var.Magic_stoneC then

				local curHP, maxHP = cObjectHP( MobList[i] )

				cDamaged( MobList[i], maxHP, Var.Magic_stoneA )
			end

		end

		Var.Zone3_Reset_Step		= 3
		Var.Zone3_Reset_Step_Delay	= CurSec + 3

		return
	end

	if Var.Zone3_Reset_Step == 3 then

		if Var.Zone3_Reset_Step_Delay > CurSec then
			return
		end

		cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Msg_03_F_001 )

		Var.Zone3_Reset_Step		= 4
		Var.Zone3_Reset_Step_Delay	= CurSec + 10

		return
	end

	if Var.Zone3_Reset_Step == 4 then

		if Var.Zone3_Reset_Step_Delay > CurSec then
			return
		end

		Var.SummonStone = cMobRegen_XY( Var.MapIndex, RegenInfo.SStone.Index, RegenInfo.SStone.x, RegenInfo.SStone.y, RegenInfo.SStone.dir )

		if Var.SummonStone == nil then
			return
		end


		Var.Zone3_Reset_Step		= 5
		Var.Zone3_Reset_Step_Delay	= CurSec

		return
	end


	Var.Zone3_Reset_Step		= nil
	Var.Zone3_Reset_Step_Delay	= nil

	Var.StepFunc				= Dummy

	return
end


function Zone3_WaveEvent_Clear( Var )
cExecCheck "Zone3_WaveEvent_Clear"

	if Var == nil then
		return
	end

	local CurSec = cCurrentSecond()

	-- �������̴� ���� �ʱ�ȭ
	if Var.Zone3_Clear_Step == nil then

		Var.CurWave				= nil
		Var.ReMoveTo			= nil

		Var.Zone3_Event_Step	= nil
		Var.Zone3_EventPlayTime	= nil

		Var.Loussier_Stop  		= nil -- ��ÿ� ���� ���� ����

		Var.Zone3_Clear_Step		= 1
		Var.Zone3_Clear_Step_Delay	= CurSec
	end


	if Var.Zone3_Clear_Step == 1 then

		if Var.Zone3_Clear_Step_Delay > CurSec then
			return
		end

		cAnimate( Var.SummonStone, "stop" )

		cSkillBlast( Var.SummonStone, Var.SummonStone,"RStone_Skill01_W" )

		Var.Zone3_Clear_Step		= 2
		Var.Zone3_Clear_Step_Delay	= CurSec + 1

		return
	end


	if Var.Zone3_Clear_Step == 2 then

		if Var.Zone3_Clear_Step_Delay > CurSec then
			return
		end

		-- �� ų
		local MobList = { cGetAreaObjectList( Var.MapIndex, AreaIndex.Zone3_3, ObjectType.Mob ) }

		for i=1, #MobList do

			if	MobList[i] ~= Var.Magic_stoneA and
				MobList[i] ~= Var.Magic_stoneB and
				MobList[i] ~= Var.Magic_stoneC and
				MobList[i] ~= Var.SummonStone  and
				MobList[i] ~= Var.LoussierHandle then

				local curHP, maxHP = cObjectHP( MobList[i] )

				cDamaged( MobList[i], maxHP, Var.SummonStone )
			end

		end

		Var.Zone3_Clear_Step		= 3
		Var.Zone3_Clear_Step_Delay	= CurSec + 1

		return
	end


	if Var.Zone3_Clear_Step == 3 then

		if Var.Zone3_Clear_Step_Delay > CurSec then
			return
		end

		Var.BossRoomGate = cMobRegen_XY( Var.MapIndex,
											RegenInfo.BossRoomGate.Index,
											RegenInfo.BossRoomGate.x,
											RegenInfo.BossRoomGate.y,
											RegenInfo.BossRoomGate.dir )


		if Var.BossRoomGate == nil then
			cDebugLog( "Fail cMobRegen_XY BossRoomGate" )
			return
		end

		cSetAIScript( "ID/AdlF/AdlF", Var.BossRoomGate )

		cAIScriptFunc( Var.BossRoomGate, "NPCClick", "BossRoomGateFunc" )


		-- ��ȯ�� �۵� ����� ��ÿ� ��� ��ÿ� �̵�
		if Var.SummonStone_Active == "Loussier" then

			cNPCVanish( Var.LoussierHandle )

			Var.LoussierHandle = cMobRegen_XY( Var.MapIndex, RegenInfo.Loussier.Index,
																RegenInfo.Loussier.BossRoomLoc.x,
																RegenInfo.Loussier.BossRoomLoc.y,
																RegenInfo.Loussier.BossRoomLoc.dir )

			cSetAIScript( "ID/AdlF/AdlF", Var.LoussierHandle )
		end

		Var.Zone3_Clear_Step		= 4
		Var.Zone3_Clear_Step_Delay	= CurSec

		return
	end


	Var.Zone3_Clear_Step		= nil
	Var.Zone3_Clear_Step_Delay	= nil

	Var.StepFunc				= Zone4_Setting


	return
end


