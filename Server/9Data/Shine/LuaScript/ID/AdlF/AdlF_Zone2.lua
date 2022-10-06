--[[																	]]--
--[[						불타는 아델리아 							]]--
--[[							2지역									]]--
--[[																	]]--

function Zone2_Setting( Var )
cExecCheck "Zone2_Setting"

	if Var == nil then
		return
	end


	-- 어둠의돌 소환
	Var.Zone_2_Darkstone_1	= cMobRegen_XY( Var.MapIndex, RegenInfo.DStone2.Index,  RegenInfo.DStone2.x,  RegenInfo.DStone2.y,  RegenInfo.DStone2.dir  )
	Var.Zone_2_Darkstone_2	= cMobRegen_XY( Var.MapIndex, RegenInfo.DStone3.Index,  RegenInfo.DStone3.x,  RegenInfo.DStone3.y,  RegenInfo.DStone3.dir  )
	Var.Zone_2_Darkstone_3	= cMobRegen_XY( Var.MapIndex, RegenInfo.DStone4.Index,  RegenInfo.DStone4.x,  RegenInfo.DStone4.y,  RegenInfo.DStone4.dir  )

	-- 공격 당할시 회전 하는 문제 때문에 다시 추가
	cSetAIScript( "ID/AdlF/AdlF", Var.Zone_2_Darkstone_1 )
	cSetAIScript( "ID/AdlF/AdlF", Var.Zone_2_Darkstone_2 )
	cSetAIScript( "ID/AdlF/AdlF", Var.Zone_2_Darkstone_3 )

	-- 2지역 몹 그룹 리젠
	for i=1, #RegenInfo.Zone2_Regen_Group do

		cGroupRegenInstance( Var.MapIndex, RegenInfo.Zone2_Regen_Group[i] )

	end

	-- 정찰자 소환, 상태이상
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

	-- 지역안에 오브젝트 첫번째가 있는지만 체크
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

	-- NPC 대화
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

	-- 지역안에 오브젝트 첫번째가 있는지만 체크
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


	-- 대화 출력
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


	-- 공지 출력
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
			Var.Dialog		= DialogInfo.Zone2_Event3_alive
			Var.DialogStep	= 1

			Var.Zone2_ChatEvent_3_Step	= 2

			Var.Loussier_Stop  = 1 -- 루시에 멈춤 상태

		else
			Var.Dialog		= DialogInfo.Zone2_Event3_Dead
			Var.DialogStep	= 1

			Var.Zone2_ChatEvent_3_Step	= 1
		end

		Var.Zone2_EventPlayTime		= CurSec + 1

		return
	end


	-- 루시에 없을때 대화
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

		Var.Zone2_ChatEvent_3_Step	= 99			-- 바로 3지역으로 넘어가면 됨
		Var.Zone2_EventPlayTime		= CurSec

		return
	end


	-- 루시에 있을때
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


		Var.Loussier_Stop			= nil -- 루시에 멈춤 상태 해제

		Var.Dialog					= nil
		Var.DialogStep				= nil

		Var.Zone2_ChatEvent_3_Step	= 99
		Var.Zone2_EventPlayTime		= CurSec

		return
	end


	-- 관문 해제 및 공지 출력
	cDoorAction( Var.Door2, RegenInfo.Door2.Block, "open" )

	cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Msg_02_002 )



	Var.Dialog					= nil
	Var.DialogStep				= nil

	Var.Zone2_ChatEvent_2_Step	= nil
	Var.Zone2_EventPlayTime		= nil

	Var.StepFunc				= Dummy

end

