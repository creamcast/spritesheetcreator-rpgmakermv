EnableExplicit

#MAPFILE = "map.txt"
#RENDERIMG = 1
#DUMMY = 99
Global G_sprite_width = 48
Global G_sprite_height = 48

Procedure Error(msg.s)
	PrintN("Error: " + msg)
EndProcedure

Procedure ExitProgram()
	PrintN("press any key to exit the program.")
	Input()
	End
EndProcedure

Procedure SFieldToList(List lst.s(), sfield.s, max.i)
	Define i = 0
	For i = 1 To max
		AddElement(lst())
		lst() = StringField(sfield,i,",")
	Next
EndProcedure

Procedure GetSpriteSpecs()
	Define result = #False
	If OpenPreferences(#MAPFILE)
		If PreferenceGroup("specs")
			G_sprite_width = ReadPreferenceInteger("sprite_w",48)
			G_sprite_height = ReadPreferenceInteger("sprite_h",48)
		EndIf
		ClosePreferences()
		result = #True
	Else
		Error(#MAPFILE + " file does not exist!")
		result = #False
	EndIf
	ProcedureReturn result
EndProcedure

Procedure FlipImageHorizontal(imgid, imgwidth,imgheight)
	Define tmp = CreateImage(#PB_Any, imgwidth, imgheight, 32, #PB_Image_Transparent)
	Define new = CreateImage(#PB_Any, imgwidth, imgheight, 32, #PB_Image_Transparent)
	Define x = 0
	Define y = 0
	
	Define color = 0	
	For y = 0 To imgheight - 1
		For x = 0 To imgwidth - 1 
			StartDrawing(ImageOutput(tmp));
				DrawingMode(#PB_2DDrawing_AllChannels )
				DrawImage(ImageID(imgid), 0,0)
				color = Point(x,y)
			StopDrawing()
			
			StartDrawing(ImageOutput(new))
				DrawingMode(#PB_2DDrawing_AllChannels)
				Plot(imgwidth - x - 1,y, color)
			StopDrawing()
		Next
	Next	
	FreeImage(tmp)
	ProcedureReturn new
EndProcedure

Procedure GetSpriteImagePaths(List paths.s(), spritename.s)
	Define result = #False
	If OpenPreferences(#MAPFILE)
		If PreferenceGroup(spritename)
			Define dummy = ReadPreferenceInteger("dummy",0)
			If dummy
				ProcedureReturn #DUMMY
			EndIf
			Define flipleft = ReadPreferenceInteger("flip_left",0)
			Define flipright = ReadPreferenceInteger("flip_right",0)
		
			SFieldToList(paths(),ReadPreferenceString("front",""),3)
			SFieldToList(paths(),ReadPreferenceString("left",""),3)
			SFieldToList(paths(),ReadPreferenceString("right",""),3)
			SFieldToList(paths(),ReadPreferenceString("back",""),3)
			Define folder.s = ReadPreferenceString("folder","")
			ForEach paths()
				CompilerSelect #PB_Compiler_OS
					CompilerCase #PB_OS_Windows
						paths() = folder + "\" + paths()
					CompilerDefault
						paths() = folder + "/" + paths()
				CompilerEndSelect
			Next
			
			If flipleft = 1
				SelectElement(paths(), 3)
				paths() = "flip_" + paths()
				SelectElement(paths(), 4)
				paths() = "flip_" + paths()
				SelectElement(paths(), 5)
				paths() = "flip_" + paths()
			EndIf
			
			If flipright = 1
				SelectElement(paths(), 6)
				paths() = "flip_" + paths()
				SelectElement(paths(), 7)
				paths() = "flip_" + paths()
				SelectElement(paths(), 8)
				paths() = "flip_" + paths()
			EndIf
			
			result = #True
		Else
			Error("map for " + spritename + " does not exist")
			result = #False
		EndIf
		ClosePreferences()
	Else
		Error(#MAPFILE + " file does not exist!")
		result = #False
	EndIf
	ProcedureReturn result
EndProcedure

Procedure LoadImages(List imgpaths.s(), List imgids.i())
	ForEach imgpaths()
		Define img.i = 0
		If Left(imgpaths(),5) = "flip_"
			imgpaths() = Mid(imgpaths(), 6)
			Define tmp.i = LoadImage(#PB_Any, imgpaths())
			PrintN("flipping " + imgpaths() + "...")
			img = FlipImageHorizontal(tmp,G_sprite_width,G_sprite_height)
			FreeImage(tmp)
		Else
			img.i = LoadImage(#PB_Any, imgpaths())
		EndIf 
	
		If img = 0 
			Error("image: " + imgpaths() + " could not be loaded")
			ProcedureReturn #False
		Else
			AddElement(imgids())
			imgids() = img
		EndIf
	Next	
	ProcedureReturn #True
EndProcedure

Procedure RenderSheet(List imgids.i(), offsetx, offsety)
	Define x = offsetx
	Define y = offsety
	Define c = 0
	StartDrawing(ImageOutput(#RENDERIMG))
	DrawingMode(#PB_2DDrawing_AllChannels )
	ForEach imgids()
		DrawImage(ImageID(imgids()), x,y)
		x + G_sprite_width
		c + 1
		If c = 3
			x = offsetx
			y = y + G_sprite_height
			c = 0
		EndIf
	Next
	StopDrawing()
EndProcedure

Procedure RenderSprite(name.s, offsetx, offsety)
	PrintN("processing " + name + "...")

	NewList paths.s()
	NewList imgids.i()
	
	Define r = GetSpriteImagePaths(paths(), name)
	If r = #False
		ExitProgram()	
	ElseIf r = #DUMMY
		PrintN("dummy map.")
		ProcedureReturn #True
	EndIf
	
	If LoadImages(paths(), imgids()) = #False
		ExitProgram()
	EndIf
	
	RenderSheet(imgids(), offsetx, offsety)

	ForEach imgids()
		FreeImage(imgids())
	Next
EndProcedure

Procedure Main()
	OpenConsole()
	UseJPEGImageDecoder() 
	UseJPEG2000ImageDecoder() 
	UsePNGImageDecoder()
	UsePNGImageEncoder()
	
	If GetSpriteSpecs() = #False
		ExitProgram()
	EndIf
	
	CreateImage(#RENDERIMG, G_sprite_width * 12, G_sprite_height * 8, 32, #PB_Image_Transparent)
	
	RenderSprite("sprite1", 0, 0)
	RenderSprite("sprite2", G_sprite_width * 3, 0)
	RenderSprite("sprite3", G_sprite_width * 6, 0)
	RenderSprite("sprite4", G_sprite_width * 9, 0)
	
	Define y = G_sprite_height * 4
	RenderSprite("sprite5", 0, y)
	RenderSprite("sprite6", G_sprite_width * 3, y)
	RenderSprite("sprite7", G_sprite_width * 6, y)
	RenderSprite("sprite8", G_sprite_width * 9, y)
	
	PrintN("saving spritesheet as 'output.png' in executable folder...")
	If SaveImage(#RENDERIMG, "output.png",#PB_ImagePlugin_PNG, 10)
		PrintN("done.")
	Else
		Error("could not save image.")
	EndIf
	ExitProgram()	
	CloseConsole()
EndProcedure
Main()
; IDE Options = PureBasic 5.41 LTS (Windows - x64)
; ExecutableFormat = Console
; CursorPosition = 215
; FirstLine = 192
; Folding = --
; EnableUnicode
; EnableXP
; Executable = spritesheetcreator.exe
; CompileSourceDirectory