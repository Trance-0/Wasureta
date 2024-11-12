from django.urls import path
from . import views

urlpatterns =[
    path('<int:jisho_id>',views.getJisho),
    path('word_pairs_preview/<int:jisho_id>',views.getWordPairsPreview),
    path('getJishoList',views.getJishoList),
    path('create',views.createJisho),
]
