from django.db import models

# Create your models here.
from datetime import timedelta
import os
from django.conf import settings
from django.db import models
from django.utils.timezone import now
from django.utils.translation import gettext_lazy as _
from django.utils.crypto import get_random_string

def user_profile_path(instance, filename):
    """ 
    file will be uploaded to MEDIA_ROOT/user_<id>/<filename>
    https://docs.djangoproject.com/en/dev/ref/models/fields/#django.db.models.FileField.upload_to
    """
    # return "profile_pic/user_{0}/{1}".format(instance.user.id, filename)
    # we save only one latest image.
    _name, extension = os.path.splitext(filename)
    return "user_upload/user_{0}/profile_pic/profile_latest{1}".format(instance.user_id.id, extension)

class Member(models.Model):
    """for django built-in authentication: https://docs.djangoproject.com/en/4.2/ref/contrib/auth/"""

    # This objects contains the username, password, first_name, last_name, and email of member.
    user_id = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        # when member is delete, user would also be deleted
        on_delete=models.CASCADE,
        null=False,
    )
    image = models.ImageField(upload_to=user_profile_path, blank=True, null=False)
    motto = models.CharField(max_length=100, blank=True, null=True)
    reputation = models.IntegerField(default=0, null=False)
    exp = models.IntegerField(default=0, null=False)
    social_link = models.URLField(max_length=255, blank=True, null=True)
    credit_remains = models.IntegerField(default=0, null=False)

    # last_login and date_joined automatically created by user_id, for these field, create one time value to timezone.now()
    # The field is only automatically updated when calling Model.save().
    last_login=models.DateTimeField(auto_now=True, null=False)
    # Automatically set the field to now when the object is first created. 
    date_joined=models.DateTimeField(auto_now_add=True, null=False)

    # user status is determined by the group in user attribute

    def __str__(self):
        """for better list display"""
        return f"{self.user_id.get_full_name()},user_id:{self.user_id.id},username:{self.user_id.username}"

class VerificationChoices(models.TextChoices):
    """User group choices, may be more efficient if use django internal group"""

    REGISTER = "R", _("Register")
    AUTHENTICATE = "A", _("Authenticate")
    FUNCTION = "F", _("Function")

class VerificationCode(models.Model):
    """This is the activation code that will be used for create user."""

    code = models.CharField(max_length=255, unique=True, null=True, blank=True)
    # editable datetime field with auto-now
    # https://stackoverflow.com/a/18752680/14110380
    expire_date = models.DateTimeField(default=now,null=False)
    usage = models.CharField(
        null=False,
        max_length=1,
        choices=VerificationChoices.choices,
        default=VerificationChoices.AUTHENTICATE,
    )
    function = models.CharField(max_length=255, default="",null=True)
    max_use = models.IntegerField(default=1, null=False)

    def __str__(self):
        return f'{self.code}:{self.function}'
