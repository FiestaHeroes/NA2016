--[[																	]]--
--[[						불타는 아델리아 							]]--
--[[							4지역									]]--
--[[																	]]--

function Zone4_Setting( Var )
cExecCheck "Zone4_Setting"

	if Var == nil then
		return
	end


	Var.Eglack = cMobRegen_XY( Var.MapIndex, RegenInfo.Eglack.Index,
												RegenInfo.Eglack.x,
												RegenInfo.Eglack.y,
												RegenInfo.Eglack.dir   )


	if Var.Eglack == nil then
		cDebugLog( "Default_Setting : Fail cMobRegen_XY Eglack" )
		return
	end

	cSetAbstate( Var.Eglack, "StaSalare00", 1, 20000000 )
	cSetDeadDelayTime ( Var.Eglack, 9999 )

	Var.StepFunc = Dummy

	return
end


function Zone4_Event_1( Var )
cExecCheck "Zone4_Event_1"

	if Var == nil then
		return
	end


	local CurSec = cCurrentSecond()

	-- 루시에가 있고 없고에 따른 대화 내용 설정
	if Var.Zone4_Event_1_Step == nil then

		if Var.SummonStone_Active == "Loussier" then
			Var.Dialog		= DialogInfo.Zone4_Event1_alive
		else
			Var.Dialog		= DialogInfo.Zone4_Event1_Dead
		end

		Var.DialogStep	= 1

		Var.Zone4_Event_1_Step	= 1
		Var.Zone4_EventPlayTime	= CurSec

		return
	end

	-- 대화, 루시에가 있다면 그 다음 단계 실행
	if Var.Zone4_Event_1_Step == 1 then

		if Var.Zone4_EventPlayTime > CurSec then
			return
		end

		if Var.DialogStep <= #Var.Dialog then

			cMobDialog( Var.MapIndex,
						Var.Dialog[Var.DialogStep].Portrait,
						Var.Dialog[Var.DialogStep].FileName,
						Var.Dialog[Var.DialogStep].Index )

			Var.Zone4_EventPlayTime	= CurSec + Var.Dialog[Var.DialogStep].Delay

			Var.DialogStep = Var.DialogStep + 1

			return
		end


		Var.Dialog			= nil
		Var.DialogStep		= nil

		if Var.SummonStone_Active == "Loussier" then
			Var.Zone4_Event_1_Step = 2
		else
			Var.Zone4_Event_1_Step = 99
		end

		Var.Zone4_EventPlayTime	= CurSec

		return
	end


	if Var.Zone4_Event_1_Step == 2 then

		if Var.Zone4_EventPlayTime > CurSec then
			return
		end

		-- 보스 버프 해제 스킬
		if cSkillBlast( Var.LoussierHandle, Var.Eglack, "AdlF_Loussier_Skill01_N", 9999 ) == nil then
			cDebugLog( "Eglack Debuff Fail" )
		end

		-- 보스 버프 해제
		cResetAbstate( Var.Eglack, "StaSalare00" )

		Var.Zone4_Event_1_Step	= 3
		Var.Zone4_EventPlayTime	= CurSec + 4

		return
	end


	if Var.Zone4_Event_1_Step == 3 then

		if Var.Zone4_EventPlayTime > CurSec then
			return
		end

		-- 루시에 무적
		if cSkillBlast( Var.LoussierHandle, Var.LoussierHandle, "AdlF_Loussier_Skill03_N" ) == nil then
			cDebugLog( "Loussier Immortal Fail" )
		end

		Var.Zone4_Event_1_Step	= 4
		Var.Zone4_EventPlayTime	= CurSec

		return
	end

	-- 무적스킬 관련 데이터 수정으로 강제로 상태이상 걸어주는 단계는 삭제
	-- ActiveSkill 에서 캐스팅 시간, 걸리는 상태이상, 확률 수정
	-- SubAbstate 에서 상태이상 지속시간 수정


	-- 공지 출력 - 보스를 죽여라
	cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Mission_04_001 )


	Var.Zone4_Event_1_Step	= nil
	Var.Zone4_EventPlayTime	= nil

	Var.StepFunc			= Dummy
end


function Zone4_Event_2( Var )
cExecCheck "Zone4_Event_2"


	if Var == nil then
		return
	end

	local CurSec = cCurrentSecond()

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 루시에 있을때의 처리
	if Var.SummonStone_Active == "Loussier" then

		if Var.Zone4_Event_2_Step == nil then

			-- 루시에 이동

			local louNewX, louNewY = cGetAroundCoord( Var.Eglack, Var.EglackDeadDir, 100 )

			cNPCVanish( Var.LoussierHandle )

			Var.LoussierHandle = cMobRegen_XY( Var.MapIndex, RegenInfo.Loussier.Index,
																				louNewX,
																				louNewY,
																				Var.EglackDeadDir )

			cSetAIScript( "ID/AdlFH/AdlFH", Var.LoussierHandle )

			Var.Zone4_Event_2_Step	= 1
			Var.Zone4_EventPlayTime	= CurSec + 2

			return
		end


		if Var.Zone4_Event_2_Step == 1 then

			if Var.Zone4_EventPlayTime > CurSec then
				return
			end

			if cSkillBlast( Var.LoussierHandle, Var.Eglack, "AdlF_Loussier_Skill02_N" ) == nil then
				cDebugLog( "Eglack Revive Fail" )
			end

			Var.Zone4_Event_2_Step	= 2
			Var.Zone4_EventPlayTime	= CurSec + 3.5

			return
		end


		if Var.Zone4_Event_2_Step == 2 then

			if Var.Zone4_EventPlayTime > CurSec then
				return
			end


			local eglNewX, eglNewY = cGetAroundCoord( Var.Eglack, Var.EglackDeadDir+180, 100 )

			cNPCVanish( Var.Eglack )

			Var.Eglack = cMobRegen_XY( Var.MapIndex, RegenInfo.EglackMan.Index,
																		eglNewX,
																		eglNewY,
																		Var.EglackDeadDir+ 180 )


			Var.Zone4_Event_2_Step	= 3
			Var.Zone4_EventPlayTime	= CurSec + 2

			Var.Dialog			= DialogInfo.Zone4_Event2_alive_1
			Var.DialogStep		= 1

			return
		end


		if Var.Zone4_Event_2_Step == 3 then

			if Var.Zone4_EventPlayTime > CurSec then
				return
			end

			if Var.DialogStep <= #Var.Dialog then

				cMobDialog( Var.MapIndex,
							Var.Dialog[Var.DialogStep].Portrait,
							Var.Dialog[Var.DialogStep].FileName,
							Var.Dialog[Var.DialogStep].Index )

				Var.Zone4_EventPlayTime	= CurSec + Var.Dialog[Var.DialogStep].Delay

				Var.DialogStep = Var.DialogStep + 1

				return
			end


			Var.Dialog			= nil
			Var.DialogStep		= nil

			Var.Zone4_Event_2_Step	= 4
			Var.Zone4_EventPlayTime	= CurSec + 1

			return
		end


		if Var.Zone4_Event_2_Step == 4 then

			if Var.Zone4_EventPlayTime > CurSec then
				return
			end

			-- 보상 아이템 드랍 처리
			-- 아이템 드랍은 몹 죽을시 자동으로 하기로함
			cQuestMobKill_AllInMap( Var.MapIndex, 2681, "Daliy_Check_Adlf", 5 )


			Var.Zone4_Event_2_Step	= 5
			Var.Zone4_EventPlayTime	= CurSec + 1

			Var.Dialog			= DialogInfo.Zone4_Event2_alive_2
			Var.DialogStep		= 1

			return
		end


		if Var.Zone4_Event_2_Step == 5 then

			if Var.Zone4_EventPlayTime > CurSec then
				return
			end

			if Var.DialogStep <= #Var.Dialog then

				cMobDialog( Var.MapIndex,
							Var.Dialog[Var.DialogStep].Portrait,
							Var.Dialog[Var.DialogStep].FileName,
							Var.Dialog[Var.DialogStep].Index )

				Var.Zone4_EventPlayTime	= CurSec + Var.Dialog[Var.DialogStep].Delay

				Var.DialogStep = Var.DialogStep + 1

				return
			end


			Var.Dialog			= nil
			Var.DialogStep		= nil

			Var.Zone4_Event_2_Step	= 6
			Var.Zone4_EventPlayTime	= CurSec + 1

			return
		end


		-- 출구 게이트 생성
		if Var.Zone4_Event_2_Step == 6 then

			if Var.Zone4_EventPlayTime > CurSec then
				return
			end


			Var.CompleteGate = cMobRegen_XY( Var.MapIndex, RegenInfo.CompleteGate.Index,
																Var.EglackDeadLocX,
																Var.EglackDeadLocY,
																0 )
			if Var.CompleteGate == nil then
				cDebugLog( "Default_Setting : Fail cMobRegen_XY CompleteGate" )
				return
			end

			if cSetAIScript( "ID/AdlFH/AdlFH", Var.CompleteGate ) == nil then
				cDebugLog( "Default_Setting : Fail cSetAIScript CompleteGate" )
				return
			end

			if cAIScriptFunc( Var.CompleteGate, "NPCClick", "CompleteGateFunc" ) == nil then
				cDebugLog( "Default_Setting : Fail cAIScriptFunc CompleteGate" )
				return
			end

			Var.Zone4_Event_2_Step	= 7
			Var.Zone4_EventPlayTime	= CurSec + 1

		end


		Var.Zone4_Event_2_Step	= nil
		Var.Zone4_EventPlayTime	= nil

		Var.StepFunc			= Dummy

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 루시에 없을때의 처리
	else

		if Var.Zone4_Event_2_Step == nil then


			local kerenNewX, kerenNewY = cGetAroundCoord( Var.Eglack, Var.EglackDeadDir, 116 )

			Var.Karen = cMobRegen_XY( Var.MapIndex, RegenInfo.Karen.Index,
																kerenNewX,
																kerenNewY,
																Var.EglackDeadDir )

			cSetAIScript( "ID/AdlFH/AdlFH", Var.Karen )

			Var.Zone4_Event_2_Step = 1
			Var.Zone4_EventPlayTime	= CurSec + 1

			return
		end


		if Var.Zone4_Event_2_Step == 1 then

			if Var.Zone4_EventPlayTime > CurSec then
				return
			end

			if cSkillBlast( Var.Karen, Var.Karen, "AdlF_Karen_Skill02_W" ) == nil then
				cDebugLog( "Karen Sleep Fail" )
			end

			Var.Zone4_Event_2_Step = 2
			Var.Zone4_EventPlayTime	= CurSec + 4.5

			return
		end

		if Var.Zone4_Event_2_Step == 2 then

			if Var.Zone4_EventPlayTime > CurSec then
				return
			end

			local player = { cGetAreaObjectList( Var.MapIndex, AreaIndex.Zone4_2, ObjectType.Player ) }

			for i=1, #player do

				cSetAbstate( player[i], "StaMesmerize", 1, 22000 )

			end

			Var.Zone4_Event_2_Step	= 3
			Var.Zone4_EventPlayTime	= CurSec

			Var.Dialog			= DialogInfo.Zone4_Event2_Dead_1
			Var.DialogStep		= 1

			return
		end


		if Var.Zone4_Event_2_Step == 3 then

			if Var.Zone4_EventPlayTime > CurSec then
				return
			end

			if Var.DialogStep <= #Var.Dialog then

				cMobDialog( Var.MapIndex,
							Var.Dialog[Var.DialogStep].Portrait,
							Var.Dialog[Var.DialogStep].FileName,
							Var.Dialog[Var.DialogStep].Index )

				Var.Zone4_EventPlayTime	= CurSec + Var.Dialog[Var.DialogStep].Delay

				Var.DialogStep = Var.DialogStep + 1

				return
			end


			Var.Dialog			= nil
			Var.DialogStep		= nil

			Var.Zone4_Event_2_Step	= 4
			Var.Zone4_EventPlayTime	= CurSec

			return
		end


		if Var.Zone4_Event_2_Step == 4 then

			if Var.Zone4_EventPlayTime > CurSec then
				return
			end

			if cSkillBlast( Var.Karen, Var.Eglack, "AdlF_Karen_Skill03_N" ) == nil then
				cDebugLog( "Karen Revive Fail" )
			end

			Var.Zone4_Event_2_Step	= 5
			Var.Zone4_EventPlayTime	= CurSec + 3.5

			return
		end


		if Var.Zone4_Event_2_Step == 5 then

			if Var.Zone4_EventPlayTime > CurSec then
				return
			end

			local eglNewX, eglNewY = cGetAroundCoord( Var.Eglack, Var.EglackDeadDir+180, 100 )

			cNPCVanish( Var.Eglack )

			Var.Eglack = cMobRegen_XY( Var.MapIndex, RegenInfo.EglackMad.Index,
																		eglNewX,
																		eglNewY,
																		Var.EglackDeadDir )


			Var.Zone4_Event_2_Step	= 6
			Var.Zone4_EventPlayTime	= CurSec + 1

			return
		end


		Var.Zone4_Event_2_Step	= nil
		Var.Zone4_EventPlayTime	= nil

		Var.StepFunc			= Zone4_Eglack_Mad

	end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


end



function Zone4_Eglack_Mad( Var )
cExecCheck "Zone4_Eglack_Mad"


	if Var == nil then
		return
	end


	local CurSec = cCurrentSecond()

	if Var.Zone4_Event_3_Step == nil then

		if cIsObjectDead( Var.Eglack ) ~= nil then

			Var.EglackDeadLocX, Var.EglackDeadLocY = cObjectLocate( Var.Eglack )

			Var.Zone4_Event_3_Step	= 1
			Var.Zone4_EventPlayTime	= CurSec + 1

			Var.Dialog			= DialogInfo.Zone4_Event3_Dead
			Var.DialogStep		= 1

		end

		return
	end


	if Var.Zone4_Event_3_Step == 1 then

		if Var.Zone4_EventPlayTime > CurSec then
			return
		end

		if Var.DialogStep <= #Var.Dialog then

			cMobDialog( Var.MapIndex,
						Var.Dialog[Var.DialogStep].Portrait,
						Var.Dialog[Var.DialogStep].FileName,
						Var.Dialog[Var.DialogStep].Index )

			Var.Zone4_EventPlayTime	= CurSec + Var.Dialog[Var.DialogStep].Delay

			Var.DialogStep = Var.DialogStep + 1

			return
		end


		Var.Dialog			= nil
		Var.DialogStep		= nil

		Var.Zone4_Event_3_Step	= 2
		Var.Zone4_EventPlayTime	= CurSec

		return
	end


	if Var.Zone4_Event_3_Step == 2 then

		if Var.Zone4_EventPlayTime > CurSec then
			return
		end

		cNPCVanish( Var.Karen )

		-- 보상 아이템 드랍 처리
		-- 아이템 드랍은 몹 죽을시 자동으로 하기로함
		cQuestMobKill_AllInMap( Var.MapIndex, 2681, "Daliy_Check_Adlf", 5 )

		Var.Zone4_Event_3_Step	= 3
		Var.Zone4_EventPlayTime	= CurSec

		return
	end


	if Var.Zone4_Event_3_Step == 3 then

		if Var.Zone4_EventPlayTime > CurSec then
			return
		end

		Var.CompleteGate = cMobRegen_XY( Var.MapIndex, RegenInfo.CompleteGate.Index,
															Var.EglackDeadLocX,
															Var.EglackDeadLocY,
															0 )
		if Var.CompleteGate == nil then
			cDebugLog( "Default_Setting : Fail cMobRegen_XY CompleteGate" )
			return
		end

		if cSetAIScript( "ID/AdlFH/AdlFH", Var.CompleteGate ) == nil then
			cDebugLog( "Default_Setting : Fail cSetAIScript CompleteGate" )
			return
		end

		if cAIScriptFunc( Var.CompleteGate, "NPCClick", "CompleteGateFunc" ) == nil then
			cDebugLog( "Default_Setting : Fail cAIScriptFunc CompleteGate" )
			return
		end

		Var.Zone4_Event_3_Step	= 4
		Var.Zone4_EventPlayTime	= CurSec

		return
	end


	Var.Zone4_Event_3_Step	= nil
	Var.Zone4_EventPlayTime	= nil

	Var.StepFunc			= Dummy

end




