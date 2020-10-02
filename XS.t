XS={}
-----------------------------------------------------------------------调试功能合集---------------------------------------------------------------------------------------------
function XS_ErrorPrint(funcname,str)
    XS.Print("调用错误:"..funcname.."函数 "..str)
end
XS_Key=""
function XS.Print(...)--调试输出，可打印表
    if ... ==nil then
        return false
    end
    local tab={}
    local str=""
    if type(...)=="table" then
        tab=...
        str=tab
    else
        tab={...}
        for i=1,#tab do
            if type(tab[i])=="table" then
                local value=XS_PrintTable(tab[i],1)
                str=str..value
            else
                str=str..tostring(tab[i])
                if i~=#tab then
                    str=str
                end
            end
            
        end
    end
    XS_level=XS_level or 1
    if type(str)=="table" then	
        local indent=""
        for i=1,XS_level do
            indent=indent.."  "
        end
        if XS_Key~="" then
            XS.Print(tostring(indent).."["..tostring(XS_Key).."]".." ".."=".." ".."{")
        else
            XS.Print(tostring(indent).."{")
        end
        XS_Key=""
        for k,v in pairs(str) do
            if type(v)=="table" then
                XS_Key=k
                XS.Print(v,XS_level+1)
            else
                local content=string.format("%s[%s]=%s",tostring(indent).."  ",tostring(k),tostring(v))
                XS.Print(tostring(content))
            end
        end
        XS.Print(tostring(indent).."}")
    else
        traceprint(tostring(str))
    end
end
function XS_PrintTable(str,XS_level)
    local str2=""
    local indent=""
    for i=1,XS_level do
        indent=indent.." "
    end
    if XS_Key~="" then
        str2=str2..(tostring(indent).."["..tostring(XS_Key).."]".."".."=".." ".."{")
    else
        str2=str2..(tostring(indent).."{")
    end
    XS_Key=""
    for k,v in pairs(str) do
        if type(v)=="table" then
            XS_Key=k
            str2=str2..XS_PrintTable(v,XS_level + 1)
        else
            local content=string.format("%s[%s]=%s,",tostring(indent).."",tostring(k),tostring(v))
            str2=str2..(tostring(content))
        end
    end
    str2=str2..(tostring(indent).."}")
    return str2
end
function XS.Sleep(times)
    local times=times or 1000
    local r=rnd(-50,50)
    sleep(mabs(r+times))
end
-----------------------------------------------------------------------控制功能合集---------------------------------------------------------------------------------------------
XS_TimingArr={}
function XS.Timer(id,t)--定时器
    t=t or 5
    local time=os.time()
    XS_TimingArr[id]=XS_TimingArr[id] or os.time()+t
    if XS_TimingArr[id]<=time then
        XS_TimingArr[id]=os.time()+t
        return true
    end
    return false
end
function XS.TimerFirst(id,t)--第一次进入定时器返回true
    t=t or 5
    local time=os.time()
    if XS_TimingArr[id]==nil  then
        XS_TimingArr[id]=os.time() + t
        return true
    end
    if XS_TimingArr[id] <=times  then
        XS_TimingArr[id]=os.time() + t
        return true
    end
    return false
end
function XS.TimerInit(id)--初始化定时器
    if id then
        XS_TimingArr[id]=nil
    else
        XS_TimingArr={}
    end
end
function XS.TimerRet(id)--返回定时器剩余时间	
    if id then
        local time=os.time()
        if XS_TimingArr[id]==nil or (XS_TimingArr[id]-time)<=0 then
            return 0
        else
            return XS_TimingArr[id]-time
        end
    else
        XS_ErrorPrint("XS.TimerRet","定时器id错误")
    end
end
XS_SwitchArr={}
function XS.Switch(id)--开关函数
    local id=id or 1
    if XS_SwitchArr[id]==nil then
        XS_SwitchArr[id]=true
    end
    if XS_SwitchArr[id] then
        XS_SwitchArr[id]=false
        return true
    end
    return false
end
function XS.OpenSwitch(id)--打开开关
    if id then
        XS_SwitchArr[id]=true
    else
        XS_SwitchArr={}
    end
end
function XS.Distance(x1,y1,x2,y2)
    return 	math.abs(math.ceil(math.sqrt((math.pow((x1 - x2),2)+math.pow((y1 - y2),2)))))
end
-----------------------------------------------------------------------显示功能合集---------------------------------------------------------------------------------------------
function XS.Msg(msg,...)--坐标用{}
    if type(msg)~="nil" then
        local Arr={...}
        for i=1,#Arr do
            if type(Arr[i])=="number" then
                local t=Arr[i]
            elseif type(Arr[i])=="table" then
                local x=Arr[i][1]
                local y=Arr[i][2]
            end
        end
        messageboxex(tostring(msg),t or 1500,x or 1,y or 1,1,12)
    end
end
function XS.MsgClose()--关闭信息框
    messageboxex("",0,0,0,0,0)
end
function XS.Msgex(msg,...)
    if type(msg)=="string" then
        local Arr={...}
        for i=1,#Arr do
            if type(Arr[i])=="number" then
                local t=Arr[i]
            elseif type(Arr[i])=="table" then
                local x=Arr[i][1]
                local y=Arr[i][2]
            end
        end
        local p={}
        for i=1,strlen(msg) do
            p[#p+1]=strsub(msg,0,i)
        end
        for i=1,#p do
            messageboxex(p[i],t or 1500,x or 1,y or 1,1,12)
            sleep(100)
        end
    end
end
function XS.Show(msg,...)
    XS.Msg(msg,...)
    XS.Print(msg)
end
function XS.CheckRun(s,x,y)
    local x=x or 1
    local y=y or 1
    showscriptad()
    local s=s or 3
    local msg=""
    local list=XS.GetScreen() --获取当前分辨率 
    msg=msg .. "当前分辨率: " .. list[1] .. " * " .. list[2] .. "  DPI: " .. list[3].."\n".."推荐分辨率: 720 * 1280  DPI: 320"
    msg=msg .. "\n*****************************"
    msg=msg .. "\n[飞天助手]海量免费辅助搭配[红手指]\n免充电、免Root、免流量、24小时离线挂机!"
    msg=msg .. "\n*****************************"
    msg=msg .. "\n请确保 所有弹窗已关闭"
    msg=msg .. "\n*****************************"
    msg=msg .. "\n智能检测运行环境...".."\n当前运行环境:"..XS.GetRunType()
    msg=msg .. "\n*****************************"
    for i=s, 0, -1 do
        XS.Msg(msg .. "\n                                                " .. i .. "秒后开始运行",1000,x,y)
        sleep(1000) 
    end
end
-----------------------------------------------------------------------变量功能合集---------------------------------------------------------------------------------------------
function XS.Split(str,cutsymbol)--字符串分割
    local Arr={}
    while true do
        local ret=strfind(str,cutsymbol)
        if ret==-1 then
            Arr[#Arr+1]=str
            break
        else
            Arr[#Arr+1]=strsub(str,0,ret)
            str=strsub(str,ret+1,strlen(str))
        end
    end
    return Arr
end
function XS.TableReverse(tab,id)--数组倒序,id:1.使用for形式遍历,2.迭代器遍历
    local id=id or 2
    local Arr={}
    if id==1 then
        for i=#tab,0,-1 do
            Arr[#Arr+1]=tab[i]
        end
    else
        for k,v in pairs(tab) do
            Arr[k]=v
        end
    end
    return Arr
end
function XS.ArrayAssign(Array)--数组赋值
    local ret = {}
    for k,v in pairs(Array) do
        ret[k] = v
    end
    return ret
end
-----------------------------------------------------------------------时间功能合集---------------------------------------------------------------------------------------------
function XS.TimeNow(id)--返回当前时间,id:1.返回table表形式,2.返回字符串形式
    local id=id or 1
    local Ret=nil;
    if id==1 then
        local time=timenow()
        Ret={year=tonumber(timeyear(time));
        month=tonumber(timemonth(time));
        day=tonumber(timeday(time));
        hour=tonumber(timehour(time));
        minute=tonumber(timeminute(time));
        second=tonumber(timesecond(time))
        }
    else
        local Ret=timenow()
    end
    return Ret
end
XS_TimeAddArr={}
function XS.TimeAdd(id,future1,future2)--添加定时任务,参数={小时,分钟}
    if XS_TimeAddArr[id] then
        XS_ErrorPrint("XS.TimeAdd","此id已经存在!!!")
        return false
    end
    XS_TimeAddArr[id]={future1,future2}
    return true
end
function XS.TimeRet(id)--返回是否已经达到定时任务的时间
    if XS_TimeAddArr[id] then
        local now=XS.TimeNow(1)
        if now.hour>=XS_TimeAddArr[id][1][1] and now.hour<=XS_TimeAddArr[id][1][2] then--小时数符合
            if now.minute>=XS_TimeAddArr[id][2][1] and now.minute<=XS_TimeAddArr[id][2][2] then--分钟数符合
                return true
            end
        end
    else
        XS_ErrorPrint("XS.TimeRet","此id不存在!!!")
        return false
    end
    return false
end
function XS.TimeFormat(id)--清空定时任务,如果不填id则全部清空
    if id then
        XS_TimeAddArr[id]=nil
    else
        XS_TimeAddArr={}
    end
end
XS_TickCount_Arr={}
function XS.GetTickCount(id)
    if XS_TickCount_Arr[id] then
        if os.time()-XS_TickCount_Arr[id]==0 then
            XS_ErrorPrint("XS.GetTickCount","获取间隔过短")
            return ""
        end
        return XS.ReturnDate(os.time()-XS_TickCount_Arr[id])
    else
        XS_ErrorPrintt("XS.GetTickCount","ID错误")
    end
    return nil;
end
function XS.InitTickCount(id)
    XS_TickCount_Arr[id]=os.time()
end
function XS.ReturnDate(t)		--返回天时分
    t=tonumber(t) or 0
    if t==0 then
        XS_ErrorPrint("XS.ReturnDate","请传入number值")
    else
        local list={math.floor((t/60/60)/24);math.floor((t/60/60)%24);math.floor((t/60)%60);math.floor(t%60)}
        local list2={"天";"小时";"分";"秒"}
        local str=""
        for i=1,#list do
            if list[i]>0 then
                str=str..list[i]..list2[i]
            end
        end
        return str
    end
end
-----------------------------------------------------------------------系统功能合集---------------------------------------------------------------------------------------------
function XS.GetScreen()
    local ret=cmdnew("su -c 'dumpsys window'")
    local information={}
    _,_,information[1],information[2],information[3]=ret:find("init=(%d+)x(%d+) (%d+)dpi")
    if information[1] then
        information[1]=tonumber(information[1])
        information[2]=tonumber(information[2])
        information[3]=tonumber(information[3])
        return information
    else
        return nil
    end
end
function XS.RetSystemInfo()--返回设备信息
    local Arr={Screen={},Version=nil,Imei=nil}
    local list=XS.GetScreen() --获取当前分辨率 
    Arr.Screen={list[1],list[2],list[3]}
    Arr.Version=sysgetversion()
    Arr.Imei=getimei()
    --[[
    Arr={
    Screen={x,y,dpi};分辨率
    Version="6.0.0";手机版本号
    Imei="XXX";设备唯一标识
    }
    --]]
    return Arr
end
function XS.RunApp(name)--打开软件
    local ret=sysstartapp(name)
    if ret then
        XS.Print("打开:"..name.."  成功")
        return true
    else
        XS.Print("打开:"..name.."  失败")
        return false
    end
end
function XS.KillApp(name)--关闭软件
    local ret=syskillapp(name)
    if ret then
        XS.Print("关闭:"..name.."  成功")
        return true
    else
        XS.Print("关闭:"..name.."  失败")
        return false
    end
end
function XS.GetRunType()--返回运行状态
    local value = getruntype()
    if value == 1 then
        return "调试版"
    elseif value == 2 then
        return "独立包"
    elseif value == 3 then
        return "飞天助手"
    end
end
function XS.KeyPress(code)--进行虚拟按键操作,如果没有对应键码则会输入文本(打字)
    local KeyPressArr={回车=66;返回=4;退格=67;Tab=61;Home=3;};
    if KeyPressArr[code] then
        keypress(KeyPressArr[code])
        XS.Print("执行:"..code.."成功")
        return true
    else
        inputtext(tostring(code));
        XS.Print("输入:"..code.."成功")
    end
    return false
end
function XS.SetIme(id)--设置输入法为飞天助手或指定输入法,能防止因为输入法而卡屏
    if id then
        setime(id)
    else
        setime("com.zdnewproject/api.input.TC_IME")
    end
end
-----------------------------------------------------------------------图色功能合集---------------------------------------------------------------------------------------------
function XS.SetScreen(org)
    if type(org)=="string" then
        local Arr={右=1,下=0}
        if Arr[org] then
            setrotatescreen(Arr[org])
            return true
        end
    elseif type(org)=="number" then
        setrotatescreen(org)
        return true
    else
        XS_ErrorPrint("XS.SetScreen","参数错误,请仔细检查!")
        return false
    end
end
function XS.KeepScreen(id)
    local id=id or 0
    releasecapture(id)
    keepcapture(id)
end
XS_Scale=1
function XS.SetScale(X,Y)--设置分辨率缩放功能
    local list=XS.GetScreen()
    if X>Y then
        local a=X
        local X=Y
        local Y=a
    end
    if list[1]>list[2] then
        local a=list[1]
        list[1]=list[2]
        list[2]=a
    end
    XS_Scale=list[1]/X
end
function ColorChange(...)	--色点缩放
    if XS_Scale==1 then
        return ...
    else
        if ...==nil then
            return ...
        end
        if type(...)=="table" then
            Arr=...
        else
            Arr={...}
        end
        if #Arr==1 then--找色参数
            local str=""
            if Arr[1] ~="" then
                local list=XS.Split(Arr[1],",")
                for i=1,#list do
                    if str ~="" then
                        str=str .. ","
                    end
                    local arr=XS.Split(list[i],"|")
                    x=math.ceil(tonumber(arr[1]) * XS_Scale)
                    y=math.ceil(tonumber(arr[2]) * XS_Scale)
                    val=arr[3]
                    str=str .. x .. "|" .. y .. "|" .. val 
                end
            end
            return str
        elseif #Arr==4 then--找色(滑动)四坐标
            for g=1,#Arr do
                if type(Arr[g])=="number" then
                    Arr[g]=math.ceil(Arr[g] * XS_Scale)
                end
            end
            return Arr[1],Arr[2],Arr[3],Arr[4]
        elseif #Arr==2 then--点击坐标
            for g=1,#Arr do
                if type(Arr[g])=="number" then
                    Arr[g]=math.ceil(Arr[g]*XS_Scale)
                end
            end
            return Arr[1],Arr[2]
        end
        return ...
    end
end
function XS.AddTable(ts)
    if ts == nil then
        XS_ErrorPrint("XS.AddTable","参数不能为空")
        return false
    end
    local ts2=XS.ArrayAssign(ts)
    local ret={}
    for k,v in pairs(ts2) do
        if type(v[1])=="table" then
            ret[k]={}
            for i=1,#v do
                ret[k][i]={k}
                for o=1,#v[i] do
                    ret[k][i][#ret[k][i]+1]=v[i][o]
                end
            end
        else
            ret[k]={k}
            for o=1,#v do
                ret[k][#ret[k] + 1]=v[o]
            end
        end
    end
    return ret
end
--主线任务,true,{-100,100},5
function XS.Find(ts,...)
    if ...==nil then
        return false
    end
    local t={...}
    local bool,px,py,r=false,0,0,5
    for i=1,#t do
        if type(t[i])=="boolean" then
            bool=t[i]
        elseif type(t[i])=="table" then
            px=t[i][1]
            py=t[i][2]
        elseif type(t[i])=="number" then
            r=t[i]
        end
    end
    if type(ts[1])=="table" then--多个色点
        for k,v in pairs(ts) do
            local Arr=XS.ArrayAssign(v)
            local x,y=XS_GetColorsPoint(Arr)
            if x~=-1 then
                if bool then
                    XS.Click(x+px,y+py,r)
                end
                XS.Print("XS.Find ->  ".. v[1] ..":"..x..","..y)
                return true,x,y
            end
        end
    else
        local Arr=XS.ArrayAssign(ts)
        local x,y=XS_GetColorsPoint(Arr)
        if x~=-1 then
            if bool then
                XS.Click(x+px,y+py,r)
            end
            XS.Print("XS.Find ->  ".. ts[1] ..":"..x..","..y)
            return true,x,y
        end
    end
    return false,-1,-1
end
function XS_GetColorsPoint(colors)
    --多点找色:0  ,0 ,2000,2000,"cc805b-020202"              ,"9|2|-00ff00|-ff0000,15|2|2dff1c-010101"
    --单点找色:0  ,0 ,500 ,500 ,"000000-ff00ff|f1f1f1-000000"
    --找字:	   324,77,393 ,117 ,"发现"             			 ,"ffffff-000000"
    --获取颜色数量:0,0,500,500,"000000-000000|ff00ff-000000"
    local sim,sc=0.8,0
    local ts=XS.ArrayAssign(colors)
    local name=ts[1]
    table.remove(ts,1)--移除名字
    --补充找色范围
    local newts=nil
    for i=1,#ts do
        if type(ts[i])=="string" then--色点组
            if i<5 then--无找色范围
                newts={0,0,2000,2000}
                for o=i,#ts do
                    newts[#newts+1]=ts[o]
                end
                ts=XS.ArrayAssign(newts)
            end
            break
        end
    end
    --相似度设置
    for i=1,#ts do
        if strfind(tostring(ts[i]),".")~=-1 then
            sim=ts[i]
            table.remove(ts,i)
            break
        end
    end
    --找色方向设置
    for i=5,#ts do
        if type(ts[i])=="number" then
            sc=ts[i]
            table.remove(ts,i)
            break
        end
    end
    --模式选择
    local mode=0
    if type(ts[#ts-1])=="string" and strfind(ts[#ts],"|") ~=-1 and strsub(ts[#ts-1],6,7) == "-" then--找色(多)
        mode=1
        ts=XS.ArrayAssign({ColorChange(ts[1],ts[2],ts[3],ts[4]),ts[5],ColorChange(ts[6])})
    elseif type(ts[#ts])=="string" and strsub(ts[#ts],6,7) == "-" and type(ts[#ts-1])=="number" then--找色(单)
        mode=2
        ts=XS.ArrayAssign({ColorChange(ts[1],ts[2],ts[3],ts[4]),ts[5]})
    elseif type(ts[#ts-1])=="string" and strfind(ts[#ts-1],"-") == -1 then --找字
        sim=0.7
        mode=3
    else--获取颜色数量
        mode=4
        ts=XS.ArrayAssign({ColorChange(ts[1],ts[2],ts[3],ts[4]),ts[5]})
    end
    if mode==1 then--找色
        XS.KeepScreen()
        if #ts==6 then--多点
            local x,y=findmulticolor(ts[1],ts[2],ts[3],ts[4],ts[5],ts[6],sim,sc)
            if x~=-1 then
                return x,y
            end
            return -1,-1
        end
    elseif mode==2 then--单点找色
        XS.KeepScreen()
        if #ts==5 then--单点
            local x,y=findcolor(ts[1],ts[2],ts[3],ts[4],ts[5],sim,sc)
            if x~=-1 then
                return x,y
            end
            return -1,-1
        end
    elseif mode==3 then--找字
        XS.KeepScreen(1)
        setnewdict(getrcpath("rc:"..name..".txt"),1)
        usenewdict(1)
        local x,y=findword(ts[1],ts[2],ts[3],ts[4],ts[5],ts[6],sim)
        lineprint(x)
        if x~=-1 then
            return x,y
        end
        return -1,-1
    elseif mode==4 then--获取颜色数量
        XS.KeepScreen()
        local ret=getcolornum(ts[1],ts[2],ts[3],ts[4],ts[5],sim)
        return tonumber(ret)
    else
        XS_ErrorPrint("找色函数","请检查色点是否错误!")
    end
    return -1,-1
end
function XS.FindAll(str,distance)
    if str==nil then
        return false
    end
    local d=distance or 5
    if type(ts[1])=="table" then--多个色点
        for k,v in pairs(ts) do
            local Arr=XS.ArrayAssign(v)
            local ret=XS_GetAllColors(Arr)
            if ret~="" then
                --转换格式
                local Arr2={}
                local Table=XS.Split(ret,"|")--分割成每个位置
                for i=1,#Table do
                    local tab=XS.Split(Table[i],",")--分割成每个坐标值(id,x,y)
                    if #Arr2>0 then
                        local ret=XS.Distance(Arr[#Arr][1],Arr[#Arr][1],tonumber(tab[2]),tonumber(tab[3]))--取距离
                        if ret>d  then--大于要求距离
                            Arr2[#Arr2+1]={tonumber(tab[2]),tonumber(tab[3])}
                        end
                    else
                        Arr2[#Arr2+1]={tonumber(tab[2]),tonumber(tab[3])}
                    end
                end
                return Arr2
            end
        end
    else
        local Arr=XS.ArrayAssign(ts)
        local ret=XS_GetAllColors(Arr)
        if ret~="" then
            --转换格式
            local Arr2={}
            local Table=XS.Split(ret,"|")--分割成每个位置
            for i=1,#Table do
                local tab=XS.Split(Table[i],",")--分割成每个坐标值(id,x,y)
                if #Arr2>0 then
                    local ret=XS.Distance(Arr[#Arr][1],Arr[#Arr][1],tonumber(tab[2]),tonumber(tab[3]))--取距离
                    if ret>d  then--大于要求距离
                        Arr2[#Arr2+1]={tonumber(tab[2]),tonumber(tab[3])}
                    end
                else
                    Arr2[#Arr2+1]={tonumber(tab[2]),tonumber(tab[3])}
                end
            end
            return Arr2
        end
    end
    return nil;
end
function XS_GetAllColors(c)
    local ts=XS.ArrayAssign(c);
    local sim,sc=0.8,0
    local name=ts[1]
    table.remove(ts,1)--移除名字
    --补充找色范围
    local newts=nil
    for i=1,#ts do
        if type(ts[i])=="string" then--色点组
            if i<5 then--无找色范围
                newts={0,0,2000,2000}
                for o=i,#ts do
                    newts[#newts+1]=ts[o]
                end
                ts=XS.ArrayAssign(newts)
            end
            break
        end
    end
    --相似度设置
    for i=1,#ts do
        if strfind(tostring(ts[i]),".")~=-1 then
            sim=ts[i]
            table.remove(ts,i)
            break
        end
    end
    --找色方向设置
    for i=5,#ts do
        if type(ts[i])=="number" then
            sc=ts[i]
            table.remove(ts,i)
            break
        end
    end
    local ret=findmulticolorex(ts[1],ts[2],ts[3],ts[4],ts[5],ts[6],sim,sc)
    if strlen(ret)>0 then
        return ret;
    else
        return ""
    end
end
-----------------------------------------------------------------------屏幕操作功能合集---------------------------------------------------------------------------------------------
function XS.Click(x,y,...)--点击函数
    local r=r or 5
    local msg=nil
    local Arr={...}
    for i=1,#Arr do
        if type(Arr[i])=="string" then
            msg=Arr[i]
        elseif type(Arr[i])=="number" then
            r=Arr[i]
        end
    end
    local R=rnd(-r,r)
    local R2=rnd(-1*((r^2-R^2)^0.5),(((r)^2-(R)^2)^0.5))--求圆内随机位置
    local x,y=ColorChange(x,y)--坐标换算
    touchdown(x+R,y+R2,1)
    sleep(rnd(10,15))
    touchup(1)
    if msg then
        XS.Show("点击:"..msg)
    end
end
function XS.Slid(x1,y1,x2,y2,id,R) --滑动
    R=R or 5
    local r=rnd(-R,R)
    id=id or 1
    x1,y1,x2,y2=ColorChange(x1,y1,x2,y2)
    if id==1 then--默认滑动
        touchdown(x1 + r, y1 + r, 0)
        sleep(300)
        touchmove(x2 + r, y2 + r, 0)
        sleep(111)
        touchup(0)
    elseif id==2 then--捏合滑动
        local g1, g2
        x1=x1 + r
        y1=y1 + r
        x2=x2 + r
        y2=y2 + r
        touchdown(x1, y1, 0)
        touchdown(x2, y2, 1)
        g1=((x2 - x1) / 2) + x1
        g2=((y2 - y1) / 2) + y1
        touchmove(g1, g2, 0)
        touchmove(g1, g2, 1)
        touchup(0)
        touchup(1)
    elseif id==3 then	--兼容滑动
        touchdown(x1, y1, 0)
        sleep(1000)
        touchmove(x2, y2, 0)
        sleep(1000)
        touchup(0)
    elseif id==4 then	--匀速滑动
        local diff1=x1-x2
        local diff2=y1-y2
        R=R or 400
        if R < 400 then
            R=400 
        end
        local d = XS.Distance(x1,y1,x2,y2)/100
        local x,y= (x2-x1)/d,(y2-y1)/d
        touchdown(x1,y1,1)
        local times=R/d
        for i=1,d do
            touchmove(x1+x*i,y1+y*i,1)
            sleep(times);
        end
        touchup(1)
    end
end
-----------------------------------------------------------------------文字识别功能合集------------------------------------------------------------------------------------------
function XS.Ocr(str)
    if str==nil then
        return nil
    end
    --324,77,393,117,"ffffff-000000"
    local Arr=XS.ArrayAssign(str)
    name=Arr[1]
    local sim=0.7
    table.remove(Arr,1)
    setnewdict(getrcpath("rc:"..name..".txt"),1)
    usenewdict(1)
    for i=1,#Arr do--获取相似度
        if strfind(tostring(Arr[i]),".")~=-1 then
            sim=Arr[i]
            table.remove(Arr,i)
            break
        end
    end
    local ret=ocrrec(Arr[1],Arr[2],Arr[3],Arr[4],Arr[5],sim)
    if ret~=nil and ret~="" then
        return ret
    end
    return nil;
end