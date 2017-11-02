#pragma rtGlobals=1		// Use modern global access method.



//Load Images
Function LoadImageFiles1spot(numpoints)

	variable numpoints
	
	string filename, path
	variable i
	
	for(i =0; i< numpoints; i += 1)
		//file name
		filename = "780-"+num2str(i)+".tif"
		//folder path/name
		path ="C:Users:Cody:Dropbox:11-23-2015:PBS2 no tubing:"+ filename
		//path ="C:Users:codyjoy:Desktop:Glue Test:No Glue- 850 nm laser:"+ filename
		
		ImageLoad/O/T=tiff path
	endfor

End

//Making a New Array for the average of frames
Function FrameAvg(numpoints, newWaveName)
	variable numpoints	
	string newWaveName
		
	string filename
	variable i
	
	
	Make/O/N=(numpoints)/D meanvalues
	
	for(i =0; i< numpoints; i += 1)
		//file name;		
		filename = "with filter 2_"+num2str(i)+".bmp"
		meanvalues[i] = mean( $filename)			
		
	endfor
	
	Duplicate/O meanvalues $newWaveName
	
End

//Making a New Array for the area next to the Center points
Function NextToCenterAvg(numpoints, row, col, newWaveName)
	variable numpoints
	variable col, row	
	string newWaveName
	
	
	string filename
	variable i
	variable j=0, k = 0
		
	//col1 = 200 row1 = 350 col2 = 300 row2 = 450
	variable col1, col2, row1, row2
	
	col1 = col-100 ;	row1 = row-200 ;	col2 = col+100 ;	row2 = row + 0 
		
	Make/O/N=(40000)/D tempwave
	Make/O/N=(500)/D meanvalues

	for(i =0; i< numpoints; i += 1)
		//file name; ex) T40_2_0.bmp
		
		filename = "Image_"+num2str(i)+".bmp"
		
		//new Array for Frame Averages							
		Duplicate/O/R=(row1,row2)(col1,col2) $filename tempwave
		meanvalues[i] = mean(tempwave)
	endfor
	
	Duplicate/O meanvalues $newWaveName
	
End

//Making a New Array for the area next to the Center points
Function TotalCenterAvg(numpoints, row, col, newWaveName)
	variable numpoints
	variable col, row	
	string newWaveName
	
	
	string filename
	variable i
	variable j=0, k = 0
		
	//col1 = 200 row1 = 350 col2 = 300 row2 = 450
	variable col1, col2, row1, row2
	
	col1 = col-75 ;	row1 = row-75 ;	col2 = col+75 ;	row2 = row + 75 
		
	Make/O/N=(40000)/D tempwave
	Make/O/N=(numpoints)/D meanvalues

	for(i =0; i< numpoints; i += 1)
		//file name; ex) T40_2_0.bmp
		
		filename = "780-"+num2str(i)+".tif"
		
		//new Array for Frame Averages							
		Duplicate/O/R=(row1,row2)(col1,col2) $filename tempwave
		meanvalues[i] = mean(tempwave)
	endfor
	
	Duplicate/O meanvalues $newWaveName
	
End

Function ScaledifferentialWavename(dataPoints, P1, P2,timeStamp,diffWaveName)
	
	variable dataPoints
	string diffWaveName
	wave P1, P2, timeStamp
	variable P1_0, P2_0,test,test1
	
	Make/N=(dataPoints+1)/D/O ScaledDiffValue
	Make/N=(dataPoints+1)/D/O ScaledDiffValues
	wave wave1,wave99
	
	variable i
	P1_0 = P1[0]
	P2_0 = P2[0]
	
	for(i=0; i < dataPoints+1; i += 1)
		ScaledDiffValues[i] = (P1[i] - P2[i]) / (P1[i] + P2[i])
		ScaledDiffValue[i] = (P1[i] - P1_0/P2_0*P2[i]) / (P1[i] + P1_0/P2_0*P2[i])
	endfor
	
	Duplicate/O ScaledDiffValue $diffWaveName
	Duplicate/O $diffWaveName wave1
	CurveFit/M=2/W=0 line, wave1[0,100]/X=timeStamp[0,100]/D
	WAVE W_coef
	test1 = W_coef[1]
	//Duplicate/O ScaledDiffValues $diffWaveName
	//Duplicate/O $diffWaveName wave99
	//CurveFit/M=2/W=0 line, wave99[0,100]/X=timeStamp[0,100]/D
	//Wavestats P2
	//test =  V_max
	//Wavestats P1
	
	print test1
	//print V_max
	//print test
	//WAVE W_coef
	//print W_coef[1]
	//WAVE W_sigma
	//print w_sigma[1]
	
	
End


Function findMean(wave1, wave2, wave3)
	wave wave1, wave2, wave3
	
	variable avg1, avg2, avg3
	avg1 = mean(wave1)
	avg2 = mean(wave2)
	avg3 = mean(wave3)
	
	return (avg1 + avg2 + avg3) / 3
End


Function Run(numpoints,timepersample)
	variable numpoints, timepersample
	
	
	
	Make/O/N=(numpoints)/D test, test1, test2, test3, test4, test5, test6, test7, test8, test9, test10, test11
	
	Make/O/N=(3)/D trans_avg, ref_avg, sputtertime1
	
	//LoadImageFiles1spot(numpoints, spotNum, sputterTime)
	variable i
	
	for( i = 1 ; i < 500; i += 1 ) //number of spots
		LoadImageFiles1spot(500)
	endfor

	


	
	
	//FrameAvg
	FrameAvg(500, "test")
	FrameAvg(500, "test1")
	FrameAvg(500, "test2")
	FrameAvg(500, "test3")
	FrameAvg(500, "test4")
	FrameAvg(500, "test5")
	FrameAvg(500, "test6")
	FrameAvg(500, "test7")
	FrameAvg(500, "test8")
	FrameAvg(500, "test9")
	FrameAvg(500, "test10")
	FrameAvg(500, "test11")
	
	
	//NextToCenterAvg
	NextToCenterAvg(500, 408, 260, "test13")
	NextToCenterAvg(500, 259, 171, "test14")
	NextToCenterAvg(500, 322, 322, "test15")
	NextToCenterAvg(500, 408, 260, "test16")
	NextToCenterAvg(500, 408, 260, "test17")
	NextToCenterAvg(500, 259, 171, "test18")
	NextToCenterAvg(500, 322, 322, "test19")
	NextToCenterAvg(500, 259, 171, "test20")
	NextToCenterAvg(500, 408, 260, "test21")
	NextToCenterAvg(500, 259, 171, "test22")
	NextToCenterAvg(500, 322, 322, "test23")
	NextToCenterAvg(500, 322, 322, "test24")
	
	
	//TotalCenterAvg
	TotalCenterAvg(500, 378, 215, "test")
	TotalCenterAvg(500, 378, 215, "test1")
	TotalCenterAvg(500, 378, 215, "test2")
	TotalCenterAvg(500, 378, 215, "test3")
	TotalCenterAvg(500, 378, 215, "test4")
	TotalCenterAvg(500, 378, 215, "test5")
	TotalCenterAvg(500, 378, 215, "test6")
	TotalCenterAvg(500, 378, 215, "test7")
	TotalCenterAvg(500, 378, 215, "test8")
	TotalCenterAvg(500, 378, 215, "test9")
	TotalCenterAvg(500, 378, 215, "test10")
	TotalCenterAvg(500, 378, 215, "test11")

	
	
	
	
	
	
	
	
	
	
	
	if(1)
	variable tavg, ravg
	string wave_name1, wave_name2, wave_name3
	Make/O/N=(3)/D transmission, reflection, sputtertime
	
	sputtertime = {30,40,50}
	
	for(i = 0; i < 3; i += 1)
		//transmission
		wave_name1 = "t"+num2str(30+10*i) +"s1" ; wave_name2 = "t"+num2str(30+10*i) +"s2" ;	wave_name3 = "t"+num2str(30+10*i) +"s3"
		transmission[i] = findMean($wave_name1, $wave_name2, $wave_name3) / findMean(ns1, ns2, ns3)
		//reflection
		wave_name1 = "r"+num2str(30+10*i) +"s1" ; wave_name2 = "r"+num2str(30+10*i) +"s2"; wave_name3 = "r"+num2str(30+10*i) +"s3"
		reflection[i] = findMean($wave_name1, $wave_name2, $wave_name3) / findMean(ns1, ns2, ns3)
	endfor
	
	display transmission, reflection vs sputtertime
	
	endif

END






Window AverageofFrame788nmfilter() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(156,69.5,590.25,324.5) test,test1,test2
	ModifyGraph margin(top)=72
	ModifyGraph lSize=2
	ModifyGraph rgb(test1)=(0,12800,52224),rgb(test2)=(0,52224,0)
	Label left "\\F'Arial'\\Z18Average Pixel Intensity"
	Label bottom "\\Z18Image Number"
	TextBox/C/N=text0/A=MC/X=-20.63/Y=73.02 "Average of Frame\\Z18"
	Legend/C/N=text1/J/A=MC/X=49.25/Y=29.11 "\\s(test) 780 nm \r\\s(test1) 830 nm\r\\s(test2) 850 nm"
	TextBox/C/N=text2/F=0/Z=1/A=MT/X=5.26/Y=-13.73 "\\Z36Average of Frame"
EndMacro

Window Laser850nmFilter788nm() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(264.75,239,659.25,447.5) test2,test2
EndMacro

Window Laser780nmFilter788nm() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(567.75,77.75,962.25,286.25) test
EndMacro

Window Laser830nmFilter788nm() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(680.25,82.25,1074.75,290.75) test1
EndMacro
