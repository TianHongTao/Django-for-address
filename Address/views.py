from django.contrib import messages
from django.db import transaction
from django.shortcuts import render, redirect
from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
import hashlib
import pymysql

# Create your views here.
from Address import models

try:
    db = pymysql.connect(host='localhost', port=3306, user='root', passwd='root', db='Address',
                     charset="utf8")
    cursor = db.cursor()
except Exception as e:
    print(e)

# 分页器一页展示多少
NUM = 2

def index(request):
    return render(request,"index.html")

def friend(request):
    is_alive = request.session.get('is_login')
    if is_alive == None or is_alive == False:
        messages.error(request, '用户未登录', extra_tags='bg-warning text-warning')
        return redirect('/index/')
    else:
        WechatID = request.session.get('WechatID')
        user_id = models.IdWechatid.objects.filter(wechatid=WechatID).first()
        cursor.execute("SELECT FRIENDID,REMARK FROM Address.RELATION WHERE MYID = %d"%(user_id.id))
        friendlist = cursor.fetchall()
        infos = []

        NUM1 = len(friendlist)
        if NUM1 == 0:
            NUM1 = NUM
        if request.GET.get('page') == None:
            i = 0
        else:
            i = (int(request.GET.get('page'))-1)*NUM1
            request.session["i"] = i

        while(i - request.session.get('i') < NUM1):
            if i >= len(friendlist):
                break;
            cursor.execute("SELECT * FROM Address.USERINFO WHERE ID = %d" % (friendlist[i][0]))
            UserInfo = cursor.fetchone()
            cursor.execute(
                "SELECT LOCATION.LOCATION,PARENT_ID,LOCATION.ID FROM ID_LOCATION,LOCATION WHERE ID_LOCATION.ID = %d AND ID_LOCATION.LOCATION_ID = LOCATION.ID" % (
                    int(friendlist[i][0])))
            location = cursor.fetchone()
            if location == None:
                break
            cursor.execute("call get_full_location(%d)"%(location[2]))
            address = cursor.fetchone()[0]
            remark = friendlist[i][1]
            cursor.execute("SELECT WECHATID FROM Address.ID_WECHATID WHERE ID = %d" % (friendlist[i][0]))
            WechatID = cursor.fetchone()
            info = {}
            info['WechatID'] = WechatID[0]
            info['Remark'] = remark
            info['Email'] = UserInfo[5]
            info['Phone'] = UserInfo[1]
            info['Location'] = address
            info['signature'] = UserInfo[4]
            infos.append(info)
            i+=1

        p = Paginator(friendlist, NUM1,2)
        page = request.GET.get('page')
        try:
            contacts = p.page(page)
        except PageNotAnInteger:
            contacts = p.page(1)
        except EmptyPage:
            contacts = p.page(Paginator.num_pages)
        return render(request, "friend.html",{'contacts': contacts, 'infos' : infos})


def myself(request):
    is_alive = request.session.get('is_login')
    if is_alive == None or is_alive == False:
        messages.error(request, '用户未登录', extra_tags='bg-warning text-warning')
        return redirect('/index/')
    else:
        try:
            WechatID = request.session.get('WechatID')
            user_id = models.IdWechatid.objects.filter(wechatid=WechatID).first()
            cursor.execute("SELECT * FROM USERINFO WHERE ID = %d" %(int(user_id.id)))
            data = cursor.fetchone()
            cursor.execute("SELECT LOCATION.LOCATION,PARENT_ID,LOCATION.ID FROM ID_LOCATION,LOCATION WHERE ID_LOCATION.ID = %d AND ID_LOCATION.LOCATION_ID = LOCATION.ID" % (int(user_id.id)))
            location = cursor.fetchone()
            cursor.execute("call get_full_location(%d)"%(location[2]))
            address = cursor.fetchone()[0]
            print(address)

        except Exception as e:
            print(e)
        context = {
            'WechatID': user_id.wechatid,
            'Password': data[2],
            'Username': data[3],
            'Email': data[5],
            'Phone': data[1],
            'Location': address,
            'signature': data[4],
        }
        return render(request, "myself.html",context)

def registe(request):
    WechatID = request.POST['Wechat-ID']
    Password = request.POST['Password']
    Username = request.POST['Username']
    Email = request.POST['Email']
    Phone = int(request.POST['Phone'])
    Location = request.POST['Location']
    signature = request.POST['signature']
    verification = [False,False,False]

    for i in Password:
        if(i>'1' and i<'9'):
            verification[0] = True
        elif(i>'a' and i<'z'):
            verification[1] = True
        elif(i>'A' and i<'Z'):
            verification[2] = True

    if False in verification:
        messages.error(request, '密码请包含大小写英文字符以及数字', extra_tags='bg-warning text-warning')
        return redirect('/index/')
    elif len(Password) < 6:
        messages.error(request, '密码请至少包含6个字符', extra_tags='bg-warning text-warning')
        return redirect('/index/')

    try:
        Id_Wechatid = models.IdWechatid(wechatid=WechatID)
        Id_Wechatid.save()
        location_list = Location.split()
        now_id = Id_Wechatid.id
        now_location_id = None
        parent_id = 1
        for location in location_list:
            Id_Location = models.Location(location=location, parent_id=parent_id)
            Id_Location.save()
            parent_id = Id_Location.id
            now_location_id = Id_Location.id
        cursor.execute("INSERT INTO ID_LOCATION(ID,LOCATION_ID) VALUES (%d,%d)"%(int(now_id),int(now_location_id)))
        db.commit()
        cursor.execute("INSERT INTO USERINFO(ID,PHONE,PASSWORD,USERNAME,signature,email) VALUES (%d,%d,\"%s\",\"%s\",\"%s\",\"%s\")"%(int(now_id), int(Phone), str(Password), str(Username), str(signature),str(Email)))
        db.commit()
    except Exception as e:
        messages.error(request, str(e), extra_tags='bg-warning text-warning')
        print(e)
    return render(request, "index.html")

def login(request):
    WechatID = request.GET['Wechat-ID']
    Password = request.GET['Password']
    md5 = hashlib.md5()
    md5.update(bytes(Password,encoding = 'utf-8'))
    user_id = models.IdWechatid.objects.filter(wechatid = WechatID).first()
    if user_id:
        user = models.Userinfo.objects.filter(id = user_id.id,password=Password).first()
        # print()
        if user:
            request.session['is_login'] = True
            request.session['WechatID'] = user_id.wechatid
            request.session['Password'] = user.password
            request.session["i"] = 0
            if user_id.wechatid == 'Admin':
                return redirect('/Myadmin/')
            return redirect('/friend/')
        else:
            messages.error(request, '帐号/密码有误', extra_tags='bg-warning text-warning')
            return redirect('/index/')
    else:
        messages.error(request, '帐号为空', extra_tags='bg-warning text-warning')
        return redirect('/index/')

def someone(request):
    wechatID = request.POST['Wechat-ID']
    if wechatID == 'Wechat-ID':
        messages.error(request, '请输入有效字符', extra_tags='bg-warning text-warning')
        return redirect('/friend/')
    else:
        try:
            user_id = models.IdWechatid.objects.filter(wechatid=wechatID).first()
            if user_id == None:
                messages.error(request, 'WechatID不匹配', extra_tags='bg-warning text-warning')
                return redirect('/friend/')
            cursor.execute("SELECT * FROM USERINFO WHERE ID = %d" %(int(user_id.id)))
            data = cursor.fetchone()
            request.session['friendID'] = wechatID
            cursor.execute("SELECT LOCATION.LOCATION,PARENT_ID,LOCATION.ID FROM ID_LOCATION,LOCATION WHERE ID_LOCATION.ID = %d AND ID_LOCATION.LOCATION_ID = LOCATION.ID" % (int(user_id.id)))
            location = cursor.fetchone()
            cursor.execute("call get_full_location(%d)"%(location[2]))
            address = cursor.fetchone()[0]

        except Exception as e:
            print(e)
        context = {
            'WechatID': user_id.wechatid,
            'Password': data[2],
            'Username': data[3],
            'Email': data[5],
            'Phone': data[1],
            'Location': address,
            'signature': data[4],
        }
        return render(request, "someone.html",context)

def addfriend(request):
    MyWechatID = request.session.get('WechatID')
    FriendWechatID = request.session.get('friendID')
    Remark = request.POST['Remark']
    Me = models.IdWechatid.objects.filter(wechatid = MyWechatID).first()
    Friend = models.IdWechatid.objects.filter(wechatid = FriendWechatID).first()
    if Me == None:
        messages.error(request, '请重新登录', extra_tags='bg-warning text-warning')
        return redirect('/index/')
    elif Friend == None:
        messages.error(request, '好友的WechatID不匹配', extra_tags='bg-warning text-warning')
        return redirect('/friend/')
    elif Me == Friend:
        messages.error(request, '请勿添加自己为好友', extra_tags='bg-warning text-warning')
        return redirect('/friend/')
    else:
        try:
            cursor.execute("INSERT INTO RELATION(MYID,FRIENDID,REMARK) VALUES (%d,%d,\"%s\")" % (int(Me.id), int(Friend.id), str(Remark)))
            db.commit()
        except Exception as e:
            print(e)
    return redirect('/friend/')

def modifyinfo(request):
    WechatID = request.POST['Wechat-ID']
    Password = request.POST['Password']
    Username = request.POST['Username']
    Email = request.POST['Email']
    Phone = int(request.POST['Phone'])
    Location = request.POST['Location']
    signature = request.POST['signature']
    PastPassword = request.POST['PastPassword']
    Me = models.IdWechatid.objects.filter(wechatid=WechatID).first()
    context = {
        'WechatID':WechatID,
        'Password' : Password,
        'Username' : Username,
        'Email' : Email,
        'Phone' : Phone,
        'Location' : Location,
        'signature' : signature,
    }
    try:
        cursor.execute("SELECT PASSWORD FROM Address.USERINFO WHERE ID = %d" % (Me.id))
        pastpassword = cursor.fetchone()
        if PastPassword != pastpassword[0]:
            messages.error(request, '旧密码输入错误', extra_tags='bg-warning text-warning')
            return redirect('/friend/')
    except Exception as e:
        print(e)
    location_list = Location.split()
    try:
        cursor.execute("SELECT ID FROM LOCATION WHERE LOCATION = \"%s\""%(location_list[-1]))
        LocationID = cursor.fetchone()
        cursor.execute("UPDATE ID_LOCATION SET LOCATION_ID = %d WHERE ID = %d"%(int(LocationID[0]),int(Me.id)))
        cursor.execute("UPDATE USERINFO SET Address.USERINFO.PASSWORD = \"%s\", Address.USERINFO.USERNAME = \"%s\","
                   "Address.USERINFO.email = \"%s\", Address.USERINFO.PHONE = %d, Address.USERINFO.signature = \"%s\" "
                   "WHERE Address.USERINFO.ID = %d" % (Password,Username,Email,int(Phone),signature,int(Me.id)))
        db.commit()
    except Exception as e:
        print(e)

    return render(request, "myself.html", context)

def delete(request):
    friendWechatID = request.POST['WechatID']
    myWechatID = request.session.get('WechatID')
    try:
        friend_id = models.IdWechatid.objects.filter(wechatid=friendWechatID).first()
        my_id = models.IdWechatid.objects.filter(wechatid=myWechatID).first()
        cursor.execute("DELETE FROM Address.RELATION WHERE Address.RELATION.MYID = %d AND Address.RELATION.FRIENDID = %d"%(my_id.id,friend_id.id))
        db.commit()
    except Exception as e:
        print(e)
        messages.error(request, '好友删除有误', extra_tags='bg-warning text-warning')
        return redirect('/friend/')

    return redirect('/friend/')


def Myadmin(request):
    is_alive = request.session.get('is_login')
    if is_alive == None or is_alive == False:
        messages.error(request, '用户未登录', extra_tags='bg-warning text-warning')
        return redirect('/index/')
    else:
        WechatID = request.session.get('WechatID')
        if WechatID != 'Admin':
            messages.error(request, '管理员用户未登录', extra_tags='bg-warning text-warning')
            return redirect('/index/')
        try:
            db = pymysql.connect(host='localhost', port=3306, user='root', passwd='root', db='Address',
                                 charset="utf8")
            cursor = db.cursor()
        except Exception as e:
            print(e)
        cursor.execute("SELECT WECHATID FROM Address.ID_WECHATID WHERE WECHATID != 'Admin'")
        userlist = cursor.fetchall()
        infos = []

        if request.GET.get('page') == None:
            i = 0
        else:
            i = (int(request.GET.get('page')) - 1) * NUM
            request.session["i"] = i

        while (i - request.session.get('i') < NUM):
            if i > len(userlist) or userlist[i] == None:
                break
            info = {}
            info['WechatID'] = str(userlist[i]).replace('(\''," ").replace('\',)'," ")
            infos.append(info)
            i += 1

        p = Paginator(userlist, NUM, 2)
        page = request.GET.get('page')
        try:
            contacts = p.page(page)
        except PageNotAnInteger:
            contacts = p.page(1)
        except EmptyPage:
            contacts = p.page(Paginator.num_pages)
        return render(request, "Admin.html", {'contacts': contacts, 'infos': infos})




def Users(request):
    wechatID = request.POST['WechatID']
    if wechatID == 'Wechat-ID':
        messages.error(request, '请输入有效字符', extra_tags='bg-warning text-warning')
        return redirect('/friend/')
    else:
        try:
            user_id = models.IdWechatid.objects.filter(wechatid=wechatID).first()
            if user_id == None:
                messages.error(request, 'WechatID不匹配', extra_tags='bg-warning text-warning')
                return redirect('/friend/')
            cursor.execute("SELECT * FROM USERINFO WHERE ID = %d" %(int(user_id.id)))
            data = cursor.fetchone()
            request.session['friendID'] = wechatID
            cursor.execute("SELECT LOCATION.LOCATION,PARENT_ID,LOCATION.ID FROM ID_LOCATION,LOCATION WHERE ID_LOCATION.ID = %d AND ID_LOCATION.LOCATION_ID = LOCATION.ID" % (int(user_id.id)))
            location = cursor.fetchone()
            cursor.execute("call get_full_location(%d)"%(location[2]))
            address = cursor.fetchone()[0]

        except Exception as e:
            print(e)
        context = {
            'WechatID': user_id.wechatid,
            'Password': data[2],
            'Username': data[3],
            'Email': data[5],
            'Phone': data[1],
            'Location': address,
            'signature': data[4],
        }
        return render(request, "Users.html",context)

def modifyUser(request):
    WechatID = request.POST['Wechat-ID']
    Password = request.POST['Password']
    Username = request.POST['Username']
    Email = request.POST['Email']
    Phone = int(request.POST['Phone'])
    Location = request.POST['Location']
    signature = request.POST['signature']
    Me = models.IdWechatid.objects.filter(wechatid=WechatID).first()
    context = {
        'WechatID':WechatID,
        'Password' : Password,
        'Username' : Username,
        'Email' : Email,
        'Phone' : Phone,
        'Location' : Location,
        'signature' : signature,
    }
    location_list = Location.split()
    try:
        db = pymysql.connect(host='localhost', port=3306, user='root', passwd='root', db='Address',
                             charset="utf8")
        cursor = db.cursor()
    except Exception as e:
        print(e)
    try:
        cursor.execute("SELECT ID FROM LOCATION WHERE LOCATION = \"%s\""%(location_list[-1]))
        LocationID = cursor.fetchone()
        cursor.execute("UPDATE ID_LOCATION SET LOCATION_ID = %d WHERE ID = %d"%(int(LocationID[0]),int(Me.id)))
        cursor.execute("UPDATE USERINFO SET Address.USERINFO.PASSWORD = \"%s\", Address.USERINFO.USERNAME = \"%s\","
                   "Address.USERINFO.email = \"%s\", Address.USERINFO.PHONE = %d, Address.USERINFO.signature = \"%s\" "
                   "WHERE Address.USERINFO.ID = %d" % (Password,Username,Email,int(Phone),signature,int(Me.id)))
        db.commit()
    except Exception as e:
        print(e)
    return render(request, "Users.html", context)


def delUser(request):
    WechatID = request.POST['Wechat-ID']
    now = models.IdWechatid.objects.filter(wechatid=WechatID).first()
    cursor.execute("SET FOREIGN_KEY_CHECKS = 0")
    cursor.execute("DELETE FROM Address.USERINFO WHERE Address.USERINFO.ID = %d"%(int(now.id)))
    cursor.execute("DELETE FROM Address.ID_WECHATID WHERE Address.ID_WECHATID.WECHATID = \"%s\""%(WechatID))
    cursor.execute("SET FOREIGN_KEY_CHECKS = 1")
    db.commit()
    return redirect("/Myadmin/")


def GroupShow(request):
    is_alive = request.session.get('is_login')
    if is_alive == None or is_alive == False:
        messages.error(request, '用户未登录', extra_tags='bg-warning text-warning')
        return redirect('/index/')
    else:
        WechatID = request.session.get('WechatID')
        user_id = models.IdWechatid.objects.filter(wechatid=WechatID).first()
        cursor.execute("SELECT Group_ID FROM Address.Group_Relation WHERE User_ID = %d" % (user_id.id))
        GROUPIDS = cursor.fetchall()
        infos = []
        NUM1 = len(GROUPIDS)
        if NUM1 == 0:
            NUM1 = NUM

        if request.GET.get('page') == None:
            i = 0
        else:
            i = (int(request.GET.get('page')) - 1) * NUM1
            request.session["i"] = i

        while (i - request.session.get('i') < NUM1):
            if i >= len(GROUPIDS):
                break
            cursor.execute("SELECT ID,NAME,INFO FROM Address.group WHERE ID = %d"%(int(GROUPIDS[i][0])))
            groupinfo = cursor.fetchone()
            info = {}
            # print(groupinfo[0])
            info["GroupID"] = groupinfo[0]
            info['GroupName'] = groupinfo[1]
            info['INFO'] = groupinfo[2]
            infos.append(info)
            i += 1

        p = Paginator(GROUPIDS, NUM1 , 2)
        page = request.GET.get('page')
        try:
            contacts = p.page(page)
        except PageNotAnInteger:
            contacts = p.page(1)
        except EmptyPage:
            contacts = p.page(Paginator.num_pages)
        return render(request, "GroupShow.html", {'contacts': contacts, 'infos': infos})


def Groupdelete(request):
    WechatID = request.session.get('WechatID')
    now = models.IdWechatid.objects.filter(wechatid=WechatID).first()
    GroupID = request.POST["GroupID"]
    cursor.execute("SET FOREIGN_KEY_CHECKS = 0")
    cursor.execute("DELETE FROM Address.Group_Relation WHERE User_ID = %d and Group_ID = %d"%(int(now.id),int(GroupID)))
    cursor.execute("SET FOREIGN_KEY_CHECKS = 1")
    db.commit()
    return redirect("/GroupShow/")

def GroupInfo(request):
    GroupID = request.POST['GroupID']
    is_alive = request.session.get('is_login')
    if is_alive == None or is_alive == False:
        messages.error(request, '用户未登录', extra_tags='bg-warning text-warning')
        return redirect('/index/')
    else:
        cursor.execute("SELECT NAME,INFO,ID FROM Address.group WHERE ID = %d"%(int(GroupID)))
        GroupInfo = cursor.fetchone()

        if GroupInfo == None:
            messages.error(request, '无当前搜索的群聊', extra_tags='bg-warning text-warning')
            return redirect('/GroupShow/')

        cursor.execute("SELECT User_ID FROM Group_Relation WHERE Group_ID = %d"%(int(GroupID)))
        GroupPerson = cursor.fetchall()
        friendlist = GroupPerson
        infos = []

        NUM1 = len(friendlist)
        if NUM1 == 0:
            NUM1 = NUM

        if request.GET.get('page') == None:
            i = 0
        else:
            i = (int(request.GET.get('page'))-1)*NUM1
            request.session["i"] = i

        while(i - request.session.get('i') < NUM1):
            if i >= len(friendlist):
                break
            cursor.execute("SELECT * FROM Address.USERINFO WHERE ID = %d" % (friendlist[i][0]))
            UserInfo = cursor.fetchone()
            cursor.execute(
                "SELECT LOCATION.LOCATION,PARENT_ID,LOCATION.ID FROM ID_LOCATION,LOCATION WHERE ID_LOCATION.ID = %d AND ID_LOCATION.LOCATION_ID = LOCATION.ID" % (
                    int(friendlist[i][0])))
            location = cursor.fetchone()
            print(location)
            if location == None:
                break
            cursor.execute("call get_full_location(%d)"%(location[2]))
            address = cursor.fetchone()[0]
            cursor.execute("SELECT USERNAME FROM Address.USERINFO WHERE ID = %d"%(friendlist[i][0]))
            remark = cursor.fetchone()
            cursor.execute("SELECT WECHATID FROM Address.ID_WECHATID WHERE ID = %d" % (friendlist[i][0]))
            WechatID = cursor.fetchone()
            info = {}
            info['WechatID'] = WechatID[0]
            info['Remark'] = remark[0]
            info['Email'] = UserInfo[5]
            info['Phone'] = UserInfo[1]
            info['Location'] = address
            info['signature'] = UserInfo[4]
            infos.append(info)
            i+=1

        p = Paginator(GroupPerson, NUM1,2)
        page = request.GET.get('page')
        try:
            contacts = p.page(page)
        except PageNotAnInteger:
            contacts = p.page(1)
        except EmptyPage:
            contacts = p.page(Paginator.num_pages)
        return render(request, "GroupInfo.html",{'contacts': contacts, 'infos' : infos,"GroupID":GroupInfo[2],"GroupName":GroupInfo[0],"INFO":GroupInfo[1]})

def addGroup(request):
    GroupID = request.POST['GroupID']
    WechatID = request.session.get('WechatID')
    now = models.IdWechatid.objects.filter(wechatid=WechatID).first()
    cursor.execute("INSERT INTO Group_Relation(User_ID, Group_ID) VALUES (%d,%d)"%(int(now.id),int(GroupID)))
    db.commit()
    return redirect("/GroupShow/")

def regGroup(request):
    Name = request.POST['Name']
    INFO = request.POST['INFO']
    FriendID = request.POST['FriendID']
    FriendID_list = FriendID.split(",")
    WechatID = request.session.get('WechatID')
    try:
        Id_Wechatid = models.IdWechatid.objects.filter(wechatid=WechatID).first()
        cursor.execute("INSERT INTO Address.group(NAME,INFO) VALUES (\"%s\",\"%s\")"%(str(Name),str(INFO)))
        db.commit()
        cursor.execute("SELECT ID FROM Address.group WHERE NAME = \"%s\" and INFO = \"%s\""%(str(Name),str(INFO)))
        id = cursor.fetchone()
        cursor.execute("INSERT INTO Group_Relation(User_ID,Group_ID) VALUES (%d,%d)"%(int(Id_Wechatid.id), int(id[0])))
        db.commit()
        for i in FriendID_list:
            cursor.execute(
                "INSERT INTO Group_Relation(User_ID,Group_ID) VALUES (%d,%d)" % (int(i), int(id[0])))
            db.commit()
            print("INSERT INTO Group_Relation(User_ID,Group_ID) VALUES (%d,%d)" % (int(i), int(id[0])))
    except Exception as e:
        messages.error(request, str(e), extra_tags='bg-warning text-warning')
        print(e)
    return redirect("/GroupShow/")


def OfficialAccountShow(request):
    is_alive = request.session.get('is_login')
    if is_alive == None or is_alive == False:
        messages.error(request, '用户未登录', extra_tags='bg-warning text-warning')
        return redirect('/index/')
    else:
        WechatID = request.session.get('WechatID')
        Id_Wechatid = models.IdWechatid.objects.filter(wechatid=WechatID).first()
        cursor.execute("SELECT Off_ID FROM OfficialAccount_Relation WHERE User_ID = %d" % (int(Id_Wechatid.id)))
        Off_IDS = cursor.fetchall()
        infos = []
        NUM1 = len(Off_IDS)
        if NUM1 == 0:
            NUM1 = NUM
        if request.GET.get('page') == None:
            i = 0
        else:
            i = (int(request.GET.get('page')) - 1) * NUM1
            request.session["i"] = i

        while (i - request.session.get('i') < NUM1):
            if i >= len(Off_IDS):
                break
            cursor.execute("SELECT * FROM Address.OfficialAccount WHERE ID = %d" % (int(Off_IDS[i][0])))
            groupinfo = cursor.fetchone()
            info = {}
            # print(groupinfo[0])
            info["ID"] = groupinfo[0]
            info['Name'] = groupinfo[1]
            info['INFO'] = groupinfo[2]
            info['MAINBODY'] = groupinfo[3]
            infos.append(info)
            i += 1

        p = Paginator(Off_IDS, NUM1, 2)
        page = request.GET.get('page')
        if page == None:
            page = 1
        try:
            contacts = p.page(page)
        except PageNotAnInteger:
            contacts = p.page(1)
        except EmptyPage:
            contacts = p.page(Paginator.num_pages)
        return render(request, "OfficialAccountShow.html", {'contacts': contacts, 'infos': infos})

def OffInfo(request):
    OfficialAccountName = request.POST['Name']
    is_alive = request.session.get('is_login')
    if is_alive == None or is_alive == False:
        messages.error(request, '用户未登录', extra_tags='bg-warning text-warning')
        return redirect('/index/')
    else:
        cursor.execute("SELECT * FROM Address.OfficialAccount WHERE NAME = \"%s\""%(str(OfficialAccountName)))
        OfficialAccountINFO = cursor.fetchone()
        if OfficialAccountINFO == None:
            messages.error(request, '无当前搜索的公众号', extra_tags='bg-warning text-warning')
            return redirect('/OfficialAccountShow/')
        cursor.execute("SELECT * FROM Address.OfficialAccount_Relation WHERE Off_ID = %d"%(int(OfficialAccountINFO[0])))
        OfficialAccountRelations = cursor.fetchall()
        nums = len(OfficialAccountRelations)
        cursor.execute("SELECT * FROM OfficialAccount_Word WHERE Off_ID = %d"%(int(OfficialAccountINFO[0])))
        OfficialAccountWords = cursor.fetchall()
        infos = []
        NUM1 = len(OfficialAccountWords)
        if NUM1 == 0:
            NUM1 = NUM

        if request.GET.get('page') == None:
            i = 0
        else:
            i = (int(request.GET.get('page'))-1)*NUM1
            request.session["i"] = i

        while(i - request.session.get('i') < NUM1):
            if i >= len(OfficialAccountWords):
                break
            cursor.execute("SELECT * FROM Address.Word WHERE ID = %d"%(int(OfficialAccountWords[i][1])))
            Wordinfo = cursor.fetchone()
            info = {}
            info["Info"] = Wordinfo[1]
            info["Name"] = Wordinfo[2]
            infos.append(info)
            i+=1

        p = Paginator(OfficialAccountWords, NUM1,2)
        page = request.GET.get('page')
        try:
            contacts = p.page(page)
        except PageNotAnInteger:
            contacts = p.page(1)
        except EmptyPage:
            contacts = p.page(Paginator.num_pages)
        return render(request, "OfficialAccountInfo.html",{'contacts': contacts, 'infos' : infos,
                                                 "ID": OfficialAccountINFO[0],"Name":OfficialAccountINFO[1],
                                                "MAINBODY":OfficialAccountINFO[3],"Nums":nums, "INFO":OfficialAccountINFO[2]})

def addOff(request):
    OfficialAccountID = request.POST['ID']
    WechatID = request.session.get('WechatID')
    now = models.IdWechatid.objects.filter(wechatid=WechatID).first()
    OfficialAccountID  = OfficialAccountID[3]
    cursor.execute("INSERT INTO OfficialAccount_Relation(User_ID, Off_ID) VALUES (%d,%d)"%(int(now.id),int(OfficialAccountID)))
    db.commit()
    return redirect("/OfficialAccountShow/")

def regOff(request):
    Name = request.POST['Name']
    INFO = request.POST['INFO']
    MAINBODY = request.POST['MAINBODY']
    WechatID = request.session.get('WechatID')
    try:
        Id_Wechatid = models.IdWechatid.objects.filter(wechatid=WechatID).first()
        cursor.execute("INSERT INTO OfficialAccount(NAME, INFO, MAINBODY) VALUES(\"%s\",\"%s\",\"%s\")"%(str(Name),str(INFO),str(MAINBODY)))
        db.commit()
        cursor.execute("SELECT ID FROM OfficialAccount WHERE NAME = \"%s\"" % (str(Name)))
        id = cursor.fetchone()
        cursor.execute(
            "INSERT INTO OfficialAccount_Relation(User_ID,Off_ID) VALUES (%d,%d)" % (int(Id_Wechatid.id), int(id[0])))
        db.commit()
    except Exception as e:
        messages.error(request, str(e), extra_tags='bg-warning text-warning')
        print(e)
    return redirect("/OfficialAccountShow/")

def Offdel(request):
    WechatID = request.session.get('WechatID')
    now = models.IdWechatid.objects.filter(wechatid=WechatID).first()
    OfficialAccountID = request.POST["ID"]
    cursor.execute("SET FOREIGN_KEY_CHECKS = 0")
    cursor.execute("DELETE FROM Address.OfficialAccount_Relation WHERE User_ID = %d and Off_ID = %d"%(int(now.id),int(OfficialAccountID)))
    cursor.execute("SET FOREIGN_KEY_CHECKS = 1")
    db.commit()
    return redirect("/OfficialAccountShow/")

def Wordadd(request):
    request.session["offID"] = request.POST['ID'][3:]
    return render(request,"Word.html")

def regWord(request):
    WechatID = request.session.get('WechatID')
    now = models.IdWechatid.objects.filter(wechatid=WechatID).first()
    offID = request.session.get('offID')
    Name = request.POST['Name']
    INFO = request.POST['INFO']
    try:
        cursor.execute("INSERT INTO Word(NAME,INFO) VALUES (\"%s\",\"%s\")"%(str(Name),str(INFO)))
        cursor.execute("SELECT ID FROM Word WHERE NAME  = \"%s\" AND INFO = \"%s\"" % (str(Name), str(INFO)))
        ID = cursor.fetchone()
        cursor.execute("INSERT INTO OfficialAccount_Word(Off_ID, Word_ID) VALUES (%d,%d)"%(int(offID),int(ID[0])))
        cursor.execute("call INSERTINTOOFF(%d,%d)"%(int(now.id),int(offID)))
        db.commit()

    except Exception as e:
        print(e)
    return redirect("/OfficialAccountShow/")

def Group(request):
    return render(request,"Group.html")

def OffAccount(request):
    return render(request,"OfficialAccount.html")

