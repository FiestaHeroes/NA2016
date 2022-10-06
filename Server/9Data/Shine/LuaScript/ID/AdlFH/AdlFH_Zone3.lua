--[[																	]]--
--[[						불타는 아델리아 							]]--
--[[							3지역									]]--
--[[																	]]--

function Zone3_Setting( Var )
cExecCheck "Zone3_Setting"

	if Var == nil then
		return
	end


	local CurSec = cCurrentSecond()


	if Var.Zone3_Setting_Step == nil then

		-- 비상작동마법석 및 소환마법석 생성
		Var.Magic_stoneA		= cMobRegen_XY( Var.MapIndex, RegenInfo.MStoneA.Index,  RegenInfo.MStoneA.x,  RegenInfo.MStoneA.y,  RegenInfo.MStoneA.dir  )
		Var.Magic_stoneB		= cMobRegen_XY( Var.MapIndex, RegenInfo.MStoneB.Index,  RegenInfo.MStoneB.x,  RegenInfo.MStoneB.y,  RegenInfo.MStoneB.dir  )
		Var.Magic_stoneC		= cMobRegen_XY( Var.MapIndex, RegenInfo.MStoneC.Index,  RegenInfo.MStoneC.x,  RegenInfo.MStoneC.y,  RegenInfo.MStoneC.dir  )
		Var.SummonStone			= cMobRegen_XY( Var.MapIndex, RegenInfo.SStone.Index,   RegenInfo.SStone.x,   RegenInfo.SStone.y,   RegenInfo.SStone.dir   )


		-- 비상작동마법석 스크립트 셋팅
		if cSetAIScript( "ID/AdlFH/AdlFH", Var.Magic_stoneA ) == nil then
			cDebugLog( "Default_Setting : Fail cSetAIScript Magic_stoneA" )
			return
		end
		if cSetAIScript( "ID/AdlFH/AdlFH", Var.Magic_stoneB ) == nil then
			cDebugLog( "Default_Setting : Fail cSetAIScript Magic_stoneB" )
			return
		end
		if cSetAIScript( "ID/AdlFH/AdlFH", Var.Magic_stoneC ) == nil then
			cDebugLog( "Default_Setting : Fail cSetAIScript Magic_stoneC" )
			return
		end


		-- 3지역 몹 소환
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


function Zone3_WaveMobSummon( Var, MStone, ActiveTime )
cExecCheck "Zone3_WaveMobSummon"


	if Var == nil then
		return
	end

	if Var.MapIndex == nil then
		return
	end

	if Var.CurWave == nil then
		return
	end
	
	if MStone == nil then
		return
	end
	
	if WaveEvent.MobInfo[MStone] == nil
	then
		return
	end

	if Var.CurWave > #WaveEvent.MobInfo[MStone] then
		return
	end


	local SummonInfo = WaveEvent.MobInfo[MStone][Var.CurWave]
	if SummonInfo == nil then
		return
	end


	local SummonNum = SummonInfo.ActiveSummonNum
	if ActiveTime == nil then
		SummonNum = SummonInfo.NonActiveSummonNum
	end


	cAssertLog( "Magic Stone SummonNum : "..SummonNum )


	for i=1, SummonNum do

		local obj = cMobRegen_XY( Var.MapIndex, SummonInfo.MobIndex,  SummonInfo.x,  SummonInfo.y,  SummonInfo.dir  )

		cSetAIScript( "ID/AdlFH/AdlFH", obj )

		-- 웨이브 몬스터 능력치 조정, 아이템 드랍 안시킴
		cSetNPCParam ( obj, "MaxHP",    SummonInfo.HP )
		cSetNPCParam ( obj, "HP",       SummonInfo.HP )
		cSetNPCParam ( obj, "RunSpeed", SummonInfo.RunSpeed )
		cSetNPCParam ( obj, "AC",       SummonInfo.AC )
		cSetNPCParam ( obj, "MR",       SummonInfo.MR )
		cSetNPCParam ( obj, "MobEXP",   SummonInfo.MobEXP )
		cSetNPCIsItemDrop( obj, 0)

		cFollow( obj, Var.SummonStone, 1, 9999999 )

	end

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

		Var.Loussier_Stop		= 1 -- 루시에 멈춤 상태

		cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Msg_03_001 )

		return
	end


	if Var.Zone3_Event_Step == 1 then

		if Var.Zone3_EventPlayTime > CurSec then
			return
		end

		Var.Zone3_Event_Step		= 2
		Var.Zone3_EventPlayTime		= CurSec + WaveEvent.WaveTime[Var.CurWave]
		Var.Zone3_TipMessageTime	= CurSec + WaveEvent.MS_TipMessageTime

		cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Mission_03_003 )

		return
	end


	-- 몹들 리젠, 및 이동
	if Var.Zone3_Event_Step == 2 then

		-- 몹들이 이동상태가 풀렸을때 다시 이동하기 위해
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

			Var.ReMoveTo = CurSec + 1		-- 1초 간격

		end


		if Var.Zone3_TipMessageTime ~= nil then

			if Var.Zone3_TipMessageTime <= CurSec then

				Var.Zone3_TipMessageTime = nil

				cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Tip_03_001 )

			end

		end


		if Var.Zone3_EventPlayTime > CurSec then
			return
		end


		-- 웨이브몹 소환
		if Var.CurWave <= #WaveEvent.WaveTime then

			Zone3_WaveMobSummon( Var, "MStoneA", Var.MagicStoneA_ActiveTime )
			Zone3_WaveMobSummon( Var, "MStoneB", Var.MagicStoneB_ActiveTime )
			Zone3_WaveMobSummon( Var, "MStoneC", Var.MagicStoneC_ActiveTime )


			-- 타이머 안뜬 사람을 위해
			cTimer( Var.MapIndex, (Var.Zone3_WaveTimer - CurSec) )


			-- 마지막 웨이브 반복
			if Var.CurWave < #WaveEvent.WaveTime then
				Var.CurWave	= Var.CurWave + 1
			end


			Var.Zone3_EventPlayTime	= CurSec + WaveEvent.WaveTime[Var.CurWave]

			return
		end


		Var.Zone3_Event_Step	= 3
		Var.Zone3_EventPlayTime	= CurSec

		return
	end


	-- 이쪽으로 오지 않음

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

	-- 진행중이던 정보 초기화
	if Var.Zone3_Reset_Step == nil then

		Var.CurWave				= nil
		Var.ReMoveTo			= nil

		Var.Zone3_Event_Step	= nil
		Var.Zone3_EventPlayTime	= nil

		Var.SummonStone_Active	= nil
		Var.SummonStone_HP		= nil

		Var.Loussier_Stop  		= nil -- 루시에 멈춤 상태 해제

		cTimer( Var.MapIndex, 0 )  -- 타이머 해제

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

		-- 플레이어 킬
		local PlyList = { cGetAreaObjectList( Var.MapIndex, AreaIndex.Zone3_3, ObjectType.Player ) }

		for i=1, #PlyList do
			local curHP, maxHP = cObjectHP( PlyList[i] )

			if maxHP ~= nil then
				cDamaged( PlyList[i], maxHP, Var.Magic_stoneA ) -- 대미지 주는 대상 변경
			end
		end

		-- 몹 킬
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


		-- 토템 초기화
		cAnimate( Var.Magic_stoneA, "stop" )
		cAnimate( Var.Magic_stoneB, "stop" )
		cAnimate( Var.Magic_stoneC, "stop" )

		Var.MagicStoneA_ActiveTime = nil
		Var.MagicStoneB_ActiveTime = nil
		Var.MagicStoneC_ActiveTime = nil


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

	-- 진행중이던 정보 초기화
	if Var.Zone3_Clear_Step == nil then

		Var.CurWave				= nil
		Var.ReMoveTo			= nil

		Var.Zone3_Event_Step	= nil
		Var.Zone3_EventPlayTime	= nil

		Var.Loussier_Stop  		= nil -- 루시에 멈춤 상태 해제

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

		-- 몹 킬
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

		cSetAIScript( "ID/AdlFH/AdlFH", Var.BossRoomGate )

		cAIScriptFunc( Var.BossRoomGate, "NPCClick", "BossRoomGateFunc" )


		-- 소환석 작동 방법이 루시에 라면 루시에 이동
		if Var.SummonStone_Active == "Loussier" then

			cNPCVanish( Var.LoussierHandle )

			Var.LoussierHandle = cMobRegen_XY( Var.MapIndex, RegenInfo.Loussier.Index,
																RegenInfo.Loussier.BossRoomLoc.x,
																RegenInfo.Loussier.BossRoomLoc.y,
																RegenInfo.Loussier.BossRoomLoc.dir )

			cSetAIScript( "ID/AdlFH/AdlFH", Var.LoussierHandle )
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


