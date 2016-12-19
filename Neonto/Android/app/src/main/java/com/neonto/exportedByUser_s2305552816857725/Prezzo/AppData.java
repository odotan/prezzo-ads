package com.neonto.exportedByUser_s2305552816857725.Prezzo;

import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

public class AppData {
    
    public static DataSheet listData1DataSheet;

    public static DataSheet getDataSheetByName(String name) throws Exception {
        switch (name) {
            case "List data 1": return listData1DataSheet;
        }
        throw new Exception(String.format("No data sheet found with name '%s'.", name));
    }

    public static void loadDrawableFromUrl(final Context context, String url, final OnLoadingDrawableFinishedListener listener) {
        if (url.startsWith("asset://")) {
            Resources resources = context.getResources();
            int extLen = 4;  // assume extension is dot + three letters (e.g. ".png")
            String resName = "drawable/"+url.substring("asset://".length(), url.length()-extLen);
            int resId = resources.getIdentifier(resName, null, context.getPackageName());
            listener.onLoadingDrawableFinished(resources.getDrawable(resId), false);
            return;
        }
        else if (url.startsWith("documents://")) {
            String path = context.getExternalFilesDir(null).getPath() + java.io.File.separator + url.substring("documents://".length());
            listener.onLoadingDrawableFinished(Drawable.createFromPath(path), false);
            return;
        }
        else if (url.startsWith("http")) {
            new AsyncTask<String, Object, Object>() {
                @Override
                protected Bitmap doInBackground(String... params) {
                    try {
                        URL url = new URL(params[0]);
                        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                        if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                            Bitmap bitmap = BitmapFactory.decodeStream(conn.getInputStream());
                            final Drawable drawable = new BitmapDrawable(context.getResources(), bitmap);
                            
                            // Run in main thread.
                            new Handler(Looper.getMainLooper()).post(new Runnable() {
                                @Override
                                public void run() {
                                    try {
                                        listener.onLoadingDrawableFinished(drawable, true);
                                    }
                                    catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                            });
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        listener.onLoadingDrawableFinished(null, true);
                    }
                    return null;
                }
            }.execute(url);
            return;
        }
        listener.onLoadingDrawableFinished(null, false);
    }
    
    public interface OnLoadingDrawableFinishedListener {
        void onLoadingDrawableFinished(Drawable d, boolean isAsync);
    }
    
    private static HashMap<String, Typeface> mTypefaces = new HashMap<String, Typeface>();

    public static Typeface getTypeface(String filename, Context context) {
        Typeface typeface = mTypefaces.get(filename);
        if (typeface == null) {
            try {
                typeface = Typeface.createFromAsset(context.getAssets(), "fonts/"+filename);
                mTypefaces.put(filename, typeface);
            }
            catch (Exception e) {
                e.printStackTrace();
            }
        }
        return typeface;
    }

}
