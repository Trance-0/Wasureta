# Generated by Django 4.2 on 2024-11-07 22:36

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('jisho', '0004_remove_memrecord_configuration_hints_is_aigc_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='memrecord',
            name='is_random',
        ),
        migrations.AddField(
            model_name='memrecord',
            name='random_seed',
            field=models.IntegerField(null=True),
        ),
    ]
