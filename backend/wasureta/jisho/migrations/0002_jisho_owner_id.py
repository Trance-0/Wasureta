# Generated by Django 4.2 on 2024-11-07 03:38

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('member', '0001_initial'),
        ('jisho', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='jisho',
            name='owner_id',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, to='member.member'),
            preserve_default=False,
        ),
    ]
