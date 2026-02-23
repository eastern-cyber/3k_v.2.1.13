from django.urls import path
from .views import *

urlpatterns = [
    path('', post_page_view),
    path('<pk>/', post_page_view, name='post_page'),
    path('like/<pk>/', like_post, name='like_post'),
    path('bookmark/<pk>/', bookmark_post, name='bookmark_post'),
    path('comment/<pk>', comment, name='comment'),
]