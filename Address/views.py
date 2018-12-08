from django.contrib import messages
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
        for i in range(len(friendlist)):
            cursor.execute("SELECT * FROM Address.USERINFO WHERE ID = %d" % (friendlist[i][0]))
            UserInfo = cursor.fetchone()
            cursor.execute(
                "SELECT LOCATION.LOCATION,PARENT_ID FROM ID_LOCATION,LOCATION WHERE ID_LOCATION.ID = %d AND ID_LOCATION.LOCATION_ID = LOCATION.ID" % (
                    int(friendlist[i][0])))
            location = cursor.fetchone()
            address = ""
            while int(location[1]) != 1:
                address = address + location[0] + " "
                cursor.execute(
                    "SELECT LOCATION.LOCATION,PARENT_ID FROM LOCATION WHERE LOCATION.ID = %d " % (
                        int(location[1])))
                location = cursor.fetchone()
            address = address + location[0] + " "
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

        p = Paginator(friendlist, 5,2)
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
            cursor.execute("SELECT LOCATION.LOCATION,PARENT_ID FROM ID_LOCATION,LOCATION WHERE ID_LOCATION.ID = %d AND ID_LOCATION.LOCATION_ID = LOCATION.ID" % (int(user_id.id)))
            location = cursor.fetchone()
            address = ""
            # print(location)
            while int(location[1]) != 1:
                address = address+location[0]+" "
                cursor.execute(
                    "SELECT LOCATION.LOCATION,PARENT_ID FROM LOCATION WHERE LOCATION.ID = %d " % (
                        int(location[1])))
                location = cursor.fetchone()
            address = address + location[0] + " "

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
    # print(Phone)
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
        cursor.execute("INSERT INTO USERINFO(ID,PHONE,PASSWORD,USERNAME,signature,email) VALUES (%d,%d,%s,\"%s\",\"%s\",\"%s\")"%(int(now_id), int(Phone), str(Password), str(Username), str(signature),str(Email)))
        db.commit()
    except Exception as e:
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
            cursor.execute("SELECT LOCATION.LOCATION,PARENT_ID FROM ID_LOCATION,LOCATION WHERE ID_LOCATION.ID = %d AND ID_LOCATION.LOCATION_ID = LOCATION.ID" % (int(user_id.id)))
            location = cursor.fetchone()
            address = ""
            # print(location)
            while int(location[1]) != 1:
                address = address+location[0]+" "
                cursor.execute(
                    "SELECT LOCATION.LOCATION,PARENT_ID FROM LOCATION WHERE LOCATION.ID = %d " % (
                        int(location[1])))
                location = cursor.fetchone()
            address = address + location[0] + " "

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
    # print(friendWechatID)
    # print(myWechatID)
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