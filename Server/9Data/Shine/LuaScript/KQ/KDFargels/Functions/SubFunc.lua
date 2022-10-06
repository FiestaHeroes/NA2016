

function FaceCut( EventMemory )
cExecCheck( "FaceCut" )

	if EventMemory == nil then

		return

	end

	if EventMemory["FaceCut"] == nil then

		return

	end

	if EventMemory["FaceCut"]["Number"] > #DIALOG_DATA then

		return

	end


	local FacecutData = DIALOG_DATA[EventMemory["FaceCut"]["Number"]]

	if FacecutData == nil then

		return

	end


	if FacecutData["FACECUT"] == nil then

		cNotice( EventMemory["MapIndex"], FacecutData["FILENAME"], FacecutData["INDEX"] )

	elseif FacecutData["FACECUT"] ~= nil then

		cMobDialog( EventMemory["MapIndex"], FacecutData["FACECUT"], FacecutData["FILENAME"], FacecutData["INDEX"] )

	end

	EventMemory["FaceCut"]["CheckTime"]	= EventMemory["CurrentTime"] + FacecutData["DELAY"]
	EventMemory["FaceCut"]["Number"]	= EventMemory["FaceCut"]["Number"] + 1

end

function FaceCutThread( EventMemory )
cExecCheck( "FaceCutThread" )

	if EventMemory == nil then

		return

	end

	if EventMemory["FaceCut"] == nil then

		return

	end

	if EventMemory["FaceCut"]["FaceCutThread"] == nil then

		return

	end

	if EventMemory["FaceCut"]["FaceCutThread"]["Working"] == false then

		return

	end

	if EventMemory["FaceCut"]["CheckTime"] == nil then

		return

	end

	if EventMemory["FaceCut"]["CheckTime"] <= EventMemory["CurrentTime"] then

		local Length 	= EventMemory["FaceCut"]["FaceCutThread"]["Length"]
		local Count 	= EventMemory["FaceCut"]["FaceCutThread"]["Count"]

		if Count < Length then

			FaceCut( EventMemory )

			EventMemory["FaceCut"]["FaceCutThread"]["Count"] = Count + 1

		else

			EventMemory["FaceCut"]["FaceCutThread"]["Working"] = false

		end

	end

end

function FaceCutThreadStart( EventMemory, Length )
cExecCheck( "FaceCutThreadStart" )

	if EventMemory == nil then

		return

	end

	if EventMemory["FaceCut"] == nil then

		return

	end

	if EventMemory["FaceCut"]["FaceCutThread"] == nil then

		EventMemory["FaceCut"]["FaceCutThread"] = { }

	end

	EventMemory["FaceCut"]["FaceCutThread"]["Length"] 	= Length
	EventMemory["FaceCut"]["FaceCutThread"]["Count"] 	= 0
	EventMemory["FaceCut"]["FaceCutThread"]["Working"]	= true

end

function DoorCreate( EventMemory )
cExecCheck( "DoorCreate" )

	EventMemory["EventData"]["DoorList"] = { }

	local DoorList 		= { }
	local DoorCount		= 1

	for index, value in pairs( DOOR_BLOCK_DATA ) do

		local Door 			= { }


		Door["Handle"] = cDoorBuild( EventMemory["MapIndex"], value["DOOR_INDEX"],
												value["REGEN_POSITION"]["X"], value["REGEN_POSITION"]["Y"], value["REGEN_POSITION"]["DIR"], value["SCALE"] )

		if Door["Handle"] ~= nil then

			Door["Index"]			= value["DOOR_BLOCK"]
			Door["X"]				= value["REGEN_POSITION"]["X"]
			Door["Y"]				= value["REGEN_POSITION"]["Y"]
			DoorList[DoorCount] 	= Door
			DoorCount 				= DoorCount + 1

			cDoorAction( Door["Handle"], Door["Index"], "close" )

			cSetAIScript( SCRIPT_MAIN, Door["Handle"] )
			cAIScriptFunc( Door["Handle"], "Entrance", "DOOR_ROUTINE" )

		end

	end

	EventMemory["EventData"]["DoorList"] = DoorList

end

function CameraMove( EventMemory )
cExecCheck( "CameraMove" )

	if EventMemory == nil then

		return

	end

	if EventMemory["CameraMove"] == nil then

		return

	end

	if EventMemory["CameraMove"]["Number"] > #CAMERAMOVE_DATA then

		return

	end

	local CameraData = CAMERAMOVE_DATA[EventMemory["CameraMove"]["Number"]]


	if EventMemory["CameraMove"]["CameraState"] == CAMERA_STATE["MOVE"] then

		local PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			--if cIsKQJoiner( PlayerList[i] ) == true then

				cSetAbstate( PlayerList[i], CameraData["AbstateIndex"], 1, CameraData["AbstateTime"] )
				cSetAbstate( PlayerList[i], "StaImmortal", 1, 99999999 )

			--end

		end

		cCameraMove( EventMemory["MapIndex"], EventMemory["CameraMove"]["Focus"]["X"], EventMemory["CameraMove"]["Focus"]["Y"], EventMemory["CameraMove"]["Focus"]["DIR"],
											  CameraData["AngleY"], CameraData["Distance"], 1 )

		EventMemory["CameraMove"]["CheckTime"] = EventMemory["CurrentTime"] + CameraData["KeepTime"]

		return

	elseif EventMemory["CameraMove"]["CameraState"] == CAMERA_STATE["REMOVE"] then

		local PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

		for i=1, #PlayerList do

			--if cIsKQJoiner( PlayerList[i] ) == true then

				cResetAbstate( PlayerList[i], "StaImmortal" )
				cResetAbstate( PlayerList[i], CameraData["AbstateIndex"] )

			--end

		end

		EventMemory["CameraMove"]["CheckTime"] = nil
		cCameraMove( EventMemory["MapIndex"], 0, 0, 0, 0, 0, 0 )
		--EventMemory["CameraMove"]["Number"] = EventMemory["CameraMove"]["Number"] + 1

		return

	elseif EventMemory["CameraMove"]["CameraState"] == CAMERA_STATE["NEXT_STEP"] then

		EventMemory["CameraMove"]["Number"] = EventMemory["CameraMove"]["Number"] + 1

		return

	end

end

function CameraMoveStart( EventMemory )
cExecCheck( "CameraMoveStart" )

	if EventMemory == nil then

		return

	end

	local DoorPosition = DOOR_BLOCK_DATA[EventMemory["EventNumber"]]["REGEN_POSITION"]

	EventMemory["CameraMove"]["CameraState"]	= CAMERA_STATE["MOVE"]
	EventMemory["CameraMove"]["Focus"]["X"] 	= DoorPosition["X"]
	EventMemory["CameraMove"]["Focus"]["Y"] 	= DoorPosition["Y"]
	EventMemory["CameraMove"]["Focus"]["DIR"] 	= ( DoorPosition["DIR"] + 180 ) * (-1)

	CameraMove( EventMemory )

	local DoorInfo = EventMemory["EventData"]["DoorList"][EventMemory["EventNumber"]]

	cDoorAction( DoorInfo["Handle"], DoorInfo["Index"], "open" )

end

function CameraMoveEnd( EventMemory )
cExecCheck( "CameraMoveEnd" )

	if EventMemory == nil then

		return

	end

	EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["REMOVE"]

	CameraMove( EventMemory )

	EventMemory["CameraMove"]["CameraState"] = CAMERA_STATE["NEXT_STEP"]

	CameraMove( EventMemory )

end

function CreateObjectList_XY( EventMemory, DataIndex, ListName, Func )
cExecCheck( "CreateObjectList_XY" )

	if EventMemory == nil then

		return

	end

	local ObjectList = EventMemory["EventData"][ListName]

	if ObjectList == nil then

		ObjectList = {}

	end

	local EventData 	= EVENT_DATA[EventMemory["EventNumber"]]
	local ObjectData 	= EventData[DataIndex]

	for i = 1, #ObjectData do

		local Object = { }

		Object["Handle"] = cMobRegen_XY( EventMemory["MapIndex"], ObjectData[i]["MOBINDEX"],
										ObjectData[i]["X"], ObjectData[i]["Y"], ObjectData[i]["DIR"] )

		if Object["Handle"] ~= nil then

			ObjectList[Object["Handle"]] = Object

			if Func ~= nil then

				Func( Object, ObjectData[i] )

			end

		end

	end

	EventMemory["EventData"][ListName] = ObjectList

	return EventMemory["EventData"][ListName]

end

function CreateObjectList_Circle( EventMemory, DataIndex, ListName, Func )
cExecCheck( "CreateObjectList_Circle" )

	if EventMemory == nil then

		return

	end

	if EventMemory["EventData"][ListName] == nil then

		EventMemory["EventData"][ListName] = { }

	end

	local EventData 	= EVENT_DATA[EventMemory["EventNumber"]]
	local ObjectData 	= EventData[DataIndex]
	local ObjectList	= EventMemory["EventData"][ListName]

	for i = 1, #ObjectData do

		local Object = { }

		Object["Handle"] = cMobRegen_Circle( EventMemory["MapIndex"], ObjectData[i]["MOBINDEX"],
										ObjectData[i]["X"], ObjectData[i]["Y"], ObjectData[i]["RADIUS"] )

		if Object["Handle"] ~= nil then

			ObjectList[Object["Handle"]] = Object

			if Func ~= nil then

				Func( Object, ObjectData[i] )

			end

		end

	end

	EventMemory["EventData"][ListName] = ObjectList

	return EventMemory["EventData"][ListName]

end

function StunRegenObjectAll( EventMemory )
cExecCheck( "StunRegenObjectAll" )

	if EventMemory == nil then

		return

	end

	local ObjectList = EventMemory["EventData"]["ObjectList"]

	if ObjectList ~= nil then

		for index, value in pairs( ObjectList ) do

			local Object = ObjectList[index]

			if Object ~= nil then

				if Object["Handle"] ~= nil then

					cSetAbstate( Object["Handle"], "StaAdlFStun", 1, 1500 )

				end

			end

		end

	end

end

function ResetStunRegenObjectAll( EventMemory )
cExecCheck( "StunRegenObjectAll" )

	if EventMemory == nil then

		return

	end

	local ObjectList = EventMemory["EventData"]["ObjectList"]

	if ObjectList ~= nil then

		for index, value in pairs( ObjectList ) do

			local Object = ObjectList[index]

			if Object ~= nil then

				if Object["Handle"] ~= nil then

					cResetAbstate( Object["Handle"], "StaAdlFStun" )

				end

			end

		end

	end

end

function KDFargelsSkill01( EventMemory, Handle, Skill, SkillInfo )
cExecCheck( "KDFargelsSkill01" )

	if EventMemory == nil then

		return

	end

	if Handle == nil then

		return

	end

	if Skill == nil then

		return

	end

	if SkillInfo == nil then

		return

	end

	local Range			= SkillInfo["RANGE"]
	local AbstateData	= SkillInfo["ABSTATE"]
	local AbstateList	= Skill["AbstateList"]

	for i = 1, #AbstateList do

		local AbstateIndex	= AbstateData[i]["ABSTATE_INDEX"]
		local KeepTime 		= AbstateData[i]["KEEPTIME"]
		local PrepareTime	= AbstateData[i]["PREPARETIME"]
		local IntervalTime	= AbstateData[i]["INTERVALTIME"]

		local Abstate 		= AbstateList[i]

		if Abstate ~= nil then

			if Abstate["Enable"] == true then

				if Abstate["CheckPrepareTime"] <= EventMemory["CurrentTime"] then

					if Abstate["CheckIntervalTime"] <= EventMemory["CurrentTime"] then

						local RestTime = Abstate["CheckKeepTime"] - EventMemory["CurrentTime"]

						cSetAbstate_Range( Handle, Range * 0.5 , ObjectType["Player"], AbstateIndex, 1, RestTime * 1000 )

						--cDebugLog( "cSetAbstate_Range : " .. AbstateIndex )

						Abstate["CheckIntervalTime"] = EventMemory["CurrentTime"] + IntervalTime

					end

				end

				if Abstate["CheckKeepTime"] <= EventMemory["CurrentTime"] then

					local PlayerList = { cGetPlayerList( EventMemory["MapIndex"] ) }

					for j = 1, #PlayerList do

						if PlayerList[j] ~= nil then

							cResetAbstate( PlayerList[j], AbstateIndex )

						end

					end

					AbstateList[i]["Enable"] = false

				end

			end

		end

	end

end

function KDFargelsSkill02( EventMemory, Handle, Skill, SkillInfo )
cExecCheck( "KDFargelsSkill02" )

	if EventMemory == nil then

		return

	end

	if Handle == nil then

		return

	end

	if Skill == nil then

		return

	end

	if SkillInfo == nil then

		return

	end

	local Range			= SkillInfo["RANGE"]
	local AbstateData	= SkillInfo["ABSTATE"]
	local AbstateList	= Skill["AbstateList"]

	for i = 1, #AbstateList do

		local AbstateIndex	= AbstateData[i]["ABSTATE_INDEX"]
		local KeepTime 		= AbstateData[i]["KEEPTIME"]
		local PrepareTime	= AbstateData[i]["PREPARETIME"]
		local IntervalTime	= AbstateData[i]["INTERVALTIME"]

		local Abstate 		= AbstateList[i]

		if Abstate ~= nil then

			if Abstate["Enable"] == true then

				if Abstate["CheckPrepareTime"] <= EventMemory["CurrentTime"] then

					if Abstate["CheckIntervalTime"] <= EventMemory["CurrentTime"] then

						local RestTime = Abstate["CheckKeepTime"] - EventMemory["CurrentTime"]

						cSetAbstate( Handle, AbstateIndex, 1, RestTime * 1000 )

						--cDebugLog( "cSetAbstate : " .. AbstateIndex )

						Abstate["CheckIntervalTime"] = EventMemory["CurrentTime"] + IntervalTime

					end

				end

				if Abstate["CheckKeepTime"] <= EventMemory["CurrentTime"] then

					cResetAbstate( Handle, AbstateIndex )

					AbstateList[i]["Enable"] = false

				end

			end

		end

	end

end
