/*


This is a base class for data sheets exported from Neonto Studio.
It provides basic functionality for updating data and loading images.

*/



package com.neonto.exportedByUser_s2305552816857725.Prezzo;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.UUID;

public class DataSheet {

    protected Context mContext;
    protected String mSheetId;
    protected UUID mLatestLoadId;  // used to detect whether a load is still valid on completion

    protected ArrayList<HashMap<String, HashMap<String, Object>>> mRows;
    protected HashSet<OnChangeListener> mListeners;
    protected HashMap<String, Drawable> mCachedDrawables;
    protected HashMap<String, ArrayList<AppData.OnLoadingDrawableFinishedListener>> mPendingLoadImageListeners;

    protected String mDataSheetPath;
    protected String mPersistenceName;

    public DataSheet(Context context, String sheetId) {
        mContext = context;
        mSheetId = sheetId;

        mListeners = new HashSet<OnChangeListener>();
        mCachedDrawables = new HashMap<>();
        mPendingLoadImageListeners = new HashMap<>();
    }

    protected void loadRowsWithPersistenceName(String persistenceName) {
        mPersistenceName = persistenceName;

        mDataSheetPath = mContext.getExternalFilesDir(null) + File.separator + mPersistenceName + ".dat";

        try {
            File file = new File(mDataSheetPath);
            FileInputStream fis = new FileInputStream(file);
            ObjectInputStream ois = new ObjectInputStream(fis);
            mRows = (ArrayList<HashMap<String, HashMap<String, Object>>>) ois.readObject();
            ois.close();
            fis.close();
        } catch (Exception e) {
            Log.d("", "no stored values found for data sheet '"+getName()+"', using default values.");
        }

        if (mRows == null) {
            writeDefaultRowData();
        }
    }

    public String getName() {
        return "unknown";
    }

    public String getSheetId() {
        return mSheetId;
    }

    public synchronized UUID getLatestLoadId() {
        return mLatestLoadId;
    }

    public synchronized void setLatestLoadId(UUID uuid) {
        mLatestLoadId = uuid;
    }

    public ArrayList<HashMap<String, HashMap<String, Object>>> getRows() {
        return mRows;
    }

    public void setRows(ArrayList<HashMap<String, HashMap<String, Object>>> rows) {
        mRows = rows;
    }

    public void saveRowWithValues(HashMap<String, Object> values) {
        updateRow(mRows.size(), values);
    }

    public void updateRow(int rowIndex, HashMap<String, Object> values) {
        final boolean newEntry = rowIndex >= mRows.size();

        HashMap<String, HashMap<String, Object>> row = (newEntry) ? new HashMap<String, HashMap<String, Object>>() : mRows.get(rowIndex);
        HashMap<String, Object> col;

        for (HashMap.Entry<String, Object> entry : values.entrySet()) {
            final Object val = entry.getValue();
            if (val instanceof String) {
                col = new HashMap<>(); col.put("type", "text"); col.put("value", val); row.put(entry.getKey(), col);
            }
            else if (val instanceof android.graphics.Bitmap) {
                try {
                    final String fileName = (newEntry) ? determineFilename(entry.getKey()) : stripDocumentsPath((String) mRows.get(rowIndex).get(entry.getKey()).get("value"));

                    File file = new File(mContext.getExternalFilesDir(null), fileName);
                    FileOutputStream fos = new FileOutputStream(file);
                    prepareBitmapForSaving((Bitmap) val).compress(Bitmap.CompressFormat.PNG, 100, fos);
                    fos.close();

                    col = new HashMap<>(); col.put("type", "image"); col.put("value", "documents://"+fileName); row.put(entry.getKey(), col);
                }
                catch (Exception e) {
                    e.printStackTrace();
                }
            }
            else if ((val instanceof JSONArray) || (val instanceof JSONObject)) {
                col = new HashMap<>(); col.put("type", "json"); col.put("value", val); row.put(entry.getKey(), col);
            }
        }

        if (newEntry) {
            mRows.add(0, row);
        }

        save();
    }

    public void deleteRow(int rowIndex) {
        // delete image files.
        HashMap<String, HashMap<String, Object>> row = mRows.get(rowIndex);
        for (String key : row.keySet()) {
            HashMap<String, Object> element = row.get(key);
            if (element.get("type").equals("image")) {
                String value = stripDocumentsPath((String) element.get("value"));
                if (value != null) {
                    File file = new File(mContext.getExternalFilesDir(null), value);
                    if (!file.delete()) {
                        Log.d("DataSheet", String.format("could not delete file '%%s'", value));
                    }
                }
            }
        }

        mRows.remove(rowIndex);

        save();
    }

    public void loadImage(String col, int rowIdx, final AppData.OnLoadingDrawableFinishedListener listener) {
        if (col == null || rowIdx < 0 || rowIdx >= mRows.size()) {
            listener.onLoadingDrawableFinished(null, false);
            return;
        }

        HashMap<String, HashMap<String, Object>> row = mRows.get(rowIdx);
        HashMap<String, Object> cell = row.get(col);
        if (cell == null || !cell.get("type").equals("image")) {
            listener.onLoadingDrawableFinished(null, false);
            return;
        }

        final String url = (String) cell.get("value");

        if (mCachedDrawables.containsKey(url)) {
            listener.onLoadingDrawableFinished(mCachedDrawables.get(url), false);
            return;
        }

        boolean alreadyLoading;

        synchronized (mPendingLoadImageListeners) {
            alreadyLoading = mPendingLoadImageListeners.containsKey(url);
            if ( !alreadyLoading) {
                mPendingLoadImageListeners.put(url, new ArrayList<AppData.OnLoadingDrawableFinishedListener>());
            }
            mPendingLoadImageListeners.get(url).add(listener);
        }

        if (alreadyLoading) {
            return;
        }

        AppData.loadDrawableFromUrl(mContext, url, new AppData.OnLoadingDrawableFinishedListener() {
            @Override
            public void onLoadingDrawableFinished(Drawable d, boolean isAsync) {
                if (url.startsWith("http")) {
                    mCachedDrawables.put(url, d);
                }
                synchronized (mPendingLoadImageListeners) {
                    for (AppData.OnLoadingDrawableFinishedListener l : mPendingLoadImageListeners.get(url)) {
                        l.onLoadingDrawableFinished(d, isAsync);
                    }
                    mPendingLoadImageListeners.remove(url);
                }
            }
        });
    }

    public void invalidateLoadImageListener(AppData.OnLoadingDrawableFinishedListener listener) {
        synchronized (mPendingLoadImageListeners) {
            for (ArrayList<AppData.OnLoadingDrawableFinishedListener> listeners : mPendingLoadImageListeners.values()) {
                listeners.remove(listener);
            }
        }
    }

    public void notifyRowsModified() {
        // Copy listeners in case array gets modified by a listener during notification
        Set<OnChangeListener> listeners = (Set<OnChangeListener>) mListeners.clone();
        for (OnChangeListener listener : listeners) {
            listener.dataSheetUpdated(this);
        }
    }

    public void takeRowsFromJSONArray(JSONArray jsonArr) {
        try {
            ArrayList<HashMap<String, HashMap<String, Object>>> arr = new ArrayList<>();

            for (int i = 0; i < jsonArr.length(); ++i) {
                Object obj = jsonArr.get(i);
                arr.add(convertJSONObjectToDataSheetRow((JSONObject) obj));
            }

            setRows(arr);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public JSONArray JSONArrayFromRows() {
        try {
            JSONArray arr = new JSONArray();

            for (HashMap<String, HashMap<String, Object>> row : getRows()) {
                arr.put(convertDataSheetRowToJSONObject(row));
            }

            return arr;
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        return new JSONArray();
    }

    public void save() {
        try {
            File file = new File(mDataSheetPath);
            FileOutputStream fos = new FileOutputStream(file);
            ObjectOutputStream oos = new ObjectOutputStream(fos);
            oos.writeObject(mRows);
            oos.close();
            fos.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void releaseCachedData() {
        mCachedDrawables = new HashMap<>();
    }


    interface OnChangeListener {
        void dataSheetUpdated(DataSheet sheet);
    }

    public void addListener(OnChangeListener listener) {
        if (listener != null) {
            mListeners.add(listener);
        }
    }

    public void removeListener(OnChangeListener listener) {
        if (listener != null) {
            mListeners.remove(listener);
        }
    }


    static private String stripDocumentsPath(String path) {
        return path.startsWith("documents://") ? path.substring(12) : null;
    }

    private String determineFilename(String imageName) {
        String file = "datasheet_"+mPersistenceName+"++"+imageName+"++";
        String ext = ".png";

        long index = 0;
        for (HashMap<String, HashMap<String, Object>> row : mRows) {
            for (String key : row.keySet()) {
                HashMap<String, Object> element = row.get(key);
                if (element.get("type").equals("image")) {
                    String value = stripDocumentsPath((String) element.get("value"));
                    if (value != null) {
                        if (value.startsWith(file) && value.endsWith(ext)) {
                            index = Math.max(index, Long.parseLong(value.substring(file.length(), value.length()-ext.length())));
                        }
                    }
                }
            }
        }

        return file + (index+1) + ext;
    }

    private Bitmap prepareBitmapForSaving(Bitmap bitmap) {
        final int maxDim = 1200;

        int width = bitmap.getWidth();
        int height = bitmap.getHeight();
        if (width > maxDim || height > maxDim) {
            float sc = Math.min((float)maxDim / width, (float)maxDim / height);
            width = (int)Math.floor(width * sc);
            height = (int)Math.floor(height * sc);
            bitmap = Bitmap.createScaledBitmap(bitmap, width, height, true);
        }

        return bitmap;
    }

    private static HashMap<String, HashMap<String, Object>> convertJSONObjectToDataSheetRow(JSONObject obj) throws Exception {
        if (obj == null)
            return new HashMap<String, HashMap<String, Object>>();

        HashMap<String, HashMap<String, Object>> row = new HashMap<String, HashMap<String, Object>>();
        HashMap<String, Object> col;

        Iterator<String> it = obj.keys();
        while (it.hasNext()) {
            String key = it.next();
            Object val = obj.get(key);

            String colType;
            Object cellValue;

            if (val instanceof JSONArray) {
                colType = "json";
                cellValue = val;
            }
            else if (val instanceof JSONObject) {
                colType = "json";
                cellValue = val;
            }
            else {
                colType = "text";
                cellValue = val;
            }

            col = new HashMap<>(); col.put("type", colType); col.put("value", cellValue); row.put(key, col);
        }

        return row;
    }

    static JSONObject convertDataSheetRowToJSONObject(HashMap<String, HashMap<String, Object>> row) throws Exception {
        if (row == null)
            return new JSONObject();

        JSONObject obj = new JSONObject();

        for (String key : row.keySet()) {
            HashMap<String, Object> val = row.get(key);
            String type = (String) val.get("type");
            Object value = val.get("value");

            Object jsonValue = null;

            if (type.equals("image")) {
                // ignore images when writing to JSON
            }
            else if (type.equals("json")) {
                jsonValue = value;
            }
            else {
                jsonValue = value;
            }

            obj.put(key, jsonValue);
        }

        return obj;
    }

    protected void writeDefaultRowData() {}

}
