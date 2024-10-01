"""
Admin view registration

After you modify the class, don't forget to register the models or 
they will not be avaliable in admin site.
"""
from django.contrib import admin

# Register your models here.

from .models import Member,VerificationCode


class MemberInline(admin.TabularInline):
    """Line per creator in admin view and one extra for convenience"""
    model=Member
    extra=1

class ActivationCodeInline(admin.StackedInline):
    """Line per creator in admin view and one extra for convenience"""
    model=VerificationCode
    extra=1

# Add model to admin view
admin.site.register(Member,MemberInline)
admin.site.register(VerificationCode,ActivationCodeInline)
