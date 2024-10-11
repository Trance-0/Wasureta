from django.urls import path
from . import views

urlpatterns =[
    path('getJishoList',views.getJishoList),
]