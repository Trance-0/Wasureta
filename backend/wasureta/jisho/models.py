from django.db import models

# Create your models here.
import os
from django.db import models
from django.utils.translation import gettext_lazy as _

# from member.models import Member
# Create your models here.

def Jisho_file_path(instance, filename):
    """ 
    file will be uploaded to MEDIA_ROOT/user_<id>/<filename>
    https://docs.djangoproject.com/en/dev/ref/models/fields/#django.db.models.FileField.upload_to
    """
    # return "profile_pic/user_{0}/{1}".format(instance.user.id, filename)
    # we save only one latest image.
    _name, _extension = os.path.splitext(filename)
    return "user_upload/user_{0}/jisho/csv_{1}.csv".format(instance.creator_id.user_id.id,instance.id)


class Jisho(models.Model):
    # This objects contains the username, password, first_name, last_name, and email of member.
    # owner_id = models.ForeignKey(
    #     Member,
    #     on_delete=models.CASCADE,
    #     null=False,
    # )
    
    csv_file = models.FileField(upload_to=Jisho_file_path,null=False)
    title = models.CharField(max_length=100, null=False)
    description = models.CharField(max_length=3000, null=True)
    sharing_id = models.CharField(max_length=36,unique=True,null=True)

    # last_use and date_created automatically created, for these field, create one time value to timezone.now()
    date_created=models.DateTimeField(auto_now_add=True,null=False)

class MemRecord(models.Model):
    """
    This 
    """
    jisho_id = models.ForeignKey(
        Jisho,
        # when record is deleted, whether the creator should also be deleted
        on_delete=models.CASCADE,
        null=False,
    )
    start_time = models.DateTimeField(auto_now_add=True,null=False)
    end_time = models.DateTimeField(null=True)
    # stores how the word list is tested.
    configuration = models.CharField(max_length=256,null=False)
    # stores the current progress, to be implement.
    progress = models.CharField(max_length=36,null=True)
    sharing_id = models.CharField(max_length=36,unique=True,null=False)

class WordPair (models.Model):
    """
    This class stores the meaning and word relationship
    """
    jisho_id = models.ForeignKey(
        Jisho,
        # when record is deleted, whether the creator should also be deleted
        on_delete=models.CASCADE,
        null=False,
    )
    key = models.CharField(max_length=64, null=False)
    value = models.CharField(max_length=64, null=False)
    attributes = models.CharField(max_length=256, null=False)
    
class WordVariant(models.Model):
    """
    This class stores different form of a word, for example te-form for a japanese word
    """
    word_id = models.ForeignKey(
        WordPair,
        # when record is deleted, whether the creator should also be deleted
        on_delete=models.CASCADE,
        null=False,
    )
    value = models.CharField(max_length=64, null=False)
    attributes = models.CharField(max_length=256, null=False)
    
class Hints(models.Model):
    """
    This class stores the hint to memorize the word
    """
    word_id = models.ForeignKey(
        WordPair,
        # when record is deleted, whether the creator should also be deleted
        on_delete=models.CASCADE,
        null=False,
    )
    value = models.CharField(max_length=64, null=False)
    attributes = models.CharField(max_length=256, null=False)
    
  
    
    
     
     
     
     


 

    



