from django.urls import path
from . import views

urlpatterns =[
    path('<int:jisho_id>',views.getJisho),
    path('getJishoList',views.getJishoList),
    path('create',views.createJisho),
]
