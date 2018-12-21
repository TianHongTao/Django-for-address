"""shujuku URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf.urls import url
from django.contrib import admin
from django.urls import path

from Address import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('index/', views.index, name = "index"),
    path('friend/', views.friend, name = "use"),
    path('myself/', views.myself, name = 'myself'),
    path('Myadmin/', views.Myadmin, name='Myadmin'),
    path('GroupShow/',views.GroupShow,name='GroupShow'),
    path('OfficialAccountShow/',views.OfficialAccountShow,name='OfficialAccountShow'),
    url('registe', views.registe, name = 'registe'),
    url('login', views.login, name='login'),
    url('someone', views.someone, name='someone'),
    url('addfriend', views.addfriend, name='addfriend'),
    url('modifyinfo', views.modifyinfo, name='modifyinfo'),
    url('delete', views.delete, name='delete'),
    url('Users',views.Users,name='Users'),
    url('modifyUser',views.modifyUser,name='modifyUser'),
    url('delUser',views.delUser,name='delUser'),
    url('Groupdel',views.Groupdelete,name='Groupdel'),
    url('GroupInfo',views.GroupInfo,name='GroupInfo'),
    url('addGroup',views.addGroup,name='addGroup'),
    url('regGroup',views.regGroup,name='regGroup'),
    url("Group",views.Group,name='Group'),
    url('Offdel',views.Offdel,name="Offdel"),
    url("OffInfo", views.OffInfo, name="OffInfo"),
    url("addOff", views.addOff, name="addOff"),
    url('regOff', views.regOff, name='regOff'),
    url("OffAccount",views.OffAccount,name="OffAccount"),
]
