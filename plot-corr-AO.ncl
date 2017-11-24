begin
  
  itimes = 197901 ;��ʼ���� 
  itimee = 201001 ;��������
  
  siglvl = 0.05   ; ���Ŷ�

  ;;;;read air data   
  f   = addfile("./data/air.mon.mean.nc", "r")   
  var := short2flt(f->air)
  time  := f->time
  YYYYMM := cd_calendar(time,-1)

  ist = ind(itimes.eq.YYYYMM)
  ied = ind(itimee.eq.YYYYMM)  
  

  
   ; ���������ұ�άƽ��������meta data�����Ｔ��γ��ƽ��
  dims   = dimsizes(air_zm)
  
  ;;;;read AOI data   
  ncfile = addfile("SLP-PC1-jan-34yr.nc","r")
  eof_ts = ncfile->AOI
  AOI = eof_ts({1979:2010}) ; ��ȡ����ʱ��Σ��Ա�֤��air����һ��

  ;;��ز�����
     ; ͬʱ���
     ;�����Ϊ[17] x [73] x [1]

  var :=(/corr(:,:,0)/)
  copy_VarMeta(air_zm(0,:,:),var)
    
    
    
  
  ;;**plot**************************************
  wks   = gsn_open_wks ("eps", "plot-corr-AO")    
  gsn_define_colormap(wks,"BlWhRe")               
  
  res                = True                 
  res@gsnDraw        = False   
  res@gsnFrame       = False   
  res@gsnLeftString  = ""
  res@gsnRightString = ""

  res@tmXBMode                = "Explicit"
  res@tmXBValues              = (/-90,-60,-30,0,30,60,90/)                         ;�����ڵ�ͼ�ϻ��ƣ�����Щ��ֵָ����γ��
  res@tmXBLabels              = (/"90~S~o~N~S","60~S~o~N~S","30~S~o~N~S","0","30~S~o~N~N","60~S~o~N~N","90~S~o~N~N"/)  ;�ڶ�Ӧλ�������Ӵ�Ȧ�ŵ�γ�ȡ�����ʹ����Ĭ�ϵ�function code ~��
  res@tmXBLabelDeltaF         = -0.6                    ; �ƶ���λ�ã�ʹ����ӿ���X��
  res@tmXBLabelFontHeightF    = 0.015                    ; �����С
  res@tmYLLabelFontHeightF    = 0.015                    ; �����С
  
  res@tiYAxisString   = "Level (hPa)"
    
  res@cnFillOn             = True                  ; turn on color
  res@cnLinesOn            = False                 ; no contour lines
  res@cnLineLabelsOn       = False
        
  res@gsnContourZeroLineThicknessF  = 0.
  res@cnInfoLabelOn        = False
  
  res@lbLabelBarOn         = False
      
  base=gsn_csm_pres_hgt(wks,prob,res)
  

  res@cnFillOn             = False    
  res@cnLinesOn            = True     
  res@cnLevelSpacingF      = 0.15
  res@cnLineDashPattern    = 2
  res@cnLineThicknessF     = 3.
  res@cnInfoLabelOn        = True
  
  ;res@gsnCenterString  = "r(AO, air_zm) @Jan"
  ;res@gsnCenterStringFontHeightF = 0.03
  ;res@gsnCenterStringOrthogonalPosF = 0.05
   
  plot = gsn_csm_pres_hgt(wks,var(level|:,lat|:),res) 
  plot = ColorNegDashZeroPosContour(plot,"black","white","black")   
  overlay(base,plot)
  
  draw(base)                                                                 
  frame(wks)     
end