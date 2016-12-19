package com.neonto.exportedByUser_s2305552816857725.Prezzo;

import android.app.Application;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import java.io.File;
import java.io.FileOutputStream;
import java.util.Timer;
import java.util.TimerTask;

public class PrezzoApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        AppData.listData1DataSheet = new ListData1DataSheet(this);
    }

    @Override
    public void onTrimMemory(int level) {
        super.onTrimMemory(level);
        
        if (level >= TRIM_MEMORY_RUNNING_LOW) {
            AppData.listData1DataSheet.releaseCachedData();
        }
    }
}
