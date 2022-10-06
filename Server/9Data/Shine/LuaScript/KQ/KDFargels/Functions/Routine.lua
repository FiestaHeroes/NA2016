--------------------------------------------------------------------------------
--                          KDFargels Routine Func                            --
--------------------------------------------------------------------------------

function PlayerMapLogin( Field, Handle )
cExecCheck( "PlayerMapLogin" )

	if Field == nil or Handle == nil then

		return

	end

	local EventMemory = InstanceField[Field]

	if EventMemory == nil then

		return

	end


	local PlayerList = EventMemory["PlayerList"]

	if PlayerList == nil then

		return

	end

	if PlayerList[Handle] == nil and cIsKQJoiner( Handle ) == true then

		PlayerList[Handle] 			= { }
		EventMemory["PlayerLogin"]	= true

	end

	if Field ~= nil and EventMemory["CheckLimitTime"] ~= nil then

		local RestLimitTime = EventMemory["CheckLimitTime"] - cCurrentSecond()
		local LimitTime		= cGetKQLimitSecond( Field )

		if LimitTime ~= nil then

			if 0 < RestLimitTime and RestLimitTime <= LimitTime then

				--cTimer_Obj( Handle, RestLimitTime )
				cShowKQTimerWithLife_Obj( Handle, RestLimitTime )

			end

		end

	end

end

function TORIN_ROUTINE( Handle, MapIndex )
cExecCheck( "TORIN_ROUTINE" )

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	local EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventData["TorinList"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventData["TorinList"][Handle] = nil

		return ReturnAI["END"]

	end


	return ReturnAI["CPP"]

end

function DLICH_ROUTINE( Handle, MapIndex )
cExecCheck( "DLICH_ROUTINE" )


	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	local EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventData["DLichList"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventData["DLichList"][Handle] = nil

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end

function EPIS_ROUTINE( Handle, MapIndex )
cExecCheck( "EPIS_ROUTINE" )

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	local EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventData["EpisList"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventData["EpisList"][Handle] = nil

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end

function FARGELS_ROUTINE( Handle, MapIndex )
cExecCheck( "FARGELS_ROUTINE" )

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	local EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventData["FargelsList"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventData["FargelsList"][Handle] = nil

		return ReturnAI["END"]

	end

	local Fargels = EventData["FargelsList"][Handle]

	if Fargels == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	local HP, MaxHP = cObjectHP( Handle )

	if MaxHP == 0 then

		return ReturnAI["END"]

	end

	local HPRate = HP / MaxHP * 100

	-- Fargels Skill
	for i = 1, #FARGELS_SKILL do

		local SkillIndex 	= FARGELS_SKILL[i]["SKILL_INDEX"]
		local MinHPRate 	= FARGELS_SKILL[i]["MINHPRATE"]
		local MaxHPRate		= FARGELS_SKILL[i]["MAXHPRATE"]
		local Delay			= FARGELS_SKILL[i]["DELAY"]
		local Range			= FARGELS_SKILL[i]["RANGE"]
		local AbstateData	= FARGELS_SKILL[i]["ABSTATE"]
		local Func			= FARGELS_SKILL[i]["FUNC"]

		-- skill
		if MinHPRate < HPRate and HPRate <= MaxHPRate then

			if Fargels["SkillList"][i]["CheckTime"] <= EventMemory["CurrentTime"] then

				local ClassList 	= { 1, 6, 11, 16, 21, 26 }
				local PlayerHandle 	= cFindNearPlayer( Handle, Range, ClassList )

				if PlayerHandle ~= nil and SkillIndex ~= nil then

					cSkillBlast( Handle, PlayerHandle, SkillIndex )

				end

				-- abstate
				local AbstateList = Fargels["SkillList"][i]["AbstateList"]

				for j = 1, #AbstateList do

					local KeepTime		= AbstateData[j]["KEEPTIME"]
					local PrepareTime	= AbstateData[j]["PREPARETIME"]

					AbstateList[j]["CheckKeepTime"]		= EventMemory["CurrentTime"] + KeepTime
					AbstateList[j]["CheckPrepareTime"]	= EventMemory["CurrentTime"] + PrepareTime
					AbstateList[j]["Enable"]			= true

				end

				--cDebugLog( "cSkillBlast : " .. SkillIndex )

				Fargels["SkillList"][i]["CheckTime"] = EventMemory["CurrentTime"] + Delay

			end

		end

		if Func ~= nil then

			Func( EventMemory, Handle, Fargels["SkillList"][i], FARGELS_SKILL[i] )

		end

	end

	return ReturnAI["CPP"]

end

function GUARDIANS_ROUTINE( Handle, MapIndex )
cExecCheck( "GUARDIANS_ROUTINE" )

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	local EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventData["GuardiansList"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		cAIScriptSet( Handle )
		EventData["GuardiansList"][Handle] = nil

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]
end

function REGENOBJECT_ROUTINE( Handle, MapIndex )
cExecCheck( "REGENOBJECT_ROUTINE" )

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	local EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventData["RegenObjectList"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	local RegenObject = EventData["RegenObjectList"][Handle]

	if RegenObject == nil then

		cAIScriptSet( Handle )
		EventData["RegenObjectList"][Handle] = nil
		return ReturnAI["END"]

	end

	local RegenObjectData 	= RegenObject["REGENOBJECT_DATA"]
	local RegenInfoList		= RegenObject["RegenInfoList"]

	if cIsObjectDead( Handle ) then

		if RegenObject["EventNumber"] ~= EventMemory["EventNumber"] then

			cAIScriptSet( Handle )
			EventData["RegenObjectList"][Handle] = nil
			return ReturnAI["END"]

		end

		if RegenObjectData["REGEN_CONDITION"] == REGEN_CONDITION["REMOVE"] then

			RegenObject["CheckCondition"] = true

		else

			cAIScriptSet( Handle )
			EventData["RegenObjectList"][Handle] = nil
			return ReturnAI["END"]

		end

	end

	if RegenObject["EventNumber"] ~= EventMemory["EventNumber"] then

		return ReturnAI["END"]

	end

	if RegenObject["CheckCondition"] == false then

		if RegenObjectData["REGEN_CONDITION"] == REGEN_CONDITION["NORMAL"] then

			RegenObject["CheckCondition"] = true

		elseif RegenObjectData["REGEN_CONDITION"] == REGEN_CONDITION["SENSOR"] then

			local FindPlayer = cObjectFind( Handle, RegenObjectData["RANGE"], ObjectType["Player"], "so_ObjectType" )

			if FindPlayer ~= nil then

				RegenObject["CheckCondition"] = true

			end

		end

		return ReturnAI["END"]

	end

	-- Object Regen
	for i = 1, #RegenInfoList do

		local RegenInfo = RegenInfoList[i]

		if -1 < RegenInfo["CheckTime"] and RegenInfo["CheckTime"] <= EventMemory["CurrentTime"] then

			local RegenData = RegenInfo["REGEN_DATA"]
			local RegenX	= RegenData["X"]
			local RegenY	= RegenData["Y"]

			if RegenX == -1 or RegenY == -1 then

				RegenX, RegenY = cObjectLocate( Handle )

			end

			for j = 1, RegenData["MOBCOUNT"] do

				if RegenInfo["CheckCount"] < RegenData["MAXCOUNT"] then

					local Object = { }

					Object["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], RegenData["MOBINDEX"],
														RegenX, RegenY, RegenData["RADIUS"] )

					if Object["Handle"] ~= nil then

						Object["RegenObjectHandle"] = Handle
						Object["RegenInfoIndex"]	= i
						RegenInfo["CheckCount"]		= RegenInfo["CheckCount"] + 1

						if EventMemory["EventData"]["ObjectList"] == nil then

							EventMemory["EventData"]["ObjectList"] = { }

						end

						EventMemory["EventData"]["ObjectList"][Object["Handle"]] = Object

						cSetAIScript( SCRIPT_MAIN, Object["Handle"] )
						cAIScriptFunc( Object["Handle"], "Entrance", RegenData["ROUTINE"] )

					end

				end

			end

			if RegenData["REGEN_TYPE"] == REGEN_TYPE["ONESHOT"] then

				RegenInfo["CheckTime"] = -1

			elseif RegenData["REGEN_TYPE"] == REGEN_TYPE["REPEAT"] then

				RegenInfo["CheckTime"] = EventMemory["CurrentTime"] + RegenData["DELAY"]

			end

		end

	end

	local RegenDialogData = RegenObjectData["REGEN_DIALOG_DATA"]

	if RegenDialogData ~= nil then

		for i = 1, #RegenDialogData do

			local DialogData = RegenDialogData[i]

			cMobDialog( EventMemory["MapIndex"], DialogData["FACECUT"], DialogData["FILENAME"], DialogData["INDEX"] )

		end

	end

	if RegenObjectData["REGEN_CONDITION"] == REGEN_CONDITION["REMOVE"] then

		cAIScriptSet( Handle )
		EventData["RegenObjectList"][Handle] = nil
		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end

function OBJECT_ROUTINE( Handle, MapIndex )
cExecCheck( "OBJECT_ROUTINE" )

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	local EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if EventData["ObjectList"] == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	if cIsObjectDead( Handle ) then

		local Object = EventData["ObjectList"][Handle]

		if Object ~= nil then

			local RegenObjectHandle = Object["RegenObjectHandle"]
			local RegenInfoIndex	= Object["RegenInfoIndex"]
			local RegenObject		= EventData["RegenObjectList"][RegenObjectHandle]

			if RegenObject ~= nil then

				local RegenInfo = RegenObject["RegenInfoList"][RegenInfoIndex]

				if RegenInfo ~= nil then

					RegenInfo["CheckCount"] = RegenInfo["CheckCount"] - 1

				end

			end

		end

		cAIScriptSet( Handle )
		EventData["ObjectList"][Handle] = nil

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end

function DOOR_ROUTINE( Handle, MapIndex )
cExecCheck( "DOOR_ROUTINE" )

	local EventMemory = InstanceField[MapIndex]

	if EventMemory == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local EventData = EventMemory["EventData"]

	if EventData == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end


	local DoorList = EventData["DoorList"]

	if DoorList == nil then

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]

	end

	return ReturnAI["CPP"]

end
