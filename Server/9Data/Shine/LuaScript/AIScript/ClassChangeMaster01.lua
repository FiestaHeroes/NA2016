require( "common" )

gIsInit 	= false		-- 초기화 되었나? ㄴㄴ
------------------------------------------------------------------------------------------------------
--
-- FUNCTION : CPP -> LUA
--
------------------------------------------------------------------------------------------------------
function DummyFunction()
end


function ClassChangeMaster01( Handle, MapIndex )
cExecCheck( "ClassChangeMaster01" )


	-- 이벤트 초기화
	if gIsInit == false
	then

		-- AISctipt Function 설정
		cAIScriptFunc( Handle, "NPCClick", "ClassChangeMaster01_Click" )
		cAIScriptFunc( Handle, "NPCMenu",  "ClassChangeMaster01_Menu"  )

		gIsInit = true;

	end

end


function ClassChangeMaster01_Click( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "ClassChangeMaster01_Click" )

	-- 다이얼로그 메뉴 출력
	cNPCMenuOpen( NPCHandle, PlyHandle )

end


function ClassChangeMaster01_Menu( NPCHandle, PlyHandle, PlyCharNo, Value )
cExecCheck( "ClassChangeMaster01_Menu" )

	-- 클래스 변경? ㅇㅇ
	if Value == 1
	then

		cClassChangeOpen( PlyHandle )

	end

end
